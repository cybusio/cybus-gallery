# HTTP to CNC Write Bridge

## What This Does
Send data from HTTP POST requests to **FANUC CNC machines** using FOCAS protocol. Transform HTTP data and write it directly to CNC parameters or programs.

**Quick Example:**
```bash
# Send program command to CNC
curl -X POST https://your-connectware.com/cnc/api/write \
  -H "Content-Type: application/json" \
  -d '{"data": "O1001"}'
```

## Quick Setup
1. **Configure CNC**: Update `host` IP address in `cnc-write-service.scf.yaml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply cnc-write-service.scf.yaml`
3. **Test endpoint**: Use `test-cnc-commands.sh` script or send manual requests

## Key Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| **host** | CNC machine IP | `192.168.1.100` |
| **port** | FOCAS port | `8193` |
| **endpoint** | HTTP write path | `/cnc/api/write` |
| **address** | FOCAS write address | `/NC/Channel/ChannelDiagnose/progName` |

## Example Commands

**Send program number:**
```bash
curl -X POST https://your-connectware.com/cnc/api/write \
  -H "Content-Type: application/json" \
  -d '{"data": "O1001"}'
```

**Send parameter:**
```bash
curl -X POST https://your-connectware.com/cnc/api/write \
  -H "Content-Type: application/json" \
  -d '{"data": "M30"}'
```

## Data Flow
1. **HTTP POST** → Receive JSON data at `/cnc/api/write`
2. **JSONata Transform** → Extract `data` field and format for FOCAS
3. **FOCAS Write** → Send to CNC machine via FOCAS protocol
4. **CNC Execute** → Machine processes the command

## What's Next
- **[FOCAS Integration](../focas)**: Read data from FANUC CNC systems
- **[HTTP POST MQTT](../http-post-mqtt)**: Receive data via HTTP
- **[Data Processing](../../data-processing)**: Transform CNC data
- **[Monitoring](../../monitoring)**: Track CNC operations
  