#!/usr/bin/env bash
check_suid() {
	
	local suid
	local line
	local path

	suid=$(sudo find / -xdev -type f -perm -4000 -printf '%M %u %g %p\n' 2>/dev/null)
	
	if [[ -z "$suid" ]]; then
		info "No SUID files detected."
		return
	fi

	while IFS= read -r line; do
		[[ -z "$line" ]] && continue
	
		path=$(awk '{print $4}' <<< "$line")

		if sudo find "$path" -perm -4000 -perm /022 -print -quit 2>/dev/null | grep -q .; then
			
			PRIVILEGE=3
			EXPOSURE=2
			LIKELIHOOD=3
			CONFIDENCE=3
			
			add_finding \
				"SUID" \
				"Writable privileged executable" \
				"A SUID executable is writable by its group or other users." \
				"$line"

		elif dpkg -S "$path" >/dev/null 2>&1; then
			pass "Package managed SUID file: $path"

		else
			PRIVILEGE=3
			EXPOSURE=1
			LIKELIHOOD=2
			CONFIDENCE=2

			add_finding \
				"SUID" \
				"Non-package managed SUID executable" \
				"A SUID executable was found that is not associated with an installed debian package." \
				"$line"
		fi
	done <<< "$suid"
}

