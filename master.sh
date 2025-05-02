#!/bin/bash

# Make all scripts executable (silently)
find "./scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null

# Colors & setup
RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[0;33m'; NC='\033[0m'; CYAN='\033[0;36m'

# Set scripts directory
SCRIPTS_DIR="./scripts"

# Function to display ASCII art logo
display_logo() {
    echo -e "\033[36m"
echo " __                   __                __   .__  __   "
echo "|  | ______________ _/  |_  ____  _____|  | _|__|/  |_ "
echo "|  |/ /\_  __ \__  \\   __\/  _ \/  ___/  |/ /  \   __\ "
echo "|    <  |  | \// __ \|  | (  <_> )___ \|    <|  ||  |   "
echo "|__|_ \ |__|  (____  /__|  \____/____  >__|_ \__||__|   "
echo "     \/            \/                \/     \/          "
    echo -e "\033[0m"
}

# Initial screen setup
clear
display_logo

# Main menu
while true; do
    echo -e "${YELLOW}======= KRATOSKIT MENU =======${NC}"
    
    # Find and list all scripts
    echo -e "${YELLOW}Available Scripts:${NC}"
    scripts=()
    count=1
    
    while IFS= read -r script; do
        script_name=$(basename "$script" .sh)
        scripts+=("$script")
        echo -e "${GREEN}$count${NC}) ${BLUE}$script_name${NC}"
        ((count++))
    done < <(find "$SCRIPTS_DIR" -name "*.sh" | sort)
    
    # Exit option
    echo -e "${GREEN}0${NC}) ${RED}Exit${NC}"
    
    # Coming soon message
    echo -e "${CYAN}... more scripts coming soon!${NC}"
    
    # Get user choice
    echo -e "${YELLOW}Select an option:${NC}"
    read -p "> " choice
    
    # Process choice
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
        if [ "$choice" -eq 0 ]; then
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
        elif [ "$choice" -gt 0 ] && [ "$choice" -le "${#scripts[@]}" ]; then
            clear
            # Run the selected script
            "${scripts[$choice-1]}"
            echo -e "${BLUE}Press Enter to return to menu...${NC}"
            read
            clear
            display_logo
        else
            # Invalid number - clear and show menu again
            echo -e "${RED}Invalid option.${NC}"
            sleep 1
            clear
            display_logo
        fi
    else
        # Invalid input - clear and show menu again
        echo -e "${RED}Please enter a number.${NC}"
        sleep 1
        clear
        display_logo
    fi
done
