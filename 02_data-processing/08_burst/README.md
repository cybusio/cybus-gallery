# Burst Rule Tutorial

> **Purpose**: Batch multiple messages into arrays for efficient bulk processing and reduced network traffic  
> **Prerequisites**: [Transform](../01_transform/) and [Collect](../07_collect/) tutorials

## What You'll Learn

The `burst` rule consolidates multiple messages into **single array messages**. Perfect for:
- 📦 Batching high-frequency sensor data for efficient processing
- 🚀 Reducing network traffic by 60-80%
- ⏱️ Time-based data aggregation (every N seconds)
- 📊 Size-based batching (every N messages)

**Key Concept**: Triggers on **OR logic** - whichever condition is met first.

## Step-by-Step Examples

### Step 1: Size-Based Batching (High-Frequency Data)

**Concept**: Collect exactly N messages, then burst immediately.

```yaml
rules:
- burst:
    maxSize: 3  # Burst after collecting exactly 3 messages
```

**Perfect for**: Fast sensors with predictable data rates (100+ messages/second).

**Timeline:**
```
t=0ms:   {"value": 23.1, "timestamp": "10:00:00.100Z"}  → Buffer: [msg1]
t=100ms: {"value": 23.2, "timestamp": "10:00:00.200Z"}  → Buffer: [msg1, msg2]  
t=200ms: {"value": 23.3, "timestamp": "10:00:00.300Z"}  → BURST! Output:
[
  {"value": 23.1, "timestamp": "10:00:00.100Z"},
  {"value": 23.2, "timestamp": "10:00:00.200Z"},
  {"value": 23.3, "timestamp": "10:00:00.300Z"}
]
```

**Benefits**: Immediate processing once batch is full, perfect for steady streams.

### Step 2: Time-Based Batching (Sporadic Data)

**Concept**: Wait for a time period, then burst whatever messages arrived.

```yaml
rules:
- burst:
    interval: 2000  # Burst every 2 seconds
```

**Perfect for**: Irregular data that needs regular processing.

**Timeline:**
```
t=0ms:    {"value": 1013.2} arrives  → Buffer: [msg1]
t=500ms:  {"value": 1013.1} arrives  → Buffer: [msg1, msg2]
t=1200ms: {"value": 1013.0} arrives  → Buffer: [msg1, msg2, msg3]
t=2000ms: Timer triggers → BURST! Output:
[
  {"value": 1013.2},
  {"value": 1013.1}, 
  {"value": 1013.0}
]

t=2000ms: Buffer resets → Buffer: []
```

**Benefits**: Guarantees regular output even with irregular input timing.

### Step 3: Adaptive Batching (Mixed Traffic)

**Concept**: Use BOTH size AND time limits - whichever comes first triggers the burst.

```yaml
rules:
- burst:
    maxSize: 5      # Burst after 5 messages OR
    interval: 3000  # Burst after 3 seconds
```

**Test Case A - High Traffic (size limit hit first):**
```
5 messages arrive in 1 second → Bursts at 1s with 5 messages
```

**Test Case B - Low Traffic (time limit hit first):**
```
2 messages arrive in 3 seconds → Bursts at 3s with 2 messages  
```

**Benefits**: Adapts to varying data rates automatically.

### Step 4: Burst + Transform for Analytics

**Concept**: Process batched data with statistical analysis.

```yaml
rules:
- burst:
    maxSize: 10
    interval: 5000
- transform:
    expression: |
      {
        "batch_stats": {
          "count": $count($),
          "average_temp": $average($.*.value),
          "min_temp": $min($.*.value),
          "max_temp": $max($.*.value),
          "time_span": $max($.*.timestamp) - $min($.*.timestamp)
        },
        "raw_readings": $
      }
```

**Input array:**
```json
[
  {"value": 22.1, "timestamp": 1730115600100},
  {"value": 22.3, "timestamp": 1730115600200},
  {"value": 22.0, "timestamp": 1730115600300}
]
```

**Output with analytics:**
```json
{
  "batch_stats": {
    "count": 3,
    "average_temp": 22.13,
    "min_temp": 22.0,
    "max_temp": 22.3,
    "time_span": 200
  },
  "raw_readings": [...]
}
```

## Burst Configuration Patterns

| Pattern | Configuration | Best For | Example Use Case |
|---------|--------------|----------|------------------|
| **Size Only** | `maxSize: N` | Steady high-frequency data | Production line sensors |
| **Time Only** | `interval: N` | Sporadic irregular data | Building occupancy sensors |
| **Adaptive** | Both parameters | Variable-rate data | IoT sensor networks |
| **Small Fast** | `maxSize: 5, interval: 1000` | Real-time analytics | Alert systems |
| **Large Slow** | `maxSize: 100, interval: 60000` | Bulk processing | Data warehousing |

## Real-World Benefits

### 📊 **Performance Improvement**
- **Before Burst**: Process 1000 individual messages = 1000 operations
- **After Burst**: Process 10 batches of 100 = 10 operations  
- **Result**: 99% reduction in processing overhead

### 🚀 **Network Optimization**  
- **Before**: 100 messages/second = 100 network calls
- **After**: 10 batches/second = 10 network calls
- **Result**: 90% reduction in network traffic

## Key Concepts

- 📦 **Message Batching**: Combine multiple individual messages into arrays
- ⚡ **OR Logic**: Trigger on EITHER size OR time limit (whichever comes first)
- 🎯 **Efficient Processing**: Reduce overhead through bulk operations
- ⏰ **Flexible Timing**: Adapt to both high and low traffic scenarios

## Next Steps

- **Combine**: Use with [COV](../06_cov/) to batch only significant changes
- **Advanced**: Chain with [Collect](../07_collect/) for multi-source batching
- **Integration**: [Complete Rule Chain Example](../complete_rule_chain_example.scf.yaml)
# High-frequency sensor data
{"sensorId": "temp-01", "value": 23.1, "timestamp": "2025-10-29T10:00:00.000Z"}
{"sensorId": "temp-01", "value": 23.2, "timestamp": "2025-10-29T10:00:00.100Z"}
{"sensorId": "temp-01", "value": 23.3, "timestamp": "2025-10-29T10:00:00.200Z"}

# Low-frequency sensor data  
{"sensorId": "press-01", "value": 1013.1, "timestamp": "2025-10-29T10:00:00.000Z"}
{"sensorId": "press-01", "value": 1013.2, "timestamp": "2025-10-29T10:00:02.500Z"}
```

### Output Messages
```json
# Size-triggered burst (3 messages reached maxSize=3)
[
  {"sensorId": "temp-01", "value": 23.1, "timestamp": "2025-10-29T10:00:00.000Z"},
  {"sensorId": "temp-01", "value": 23.2, "timestamp": "2025-10-29T10:00:00.100Z"},
  {"sensorId": "temp-01", "value": 23.3, "timestamp": "2025-10-29T10:00:00.200Z"}
]

# Time-triggered burst (interval=2000ms reached with only 2 messages)
[
  {"sensorId": "press-01", "value": 1013.1, "timestamp": "2025-10-29T10:00:00.000Z"},
  {"sensorId": "press-01", "value": 1013.2, "timestamp": "2025-10-29T10:00:02.500Z"}
]
```

## Configuration Best Practices

### Choosing maxSize
- **Small values (2-5)**: Low-latency processing, frequent small batches
- **Medium values (10-50)**: Balanced efficiency and latency  
- **Large values (100+)**: High-throughput processing, potential higher latency

### Choosing interval
- **Short intervals (1-5 seconds)**: Near real-time processing
- **Medium intervals (10-30 seconds)**: Regular processing cycles
- **Long intervals (60+ seconds)**: Batch processing, analytics workloads

### Combining Both
Use both parameters when:
- **Data rate varies** throughout the day
- **Need guaranteed maximum latency** (interval provides upper bound)
- **Need efficient batching** during high-traffic periods (maxSize optimizes throughput)
- **Building resilient systems** that handle both peak and off-peak loads

The complete implementation with all examples is available in the `service.scf.yaml` file in this directory.
