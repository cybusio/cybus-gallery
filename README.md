# Cybus Gallery

**Production-ready examples for Industrial IoT with Cybus Connectware**

Connect industrial devices, transform data, and monitor your systems with proven service configuration templates and processing rules.

## 🔌 Connecting Systems

**Industrial Protocols** (12 supported):
- **[OPC UA](./connecting-systems/opcua/)** - Industry 4.0 standard protocol
- **[Modbus TCP](./connecting-systems/modbus/)** - Read/write Modbus devices  
- **[Siemens S7](./connecting-systems/siemens-s7/)** - Connect to Siemens PLCs
- **[EtherNet/IP](./connecting-systems/ethernetip/)** - Allen-Bradley PLCs and devices
- **[ADS](./connecting-systems/ads/)** - Beckhoff TwinCAT automation
- **[BACnet](./connecting-systems/bacnet/)** - Building automation protocol
- **[FOCAS](./connecting-systems/focas/)** - FANUC CNC machine integration
- **[OpenProtocol](./connecting-systems/openprotocol/)** - Atlas Copco tools
- **[SOPAS](./connecting-systems/sopas/)** - SICK sensor integration
- **[Heidenhain DNC](./connecting-systems/heidenhain-dnc/)** - CNC data collection

**Cloud & Web Integration**:
- **[AWS IoT](./connecting-systems/aws-iot/)** - Amazon IoT Core & Greengrass
- **[Azure IoT](./connecting-systems/azure-iot/)** - Microsoft IoT Hub & Edge
- **[HTTP Integration](./connecting-systems/http-post-mqtt/)** - RESTful API bridging
- **[Custom TCP](./connecting-systems/custom-tcp/)** - Build custom connectors

**Security & Management**:
- **[TLS Certificates](./connecting-systems/mqtt-tls-certificates/)** - Secure MQTT connections

**[→ All connection examples](./connecting-systems/)**

## 🔄 Data Processing

**Essential Processing Rules**:
- **[Transform](./data-processing/01_transform/)** - Convert JSON data with JSONata
- **[Filter](./data-processing/02_filter/)** - Conditional data processing
- **[Parse](./data-processing/03_parse/)** - Extract data from strings and formats
- **[COV (Change of Value)](./data-processing/06_cov/)** - Publish only on changes
- **[Collect](./data-processing/07_collect/)** - Aggregate multiple data sources

**Advanced Processing**:
- **[Stash](./data-processing/04_stash/)** - State management between messages
- **[SetContextVars](./data-processing/05_setContextVars/)** - Dynamic variable extraction
- **[Burst](./data-processing/08_burst/)** - Message batching and splitting

**[→ All data processing examples](./data-processing/)**

## 📡 Advanced Mapping

**Enterprise Mapping Patterns**:
- **[Basic Wildcards](./advanced-mapping/01_basic_wildcards/)** - Dynamic topic matching
- **[Array Mapping](./advanced-mapping/02_array/)** - Multi-source integration
- **[Wildcards with Collect](./advanced-mapping/03_wildcards_with_collect/)** - Advanced aggregation
- **[Dynamic Routing](./advanced-mapping/04_dynamic_publish_topic/)** - Content-based routing

**[→ All advanced mapping examples](./advanced-mapping/)**

## 📊 Monitoring

Monitor and visualize your Industrial IoT data:

- **[Elasticsearch & Kibana](./monitoring/elasticsearch/)** - Search and visualize data
- **[Grafana & Loki](./monitoring/grafana-loki/)** - Log aggregation and monitoring
- **[Azure Monitoring](./monitoring/azure-monitoring/)** - Cloud-based monitoring

**[→ All monitoring examples](./monitoring/)**

## � Security

Secure your Industrial IoT deployments:

- **[Client Certificates](./security/client-certificates-for-mqtt-over-tls/)** - MQTT TLS authentication
- **[User Management](./security/user-management/)** - Access control and permissions

**[→ All security examples](./security/)**

## 📚 Documentation

- **[Cybus Connectware Docs](https://docs.cybus.io/)** - Complete platform documentation
- **[Protocol Details](https://docs.cybus.io/documentation/industry-protocol-details)** - Industrial protocol guides
- **[Service Configuration](https://docs.cybus.io/documentation/services)** - SCF file reference
- **[Data Processing](https://docs.cybus.io/documentation/services/data-processing-rules)** - Processing rules guide

## 📞 Support

- **Documentation**: [docs.cybus.io](https://docs.cybus.io/)
- **Support Portal**: [support.cybus.io](https://support.cybus.io/)
- **Professional Services**: Contact [Cybus](https://www.cybus.io/) for implementation support