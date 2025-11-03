# Stash Rule Tutorial

> **Purpose**: Store message data to access it in future messages for trend analysis and comparisons  
> **Prerequisites**: [Transform](../01_transform/) tutorial

## What You'll Learn

The `stash` rule is your **memory between messages**. Perfect for:
- 📈 Trend analysis (comparing current vs previous values)
- ⚡ Change detection and alerting
- 🔄 State tracking across message flows
- 📊 Rate calculations and derivatives

**Key Concept**: Stash stores the **complete payload** from the previous step, not individual fields.

## Step-by-Step Examples

### Step 1: Basic Temperature Comparison

**Concept**: Compare current temperature reading with the previous one.

```yaml
rules:
- transform:
    expression: |
      {
        "current_temp": $.temperature,
        "previous_temp": $last("tempHistory") ? $last("tempHistory").temperature : null,
        "change": $last("tempHistory") ? 
                   $.temperature - $last("tempHistory").temperature : 0,
        "sensor": $.sensor
      }
- stash:
    label: tempHistory    # Store complete message for next time
```

**Message Flow:**
```
Message 1: {"temperature": 25, "sensor": "room-01"}
→ Output: {"current_temp": 25, "previous_temp": null, "change": 0}
→ Stashed: {"temperature": 25, "sensor": "room-01"}

Message 2: {"temperature": 27, "sensor": "room-01"}  
→ Output: {"current_temp": 27, "previous_temp": 25, "change": 2}
→ Stashed: {"temperature": 27, "sensor": "room-01"}

Message 3: {"temperature": 24, "sensor": "room-01"}
→ Output: {"current_temp": 24, "previous_temp": 27, "change": -3}
```

### Step 2: Stash Positioning - When Order Matters

**Option A: Stash First (store raw input)**
```yaml
rules:
- stash:
    label: rawData        # Store original input first
- transform:
    expression: |
      {
        "current": $.temperature,
        "previous": $last("rawData") ? $last("rawData").temperature : null
      }
```

**Option B: Stash Last (store processed result)**
```yaml
rules:
- transform:
    expression: |
      {
        "current": $.temperature,
        "previous": $last("processed") ? $last("processed").current : null,
        "sensor": $.sensor
      }
- stash:
    label: processed      # Store processed result
```

**When to use each:**
- **Stash First**: Need original raw values for comparison
- **Stash Last**: Need processed/calculated values for comparison

### Step 3: Multiple Stashes for Complex Analysis

**Concept**: Track both original input AND processed values across messages.

```yaml
rules:
# Step 1: Store original input
- stash:
    label: original
    
# Step 2: Process the data  
- transform:
    expression: |
      {
        "doubled_value": $.reading * 2,
        "sensor_name": $.sensor_id,
        "processing_time": $now()
      }

# Step 3: Compare both raw and processed history
- transform:
    expression: |
      {
        "current": {
          "raw_reading": $.reading,
          "processed_value": $.doubled_value,
          "sensor": $.sensor_name
        },
        "previous": {
          "raw_reading": $last("original") ? $last("original").reading : null,
          "processed_value": $last("processed") ? $last("processed").doubled_value : null
        },
        "comparison": {
          "raw_change": $last("original") ? 
                        $.reading - $last("original").reading : 0,
          "processed_change": $last("processed") ? 
                              $.doubled_value - $last("processed").doubled_value : 0
        }
      }

# Step 4: Store processed result for next message
- stash:
    label: processed
```

**Test with:**
```json
Message 1: {"reading": 10, "sensor_id": "S1"}
Message 2: {"reading": 15, "sensor_id": "S1"}
```

**Message 2 output:**
```json
{
  "current": {"raw_reading": 15, "processed_value": 30, "sensor": "S1"},
  "previous": {"raw_reading": 10, "processed_value": 20},
  "comparison": {"raw_change": 5, "processed_change": 10}
}
```

### Step 4: Advanced Pattern - Stateful Counter

**Concept**: Track per-device counters that persist across messages (from service example).

```yaml
# Complex pattern for per-station counting
# Each station maintains its own counter state
```

*Note: This advanced pattern combines stash with collect and complex JSONata for production scenarios.*

## Understanding Stash Storage

**CRITICAL**: Stash stores the **entire payload** from the previous rule step!

```yaml
# What actually gets stashed:
- transform:
    expression: |
      {
        "temperature": $.temp,
        "humidity": $.humidity,
        "calculated_feels_like": $.temp + ($.humidity * 0.1)
      }
- stash:
    label: myData    # Stores the COMPLETE object above
```

**Accessing stashed data:**
```yaml
# You can access any field from the complete stashed object:
$last("myData").temperature          # 25
$last("myData").humidity             # 60  
$last("myData").calculated_feels_like # 31
```

## Real-World Use Cases

### 🔥 **Alert on Significant Changes**
```yaml
- transform:
    expression: |
      $last("tempHistory") and 
      ($abs($.temperature - $last("tempHistory").temperature) > 5) ?
      {
        "alert": "Temperature spike detected!",
        "current": $.temperature,
        "previous": $last("tempHistory").temperature,
        "change": $.temperature - $last("tempHistory").temperature
      } : null
```

### 📈 **Calculate Rates**
```yaml
- transform:
    expression: |
      $last("speedHistory") ?
      {
        "speed": $.distance,
        "acceleration": ($.distance - $last("speedHistory").distance) / 
                       ($.timestamp - $last("speedHistory").timestamp)
      } : {"speed": $.distance, "acceleration": 0}
```

## Stash Patterns Comparison

| Pattern | Complexity | Use Case | When to Choose |
|---------|-----------|----------|---------------|
| **Single Stash** | ⭐⭐ | Compare current vs previous | Simple trend analysis |
| **Stash First** | ⭐⭐ | Need raw input history | Original data comparison |  
| **Stash Last** | ⭐⭐ | Need processed result history | Calculated value trends |
| **Multiple Stashes** | ⭐⭐⭐ | Need BOTH raw AND processed | Complex analysis scenarios |

## Key Concepts

- 🧠 **Memory Between Messages**: Access data from previous messages
- 📦 **Complete Payload Storage**: Entire rule step output gets stored
- 🔄 **Per-Topic Storage**: Each subscription topic has separate stash storage
- ⏰ **First Message**: `$last("label")` returns `null` for first message

## Next Steps

- **Combine**: Use with [SetContextVars](../05_setContextVars/) for dynamic routing
- **Advanced**: Try [Collect](../07_collect/) for gathering multiple values
- **Integration**: [Complete Rule Chain Example](../complete_rule_chain_example.scf.yaml)
