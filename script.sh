#!/bin/bash
set -euo pipefail

# ========================================================================
# Enhanced Multi-VM Manager (QEMU/KVM & Cloud-Init)
# ========================================================================
# Base Code Credit: HOPINGBOYZ & EDIT BY NOBITA
# Completed & Remastered by Gemini
# Used for safe, authorized, educational, and testing purposes only.

# --- Global Configuration & Variables ---
VM_DIR="$HOME/qemu_vms"

# OS_OPTIONS: OS_NAME="OS_TYPE|CODENAME|IMG_URL|DEFAULT_HOSTNAME|DEFAULT_USERNAME|DEFAULT_PASSWORD"
declare -A OS_OPTIONS=(
    ["Ubuntu 22.04 LTS (Jammy)"]="ubuntu|jammy|https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img|ubuntu-vm|ubuntu|ubuntu"
    ["Debian 12 (Bookworm)"]="debian|bookworm|https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2|debian-vm|debian|debian"
    ["Alpine Linux Edge"]="alpine|edge|https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-virt-3.19.1-x86_64.iso|alpine-vm|alpine|alpine"
)

# --- Utility Functions ---

# Function to display header
display_header() {
    clear
    cat << "EOF"
========================================================================
                       _ _     _                 
                      | (_)   | |                
                      | |_ ___| |__  _ __  _   _ 
                  _   | | / __| '_ \| '_ \| | | |
                 | |__| | \__ \ | | | | | | |_| |
                  \____/|_|___/_| |_|_| |_|\__,_| 
                                                                  
        QEMU/KVM VIRTUAL MACHINE MANAGER | HOPINGBOYZ & NOBITA
========================================================================
EOF
    echo
}

# Function to display colored output with emojis
print_status() {
    local type=$1
    local message=$2
    
    # ANSI Color Codes: 31=Red, 32=Green, 33=Yellow, 34=Blue, 36=Cyan, 0=Reset
    case $type in
        "INFO") echo -e "\033[1;34mðŸ“‹ [INFO]\033[0m $message" ;;
        "WARN") echo -e "\033[1;33mâš ï¸  [WARN]\033[0m $message" ;;
        "ERROR") echo -e "\033[1;31mâŒ [ERROR]\033[0m $message" ;;
        "SUCCESS") echo -e "\033[1;32mâœ… [SUCCESS]\033[0m $message" ;;
        "INPUT") echo -e "\033[1;36mðŸŽ¯ [INPUT]\033[0m $message" ;;
        *) echo "[$type] $message" ;;
    esac
}

# --- VM Management Functions (Restored/Completed) ---

# [check_image_lock, validate_input, check_dependencies, cleanup, get_vm_list, 
#  load_vm_config, save_vm_config, create_new_vm, setup_vm_image, 
#  start_vm, delete_vm, show_vm_info, is_vm_running, stop_vm, edit_vm_config, resize_vm_disk]
# ... (Functions above are assumed to be present from the user's provided block)
# ... The implementation below is the continuation of the final cut-off function.

# Function to fix VM issues (Continuation of cut-off code)
fix_vm_issues() {
    local vm_name=$1
    
    if load_vm_config "$vm_name"; then
        print_status "INFO" "ðŸ”§ Fixing issues for VM: $vm_name"
        
        while true; do
            echo "ðŸ”§ Select issue to fix:"
            echo "  1) ðŸ”“ Remove lock files"
            echo "  2) ðŸŒ± Recreate cloud-init seed image (if user/network config failed)"
            echo "  3) â†©ï¸  Back to VM menu"
            
            read -p "$(print_status "INPUT" "ðŸŽ¯ Enter your choice: ")" fix_choice
            
            case $fix_choice in
                1)
                    if [[ -f "${IMG_FILE}.lock" ]]; then
                        rm -f "${IMG_FILE}.lock" 2>/dev/null
                        print_status "SUCCESS" "âœ… Removed lock file: ${IMG_FILE}.lock"
                    else
                        print_status "INFO" "â„¹ï¸  No lock file found to remove."
                    fi
                    ;;
                2)
                    print_status "INFO" "ðŸ”„ Recreating cloud-init seed image..."
                    # This calls setup_vm_image, which recreates the seed ISO
                    # using current VM_NAME, HOSTNAME, USERNAME, and PASSWORD.
                    setup_vm_image
                    ;;
                3)
                    break
                    ;;
                *)
                    print_status "ERROR" "âŒ Invalid selection"
                    ;;
            esac
            read -p "$(print_status "INPUT" "âŽ Press Enter to continue...")"
            display_header
            print_status "INFO" "ðŸ”§ Fixing issues for VM: $vm_name"
        done
    fi
}


# Function to manage a selected VM
vm_management_menu() {
    local vm_name=$1
    
    while true; do
        display_header
        print_status "INFO" "ðŸš€ Managing VM: $vm_name"
        echo "ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹"
        
        # Check if running and show status
        if is_vm_running "$vm_name"; then
            print_status "SUCCESS" "ðŸš€ Status: Running (PID: $(pgrep -f "qemu-system.*$vm_name" | head -1))"
            local run_text="ðŸ›‘ Stop VM"
        else
            print_status "WARN" "ðŸ’¤ Status: Stopped"
            local run_text="ðŸš€ Start VM"
        fi
        
        echo "ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹ðŸ”¹"
        
        echo "  1) $run_text"
        echo "  2) ðŸ“Š Show Info"
        echo "  3) âœï¸  Edit Configuration"
        echo "  4) ðŸ’¾ Resize Disk Image"
        echo "  5) ðŸ”§ Fix Common Issues"
        echo "  6) ðŸ“ˆ Show Performance Metrics"
        echo "  7) ðŸ—‘ï¸  Delete VM (Permanent)"
        echo "  0) â†©ï¸  Back to Main Menu"
        
        read -p "$(print_status "INPUT" "ðŸŽ¯ Enter your choice: ")" action_choice
        
        display_header # Clear screen before running action
        
        case $action_choice in
            1)
                if is_vm_running "$vm_name"; then
                    stop_vm "$vm_name"
                else
                    start_vm "$vm_name"
                fi
                read -p "$(print_status "INPUT" "âŽ Press Enter to continue...")"
                ;;
            2) show_vm_info "$vm_name" ;;
            3) edit_vm_config "$vm_name" ;;
            4) resize_vm_disk "$vm_name" ;;
            5) fix_vm_issues "$vm_name" ;;
            6) show_vm_performance "$vm_name" ;;
            7) 
                delete_vm "$vm_name"
                return # Exit back to main menu after deletion
                ;;
            0) return ;;
            *) print_status "ERROR" "âŒ Invalid selection"
               read -p "$(print_status "INPUT" "âŽ Press Enter to continue...")"
               ;;
        esac
    done
}

# --- Main Program Entry Point ---
main_menu() {
    check_dependencies
    
    while true; do
        display_header
        
        print_status "INFO" "ðŸ“¦ VM Directory: $VM_DIR"
        echo "========================================================================"
        echo "                      M A I N   M E N U"
        echo "========================================================================"
        
        echo "  1) ðŸ†• Create New VM"
        echo "  2) ðŸš€ Manage Existing VM"
        echo "  0) âŒ Exit"
        echo
        
        read -p "$(print_status "INPUT" "ðŸŽ¯ Enter your choice: ")" main_choice
        
        case $main_choice in
            1)
                display_header
                create_new_vm
                read -p "$(print_status "INPUT" "âŽ Press Enter to continue...")"
                cleanup
                ;;
            2)
                local vm_list=$(get_vm_list)
                if [[ -z "$vm_list" ]]; then
                    print_status "WARN" "âš ï¸  No VMs found in $VM_DIR."
                    read -p "$(print_status "INPUT" "âŽ Press Enter to continue...")"
                    continue
                fi
                
                display_header
                print_status "INFO" "ðŸŒ Select a VM to manage:"
                local i=1
                local selected_vms=()
                for vm in $vm_list; do
                    echo "  $i) $vm"
                    selected_vms[$i]="$vm"
                    ((i++))
                done
                echo "  0) â†©ï¸  Back to Main Menu"
                
                while true; do
                    read -p "$(print_status "INPUT" "ðŸŽ¯ Enter VM number (1-$((i-1))) or 0: ")" vm_choice
                    if [[ "$vm_choice" =~ ^[0-9]+$ ]] && [ "$vm_choice" -ge 0 ] && [ "$vm_choice" -lt "$i" ]; then
                        if [ "$vm_choice" -eq 0 ]; then
                            break
                        fi
                        local selected_vm="${selected_vms[$vm_choice]}"
                        vm_management_menu "$selected_vm"
                        break
                    else
                        print_status "ERROR" "âŒ Invalid selection. Try again."
                    fi
                done
                ;;
            0)
                print_status "INFO" "ðŸ‘‹ Exiting VM Manager. Goodbye!"
                exit 0
                ;;
            *)
                print_status "ERROR" "âŒ Invalid selection"
                read -p "$(print_status "INPUT" "âŽ Press Enter to continue...")"
                ;;
        esac
    done
}

# --- Execute Main Program ---
main_menu
