#!/bin/bash

# Clear the screen for a cleaner look
clear

# ASCII Art Logo
echo -e "\033[36m"
echo "    _  _ _    ___ ___ ___ ___ _______ ___  "
echo "   /_\| | |  | _ \ __/ __|_ _|_  / __| _ \ "
echo "  / _ \_  _| |   / _|\__ \| | / /| _||   / "
echo " /_/ \_\|_|  |_|_\___|___/___/___|___|_|_\ "
echo -e "\033[0m"

# Colors & setup
RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
command -v gs &>/dev/null || { echo -e "${RED}Error: Ghostscript not installed${NC}"; exit 1; }
mkdir -p ~/Kratos/pdf
echo -e "${BLUE}Output: ~/Kratos/pdf${NC}"

# Get input/output files
[ "$#" -eq 0 ] && read -p "PDF path: " input_pdf || input_pdf="$1"
[ ! -f "$input_pdf" ] && { echo -e "${RED}Error: File not found${NC}"; exit 1; }
filename=$(basename "$input_pdf")
output_pdf="$HOME/Kratos/pdf/${filename%.*}A4.pdf"
[ -f "$output_pdf" ] && { echo -e "${BLUE}Removing existing file...${NC}"; rm "$output_pdf"; }

# Process with spinner
echo -e "${BLUE}Resizing PDF...${NC}"
(gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
  -dPDFFitPage -sPAPERSIZE=a4 -dNOPAUSE -dQUIET -dBATCH \
  -sOutputFile="$output_pdf" "$input_pdf") &
pid=$!; tput civis; i=0; spin='⣾⣽⣻⢿⡿⣟⣯⣷'
while ps -p $pid > /dev/null; do
    printf "\r${BLUE}[%s] Processing...${NC}" "${spin:i++%${#spin}:1}"
    sleep 0.1
done
printf "\r${BLUE}[✓] Complete!${NC}        \n"
tput cnorm
echo -e "${GREEN}Saved: $output_pdf${NC}" 
