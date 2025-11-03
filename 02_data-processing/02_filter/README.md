# Filter Rules: Conditional Message Processing

# Filter Rule Tutorial

> **Purpose**: Route messages based on conditions and filter unwanted data  
> **Prerequisites**: [Transform](../01_transform/) tutorial## What You'll Learn

By the end of this tutorial, you'll understand:
- ✅ **Basic filtering** by field values and conditions
- ✅ **Multi-condition logic** with AND, OR, and NOT operators
- ✅ **Advanced filtering** with arrays, objects, and complex data structures
- ✅ **Performance optimization** for high-throughput filtering
- ✅ **Filter chaining** combined with other processing rules

## How Filter Rules Work

Filter rules act as **intelligent gatekeepers**:

```yaml
rules:
- filter:
    expression: temperature > 85    # Boolean condition
```

**Behavior:**
- **Expression returns `true`** → Message passes through **unchanged**
- **Expression returns `false`** → Message is **discarded** (not processed further)  
- **No data modification** → Unlike transform rules, filters don't change content

**Key Point**: Filters control **which** messages get processed, not **how** they're processed.

## Step 1: Basic Field Filtering

Start with simple field value conditions - the foundation of all filtering:

```yaml
rules:
- filter:
    expression: level = "ERROR"    # Only pass ERROR level messages
```

**Common Basic Filters:**
```yaml
# Numeric comparisons
temperature > 85                  # Temperature alarms
battery_level < 20               # Low battery alerts
pressure >= 30 and pressure <= 100  # Normal operating range

# String matching  
status = "active"                # Active devices only
device_type = "sensor"           # Specific device types

# Array membership
priority in ["high", "critical"] # Important messages only
```

**Example Flow:**
- **Input 1**: `{"temperature": 90, "device": "sensor-01"}` → **Passes** (90 > 85)
- **Input 2**: `{"temperature": 70, "device": "sensor-02"}` → **Discarded** (70 ≤ 85)
- **Input 3**: `{"temperature": 95, "device": "sensor-03"}` → **Passes** (95 > 85)

### 2. Multi-Condition Logic

Combine multiple conditions for complex business rules:

```yaml
rules:
- filter:
    expression: |
      (temperature > 85 or pressure < 30) and 
      status = "operational"
```

**Logic Operators**:
- `and` - Both conditions must be true
- `or` - Either condition can be true
- `not` - Inverts the condition
- Parentheses for grouping: `(A or B) and C`

**Use Cases**: Quality control, equipment monitoring, safety checks

### 3. Advanced Scenarios

Handle complex data structures and real-world requirements:

```yaml
rules:
- filter:
    expression: |
      $count(alarms[severity = "critical"]) > 0 and
      equipment.maintenance_due = false
```

**Advanced Capabilities**:
- **Array processing**: `$count()`, `$exists()`, `$filter()`
- **Object navigation**: `equipment.status`, `config.settings.enabled`
- **Context variables**: `$context.topic` for wildcard subscriptions
- **Mathematical functions**: `$average()`, `$sum()`, `$abs()`

**Use Cases**: Maintenance alerts, statistical analysis, multi-sensor correlation

## Filter + Transform Pattern

Combine filtering with data enrichment for intelligent processing:

```yaml
rules:
- filter:
    expression: temperature > 95 or oil_pressure < 30
- transform:
    expression: |
      {
        "alert_type": "maintenance_required",
        "severity": temperature > 100 ? "critical" : "warning",
        "original_data": $
      }
```

**Benefits**: Filter first for efficiency, then add intelligence and context

## Performance Tips

- **Start simple**: Use basic patterns for high-frequency data
- **Filter early**: Place filters before transforms in rule chains
- **Test expressions**: Verify logic with sample data before deployment
- **Optimize order**: Put fastest filters first in complex chains

## Examples in This Folder

See `service.scf.yaml` for working implementations:
- Basic field filtering
- Numeric range checks  
- Complex multi-condition logic
- Array and object processing
- Filter + transform combinations
