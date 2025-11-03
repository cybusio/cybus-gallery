# Basic Wildcard Patterns

**Purpose**: Learn fundamental wildcard subscription patterns for multi-topic mapping  
**Focus**: Wildcard syntax and context variables  
**Prerequisites**: Basic understanding of MQTT topics and JSONata expressions

## What You'll Learn

By the end of this tutorial, you'll understand:
- ✅ **Wildcard syntax** and when to use `+` vs `#`
- ✅ **Context variables** for accessing wildcard values
- ✅ **Dynamic topic handling** without hardcoding paths
- ✅ **Best practices** for wildcard naming and organization

## The Problem: Multiple Similar Topics

Instead of creating separate mappings for each topic:
```yaml
# ❌ Repetitive approach - not scalable
- subscribe: { topic: "factory/line-A/status" }
- subscribe: { topic: "factory/line-B/status" }  
- subscribe: { topic: "factory/line-C/status" }
```

Use wildcards to handle them all with one pattern:
```yaml
# ✅ Scalable approach - handles all lines
- subscribe: { topic: "factory/+line/status" }
```

## Wildcard Syntax

- **`+`** = Matches **exactly one** topic level 
- **`#`** = Matches **zero or more** remaining levels

### Examples:
```yaml
factory/+/status         # Matches: factory/line-A/status, factory/pump-3/status
sensors/+/+/temperature  # Matches: sensors/floor1/room1/temperature  
building/#               # Matches: building/floor1, building/floor1/room1/temp
```

## Step 1: Basic Wildcards (No Context Variables)

Start simple - use wildcards without names:

```yaml
subscribe:
  topic: factory/+/status    # Matches any factory equipment
rules:
- transform:
    expression: |
      {
        "timestamp": $now(),
        "status": $.status,
        "temperature": $.temperature
      }
```

**Problem**: You lose information about **which** equipment sent the data!

## Step 2: Named Wildcards (With Context Variables)

Add names to wildcards to capture the matched segments:

```yaml
subscribe:
  topic: factory/+equipment/status    # Named wildcard creates $context.vars.equipment
rules:
- transform:
    expression: |
      {
        "timestamp": $now(),
        "equipment_id": $context.vars.equipment,  # Now you know which equipment!
        "status": $.status,
        "temperature": $.temperature
      }
```

**Input**: `factory/pump-005/status` → `{"status": "running", "temperature": 68.5}`  
**Output**: `{"timestamp": 1730115600000, "equipment_id": "pump-005", "status": "running", "temperature": 68.5}`

## Complete Example

```yaml
topic: factory/+line/+machine/status
# Input: factory/assembly/cnc-001/status
# Creates: $context.vars.line = "assembly"
#         $context.vars.machine = "cnc-001"  
```

## Accessing Wildcard Values

Use `$context.vars.<name>` to access wildcard values in your transform:

```yaml
topic: building/+floor/+room/+sensor/reading

transform:
  expression: |
    {
      "device_location": {
        "floor": $context.vars.floor,      # Gets floor value
        "room": $context.vars.room,        # Gets room value  
        "sensor": $context.vars.sensor     # Gets sensor value
      },
      "full_path": $context.vars.floor & "/" & $context.vars.room,
      "sensor_reading": $.value,
      "timestamp": $now()
    }

# Input: building/2/office-201/temperature/reading → {"value": 23.5}
# Output: {
#   "device_location": {
#     "floor": "2",
#     "room": "office-201", 
#     "sensor": "temperature"
#   },
#   "full_path": "2/office-201",
#   "sensor_reading": 23.5,
#   "timestamp": "2025-10-28T10:30:00Z"
# }
```

## Best Practices

**✅ Use descriptive wildcard names:**
```yaml
topic: building/+floor/+room/+sensor/reading
```

**❌ Avoid cryptic wildcard names:**
```yaml
topic: building/+a/+b/+c/reading  
```

## Important: MQTT Root Prefix

When subscribing to endpoint topics in mappings, **always include the MQTT root prefix**:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/factory/+line/+machine/status
```

**Why this matters:**
- **Security**: Prevents subscribing to unintended external MQTT topics
- **Isolation**: Ensures you only receive data from your Connectware endpoints  
- **Best Practice**: Required for production deployments

**Example with prefix:**
```yaml
mappings:
- subscribe:
    topic: ${Cybus::MqttRoot}/factory/production/+line/sensors/#
  publish:
    topic: analytics/sensors
  rules:
  - transform:
      expression: |
        {
          "line": $context.vars.line,
          "sensor_data": $
        }
```

**❌ Without prefix (unsafe):**
```yaml
topic: factory/+line/status  # Could match external MQTT topics!
```

**✅ With prefix (secure):**
```yaml  
topic: ${Cybus::MqttRoot}/factory/+line/status  # Only your endpoints
```

## When to Use Wildcards

**✅ Good for same root path:**
```yaml
topic: building/+floor/+room/temperature
# Matches: building/1/office/temperature, building/2/lobby/temperature
```

**❌ Use arrays for different roots:**
```yaml
# Different domains - use arrays instead
- building/sensors/temperature
- factory/machines/temp  
- vehicle/engine/temperature
```

## Quick Reference

| Wildcard | Meaning | Example |
|----------|---------|---------|
| `+` | Single level | `${Cybus::MqttRoot}/factory/+/status` |
| `#` | Multi-level | `${Cybus::MqttRoot}/sensors/#` |
| `+name` | Creates variable | `$context.vars.name` |
| `${Cybus::MqttRoot}` | Endpoint prefix | Always required for security |

## Real Manufacturing Examples

This tutorial includes three comprehensive manufacturing scenarios:

### [01_line_monitoring.scf.yaml](./01_line_monitoring.scf.yaml)
**Production Line Equipment Monitoring**
- **Scenario**: Monitor CNC machines and robots across production lines
- **Wildcards**: `factory/production/+line/+machine/status`
- **Real Equipment**: Mazak CNC, DMG Mori, HAAS machines, KUKA robots
- **Use Case**: Track machine status, spindle speed, and tool wear across multiple production lines

### [02_sensor_monitoring.scf.yaml](./02_sensor_monitoring.scf.yaml) 
**Factory-Wide Sensor Networks**
- **Scenario**: Multi-line temperature, vibration, and pressure monitoring
- **Wildcards**: `factory/production/+line/sensors/#`
- **Real Sensors**: Temperature probes, vibration sensors, hydraulic pressure monitors
- **Use Case**: Detect overheating, excessive vibration, and pressure anomalies across the entire facility

### [03_quality_control.scf.yaml](./03_quality_control.scf.yaml)
**Quality Assurance Systems**  
- **Scenario**: Multi-dimensional quality control monitoring
- **Wildcards**: `quality/stations/+/+/+` (inspection, testing, final-check)
- **Real Tests**: Dimensional checks, leak tests, visual inspection, functional testing
- **Use Case**: Aggregate quality metrics and generate comprehensive quality reports

Each example demonstrates progressively complex wildcard patterns with real manufacturing contexts, dummy but realistic OPC UA and Modbus connections, and practical JSONata transformations you'll find in actual industrial deployments.

## Next Steps

- **[Wildcards with Collect](../03_wildcards_with_collect/)** - Combine wildcards with data aggregation
- **[Dynamic Publishing](../04_dynamic_publish_topic/wildcards/)** - Use wildcards for dynamic topic routing
- **[Array Mapping](../01_array/)** - Handle multiple incompatible topic patterns