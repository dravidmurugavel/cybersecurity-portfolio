#!/usr/bin/env bash

print_findings_json() {

	local first=true
	local i

	echo "{"
	echo '  "findings":['
	
	while IFS= read -r i; do
		[[ -z "$i" ]] && continue
		
		if [[ "$first" == false ]]; then
  			echo "       ,"
		fi

		jq -n \
		     --arg id "${FINDING_ID[$i]}" \
		     --arg check "${FINDING_CHECK[$i]}" \
		     --arg title "${FINDING_TITLE[$i]}" \
		     --arg description "${FINDING_DESCRIPTION[$i]}" \
		     --arg evidence "${FINDING_EVIDENCE[$i]}" \
		     --arg recommendation "${FINDING_RECOMMENDATION[$i]}" \
		     --argjson privilege "${FINDING_PRIVILEGE[$i]}" \
		     --argjson exposure "${FINDING_EXPOSURE[$i]}" \
		     --argjson likelihood "${FINDING_LIKELIHOOD[$i]}" \
		     --argjson confidence "${FINDING_CONFIDENCE[$i]}" \
		     --argjson risk_score "${FINDING_SCORE[$i]}" \
		     --arg severity "${FINDING_SEVERITY[$i]}" \
		     '{
			id: $id,
			check: $check,
			title: $title,
			description: $description,
			evidence: $evidence,
			privilege: $privilege,
			likelihood: $likelihood,
			confidence: $confidence,
			risk_score: $risk_score,
			severity: $severity,
			recommendation: $recommendation
		     }' |
		     sed 's/^/      /'

		first=false
	done< <(get_sorted_finding_indexes)

	echo "   ]"
	echo "}"
}



