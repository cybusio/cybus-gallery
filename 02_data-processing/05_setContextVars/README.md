# SetContextVars Rule Tutorial

> **Purpose**: Extract values from messages and store them as variables for dynamic routing and processing  
> **Prerequisites**: [Transform](../01_transform/) and [Filter](../02_filter/) tutorials

## What You'll Learn

The `setContextVars` rule is your tool for **extracting data once and using it everywhere**. Perfect for:
- 🎯 Dynamic topic routing based on message content
- 📊 Multi-tenant data routing 
- ⚡ Alert systems with priority-based routing
- 🔧 Reducing complex JSONata repetition

## Step-by-Step Examples

### Step 1: Basic Variable Extraction

**Concept**: Extract device information and use it in message transformation.

```yaml
rules:
- setContextVars:
    vars:
      deviceName: $.device.name      # Extract and store device name
      location: $.device.location    # Extract and store location
      sensorType: $.sensor.type      # Extract and store sensor type
- transform:
    expression: |
      {
        "device_info": {
          "name": $context.vars.deviceName,
          "location": $context.vars.location,
          "type": $context.vars.sensorType
        },
        "reading": $.value,
        "message": "Device " & $context.vars.deviceName & " at " & $context.vars.location
      }
```

**Test with this data:**
```json
{
  "device": {"name": "sensor-01", "location": "warehouse"},
  "sensor": {"type": "temperature"},
  "value": 23.5
}
```

**You get:**
```json
{
  "device_info": {
    "name": "sensor-01",
    "location": "warehouse", 
    "type": "temperature"
  },
  "reading": 23.5,
  "message": "Device sensor-01 at warehouse"
}
```

### Step 2: Dynamic Topic Routing

**Concept**: Use extracted variables to build publish topics dynamically.

```yaml
mappings:
- subscribe:
    topic: sensors/incoming
  publish:
    topic: 'devices/{deviceName}/{location}/processed'  # Variables in topic!
  rules:
  - setContextVars:
      vars:
        deviceName: $.device.name
        location: $.device.location
  - transform:
      expression: |
        {
          "routed_to": "devices/" & $context.vars.deviceName & "/" & $context.vars.location & "/processed",
          "device": $context.vars.deviceName,
          "location": $context.vars.location,
          "data": $
        }
```

**Test with:**
```json
{
  "device": {"name": "temp-sensor-03", "location": "factory-floor"},
  "reading": {"temperature": 28.7, "humidity": 65}
}
```

**Routes to topic:** `devices/temp-sensor-03/factory-floor/processed`

### Step 3: Conditional Variables with Alert Routing

**Concept**: Create variables with conditional logic for smart alert routing.

```yaml
mappings:
- subscribe:
    topic: temperature/readings
  publish:
    topic: 'alerts/{priority}/temperature'
  rules:
  - setContextVars:
      vars:
        priority: |
          $.temperature > 30 ? "high" : 
          $.temperature > 20 ? "normal" : "low"
        status: |
          $.temperature > 40 ? "critical" : 
          $.temperature < 10 ? "warning" : "ok"
  - transform:
      expression: |
        {
          "temperature": $.temperature,
          "priority": $context.vars.priority,
          "status": $context.vars.status,
          "needs_attention": $context.vars.status != "ok"
        }
```

**Test Case A - Normal temp (25°C):**
- Variables: `priority = "normal"`, `status = "ok"`
- Routes to: `alerts/normal/temperature`

**Test Case B - High temp (42°C):**
- Variables: `priority = "high"`, `status = "critical"` 
- Routes to: `alerts/high/temperature`

### Step 4: Multi-Tenant Routing

**Concept**: Route messages to tenant-specific topics automatically.

```yaml
mappings:
- subscribe:
    topic: app/events
  publish:
    topic: 'tenants/{tenant}/events/{eventType}'
  rules:
  - setContextVars:
      vars:
        tenant: $.organization.id
        eventType: $.event.type
  - transform:
      expression: |
        {
          "tenant_id": $context.vars.tenant,
          "event_type": $context.vars.eventType,
          "event_data": $
        }
```

**Test with:**
```json
{
  "organization": {"id": "acme-corp", "name": "ACME Corporation"},
  "event": {"type": "user-login", "user_id": "john.doe"},
  "metadata": {"source": "web-app"}
}
```

**Routes to:** `tenants/acme-corp/events/user-login`

## Real-World Benefits

**Before setContextVars (repetitive and error-prone):**
```yaml
- transform:
    expression: |
      {
        "device": $.device.name,  # Repeated extraction
        "topic": "devices/" & $.device.name & "/" & $.device.location & "/data",  # Long expression
        "alert_level": $.temperature > 30 ? "high" : "normal"  # Repeated logic
      }
# More rules with the same repeated expressions...
```

**After setContextVars (clean and maintainable):**
```yaml
- setContextVars:
    vars:
      deviceName: $.device.name
      location: $.device.location 
      alertLevel: $.temperature > 30 ? "high" : "normal"
# Now use simple $context.vars.deviceName everywhere!
```

## Key Concepts

- 🎯 **Extract Once, Use Many**: Store complex expressions as simple variables
- 🚀 **Dynamic Topics**: Build publish topics from message data
- 🧠 **Smart Routing**: Route based on calculated conditions
- 🔧 **Clean Code**: Eliminate repetitive JSONata expressions

## Next Steps

- **Advanced**: Try [Collect](../07_collect/) to gather multiple values
- **Integration**: Combine with [Stash](../04_stash/) for temporary data storage
- **Explore**: [Complete Rule Chain Example](../complete_rule_chain_example.scf.yaml)
