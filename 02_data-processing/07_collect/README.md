# Collect Rule Tutorial

> **Purpose**: Aggregate multiple data sources into a single message for comprehensive monitoring  
> **Prerequisites**: [Transform](../01_transform/), [Filter](../02_filter/), and [SetContextVars](../05_setContextVars/)

## What You'll Learn

The `collect` rule creates a **Last Value Cache (LVC)** that gathers data from multiple sources. Perfect for:
- 🎯 Environmental monitoring dashboards (temp + humidity + pressure)
- 📊 Multi-sensor equipment snapshots 
- 🔗 Coordinating data from different systems
- 📈 Building complete data pictures from partial updates

**Key Concept**: Every incoming message triggers output of the **complete current cache**.

## Step-by-Step Examples

### Step 1: Basic Multi-Sensor Collection

**Concept**: Gather temperature, humidity, and pressure into one message.

```yaml
mappings:
- subscribe:
    - topic: sensors/temperature
    - topic: sensors/humidity  
    - topic: sensors/pressure
  publish:
    topic: environment/snapshot
  rules:
  - collect: {}  # Cache keys = topic paths
```

**Message flow:**
```
10:00:01 - sensors/temperature: {"value": 23.5, "unit": "°C"}
→ Output: {
    "sensors/temperature": {"value": 23.5, "unit": "°C"}
  }

10:00:02 - sensors/humidity: {"value": 65.2, "unit": "%"}  
→ Output: {
    "sensors/temperature": {"value": 23.5, "unit": "°C"},
    "sensors/humidity": {"value": 65.2, "unit": "%"}
  }

10:00:03 - sensors/pressure: {"value": 1013.1, "unit": "hPa"}
→ Output: {
    "sensors/temperature": {"value": 23.5, "unit": "°C"},
    "sensors/humidity": {"value": 65.2, "unit": "%"}, 
    "sensors/pressure": {"value": 1013.1, "unit": "hPa"}
  }
```

**Key insight**: Each message updates the cache and triggers output of ALL current values.

### Step 2: Using Static Labels for Cleaner Access

**Concept**: Use labels to create simple field names instead of long topic paths.

```yaml
mappings:
- subscribe:
    - topic: sensors/office/temperature
      label: temp
    - topic: sensors/office/humidity
      label: humidity
    - topic: sensors/office/pressure  
      label: pressure
  publish:
    topic: environment/office-snapshot
  rules:
  - collect: {}
  - transform:
      expression: |
        {
          "office_conditions": {
            "temperature": $lookup($, 'temp'),
            "humidity": $lookup($, 'humidity'), 
            "pressure": $lookup($, 'pressure'),
            "comfort_index": 
              ($lookup($, 'temp').value >= 20 and $lookup($, 'temp').value <= 25) and
              ($lookup($, 'humidity').value >= 40 and $lookup($, 'humidity').value <= 60) 
              ? "comfortable" : "uncomfortable"
          },
          "snapshot_timestamp": $now()
        }
```

**Benefits of labels:**
- ✅ **Simple access**: `$lookup($, 'temp')` vs `$lookup($, 'sensors/office/temperature')`
- ✅ **Cleaner code**: Shorter expressions, easier to read
- ✅ **Flexible naming**: Choose meaningful names independent of topic structure  
- **When**: Fixed, known data sources
- **Pros**: Clean cache keys, easy JSONata access with `$lookup()`
- **Cons**: Requires predefined subscription list

### 3. Dynamic Labels (with Topic Dynamic Labels)
- **When**: Unknown number of sources, scalable systems
- **Pros**: Automatic scaling, pattern-based organization
- **Critical**: Prevents data overwrite in wildcard scenarios

## Why Dynamic Labels are Essential for Wildcards

**Without dynamic labels**, wildcard subscriptions create a **critical data loss problem**:

```yaml
# WRONG - Data Loss Risk
subscribe:
  topic: building/+room/temperature  # Multiple rooms
  # No label = same cache key for all rooms!
```

**Problem**: All messages use the same cache key, so:
- `building/office-a/temperature` overwrites `building/office-b/temperature` in cache
- Only the last received message is kept
- **Data from all other rooms is lost!**
- **Every new message from ANY room triggers output** but cache only contains the latest room's data

**Solution - Dynamic Labels**:
```yaml
# CORRECT - Data Preserved  
subscribe:
  topic: building/+room/temperature
  label: 'temp_{room}'  # Unique cache key per room
```

**Result**: Each room gets its own cache entry:
- `temp_office-a` stores office-a data
- `temp_office-b` stores office-b data  
- **All room data is preserved**
- **Any new message from ANY room** triggers output with ALL rooms' latest data

## Comprehensive Examples

### Example 1: Static Labels for Known Sources
```yaml
# Clean cache keys for easier data processing
mappings:
- subscribe:
    - topic: sensors/office/temperature
      label: temp
    - topic: sensors/office/humidity  
      label: humidity
  rules:
  - collect: {}
  - transform:
      expression: |
        {
          "comfort": ($lookup($, 'temp').value > 20 and $lookup($, 'humidity').value < 60) ? "good" : "poor"
        }
```

**Benefits**:
- Simple JSONata access: `$lookup($, 'temp')`
- Clean cache structure
- Easy data correlation

### Step 3: Dynamic Labels for Scalable Systems

**Concept**: Handle unknown number of data sources automatically.

```yaml
mappings:
- subscribe:
    topic: building/+room/sensors/temperature
    label: 'temp_{room}'    # Dynamic: creates unique key per room
  publish:
    topic: environment/building-overview
  rules:
  - collect: {}
  - transform:
      expression: |
        {
          "building_summary": {
            "rooms_monitored": $count($keys($)),
            "average_temp": $average($map($values($), function($v) { $v.value })),
            "rooms_above_25c": $filter($keys($), function($k) { 
              $lookup($, $k).value > 25 
            }),
            "snapshot_time": $now()
          },
          "room_details": $
        }
```

**Test with dynamic data:**
```
Room A: building/office-a/sensors/temperature → {"value": 23.2}
Room B: building/conference/sensors/temperature → {"value": 26.8}  
Room C: building/lobby/sensors/temperature → {"value": 21.5}
```

**Output after all rooms:**
```json
{
  "building_summary": {
    "rooms_monitored": 3,
    "average_temp": 23.83,
    "rooms_above_25c": ["temp_conference"],
    "snapshot_time": 1730115600000
  },
  "room_details": {
    "temp_office-a": {"value": 23.2},
    "temp_conference": {"value": 26.8},
    "temp_lobby": {"value": 21.5}
  }
}
```

### Step 4: Multi-Level Dynamic Labels

**Concept**: Handle complex hierarchies like factory/line/machine/sensor.

```yaml
mappings:
- subscribe:
    topic: factory/+line/+machine/+sensor/data
    label: '{line}_{machine}_{sensor}'
  publish:
    topic: factory/complete-status
  rules:
  - collect: {}
```

**Example cache structure:**
```json
{
  "line-a_cnc-001_temperature": {"value": 68.5, "status": "normal"},
  "line-a_cnc-001_vibration": {"value": 2.1, "status": "normal"}, 
  "line-a_robot-arm_position": {"x": 145.2, "y": 78.9, "status": "moving"},
  "line-b_press-002_pressure": {"value": 850.3, "status": "high"}
}
```

## Why Dynamic Labels Prevent Data Loss

**❌ Without dynamic labels (WRONG):**
```yaml
subscribe:
  topic: building/+room/temperature  # Multiple rooms
  # No label = ALL rooms use same cache key!
```

**Problem**: `building/office-a/temperature` and `building/office-b/temperature` overwrite each other.

**✅ With dynamic labels (CORRECT):**
```yaml
subscribe:
  topic: building/+room/temperature
  label: 'temp_{room}'  # Each room gets unique cache key
```

**Result**: Every room preserved independently in cache.

## Cache Triggering Behavior

**Critical understanding**: ANY message triggers output of COMPLETE cache.

```
Cache State: {"temp_office": 22.5, "humidity_office": 65}

New message arrives: pressure_office → {"value": 1013}
→ Cache becomes: {"temp_office": 22.5, "humidity_office": 65, "pressure_office": {"value": 1013}}
→ Output: ENTIRE cache above (not just the pressure message)
```

## Real-World Use Cases

### 🏭 **Manufacturing Dashboard**
```yaml
# Collect all machine statuses for overview dashboard
- subscribe:
    topic: factory/+line/+machine/status
    label: '{line}_{machine}_status'
  rules:
  - collect: {}
  - transform:
      expression: |
        {
          "factory_overview": {
            "total_machines": $count($keys($)),
            "running_machines": $count($filter($keys($), function($k) {
              $lookup($, $k).state = "running"
            })),
            "machines_in_error": $filter($keys($), function($k) {
              $lookup($, $k).alarm = true
            })
          }
        }
```

### 🌡️ **Environmental Monitoring**
```yaml
# Office climate control with multiple zones
- subscribe:
    - topic: hvac/+zone/temperature
      label: 'temp_{zone}'
    - topic: hvac/+zone/humidity  
      label: 'humidity_{zone}'
  rules:
  - collect: {}
  - transform:
      expression: |
        {
          "climate_summary": {
            "zones_comfortable": $count($filter($keys($), function($k) {
              $contains($k, 'temp') and $lookup($, $k).value >= 20 and $lookup($, $k).value <= 25
            })),
            "zones_need_attention": $filter($keys($), function($k) {
              $contains($k, 'temp') and ($lookup($, $k).value < 18 or $lookup($, $k).value > 28)
            })
          }
        }
```

## Key Concepts

- 📊 **Last Value Cache**: Stores latest value from each source
- ⚡ **Immediate Triggers**: Every message triggers output of complete cache
- 🏷️ **Smart Labels**: Organize data with meaningful cache keys
- 🎯 **Dynamic Scaling**: Handle unknown number of sources automatically
- 🔄 **Data Aggregation**: Combine multiple sources into comprehensive views

## Next Steps

- **Advanced**: Try [Burst](../08_burst/) for time-based batching
- **Combine**: Use with [COV](../06_cov/) to collect only significant changes
- **Integration**: [Complete Rule Chain Example](../complete_rule_chain_example.scf.yaml)
```yaml
mappings:
- subscribe:
    # Critical equipment - static labels for easy access
    - topic: factory/line-a/cnc-001/status
      label: cnc_001_status
    - topic: factory/line-a/robot-arm/status  
      label: robot_status
    # Variable sensors - dynamic labels
    - topic: factory/line-a/+machine/sensors/+type/readings
      label: '{machine}_{type}'
  rules:
  - collect: {}
  - transform:
      expression: |
        {
          "critical_status": {
            "cnc": $lookup($, 'cnc_001_status').operational,
            "robot": $lookup($, 'robot_status').operational
          },
          "sensor_readings": $filter($, function($v, $k) { 
            $contains($k, '_') and not $contains($k, 'status')
          }),
          "line_operational": $lookup($, 'cnc_001_status').operational and $lookup($, 'robot_status').operational
        }
```

This pattern provides:
- **Reliable access** to critical equipment status
- **Flexible scaling** for additional sensors  
- **Clear separation** between critical and supplementary data
- **Data preservation** across all sources

## Configuration Reference

See `service.scf.yaml` for complete implementation examples including:
- Basic collect without labels
- Static labeling for known sources  
- Single-level dynamic labels
- Multi-level dynamic labels
- Manufacturing equipment monitoring