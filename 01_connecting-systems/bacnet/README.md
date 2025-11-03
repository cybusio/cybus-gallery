# BACnet Building Automation

## What This Does
Connect to **BACnet devices** in building automation systems. Read sensors, control HVAC systems, and manage building equipment through the BACnet protocol.

**Quick Example:**
```yaml
# Connect to BACnet device and read temperature sensor
bacnetConnection:
  type: Cybus::Connection
  properties:
    protocol: Bacnet
    connection:
      deviceInstance: 2000
      deviceAddress: "192.168.10.30:47808"
      localPort: 48808
```

## Quick Setup
1. **Configure device**: Update IP address and device instance in `read-write.scf.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply read-write.scf.yml`
3. **Test connection**: Check logs for successful BACnet device discovery

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **deviceAddress** | BACnet device IP:Port | `"192.168.10.30:47808"` |
| **deviceInstance** | BACnet device ID | `2000` |
| **localPort** | Local UDP port | `48808` |
| **objectType** | BACnet object type | `binary-output`, `analog-input` |
| **objectInstance** | Object instance number | `303` |
| **property** | BACnet property | `present-value` |

## Example Objects

**Read temperature sensor:**
```yaml
temperatureSensor:
  type: Cybus::Endpoint
  properties:
    protocol: Bacnet
    connection: !ref bacnetConnection
    subscribe:
      objectType: analog-input
      objectInstance: 101
      property: present-value
      interval: 5000
```

**Control HVAC output:**
```yaml
hvacControl:
  type: Cybus::Endpoint
  properties:
    protocol: Bacnet
    connection: !ref bacnetConnection
    write:
      objectType: binary-output
      objectInstance: 303
      property: present-value
      priority: 8
```

## Common BACnet Objects

| Object Type | Use Case | Properties |
|-------------|----------|------------|
| **analog-input** | Temperature, humidity sensors | `present-value`, `units` |
| **analog-output** | Setpoints, control values | `present-value`, `priority-array` |
| **binary-input** | Door contacts, alarms | `present-value`, `polarity` |
| **binary-output** | Pumps, fans, lights | `present-value`, `priority` |

## What's Next
- **[Modbus](../modbus)**: Industrial device connectivity
- **[OPC UA](../opcua)**: Manufacturing automation
- **[Data Processing](../../data-processing)**: Transform and filter building data
- **[Monitoring](../../monitoring)**: Visualize building metrics
