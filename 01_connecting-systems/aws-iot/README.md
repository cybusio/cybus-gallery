# AWS IoT Integration

## What This Does
Connects Cybus Connectware to AWS IoT Core or AWS IoT Greengrass for cloud-based Industrial IoT applications.

## Quick Setup

### For AWS IoT Core:
1. Create a device in your AWS IoT Console and download certificates
2. Update connection parameters in `aws-iot-core-connectware-service.yml`
3. Deploy: `docker run --rm -v ${PWD}:/workspace cybus/connectware-cli deploy /workspace/aws-iot-core-connectware-service.yml`
4. Verify data appears in AWS IoT Console

### For AWS IoT Greengrass:
1. Set up Greengrass Core and create device certificates  
2. Update parameters in `aws-iot-greengrass-connectware-service.yml`
3. Deploy and verify connection

## Key Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Aws_IoT_Endpoint_Address | Yes | Your AWS IoT endpoint (find with `aws iot describe-endpoint`) |
| caCert | Yes | Amazon Root CA certificate |
| clientCert | Yes | Device certificate from AWS IoT |
| clientPrivateKey | Yes | Device private key |

## Prerequisites
- AWS account with IoT Core access
- AWS CLI installed and configured
- Cybus Connectware (Version 1.0.13 or higher)
- Basic understanding of MQTT and certificates

## Detailed Setup Guide

### Step 1: AWS IoT Core Setup

#### 1.1: Get Your AWS IoT Endpoint
```bash
aws iot describe-endpoint --endpoint-type iot:Data-ATS
```
Save the `endpointAddress` from the response (e.g., `a7t9xxxxx-ats.iot.eu-central-1.amazonaws.com`)

#### 1.2: Create Device and Certificates
1. **Go to AWS IoT Console** → Things → Create a single thing
2. **Download all certificate files**:
   - Device certificate (`.pem.crt`)
   - Private key (`.pem.key`) 
   - Amazon Root CA 1 (`AmazonRootCA1.pem`)
3. **Activate the certificate** in the AWS console

#### 1.3: Create IoT Policy
Create a policy named `CybusConnectwarePolicy` with these permissions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iot:Publish",
        "iot:Subscribe", 
        "iot:Connect",
        "iot:Receive"
      ],
      "Resource": "*"
    }
  ]
}
```

#### 1.4: Attach Policy to Certificate
In AWS IoT Console → Secure → Certificates → Your certificate → Policies → Attach policy

### Step 2: Configure Connectware Service

#### 2.1: Update Service Configuration
Edit `aws-iot-core-connectware-service.yml`:
- Set `Aws_IoT_Endpoint_Address` to your endpoint from Step 1.1
- Add your certificate files to the `caCert`, `clientCert`, and `clientPrivateKey` parameters

#### 2.2: Deploy and Test
```bash
docker run --rm -v ${PWD}:/workspace cybus/connectware-cli deploy /workspace/aws-iot-core-connectware-service.yml
```

#### 2.3: Verify Connection
Check in AWS IoT Console → Test → MQTT test client → Subscribe to topic `#` to see messages.

## AWS IoT Greengrass Setup

For edge computing scenarios, you can connect to AWS IoT Greengrass instead:

### Key Differences from IoT Core
- Uses Greengrass Group CA instead of Amazon Root CA
- Requires `Greengrass_Core_Endpoint_Address` (IP/hostname of Greengrass Core)
- Needs `awsGreengrassClientId` matching your device name

### Setup Steps
1. Set up Greengrass Core device and create Greengrass Group
2. Get Greengrass Group CA certificate:
   ```bash
   aws greengrass list-groups
   aws greengrass get-group-certificate-authority --group-id "your-group-id" --certificate-authority-id "your-ca-id"
   ```
3. Update `aws-iot-greengrass-connectware-service.yml` with your Greengrass configuration
4. Deploy: `docker run --rm -v ${PWD}:/workspace cybus/connectware-cli deploy /workspace/aws-iot-greengrass-connectware-service.yml`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection fails | Verify endpoint address and certificate files |
| "Not authorized" error | Check IoT policy is attached to certificate |
| No data in AWS console | Confirm device is publishing to correct topics |

## Advanced Features

Once basic connectivity works, explore these AWS IoT features:
- **Device Shadows**: Maintain device state in the cloud
- **Rules Engine**: Route messages to other AWS services
- **Device Management**: Over-the-air updates and fleet management

## What's Next
- Process IoT data: [Transform Rules](../../data-processing/01_transform/)
- Set up monitoring: [Elasticsearch Dashboard](../../monitoring/elasticsearch/)
- Explore AWS IoT Rules Engine and Lambda integration

## References

- [Using the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide)
- [AWS IoT Homepage](https://aws.amazon.com/iot)
- [AWS IoT Core](https://aws.amazon.com/iot-core)
- [AWS IoT Greengrass](https://aws.amazon.com/greengrass)
- [How to install Greengrass Core](https://docs.aws.amazon.com/greengrass/latest/developerguide/install-ggc.html)
- [Device authentication and authorization for AWS IoT Greengrass](https://docs.aws.amazon.com/greengrass/latest/developerguide/device-auth.html)
- [Greengrass Device Connection Workflow](https://docs.aws.amazon.com/greengrass/latest/developerguide/gg-sec.html#gg-sec-connection)
- [Cybus Homepage](https://www.cybus.io/)
- [Cybus Connectware documentation](https://docs.cybus.io)
- [Cybus Learn Service Basics](https://learn.cybus.io/lessons/mqtt-basics/)
