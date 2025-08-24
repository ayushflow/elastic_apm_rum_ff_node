# Elastic APM RUM Flutter Web Demo

This project demonstrates a complete observability setup using **Elastic APM (Application Performance Monitoring)** with **Real User Monitoring (RUM)** for a Flutter Web application. It includes distributed tracing between the frontend and backend, providing end-to-end visibility into user interactions.

## 🏗️ Project Architecture

The project consists of three main components:

### 1. **Flutter Web Application** (`elastic_a_p_m_r_u_m_flutter_web/`)
- A Flutter web app with Elastic APM RUM integration
- Tracks user interactions, page loads, and API calls
- Sends performance data to the APM Server
- Includes custom business transaction tracking

### 2. **Node.js Backend API** (`portal-api/`)
- Express.js server with Elastic APM Node.js agent
- Handles authentication, dashboard data, ticket creation, and search
- Correlates with frontend traces using distributed tracing
- Implements structured logging with trace context

### 3. **Elastic Stack Infrastructure** (Docker Compose)
- **Elasticsearch**: Data storage and indexing
- **Kibana**: Visualization and APM UI
- **APM Server**: Receives and processes APM data

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 18+ 
- Flutter SDK 3.0+
- Git

### 1. Start the Elastic Stack

```bash
# Set environment variables
export ELASTIC_PASSWORD=your_secure_password

# Start Elasticsearch, Kibana, and APM Server
docker-compose up -d
```

Wait for Elasticsearch to be healthy (check with `docker-compose ps`).

### 2. Generate Kibana Service Account Token

After Elasticsearch is running, generate a service account token for Kibana:

```bash
# Create the service account token
curl -X POST "localhost:9200/_security/service/elastic/kibana/credential/token/kibana-token" \
  -H "Content-Type: application/json" \
  -u elastic:${ELASTIC_PASSWORD} \
  -d '{"name": "kibana-token"}'

# Extract the token from the response and set it as environment variable
export KIBANA_SA_TOKEN=$(curl -X POST "localhost:9200/_security/service/elastic/kibana/credential/token/kibana-token" \
  -H "Content-Type: application/json" \
  -u elastic:${ELASTIC_PASSWORD} \
  -d '{"name": "kibana-token"}' | jq -r '.token.value')

echo "Kibana token: $KIBANA_SA_TOKEN"
```

**Note**: You'll need `jq` installed to parse the JSON response. If you don't have it, you can manually copy the token value from the curl response.

Wait for all services to be healthy (check with `docker-compose ps`).

### 3. Start the Backend API

```bash
cd portal-api

# Install dependencies
npm install

# Start the server
npm start
```

The API will be available at `http://localhost:8080`.

### 4. Run the Flutter Web App

```bash
cd elastic_a_p_m_r_u_m_flutter_web

# Get dependencies
flutter pub get

# Run the web app
flutter run -d chrome --web-port=3000
```

The Flutter app will be available at `http://localhost:3000`.

## 📊 Accessing Observability Data

### Kibana APM UI
- **URL**: http://localhost:5601
- **Username**: `elastic`
- **Password**: Your `ELASTIC_PASSWORD`

Navigate to **Observability > APM** to see:
- Service maps showing frontend-backend communication
- Transaction traces with detailed timing
- Error tracking and performance metrics
- Real-time user experience data

### API Endpoints

The backend provides these endpoints with full APM instrumentation:

- `POST /login` - User authentication
- `GET /dashboard` - Dashboard data retrieval
- `POST /tickets/create` - Ticket creation
- `GET /search` - Knowledge base search
- `GET /health` - Health check

## 🔍 Key Features

### Distributed Tracing
- **Frontend**: Elastic APM RUM agent tracks user interactions
- **Backend**: Node.js APM agent correlates with frontend traces
- **Trace Continuity**: Headers propagate trace context across services

### Business Transaction Tracking
- Custom transaction types for business operations
- Structured logging with trace correlation
- Performance monitoring for critical user journeys

### Real User Monitoring
- Page load performance metrics
- User interaction tracking
- Error monitoring and reporting
- Geographic and device analytics

## 🛠️ Configuration

### APM Server Configuration (`apm-server.yml`)
```yaml
apm-server:
  host: "0.0.0.0:8200"
  rum:
    enabled: true
    allow_origins: ["*"]
    allow_headers: ["*"]
```

### Flutter Web RUM Integration (`web/index.html`)
```javascript
window.apm = elasticApm.init({
  serviceName: 'portal-ui-application-rum',
  serverUrl: 'http://127.0.0.1:8200',
  environment: 'dev',
  transactionSampleRate: 1.0,
  distributedTracingOrigins: ['http://localhost:8080']
});
```

### Node.js APM Configuration (`portal-api/apm.js`)
```javascript
const apm = require('elastic-apm-node').start({
  serviceName: 'portal-api',
  serverUrl: 'http://localhost:8200',
  environment: 'dev',
  captureBody: 'all'
});
```

## 📁 Project Structure

```
elastic-rum-apm-ff/
├── docker-compose.yml          # Elastic Stack orchestration
├── apm-server.yml             # APM Server configuration
├── elastic_a_p_m_r_u_m_flutter_web/
│   ├── lib/
│   │   ├── custom_code/       # APM integration code
│   │   ├── pages/            # Flutter UI screens
│   │   └── backend/          # API client code
│   ├── web/
│   │   ├── index.html        # RUM agent integration
│   │   └── elastic-apm-rum.umd.min.js
│   └── pubspec.yaml
└── portal-api/
    ├── server.js             # Express.js API server
    ├── apm.js               # APM agent configuration
    └── package.json
```

## 🔧 Development

### Adding New Transactions
1. **Frontend**: Use the `ffRum` bridge in Flutter
2. **Backend**: APM automatically instruments Express routes
3. **Custom**: Add manual spans for business logic

### Environment Variables
- `ELASTIC_PASSWORD`: Elasticsearch password
- `KIBANA_SA_TOKEN`: Kibana service account token
- `ELASTIC_APM_SERVICE_NAME`: Service name for APM
- `ELASTIC_APM_SERVER_URL`: APM Server URL

## 🐛 Troubleshooting

### Common Issues

1. **APM Server not receiving data**
   - Check APM Server logs: `docker-compose logs apm`
   - Verify network connectivity between services

2. **Flutter app not connecting to API**
   - Ensure API server is running on port 8080
   - Check CORS configuration in `server.js`

3. **Kibana not accessible**
   - Wait for Elasticsearch to be fully started
   - Verify credentials and service account token

### Logs and Debugging
- **APM Server**: `docker-compose logs apm`
- **Elasticsearch**: `docker-compose logs elasticsearch`
- **Kibana**: `docker-compose logs kibana`
- **API**: Check console output in terminal

## 📚 Learn More

- [Elastic APM Documentation](https://www.elastic.co/guide/en/apm/agent/index.html)
- [Flutter Web Documentation](https://docs.flutter.dev/get-started/web)
- [Elastic APM RUM Agent](https://www.elastic.co/guide/en/apm/agent/rum-js/current/index.html)
- [Node.js APM Agent](https://www.elastic.co/guide/en/apm/agent/nodejs/current/index.html)

## 🤝 Contributing

This is a demonstration project showcasing Elastic APM integration with Flutter Web. Feel free to extend it with additional features or improvements.

---

**Note**: This setup is for development/demo purposes. For production, ensure proper security configurations, environment-specific settings, and monitoring best practices.
