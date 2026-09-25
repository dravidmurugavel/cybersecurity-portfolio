#!/usr/bin/env bash
check_sudo() {

	if ! command -v sudo >/dev/null 2>&1; then
		error "sudo command is not available"
		echo "  Evidence: sudo executable not found."
		echo "  Reason: Unable to assess sudo privileges."
		return
	fi
	
	local sudo_output
	
	if ! sudo_output=$(sudo -l 2>/dev/null); then
		error "Unable to inspect sudo privileges"
		echo "  Evidence: sudo -l could not be completed."
		echo "  Reason: Check may require authentication or elevated access."
		return
	fi
	
	if grep -Eq 'NOPASSWD: [[:space:]]*ALL|\(ALL[[:space:]]*:[[:space:]]*ALL\)[[:space:]]+ALL' <<< "$sudo_output"; then
		
		PRIVILEGE=3
		EXPOSURE=1
		LIKELIHOOD=3
		CONFIDENCE=3
		
		add_finding \
			"SUDO" \
			"Unrestricted sudo privileges" \
			"The current account has unrestricted sudo privileges that can provide full administrative control." \
			"$sudo_output"
		return
	fi

	if grep -Eq '^[[:space:]]*\([^)]*\)[[:space:]]*/' <<< "$sudo_output"; then
		pass "Sudo access is limited to specific commands."
		echo "  Evidence: Specific sudo command rules detected."
		echo "  Reason: Restricted sudo access follows least-privilege principles."
	else
		PRIVILEGE=2
		EXPOSURE=1
		LIKELIHOOD=1
		CONFIDENCE=2

		add_finding \
			"SUDO" \
			"Sudo privileges require manual review." \
			"Sudo privileges were detected but could not be automatically classified as unrestricted or specifically restricted." \
			"$sudo_output"
	fi
}

