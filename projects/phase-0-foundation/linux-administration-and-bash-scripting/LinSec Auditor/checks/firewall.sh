#!/usr/bin/env bash

check_firewall() {

	if ! command -v nft >/dev/null 2>&1; then
		error "Required command not available: nft"
		return
	fi
	
	local ruleset
	local policies
	local policy=""
	local chain=""
	local table

	ruleset=$(sudo nft list ruleset 2>/dev/null)
	
	if [[ -z "$ruleset" ]]; then

		PRIVILEGE=3
		EXPOSURE=3
		LIKELIHOOD=3
		CONFIDENCE=3

		add_finding \
			"FIREWALL"
			"No active nftables ruleset" \
			"No active nftables ruleset was detected on the host." \
			"nft list ruleset returned no active rules."
		return
	fi

	policies=$(grep -E 'chain .* \{|policy (accept|drop|reject)' <<< "$ruleset")
	
	if [[ -z "$policies" ]]; then
		info "Firewall ruleset exists but no default chain policies were identified."
		return
	fi

	while  IFS= read -r line; do
		[[ -z "$line" ]] && continue

		if [[ "$line" =~ chain[[:space:]]+([^[:space:]]+) ]]; then
			chain="${BASH_REMATCH[1]}"
			policy=""
			continue
		fi
		
		if [[ "$line" =~ policy[[:space:]]+(accept|drop|reject) ]]; then
			policy="${BASH_REMATCH[1]}"
		else
			continue
		fi
		
		if [[ "$policy" == "accept" ]]; then
			if [[ "$chain" == "input" ]]; then
				PRIVILEGE=2
				EXPOSURE=3
				LIKELIHOOD=2
				CONFIDENCE=3
			
				add_finding \
					"FIREWALL" \
					"Permissive firewall input policy." \
					"An input chain uses ACCEPT as its defualt policy. Network traffic is permitted unless explicitly blocked by another rule." \
					"Chain=$chain Policy=$policy"
			elif [[ "$chain" == "forward" ]]; then
				PRIVILEGE=2
				EXPOSURE=3
				LIKELIHOOD=1
				CONFIDENCE=3
				
				add_finding \
					"FIREWALL" \
					"Permissive firewall forward policy." \
					"The forwarding chain uses ACCEPT as its default policy." \
					"Chain=$chain Policy=$policy"
			elif [[ "$chain" == "output" ]]; then
				info "Permissive firewall output policy detected."
			fi
		elif [[ "$policy" == "drop" || "$policy" == "reject" ]]; then
			pass "Restrictive firewall policy detected: $chain -> $policy"
		fi

	done <<< "$policies"
}
