# Siemens S7 PLC Integration

## What This Does
Connects to Siemens S7 PLCs and maps register data to MQTT topics for real-time monitoring and control of industrial automation systems.

## Quick Setup
1. **Configure PLC**: Update `plcHost`, `rack`, and `slot` in `S7-example-commissioning-file.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply S7-example-commissioning-file.yml`
3. **Test connection**: Verify PLC data appears on configured MQTT topics

## Key Parameters
| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| plcHost | Yes | - | Siemens S7 PLC IP address |
| rack | Yes | 0 | PLC rack number |
| slot | Yes | 2 | PLC slot number |

## What's Next
- Process PLC data: [Transform Rules](../../data-processing/01_transform/)
- Set up alarms: [Filter Rules](../../data-processing/02_filter/)
- Monitor production: [Dashboard Setup](../../monitoring/grafana-loki/)

## Full Tutorial
For detailed guidance, see: [How to connect a Siemens S7 device](https://learn.cybus.io/lessons/how-to-connect-and-use-a-s7-device/)