# Azure IoT Integration

## What This Does
Connects industrial devices to Microsoft Azure IoT Hub or Azure IoT Edge for cloud-based monitoring and control.

## Quick Setup

### Azure IoT Hub (Direct Cloud):
1. Create device in Azure IoT Hub, copy connection string
2. Update `Azure_Iot_Connection_String` in `azure-iot-hub-connectware-service.yml`
3. Deploy: `docker run --rm -v ${PWD}:/workspace cybus/connectware-cli deploy /workspace/azure-iot-hub-connectware-service.yml`
4. Test with Node-RED flow: `node-red-flow-test-event.json`

### Azure IoT Edge (Edge Gateway):
1. Set up IoT Edge device with certificates
2. Configure connection string and `Azure_Iot_Hub_CaCertChain` in `azure-iot-edge-connectware-service.yml`
3. Deploy: `docker run --rm -v ${PWD}:/workspace cybus/connectware-cli deploy /workspace/azure-iot-edge-connectware-service.yml`

## Key Parameters

| Parameter | Required | Example |
|-----------|----------|---------|
| Azure_Iot_Connection_String | Yes | `HostName=myhub.azure-devices.net;DeviceId=device1;SharedAccessKey=...` |
| Azure_Iot_Hub_CaCertChain | Edge only | PEM certificate chain |
| machineTopic | Yes | `ProductionLine1` |

## Example Data Flow
Input (MQTT topic `services/azureiothubtest/test/ProductionLine1`):
```json
{
  "DeviceData": {
    "Temperature": 78.567,
    "Position": {"X": 35.02, "Y": 12.62, "Z": 3.45},
    "Status": "operational"
  }
}
```

Output to Azure IoT:
```json
{
  "deviceId": "TestDevice",
  "payload": {
    "Temperature": 78.567,
    "Position": {"X": 35.02, "Y": 12.62, "Z": 3.45},
    "Status": "operational"
  }
}
```

## Troubleshooting

**Connection fails to IoT Edge:**
- Verify certificates: `openssl s_client -connect <gateway-host>:8883`
- Check hostname resolution and certificate CN match
- Ensure complete CA certificate chain in `Azure_Iot_Hub_CaCertChain`

**No data in Azure IoT Hub:**
- Set log level to `trace` in SCF to see telemetry dumps
- Verify connection string format and device exists
- Check MQTT topic permissions and data flow

## What's Next
- Monitor data with [Azure IoT monitoring guide](https://github.com/cybusio/example-how-to-monitor-azure-iot-hub-events)
- Add data transformations using [data-processing rules](../../data-processing/)
- Set up alerts and dashboards in Azure IoT Central
