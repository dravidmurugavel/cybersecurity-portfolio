#!/usr/bin/env bash
check_world_writable_files() {

	local root_owned
	local other_owned
	local line

	root_owned=$(sudo  find / -xdev -type f -user root -perm 0002 -perm /0111 -ls 2>/dev/null \
			-printf '%M %u %g %p\n' 2>/dev/null)
	other_owned=$(sudo find / -xdev -type f ! -user root -perm -0002 \
			-printf '%M %u %g %p\n' 2>/dev/null)

	if  [[ -n "$root_owned" ]]; then
		while IFS= read -r line; do
			[[ -z "$line" ]] && continue
	
			PRIVILEGE=3
			EXPOSURE=2
			LIKELIHOOD=3
			CONFIDNCE=3
	
			add_finding \
				"FILE" \
				"Root-owned world writable executables" \
				"A root-owned executable is writable by other users, allowing unauthorized modification of a privilege executable." \
				"$line"
	
		done <<< "$root_owned"
	fi

	if [[ -n "$other_owned" ]]; then
		while IFS= read -r line; do
			[[ -z "$line" ]] && continue
	
			PRIVILEGE=1
			EXPOSURE=2
			LIKELIHOOD=2
			CONFIDENCE=3
		
			add_finding \
				"FILE" \
				"World Writable file" \
				"A file is writable by other users and should be reviewed to determine whether the permissions are authorized." \
				"$line"
		
		done <<< "$other_owned"
	fi

	if [[ -z "$root_owned" && -z "$other_owned" ]]; then
		pass "No world writable files are found."
	fi
}

