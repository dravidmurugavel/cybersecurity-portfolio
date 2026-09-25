#!/usr/bin/env bash
check_ssh() {
	
	if ! command -v ss >/dev/null 2>&1; then
		error "Required command not available: ss"
		return
	fi

	local ssh_listener
	local ssh_config="/etc/ssh/sshd_config"
	local ssh_port
	local bind_address
	local password_auth
	local permit_root
	local authorized_users

	ssh_listener=$(sudo ss -lntp 2>/dev/null | grep -E ':(22|2222)\b' || true)
	
	# -------------------------------------------------
	# No SSH listener
	# -------------------------------------------------
	
	if [[ -z "$ssh_listener" ]]; then
		pass "SSH is not currently exposed through ports 22 or 2222."
		echo "  Evidence: No SSSH listener detected."
		return
	fi
	
	echo "  Evidence:"
	printf '%s\n' "$ssh_listener"
	
	#-------------------------------------------------
	# Determine SSH port
	#-------------------------------------------------

	ssh_port=$(awk '{print $4}' <<< "$ssh_listener" | sed 's/.*://')

	#-------------------------------------------------
	# Determine bind address
	#-------------------------------------------------

	bind_address=$(awk '{print $4}' <<< "$ssh_listener")

	#-------------------------------------------------
	# Exposure assessment
	#-------------------------------------------------

	local network_exposed=false
	if  [[ "$bind_address" == 0.0.0.0:* || "$bind_address" == \[::\]:* ||
		"$bind_address" == \*:* ]]; then
		network_exposed=true
	fi

	#-------------------------------------------------
	# SSH configuration
	#-------------------------------------------------

	if [[ -r "$ssh_config" ]]; then
		password_auth=$(grep -Ei '^[[:space:]]*PasswordAuthentication[[:space:]]+' \
			"$ssh_config" | tail -n 1 | awk '{print tolower($2)}')
		permit_root=$(grep -Ei '^[[:space:]]*PermitRootLogin[[:space:]]+' \
			"ssh_config" | tail -n 1 | awk '{print to lower($2)}')
	else
		warn "SSH server configuration file is unavailable."
		password_auth="unknown"
		permit_root="unknown"
	fi

	#-------------------------------------------------
	# Authorized SSH users
	#-------------------------------------------------

	authorized_users=$(awk -F: '$3 >= 1000 && $3 < 60000 && $7 !~ /(nologin|false)$/ {print $1}' /etc/passwd 2>/dev/null || true)

	#-------------------------------------------------
	# Network-exposed SSH
	#-------------------------------------------------

	if [[ "$network_exposed" == true ]]; then
		PRIVILEGE=2
		EXPOSURE=3
		LIKELIHOOD=2
		CONFIDENCE=3

		if [[ "$password_auth" == "yes" ]]; then
			LIKELIHOOD=3
		fi
	
		if [[ "$permit_root" == "yes" ]]; then
			PRIVILEGE=3
			LIKELIHOOD=3
		fi

		add_finding \
			"SSH" \
			"Network-exposed SSH service" \
			"An SSH service is listening on a network-accessible address and requires review of authentiction and privileged access controls." \
			"Port=$port Bind=$bind_address PasswordAuthentication=$password_auth PermitRootLogin=$permit_root AuthorizedUsers=${authorized_users:-none}"

	else
		PRIVILEGE=1
		EXPOSURE=1
		LIKELIHOOD=1
		CONFIDENCE=3

		add_finding \
			"SSH"
			"Local-only SSH service" \
			"An SSH service is listening but is bound only to a local address." \
                        "Port=$port Bind=$bind_address PasswordAuthentication=$password_auth PermitRootLOGIN=$permit_root AuthorizedUsers=${authorized_users:-none}"
	fi

	#--------------------------------------------------
	# configuration observations
	#--------------------------------------------------

	if [[ "$password_auth" == "yes" ]]; then
		info "SSH password authentication is enabled."
	elif [[ "$password_auth" == "no" ]]; then
		pass "SSH password authentication is disabled."
	else
		info "SSH password authentication setting could not be determined."
	fi

	if [[ "$permit_root" == "yes" ]]; then
		warn "SSH root login is explicitly permitted."
	elif [[ "$permit_root" == "no" || "$permit_root" == "prohibit-password" || "$permit_root" == "without-password" ]]; then
		pass "Direct SSH root login is restricted."
	else
		info "SSH root-login policy is using the SSH server default or could not be determined."
	fi

	echo "	SSH Assessment:"
	echo "	   Port             : ${ssh_port:-unknown}"
	echo "	   Bind Address     : ${bind_address:-unknown}"
	echo "	   Network Exposed  : $network_exposed"
	echo "	   Password Auth    : ${password_auth:-unknown}"
	echo "	   Root Login       : ${permit_root:-default/unknown}"
	echo "	   Authorized Users : ${authorized_users:-none}"
}
