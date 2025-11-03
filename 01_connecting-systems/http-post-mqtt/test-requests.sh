#!/bin/bash

# Simple test script for HTTP POST to MQTT example
# This script sends sample JSON data to the HTTP endpoint

BASE_URL="https://your-connectware.com/data"
ENDPOINT="/api/sensor-data"
# Replace with your actual auth token
AUTH_HEADER="Authorization: Basic <YOUR_AUTH_TOKEN>"

echo "Testing Simple HTTP POST to MQTT Bridge"
echo "======================================"

# Test 1: Temperature data
echo -e "\n1. Sending temperature data..."
curl -X POST "${BASE_URL}${ENDPOINT}" \
  -H "Content-Type: application/json" \
  -H "$AUTH_HEADER" \
  -d '{"temperature": 23.5, "humidity": 60}' \
  -w "\nHTTP Status: %{http_code}\n"

# Test 2: Machine status
echo -e "\n2. Sending machine status..."
curl -X POST "${BASE_URL}${ENDPOINT}" \
  -H "Content-Type: application/json" \
  -H "$AUTH_HEADER" \
  -d '{"machine": "pump01", "status": "running", "pressure": 2.5}' \
  -w "\nHTTP Status: %{http_code}\n"

# Test 3: Sensor array
echo -e "\n3. Sending sensor array..."
curl -X POST "${BASE_URL}${ENDPOINT}" \
  -H "Content-Type: application/json" \
  -H "$AUTH_HEADER" \
  -d '{"sensors": [{"id": "temp001", "value": 25.1}, {"id": "hum001", "value": 65}]}' \
  -w "\nHTTP Status: %{http_code}\n"

echo -e "\nTest completed!"
echo "All data should appear on MQTT topic: sensors/data"