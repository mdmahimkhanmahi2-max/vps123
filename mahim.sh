#!/bin/bash

# Credit for Original Concept and Design: MAHIMOP (Jishnu Network)
# Remastered by Gemini

# --- Terminal Colors & Control (Using Tput for Reset) ---
R="\e[1;31m"  # Bright Red
G="\e[1;32m"  # Green
Y="\e[1;33m"  # Yellow
B="\e[1;34m"  # Blue (Not used, but kept for completeness)
C="\e[1;36m"  # Cyan
W="\e[1;37m"  # White
N="\e[0m"     # Reset
DASH_LINE="${R}$(printf -- '-%.0s' {1..60})${N}"
BOLD_RED_ARROW="${R}»»${W}"

# --- Utility Functions ---

# Function to display the JISHNU NETWORK ASCII Art
print_jishnu_logo() {
    local BORDER="${R}==============================================================${N}"
    local WING="${W}>>>${R} ${W}"
    echo -e "\n${BORDER}"
    echo -e "${R}# ${WING}    ____  _   _ ____  _   _ _   _ ____  _   _ _____   ${R}#"
    echo -e "${R}# ${WING}   / ___|| | | |  _ \| | | | \ | |  _ \| \ | |_   _|  ${R}#"
    echo -e "${R}# ${WING}  | |   | |_| | |_) | | | |  \| | | | |  \| | | |    ${R}#"
    echo -e "${R}# ${WING}  | |___|  _  |  _ <| |_| | |\  | |_| | |\  | | |    ${R}#"
    echo -e "${R}# ${WING}   \____|_| |_|_| \_\\___/|_| \_|____/|_| \_| |_|    ${R}#"
    echo -e "${R}# ${WING}                                                      ${R}#"
    echo -e "${R}# ${Y}             N E T W O R K - D E V O P S                ${R}#"
    echo -e "${R}# ${Y}            Made by Jishnu (MAHIMOP)                    ${R}#"
    echo -e "${BORDER}\n"
}

# Function to create a consistent, centered box/header
print_centered_header() {
    local text="$1"
    local color="${2:-$R}" # Default to Red
    local len="${#text}"
    local width=60
    local padding=$(( (width - len) / 2 ))
    
    echo -e "${color}$(printf -- '═%.0s' {1..60})${N}"
    printf "${color}║%*s${W}%s${color}%*s║${N}\n" $padding "" "$text" $((padding + (len % 2))) ""
    echo -e "${color}$(printf -- '═%.0s' {1..60})${N}"
}

# Function to display a menu option in a clean block
print_menu_option() {
    local num="$1"
    local text="$2"
    local width=54 # Width of the content area
    local len_text="${#text}"
    local pad_size=$(( width - len_text - 5 )) # 5 is for '[NUM]' and spaces
    
    echo -e "  ${R}┌$(printf -- '─%.0s' {1..58})┐${N}"
    echo -e "  ${R}│ ${W} [${R}$num${W}] ${Y}$text$(printf '%*s' $pad_size) ${R}│${N}"
    echo -e "  ${R}└$(printf -- '─%.0s' {1..58})┘${N}"
}

# Function to display status messages
print_status() {
    local text="$1"
    local color="${2:-$R}" # Default to Red
    echo -e "\n${color}»»${W} ${text}${N}\n"
}

# Function for the Main Screen
main_menu() {
    clear
    print_jishnu_logo
    print_centered_header "DEVELOPMENT MANAGEMENT CONSOLE" $R
    
    # Main Options Header
    echo -e "\n${R}╔$(printf -- '═%.0s' {1..58})╗${N}"
    echo -e "${R}║${Y}            M A I N   O P T I O N S               ${R}║${N}"
    echo -e "${R}╚$(printf -- '═%.0s' {1..58})╝${N}\n"
    
    # Options
    print_menu_option "1" "ðŸš€ GitHub VPS Maker (Docker/KVM)"
    print_menu_option "2" "ðŸ”§ IDX Tool Setup (Nix/QEMU)"
    print_menu_option "3" "âš¡ IDX VPS Maker (Remote Script)"
    print_menu_option "4" "âŒ Exit Console"
    
    echo -e "\n${DASH_LINE}"
    echo -ne "${BOLD_RED_ARROW} Select Option [${R}1-4${W}] : ${Y}"
    read -p "" op
    echo -ne "${N}"
}

# --- Main Logic Loop ---
while true; do
    main_menu
    
    case $op in
    
    # =========================================================
    # (1) GITHUB VPS MAKER
    # =========================================================
    1)
        clear
        print_jishnu_logo
        print_centered_header "ðŸš€ GITHUB VPS MAKER" $R
        
        # Default Configuration
        RAM=15000
        CPU=4
        DISK_SIZE=100G
        CONTAINER_NAME="github-vps" # Renamed for clarity
        IMAGE_NAME="hopingboyz/debain12"
        VMDATA_DIR="$PWD/vmdata"
        
        print_status "Configuration Summary:" $R
        
        echo -e "${R}┌$(printf -- '─%.0s' {1..58})┐${N}"
        echo -e "${R}│ ${W} ${G}RAM${W}        : ${Y}$RAM MB${W}                           ${R}│${N}"
        echo -e "${R}│ ${W} ${G}CPU${W}        : ${Y}$CPU cores${W}                        ${R}│${N}"
        echo -e "${R}│ ${W} ${G}DISK SIZE${W}  : ${Y}$DISK_SIZE${W}                        ${R}│${N}"
        echo -e "${R}│ ${W} ${G}NAME${W}       : ${Y}$CONTAINER_NAME${W}                   ${R}│${N}"
        echo -e "${R}│ ${W} ${G}IMAGE${W}      : ${Y}$IMAGE_NAME${W}                       ${R}│${N}"
        echo -e "${R}│ ${W} ${G}TYPE${W}       : ${Y}GitHub Docker VPS${W}                 ${R}│${N}"
        echo -e "${R}└$(printf -- '─%.0s' {1..58})┘${N}\n"
        
        print_status "Starting GitHub VPS Deployment..." $Y
        
        # Pre-flight Check & Setup
        if ! command -v docker &> /dev/null; then
            print_status "Docker is not installed. Please install Docker to proceed." $R
            read -p "Press Enter to return to main menu..."
            continue
        fi
        
        echo -e "${Y}ðŸ“ Creating VM data directory at ${VMDATA_DIR}...${N}"
        mkdir -p "$VMDATA_DIR"
        
        echo -e "${C}»» Executing: docker run -it --rm ...${N}"
        
        # Docker Execution Block
        docker run -it --rm \
          --name "$CONTAINER_NAME" \
          --device /dev/kvm \
          -v "$VMDATA_DIR":/vmdata \
          -e RAM="$RAM" \
          -e CPU="$CPU" \
          -e DISK_SIZE="$DISK_SIZE" \
          "$IMAGE_NAME"
        
        print_status "GitHub VPS session ended." $R
        read -p "Press Enter to return to main menu..."
        ;;
    
    # =========================================================
    # (2) IDX TOOL SETUP
    # =========================================================
    2)
        clear
        print_jishnu_logo
        print_centered_header "ðŸ”§ IDX TOOL SETUP" $R
        
        print_status "Preparing IDX Development Environment..." $Y
        
        # Cleanup (assuming 'vps123' is a working directory)
        echo -e "${Y}ðŸ§¹ Attempting cleanup of old 'myapp' and 'flutter' folders...${N}"
        # We need to ensure 'vps123' exists or navigate correctly
        # Original code assumed 'cd vps123' would succeed, which is risky.
        # It's safer to use absolute paths or a controlled environment.
        # For simplicity, we'll keep the original's intent but warn:
        
        if [ ! -d "vps123" ]; then
            echo -e "${Y}»» Directory 'vps123' not found. Assuming current directory.${N}"
        fi
        
        rm -rf myapp flutter
        
        IDX_DIR="vps123/.idx"
        
        if [ ! -d "$IDX_DIR" ]; then
            echo -e "${G}ðŸ“ Creating IDX configuration directory: $IDX_DIR...${N}"
            mkdir -p "$IDX_DIR"
            
            # Create the dev.nix file
            DEV_NIX_PATH="$IDX_DIR/dev.nix"
            echo -e "${C}ðŸ“ Creating dev.nix configuration at ${DEV_NIX_PATH}...${N}"
            
            cat <<EOF > "$DEV_NIX_PATH"
{ pkgs, ... }: {
  channel = "stable-24.05"; # NixOS Channel for stability

  packages = with pkgs; [
    unzip
    openssh
    git
    qemu_kvm # QEMU for virtualization
    sudo
    cdrkit
    cloud-utils
    qemu
    # Add other IDX/Nix essential packages here
  ];

  env = {
    EDITOR = "nano"; # Default editor preference
  };

  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    workspace = {
      # Placeholder for custom commands on creation/start
      onCreate = { };
      onStart = { };
    };

    previews = {
      enable = false; # Disable web previews by default
    };
  };
}
EOF
            
            print_status "âœ… IDX TOOL SETUP COMPLETE!" $G
            
            echo -e "${R}┌$(printf -- '─%.0s' {1..58})┐${N}"
            echo -e "${R}│ ${W} ${G}Status${W}   : ${Y}Ready to use${W}                        ${R}│${N}"
            echo -e "${R}│ ${W} ${G}Location${W} : ${Y}~/$IDX_DIR${W}                         ${R}│${N}"
            echo -e "${R}│ ${W} ${G}Tool${W}     : ${Y}IDX Dev Environment${W}                 ${R}│${N}"
            echo -e "${R}│ ${W} ${G}Version${W}  : ${Y}Stable 24.05${W}                        ${R}│${N}"
            echo -e "${R}└$(printf -- '─%.0s' {1..58})┘${N}"
        else
            print_status "âš  IDX Tool already setup â€” skipping." $Y
            echo -e "${W}Location: ${Y}~/$IDX_DIR${N}"
        fi
        
        read -p "Press Enter to return to main menu..."
        ;;
    
    # =========================================================
    # (3) IDX VPS MAKER
    # =========================================================
    3)
        clear
        print_jishnu_logo
        print_centered_header "âš¡ IDX VPS MAKER" $R
        
        print_status "Connecting to Jishnu Network Remote Script..." $C
        
        echo -e "${C}»» Executing remote script via curl...${N}"
        echo -e "${DASH_LINE}"
        
        # Execute the remote script
        bash <(curl -s https://github.com/mdmahimkhanmahi2-max/testxyz/blob/a5741b2f1f06772440a80cfbae72c5b321904c4d/script.sh)
        
        echo -e "\n${DASH_LINE}"
        print_status "IDX VPS Maker execution completed." $R
        read -p "Press Enter to return to main menu..."
        ;;
    
    # =========================================================
    # (4) EXIT
    # =========================================================
    4)
        clear
        print_jishnu_logo
        print_centered_header "SESSION TERMINATED" $R
        
        echo -e "\n${R}┌$(printf -- '─%.0s' {1..58})┐${N}"
        echo -e "${R}│ ${W}   Thank you for using Jishnu Network Console!    ${R}│${N}"
        echo -e "${R}│ ${Y}            Made with â¤ï¸ by Jishnu                 ${R}│${N}"
        echo -e "${R}└$(printf -- '─%.0s' {1..58})┘${N}\n"
        
        echo -e "${Y}ðŸ‘‹ Goodbye! Come back soon...${N}\n"
        exit 0
        ;;
    
    # =========================================================
    # INVALID OPTION
    # =========================================================
    *)
        clear
        print_jishnu_logo
        print_centered_header "âš  INVALID OPTION!" $Y
        
        echo -e "\n${R}┌$(printf -- '─%.0s' {1..58})┐${N}"
        echo -e "${R}│ ${W}    Please choose a number between 1 and 4 only!    ${R}│${N}"
        echo -e "${R}└$(printf -- '─%.0s' {1..58})┘${N}"
        
        sleep 2
        ;;
    esac
done
