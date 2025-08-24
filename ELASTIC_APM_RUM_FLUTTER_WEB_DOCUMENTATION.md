# Elastic APM RUM and Frontend Observability

## Introduction

This guide shows you how to implement **Elastic APM RUM (Real User Monitoring)** in Flutter Web applications. You'll learn to track user interactions, performance metrics, and business events to gain deep insights into your application's behavior and user experience.

The implementation uses a **Dart-to-JavaScript bridge** that connects Flutter Web widgets to the Elastic APM RUM agent, enabling automatic monitoring of page loads, API calls, user actions, and errors. By adding business context to technical metrics, you can correlate performance issues with business impact.

Whether you're new to observability or an experienced developer, this guide provides step-by-step instructions to transform your Flutter Web app into a fully monitored, observable system.

---

## What is Elastic APM and RUM?

**Elastic APM (Application Performance Monitoring)** is a comprehensive observability solution that helps developers monitor and troubleshoot application performance in real-time. It provides deep insights into application behavior, performance bottlenecks, and user experience.

**RUM (Real User Monitoring)** is a specific component of Elastic APM that focuses on monitoring the actual user experience in web applications. Unlike synthetic monitoring that uses simulated users, RUM captures real user interactions and performance metrics directly from the browser.

### Key Benefits of Elastic APM RUM:

1. **Real User Experience**: Captures actual user interactions, not synthetic tests
2. **Automatic Performance Metrics**: Tracks page load times, resource loading, and user interactions
3. **Error Tracking**: Automatically captures JavaScript errors and exceptions
4. **Distributed Tracing**: Links frontend requests to backend services
5. **Business Context**: Correlates technical metrics with business events
6. **Cross-Browser Support**: Works across all modern browsers

### Automatic Metrics Tracked by APM RUM:

Elastic APM RUM automatically captures these metrics without any additional code:

- **Page Load Performance**: 
  - Time to First Byte (TTFB)
  - DOM Content Loaded
  - Window Load Complete
  - Resource loading times (CSS, JS, images)

- **User Interactions**:
  - Click events
  - Form submissions
  - Navigation events
  - Custom events

- **Error Monitoring**:
  - JavaScript exceptions
  - Network errors
  - Resource loading failures

- **Resource Performance**:
  - API call durations
  - Database query times
  - External service calls

- **User Experience Metrics**:
  - First Input Delay (FID)
  - Largest Contentful Paint (LCP)
  - Cumulative Layout Shift (CLS)

## Transactions & Spans

### Understanding Transactions and Spans

**Transactions** represent the highest-level unit of work in your application. Think of them as the "container" that holds all related operations for a specific user action or business process.

**Spans** are the individual operations within a transaction. They represent specific work units like API calls, database queries, or business logic execution.

### Real-World Examples:

**E-commerce Checkout Process:**
```
Transaction: "User Checkout Process"
├── Span: "Validate User Session"
├── Span: "Load Shopping Cart"
├── Span: "Calculate Total with Tax"
├── Span: "Process Payment"
│   ├── Span: "Validate Credit Card"
│   ├── Span: "Charge Payment Gateway"
│   └── Span: "Update Order Status"
└── Span: "Send Confirmation Email"
```

**User Login Flow:**
```
Transaction: "User Authentication"
├── Span: "Validate Input Fields"
├── Span: "API Call: POST /login"
│   ├── Span: "Network Request"
│   └── Span: "Server Processing"
├── Span: "Store Authentication Token"
└── Span: "Navigate to Dashboard"
```

### Why This Matters:

- **Performance Analysis**: Identify which specific operations are slow
- **Error Isolation**: Pinpoint exactly where failures occur
- **Business Impact**: Correlate technical issues with user actions
- **Distributed Debugging**: Trace requests across multiple services

## Elastic APM RUM with Flutter Web

### Core Idea and Architecture

The architecture follows a **Dart-to-JavaScript bridge pattern** that enables Flutter Web applications to leverage the powerful Elastic APM RUM agent while maintaining clean, type-safe Dart code.

#### Architecture Flow:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Flutter UI    │    │   Observability  │    │  JavaScript     │
│   (Widgets)     │───▶│   Dart Bridge    │───▶│  APM RUM Agent  │
│                 │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
   User Actions           Business Context         Elastic APM
   (Clicks, Forms)        (Transactions, Spans)    (Metrics, Traces)
```

#### Key Components:

1. **JavaScript APM Agent**: Loaded in `index.html`, handles all APM operations
2. **Dart-JS Bridge**: `observability.dart` provides type-safe Dart interface
3. **Business Logic Layer**: Widgets call observability methods for business context
4. **Automatic Interception**: API calls are automatically tracked via interceptors

#### Data Flow:

1. **User Action**: User clicks a button or submits a form
2. **Widget Layer**: Flutter widget calls observability methods
3. **Dart Bridge**: `observability.dart` converts Dart calls to JavaScript
4. **APM Agent**: JavaScript agent creates transactions/spans and sends to Elastic
5. **Elastic Backend**: APM server processes and stores the data
6. **Kibana**: Data is visualized in dashboards and alerts

### Business Context for Traceability

The observability system is designed around **business events** rather than just technical metrics. This means every transaction and span includes business context that helps correlate technical performance with business impact.

#### Business Context Model:

```dart
class BusinessContext {
  final String? requestId;        // Unique request identifier
  final String? traceId;          // Distributed trace ID
  final String? spanId;           // Individual span identifier
  final String? bpId;             // Business Process ID
  final String service;           // Service name
  final EventType type;           // Event classification
  final String entity;            // Business entity (User, Ticket, etc.)
  final String action;            // Business action (LOGIN, CREATE, etc.)
  final ResultType result;        // Success/Failure/Pending
  final String? userId;           // User identifier
  final Map<String, dynamic>? additionalContext; // Custom business data
}
```

#### Business Process Examples:

**Ticket Creation Process:**
- **Entity**: Ticket
- **Action**: CREATE
- **Business Process**: TicketManagement
- **Flow Steps**: CREATION → VALIDATION → SUBMISSION → ASSIGNMENT

**User Authentication:**
- **Entity**: User
- **Action**: LOGIN
- **Business Process**: UserAuthentication
- **Flow Steps**: LOGIN_INITIATED → VALIDATION → AUTHENTICATION → NAVIGATION

### Observability Terminology

The implementation introduces several key concepts and methods:

#### Core Methods:

1. **`initializeJourney()`**: Sets up a new user journey with trace context
2. **`startBusinessTransaction()`**: Begins a business-level transaction
3. **`endTransactionWithResult()`**: Ends transaction with success/failure result
4. **`startBusinessSpan()`**: Creates a span for sub-operations
5. **`trackUserAction()`**: Tracks instantaneous user interactions
6. **`trackUserActionAsTransaction()`**: Tracks standalone user actions as complete transactions
7. **`startApiCall()`**: Automatically tracks API calls

#### Event Types:

```dart
enum EventType {
  BUSINESS_EVENT,    // Core business operations
  EXTERNAL_CALL,     // API calls, external services
  SECURITY_EVENT,    // Authentication, authorization
  USER_ACTION,       // UI interactions
  BATCH_PROCESS,     // Background operations
}
```

#### Result Types:

```dart
enum ResultType {
  SUCCESS,           // Operation completed successfully
  FAILURE,           // Operation failed
  PENDING,           // Operation in progress
}
```

#### Key Concepts:

- **Journey**: A complete user session or business process
- **Transaction**: A business operation that may span multiple API calls
- **Span**: Individual operations within a transaction
- **Labels**: Key-value pairs that add context to transactions/spans
- **Trace Context**: Headers that propagate tracing across services

## Implementation

### Step 1: Adding the Elastic APM RUM Agent

First, download the Elastic APM RUM agent and place it in the `web` folder:

```bash
# Download the latest APM RUM agent
curl -o elastic_a_p_m_r_u_m_flutter_web/web/elastic-apm-rum.umd.min.js \
  https://unpkg.com/@elastic/apm-rum@latest/dist/bundles/elastic-apm-rum.umd.min.js
```

**File Structure:**
```
elastic_a_p_m_r_u_m_flutter_web/
└── web/
    ├── index.html
    ├── elastic-apm-rum.umd.min.js  ← APM RUM Agent
    └── ...
```

### Step 2: Configuring APM in index.html

The APM agent is initialized in the HTML file with specific configuration:

```html
<!-- Elastic APM RUM Agent -->
<script src="elastic-apm-rum.umd.min.js" crossorigin></script>

<script>
  console.log('[RUM] Initializing APM...');

  try {
    window.apm = elasticApm.init({
      serviceName: 'portal-ui-application-rum',    // Service identifier
      serverUrl: 'http://127.0.0.1:8200',          // APM server endpoint
      environment: 'dev',                          // Environment (dev/staging/prod)
      transactionSampleRate: 1.0,                  // Capture 100% of transactions
      centralConfig: false,                        // Disable central config
      logLevel: 'debug',                           // Debug logging for development
      distributedTracingOrigins: [                 // Allowed origins for tracing
        'http://localhost:8080', 
        'http://127.0.0.1:8080'
      ]
    });
    console.log('[RUM] APM initialized successfully:', window.apm);
  } catch (e) {
    console.error('[RUM] APM initialization failed:', e);
  }
</script>
```

**Configuration Explanation:**

- **`serviceName`**: Unique identifier for your application in APM
- **`serverUrl`**: Where your APM server is running
- **`transactionSampleRate`**: 1.0 means capture all transactions (use lower values in production)
- **`distributedTracingOrigins`**: Domains allowed to participate in distributed tracing
- **`logLevel`**: Controls APM agent logging verbosity

### Step 3: Creating the Dart-JavaScript Bridge

The bridge consists of two parts: JavaScript wrapper functions and Dart external declarations.

#### JavaScript Wrapper (`ffRum`):

```javascript
window.ffRum = {
  currentTransaction: null,
  currentSpan: null,
  spanStack: [],

  startTransaction: function (name, type) {
    console.log('[RUM] startTransaction called', { name: name, type: type || 'custom' });
    try {
      if (!apm) {
        console.error('[RUM] APM not initialized');
        return null;
      }

      // End any existing transaction first
      if (window.ffRum.currentTransaction) {
        console.log('[RUM] Ending existing transaction before starting new one');
        window.ffRum.endTransaction();
      }

      const tx = apm.startTransaction(name, type || 'custom');
      console.log('[RUM] startTransaction result:', tx);
      
      if (tx) {
        window.ffRum.currentTransaction = tx;
        window.ffRum.currentSpan = null;
        window.ffRum.spanStack = [];
        console.log('[RUM] Transaction stored:', tx);
      }
      return tx;
    } catch (e) {
      console.error('[RUM] startTransaction error:', e);
      return null;
    }
  },
  // ... other methods
};
```

**Key Features:**
- **Transaction Management**: Automatically ends previous transactions
- **Span Stack**: Maintains hierarchy of spans within transactions
- **Error Handling**: Graceful degradation if APM fails
- **Debug Logging**: Comprehensive logging for troubleshooting

#### Dart External Declarations:

```dart
@JS('window.ffRum')
library;

@JS('startTransaction')
external void _startTransaction(String name, String type);

@JS('endTransaction')
external void _endTransaction();

@JS('startSpan')
external void _startSpan(String name, String type);

@JS('endSpan')
external void _endSpan();

@JS('addLabels')
external void _addLabels(JSAny labels);
```

**Explanation:**
- **`@JS('window.ffRum')`**: Points to the JavaScript wrapper object
- **`external`**: Declares functions implemented in JavaScript
- **`JSAny`**: Dart's type for JavaScript objects
- **`library`**: Groups related external declarations

### Step 4: Core Observability Class

The main observability class provides business-focused methods:

#### Journey Initialization:

```dart
static void initializeJourney({
  String? traceId,
  String? requestId,
  String? userId,
  String? bpId,
}) {
  _currentTraceId = traceId ?? _generateTraceId();
  _currentRequestId = requestId ?? _generateRequestId();
  _currentUserId = userId;
  _currentBpId = bpId;
  _spanCounter = 0;
  _hasActiveTransaction = false;

  debugPrint('RUM Journey initialized: traceId=$_currentTraceId, requestId=$_currentRequestId');
}
```

**What this does:**
- **Generates unique IDs**: Creates trace and request identifiers for distributed tracing
- **Sets context**: Establishes user and business process context
- **Resets state**: Clears any previous transaction state
- **Logs activity**: Provides debug information for troubleshooting

#### Business Transaction Management:

```dart
static void startBusinessTransaction({
  required String name,
  required String service,
  required String entity,
  required String action,
  EventType type = EventType.BUSINESS_EVENT,
  String? userId,
  Map<String, dynamic>? additionalLabels,
}) {
  if (!kIsWeb) return;  // Only run in web environment
  if (_hasActiveTransaction) {
    debugPrint('RUM Warning: Transaction already active, ending previous one');
    _endTransaction();
  }

  try {
    // Start the transaction
    _startTransaction(name, type.name);
    _hasActiveTransaction = true;

    // Create business context
    final context = BusinessContext(
      requestId: _currentRequestId,
      traceId: _currentTraceId,
      spanId: _generateSpanId(),
      bpId: _currentBpId,
      service: service,
      type: type,
      entity: entity,
      action: action,
      result: ResultType.PENDING,
      userId: userId ?? _currentUserId,
      additionalContext: additionalLabels,
    );

    // Add all context as labels
    _addLabelsInternal(context.toMap());

    debugPrint('RUM Business Transaction started: ${context.toMap()}');
  } catch (e) {
    debugPrint('RUM startBusinessTransaction failed: $e');
  }
}
```

**Key Features:**
- **Web-only execution**: `if (!kIsWeb) return` ensures it only runs in web builds
- **Transaction cleanup**: Automatically ends previous transactions
- **Business context**: Creates rich context with entity, action, and user info
- **Label propagation**: Converts business context to APM labels
- **Error handling**: Graceful error handling with debug logging

#### User Action Tracking:

```dart
static void trackUserAction({
  required String action,
  required String entity,
  Map<String, dynamic>? additionalLabels,
}) {
  if (!kIsWeb) return;

  try {
    final startTime = DateTime.now().millisecondsSinceEpoch;

    // Start the span
    _startSpan('user_action_$action', EventType.USER_ACTION.name);

    // Add labels
    final labels = {
      'entity': entity,
      'action': action,
      'type': EventType.USER_ACTION.name,
      'startTime': startTime,
      'duration': 0, // User actions should be instantaneous
      if (additionalLabels != null) ...additionalLabels,
    };
    _addLabelsInternal(labels);

    // CRITICAL: End the span immediately!
    // User actions are instantaneous events
    _endSpan();

    final endTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint('RUM User Action tracked and ended: $action (duration: ${endTime - startTime}ms)');
  } catch (e) {
    debugPrint('RUM trackUserAction failed: $e');
    // Try to end span even if error occurred
    try {
      _endSpan();
    } catch (_) {}
  }
}
```

**Important Design Decision:**
- **Immediate span ending**: User actions are instantaneous, so spans end immediately
- **Duration tracking**: Measures actual time taken for the action
- **Error recovery**: Ensures spans are ended even if errors occur

#### Standalone User Action Transactions:

```dart
static void trackUserActionAsTransaction({
  required String actionName,
  Map<String, dynamic>? additionalLabels,
}) {
  if (!kIsWeb) return;

  try {
    final startTime = DateTime.now().millisecondsSinceEpoch;

    // Start the transaction
    _startTransaction(actionName, 'user-action');

    // Add labels
    final labels = {
      'action': actionName,
      'type': 'USER_ACTION',
      'startTime': startTime,
      'duration': 0, // User actions should be instantaneous
      if (additionalLabels != null) ...additionalLabels,
    };
    _addLabelsInternal(labels);

    // Add a small delay before ending to ensure transaction is captured
    Future.delayed(Duration(milliseconds: 10), () {
      try {
        _endTransaction();
        final endTime = DateTime.now().millisecondsSinceEpoch;
        debugPrint(
            'RUM User Action Transaction tracked and ended: $actionName (duration: ${endTime - startTime}ms)');
      } catch (e) {
        debugPrint('RUM trackUserActionAsTransaction end failed: $e');
      }
    });
  } catch (e) {
    debugPrint('RUM trackUserActionAsTransaction failed: $e');
    // Try to end transaction even if error occurred
    try {
      _endTransaction();
    } catch (_) {}
  }
}
```

**When to Use `trackUserActionAsTransaction`:**

- **Page Views**: When users navigate to different pages
- **Standalone Actions**: User interactions that aren't part of larger business processes
- **Quick Events**: Instantaneous actions that don't require complex tracking
- **Analytics Events**: Simple user behavior tracking for analytics

**Key Differences from `trackUserAction`:**

| Feature | `trackUserAction()` | `trackUserActionAsTransaction()` |
|---------|-------------------|----------------------------------|
| **Scope** | Span within existing transaction | Complete standalone transaction |
| **Duration** | Instantaneous (0ms) | Short duration (10ms delay) |
| **Context** | Part of larger business process | Independent event |
| **Use Case** | Button clicks in forms | Page views, navigation events |

**Example Usage:**

```dart
// Page load tracking - standalone transaction
await actions.trackUserActionAsTransaction(
  'login_page_view',
  <String, String?>{
    'page': 'login',
    'businessProcess': 'UserAuthentication',
  },
);

// Dashboard view - standalone transaction
await actions.trackUserActionAsTransaction(
  'dashboard_view',
  <String, String?>{
    'userId': FFAppState().loginResponse.username,
  },
);
```

### Step 5: API Call Interception

The observability interceptor automatically tracks all API calls:

```dart
class ObservabilityInterceptor extends FFApiInterceptor {
  int? _startTime;

  @override
  Future<ApiCallOptions> onRequest({
    required ApiCallOptions options,
  }) async {
    _startTime = DateTime.now().millisecondsSinceEpoch;

    // Extract endpoint from URL path
    final endpoint = options.apiUrl;

    // Start the API call span with metadata from the request
    Observability.startApiCall(
      endpoint: endpoint,
      method: options.callType.name,
      operationName: '${options.callType.name} $endpoint',
      additionalLabels: {
        ...metadata,
        'startTime': _startTime,
      },
    );

    // Add trace context headers for distributed tracing
    final traceHeaders = Observability.getTraceContext();
    final updatedHeaders = Map<String, String>.from(options.headers);
    updatedHeaders.addAll(traceHeaders);

    return options.copyWith(headers: updatedHeaders);
  }
}
```

**What this accomplishes:**
- **Automatic tracking**: Every API call is automatically instrumented
- **Distributed tracing**: Adds trace headers to propagate context
- **Metadata extraction**: Captures business context from request metadata
- **Timing measurement**: Tracks request duration for performance analysis

### Step 6: Widget Integration Examples

#### Login Screen Integration:

```dart
// On page load - initialize journey
SchedulerBinding.instance.addPostFrameCallback((_) async {
  await actions.initializeJourney(
    'BP_USER_AUTH_${getCurrentTimestamp.millisecondsSinceEpoch.toString()}',
  );
  await actions.trackUserActionAsTransaction(
    'login_page_view',
    <String, String?>{
      'page': 'login',
      'businessProcess': 'UserAuthentication',
    },
  );
});

// On login button click
FFButtonWidget(
  onPressed: () async {
    // Start business transaction for entire login process
    unawaited(() async {
      await actions.startBusinessTransaction(
        'user_login_process',
        'portal-ui-application',
        'User',
        'LOGIN',
        EventType.BUSINESS_EVENT,
        <String, String?>{
          'eventSequence': '1',
          'businessProcess': 'UserAuthentication',
          'flowStep': 'LOGIN_INITIATED',
        },
      );
    }());

    // Track user action
    unawaited(() async {
      await actions.trackUserAction(
        'CLICK_LOGIN',
        'LoginButton',
        <String, String?>{
          'username': 'demo',
          'eventSequence': '2',
        },
      );
    }());

    // Make API call (automatically tracked by interceptor)
    _model.loginApiResponse = await FlutterElasticRUMDemoAPIGroup.authenticateUserCall.call();

    // End transaction with result
    if (_model.loginApiResponse?.succeeded ?? true) {
      await actions.endTransactionWithResult(
        ResultType.SUCCESS,
        <String, String?>{
          'flowStep': 'LOGIN_COMPLETED',
          'nextAction': 'NAVIGATE_TO_DASHBOARD',
          'eventSequence': '4',
        },
      );
    }
  },
)
```

**Business Flow Captured:**
1. **Journey Initialization**: Sets up user authentication business process
2. **Page View Tracking**: Records user landing on login page
3. **Business Transaction**: Starts transaction for entire login process
4. **User Action**: Tracks button click with business context
5. **API Call**: Automatically tracked by interceptor
6. **Result Recording**: Ends transaction with success/failure result

#### Dashboard Screen Integration:

```dart
// On page load
SchedulerBinding.instance.addPostFrameCallback((_) async {
  await actions.trackUserActionAsTransaction(
    'dashboard_view',
    <String, String?>{
      'userId': FFAppState().loginResponse.username,
    },
  );
});

// On logout button click
FlutterFlowIconButton(
  onPressed: () async {
    await actions.startBusinessTransaction(
      'user_logout',
      'portal-ui-application',
      'User',
      'LOGOUT',
      EventType.BUSINESS_EVENT,
      null,
    );
    await actions.trackUserAction(
      'CLICK_LOGOUT',
      'LogoutButton',
      <String, String?>{
        'source': 'dashboard',
      },
    );
    await actions.endTransactionWithResult(
      ResultType.SUCCESS,
      <String, String?>{
        'logoutReason': 'USER_INITIATED',
      },
    );
    // Navigate to login
    context.goNamed(LoginScreenWidget.routeName);
  },
)
```

## Tracking a Business Journey: Ticket Creation

The ticket creation process demonstrates the complete observability lifecycle across multiple layers:

### Business Process Flow:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   User Action   │    │  Business Logic  │    │   API Layer     │
│                 │    │                  │    │                 │
│ 1. Page Load    │───▶│ 2. Initialize    │───▶│ 3. Form Submit  │
│    (Journey)    │    │    Journey       │    │    (API Call)   │
│                 │    │                  │    │                 │
│ 4. Form Fill    │───▶│ 5. Track User    │───▶│ 6. Backend      │
│    (Actions)    │    │    Actions       │    │    Processing   │
│                 │    │                  │    │                 │
│ 7. Submit       │───▶│ 8. Business      │───▶│ 9. Response     │
│    Button       │    │    Transaction   │    │    Handling     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Complete Implementation Flow:

#### 1. Journey Initialization (Page Load):

```dart
// Ticket creation screen initialization
SchedulerBinding.instance.addPostFrameCallback((_) async {
  await actions.initializeJourney(
    'BP_TICKET_CREATE_${getCurrentTimestamp.millisecondsSinceEpoch.toString()}',
  );
  await actions.trackUserActionAsTransaction(
    'ticket_creation_page_view',
    <String, String?>{
      'page': 'ticket_creation',
      'businessProcess': 'TicketManagement',
    },
  );
});
```

**What happens:**
- **Business Process ID**: `BP_TICKET_CREATE_1234567890` is generated
- **Trace Context**: New trace ID and request ID are created
- **Page View**: User landing on ticket creation page is tracked
- **Business Context**: Links to TicketManagement business process

#### 2. User Interaction Tracking:

```dart
// Form submission button
FFButtonWidget(
  onPressed: () async {
    // Start business transaction for ticket creation
    await actions.startBusinessTransaction(
      'ticket_creation_process',
      'portal-ui-application',
      'Ticket',
      'CREATE',
      EventType.BUSINESS_EVENT,
      <String, String?>{
        'businessProcess': 'TicketManagement',
        'flowStep': 'CREATION',
        'priority': _model.dropDownValue,
      },
    );
    
    // Add form submission labels
    await actions.addLabels(
      <String, String?>{
        'formSubmission': 'true',
        'eventSequence': '1',
      },
    );
    
    // API call (automatically tracked by interceptor)
    _model.ticketCreationApiResponse = await FlutterElasticRUMDemoAPIGroup.createANewTicketCall.call();
  },
)
```

**Business Context Captured:**
- **Entity**: Ticket
- **Action**: CREATE
- **Business Process**: TicketManagement
- **Flow Step**: CREATION
- **Priority**: User-selected priority level
- **Form Data**: Submission context

#### 3. API Call Interception:

```dart
// In ObservabilityInterceptor.onRequest()
Observability.startApiCall(
  endpoint: endpoint,
  method: options.callType.name,
  operationName: '${options.callType.name} $endpoint',
  additionalLabels: {
    ...metadata,
    'startTime': _startTime,
  },
);

// Add trace context headers
final traceHeaders = Observability.getTraceContext();
final updatedHeaders = Map<String, String>.from(options.headers);
updatedHeaders.addAll(traceHeaders);
```

**Distributed Tracing:**
- **Trace Headers**: `X-Trace-Id`, `X-Request-Id`, `X-BP-Id` added to request
- **Span Creation**: New span created for API call
- **Metadata**: Business context propagated to backend

#### 4. Backend Processing (Node.js):

```javascript
app.post('/tickets/create', async (req, res) => {
    // Extract trace context from headers
    const traceId = req.headers['x-trace-id'];
    const requestId = req.headers['x-request-id'];
    const bpId = req.headers['x-bp-id'];
    
    // Log business event
    req.logger.infoBusinessEvent(
        'Ticket',
        'CREATE',
        'PENDING',
        { priority: req.body.priority }
    );
    
    // Process ticket creation
    const ticketId = await createTicket(req.body);
    
    // Log success
    req.logger.infoBusinessEvent(
        'Ticket',
        'CREATE',
        'SUCCESS',
        { ticketId }
    );
    
    res.json({
        ticketId,
        traceId,
        observabilityMetadata: {
            action: 'CREATE_TICKET',
            result: 'SUCCESS',
            ticketId
        }
    });
});
```

**Backend Integration:**
- **Trace Context**: Headers are extracted and used for correlation
- **Business Events**: Backend logs business events with same entity/action
- **Metadata Response**: Observability metadata returned to frontend

#### 5. Response Handling:

```dart
// In ObservabilityInterceptor.onResponse()
if (response.statusCode >= 200 && response.statusCode < 300) {
  final additionalLabels = <String, dynamic>{
    'result': 'SUCCESS',
    'statusCode': response.statusCode,
    'duration': duration,
  };

  // Extract observability metadata from response
  try {
    final responseData = response.jsonBody as Map<String, dynamic>;
    if (responseData.containsKey('observabilityMetadata')) {
      final observabilityMetadata = responseData['observabilityMetadata'] as Map<String, dynamic>?;
      if (observabilityMetadata != null) {
        additionalLabels.addAll(observabilityMetadata);
      }
    }
  } catch (e) {
    // Ignore parsing errors for metadata extraction
  }

  Observability.addLabels(additionalLabels);
}
```

**Response Processing:**
- **Success Labels**: Result, status code, and duration added
- **Metadata Extraction**: Backend observability metadata merged
- **Span Ending**: API call span is automatically ended

#### 6. Transaction Completion:

```dart
if ((_model.ticketCreationApiResponse?.succeeded ?? true)) {
  await actions.endTransactionWithResult(
    ResultType.SUCCESS,
    <String, String?>{
      'ticketNumber': _model.ticketResponse?.ticketId,
      'flowStep': 'CREATION_COMPLETED',
    },
  );
} else {
  await actions.endTransactionWithResult(
    ResultType.FAILURE,
    <String, String?>{
      'error': 'Some error from backend on Ticket Creation',
      'flowStep': 'CREATION_FAILED',
    },
  );
}
```

**Final Business Context:**
- **Success Path**: Ticket ID and completion status recorded
- **Failure Path**: Error details and failure status recorded
- **Transaction End**: Business transaction completed with final result

### Complete Trace Visualization:

In Elastic APM, this creates a trace that looks like:

```
Transaction: "ticket_creation_process" (TicketManagement)
├── Span: "ticket_creation_page_view" (USER_ACTION)
├── Span: "POST /tickets/create" (EXTERNAL_CALL)
│   ├── Backend Transaction: "CREATE_TICKET" (TicketManagement)
│   └── Duration: 450ms
├── Labels:
│   ├── businessProcess: "TicketManagement"
│   ├── entity: "Ticket"
│   ├── action: "CREATE"
│   ├── priority: "HIGH"
│   ├── ticketNumber: "TKT-2024-001"
│   └── result: "SUCCESS"
└── Duration: 520ms
```

**Business Value:**
- **Performance Insights**: Know exactly how long ticket creation takes
- **Error Tracking**: Identify where failures occur in the process
- **User Experience**: Understand user interaction patterns
- **Business Correlation**: Link technical performance to business outcomes

## Conclusion

This implementation demonstrates a comprehensive approach to frontend observability that goes beyond simple performance monitoring. By combining Elastic APM RUM's automatic metrics with custom business context, we create a powerful observability system that provides:

### Key Achievements:

1. **Automatic Instrumentation**: Leverages APM RUM's built-in capabilities for performance metrics, error tracking, and user interaction monitoring

2. **Business Context Integration**: Every technical metric is enriched with business context (entity, action, process, user)

3. **Distributed Tracing**: Seamless correlation between frontend and backend operations

4. **Developer-Friendly**: Clean Dart API that abstracts JavaScript complexity

5. **Production Ready**: Comprehensive error handling, logging, and configuration options

### Business Benefits:

- **Faster Issue Resolution**: Pinpoint exactly where and why problems occur
- **Performance Optimization**: Identify bottlenecks in user journeys
- **User Experience Insights**: Understand how users interact with your application
- **Business Impact Analysis**: Correlate technical issues with business outcomes
- **Proactive Monitoring**: Detect issues before they affect users

### Technical Benefits:

- **Type Safety**: Dart's type system ensures correct usage
- **Maintainability**: Clean separation between business logic and observability
- **Scalability**: Architecture supports complex multi-step business processes
- **Integration**: Works seamlessly with existing Flutter Web applications
- **Extensibility**: Easy to add new business contexts and tracking points

This observability implementation transforms your Flutter Web application from a black box into a fully transparent, monitored system that provides deep insights into both technical performance and business value delivery.
