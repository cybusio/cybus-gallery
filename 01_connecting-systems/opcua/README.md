# OPC UA Integration

## What This Does
Connects Cybus Connectware to OPC UA servers and maps device data to MQTT topics for Industrial IoT applications.

## Quick Setup
1. **Choose example**: 
   - `opcua-example-commissioning-file.yml` - Complete industrial example
   - `opcua-simple-example.yml` - Building automation (air conditioner)
2. **Configure server**: Update `opcuaHost` and `opcuaPort` parameters
3. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply opcua-example-commissioning-file.yml`
4. **Test connection**: Verify MQTT messages appear on configured topics

## Key Parameters
| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| opcuaHost | Yes | opcuaserver.com | OPC UA server hostname or IP |
| opcuaPort | Yes | 48010 | OPC UA server port |

## What's Next
- Transform the data: [Data Processing Rules](../../data-processing/01_transform/)
- Add security: [TLS Certificates](../mqtt-tls-certificates/)
- Monitor data flow: [Elasticsearch Dashboard](../../monitoring/elasticsearch/)

## Full Tutorial
For detailed guidance, see: [How to connect an OPC UA server](https://learn.cybus.io/lessons/how-to-connect-and-integrate-an-opcua-server/)