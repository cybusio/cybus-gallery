# Array of Topics Patterns with Wildcards and Collect

This section demonstrates using array subscription to handle multiple incompatible topic structures in manufacturing environments. Array subscription is essential when different systems use incompatible topic patterns that cannot be unified with a single wildcard pattern.

## Manufacturing Scenarios

### 1. Manufacturing Integration (`01_manufacturing_integration.scf.yaml`)
- **Use Case**: Cross-system analytics for production, quality, and maintenance
- **Technology**: OPC UA connections to different manufacturing systems
- **Topic Patterns**: 
  - `production/lines/+line/status`
  - `quality/batches/+batch/results`  
  - `maintenance/equipment/+equipment/schedule`
- **Focus**: Multi-domain integration with different topic structures

### 2. Supply Chain Visibility (`02_supply_chain_visibility.scf.yaml`)
- **Use Case**: End-to-end supply chain monitoring across facilities
- **Technology**: Modbus connections to inventory, warehouse, and supplier systems
- **Topic Patterns**:
  - `inventory/materials/+material/level`
  - `inventory/products/+product/level`
  - `logistics/warehouses/+warehouse/storage`
  - `suppliers/+supplier/deliveries`
- **Focus**: Cross-facility coordination with heterogeneous data sources

### 3. Energy Management (`03_energy_management.scf.yaml`)
- **Use Case**: Multi-utility monitoring for facility optimization
- **Technology**: Mixed OPC UA and Modbus connections to utility systems
- **Topic Patterns**:
  - `energy/electrical/+area/consumption`
  - `energy/compressed-air/+compressor/metrics`
  - `energy/cooling/systems/+chiller/status`
- **Focus**: Cross-utility analytics with different topic depths

## Why Array Subscription is Essential


**Array subscription** solves integration challenges when manufacturing systems use:
- **Different root paths** (production/, quality/, maintenance/, energy/)
- **Different hierarchical depths** (3, 4, or 5 topic levels)  
- **Different business domains** (incompatible naming conventions)

### Manufacturing Array Subscription Pattern
```yaml
subscribe:
  - topic: ${Cybus::MqttRoot}/production/lines/+line/status
    label: 'prod_{line}'
  - topic: ${Cybus::MqttRoot}/quality/batches/+batch/results
    label: 'quality_{batch}'
  - topic: ${Cybus::MqttRoot}/maintenance/equipment/+equipment/schedule
    label: 'maint_{equipment}'

rules:
- collect: {}  # Aggregates all different topic structures
- transform:   # Process complete cross-system dataset
    expression: |
      {
        "all_systems": $,
        "triggered_by": $context.topic
      }
```

**Manufacturing Benefits:**
- ✅ **Multi-system integration**: Production, quality, maintenance in one service
- ✅ **Cross-domain analytics**: Correlate different manufacturing systems
- ✅ **Unified monitoring**: Single dashboard for heterogeneous systems

## Dynamic Labels for Manufacturing Systems

**Dynamic labels** using wildcard values create unique identification for each manufacturing asset:

### Example: Cross-System Manufacturing Topics
```yaml
# Different manufacturing systems - incompatible topic structures:
production/lines/line-a/status             # Production domain
quality/batches/batch-001/results          # Quality domain  
maintenance/equipment/robot-001/schedule   # Maintenance domain
energy/electrical/main-panel/consumption   # Energy domain
```

### Dynamic Label Solution
```yaml
subscribe:
  - topic: ${Cybus::MqttRoot}/production/lines/+line/status
    label: 'prod_{line}'                   # Creates: prod_line-a
  - topic: ${Cybus::MqttRoot}/quality/batches/+batch/results
    label: 'quality_{batch}'               # Creates: quality_batch-001
  - topic: ${Cybus::MqttRoot}/maintenance/equipment/+equipment/schedule
    label: 'maint_{equipment}'             # Creates: maint_robot-001
  - topic: ${Cybus::MqttRoot}/energy/electrical/+area/consumption
    label: 'elec_{area}'                   # Creates: elec_main-panel
```

**Manufacturing Benefits:**
- 🎯 **Asset identification**: Each machine, line, or system gets unique storage
- 🔑 **Domain separation**: Labels include system type for easy filtering
- 🏗️ **Cross-correlation**: Compare and analyze across different manufacturing domains

## Collect Rule for Cross-System Analytics

A **collect rule** aggregates the **latest data** from each manufacturing system in a **key-value cache**. When any system sends new data, the rule triggers and provides **complete visibility** across all integrated systems.

```yaml
subscribe:
  - topic: ${Cybus::MqttRoot}/production/lines/+line/status
    label: 'prod_{line}'
  - topic: ${Cybus::MqttRoot}/quality/batches/+batch/results
    label: 'quality_{batch}'

rules:
- collect: {}  # Stores all manufacturing system data
- transform:   # Triggered when any system updates
    expression: |
      {
        "all_systems": $,
        "updated_system": $context.topic,
        "timestamp": $now()
      }
```

**Manufacturing Data Flow:**
```
📨 Production: production/lines/line-a/status → {"oee": 0.85, "output": 120}
📨 Quality: quality/batches/batch-001/results → {"passed": 45, "failed": 2}
📨 Maintenance: maintenance/equipment/robot-001/schedule → {"next": "2024-11-15", "priority": "medium"}

✨ Analytics Output (triggered by maintenance update):
{
  "all_systems": {
    "prod_line-a": {"oee": 0.85, "output": 120},
    "quality_batch-001": {"passed": 45, "failed": 2},
    "maint_robot-001": {"next": "2024-11-15", "priority": "medium"}
  },
  "updated_system": "maintenance/equipment/robot-001/schedule",
  "timestamp": 1730529600000
}
```

## Why Dynamic Labels Prevent Manufacturing Data Loss

**Critical Issue**: Without dynamic labels, manufacturing data from similar systems gets overwritten!

### ❌ Static Labels Example - Manufacturing Data Loss

```yaml
subscribe:
  - topic: ${Cybus::MqttRoot}/production/lines/+line/status
    label: 'production_data'                    # Same label for ALL lines!
  - topic: ${Cybus::MqttRoot}/energy/electrical/+area/consumption
    label: 'electrical_data'                    # Same label for ALL areas!

rules:
- collect: {}
- transform:
    expression: |
      {
        "manufacturing_data": $,
        "system_count": $count($keys($))
      }
```

**Multiple Manufacturing Systems Reporting:**
```
📨 production/lines/line-a/status → {"oee": 0.85, "output": 120}
📨 production/lines/line-b/status → {"oee": 0.79, "output": 95}
📨 energy/electrical/main-panel/consumption → {"power_kw": 285.4, "current_a": 396.7}
📨 energy/electrical/production-area/consumption → {"power_kw": 142.8, "current_a": 199.3}
```

**❌ Static Labels Result - Data Loss:**
```json
{
  "manufacturing_data": {
    "production_data": {"oee": 0.79, "output": 95},      // Only Line B!
    "electrical_data": {"power_kw": 142.8, "current_a": 199.3}  // Only production area!
  },
  "system_count": 2  // Lost Line A & main panel data! ⚠️
}
```

### ✅ Dynamic Labels Example - Complete Manufacturing Visibility

```yaml
subscribe:
  - topic: ${Cybus::MqttRoot}/production/lines/+line/status
    label: 'prod_{line}'                        # Unique per production line
  - topic: ${Cybus::MqttRoot}/energy/electrical/+area/consumption
    label: 'elec_{area}'                        # Unique per electrical area
  - topic: ${Cybus::MqttRoot}/quality/batches/+batch/results
    label: 'quality_{batch}'                    # Unique per quality batch

rules:
- collect: {}
- transform:
    expression: |
      {
        "manufacturing_data": $,
        "system_count": $count($keys($)),
        "system_breakdown": {
          "production_lines": $count($filter($keys($), function($k) { $contains($k, 'prod_') })),
          "electrical_areas": $count($filter($keys($), function($k) { $contains($k, 'elec_') })),
          "quality_batches": $count($filter($keys($), function($k) { $contains($k, 'quality_') }))
        }
      }
```

**Same Manufacturing Systems Reporting:**
```
📨 production/lines/line-a/status → {"oee": 0.85, "output": 120}
📨 production/lines/line-b/status → {"oee": 0.79, "output": 95}
📨 energy/electrical/main-panel/consumption → {"power_kw": 285.4, "current_a": 396.7}
📨 energy/electrical/production-area/consumption → {"power_kw": 142.8, "current_a": 199.3}
📨 quality/batches/batch-001/results → {"passed": 45, "failed": 2, "score": 95.7}
```

**✅ Dynamic Labels Result - Complete Analytics:**
```json
{
  "manufacturing_data": {
    "prod_line-a": {"oee": 0.85, "output": 120},
    "prod_line-b": {"oee": 0.79, "output": 95},
    "elec_main-panel": {"power_kw": 285.4, "current_a": 396.7},
    "elec_production-area": {"power_kw": 142.8, "current_a": 199.3},
    "quality_batch-001": {"passed": 45, "failed": 2, "score": 95.7}
  },
  "system_count": 5,  // All manufacturing systems tracked! 🎉
  "system_breakdown": {
    "production_lines": 2,
    "electrical_areas": 2,
    "quality_batches": 1
  }
}
```

## When to Use Array Subscription in Manufacturing

**Perfect Manufacturing Use Cases:**
- **Multi-system integration**: Production + Quality + Maintenance systems
- **Cross-facility monitoring**: Different sites with incompatible topic structures
- **Mixed protocol environments**: OPC UA + Modbus + HTTP systems in one service
- **Different data depths**: Systems with varying topic hierarchy levels

**Key Implementation Points:**
- Use `${Cybus::MqttRoot}` prefix for internal topic security
- Keep transformations simple and focused on aggregation concepts
- Include realistic manufacturing endpoints and protocols
- Provide clear examples showing cross-system benefits

**Next**: [Dynamic Publish Topics](../../04_dynamic_publish_topic/) for context-driven topic publishing