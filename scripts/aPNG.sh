#!/bin/bash

# Clear the screen for a cleaner look
clear

# ASCII Art Logo
echo -e "\033[36m"
echo "    _    _  _ ___ __  __   ___ _  _  ___  "
echo "   /_\\  | \\| |_ _|  \\/  | | _ \\ \\| |/ __| "
echo "  / _ \\ | .\` || ||  \\/| | |  _/ .\` | (_ | "
echo " /_/ \\_\\|_|\\_|___|_|  |_| |_| |_|\\_|\\___| GENERATOR "
echo -e "\033[0m"

# Colors & setup
RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
command -v ffmpeg &>/dev/null || { echo -e "${RED}Error: ffmpeg not installed${NC}"; exit 1; }
mkdir -p ~/Kratos/apng
echo -e "${BLUE}Output: ~/Kratos/apng${NC}"

# Get input/output files
[ "$#" -eq 0 ] && read -p "Video path: " input_video || input_video="$1"
[ ! -f "$input_video" ] && { echo -e "${RED}Error: File not found${NC}"; exit 1; }
filename=$(basename "$input_video")
output_apng="$HOME/Kratos/apng/${filename%.*}.png"
[ -f "$output_apng" ] && { echo -e "${BLUE}Removing existing file...${NC}"; rm "$output_apng"; }

# Get video width (for default)
video_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$input_video" 2>/dev/null)
[ -z "$video_width" ] && video_width=320

# Optional parameters with defaults
read -p "Frame rate (default: 10): " fps
fps=${fps:-10}

read -p "Scale width (default: source width, enter value to change): " width
if [ -z "$width" ]; then
    scale_filter="fps=$fps"  # Keep original size
else
    scale_filter="fps=$fps,scale=$width:-1:flags=lanczos"  # Custom width with aspect ratio preserved
fi

# Loop option
while true; do
    read -p "Loop animation? (y/n, default: y): " loop_choice
    loop_choice=${loop_choice:-y}
    case $loop_choice in
        [Yy]* ) loop_option="0"; break;;
        [Nn]* ) loop_option="1"; break;;
        * ) echo "Please answer y or n.";;
    esac
done

# Process with spinner
echo -e "${BLUE}Converting video to animated PNG...${NC}"
(ffmpeg -i "$input_video" -vf "$scale_filter" -plays $loop_option -f apng "$output_apng" -hide_banner -loglevel error) &
pid=$!; tput civis; i=0; spin='⣾⣽⣻⢿⡿⣟⣯⣷'
while ps -p $pid > /dev/null; do
    printf "\r${BLUE}[%s] Processing...${NC}" "${spin:i++%${#spin}:1}"
    sleep 0.1
done
printf "\r${BLUE}[✓] Complete!${NC}        \n"
tput cnorm
echo -e "${GREEN}Saved: $output_apng${NC}" 
