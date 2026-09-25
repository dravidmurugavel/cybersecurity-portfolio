#!/usr/bin/env bash

validate_risk_inputs() {
	if ! [[ "$PRIVILEGE" =~ ^[0-3]$ ]]; then
		echo "ERROR: Invalid PRIVILEGE value: $PRIVILEGE"
		return 1
	fi

	if ! [[ "$EXPOSURE" =~ ^[0-3]$ ]]; then
		echo "ERROR: Invalid EXPOSURE value: $EXPOSURE"
		return 1
	fi

	if ! [[ "$LIKELIHOOD" =~ ^[0-3]$ ]]; then
		echo "ERROR: Invalid LIKELIHOOD value: $LIKELIHOOD"
		return 1
	fi

	if ! [[ "$CONFIDENCE" =~ ^[1-3]$ ]]; then
		echo "ERROR: Invalid CONFIDENCE value: $CONFIDENCE"
		return 1
	fi

	return 0
}

calculate_risk() {
	
	if ! validate_risk_inputs; then
		return 1
	fi

	RISK_SCORE=$(( (PRIVILEGE + EXPOSURE + LIKELIHOOD) * CONFIDENCE))

	return 0
}

classify_severity() {
	case "$RISK_SCORE" in 
		0|1|2|3|4|5)
			SEVERITY="INFO"
			;;
		6|7|8|9|10|11)
			SEVERITY="LOW"
			;;
		12|13|14|15|16|17)
			SEVERITY="MEDIUM"
			;;
		18|19|20|21|22)
			SEVERITY="HIGH"
			;;
		23|24|25|26|27)
			SEVERITY="CRITICAL"
			;;
		*)
			echo "ERROR: Invalid risk score: $RISK_SCORE"
			return 1
			;;
	esac

	return 0
} 
