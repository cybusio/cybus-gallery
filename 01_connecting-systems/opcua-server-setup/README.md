# OPC UA Server Setup

## What This Does
Sets up the integrated Connectware OPC UA server to expose internal data to OPC UA clients.

## Quick Setup
1. Configure server parameters in `opcua-server-example-commissioning-file.yml`
2. Deploy: `docker run --rm -v ${PWD}:/workspace cybus/connectware-cli deploy /workspace/opcua-server-example-commissioning-file.yml`
3. Connect OPC UA client to your Connectware instance

## Key Configuration
| Parameter | Description |
|-----------|------------|
| serverPort | OPC UA server port (default: 4840) |
| endpoints | Data endpoints to expose via OPC UA |

## Full Tutorial
[How to set up the integrated Connectware OPC UA server](https://learn.cybus.io)
