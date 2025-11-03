# FOCAS FANUC CNC Connectivity

## What This Does
Connect to **FANUC CNC machines** using FOCAS (FANUC Open CNC API Specification). Read spindle speeds, program status, alarms, and machine parameters for CNC monitoring and control.

**Quick Example:**
```yaml
# Connect to FANUC CNC and read spindle speed
focasConnection:
  type: Cybus::Connection
  properties:
    protocol: Focas
    connection:
      host: 192.168.2.170
      port: 8193
```

## Quick Setup
1. **Configure CNC**: Update IP address in `read.scf.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply read.scf.yml`
3. **Test connection**: Check logs for successful FOCAS connection

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **host** | CNC IP address | `192.168.2.170` |
| **port** | FOCAS port | `8193` |
| **method** | FOCAS API method | `pmc_rdpmcrng` |
| **addressType** | PMC address type | `1` (F addresses) |
| **dataType** | Data type | `1` (byte) |
| **addressStart/End** | Address range | `40`, `41` |

## Example Operations

**Read spindle speed:**
```yaml
actualSpindleSpeed:
  type: Cybus::Endpoint
  properties:
    protocol: Focas
    connection: !ref focasConnection
    subscribe:
      method: 'pmc_rdpmcrng'
      interval: 5000
      addressType: 1    # F addresses
      dataType: 1       # Byte data
      addressStart: 40
      addressEnd: 41
      dataLength: 10
```

**Read machine status:**
```yaml
machineStatus:
  type: Cybus::Endpoint
  properties:
    protocol: Focas
    connection: !ref focasConnection
    subscribe:
      method: 'cnc_statinfo'
      interval: 1000
```

**Read program information:**
```yaml
programInfo:
  type: Cybus::Endpoint
  properties:
    protocol: Focas
    connection: !ref focasConnection
    subscribe:
      method: 'cnc_rdprognum'
      interval: 2000
```

## Common FOCAS Methods

| Method | Purpose | Use Case |
|--------|---------|----------|
| **pmc_rdpmcrng** | Read PMC data | Machine I/O, status |
| **cnc_statinfo** | CNC status | Operating mode, execution |
| **cnc_rdprognum** | Program number | Active program tracking |
| **cnc_alarm** | Read alarms | Fault monitoring |
| **cnc_rdspindlename** | Spindle info | Multi-spindle systems |

## PMC Address Types

| Type | Description | Example Use |
|------|-------------|-------------|
| **1** | F addresses | Machine signals |
| **2** | G addresses | System flags |
| **3** | X addresses | External inputs |
| **4** | Y addresses | External outputs |
| **5** | R addresses | Internal relays |

## Compatible Systems
- **FANUC Series 30i/31i/32i**
- **FANUC Series 0i/0i-F**
- **FANUC Series 15i**
- **FANUC Series 16i/18i/21i**
- **FANUC Power Motion i-A**

## What's Next
- **[Heidenhain DNC](../heidenhain-dnc)**: Alternative CNC connectivity
- **[Modbus](../modbus)**: Industrial device integration
- **[Data Processing](../../data-processing)**: Transform CNC data
- **[Monitoring](../../monitoring)**: Production dashboards