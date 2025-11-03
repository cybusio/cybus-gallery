# SOPAS Integration (SICK Sensors)

## What This Does
Connects to SICK sensors via SOPAS protocol and streams sensor data to MQTT for industrial automation systems.

## Quick Setup
1. **Configure sensor**: Update `sopasHost` and `deviceType` in `sopas-example-commissioning-file.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply sopas-example-commissioning-file.yml`
3. **Test connection**: Verify sensor data appears on MQTT topics

## Key Parameters
| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| sopasHost | Yes | - | SICK sensor IP address |
| sopasPort | Yes | 2112 | SOPAS protocol port |
| deviceType | Yes | - | SICK sensor model |

## What's Next
- Analyze sensor data: [Data Processing](../../data-processing/01_transform/)
- Set up alerts: [Filter Rules](../../data-processing/02_filter/)
- Visualize data: [Monitoring Dashboard](../../monitoring/elasticsearch/)

## Full Tutorial
For detailed guidance, see: [How to connect a SICK RFID scanner](https://learn.cybus.io/lessons/how-to-connect-and-use-a-sick-rfid-scanner/)