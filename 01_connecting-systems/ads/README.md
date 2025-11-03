# ADS Beckhoff TwinCAT Connectivity

## What This Does
Connect to **Beckhoff TwinCAT** PLCs using ADS (Automation Device Specification) protocol. Read variables, write values, and integrate with industrial automation systems.

**Quick Example:**
```yaml
# Connect to Beckhoff PLC and read variable
adsConnection:
  type: Cybus::Connection
  properties:
    protocol: Ads
    connection:
      host: 192.168.2.170
      netId: "192.168.2.170.1.1"
      port: 851
```

## Quick Setup
1. **Configure TwinCAT**: Update IP addresses and NetIDs in `read.scf.yaml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply read.scf.yaml`
3. **Test connection**: Check logs for successful ADS connection

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **host** | PLC IP address | `192.168.2.170` |
| **netId** | AMS NetID of device | `"192.168.2.170.1.1"` |
| **port** | AMS port number | `851` (TwinCAT Runtime) |
| **localAddress** | Client NetID | `"192.168.7.12.1.1"` |
| **routerTcpPort** | ADS router TCP port | `48898` |
| **symbolName** | Variable name | `"MAIN.Temperature"` |

## Example Operations

**Read TwinCAT variable:**
```yaml
variableReader:
  type: Cybus::Endpoint
  properties:
    protocol: Ads
    connection: !ref adsConnection
    subscribe:
      symbolName: "MAIN.Temperature"
      dataType: "real32"
      interval: 1000
```

**Write to TwinCAT variable:**
```yaml
variableWriter:
  type: Cybus::Endpoint
  properties:
    protocol: Ads
    connection: !ref adsConnection
    write:
      symbolName: "MAIN.Setpoint"
      dataType: "real32"
```

**Read array element:**
```yaml
arrayReader:
  type: Cybus::Endpoint
  properties:
    protocol: Ads
    connection: !ref adsConnection
    subscribe:
      symbolName: "MAIN.byByte[4]"
      dataType: "int8"
      interval: 1000
```

## Common Data Types

| Type | Description | Range |
|------|-------------|-------|
| **bool** | Boolean | `true`, `false` |
| **int8** | 8-bit signed integer | `-128` to `127` |
| **int16** | 16-bit signed integer | `-32768` to `32767` |
| **int32** | 32-bit signed integer | `-2³¹` to `2³¹-1` |
| **real32** | 32-bit float | IEEE 754 |
| **string** | Text string | Variable length |

## AMS Port Numbers

| Port | Service | Description |
|------|---------|-------------|
| **851** | TwinCAT Runtime | Main PLC runtime |
| **801** | TwinCAT SPS | System service |
| **811** | TwinCAT NC | Motion control |
| **821** | TwinCAT CNC | CNC service |

## What's Next
- **[EtherNet/IP](../ethernetip)**: Allen-Bradley connectivity
- **[Modbus](../modbus)**: Alternative industrial protocol
- **[Data Processing](../../data-processing)**: Transform TwinCAT data
- **[Monitoring](../../monitoring)**: Visualize automation metrics
