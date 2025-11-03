# Modbus TCP Integration

## What This Does
Connects to Modbus TCP devices and maps register data to MQTT topics for real-time monitoring and control.

## Quick Setup
1. **Choose example**: 
   - `modbus-read-example.scf.yaml` - Read coils and registers
   - `modbus-write-example.scf.yaml` - Write to device
2. **Configure device**: Update `IP_Address` and `Port_Number` parameters
3. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply modbus-read-example.scf.yaml`
4. **Test connection**: Verify MQTT messages appear on configured topics

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **IP_Address** | Modbus device IP | `192.168.10.30` |
| **Port_Number** | Modbus TCP port | `502` |
| **initialReconnectDelay** | Reconnection delay | `1000` ms |
| **fc** | Function code | `1` (coils), `3` (registers) |
| **address** | Register/coil address | `3` |
| **dataType** | Data type | `boolean`, `int16BE` |

## What's Next
- Process the data: [Transform Rules](../../data-processing/01_transform/)
- Filter by thresholds: [Filter Rules](../../data-processing/02_filter/)
- Monitor device status: [Grafana Dashboard](../../monitoring/grafana-loki/)

## Full Tutorial
For detailed guidance, see: [How to connect a Modbus/TCP server](https://learn.cybus.io/lessons/how-to-connect-and-integrate-a-modbustcp-server/)