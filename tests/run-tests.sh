#!/bin/bash

# Frontend Testing Script
# Tests the Dynamic DApp Frontend Application

echo "================================"
echo "🧪 Dynamic DApp Frontend Testing"
echo "================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize test results
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNINGS=0

# Test 1: Check if Frontend is running
echo -e "${BLUE}Test 1: Checking Frontend Server${NC}"
if timeout 2 bash -c 'echo >/dev/tcp/localhost/5173' 2>/dev/null; then
    echo -e "${GREEN}✅ Frontend server is running on port 5173${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ Frontend server not responding on port 5173${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test 2: Check if Backend is running
echo -e "${BLUE}Test 2: Checking Backend Server${NC}"
if timeout 2 bash -c 'echo >/dev/tcp/localhost/3001' 2>/dev/null; then
    echo -e "${GREEN}✅ Backend server is running on port 3001${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ Backend server not responding on port 3001${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test 3: Check Frontend files structure
echo -e "${BLUE}Test 3: Checking Frontend File Structure${NC}"
required_files=(
    "src/App.tsx"
    "src/main.tsx"
    "src/index.css"
    "src/components/Header.tsx"
    "src/components/HeroSection.tsx"
    "src/components/Footer.tsx"
    "src/pages/Index.tsx"
    "package.json"
    "vite.config.ts"
)

missing_files=0
for file in "${required_files[@]}"; do
    if [ -f "/home/israel/Documentos/DEVREL/dapp/$file" ]; then
        echo -e "${GREEN}✅ $file exists${NC}"
    else
        echo -e "${RED}❌ Missing: $file${NC}"
        ((missing_files++))
    fi
done

if [ $missing_files -eq 0 ]; then
    ((TESTS_PASSED++))
else
    ((TESTS_FAILED++))
fi
echo ""

# Test 4: Check Backend files structure
echo -e "${BLUE}Test 4: Checking Backend File Structure${NC}"
backend_files=(
    "backend/src/server.js"
    "backend/package.json"
    "backend/src/routes/gaming.js"
    "backend/src/routes/defi.js"
    "backend/src/data/mockData.js"
)

missing_backend=0
for file in "${backend_files[@]}"; do
    if [ -f "/home/israel/Documentos/DEVREL/dapp/$file" ]; then
        echo -e "${GREEN}✅ $file exists${NC}"
    else
        echo -e "${RED}❌ Missing: $file${NC}"
        ((missing_backend++))
    fi
done

if [ $missing_backend -eq 0 ]; then
    ((TESTS_PASSED++))
else
    ((TESTS_FAILED++))
fi
echo ""

# Test 5: Check Node modules
echo -e "${BLUE}Test 5: Checking Dependencies${NC}"
if [ -d "/home/israel/Documentos/DEVREL/dapp/node_modules" ]; then
    echo -e "${GREEN}✅ Frontend node_modules installed${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ Frontend node_modules not found${NC}"
    ((TESTS_FAILED++))
fi

if [ -d "/home/israel/Documentos/DEVREL/dapp/backend/node_modules" ]; then
    echo -e "${GREEN}✅ Backend node_modules installed${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ Backend node_modules not found${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test 6: Check environment files
echo -e "${BLUE}Test 6: Checking Environment Configuration${NC}"
if [ -f "/home/israel/Documentos/DEVREL/dapp/.env" ]; then
    echo -e "${GREEN}✅ Frontend .env exists${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${YELLOW}⚠️  Frontend .env not found${NC}"
    ((TESTS_WARNINGS++))
fi

if [ -f "/home/israel/Documentos/DEVREL/dapp/backend/config/config.env" ]; then
    echo -e "${GREEN}✅ Backend config.env exists${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${YELLOW}⚠️  Backend config.env not found${NC}"
    ((TESTS_WARNINGS++))
fi
echo ""

# Test 7: Check API client
echo -e "${BLUE}Test 7: Checking API Integration${NC}"
if [ -f "/home/israel/Documentos/DEVREL/dapp/src/lib/api.ts" ]; then
    echo -e "${GREEN}✅ API client exists${NC}"
    if grep -q "localhost:3001" /home/israel/Documentos/DEVREL/dapp/src/lib/api.ts; then
        echo -e "${GREEN}✅ API client configured for localhost:3001${NC}"
        ((TESTS_PASSED+=2))
    else
        echo -e "${YELLOW}⚠️  API client might not be configured correctly${NC}"
        ((TESTS_WARNINGS++))
    fi
else
    echo -e "${RED}❌ API client not found${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test 8: Check Build configuration
echo -e "${BLUE}Test 8: Checking Build Configuration${NC}"
if [ -f "/home/israel/Documentos/DEVREL/dapp/tsconfig.json" ]; then
    echo -e "${GREEN}✅ TypeScript config exists${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ TypeScript config not found${NC}"
    ((TESTS_FAILED++))
fi

if [ -f "/home/israel/Documentos/DEVREL/dapp/vite.config.ts" ]; then
    echo -e "${GREEN}✅ Vite config exists${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ Vite config not found${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test Summary
echo "================================"
echo "📊 Test Summary"
echo "================================"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${YELLOW}Warnings: $TESTS_WARNINGS${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All critical tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review above.${NC}"
    exit 1
fi
