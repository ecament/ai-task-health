#!/bin/bash

# Quick test script to verify healthcheck.sh functionality
# Run this from the project root: bash scripts/test.sh

set -e

echo "================================"
echo "VM Health Check - Test Suite"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT="./scripts/healthcheck.sh"

# Check if script exists
if [ ! -f "$SCRIPT" ]; then
    echo -e "${RED}✗ Error: healthcheck.sh not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Script found: $SCRIPT"
echo ""

# Check if script is executable
if [ ! -x "$SCRIPT" ]; then
    echo "Making script executable..."
    chmod +x "$SCRIPT"
    echo -e "${GREEN}✓${NC} Script is now executable"
    echo ""
fi

# Test 1: Run without arguments
echo "Test 1: Running health check (no arguments)"
echo "============================================"
if bash "$SCRIPT"; then
    echo -e "${GREEN}✓${NC} Basic health check passed"
else
    echo -e "${RED}✗${NC} Basic health check failed"
    exit 1
fi
echo ""

# Test 2: Run with explain argument
echo "Test 2: Running with 'explain' argument"
echo "========================================="
if bash "$SCRIPT" explain 2>&1 | head -20; then
    echo ""
    echo -e "${GREEN}✓${NC} Explain mode passed"
else
    echo -e "${RED}✗${NC} Explain mode failed"
    exit 1
fi
echo ""

# Test 3: Test invalid argument
echo "Test 3: Testing invalid argument handling"
echo "=========================================="
if bash "$SCRIPT" invalid 2>&1 | grep -q "Unknown argument"; then
    echo -e "${GREEN}✓${NC} Invalid argument handling works"
else
    echo -e "${RED}✗${NC} Invalid argument handling failed"
fi
echo ""

echo "================================"
echo -e "${GREEN}All tests completed!${NC}"
echo "================================"
