#!/usr/bin/env bash

FINDING_COUNT=0
declare -A FINDING_CHECK_COUNT
GENERATED_FINDING_ID=""

declare -a FINDING_ID
declare -a FINDING_CHECK
declare -a FINDING_TITLE
declare -a FINDING_DESCRIPTION
declare -a FINDING_EVIDENCE

declare -a FINDING_PRIVILEGE
declare -a FINDING_EXPOSURE
declare -a FINDING_LIKELIHOOD
declare -a FINDING_CONFIDENCE

declare -a FINDING_SCORE
declare -a FINDING_SEVERITY
declare -a FINDING_RECOMMENDATION

generate_finding_id() {
	local check="$1"
	local count

	count="${FINDING_CHECK_COUNT[$check]:-0}"
	((count += 1))	

	FINDING_CHECK_COUNT["$check"]="$count"
	
	printf -v GENERATED_FINDING_ID '%s-%03d' "$check" "$count"
}

add_finding() {
	local check="$1"
	local title="$2"
	local description="$3"
	local evidence="$4"
	
	generate_finding_id "$check"
	local id="$GENERATED_FINDING_ID"

	if ! calculate_risk; then
		echo "ERROR: Failed to calculate risk for finding: $id"
		return 1
	fi
	
	if ! classify_severity; then
		echo "ERROR: Failed to calculate risk for finding: $id"
		return 1
	fi

	if ! generate_recommendation; then
		echo "ERROR: Failed to generate recommendation for finding: $id"
		return 1
	fi

	((SCAN_FINDINGS +=1))

	FINDING_ID[$FINDING_COUNT]="$id"
	FINDING_CHECK[$FINDING_COUNT]="$check"
        FINDING_TITLE[$FINDING_COUNT]="$title"
        FINDING_DESCRIPTION[$FINDING_COUNT]="$description"
        FINDING_EVIDENCE[$FINDING_COUNT]="$evidence"

        FINDING_PRIVILEGE[$FINDING_COUNT]="$PRIVILEGE"
        FINDING_EXPOSURE[$FINDING_COUNT]="$EXPOSURE"
        FINDING_LIKELIHOOD[$FINDING_COUNT]="$LIKELIHOOD"
        FINDING_CONFIDENCE[$FINDING_COUNT]="$CONFIDENCE"

        FINDING_SCORE[$FINDING_COUNT]="$RISK_SCORE"
        FINDING_SEVERITY[$FINDING_COUNT]="$SEVERITY"
        FINDING_RECOMMENDATION[$FINDING_COUNT]="$RECOMMENDATION"

        ((FINDING_COUNT+=1))
	
	return 0
}
