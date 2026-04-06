#!/bin/bash
# Network Reconnaissance Module

network_scan() {
    echo -e "${CYAN}[*] Scanning local network...${NC}"
    if command -v nmap &> /dev/null; then
        nmap -sn 192.168.1.0/24 2>/dev/null | grep -oP '(\d+\.\d+\.\d+\.\d+)' | head -10
    else
        echo "nmap not installed"
    fi
}

dns_leak_test() {
    echo -e "${CYAN}[*] Testing DNS leak...${NC}"
    curl -s https://ipleak.net/json/ | head -3
}

webrtc_leak() {
    echo -e "${CYAN}[*] WebRTC leak test URL:${NC}"
    echo "https://browserleaks.com/webrtc"
}
