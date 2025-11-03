# Single Topic Pattern with Wildcards and Collect

This section demonstrates using wildcard patterns with collect rules for single topic patterns in manufacturing environments. The wildcard pattern matches multiple topics from different machines, zones, or systems, and the collect rule aggregates data for cross-system analytics.

## Manufacturing Scenarios

### 1. Production Analytics (`01_production_analytics.scf.yaml`)
- **Use Case**: Production line OEE monitoring across multiple lines
- **Technology**: OPC UA connections to production systems
- **Pattern**: `production/lines/+line/oee-metrics` with dynamic label `line_{line}`
- **Focus**: Cross-line performance aggregation and analytics

### 2. Quality Monitoring (`02_quality_monitoring.scf.yaml`)
- **Use Case**: Quality control data collection across inspection zones  
- **Technology**: OPC UA connections to quality systems
- **Pattern**: `quality/zones/+zone/inspection-results` with dynamic label `zone_{zone}`
- **Focus**: Multi-zone quality aggregation and reporting

### 3. Machine Health (`03_machine_health.scf.yaml`)
- **Use Case**: Equipment health monitoring for predictive maintenance
- **Technology**: Modbus connections to machine sensors
- **Pattern**: `machines/health/+machine/sensors` with dynamic label `machine_{machine}`
- **Focus**: Cross-machine condition monitoring and analytics

## Key Concepts Demonstrated

### Wildcard Pattern with Dynamic Labels
All scenarios use the same core pattern:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/pattern/+variable/data
  label: 'category_{variable}'  # Creates unique storage per variable

rules:
- collect: {}  # Aggregates all matching topics
- transform:   # Process complete dataset
    expression: |
      {
        "all_data": $,
        "triggered_by": $context.vars.variable,
        "item_count": $count($keys($))
      }
```

**Manufacturing Benefits:**
- ✅ **Multi-system monitoring**: Production lines, quality zones, machines
- ✅ **Cross-correlation**: Compare performance across similar assets
- ✅ **Real-time analytics**: Process complete dataset on each update

## Dynamic Labels for Manufacturing Assets

**Wildcard variables** create **unique cache keys** for each manufacturing asset:

### Example: Production Line Monitoring
```yaml
# Single wildcard pattern matches multiple production lines:
production/lines/line-a/oee-metrics     # Line: line-a
production/lines/line-b/oee-metrics     # Line: line-b  
production/lines/line-c/oee-metrics     # Line: line-c
```

### Dynamic Label Solution
```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/production/lines/+line/oee-metrics
  label: 'line_{line}'          # Creates unique labels per line

# Results in cache keys:
# line_line-a    → Line A OEE data
# line_line-b    → Line B OEE data  
# line_line-c    → Line C OEE data
```

**Manufacturing Benefits:**
- 🎯 **Asset identification**: Each line/zone/machine gets unique storage
- 🔄 **Cross-asset analysis**: Compare performance across similar equipment
- 📊 **KPI calculation**: Real-time OEE, quality rates, utilization metrics

## Collect Rule for Manufacturing Analytics

A **collect rule** aggregates the **latest data** from each matching manufacturing asset in a **key-value cache**. When any asset sends new data, the rule triggers and provides **complete visibility** across all monitored assets.

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/production/lines/+line/oee-metrics
  label: 'line_{line}'

rules:
- collect: {}  # Stores all production line data
- transform:   # Triggered on each update
    expression: |
      {
        "all_lines": $,
        "updated_line": $context.vars.line,
        "timestamp": $now()
      }
```

**Manufacturing Data Flow:**
```
📨 Line A: production/lines/line-a/oee-metrics → {"availability": 0.95, "performance": 0.88, "quality": 0.92}
📨 Line B: production/lines/line-b/oee-metrics → {"availability": 0.87, "performance": 0.91, "quality": 0.89}
📨 Line C: production/lines/line-c/oee-metrics → {"availability": 0.92, "performance": 0.85, "quality": 0.94}

🗄️ Aggregated Data (before Transform):
{
  "line_line-a": {"availability": 0.95, "performance": 0.88, "quality": 0.92},
  "line_line-b": {"availability": 0.87, "performance": 0.91, "quality": 0.89},
  "line_line-c": {"availability": 0.92, "performance": 0.85, "quality": 0.94}
}

✨ Analytics Output (triggered by Line C update):
{
  "all_lines": {
    "line_line-a": {"availability": 0.95, "performance": 0.88, "quality": 0.92},
    "line_line-b": {"availability": 0.87, "performance": 0.91, "quality": 0.89},
    "line_line-c": {"availability": 0.92, "performance": 0.85, "quality": 0.94}
  },
  "updated_line": "line-c",
  "timestamp": 1730115600000
}
```

## Why Dynamic Labels Prevent Data Loss

**Critical Issue**: Without dynamic labels, manufacturing data gets overwritten!

### ❌ Static Labels Example - Production Data Loss

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/production/lines/+line/oee-metrics
  label: 'oee_data'  # Same label for ALL lines!

rules:
- collect: {}
- transform:
    expression: |
      {
        "production_data": $,
        "line_count": $count($keys($))
      }
```

**Multiple Production Lines Reporting:**
```
📨 production/lines/line-a/oee-metrics → {"oee": 0.82, "output": 120}
📨 production/lines/line-b/oee-metrics → {"oee": 0.79, "output": 98}  
📨 production/lines/line-c/oee-metrics → {"oee": 0.85, "output": 135}
```

**❌ Static Labels Result - Data Loss:**
```json
{
  "production_data": {
    "oee_data": {"oee": 0.85, "output": 135}  // Only Line C data!
  },
  "line_count": 1  // Lost Line A & B data! ⚠️
}
```

### ✅ Dynamic Labels Example - Complete Production Visibility

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/production/lines/+line/oee-metrics
  label: 'line_{line}'  # Unique label per production line

rules:
- collect: {}
- transform:
    expression: |
      {
        "production_data": $,
        "line_count": $count($keys($)),
        "active_lines": $map($keys($), function($k) { $substringAfter($k, 'line_') }),
        "performance_summary": {
          "avg_oee": $average($map($keys($), function($k) { $lookup($, $k).oee })),
          "total_output": $sum($map($keys($), function($k) { $lookup($, $k).output })),
          "best_performer": $k_with_max_oee
        }
      }
```

**Same Production Lines Reporting:**
```
📨 production/lines/line-a/oee-metrics → {"oee": 0.82, "output": 120}
📨 production/lines/line-b/oee-metrics → {"oee": 0.79, "output": 98}  
📨 production/lines/line-c/oee-metrics → {"oee": 0.85, "output": 135}
```

**✅ Dynamic Labels Result - Complete Analytics:**
```json
{
  "production_data": {
    "line_line-a": {"oee": 0.82, "output": 120},
    "line_line-b": {"oee": 0.79, "output": 98},
    "line_line-c": {"oee": 0.85, "output": 135}
  },
  "line_count": 3,  // All production lines tracked! 🎉
  "active_lines": ["line-a", "line-b", "line-c"],
  "performance_summary": {
    "avg_oee": 0.82,
    "total_output": 353,
    "best_performer": "line-c"
  }
}
```

## Cross-Asset Manufacturing Analytics

**Advanced Use Case**: Multi-machine condition monitoring for predictive maintenance

### Input Messages from Machine Sensors
```
📨 machines/health/cnc-001/sensors → [68.5, 2.1, 1850, 1]  // [temp, vibration, speed, status]
📨 machines/health/cnc-002/sensors → [72.3, 1.8, 2100, 1]  // [temp, vibration, speed, status]  
📨 machines/health/robot-001/sensors → [45.2, 0.3, 0, 1]   // [temp, vibration, pos, status]
```

## Key Technique: Manufacturing Data Access Patterns

The `$lookup` pattern enables targeted analysis of specific machines within the complete fleet:

```javascript
// Build the dynamic label key for the reporting machine
$trigger := 'machine_' & $context.vars.machine;  // e.g., 'machine_cnc-001'

// Get data for the specific reporting machine
$reportingMachine := $lookup($, $trigger);

// Access complete fleet data
$allMachines := $; // complete machine health cache
```

**Manufacturing Analytics Examples:**
```javascript
// Compare reporting machine to fleet average
$reportingTemp := $lookup($, 'machine_' & $context.vars.machine)[0];
$allTemps := $map($keys($), function($k) { $lookup($, $k)[0] });
$avgTemp := $average($allTemps);
$tempDeviation := $reportingTemp - $avgTemp;

// Fleet health assessment
$healthyMachines := $filter($keys($), function($k) { 
  $lookup($, $k)[3] = 1  // Status = 1 (healthy)
});
$fleetHealth := $count($healthyMachines) / $count($keys($));
```

## When to Use Single Wildcard Collection in Manufacturing

**Perfect Manufacturing Use Cases:**
- **Production Lines**: All lines follow `production/lines/{line}/metrics` pattern
- **Quality Zones**: All zones use `quality/zones/{zone}/results` pattern  
- **Machine Fleet**: All machines follow `machines/health/{machine}/sensors` pattern
- **Facility Monitoring**: All areas use `facility/{area}/{system}/status` pattern

**Manufacturing Benefits:**
- **Real-time KPIs**: Calculate OEE, quality rates, utilization across assets
- **Comparative Analysis**: Identify best performers and improvement opportunities
- **Predictive Maintenance**: Detect anomalies across machine fleets
- **Cross-Asset Intelligence**: Correlation between related manufacturing systems

**Key Implementation Points:**
- Use `${Cybus::MqttRoot}` prefix for internal topic security
- Keep transformations simple and focused on core aggregation concepts
- Include realistic manufacturing endpoints (OPC UA, Modbus, HTTP)
- Provide clear input/output examples for better understanding

**Next**: [Array of Topics Patterns](../02_array_of_topics_patterns/) for handling multiple topic structures