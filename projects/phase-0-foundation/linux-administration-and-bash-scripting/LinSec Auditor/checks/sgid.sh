#!/usr/bin/env bash
check_sgid() {
	
	local sgid
	local line
	local path

	sgid=$(sudo find / -xdev -type f -perm -2000 -printf '%M %u %g %p\n' 2>/dev/null)
	
	if [[ -z "$sgid" ]]; then
		pass "No SGID files detected."
		return
	fi

	while IFS= read -r line; do
		[[ -z "$line" ]] && continue

		path=$(awk '{print $4}' <<< "$line")

		if sudo find "$path" -perm -2000 -perm /022 -print -quit 2>/dev/null | grep -q .; then
			PRIVILEGE=3
			EXPOSURE=2			
			LIKELIHOOD=3
			CONFIDENCE=3

			add_finding \
				"SGID" \
				"Writable privileged executable" \
				"An SGID executable is writable by its group or other users." \
				"$line"
		elif dpkg -S "$path" >/dev/null 2>&1; then
			pass "Package managed SGID file: $path"
		else
			
			PRIVILEGE=3
			EXPOSURE=1
			LIKELIHOOD=2
			CONFIDENCE=2

			add_finding \
				"SGID" \
				"Non-package managed SGID executable." \
				"An SGID executable was found that is not associated with an installed debian package." \
				"$line"
		fi	

	done <<< "$sgid"
}

