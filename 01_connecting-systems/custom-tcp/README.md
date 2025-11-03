# Custom TCP Connector

## What This Does
Build your own TCP-based connector for proprietary or custom industrial protocols not natively supported by Connectware.

## When to Use
- Your device uses a proprietary TCP protocol
- Need to connect legacy equipment with custom communication
- Standard protocols (OPC UA, Modbus, etc.) don't fit your use case

## Quick Setup
1. Build the connector: `docker compose build --build-arg BASEIMAGE_VERSION=1.1.1`
2. Start the environment: `docker compose up`  
3. Register the agent in Connectware following the [Agent Registration Process](https://docs.cybus.io/documentation/agents/registering-agents-in-connectware)
4. Deploy the example service: `examples/service.yaml`

## Content

This repository includes the following content:
- Server implementation `src/utils/server.js`
- Client implementation `src/*.js`
- Playground environment `docker-compose.yaml`
- Example [Service Commissioning File](https://docs.cybus.io/documentation/services/service-commissioning-files#structure-of-service-commissioning-files) `examples/service.yaml`

## How to build

Since a Custom Connector is based on a pre-built Docker image, the image tag version has to be passed to the build command. 
This tag version equals to the Connectware version this Custom Connector should be connected to, for instance:

```shell
 docker compose build --build-arg BASEIMAGE_VERSION=1.1.1
```

## How to run

To start the Agent along with a sample server, adjust the playground environment `docker-compose.yaml` and execute it.


```shell
 docker compose up
```

Follow the usual [Agent Registration Process](https://docs.cybus.io/documentation/agents/registering-agents-in-connectware) and install the attached example [Service Commissioning File](https://docs.cybus.io/documentation/services/service-commissioning-files#structure-of-service-commissioning-files) `examples/service.yaml`.

If everything goes right, you should now be able to observe an empty string being published to the MQTT topic `services/mycustomprotocolservice/mySubscribeEndpoint`.

For a write operation, simply publish a string to the MQTT topic `services/mycustomprotocolservice/myWriteEndpoint/set`

## Sample Protocol Specification

There are two supported operations `WRITE` and `read`. The argument separator is a simple colon `:`.

### Write Operation
Request:
```
<START>WRITE:<ADDRESS>:<VALUE><END> // Example: <START>WRITE:foo:bar<END>
```
Response:
```
<START>SUCCESS:WRITE:<ADDRESS><END> // Example: <START>SUCCESS:WRITE:foo<END>
```
### Read Operation
Request:
```
<START>READ:<ADDRESS><END> // Example: <START>READ:foo<END>
```
Response:
```
<START>SUCCESS:READ:<ADDRESS>:<VALUE><END> // Example: <START>SUCCESS:READ:foo:bar<END>
```
