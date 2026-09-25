#!/usr/bin/env bash

check_uid0() {

	local uid0_accounts
	local account
	local additional=false

	uid0_accounts=$(getent passwd | awk -F: '$3 == 0 {print $1}')
	
	if  [[ -z "$uid0_accounts" ]]; then
		error "Unable to identify UID 0 accounts."
		return
	fi

	while IFS= read -r account; do
		[[ -z "$account" ]] && continue		
		if [[ "$account" == "root" ]]; then
			continue
		fi
		additional=true
		
		PRIVILEGE=3
		EXPOSURE=1
		LIKELIHOOD=2
		CONFIDENCE=3
		
		add_finding \
			"UID" \
			"Additional UID 0 account"  \
			"An account other than root has UID 0 and therefore has root-equivalent privileges." \
			"$account: UID 0 entry in /etc/passwd" 

	done <<< "$uid0_accounts"
	
	if [[ "$additional" == false ]];then
		pass "Only root has UID 0."
	fi
}

