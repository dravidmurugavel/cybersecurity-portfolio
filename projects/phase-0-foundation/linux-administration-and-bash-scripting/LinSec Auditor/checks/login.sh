#!/usr/bin/env bash

check_login_accounts() {

	local found=false
	local interactive
	local valid_shell
	local username password uid gid gecos home shell

	while IFS=: read -r username password uid gid gecos home shell; do
		interactive=false
		for valid_shell in "${INTERACTIVE_SHELLS[@]}"; do
			if [[ "$shell" == "$valid_shell" ]]; then
				interactive=true
				break
			fi
		done
			
		if [[ "$interactive" == false ]]; then
			continue
		fi

		if [[ "$username" == "root" ]]; then
			 continue	
		fi
		found=true

		if (( uid >= 1000 && uid < 60000 )); then
			pass "Human/user account can log in: $username (UID=$uid, Shell=$shell)"
		else
			PRIVILEGE=1
			EXPOSURE=1
			LIKELIHOOD=2
			CONFIDENCE=3

			add_finding \
				"LOGIN" \
				"Login-capable system account" \
				"A system or service account has a login-capable shell and may have unnecessary interactive access." \
				"$username: UID=$uid, Shell=$shell, /etc/passwd"
		fi

	done < <(getent passwd)
	
	if [[ "$found" == false ]]; then
		info "No additional login-capable accounts detected."
	fi
}

