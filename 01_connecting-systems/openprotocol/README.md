# OpenProtocol Atlas Copco Torque Tools

## What This Does
Connect to **Atlas Copco torque tools** and tightening systems using OpenProtocol. Monitor tightening results, alarms, job status, and control assembly operations for quality assurance.

**Quick Example:**
```yaml
# Connect to Atlas Copco PowerFocus system
openProtocolConnection:
  type: Cybus::Connection
  properties:
    protocol: Openprotocol
    connection:
      host: 192.168.1.100
      port: 4545
```

## Quick Setup
1. **Configure tool**: Update IP address in `multi_endpoints.scf.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply multi_endpoints.scf.yml`
3. **Test connection**: Check logs for successful OpenProtocol connection

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **host** | Tool controller IP | `192.168.1.100` |
| **port** | OpenProtocol port | `4545` |
| **agentName** | Agent running connector | `openprotocol` |
| **midGroup** | Message group to subscribe | `lastTightening` |

## Common Message Groups

| MID Group | Description | Use Case |
|-----------|-------------|----------|
| **lastTightening** | Latest tightening result | Quality monitoring |
| **alarm** | Tool alarms and errors | Fault detection |
| **jobInfo** | Job and batch information | Production tracking |
| **psetSelected** | Parameter set selection | Process control |
| **vin** | Vehicle identification | Traceability |

## Example Endpoints

**Monitor tightening results:**
```yaml
lastTightening:
  type: Cybus::Endpoint
  properties:
    protocol: Openprotocol
    connection: !ref openProtocolConnection
    topic: lastTightening
    subscribe:
      midGroup: lastTightening
```

**Track alarms:**
```yaml
alarm:
  type: Cybus::Endpoint
  properties:
    protocol: Openprotocol
    connection: !ref openProtocolConnection
    topic: alarm
    subscribe:
      midGroup: alarm
```

**Job monitoring:**
```yaml
jobInfo:
  type: Cybus::Endpoint
  properties:
    protocol: Openprotocol
    connection: !ref openProtocolConnection
    topic: jobInfo
    subscribe:
      midGroup: jobInfo
```

## Compatible Systems
- **PowerFocus 6000**
- **PowerMACS 4000**
- **STwrench systems**
- **PF3000/4000/5000**
- **Tensor STR/STS**

## Typical Data Flow
1. **Tool performs tightening** → Torque/angle measurement
2. **Quality check** → Pass/fail determination  
3. **Result transmission** → Data sent via OpenProtocol
4. **MQTT publishing** → Results available for analytics
5. **Traceability** → Link to part/VIN information

## What's Next
- **[Modbus](../modbus)**: Alternative tool connectivity
- **[HTTP](../http-post-mqtt)**: REST API integration
- **[Data Processing](../../data-processing)**: Transform tightening data
- **[Monitoring](../../monitoring)**: Quality dashboards
