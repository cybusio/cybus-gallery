#!/bin/bash

# Test script for HTTP to CNC Bridge with JSONata transformation
BASE_URL="https://your-connectware.com/cnc/api"

echo "Testing HTTP to CNC write with JSONata transformation..."
echo "======================================================"

# Test 1: Using 'data' field (recommended)
echo "1. Sending program number with 'data' field..."
curl -X POST \
  "$BASE_URL/write" \
  -H "Content-Type: application/json" \
  -d '{"data": "O1001"}'
echo -e "\n"

# Test 2: Direct string value
echo "2. Sending direct string value..."
curl -X POST \
  "$BASE_URL/write" \
  -H "Content-Type: application/json" \
  -d '"MAIN.NC"'
echo -e "\n"

# Test 3: G-code command
echo "3. Sending G-code command..."
curl -X POST \
  "$BASE_URL/write" \
  -H "Content-Type: application/json" \
  -d '{"data": "M30"}'
echo -e "\n"

# Test 4: Complex object (fallback)
echo "4. Sending complex object..."
curl -X POST \
  "$BASE_URL/write" \
  -H "Content-Type: application/json" \
  -d '{
    "program": "O1002",
    "command": "start",
    "mode": "auto"
  }'
echo -e "\n"

echo "Test completed!"