// apm.js
// Start Elastic APM as early as possible.
const apm = require('elastic-apm-node').start({
    serviceName: process.env.ELASTIC_APM_SERVICE_NAME || 'portal-api',
    serverUrl: process.env.ELASTIC_APM_SERVER_URL || 'http://localhost:8200',
    environment: process.env.NODE_ENV || 'dev',
    // If your APM Server requires a secret token, set ELASTIC_APM_SECRET_TOKEN in env.
    secretToken: process.env.ELASTIC_APM_SECRET_TOKEN,
    // Helpful during development:
    captureBody: 'all',
    centralConfig: false,
    // transactionSampleRate: 1.0,
});

module.exports = apm;
