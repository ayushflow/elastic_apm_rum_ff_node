// server.js
// IMPORTANT: Require APM BEFORE other imports so it can instrument http/express.
const apm = require('./apm');

const express = require('express');
const cors = require('cors');
const os = require('os');

const app = express();

// Allow all origins
app.use(cors({
    origin: '*',
    // Expose custom headers to the frontend
    exposedHeaders: ['X-Trace-Id', 'X-Request-Id', 'X-Span-Id', 'X-Debug-TraceId']
}));

app.use(express.json());

// Utility: simulate processing delays to make timings visible in APM.
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

// Contextual Logger class matching Portal spec
class ContextualLogger {
    constructor(context) {
        this.context = context;
    }
    
    log(level, message, additionalData = {}) {
        const logEntry = {
            '@timestamp': new Date().toISOString(),
            '@version': '1',
            message,
            level,
            level_value: level === 'ERROR' ? 40000 : level === 'WARN' ? 30000 : 20000,
            logger_name: 'portal-api',
            thread_name: `pid-${process.pid}`,
            HOSTNAME: this.context.hostname,
            ...this.context,
            ...additionalData,
            app: process.env.APP_NAME || 'portal-api',
            env: process.env.NODE_ENV || 'dev'
        };
        
        // Log as JSON (can be picked up by Logstash/Filebeat)
        console.log(JSON.stringify(logEntry));
        
        return logEntry;
    }
    
    infoBusinessEvent(entity, action, result, additionalData = {}) {
        return this.log('INFO', `Business Event: ${entity} ${action}`, {
            type: 'BUSINESS_EVENT',
            entity,
            action,
            result,
            ...additionalData
        });
    }
    
    errorExternalCall(entity, action, error, additionalData = {}) {
        return this.log('ERROR', `External Call Failed: ${entity} ${action}`, {
            type: 'EXTERNAL_CALL',
            entity,
            action,
            result: 'FAILURE',
            error: error.message || error,
            ...additionalData
        });
    }
    
    warnSecurityEvent(entity, action, result, additionalData = {}) {
        return this.log('WARN', `Security Event: ${entity} ${action}`, {
            type: 'SECURITY_EVENT',
            entity,
            action,
            result,
            ...additionalData
        });
    }
}

// Middleware to extract and propagate trace context
const contextualLoggingMiddleware = (req, res, next) => {
    // Get APM transaction if available
    const apmTx = apm.currentTransaction;
    
    // Extract trace context from headers (sent by Flutter frontend)
    // Use APM's traceId if available, otherwise use header or generate new
    const traceId = apmTx?.traceId || req.headers['x-trace-id'] || `trace-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    const requestId = req.headers['x-request-id'] || `req-${Date.now()}`;
    const bpId = req.headers['x-bp-id'];
    const userId = req.headers['x-user-id'];
    
    // Generate span ID for this service
    const spanId = apmTx?.id || `${traceId}-node-${Date.now()}`;
    
    // Store in request context
    req.context = {
        traceId,
        requestId,
        spanId,
        bpId,
        userId,
        service: process.env.ELASTIC_APM_SERVICE_NAME || 'portal-api',
        hostname: os.hostname(),
    };
    
    // Create logger for this request
    req.logger = new ContextualLogger(req.context);
    
    // Add labels to APM transaction
    if (apmTx) {
        apmTx.addLabels({
            requestId,
            bpId: bpId || '',
            userId: userId || '',
            service: req.context.service,
        });
    }
    
    // Set response headers for trace continuity
    res.setHeader('X-Trace-Id', traceId);
    res.setHeader('X-Request-Id', requestId);
    res.setHeader('X-Span-Id', spanId);
    
    // Log incoming request
    req.logger.log('INFO', `Incoming request: ${req.method} ${req.path}`, {
        type: 'EXTERNAL_CALL',
        entity: req.path,
        action: req.method,
        result: 'PENDING',
        userAgent: req.headers['user-agent'],
    });
    
    // Track response
    const originalSend = res.send;
    const startTime = Date.now();
    
    res.send = function(data) {
        const duration = Date.now() - startTime;
        const result = res.statusCode < 400 ? 'SUCCESS' : 'FAILURE';
        
        // Log request completion
        req.logger.log('INFO', `Request completed: ${req.method} ${req.path}`, {
            type: 'EXTERNAL_CALL',
            entity: req.path,
            action: req.method,
            result,
            statusCode: res.statusCode,
            duration,
        });
        
        originalSend.call(this, data);
    };
    
    next();
};

// Apply middleware
app.use(contextualLoggingMiddleware);

app.get('/health', (req, res) => {
    res.json({ status: 'ok' });
});

app.post('/login', async (req, res) => {
    const { username, password } = req.body || {};
    
    // Log business event - login attempt
    req.logger.infoBusinessEvent(
        'User',
        'LOGIN',
        'PENDING',
        { username }
    );
    
    // Simulate authentication work
    await sleep(350);
    
    // Validation
    if (!username || !password) {
        // Log security event for invalid login
        req.logger.warnSecurityEvent(
            'User',
            'LOGIN_FAILED',
            'FAILURE',
            { reason: 'Missing credentials', username: username || 'unknown' }
        );
        
        // Add APM labels
        const tx = apm.currentTransaction;
        tx?.addLabels({ result: 'FAILURE', stage: 'validation' });
        
        return res.status(400).json({ 
            error: 'Missing username or password',
            traceId: req.context.traceId,
            spanId: req.context.spanId,
            observabilityMetadata: {
                action: 'LOGIN',
                result: 'FAILURE',
                reason: 'Missing credentials'
            }
        });
    }
    
    // Simulate successful authentication
    // In real app, verify against database
    const token = `token-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    
    // Log successful login
    req.logger.infoBusinessEvent(
        'User',
        'LOGIN',
        'SUCCESS',
        { username, tokenIssued: true }
    );
    
    // Add APM labels
    const tx = apm.currentTransaction;
    tx?.addLabels({ 
        result: 'SUCCESS', 
        stage: 'login',
        username 
    });
    
    res.json({
        ok: true,
        token,
        username,
        traceId: req.context.traceId,
        spanId: req.context.spanId,
        observabilityMetadata: {
            username,
            action: 'LOGIN',
            result: 'SUCCESS'
        }
    });
});

app.get('/dashboard', async (req, res) => {
    // Log dashboard access
    req.logger.infoBusinessEvent(
        'Dashboard',
        'ACCESS',
        'PENDING',
        { userId: req.context.userId }
    );
    
    // Simulate data fetch and rendering work
    await sleep(500 + Math.floor(Math.random() * 300));
    
    // Log successful dashboard load
    req.logger.infoBusinessEvent(
        'Dashboard',
        'LOAD',
        'SUCCESS',
        { dataPoints: 10 }
    );
    
    const tx = apm.currentTransaction;
    tx?.addLabels({ result: 'SUCCESS', stage: 'dashboard' });
    
    res.json({
        welcome: 'Welcome to your dashboard!',
        timestamp: new Date().toISOString(),
        metrics: {
            totalTickets: 42,
            openTickets: 7,
            avgResponseTime: '2.5 hours'
        },
        traceId: req.context.traceId,
        spanId: req.context.spanId,
        observabilityMetadata: {
            action: 'LOAD_DASHBOARD',
            result: 'SUCCESS',
            dataPoints: 10,
            totalTickets: 42,
            openTickets: 7
        }
    });
});

app.post('/tickets/create', async (req, res) => {
    const { title, description, priority } = req.body || {};
    
    // Log ticket creation attempt
    req.logger.infoBusinessEvent(
        'Ticket',
        'CREATE',
        'PENDING',
        { priority, userId: req.context.userId }
    );
    
    // Simulate ticket creation
    await sleep(800);
    
    if (!title || !description) {
        req.logger.infoBusinessEvent(
            'Ticket',
            'CREATE',
            'FAILURE',
            { reason: 'Missing required fields' }
        );
        
        return res.status(400).json({ 
            error: 'Title and description are required',
            traceId: req.context.traceId,
            observabilityMetadata: {
                action: 'CREATE_TICKET',
                result: 'FAILURE',
                reason: 'Missing required fields'
            }
        });
    }
    
    // Generate ticket ID
    const ticketId = `TKT-${Date.now().toString().substr(-6)}`;
    
    // Log successful creation
    req.logger.infoBusinessEvent(
        'Ticket',
        'CREATE',
        'SUCCESS',
        { ticketId, priority, title }
    );
    
    // Simulate batch assignment process (async)
    setTimeout(() => {
        const assignedOfficer = `OFF-${Math.floor(Math.random() * 100)}`;
        
        // Create a new context for the batch process
        const batchContext = {
            ...req.context,
            spanId: `${req.context.traceId}-batch-${Date.now()}`,
        };
        
        const batchLogger = new ContextualLogger(batchContext);
        
        batchLogger.infoBusinessEvent(
            'Ticket',
            'ASSIGN_OFFICER',
            'SUCCESS',
            { 
                ticketId, 
                assignedOfficer,
                type: 'BATCH_PROCESS',
                processType: 'AUTO_ASSIGNMENT'
            }
        );
    }, 2000);
    
    const tx = apm.currentTransaction;
    tx?.addLabels({ 
        result: 'SUCCESS', 
        ticketId,
        priority 
    });
    
    res.status(201).json({
        ticketId,
        status: 'created',
        priority,
        title,
        traceId: req.context.traceId,
        spanId: req.context.spanId,
        observabilityMetadata: {
            ticketId,
            action: 'CREATE_TICKET',
            result: 'SUCCESS',
            priority
        }
    });
});

app.get('/search', async (req, res) => {
    const query = req.query.q || '';
    
    // Log search request
    req.logger.infoBusinessEvent(
        'KnowledgeBase',
        'SEARCH',
        'PENDING',
        { query, resultCount: 0 }
    );
    
    // Simulate search
    await sleep(300);
    
    const results = [
        'How to reset password',
        'Network connectivity troubleshooting',
        'Software installation guide',
        'VPN configuration steps'
    ].filter(item => 
        query.length > 0 && item.toLowerCase().includes(query.toLowerCase())
    );
    
    // Log search completion
    req.logger.infoBusinessEvent(
        'KnowledgeBase',
        'SEARCH',
        'SUCCESS',
        { query, resultCount: results.length }
    );
    
    res.json({
        query,
        results,
        count: results.length,
        traceId: req.context.traceId,
        observabilityMetadata: {
            action: 'SEARCH_KNOWLEDGE_BASE',
            result: 'SUCCESS',
            query,
            resultCount: results.length
        }
    });
});

// Error handler
app.use((err, req, res, next) => {
    if (req.logger) {
        req.logger.log('ERROR', `Unhandled error: ${err.message}`, {
            type: 'SYSTEM_ERROR',
            entity: 'System',
            action: 'ERROR_HANDLER',
            result: 'FAILURE',
            error: err.message,
            stack: err.stack
        });
    }
    
    res.status(500).json({ 
        error: 'Internal server error',
        traceId: req.context?.traceId,
        observabilityMetadata: {
            action: 'ERROR_HANDLER',
            result: 'FAILURE',
            error: err.message
        }
    });
});

// Start server
const port = process.env.PORT || 8080;
app.listen(port, () => {
    console.log(`Node API listening on http://localhost:${port}`);
    console.log(`APM service: ${process.env.ELASTIC_APM_SERVICE_NAME || 'portal-api'} → ${process.env.ELASTIC_APM_SERVER_URL || 'http://localhost:8200'}`);
    console.log(`Environment: ${process.env.NODE_ENV || 'dev'}`);
    console.log(`Hostname: ${os.hostname()}`);
});
