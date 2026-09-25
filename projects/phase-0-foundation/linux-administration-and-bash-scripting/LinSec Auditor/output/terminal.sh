#!/usr/bin/env bash

print_severity() {
	local severity="$1"
	
	case "$severity" in
		INFO|LOW)
			echo -e "${GREEN}${severity}${RESET}"
			;;
		MEDIUM)
			echo -e "${YELLOW}${severity}${RESET}"
			;;
		HIGH|CRITICAL)
			echo -e "${RED}${severity}${RESET}"
			;;
		*)
			echo "$severity"
	esac
}

print_findings_terminal() {
	echo 
	echo "=========================================="
	echo -e "           ${BOLD}V2 Risk Assessment${RESET}             "
	echo "=========================================="

	if (( FINDING_COUNT == 0 )); then
		echo
		echo "[INFO] No security findings requiring assessment."
		return 0
	fi

	local i
	local index=1

	while IFS= read -r i; do
		[[ -z "$i" ]] && continue
		
		echo
		echo "---------------------------------"
		echo -e "       ${BOLD}Finding #$index${RESET}          "
		echo "---------------------------------"
		echo "ID            : ${FINDING_ID[$i]}"
		echo "Check         : ${FINDING_CHECK[$i]}"
		echo "Title         : ${FINDING_TITLE[$i]}"
		echo -e "Severity      : $(print_severity "${FINDING_SEVERITY[$i]}")"
		echo "Risk Score    : ${FINDING_SCORE[$i]}"
		echo
		echo "Risk Factors"
		echo "  Privilege   : ${FINDING_PRIVILEGE[$i]}"
		echo "  Exposure    : ${FINDING_EXPOSURE[$i]}"
		echo "  Likelihood  : ${FINDING_LIKELIHOOD[$i]}"
		echo "  Confidence  : ${FINDING_CONFIDENCE[$i]}"
		echo
		echo "Description   : ${FINDING_DESCRIPTION[$i]}"
		echo "Evidence      : ${FINDING_EVIDENCE[$i]}"
		echo "Recommendation: ${FINDING_RECOMMENDATION[$i]}"

		(( index +=1 ))
	done < <(get_sorted_finding_indexes)

	echo
	echo "============================================"
	echo -e "         ${BOLD}V2 FINDING SUMMARY${RESET}              "
	echo "============================================"

	local info=0
	local low=0
	local medium=0
	local high=0
	local critical=0
	
	for ((i=0; i<FINDING_COUNT; i++)); do
		case "${FINDING_SEVERITY[$i]}" in
			INFO)	((info +=1)) ;;
			LOW)	((low +=1)) ;;
			MEDIUM)	((medium +=1)) ;;
			HIGH)	((high +=1)) ;;
			CRITICAL)((critical +=1)) ;;
		esac
	done

	echo -e "INFO      : ${GREEN}$info${RESET}"
	echo -e "LOW       : ${GREEN}$low${RESET}"
	echo -e "MEDIUM    : ${YELLOW}$medium${RESET}"
	echo -e "HIGH      : ${RED}$high${RESET}"
	echo -e "CRITICAL  : ${RED}$critical${RESET}"
	echo -e "${BOLD}TOTAL${RESET}     : ${BOLD}$FINDING_COUNT${RESET}"

}
