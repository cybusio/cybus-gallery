# Parse Rules: String and Format Processing

**Purpose**: Learn how to extract structured data from strings, binary data, and complex formats  
**Focus**: Regular expressions and format parsing  
**Prerequisites**: [Transform Rules](../01_transform/) and basic understanding of data formats

## What You'll Learn

By the end of this tutorial, you'll understand:
- ✅ **String parsing** with regular expressions and text manipulation
- ✅ **Binary data processing** for industrial protocols  
- ✅ **CSV and delimited format** extraction
- ✅ **Legacy system integration** through format conversion
- ✅ **Edge computing patterns** with endpoint-level parsing

## Core Concept: Edge Data Processing

Parse rules applied directly at endpoints enable **edge computing** by transforming data at the source:
- **Input**: Binary data, strings, encoded payloads from industrial protocols
- **Process**: Apply format-specific parsing logic at endpoint level
- **Output**: Processed JSON data ready for transmission or storage
- **Benefits**: Reduced network traffic, independent operation, immediate processing

**Key Point**: Edge parsing processes data at the source endpoint, eliminating the need for downstream raw data handling.

> **Alternative Approach**: While parse rules can also be applied in mappings (downstream processing), this is less common in modern implementations. Edge parsing at endpoints is preferred for better performance, reduced network traffic, and independent operation. The examples in this guide focus on the recommended edge parsing approach.

## Why Parse Rules Are Essential with Endpoints

Many industrial protocols and connectors deliver **raw unparsed data**:

### **Common Sources of Raw Data**:
- **Modbus TCP/RTU**: Delivers raw register bytes (not JSON)
- **S7 Connector**: PLC memory blocks as binary data
- **Serial/TCP Connectors**: Raw protocol frames
- **OPC-UA**: Some data types come as binary blobs
- **MQTT**: IoT devices sending hex payloads
- **Custom TCP**: Industrial equipment with proprietary formats

### **Edge Processing Flow**:
```
┌─────────────┐    ┌──────────────────────────────┐    ┌──────────────┐
│   Protocol  │───▶│     Endpoint (Edge)          │───▶│   Broker     │
│ (Raw Data)  │    │ Parse → Transform → Output   │    │ (JSON Data)  │
└─────────────┘    └──────────────────────────────┘    └──────────────┘
```

**Traditional Approach**: Raw data → Network → Centralized processing  
**Edge Approach**: Raw data → Local processing → Processed data → Network

## Independent Edge Parsing Examples

### Level 1: Basic String Parsing - CSV Sensor Data

**Goal**: Parse CSV strings directly at endpoint level

```yaml
# Independent endpoint with edge parsing
csv_sensor_endpoint:
  type: Cybus::Endpoint
  properties:
    protocol: Mqtt
    connection: !ref mqtt_connection
    subscribe:
      topic: 'sensors/csv/raw'
    rules:
    - parse:
        format: utf8      # Convert MQTT payload bytes to string
    - transform:
        expression: |
          {
            "sensor": $split($, ',')[0],
            "value": $number($split($, ',')[1]),
            "timestamp": $now()
          }
```

**Edge Processing Result**:
- **Input**: Raw MQTT bytes → `[0x54,0x45,0x4D,0x50,0x30,0x31,0x2C,0x32,0x33,0x2E,0x35]`
- **Parse**: UTF-8 string → `"TEMP01,23.5"`
- **Transform**: JSON structure → `{"sensor": "TEMP01", "value": 23.5, "timestamp": "..."}`
- **Output**: Processed data ready for transmission

**Edge Computing Benefits**:
- **Immediate processing**: Data transformed at source
- **Reduced bandwidth**: Only processed JSON transmitted
- **Independent operation**: No downstream dependencies
- **Real-time filtering**: Invalid data handled at edge

### Level 2: Binary Numeric Parsing - Modbus Temperature

**Goal**: Parse binary register data directly at endpoint level

```yaml
# Independent Modbus endpoint with edge parsing
modbus_temperature_endpoint:
  type: Cybus::Endpoint
  properties:
    protocol: Modbus
    connection: !ref modbus_connection
    subscribe:
      fc: 3                    # Function code 3 (read holding registers)
      address: 40001           # Register address
      length: 1                # Read 1 register
    rules:
    - parse:
        format: int16BE        # Parse register as 16-bit big-endian integer
    - transform:
        expression: $ / 10     # Scale value (800 → 80.0°C)
```

**Edge Processing Result**:
- **Input**: Raw Modbus bytes → `[0x03,0x20]`
- **Parse**: 16-bit integer → `800`
- **Transform**: Scaled value → `80.0`
- **Output**: Temperature value ready for use

**Common Numeric Formats**:
```yaml
# Boolean
boolean    # First byte interpreted as boolean (0=false, non-zero=true)

# Floating Point
floatBE    # 32-bit big-endian float
floatLE    # 32-bit little-endian float
doubleBE   # 64-bit big-endian double
doubleLE   # 64-bit little-endian double

# Signed Integers
int8       # 8-bit signed (-128 to 127)
int16BE    # 16-bit big-endian signed
int16LE    # 16-bit little-endian signed
int32BE    # 32-bit big-endian signed
int32LE    # 32-bit little-endian signed

# Unsigned Integers  
uint8      # 8-bit unsigned (0 to 255)
uint16BE   # 16-bit big-endian unsigned
uint16LE   # 16-bit little-endian unsigned
uint32BE   # 32-bit big-endian unsigned
uint32LE   # 32-bit little-endian unsigned

# String Formats
utf8       # UTF-8 string
ascii      # ASCII string  
latin1     # Latin-1 string (ISO-8859-1)
json       # JSON string parsing

# Encoding Formats
toBase64   # Plain text to base64 string
fromBase64 # Base64 string to plain text
```

**Use Cases**:
- **Modbus TCP/RTU**: Register values come as raw bytes
- **S7 Connector**: PLC data blocks need parsing
- **OPC-UA**: Some data types delivered as binary
- **Industrial sensors**: Direct binary measurements

### Level 3: Integer Format Variations - S7 Counter Values

**Goal**: Handle big-endian unsigned integers directly at endpoint level

```yaml
# Independent S7 endpoint with edge parsing
s7_counter_endpoint:
  type: Cybus::Endpoint
  properties:
    protocol: S7
    connection: !ref s7_connection
    subscribe:
      address: 'DB1.DBW0'    # Data block 1, word 0
      length: 2              # 2 bytes for uint16
    rules:
    - parse:
        format: uint16BE     # Parse S7 data as unsigned 16-bit big-endian
    - transform:
        expression: |
          {
            "counter": $,
            "plc_type": "s7",
            "timestamp": $now()
          }
```

**Edge Processing Result**:
- **Input**: Raw S7 bytes → `[0x01,0x00]`
- **Parse**: Unsigned integer → `256` (big-endian interpretation)
- **Transform**: Structured data → `{"counter": 256, "plc_type": "s7", "timestamp": "..."}`
- **Output**: Production counter ready for monitoring

**Endianness Considerations**:
- **Big-Endian (BE)**: Most significant byte first (Siemens S7, Modbus)
- **Little-Endian (LE)**: Least significant byte first (Allen Bradley, Intel)
- **Critical**: Wrong endianness gives incorrect values (256 vs 1 for same bytes)

### Level 4: Multi-Sensor Data Parsing - S7 Sensor Array

**Goal**: Parse multi-sensor data blocks directly at endpoint level

```yaml
# Independent S7 endpoint with multi-sensor parsing
s7_multisensor_endpoint:
  type: Cybus::Endpoint
  properties:
    protocol: S7
    connection: !ref s7_connection
    subscribe:
      address: 'DB2.DBW0'    # Temperature sensor block
      length: 20             # 20 bytes for 10 sensors
    rules:
    - parse:
        format: int16BE      # Parse first sensor value as 16-bit big-endian
    - transform:
        expression: |
          {
            "temperature": $ / 100,
            "sensor_block": "DB2",
            "status": "active"
          }
```

**Edge Processing Result**:
- **Input**: Raw S7 bytes → `[0x09,0xC4, 0x0A,0x28, 0x09,0xF6, ...]` (20 bytes)
- **Parse**: First sensor → `2500` (int16BE from first 2 bytes)
- **Transform**: Scaled value → `{"temperature": 25.0, "sensor_block": "DB2", "status": "active"}`
- **Output**: First sensor data ready for monitoring

**Multi-Value Parsing Approaches**:
- **Single value**: Parse first sensor from data block
- **Separate endpoints**: Individual endpoints per sensor
- **Wildcard topics**: Multiple messages for different sensors
- **Sequential processing**: Chain multiple parse/transform steps

### Level 5: Base64 String Processing - Text Message Parsing

**Goal**: Convert base64 encoded strings to plain text at endpoint level

```yaml
# Independent endpoint with base64 text parsing
lorawan_endpoint:
  type: Cybus::Endpoint
  properties:
    protocol: Mqtt
    connection: !ref mqtt_connection
    subscribe:
      topic: 'lorawan/+/uplink'
    rules:
    - parse:
        format: fromBase64    # Parse base64 encoded string to plain text
    - transform:
        expression: |
          {
            "device": $split($context.topic, '/')[1],
            "payload": $,
            "length": $length($),
            "decoded": "base64_to_text"
          }
```

**Edge Processing Result**:
- **Input**: Base64 string → `"SGVsbG8gV29ybGQ="`
- **Parse**: Plain text → `"Hello World"`
- **Transform**: Structured data → `{"device": "DEV001", "value": "Hello World", "length": 11}`
- **Output**: Processed text message ready for handling

**Common Sources**:
- **IoT Devices**: Base64-encoded text messages via MQTT
- **API Integration**: Base64 content from REST APIs
- **Email/Messaging**: Base64-encoded text payloads
- **Legacy Systems**: Text data encoded for binary transmission

### Level 6: Multi-Protocol Edge Parsing - OPC-UA Float Values

**Goal**: Parse IEEE 754 float values directly at endpoint level

```yaml
# Independent OPC-UA endpoint with edge parsing
opcua_temperature_endpoint:
  type: Cybus::Endpoint
  properties:
    protocol: Opcua
    connection: !ref opcua_connection
    subscribe:
      nodeId: 'ns=2;i=1001'    # Temperature node
    rules:
    - parse:
        format: floatBE        # Parse OPC-UA float as 32-bit big-endian
    - transform:
        expression: |
          {
            "temperature": $,
            "unit": "celsius",
            "source": "opcua"
          }
```

**Edge Processing Result**:
- **Input**: Raw OPC-UA bytes → `[0x42,0x20,0x00,0x00]`
- **Parse**: IEEE 754 float → `40.0`
- **Transform**: Structured data → `{"temperature": 40.0, "unit": "celsius", "source": "opcua"}`
- **Output**: High-precision temperature ready for monitoring

**Multi-Protocol Edge Benefits**:
- **Protocol-specific parsing**: Each endpoint handles its own format
- **Independent operation**: No cross-protocol dependencies  
- **Optimized processing**: Format parsing at source
- **Unified output**: Consistent JSON structure despite different inputs

### Level 7: JSON API Integration - HTTP Data Parsing

**Goal**: Parse JSON responses directly at endpoint level

```yaml
# Independent HTTP endpoint with edge parsing
http_api_endpoint:
  type: Cybus::Endpoint
  properties:
    protocol: Http
    connection: !ref http_connection
    subscribe:
      path: '/api/sensors'
      method: post
    rules:
    - parse:
        format: json         # Parse JSON response from HTTP API
    - transform:
        expression: |
          {
            "sensors": $.data,
            "api_status": $.status,
            "timestamp": $now()
          }
```

**Edge Processing Result**:
- **Input**: JSON string → `'{"data": [{"id": 1, "value": 23.5}], "status": "ok"}'`
- **Parse**: JSON object → `{"data": [...], "status": "ok"}`
- **Transform**: Restructured data → `{"sensors": [...], "api_status": "ok", "timestamp": "..."}`
- **Output**: API data ready for integration

**Advanced Edge Techniques**:
- **Sequential processing**: Chain multiple parse/transform steps
- **Data validation**: Use transform for format checking
- **Metadata extraction**: Add context and timestamps
- **Error handling**: Process malformed data at edge

## Parse Rule Parameters Reference

### **Required Parameter**:
- `format` - Specifies the input data format (enum type)

### **Officially Supported Formats** (Cybus v1.9.0):

#### **Text Formats**:
```yaml
format: json           # Parse JSON strings  
format: utf8           # Parse as UTF-8 text
format: latin1         # Parse as Latin-1 text
format: ascii          # Parse as ASCII text
```

#### **Binary Integer Formats**:
```yaml
format: int8           # Signed 8-bit integer
format: int16BE        # Signed 16-bit big-endian
format: int16LE        # Signed 16-bit little-endian  
format: int32BE        # Signed 32-bit big-endian
format: int32LE        # Signed 32-bit little-endian
format: uint8          # Unsigned 8-bit integer
format: uint16BE       # Unsigned 16-bit big-endian
format: uint16LE       # Unsigned 16-bit little-endian
format: uint32BE       # Unsigned 32-bit big-endian
format: uint32LE       # Unsigned 32-bit little-endian
```

#### **Binary Float Formats**:
```yaml
format: floatBE        # 32-bit float big-endian
format: floatLE        # 32-bit float little-endian
format: doubleBE       # 64-bit double big-endian
format: doubleLE       # 64-bit double little-endian
```

#### **Encoding Formats**:
```yaml
format: toBase64       # Convert binary to base64 string
format: fromBase64     # Convert base64 string to binary
```

#### **Boolean Format**:
```yaml
format: boolean        # Parse as boolean value
```

### **Important Notes**:
- **Officially Supported**: Only the formats listed above are supported
- **No Buffer Operations**: `fromBase64` produces plain text, not binary buffers
- **Version Compatibility**: Always verify format support in your Cybus version
- **Edge Processing**: All examples show parsing at endpoint level

## Critical Error Handling

### **Parse Failures**
Parse rules can fail when:
- **Format mismatch**: Wrong format for data type
- **Insufficient data**: Not enough bytes for specified format
- **Invalid encoding**: Malformed UTF-8, invalid base64, etc.
- **Null/empty payload**: No data to parse

### **Error Handling Strategies**
```yaml
# Resilient parsing with error handling
rules:
- parse:
    format: utf8
- transform:
    expression: |
      $exists($) and $length($) > 0 ? 
      {"data": $, "parsed": true} : 
      {"error": "Parse failed", "parsed": false}
```

### **Production Considerations**
- **Always validate**: Check parse results before processing
- **Graceful degradation**: Handle parse failures without stopping service
- **Logging**: Log parse failures for debugging
- **Fallback strategies**: Alternative processing paths for failed parsing

## When to Use Each Edge Parsing Level

### **Level 1 (UTF-8 String)**: Text Data Processing
- ✅ **CSV sensor data from MQTT**
- ✅ **Text-based IoT protocols**
- ✅ **Log data parsing**
- ❌ Binary industrial protocols

### **Level 2 (Binary Numeric)**: Industrial Register Data
- ✅ **Modbus temperature registers**
- ✅ **PLC data values**
- ✅ **Sensor measurements**
- ❌ Text-based data

### **Level 3 (Integer Endianness)**: Counter and Status Data
- ✅ **S7 production counters**
- ✅ **Status word parsing**
- ✅ **Multi-byte integers**
- ❌ Floating-point measurements

### **Level 4 (Multi-Sensor)**: Data Block Processing
- ✅ **S7 sensor arrays**
- ✅ **Multi-channel data**
- ✅ **Batch sensor readings**
- ❌ Single value processing

### **Level 5 (Base64 Text)**: Encoded Message Processing
- ✅ **Base64 text payloads**
- ✅ **API text responses**
- ✅ **Encoded IoT messages**
- ❌ Binary data parsing

### **Level 6 (Float Values)**: High-Precision Data
- ✅ **OPC-UA measurements**
- ✅ **Scientific instruments**
- ✅ **Precision sensors**
- ❌ Integer-only data

### **Level 7 (JSON API)**: Structured Data Integration
- ✅ **REST API responses**
- ✅ **JSON message parsing**
- ✅ **Web service integration**
- ❌ Binary protocol data

## Best Practices

### **Format Selection**
1. **Know your data source**: Understand the exact format
2. **Check endianness**: BE for network protocols, LE for Intel systems
3. **Validate with samples**: Test parsing with known data
4. **Handle errors**: Plan for malformed data

### **Performance Optimization**
1. **Simple formats first**: Use basic formats when possible
2. **Avoid excessive nesting**: Complex parsing is slower
3. **Batch processing**: Parse arrays efficiently
4. **Cache format decisions**: Minimize conditional evaluation

### **Error Handling**
1. **Format mismatches**: Wrong format causes parse failures
2. **Length validation**: Ensure sufficient data for format
3. **Endianness errors**: Wrong byte order produces wrong values
4. **Encoding issues**: String encoding mismatches

### **Integration Patterns**
1. **Parse → Transform**: Convert format, then process logic
2. **Multi-stage parsing**: Header → payload → validation
3. **Protocol validation**: Check checksums and magic numbers
4. **Error propagation**: Handle parse failures gracefully

## Common Format Combinations

### **Modbus Integration**:
```yaml
# Modbus register (16-bit unsigned)
- parse: {format: uint16BE}
# Scale and validate
- transform: {expression: "$ / 100"}
```

### **Base64 Text Processing**:
```yaml
# Base64 payload to plain text
- parse: {format: fromBase64}
# Add metadata and processing info
- transform: {expression: "{payload: $, decoded: true, timestamp: $now()}"}
```

### **Multi-Protocol Edge Setup**:
```yaml
# Independent endpoints for each protocol
modbus_endpoint:
  rules: [{parse: {format: uint16BE}}]
opcua_endpoint:  
  rules: [{parse: {format: floatBE}}]
```

## Performance and Optimization

### **Format Selection Guidelines**
1. **Choose the most specific format**: Don't use `utf8` for binary data
2. **Consider data size**: Large payloads take longer to parse
3. **Endianness matters**: Wrong endianness can cause significant performance degradation
4. **Validate early**: Parse failures are expensive, validate input when possible

### **Edge Computing Benefits**
- **Reduced Network Traffic**: Only processed data is transmitted
- **Lower Latency**: Processing happens at source, no round-trip delays
- **Independent Operation**: Endpoints work without downstream dependencies
- **Resource Efficiency**: Distribute processing load across edge devices

### **Common Pitfalls**
1. **Format Mismatches**: Using `int16BE` on 4-byte data
2. **Endianness Confusion**: Mixing big-endian and little-endian formats
3. **Base64 Assumptions**: Expecting binary output from `fromBase64`
4. **Missing Error Handling**: Not planning for parse failures
5. **Over-parsing**: Using complex formats when simple ones suffice

## Configuration Reference

See `service.scf.yaml` for complete independent edge parsing examples:
- `csv_sensor_endpoint` (Level 1) - UTF-8 string parsing
- `modbus_temperature_endpoint` (Level 2) - Binary integer parsing  
- `s7_counter_endpoint` (Level 3) - Unsigned integer parsing
- `s7_multisensor_endpoint` (Level 4) - Multi-sensor data parsing
- `lorawan_endpoint` (Level 5) - Base64 text parsing
- `opcua_temperature_endpoint` (Level 6) - Float value parsing
- `http_api_endpoint` (Level 7) - JSON parsing
- `resilient_parsing_endpoint` (Bonus) - Error handling example

Each endpoint demonstrates independent edge processing with parse rules applied directly at the source.
