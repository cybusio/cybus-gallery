# Dynamic Publish Topics with SetContextVars

This section demonstrates using payload data to construct dynamic publish topics in manufacturing environments. The setContextVars rule extracts routing information from message content, enabling intelligent routing based on manufacturing conditions, priorities, and business logic.

## Manufacturing Scenarios

### 1. Quality Alert Routing (`01_quality_alert_routing.scf.yaml`)
- **Use Case**: Route quality alerts to department-specific topics based on product type and defect severity
- **Technology**: OPC UA connection to quality inspection system
- **Routing Logic**: Product category determines department, defect count determines severity
- **Focus**: Department-specific quality notifications with priority-based routing

### 2. Maintenance Priority Routing (`02_maintenance_priority_routing.scf.yaml`)
- **Use Case**: Route equipment condition alerts to appropriate maintenance teams
- **Technology**: Modbus connection to equipment condition monitoring
- **Routing Logic**: Equipment type determines team, condition metrics determine priority
- **Focus**: Team-specific maintenance work orders with urgency-based routing

### 3. Energy Alert Routing (`03_energy_alert_routing.scf.yaml`)
- **Use Case**: Route energy consumption alerts to departments based on impact and zones
- **Technology**: OPC UA connection to energy management system
- **Routing Logic**: Zone area determines department, efficiency metrics determine impact
- **Focus**: Department-specific energy optimization with cost-impact routing

## Key Concepts Demonstrated

### Manufacturing Content-Driven Routing Pattern

All scenarios use setContextVars to extract routing information from manufacturing data:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/manufacturing/data/input
publish:
  topic: 'alerts/{department}/{priority}/notifications'
rules:
- setContextVars:
    vars:
      department: $.category_based_logic  # Extract from payload
      priority: $.condition_based_logic   # Extract from payload
- transform:
    expression: |
      {
        "manufacturing_data": $,
        "routing_context": {
          "department": $context.vars.department,
          "priority": $context.vars.priority,
          "final_topic": "alerts/" & $context.vars.department & "/" & $context.vars.priority & "/notifications"
        }
      }
```

**Manufacturing Benefits:**
- ✅ **Intelligent routing**: Route alerts based on manufacturing conditions and context
- ✅ **Department-specific**: Ensure alerts reach the appropriate teams quickly
- ✅ **Priority-based**: Critical issues get routed to high-priority channels
- ✅ **Business logic**: Apply manufacturing rules and thresholds for routing decisions

## Manufacturing Payload-Based Routing Example

Quality alert routing based on product category and defect severity:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/quality/inspection/results
publish:
  topic: 'alerts/quality/{department}/{severity}/notifications'
rules:
- setContextVars:
    vars:
      department: |
        $.product.category = "automotive" ? "automotive-qc" :
        $.product.category = "aerospace" ? "aerospace-qc" : "general-qc"
      severity: |
        $.inspection.defect_count > 5 ? "critical" :
        $.inspection.defect_count > 2 ? "high" : "medium"
- transform:
    expression: |
      {
        "quality_data": $,
        "routing_context": {
          "department": $context.vars.department,
          "severity": $context.vars.severity
        }
      }
```

**Manufacturing Flow:**
- **Input**: Quality inspection results from OPC UA system
- **Payload**: `{"product": {"category": "automotive"}, "inspection": {"defect_count": 3}}`
- **SetContextVars**: `department="automotive-qc"`, `severity="high"`
- **Output Topic**: `alerts/quality/automotive-qc/high/notifications`

## Manufacturing Conditional Logic Routing

Maintenance priority routing based on equipment condition and type:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/maintenance/condition/monitoring
publish:
  topic: 'maintenance/teams/{team}/{priority}/work-orders'
rules:
- setContextVars:
    vars:
      team: |                                   # Equipment type logic
        $[0] = 1 ? "mechanical" :
        $[0] = 2 ? "electrical" :
        $[0] = 3 ? "hydraulic" : "general"
      priority: |                               # Condition-based priority
        $[2] > 90 or $[3] > 80 ? "urgent" :
        $[2] > 70 or $[3] > 60 ? "high" : "medium"
- transform:
    expression: |
      {
        "condition_data": $,
        "maintenance_routing": {
          "team": $context.vars.team,
          "priority": $context.vars.priority,
          "routing_logic": "Equipment type: " & $string($[0]) & " → Team: " & $context.vars.team & ", Temp: " & $string($[2]) & "°C → Priority: " & $context.vars.priority
        }
      }
```

**Manufacturing Flow:**
- **Payload**: `[2, 101, 85, 75, 2450, 28, 0, 1]` (Modbus array: equipment_type=2, temp=85°C, vibration=75)
- **Logic**: Type 2 → "electrical" team, Temp > 70°C → "high" priority
- **Output Topic**: `maintenance/teams/electrical/high/work-orders`

## Advanced Manufacturing Multi-Field Routing

Energy alert routing based on zone, efficiency, and cost impact:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/energy/consumption/analysis
publish:
  topic: 'alerts/energy/{department}/{impact}/optimization'
rules:
- setContextVars:
    vars:
      department: |                             # Zone-based department routing
        $.zone.area = "production" ? "production-ops" :
        $.zone.area = "facilities" ? "facilities-mgmt" : "energy-mgmt"
      impact: |                                 # Multi-condition impact assessment
        $.analysis.efficiency_drop > 20 ? "critical" :
        $.analysis.cost_increase > 15 ? "high" :
        $.analysis.efficiency_drop > 10 ? "medium" : "low"
- transform:
    expression: |
      {
        "energy_data": $,
        "alert_routing": {
          "department": $context.vars.department,
          "impact": $context.vars.impact,
          "requires_optimization": $.analysis.efficiency_drop > 10,
          "routing_decisions": {
            "efficiency_ok": $.analysis.efficiency_drop <= 10,
            "cost_acceptable": $.analysis.cost_increase <= 15
          }
        }
      }
```

**Manufacturing Flow:**
- **Payload**: `{"zone": {"area": "production"}, "analysis": {"efficiency_drop": 15.5, "cost_increase": 18.3}}`
- **Logic**: Production zone → "production-ops", Cost increase > 15% → "high" impact
- **Output Topic**: `alerts/energy/production-ops/high/optimization`

## Benefits of SetContextVars in Manufacturing

✅ **Manufacturing Intelligence**: Apply production rules and thresholds for smart routing  
✅ **Department-Specific Alerts**: Route quality, maintenance, and energy alerts to correct teams  
✅ **Priority-Based Routing**: Critical manufacturing issues get routed to high-priority channels  
✅ **Condition-Aware Routing**: Route based on manufacturing data analysis and conditions  
✅ **Business Logic Integration**: Apply manufacturing workflows and escalation rules

## When to Use SetContextVars in Manufacturing

### ✅ **Perfect Manufacturing Use Cases:**
- **Quality alert systems**: Route by product category, defect severity, inspection results
- **Maintenance notifications**: Route by equipment type, condition severity, team specialization  
- **Energy optimization alerts**: Route by consumption zone, efficiency thresholds, cost impact
- **Production workflow automation**: Route based on manufacturing conditions and priorities
- **Multi-site manufacturing**: Route by facility, production line, equipment type
- **Safety and compliance alerts**: Route by hazard type, severity level, response team

### ❌ **Not Ideal For:**
- **Simple asset-based routing**: Use [wildcards](../using_wildcards/) for better performance
- **Static manufacturing hierarchies**: Wildcard patterns are more efficient
- **High-frequency sensor data**: Processing overhead may impact performance
- **Simple machine-to-dashboard routing**: Direct topic mapping is sufficient

### 🔄 **Combining Both Approaches**

For comprehensive manufacturing routing, combine wildcard and payload analysis:

```yaml
subscribe:
  topic: ${Cybus::MqttRoot}/manufacturing/+facility/+line/alerts    # Wildcards for structure
publish:
  topic: 'alerts/{facility}/{line}/{department}/{priority}/notifications'
rules:
- setContextVars:
    vars:
      facility: $context.vars.facility        # Use wildcard values
      line: $context.vars.line
      department: $.alert_category_logic      # Extract from payload  
      priority: $.severity_analysis
```

This pattern provides efficient asset-based routing with intelligent manufacturing condition analysis.

## Manufacturing Implementation Examples

The three SCF files in this section demonstrate complete working examples:
- **Quality alert routing** with product category and defect severity analysis
- **Maintenance priority routing** with equipment type and condition assessment
- **Energy alert routing** with zone-based departments and efficiency impact analysis