#!/bin/bash
# Darkweave v1.0 - Advanced Intelligence Framework
# Author: CyberRoninX1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SESSION_ID=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="$SCRIPT_DIR/output/session_$SESSION_ID"

banner() {
    clear
    echo -e "${RED}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║      ██████╗  █████╗ ██████╗ ██╗  ██╗██╗    ██╗███████╗ █████╗    ║
    ║      ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██║    ██║██╔════╝██╔══██╗   ║
    ║      ██║  ██║███████║██████╔╝█████╔╝ ██║ █╗ ██║█████╗  ███████║   ║
    ║      ██║  ██║██╔══██║██╔══██╗██╔═██╗ ██║███╗██║██╔══╝  ██╔══██║   ║
    ║      ██████╔╝██║  ██║██║  ██║██║  ██╗╚███╔███╔╝███████╗██║  ██║   ║
    ║      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝   ║
    ║                                                                   ║
    ║                    DARKWEAVE v1.0 | CYBERRONINX1                   ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${GREEN}    [+] Advanced Intelligence Framework Loaded${NC}"
    echo -e "${CYAN}    [+] Session: $SESSION_ID${NC}"
    echo -e "${YELLOW}    [!] FOR AUTHORIZED TESTING ONLY${NC}"
    echo ""
}

create_directories() {
    mkdir -p "$SCRIPT_DIR/modules"
    mkdir -p "$SCRIPT_DIR/payloads"
    mkdir -p "$SCRIPT_DIR/php"
    mkdir -p "$SCRIPT_DIR/templates"
    mkdir -p "$SCRIPT_DIR/config"
    mkdir -p "$SCRIPT_DIR/output"
    mkdir -p "$SCRIPT_DIR/logs"
    mkdir -p "$OUTPUT_DIR"
    echo -e "${GREEN}[✓]${NC} Directory structure created"
}

main_menu() {
    echo ""
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│                    SELECT OPERATION MODE                    │${NC}"
    echo -e "${BLUE}├─────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${BLUE}│${NC}  ${GREEN}[1]${NC} Full Suite - All Modules Active                   ${BLUE}│${NC}"
    echo -e "${BLUE}│${NC}  ${GREEN}[2]${NC} Stealth Mode - Silent Collection                 ${BLUE}│${NC}"
    echo -e "${BLUE}│${NC}  ${GREEN}[3]${NC} Social Engineering - Fake Pages Only            ${BLUE}│${NC}"
    echo -e "${BLUE}│${NC}  ${GREEN}[4]${NC} Recon Mode - Network & System Only               ${BLUE}│${NC}"
    echo -e "${BLUE}│${NC}  ${GREEN}[5]${NC} Exit                                           ${BLUE}│${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "$(echo -e ${GREEN}"[?] Select mode: "${NC})" MODE
    
    case $MODE in
        1) FULL_MODE=true; STEALTH_MODE=false; SOCIAL_MODE=false; RECON_MODE=false ;;
        2) FULL_MODE=false; STEALTH_MODE=true; SOCIAL_MODE=false; RECON_MODE=false ;;
        3) FULL_MODE=false; STEALTH_MODE=false; SOCIAL_MODE=true; RECON_MODE=false ;;
        4) FULL_MODE=false; STEALTH_MODE=false; SOCIAL_MODE=false; RECON_MODE=true ;;
        5) exit 0 ;;
        *) echo -e "${RED}[!] Invalid option${NC}"; main_menu ;;
    esac
}

source_modules() {
    for module in "$SCRIPT_DIR/modules/"*.sh; do
        if [ -f "$module" ]; then
            source "$module"
        fi
    done
}

main() {
    banner
    create_directories
    source_modules
    main_menu
    
    echo -e "\n${GREEN}[✓] Darkweave initialized${NC}"
    echo -e "${CYAN}[→] Output directory: $OUTPUT_DIR${NC}\n"
    
    # Save session info
    echo "Session: $SESSION_ID" > "$OUTPUT_DIR/session_info.txt"
    echo "Started: $(date)" >> "$OUTPUT_DIR/session_info.txt"
    echo "Mode: $MODE" >> "$OUTPUT_DIR/session_info.txt"
}

main "$@"
