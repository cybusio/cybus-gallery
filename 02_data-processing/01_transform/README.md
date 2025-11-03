# Transform Rules: Manufacturing Data Processing Examples

> **Purpose**: Real-world manufacturing scenarios demonstrating data conversion & restructuring with JSONata expressions  
> **Focus**: Industrial protocols, equipment monitoring, and production system integration  
> **Prerequisites**: Basic understanding of JSON and manufacturing data flows

## Manufacturing Transform Examples

This section demonstrates transform rules through practical manufacturing scenarios, each with realistic equipment connections and industrial protocols. Every example shows complete data flows from raw sensor input to processed output for specific manufacturing use cases.

### 🏭 What You'll Learn

By working through these manufacturing examples, you'll master:
- ✅ **Sensor data standardization** for production monitoring systems
- ✅ **Equipment data enrichment** with maintenance context and validation  
- ✅ **Multi-unit conversions** for facility management and energy monitoring
- ✅ **Data restructuring** for MES integration and reporting systems
- ✅ **Conditional health assessment** for predictive maintenance workflows

### 📊 The Manufacturing Data Challenge

Industrial systems generate diverse data formats that need standardization:

```json
// ❌ Raw OPC UA sensor data (legacy field names, mixed units)
{"temp_spindle": 65, "vib_x": 2.1, "mode": 1, "hrs": 8420}

// ✅ Standardized production monitoring format  
{
  "spindle_temperature_celsius": 65,
  "vibration_x_axis_mm_s": 2.1, 
  "operational_mode": "automatic",
  "operating_hours_total": 8420,
  "equipment_status": "normal",
  "maintenance_due_hours": 580
}
```

**Solution**: Manufacturing-focused transform rules convert raw industrial data into standardized formats for enterprise systems.

## 📁 Transform Examples by Concept

Each example demonstrates a specific transform concept with realistic manufacturing data:

### [01_sensor_standardization.scf.yaml](./01_sensor_standardization.scf.yaml) - **Field Renaming**
**Concept**: Basic field mapping and value conversion
- **Raw Input**: `{"temp_spindle": 68, "spd": 2100, "mode": 1}`
- **Transformed**: `{"spindle_temperature": 68, "spindle_speed": 2100, "operational_mode": "automatic"}`
- **Key Learning**: Field renaming, value mapping, data enrichment

### [02_machine_enrichment.scf.yaml](./02_machine_enrichment.scf.yaml) - **Data Enrichment** 
**Concept**: Adding metadata, validation, and timestamps
- **Raw Input**: `[1247, 7850, 68, 1.8]` (Modbus array)
- **Transformed**: `{"cycle_count": 1247, "temperature_valid": true, "timestamp": 1730529600000}`
- **Key Learning**: Array indexing, validation logic, metadata addition

### [03_temperature_conversion.scf.yaml](./03_temperature_conversion.scf.yaml) - **Mathematical Calculations**
**Concept**: Unit conversions and mathematical operations  
- **Raw Input**: `{"temperature_f": 75.5}`
- **Transformed**: `{"fahrenheit": 75.5, "celsius": 24.17, "kelvin": 297.32}`
- **Key Learning**: Math formulas, function usage ($round), boolean evaluation

### [04_production_restructuring.scf.yaml](./04_production_restructuring.scf.yaml) - **Data Restructuring**
**Concept**: Converting flat data to hierarchical format
- **Raw Input**: `{"status": 1, "units_hour": 95, "cnc1_id": "CNC-001"}`  
- **Transformed**: Nested objects with `line_info`, `production`, `machines` arrays
- **Key Learning**: Object nesting, array creation, data organization

### [05_equipment_monitoring.scf.yaml](./05_equipment_monitoring.scf.yaml) - **Conditional Logic**
**Concept**: Complex if/then logic for equipment health assessment
- **Raw Input**: `{"temperature": 78, "vibration": 3.2}`
- **Transformed**: Status evaluation with `"temperature_status": "warning", "overall_status": "alert"`  
- **Key Learning**: Conditional operators, boolean logic, threshold-based alerts

### [06_bit_extraction.scf.yaml](./06_bit_extraction.scf.yaml) - **Bit Manipulation**
**Concept**: Extracting boolean flags from packed PLC status registers
- **Raw Input**: `[23]` (binary: 00010111) 
- **Transformed**: `{"conveyor_running": true, "safety_ok": true, "can_operate": true}`
- **Key Learning**: Bitwise AND operations, binary flag processing

### [07_database_standardization.scf.yaml](./07_database_standardization.scf.yaml) - **Database Integration**
**Concept**: Normalizing legacy database rows for ERP systems
- **Raw Input**: `{"ID": 12345, "WO_NUM": 987, "QTY_PROD": "450", "SHIFT": "1"}`
- **Transformed**: `{"record_id": 12345, "work_order": "WO-000987", "shift_code": "DAY"}`
- **Key Learning**: Data type conversion, string formatting, field mapping

### [08_quality_data_processing.scf.yaml](./08_quality_data_processing.scf.yaml) - **Quality Control**
**Concept**: Processing inspection measurements with tolerance checking
- **Raw Input**: `{"diameter": 50.05, "length": 99.8, "roughness": 1.2}`
- **Transformed**: Pass/fail results with `{"pass_fail": "PASS", "defect_codes": []}`
- **Key Learning**: Tolerance validation, statistical calculations, quality metrics

### [09_energy_monitoring.scf.yaml](./09_energy_monitoring.scf.yaml) - **Energy Analytics**
**Concept**: Power meter data processing and efficiency calculations  
- **Raw Input**: `[38500, 12300, 42100, 87]` (power readings)
- **Transformed**: `{"active_power_kw": 38.5, "efficiency_rating": "fair", "cost_per_hour": 4.62}`
- **Key Learning**: Unit scaling, cost calculations, efficiency analysis

### [10_alarm_processing.scf.yaml](./10_alarm_processing.scf.yaml) - **Alarm Management**
**Concept**: Standardizing alarm messages for maintenance systems
- **Raw Input**: `{"message": "Motor temperature high", "priority": 2}`
- **Transformed**: `{"severity": "high", "category": "thermal", "maintenance_action": "within_hour"}`
- **Key Learning**: Text analysis, priority mapping, alarm categorization