#!/usr/bin/env bash

check() {
	echo -e "${CYAN}[CHECK]${RESET} $1"
}

review() {
	echo -e "${YELLOW}[REVIEW]${RESET} $1"
}

critical_review() {
	echo -e "${RED}[CRITICAL]${RESET} $1"
}

pass() {
	((PASS_COUNT++))
	
	if [[ "${SCAN_MODE:-0}" -eq 0 ]]; then
		echo -e "${GREEN}[PASS]${RESET} $1"
	fi
}

info() {
	((INFO_COUNT++))
	
	if [[ "${SCAN_MODE:-0}" -eq 0 ]]; then
		echo -e "${BLUE}[INFO]${RESET} $1"
	fi
}

warn() {
	((WARN_COUNT++))

        if [[ "${SCAN_MODE:-0}" -eq 0 ]]; then
		echo -e "${YELLO}[WARN]${RESET} $1"
        fi
}

critical() {
	((CRITICAL_COUNT++))

        if [[ "${SCAN_MODE:-0}" -eq 0 ]]; then
		echo -e "${RED}[CRITICAL]${RESET} $1"
        fi
}

error() {
	((ERROR_COUNT++))
	echo -e "${RED}[ERROR]${RESET} $1"
}

