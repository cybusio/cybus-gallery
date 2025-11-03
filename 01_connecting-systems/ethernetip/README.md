# EtherNet/IP Allen-Bradley Connectivity

## What This Does
Connect to **Allen-Bradley PLCs** and **Rockwell Automation** devices using EtherNet/IP protocol. Read tags, write values, and integrate with ControlLogix, CompactLogix, and MicroLogix systems.

**Quick Example:**
```yaml
# Connect to Allen-Bradley PLC and read tag
ethernetIpConnection:
  type: Cybus::Connection
  properties:
    protocol: EthernetIp
    connection:
      host: 192.168.10.99
```

## Quick Setup
1. **Configure PLC**: Update IP address in `read-write.scf.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply read-write.scf.yml`
3. **Test connection**: Check logs for successful PLC connection

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **host** | PLC IP address | `192.168.10.99` |
| **tagName** | Tag name in PLC program | `dn_count`, `Temperature` |
| **programName** | Program name (or Null for global) | `SimulationMain`, `Null` |
| **tagType** | Data type for writes | `DINT`, `REAL`, `BOOL` |

## Example Operations

**Read PLC tag:**
```yaml
tagReader:
  type: Cybus::Endpoint
  properties:
    protocol: EthernetIp
    connection: !ref ethernetIpConnection
    read:
      tagName: Temperature_Reading
      programName: MainProgram
```

**Write to PLC tag:**
```yaml
tagWriter:
  type: Cybus::Endpoint
  properties:
    protocol: EthernetIp
    connection: !ref ethernetIpConnection
    write:
      tagName: Setpoint_Value
      programName: MainProgram
      tagType: REAL
```

**Subscribe to tag changes:**
```yaml
tagSubscription:
  type: Cybus::Endpoint
  properties:
    protocol: EthernetIp
    connection: !ref ethernetIpConnection
    subscribe:
      tagName: Status_Word
      programName: MainProgram
```

## Common Tag Types

| Type | Description | Example Values |
|------|-------------|----------------|
| **BOOL** | Boolean | `true`, `false` |
| **DINT** | 32-bit integer | `-2147483648` to `2147483647` |
| **REAL** | 32-bit float | `123.45` |
| **STRING** | Text string | `"Hello World"` |

## Compatible Devices
- **ControlLogix 5000** series
- **CompactLogix 5000** series  
- **MicroLogix 1400/1500**
- **PowerFlex drives**
- **PanelView HMIs**

## What's Next
- **[Modbus](../modbus)**: Alternative industrial protocol
- **[OPC UA](../opcua)**: Modern automation standard
- **[Data Processing](../../data-processing)**: Transform PLC data
- **[Monitoring](../../monitoring)**: Visualize production metrics
