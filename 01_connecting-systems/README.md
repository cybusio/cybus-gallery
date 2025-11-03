# Connecting Systems

**Production-ready service configurations for industrial device integration**

Connect Cybus Connectware to PLCs, sensors, cloud platforms, and custom systems with standardized SCF templates.

## 🏭 Industrial Protocols

| Protocol | Vendor/Standard | Use Cases | Examples |
|----------|----------------|-----------|----------|
| **[OPC UA](./opcua/)** | Industry 4.0 Standard | Universal manufacturing | Read/write, server setup |
| **[Modbus TCP](./modbus/)** | Open Standard | PLCs, sensors, meters | Read/write operations |
| **[Siemens S7](./siemens-s7/)** | Siemens | S7 PLCs (300/400/1200/1500) | TIA Portal integration |
| **[EtherNet/IP](./ethernetip/)** | Rockwell/ODVA | Allen-Bradley PLCs | CompactLogix, ControlLogix |
| **[ADS](./ads/)** | Beckhoff | TwinCAT automation | PLC variable access |
| **[BACnet](./bacnet/)** | ASHRAE | Building automation | HVAC, lighting control |
| **[FOCAS](./focas/)** | FANUC | CNC machining | Program transfer, monitoring |
| **[OpenProtocol](./openprotocol/)** | Atlas Copco | Assembly tools | Torque data, quality control |
| **[SOPAS](./sopas/)** | SICK | Industrial sensors | Safety, measurement data |
| **[Heidenhain DNC](./heidenhain-dnc/)** | Heidenhain | CNC machining | Data collection, monitoring |

## ☁️ Cloud & Web Integration

| Platform | Services | Features |
|----------|----------|----------|
| **[AWS IoT](./aws-iot/)** | IoT Core, Greengrass | Direct cloud, edge computing |
| **[Azure IoT](./azure-iot/)** | IoT Hub, IoT Edge | Device twins, edge modules |
| **[HTTP Integration](./http-post-mqtt/)** | RESTful APIs | HTTP-to-MQTT bridging |
| **[HTTP Write](./http-write-cnc/)** | CNC Commands | HTTP-based machine control |

## 📋 What Each Example Contains

- **SCF Configuration** - Service commissioning file with connection parameters
- **README Guide** - Step-by-step setup instructions
- **Parameter Reference** - Required and optional configuration values
- **Test Procedures** - How to verify successful integration
- **Troubleshooting** - Common issues and solutions

## 🎯 Choosing the Right Protocol

**For PLCs**: OPC UA (universal), S7 (Siemens), EtherNet/IP (Rockwell), ADS (Beckhoff)  
**For Sensors**: SOPAS (SICK), Modbus TCP (universal), BACnet (building automation)  
**For CNC**: FOCAS (FANUC), Heidenhain DNC, custom TCP connectors  
**For Cloud**: AWS IoT, Azure IoT with edge computing support

## 📞 Support Resources

- **[Protocol Details](https://docs.cybus.io/documentation/industry-protocol-details)** - Technical specifications
- **[Service Configuration](https://docs.cybus.io/documentation/services)** - SCF file reference  
- **[Troubleshooting Guide](https://docs.cybus.io/)** - Common integration issues
- **Professional Services** - Contact [Cybus](https://www.cybus.io/) for custom implementations