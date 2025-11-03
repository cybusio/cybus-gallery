# COV (Change of Value) Rule Tutorial

> **Purpose**: Filter messages to only pass significant value changes, reducing noise and data traffic  
> **Prerequisites**: [Transform](../01_transform/) and [Filter](../02_filter/) tutorials

## What You'll Learn

The `cov` (Change of Value) rule is your **smart data filter**. Perfect for:
- 🎯 Reducing data noise by 60-80% while keeping important changes
- 📊 Monitoring state changes (running → stopped → error)
- 🌡️ Temperature/pressure filtering with deadband thresholds
- ⚡ Preventing spam from noisy sensors

**Key Concept**: Only forward messages when monitored fields change significantly.

## Step-by-Step Examples

### Step 1: Basic State Change Monitoring

**Concept**: Only pass messages when machine state actually changes.

```yaml
rules:
- cov:
    key: state    # Monitor the 'state' field for any change
```

**Test sequence:**
```
Input 1: {"state": "running", "speed": 1800}   → PASSES (first message)
Input 2: {"state": "running", "speed": 1820}   → FILTERED (state unchanged) 
Input 3: {"state": "stopped", "speed": 0}      → PASSES (state changed)
Input 4: {"state": "stopped", "speed": 0}      → FILTERED (state unchanged)
Input 5: {"state": "error", "speed": 0}        → PASSES (state changed)
```

**Result**: Only 3 messages pass instead of 5 (40% reduction)

### Step 2: Temperature Filtering with Absolute Deadband

**Concept**: Filter noisy temperature readings - only pass changes ≥ 0.5°C.

```yaml
rules:
- cov:
    key: temperature        # Monitor 'temperature' field
    deadband: 0.5          # Must change by ±0.5 to pass through
    deadbandMode: absolute # Fixed threshold (not percentage)
```

**Test sequence:**
```
Input: 22.0°C → 22.1°C → 22.3°C → 22.6°C → 22.8°C → 21.9°C

22.0°C → PASSES (first message always passes)
22.1°C → FILTERED (change = 0.1 < 0.5)
22.3°C → FILTERED (total change from 22.0 = 0.3 < 0.5)  
22.6°C → PASSES (change from 22.0 = 0.6 > 0.5)
22.8°C → FILTERED (change from 22.6 = 0.2 < 0.5)
21.9°C → PASSES (change from 22.6 = 0.7 > 0.5)
```

**Result**: Only 3 messages pass instead of 6 (50% reduction)

### Step 3: Pressure Monitoring with Relative Deadband

**Concept**: Filter pressure based on percentage change instead of fixed values.

```yaml
rules:
- cov:
    key: pressure_bar
    deadband: 5            # 5% change required
    deadbandMode: relative # Percentage-based threshold
```

**Test sequence:**
```
Input: 100 bar → 102 bar → 106 bar → 108 bar

100 bar → PASSES (first message)
102 bar → FILTERED (2% change < 5%)
106 bar → PASSES (6% change > 5%)  
108 bar → FILTERED (1.9% change from 106 < 5%)
```

**Why relative mode?** High-value sensors need proportional thresholds - 5% of 1000 bar (50 bar) vs 5% of 10 bar (0.5 bar).

### Step 4: Multiple Field Monitoring

**Concept**: Monitor changes across multiple sensor fields efficiently.

```yaml
mappings:
# Monitor temperature changes
- subscribe: {topic: "sensors/temp"}
  publish: {topic: "filtered/temp"}  
  rules:
  - cov: {key: temperature, deadband: 0.5, deadbandMode: absolute}

# Monitor pressure changes  
- subscribe: {topic: "sensors/pressure"}
  publish: {topic: "filtered/pressure"}
  rules:
  - cov: {key: pressure, deadband: 3, deadbandMode: relative}

# Monitor state changes
- subscribe: {topic: "machine/status"}  
  publish: {topic: "filtered/status"}
  rules:
  - cov: {key: state}  # No deadband = any change passes
```
## COV Parameters

| Parameter | Required | Purpose | Example Values |
|-----------|----------|---------|----------------|
| **key** | ✅ Yes | Field to monitor for changes | `temperature`, `state`, `pressure` |
| **deadband** | ⬜ Optional | Change threshold (omit for exact match) | `0.5`, `5`, `0.01` |
| **deadbandMode** | ⬜ Optional | How to apply deadband | `absolute` or `relative` |

**Deadband modes:**
- **absolute**: Fixed threshold (e.g., ±0.5°C, ±10 bar)
- **relative**: Percentage threshold (e.g., 5% change)

## Real-World Use Cases

### 🏭 **Industrial Applications**
```yaml
# Machine monitoring - only alert on state changes
- cov: {key: machine_state}

# Temperature control - filter ±0.5°C noise  
- cov: {key: temperature, deadband: 0.5, deadbandMode: absolute}

# Pressure systems - 3% change threshold
- cov: {key: pressure_psi, deadband: 3, deadbandMode: relative}
```

### 📊 **Data Optimization Benefits**
- **Before COV**: 1000 noisy sensor readings per minute
- **After COV**: 200-300 meaningful changes per minute
- **Result**: 70% reduction in data processing and storage

### ⚡ **Performance Comparison**

| Data Type | Without COV | With COV | Reduction |
|-----------|-------------|----------|-----------|
| Noisy temperature | 100 msg/min | 20 msg/min | 80% |
| Machine states | 50 msg/min | 5 msg/min | 90% |
| Pressure readings | 200 msg/min | 60 msg/min | 70% |

## Key Concepts

- 🎯 **Smart Filtering**: Only forward significant value changes
- 📉 **Noise Reduction**: Filter out sensor noise and small fluctuations  
- ⚡ **Traffic Optimization**: Reduce message volume by 60-80%
- 🔄 **State Monitoring**: Track important system state transitions

## Next Steps

- **Combine**: Use with [Stash](../04_stash/) to compare change magnitude
- **Advanced**: Try [Collect](../07_collect/) for gathering filtered changes
- **Integration**: [Complete Rule Chain Example](../complete_rule_chain_example.scf.yaml)