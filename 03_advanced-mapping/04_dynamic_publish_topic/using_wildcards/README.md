# Dynamic Publish Topics with Wildcards

This section demonstrates using wildcard segments from input topics to construct dynamic publish topics in manufacturing environments. Topic-based routing extracts information from the topic structure itself, enabling asset-specific, line-specific, and facility-specific data routing.

## Manufacturing Scenarios

### 1. Machine Data Routing (`01_machine_data_routing.scf.yaml`)
- **Use Case**: Route machine telemetry to machine-specific analysis topics
- **Technology**: OPC UA connections to machine monitoring systems
- **Pattern**: `machines/+machine_id/telemetry/data` → `analytics/machines/{machine_id}/performance/reports`
- **Focus**: Equipment-specific analytics with performance assessment

### 2. Line Status Routing (`02_line_status_routing.scf.yaml`)
- **Use Case**: Route production line data to line-specific dashboards
- **Technology**: Modbus connections to production line monitoring
- **Pattern**: `production/lines/+line_id/status/current` → `dashboards/production/{line_id}/shift-reports`
- **Focus**: Line-specific dashboards with shift performance tracking

### 3. UNS Asset Routing (`03_uns_asset_routing.scf.yaml`)
- **Use Case**: Transform legacy data into UNS (Unified Namespace) standard
- **Technology**: OPC UA connections to legacy asset monitoring systems
- **Pattern**: `legacy/+site/+area/+line/+asset/data` → `UNS/Enterprise/{site}/Area/{area}/Line/{line}/Asset/{asset}`
- **Focus**: Enterprise data standardization and ISA-95 compliance

## Key Concepts Demonstrated

### Manufacturing Wildcard Routing Pattern

All scenarios use wildcard values from input topics to construct dynamic output topics:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/manufacturing/+asset_id/data/input
publish:
  topic: 'analytics/{asset_id}/reports/output'  # Dynamic based on asset ID
rules:
- transform:
    expression: |
      {
        "manufacturing_data": $,
        "asset_context": {
          "asset_id": $context.vars.asset_id,
          "routing_path": "analytics/" & $context.vars.asset_id & "/reports/output"
        }
      }
```

**Manufacturing Benefits:**
- ✅ **Asset-specific routing**: Each machine, line, or zone gets its own analytics topic
- ✅ **Hierarchical organization**: Maintain manufacturing structure in output topics  
- ✅ **Scalable routing**: Automatically handle new assets without configuration changes
- ✅ **Enterprise integration**: Map manufacturing data to standardized topic hierarchies

## Manufacturing Wildcard Routing Example

Machine telemetry routing to machine-specific analytics topics:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/machines/+machine_id/telemetry/data
publish:
  topic: 'analytics/machines/{machine_id}/performance/reports'
rules:
- transform:
    expression: |
      {
        "machine_info": {
          "machine_id": $context.vars.machine_id,
          "machine_type": $contains($context.vars.machine_id, "cnc") ? "cnc" : "robot"
        },
        "performance_metrics": $.metrics,
        "analysis_summary": {
          "performance_status": $.oee > 0.85 ? "excellent" : "acceptable"
        }
      }
```

**Manufacturing Flow:**
- **Input**: `machines/cnc-001/telemetry/data` → `{"oee": 0.87, "metrics": {...}}`
- **Wildcard**: `machine_id = "cnc-001"`  
- **Output Topic**: `analytics/machines/cnc-001/performance/reports`
- **Result**: Machine-specific performance analysis with OEE assessment

## Multi-Level Manufacturing Routing

Production line status routing to line-specific dashboards:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/production/lines/+line_id/status/current
publish:
  topic: 'dashboards/production/{line_id}/shift-reports'
rules:
- transform:
    expression: |
      {
        "line_identification": {
          "line_id": $context.vars.line_id,
          "line_number": $substringAfter($context.vars.line_id, "line-"),
          "facility_area": "production"
        },
        "production_status": {
          "operational_state": $[0] = 1 ? "running" : "stopped",
          "efficiency_percentage": $[1] / $[2] * 100
        },
        "performance_indicators": {
          "oee_estimation": ($[0] = 1 ? 1 : 0) * ($[1] / $[2]) * ($[3] / 100)
        }
      }
```

**Manufacturing Flow:**
- **Input**: `production/lines/line-a/status/current` → `[1, 95, 100, 97, 25, 456]`
- **Wildcard**: `line_id = "line-a"`
- **Output Topic**: `dashboards/production/line-a/shift-reports`
- **Result**: Line-specific dashboard with OEE calculation and shift summary

## Enterprise UNS (Unified Namespace) Transformation

Transform legacy manufacturing data into ISA-95 compliant enterprise hierarchy:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/legacy/+site/+area/+line/+asset/data
publish:
  topic: 'UNS/Enterprise/ManufacturingCorp/Site/{site}/Area/{area}/Line/{line}/Equipment/{asset}'
rules:
- transform:
    expression: |
      {
        "isa95_hierarchy": {
          "enterprise": "ManufacturingCorp",
          "site": $context.vars.site,
          "area": $context.vars.area,
          "line": $context.vars.line,
          "equipment": $context.vars.asset,
          "full_path": "Enterprise/ManufacturingCorp/Site/" & $context.vars.site & "/Area/" & $context.vars.area & "/Line/" & $context.vars.line & "/Equipment/" & $context.vars.asset
        },
        "isa95_classification": {
          "level": $.asset_type = "machine" ? "Level-1" : "Level-0",
          "class": $contains($context.vars.asset, "robot") ? "Robotics" : "General"
        },
        "wildcard_routing": {
          "extracted_values": {
            "site": $context.vars.site,
            "area": $context.vars.area,
            "line": $context.vars.line,
            "asset": $context.vars.asset
          },
          "topic_transformation": {
            "from": $context.topic,
            "to": "UNS/Enterprise/ManufacturingCorp/Site/" & $context.vars.site & "/Area/" & $context.vars.area & "/Line/" & $context.vars.line & "/Equipment/" & $context.vars.asset
          }
        },
        "asset_data": $.data
      }
```

**ISA-95 UNS Flow:**
- **Input**: `legacy/plant-01/production/line-a/robot-arm/data` → `{"asset_type": "machine", "status": "running", "oee": 0.87}`
- **Wildcards**: `site="plant-01"`, `area="production"`, `line="line-a"`, `asset="robot-arm"`
- **Output Topic**: `UNS/Enterprise/ManufacturingCorp/Site/plant-01/Area/production/Line/line-a/Equipment/robot-arm`
- **Result**: ISA-95 compliant enterprise hierarchy with clear wildcard routing demonstration

## Benefits of Wildcard Routing in Manufacturing

✅ **Asset-Specific Routing**: Each machine, line, or facility gets dedicated analytics topics
✅ **Manufacturing Hierarchy**: Maintain production structure in data organization
✅ **Enterprise Integration**: Map legacy systems to standardized topic hierarchies
✅ **Scalable Asset Management**: Automatically handle new equipment without configuration
✅ **UNS Compliance**: Transform data into ISA-95 compliant enterprise namespaces

## When to Use Wildcard Routing in Manufacturing

### ✅ **Perfect Manufacturing Use Cases:**
- **Equipment-specific analytics**: Machine telemetry routing to machine-specific dashboards
- **Production line monitoring**: Line status routing to line-specific shift reports
- **Enterprise data standardization**: Legacy system transformation to UNS standards
- **Multi-site manufacturing**: Facility-specific data organization and routing
- **Asset hierarchy maintenance**: Preserve manufacturing structure in data flow
- **Maintenance system integration**: Route asset data to asset-specific maintenance topics

### ❌ **Not Ideal For:**
- **Condition-based routing**: Use setContextVars for routing based on data content
- **Complex manufacturing workflows**: Use setContextVars for business logic routing  
- **Alert severity routing**: Use setContextVars for priority-based routing
- **Cross-system integration**: Use array subscription for incompatible topic structures

### 🔄 **Combining with SetContextVars**

For comprehensive manufacturing routing, combine wildcard structure with payload analysis:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/machines/+machine_id/+data_type/monitoring
publish:
  topic: 'alerts/{machine_id}/{priority}/{data_type}/notifications'
rules:
- setContextVars:
    vars:
      machine_id: $context.vars.machine_id      # Use wildcard values
      data_type: $context.vars.data_type
      priority: $.severity > 0.8 ? "high" : "normal"  # Extract from payload
```

This approach provides efficient asset-based routing with intelligent condition-driven priorities.

## Manufacturing Implementation Examples

The three SCF files demonstrate complete working examples:
- **Machine data routing** with equipment-specific performance analytics
- **Production line routing** with line-specific dashboard integration  
- **UNS asset routing** with enterprise standardization and ISA-95 compliance