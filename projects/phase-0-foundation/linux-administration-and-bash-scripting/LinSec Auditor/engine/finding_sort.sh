#!/usr/bin/env bash

get_sorted_finding_indexes() {
	local i
	
	for ((i=0; i<FINDING_COUNT; i++)); do
		echo "$i:${FINDING_SCORE[$i]}"
	done |
	sort -t: -k2,2nr |
	cut -d: -f1
}
