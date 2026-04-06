#!/bin/bash
# System Information Module

system_info() {
    echo -e "${CYAN}[*] System information:${NC}"
    echo "OS: $(uname -a)"
    echo "User: $(whoami)"
    echo "Hostname: $(hostname)"
}
