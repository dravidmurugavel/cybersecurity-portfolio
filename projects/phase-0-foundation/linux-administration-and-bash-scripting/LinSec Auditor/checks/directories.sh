#!/usr/bin/env bash
check_world_writable_directories() {

	local sticky
	local no_sticky

	sticky=$(sudo find / -xdev -type d -perm -0002 -perm -1000 \
			-printf '%M %u %g %p\n' 2>/dev/null)
	no_sticky=$(sudo find / -xdev -type d -perm -0002 ! -perm -1000 \
			-printf '%M %u %g %p\n' 2>/dev/null)
	
	if [[ -n "$sticky" ]]; then
		pass "World-writable directories have appropriate sticky-bit protection."
	fi

	if [[ -n "$no_sticky" ]]; then
		
		while IFS= read -r line; do
			[[ -z "line" ]] && continue
			
			PRIVILEGE=2
			EXPOSURE=2
			LIKELIHOOD=3
			CONFIDENCE=3
			
			add_finding \
				"DIR" \
				"World-writable directory without sticky bit"
				"A world-writable directory does not have sticky-bit protection, allowing users to potentially delete or rename files belonging to other users." \
				"$line"
		done <<< "$no_sticky"
	fi

	if [[ -z "$sticky" && -z "$no_sticky" ]]; then
		pass "No concerning world writable directories were found"
	fi
}

