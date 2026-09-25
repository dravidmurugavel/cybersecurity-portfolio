#!/usr/bin/env bash
	
show_main_menu() {
	echo
	echo " 1. Complete Security Scan"
	echo " 2. Run Individual Check"
	echo " 3. Export Report"
	echo " 4. Exit"
	echo
}

read_menu_choice() {	
	read -rp "Select an option: " MENU_CHOICE
}

show_check_menu() {
    echo
    echo " 1. Privileged Accounts"
    echo " 2. Login-capable Accounts"
    echo " 3. Sudo Configuration"
    echo " 4. World-writable Files"
    echo " 5. World-writable Directories"
    echo " 6. SUID Files"
    echo " 7. SGID Files"
    echo " 8. Listening Ports"
    echo " 9. Firewall"
    echo "10. SSH"
    echo "11. Cron"
    echo "12. Systemd"
    echo "13. Failed Authentication"
    echo " 0. Back"
    echo
}

read_check_choice() {
    read -rp "Select a check: " CHECK_CHOICE
}

show_export_menu() {
    echo
    echo " 1. Export TXT Report"
    echo " 2. Export JSON Report"
    echo " 3. Export Both"
    echo " 0. Back"
    echo
}

read_export_choice() {
    read -rp "Select an option: " EXPORT_CHOICE
}
