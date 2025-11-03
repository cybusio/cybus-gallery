# HTTP POST to MQTT Bridge

## What This Does
Create HTTP endpoints that receive POST requests and forward data directly to MQTT topics. Perfect for webhook integration and IoT data collection.

**Quick Example:**
```bash
# Send data via HTTP
curl -X POST https://your-connectware.com/data/api/sensor-data \
  -H "Content-Type: application/json" \
  -d '{"temperature": 23.5, "humidity": 60}'
```

## Quick Setup
1. **Configure endpoint**: Update paths in `http-server-service.scf.yaml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply http-server-service.scf.yaml`
3. **Test endpoint**: Use `test-requests.sh` script or send POST requests

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **serverPort** | HTTP server port | `8080` |
| **basePath** | API base path | `/api` |
| **endpoint** | POST endpoint path | `/sensor-data` |
| **topic** | Target MQTT topic | `sensors/data` |

## Example Usage

**Send sensor data:**
```bash
curl -X POST https://your-connectware.com/data/api/sensor-data \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic <TOKEN>" \
  -d '{"temperature": 23.5, "humidity": 60}'
```

**Send machine status:**
```bash
curl -X POST https://your-connectware.com/data/api/sensor-data \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic <TOKEN>" \
  -d '{"machine": "pump01", "status": "running"}'
```

## What's Next
- **[Transform Data](../../data-processing/01_transform)**: Process incoming HTTP data
- **[Filter Rules](../../data-processing/02_filter)**: Conditional message handling
- **[HTTP Write CNC](../http-write-cnc)**: Send HTTP requests to CNC machines
- **[Monitoring](../../monitoring)**: Track HTTP endpoint usage