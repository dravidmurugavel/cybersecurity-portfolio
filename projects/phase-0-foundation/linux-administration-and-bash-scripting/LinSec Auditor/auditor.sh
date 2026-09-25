#!/usr/bin/env bash

source output/colors.sh
source output/status.sh
source output/menu.sh
source output/banner.sh

source engine/risk_engine.sh
source engine/recommendation.sh
source engine/finding.sh
source engine/finding_sort.sh

source output/terminal.sh
source output/json.sh

source checks/accounts.sh
source checks/login.sh
source checks/sudo.sh
source checks/files.sh
source checks/directories.sh
source checks/suid.sh
source checks/sgid.sh
source checks/network.sh
source checks/firewall.sh
source checks/ssh.sh
source checks/cron.sh
source checks/systemd.sh
source checks/auth.sh

set -u
set -o pipefail

SCRIPT_NAME="LinSec Auditor"
VERSION="2.1.0"

HOSTNAME="$(hostname)"
CURRENT_USER="$(id -un)"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
SERVICE_BASELINE="config/service_baseline.conf"
CLI_FORMAT="txt"

INTERACTIVE_SHELLS=(
	"/bin/bash"
	"/bin/sh"
	"/bin/dash"
	"/bin/zsh"
	"/bin/fish"
	"/bin/ksh"
	"/bin/tcsh"
	"/bin/csh"
	"/usr/bin/zsh"
)

KNOWN_SERVICES=(
    "accounts-daemon.service"
    "apache2.service"
    "console-setup.service"
    "cron.service"
    "getty@.service"
    "haveged.service"
    "keyboard-setup.service"
    "lightdm.service"
    "ModemManager.service"
    "networking.service"
    "NetworkManager.service"
    "nftables.service"
    "open-vm-tools.service"
    "regenerate-ssh-host-keys.service"
    "rsyslog.service"
    "smartmontools.service"
    "systemd-pstore.service"
    "systemd-resolved.service"
    "systemd-timesyncd.service"
    "tor.service"
    "ufw.service"
    "grub-install-devices.service"
    "NetworkManager-dispatcher.service"
    "NetworkManager-wait-online.service"
)

PASS_COUNT=0
INFO_COUNT=0
WARN_COUNT=0
CRITICAL_COUNT=0
ERROR_COUNT=0
SCAN_FINDINGS=0
SCAN_MODE=1

if [[ "$EUID" -eq 0 ]]; then
	ROOT_ACCESS="YES"
else 
	ROOT_ACCESS="NO"
fi

print_header() {
	echo "================================================="
	echo -e "      ${BOLD}$SCRIPT_NAME v$VERSION${RESET}"
	echo "================================================="
	echo 
	echo -e "${BOLD}Host:${RESET} ${BOLD}$HOSTNAME${RESET}"
	echo -e "${BOLD}User:${RESET} ${BOLD}$CURRENT_USER${RESET}"
	echo -e "${BOLD}Time:${RESET} ${BOLD}$TIMESTAMP${RESET}"
	echo -e "${BOLD}Root Privileges:${RESET} ${BOLD}$ROOT_ACCESS${RESET}"
}

get_exit_code() {
	if (( CRITICAL_COUNT > 0 )); then
		return 2
	elif (( WARN_COUNT > 0 )); then
		return 1
	elif (( ERROR_COUNT > 0 ));then
		return 3
	else
		return 0
	fi
}

is_service_authorized() {
		local service="$1"
		local protocol="$2"
		local port="$3"

		if [[ ! -f "$SERVICE_BASELINE" ]]; then
			return 2
		fi

		grep -Eq "^${service}\|${protocol}\|${port}$" "$SERVICE_BASELINE"
}

get_check_highest_severity() {
        local start_count="$1"
        local highest_score=0
        local i

        for ((i=start_count; i<FINDING_COUNT; i++)); do
                if (( FINDING_SCORE[i] > highest_score )); then
                        highest_score="${FINDING_SCORE[i]}"
                fi
        done

        echo "$highest_score"
}

run_check() {
        local check_function="$1"
        local check_name="$2"

        local findings_before="$FINDING_COUNT"
        local highest_score

	if [[ "${SCAN_MODE:-0}" -eq 0 ]]; then
    		check "$check_name"
	fi
        "$check_function"

        if (( FINDING_COUNT == findings_before )); then
                echo -e "${GREEN}[PASS]${RESET} No actionable findings."
		echo
                return
        fi

        highest_score=$(get_check_highest_severity "$findings_before")

	if [[ "${SCAN_MODE:-0}" -eq 0 ]]; then
    		if (( highest_score >= 23 )); then
        		critical_review "Critical findings detected — see V2 Risk Assessment."
    		elif (( highest_score >= 18 )); then
        		echo -e "${RED}[HIGH]${RESET} High-risk findings detected — see V2 Risk Assessment."
    		elif (( highest_score >= 12 )); then
        		echo -e "${YELLOW}[MEDIUM]${RESET} Findings detected — see V2 Risk Assessment."
    		else
        		review "Findings detected — see V2 Risk Assessment."
    		fi
    	        echo
	fi
}

reset_findings() {
	FINDING_COUNT=0
	SCAN_FINDINGS=0
	FINDING_CHECK_COUNT=()
}

individual_check_menu() {
    while true; do
        show_check_menu
        read_check_choice
        choice="$CHECK_CHOICE"

        case "$choice" in
            1)
                reset_findings
                run_check check_uid0 "Privileged Accounts"
                print_findings_terminal
                ;;
            2)
                reset_findings
                run_check check_login_accounts "Login-capable Accounts"
                print_findings_terminal
                ;;
            3)
                reset_findings
                run_check check_sudo "Sudo Configuration"
                print_findings_terminal
                ;;
            4)
                reset_findings
                run_check check_world_writable_files "World-writable Files"
                print_findings_terminal
                ;;
            5)
                reset_findings
                run_check check_world_writable_directories "World-writable Directories"
                print_findings_terminal
                ;;
            6)
                reset_findings
                run_check check_suid "SUID Files"
                print_findings_terminal
                ;;
            7)
                reset_findings
                run_check check_sgid "SGID Files"
                print_findings_terminal
                ;;
            8)
                reset_findings
                run_check check_listening_ports "Listening Ports"
                print_findings_terminal
                ;;
            9)
                reset_findings
                run_check check_firewall "Firewall Configuration"
                print_findings_terminal
                ;;
            10)
                reset_findings
                run_check check_ssh "SSH Security Assessment"
                print_findings_terminal
                ;;
            11)
                reset_findings
                run_check check_cron "Cron Jobs"
                print_findings_terminal
                ;;
            12)
                reset_findings
                run_check check_systemd "Systemd Services"
                print_findings_terminal
                ;;
            13)
                reset_findings
                run_check check_failed_logins "Failed Authentication"
                print_findings_terminal
                ;;
             0)
                return 0
                ;;
             *)
                echo -e "${YELLOW}Invalid option.${RESET}"
                echo
                ;;
        esac
    done
}

export_txt_report() {
    local timestamp
    local report_file
    local report_content

    timestamp=$(date '+%Y%m%d_%H%M%S')
    report_file="reports/security_audit_${timestamp}.txt"

    report_content=$(print_findings_terminal)

    printf '%s\n' "$report_content" |
        sed $'s/\033\\[[0-9;]*m//g' > "$report_file"

    echo -e "${GREEN}[PASS]${RESET} TXT report exported:"
    echo "$report_file"
    echo
}

export_json_report() {
    local timestamp
    local report_file

    timestamp=$(date '+%Y%m%d_%H%M%S')
    report_file="reports/security_audit_${timestamp}.json"

    print_findings_json > "$report_file"

    echo -e "${GREEN}[PASS]${RESET} JSON report exported:"
    echo "$report_file"
    echo
}

export_both_reports() {
    export_txt_report
    export_json_report
}

main_menu() {
    while true; do

        show_main_menu

	read_menu_choice
        choice="$MENU_CHOICE"

        case "$choice" in
            1)
                run_full_scan
                ;;
	    2)
		individual_check_menu
		;;
	    3)
		while true; do
		   show_export_menu
		   read_export_choice
		   choice="$EXPORT_CHOICE"

		   case "$choice" in
			1)
			     export_txt_report
			     ;;
			2)
			     export_json_report
			     ;;
			3)
			     export_both_reports
			     ;;
			0)
			     break
			     ;;
			*)
			     echo -e "{YELLOW}Invalid option. ${RESET}"
			     echo
			     ;;
			esac
		done
		;;
            4)
                echo "Exiting..."
                return 0
                ;;
            *)
                echo "Invalid option."
                echo
                ;;
        esac
    done
}

run_full_scan() {
    echo
    run_check check_uid0 "Privileged Accounts"
    run_check check_login_accounts "Login-capable Accounts"
    run_check check_sudo "Sudo Configuration"
    run_check check_world_writable_files "World-writable Files"
    run_check check_world_writable_directories "World-writable Directories"
    run_check check_suid "SUID Files"
    run_check check_sgid "SGID Files"
    run_check check_listening_ports "Listening Ports"
    run_check check_firewall "Firewall Configuration"
    run_check check_ssh "SSH Security Assessment"
    run_check check_cron "Cron Jobs"
    run_check check_systemd "Systemd Services"
    run_check check_failed_logins "Failed Authentication"
}

show_help() {
    cat <<EOF
LinSec Auditor

Usage:
    ./auditor.sh
    ./auditor.sh --help

Options:
    --help        
		Show this help message
    --full        
		Run a complete security scan
    --check NAME  
		Run a specific security check
    --format txt|json
                Select report format. Default: txt.
    --output FILE
                Save the generated report to FILE.

Available checks:
    priviledged
    login
    sudo
    world-writable-files
    world-writable-directories
    suid
    sgid
    ports
    firewall
    ssh
    cron
    systemd
    auth

Interactive mode:
    Running without arguments starts the interactive menu.

Exit Codes:
    0           Scan completed with no findings
    1           Scan completed with findings
    2           Invalid command-line usage
    3           Scan execution error

EOF
}

write_cli_report() {
    local format="$1"

    if [[ -z "$CLI_OUTPUT" ]]; then
        case "$format" in
            txt)
                print_findings_terminal
                ;;
            json)
                print_findings_json
                ;;
        esac
        return
    fi

    case "$format" in
        txt)
            print_findings_terminal > "$CLI_OUTPUT"
            ;;
        json)
            print_findings_json > "$CLI_OUTPUT"
            ;;
    esac

    echo -e "${GREEN}[PASS]${RESET} Report saved to: $CLI_OUTPUT"
}

run_cli_full_scan() {
    if [[ "$CLI_FORMAT" == "json" ]]; then
        run_full_scan >/dev/null
        local scan_status=$?

        if (( scan_status != 0 )); then
            echo -e "${RED}[ERROR]${RESET} Full scan failed." >&2
            return "$EXIT_ERROR"
        fi

        write_cli_report json
        return 0
    fi

    print_banner

    run_full_scan
    local scan_status=$?

    if (( scan_status != 0 )); then
        echo -e "${RED}[ERROR]${RESET} Full scan failed." >&2
        return "$EXIT_ERROR"
    fi

    write_cli_report txt
}

run_cli_check() {
    local check_name="$1"
    local check_status=0

    case "$check_name" in
        privileged)
            run_check check_uid0 "Privileged Accounts" || check_status=$?
            ;; 
        login)
            run_check check_login_accounts "Login-capable Accounts" || check_Status=$? 
            ;;
        sudo)
            run_check check_sudo "Sudo Configuration" || check_Status=$?
            ;;
        world-writable-files)
            run_check check_world_writable_files "World-writable Files" || check_status=$?
            ;;
        world-writable-directories)
            run_check check_world_writable_directories "World-writable Directories" || check_status=$?
            ;;
        suid)
            run_check check_suid "SUID Files" || check_status=$?
            ;;
        sgid)
            run_check check_sgid "SGID Files" || check_status=$?
            ;;
        ports)
            run_check check_listening_ports "Listening Ports" || check_status=$?
            ;;
        firewall)
            run_check check_firewall "Firewall Configuration" || check_Status=$?
            ;;
        ssh)
            run_check check_ssh "SSH Security Assessment" || check_Status=$?
            ;;
        cron)
            run_check check_cron "Cron Jobs" || check_status=$?
            ;;
        systemd)
            run_check check_systemd "Systemd Services" || check_status=$?
            ;;
        auth)
            run_check check_failed_logins "Failed Authentication" || check_status=$?
            ;;
        *)
            echo "Unknown check: $check_name"
            echo "Use './auditor.sh --help' for available checks."
            return "$EXIT_USAGE"
            ;;
    esac
    if (( check_status != 0 )); then
        echo -e "${RED}[ERROR]${RESET} Check execution failed: $check_name" >&2
        return "$EXIT_ERROR"
    fi
    write_cli_report "$CLI_FORMAT"
}

export_cli_report() {
    local format="$1"

    case "$format" in
        txt)
            print_terminal_report
            ;;
        json)
            print_findings_json
            ;;
        *)
            echo "Error: Unsupported format: $format" >&2
            echo "Supported formats: txt, json" >&2
            return 1
            ;;
    esac
}

EXIT_SUCCESS=0
EXIT_FINDINGS=1
EXIT_USAGE=2
EXIT_ERROR=3

get_scan_exit_code() {
    if (( FINDING_COUNT > 0 )); then
        return "$EXIT_FINDINGS"
    fi
    return "$EXIT_SUCCESS"
}

main() {

	print_banner
	print_header

	echo
	main_menu
}

CLI_MODE=""
CLI_CHECK=""
CLI_FORMAT="txt"
CLI_OUTPUT=""

while [[ $# -gt 0 ]]; do
	case "$1" in
    		--help|-h)
        	     show_help
		     exit 0
        	     ;;
    		--full)
		     CLI_MODE="full"
		     shift
		     ;;
    		--check)
		     if [[ -z "${2:-}" ]]; then
	    		echo "Error: --check requires a check name."
	    		exit "$EXIT_USAGE"
		     fi
		     CLI_MODE="check"
		     CLI_CHECK="$2"
		     shift 2
		     ;;
    		--format)
		     if [[ -z "${2:-}" ]]; then
	             	echo "Error: --format requires txt or json."
	    	        exit "$EXIT_USAGE"
		     fi
		     case "$2" in
		        txt|json)
			    CLI_FORMAT="$2"
			    ;;
		        *)
			    echo "Error: Unsupported format: $2"
			    echo "Supported formats: txt, json"
			    exit "$EXIT_USAGE"
			    ;;
		     esac
		     shift 2
		     ;;
		--output)
		     if  [[ -z "${2:-}" ]]; then
			echo "Error: --output requires a file path."
			exit "$EXIT_USAGE"
		     fi
	
		     CLI_OUTPUT="$2"
		     shift 2
		     ;;
	     *)
                echo "Unknown option: $1"
        	echo "Use './auditor.sh --help' for usage."
        	exit "$EXIT_USAGE"
        	;;	
	esac
done

if [[ -z "$CLI_MODE" ]] && [[ "$CLI_FORMAT" != "txt" || -n "$CLI_OUTPUT" ]]; then
    echo "Error: --format and --output require --full or --check." >&2
    exit "$EXIT_USAGE"
fi

case "$CLI_MODE" in
    full)
        reset_findings

        run_cli_full_scan
        cli_status=$?

        if (( cli_status != 0 )); then
            exit "$cli_status"
        fi
        ;;

    check)
        reset_findings

        run_cli_check "$CLI_CHECK"
        cli_status=$?

        if (( cli_status == EXIT_USAGE )); then
            exit "$EXIT_USAGE"
        elif (( cli_status == EXIT_ERROR )); then
            exit "$EXIT_ERROR"
        fi
        ;;
esac

get_scan_exit_code
exit $?
get_scan_exit_code
exit $?
