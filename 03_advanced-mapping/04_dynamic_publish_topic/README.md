# Dynamic Publish Topics

**Purpose**: Learn how to create dynamic publish topics using data from input topic names and payloads  
**Focus**: Context-based routing and topic construction  
**Prerequisites**: [Basic Wildcards](../01_basic_wildcards/), [Array Mapping](../02_array/), and JSONata expressions

## What You'll Learn

By the end of this section, you'll master:
- ✅ **Wildcard-based routing** using topic segments for output construction  
- ✅ **Payload-based routing** using setContextVars for content-driven destinations
- ✅ **Multi-tenant architectures** with dynamic topic separation
- ✅ **UNS implementation** for enterprise namespace standardization

## The Challenge: Smart Message Routing

Static publish topics work for simple cases:
```yaml
# ❌ Static routing - not flexible
publish:
  topic: alerts/temperature/high    # Always goes to the same place
```

But what about dynamic scenarios where routing depends on:
- **Topic content**: Route `sensors/kitchen/temp` → `alerts/kitchen/temperature`  
- **Payload data**: Route based on `{"tenant": "acme", "priority": "high"}`
- **Business logic**: Different destinations based on data values or topic structure

**Solution**: Dynamic publish topics that construct destinations from context and data.

## When to Use Dynamic Publish Topics

**Perfect Use Cases:**
- **Multi-tenant systems**: Route messages to tenant-specific topics
- **Device-specific routing**: Send data to device-specific endpoints
- **Hierarchical data organization**: Build topic trees based on data content
- **Dynamic system integration**: Route to different systems based on payload content
- **UNS (Unified Namespace)**: Transform legacy systems into standardized enterprise hierarchies

## Tutorial Structure

Learn dynamic publishing through two progressive approaches:

### 📁 [using_wildcards/](using_wildcards/) - Topic-Based Routing (Start Here)
**Complexity**: ⭐⭐ Intermediate | **Focus**: Using wildcard values for output topics

**What You'll Learn:**
- Extract segments from input topics: `sensors/{room}/temp` → `alerts/{room}/high`
- Build hierarchical output topics using `$context.vars.{name}` 
- Route messages based on topic structure patterns
- Implement UNS (Unified Namespace) transformations

**Perfect For:**
- **Building automation**: Route by room, floor, or zone from topic structure
- **Device management**: Route by location and device ID extracted from topics  
- **Legacy system modernization**: Transform to standardized enterprise hierarchies
- **Simple dynamic routing**: When routing logic is embedded in topic names

---

### 📁 [using_set_context_vars/](using_set_context_vars/) - Content-Based Routing (Advanced)
**Complexity**: ⭐⭐⭐ Advanced | **Focus**: Using payload data for routing decisions

**What You'll Learn:**
- Extract routing info from message content: `{"tenant": "acme", "priority": "high"}`
- Use setContextVars rule to prepare dynamic routing variables
- Apply business logic and conditional routing based on data values
- Build multi-tenant and enterprise-grade routing systems

**Perfect For:**
- **Multi-tenant SaaS**: Route by organization, service, or user from payload
- **Alert systems**: Route by severity, destination, or escalation rules
- **Business process routing**: Apply complex conditional logic
- **Content-driven systems**: When routing depends on message data, not topic structure

## Comparison: Wildcards vs SetContextVars

| Approach | Data Source | Use Case | Example |
|----------|-------------|----------|---------|
| **Wildcards** | Topic segments | Route by topic structure | `input: sensors/{room}/temp` → `output: alerts/{room}/high` |
| **SetContextVars** | Payload content | Route by data content | `payload: {"priority": "high"}` → `output: alerts/high/notification` |
| **Combined** | Both sources | Complex routing logic | Topic + payload → `output: {tenant}/{priority}/{device}` |
| **UNS Implementation** | Topic structure | Legacy to standardized hierarchy | `legacy/{site}/{line}/data` → `UNS/Enterprise/{site}/Line/{line}` |

## Key Benefits

✅ **Flexible Routing**: Send messages to different destinations based on content
✅ **System Integration**: Route to different systems or services dynamically  
✅ **Multi-tenancy**: Separate data streams by tenant, user, or organization
✅ **Conditional Logic**: Apply business rules to determine routing
✅ **Scalability**: Handle dynamic systems without hardcoded topic mappings
✅ **UNS Compliance**: Transform legacy topic structures into ISA-95 compliant hierarchies

## Learning Path

### 🎯 **Recommended Sequence**

1. **Start with [Topic-Based Routing](using_wildcards/)** - Master the fundamentals
   - Learn wildcard value extraction and usage
   - Understand `$context.vars.{name}` patterns  
   - Practice with building automation and UNS examples

2. **Advance to [Content-Based Routing](using_set_context_vars/)** - Add business logic
   - Master setContextVars rule for payload-driven routing
   - Implement multi-tenant and conditional routing patterns
   - Build enterprise-grade routing systems with complex logic

3. **Combine Both Approaches** - Handle complex enterprise scenarios
   - Use topic structure AND payload content for routing decisions
   - Implement hybrid routing patterns for maximum flexibility

### 💡 **Quick Decision Guide**

**Choose Topic-Based Routing When:**
- Routing information is **embedded in topic structure**
- Need **simple, predictable routing** patterns
- **Legacy system integration** where topic hierarchy matters
- **Performance is critical** (no payload processing overhead)

**Choose Content-Based Routing When:**
- Routing depends on **message content** or business rules
- Need **complex conditional logic** based on data values
- **Multi-tenant systems** with tenant info in payload
- **Business process automation** with dynamic routing rules

## 🏭 UNS (Unified Namespace) Implementation with ISA Standards

**UNS transforms disparate enterprise manufacturing systems into a single, standardized topic hierarchy following ISA-95 and ISA-88 standards.** Dynamic publish topics are **essential** for UNS implementation because they enable automatic transformation from legacy topic structures to standardized enterprise hierarchies.

### ISA Standards Foundation

**ISA-95 (Enterprise-Control System Integration):**
- **Purpose**: Defines the interface between enterprise and control systems
- **Levels**: Level 4 (Business), Level 3 (Manufacturing Operations), Level 2 (Supervisory Control), Level 1 (Basic Control), Level 0 (Process)
- **Hierarchy**: Enterprise → Site → Area → Production Line → Work Cell → Equipment Module

**ISA-88 (Batch Process Control):**
- **Purpose**: Defines batch manufacturing control systems and equipment
- **Physical Model**: Enterprise → Site → Area → Process Cell → Unit → Equipment Module → Control Module

### Why UNS Needs Dynamic Publishing

**1. Legacy System Integration**
```yaml
# Transform legacy topics to ISA-95 compliant hierarchy
Input:  legacy/plant-01/production/line-a/robot-arm/data
Output: UNS/Enterprise/plant-01/Site/plant-01/Area/production/Line/line-a/WorkCell/assembly/Equipment/robot-arm
```

**2. ISA-95 Compliance & Automation**
- **Automatic Level Classification**: Equipment (Level 1), Supervisory (Level 2), Operations (Level 3)
- **Hierarchical Structure**: Maintain parent-child relationships per ISA-95 specification
- **Semantic Consistency**: Extract business meaning and map to standardized ISA paths

**3. Multi-Standard Support**
```yaml
# ISA-95 Manufacturing Operations Hierarchy
UNS/Enterprise/{enterprise}/Site/{site}/Area/{area}/Line/{line}/Equipment/{equipment}

# ISA-88 Batch Process Hierarchy  
UNS/Enterprise/{enterprise}/Site/{site}/Area/{area}/ProcessCell/{cell}/Unit/{unit}/EquipmentModule/{module}

# ISA-18.2 Alarm Management Integration
UNS/Enterprise/{enterprise}/Site/{site}/Area/{area}/Alarms/{priority}/{category}
```

### Complete UNS Transformation Examples

**Manufacturing Asset Integration (ISA-95):**
```yaml
# Legacy manufacturing data → ISA-95 compliant UNS
subscribe:
  topic: ${Cybus::MqttRoot}/legacy/+site/+area/+line/+asset/data
publish:
  topic: 'UNS/Enterprise/ManufacturingCorp/Site/{site}/Area/{area}/Line/{line}/Equipment/{asset}'
rules:
- transform:
    expression: |
      {
        "isa95_metadata": {
          "enterprise": "ManufacturingCorp",
          "site": $context.vars.site,
          "area": $context.vars.area, 
          "production_line": $context.vars.line,
          "equipment": $context.vars.asset,
          "level": "Level-1-Equipment",
          "hierarchy_path": "Enterprise/ManufacturingCorp/Site/" & $context.vars.site & "/Area/" & $context.vars.area & "/Line/" & $context.vars.line & "/Equipment/" & $context.vars.asset
        },
        "asset_classification": {
          "isa95_level": $.asset_type = "sensor" ? "Level-0" : $.asset_type = "machine" ? "Level-1" : "Level-2",
          "equipment_class": $contains($context.vars.asset, "robot") ? "Robotics" : $contains($context.vars.asset, "conveyor") ? "MaterialHandling" : "General"
        },
        "operational_data": $
      }
```

**Batch Process Integration (ISA-88):**
```yaml
# Batch manufacturing → ISA-88 compliant UNS
subscribe:
  topic: ${Cybus::MqttRoot}/batch/+site/+area/+cell/+unit/+module/data
publish:
  topic: 'UNS/Enterprise/ChemicalCorp/Site/{site}/Area/{area}/ProcessCell/{cell}/Unit/{unit}/EquipmentModule/{module}'
rules:
- transform:
    expression: |
      {
        "isa88_metadata": {
          "enterprise": "ChemicalCorp",
          "physical_model": {
            "site": $context.vars.site,
            "area": $context.vars.area,
            "process_cell": $context.vars.cell,
            "unit": $context.vars.unit,
            "equipment_module": $context.vars.module
          },
          "procedural_model": "Recipe-" & $.batch.recipe_id,
          "control_model": "Phase-" & $.batch.current_phase
        },
        "batch_data": $
      }
```

### ISA Standard Benefits in UNS

**✅ ISA-95 Manufacturing Operations Management:**
- **Standardized Hierarchy**: Enterprise → Site → Area → Line → Equipment
- **Level Classification**: Clear separation of control levels (0-4)
- **MES Integration**: Manufacturing Execution System compliance
- **KPI Standardization**: OEE, availability, performance tracking

**✅ ISA-88 Batch Process Control:**
- **Physical Model**: Site → Area → Process Cell → Unit → Equipment Module  
- **Procedural Model**: Recipe management and phase control
- **Control Model**: Equipment control and coordination
- **Batch Traceability**: Complete batch genealogy and history

**✅ ISA-18.2 Alarm Management:**
- **Priority Classification**: Critical, High, Medium, Low alarms
- **Alarm Rationalization**: Reduce alarm floods with proper classification
- **Response Procedures**: Standardized alarm handling workflows

### UNS Implementation Patterns

```yaml
# Multi-Standard UNS Hub
Input Patterns:
- legacy/+site/+area/+line/+equipment/data           → ISA-95 Manufacturing
- batch/+site/+area/+cell/+unit/+module/data        → ISA-88 Batch Process  
- alarms/+site/+area/+priority/+category/data       → ISA-18.2 Alarm Management
- energy/+site/+area/+system/+meter/data            → ISA-50 Energy Management

Output: UNS/Enterprise/{enterprise}/Site/{site}/...
```

**🏭 Real-World Benefits:**
- **Enterprise Integration**: Single namespace for all manufacturing systems
- **Standard Compliance**: ISA-95, ISA-88, ISA-18.2 adherence
- **Vendor Neutrality**: Consistent data model regardless of equipment vendor
- **Digital Twin Ready**: Standardized structure supports digital twin implementations
- **Analytics Enablement**: Consistent hierarchy enables enterprise-wide analytics

**👉 See [using_wildcards/03_uns_asset_routing.scf.yaml](using_wildcards/03_uns_asset_routing.scf.yaml) for complete ISA-95 compliant UNS implementation with enterprise metadata, asset classification, and standardized hierarchy transformation.**