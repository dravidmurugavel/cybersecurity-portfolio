#!/usr/bin/env bash

# General Info
# Script Name : System_profiler.sh
# Description : Interactive Linux system profiling and health check utility
# Author      : dravidmurugavel
# Version     : 1.0
# Creaed Date : 2026-07-26
# License     : MIT 

# Creating Output files and folder
mkdir -p reports
REPORT="reports/$(hostname)_system_profile_$(date +%Y%m%d_%H%M%S).txt"

# Application Banner
banner() {
	if command -v figlet >/dev/null 2>&1; then
		figlet -f slant "System Profiler"
	else
		echo ""
		echo "=================================="
		echo "	     System Profiler		"
		echo "=================================="
		echo ""
	fi
}

# Application Info
info() {
	echo "Version: 1.0"
	echo "Author: dravidmurugavel"
}

# Helper for section 
section() {
	printf '\n==================== %s ====================\n\n' "$1" ;
}

# OS Informations
os_info() {
	section "OS Information"
	if has hostnamectl; then
		hostnamectl 
	else
		uname -a 
	fi
	echo
}

# CPU Informations
cpu_info() {
	section "CPU Information"
	if has lscpu; then
		lscpu
	else
		cat /proc/cpuinfo
	fi
	echo
}

# Memory Informations
memory_info() {
	section "Memory Information"
	if has free; then
		free -h
	else
		cat /proc/meminfo
	fi
	echo
}

# Storage Informations
storage_info() {
	section "Storage Information"
	df -hT
	echo
}

#Process Informations
process_info() {
	section "Process Information"
	echo "---------- TOP 10 CPU Consumers ----------"
	ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -11
	echo
	echo "-------- TOP 10 Memory Consumers ---------"
	ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -11
	echo
}

#Port Informations
port_info() {
	section "Ports Information"
	if has ss; then
		ss -tulnp
	elif has netstat; then
		netstat -tulnp
	else 
		echo "No Socket utility found"
	fi
}

# Helper for port informations
ports() {
	if has ss; then
		ports=$(ss -tuln | tail -n +2 | wc -l)
	elif has netstat; then
		ports=$(netstat -tuln | tail -n +3 | wc -l)
	else
		ports="N/A"
	fi
}

# Helper to check command existence
has() {
	command -v "$1" >/dev/null 2>&1
}

# Exit function
bye() {
	echo
	echo "Goodbye!"
	exit 0
}

# General Summary 
summary() {
	section "Summary"
	cat <<EOF
Hostname                  :  $(hostname)
Kernel                    :  $(uname -r)
CPU model	          :  $(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
CPU cores	          :  $(nproc)
CPU load average          :  $(cat /proc/loadavg)
Total RAM                 :  $(free -h | awk '/Mem:/ {print $2}')
Available RAM	          :  $(free -h | awk '/Mem:/ {print $7}')
Disk usage (/)            :  $(df -h / | awk 'NR==2 {print $3 " / " $2 " ("$5")"}')
Running Processes         :  $(ps -e --no-headers | wc -l)
Root filesystem usage     :  $(df -h / | awk 'NR==2 {print $5}')
Listening Ports	          :  $(netstat -tuln | tail -n +3 | wc -l)
Uptime 		          :  $(uptime -p)"
Zombie processes          :  $(ps -el | awk '$2 == 'Z'' | wc -l)
Failed systemctl services :  $(systemctl --failed | awk 'NR==3 {print $1}')
EOF
}

# Report Informations
report_info() {
	echo "Report time: $(date)"
	echo "Executed by: $(whoami)"
	echo "Version: 1.0"
	echo
}

# Overall Health
health() {
	section "System Health"
	root_usage=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')
	if (( root_usage < 80 )); then
		echo "✅ Root filesystem below 80% (${root_usage}%)"
	else
		echo "✗ Root filesystem high (${root_usage}%)"
	fi
	
	ram_usage=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
	if (( ram_usage < 80 )); then
		echo "✅ RAM usage normal (${ram_usage}%)"
	else
		echo "✗ RAM usage high (${ram_usage}%)"
	fi

	swap_total=$(free | awk '/Swap:/ {print $2}')
	if (( swap_total == 0 )); then
		echo "✅ Swap not configured"
	else
		swap_usage=$(free | awk '/Swap:/ {printf "%.0f", $3/$2*100}')
		if (( swap_usage < 80 )); then
			echo "✅ Swap usage normal (${swap_usage}%)"
		else
			echo "✗ Swap usage high (${swap_usage}%)"
		fi
	fi

	ports
	echo "✅ ${ports} listening ports"

	processes=$(ps -e --no-headers | wc -l)
	echo "✅ ${processes} running processes"

	gateway=$(ip route | awk '/default/ {print $3}')
	if ping -c 2 -W 2 "$gateway" >/dev/null 2>&1; then
		echo "✅ Gateway reachable ${gateway}"	
	else
		echo "✗ Gateway unreachable ${gateway}"
	fi

	if ping -c -W 30 8.8.8.8 >/dev/null 2>&1; then
		echo "✅ Internet reachable"
	else
		echo "✗ Internet unreachable"
	fi
	
	if (( root_usage < 80 && \
	      ram_usage < 80  && \
	      (swap_total == 0 || swap_usage < 50) )); then
		section "Overall Status: ✅ HEALTHY"
	else
		section "Overall Status: ✗ Attention Required"
	fi
}

# Calling all functions for generating full report
all() {
     {
	report_info	
	os_info
	cpu_info
	memory_info
	storage_info
	process_info
	port_info
	summary
	health
      } | tee "$REPORT"
	echo
	echo "Report saved as $REPORT"
}

# Menu loop
while true; do
	clear
	banner
	info
	echo
	cat <<EOF
1) OS information
2) CPU information
3) Memory information
4) Storage information
5) Process information	
6) Port information
7) Generate full report
8) Exit
EOF

	read -rp "Select an option [1-8]: " choice
	case $choice in 
		1) os_info | tee -a "$REPORT" ;;
		2) cpu_info | tee -a "$REPORT" ;;
		3) memory_info | tee -a "$REPORT" ;;
		4) storage_info | tee -a "$REPORT" ;;
		5) process_info | tee -a "$REPORT" ;;
		6) port_info | tee -a "$REPORT";;
		7) all ;;
		8) bye ;;
		*) echo " Invalid option. Please choose 1-8."
		;;
	esac
	echo ""
	read -rp "Press ENTER to return to the menu..."
done
