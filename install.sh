#!/bin/bash
# Darkweave Installer

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================="
echo "  Darkweave Framework Installer v1.0"
echo "========================================="
echo ""

# Check dependencies
echo -e "${GREEN}[*] Checking dependencies...${NC}"

if ! command -v php &> /dev/null; then
    echo -e "${RED}[!] PHP not found${NC}"
    echo "    Install: sudo apt install php -y"
    exit 1
fi
echo -e "${GREEN}[✓] PHP found${NC}"

if ! command -v curl &> /dev/null; then
    echo -e "${RED}[!] curl not found${NC}"
    echo "    Install: sudo apt install curl -y"
    exit 1
fi
echo -e "${GREEN}[✓] curl found${NC}"

if ! command -v wget &> /dev/null; then
    echo -e "${RED}[!] wget not found${NC}"
    echo "    Install: sudo apt install wget -y"
    exit 1
fi
echo -e "${GREEN}[✓] wget found${NC}"

# Create directories
echo ""
echo -e "${GREEN}[*] Creating directories...${NC}"
mkdir -p modules payloads php templates config output logs
chmod 755 modules payloads php templates
chmod 777 output logs

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}[✓] Darkweave Installation Complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}[!] Next steps:${NC}"
echo "    1. Run: ./darkweave.sh"
echo "    2. Run: ./launch.sh"
echo ""
