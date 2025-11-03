# Heidenhain DNC Integration

## What This Does
Connects to Heidenhain CNC machines via DNC protocol to collect machining data and operational status.

## Quick Setup
1. **Configure CNC**: Update `cncHost` and `machineId` in `heidenhain-example-commissioning-file.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply heidenhain-example-commissioning-file.yml`
3. **Test connection**: Verify machining data appears on MQTT topics

## Key Parameters
| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| cncHost | Yes | - | Heidenhain CNC machine IP |
| dncPort | Yes | 3396 | DNC protocol port |
| machineId | Yes | - | Unique machine identifier |

## What's Next
- Process machining data: [Transform Rules](../../data-processing/01_transform/)
- Monitor machine status: [Filter Rules](../../data-processing/02_filter/)
- Create dashboards: [Grafana Setup](../../monitoring/grafana-loki/)

## Full Tutorial
For detailed guidance, see: [How to connect Heidenhain DNC](https://learn.cybus.io/how-to-connect-heidenhain-dnc/)