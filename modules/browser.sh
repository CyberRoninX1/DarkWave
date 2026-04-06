#!/bin/bash
# Browser Data Harvesting Module

browser_data() {
    echo -e "${CYAN}[*] Browser data extraction...${NC}"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        CHROME_PATH="$HOME/Library/Application Support/Google/Chrome"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        CHROME_PATH="$HOME/.config/google-chrome"
    fi
    
    if [ -d "$CHROME_PATH" ]; then
        echo "Chrome profile found"
    fi
}
