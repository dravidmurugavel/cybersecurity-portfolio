#!/usr/bin/env bash

SERVICE_BASELINE="config/service_baseline.conf"

is_service_authorized() {
                local service="$1"
                local protocol="$2"
                local port="$3"
                
                [[ -f "$SERVICE_BASELINE" ]] || return 2
                
                grep -Fqx "^${service}|${protocol}|${port}$" "$SERVICE_BASELINE"
}

check_listening_ports() {
	
	if ! command -v ss >/dev/null 2>&1; then
		error "Required command not available: ss"
		return
	fi
	
	local line
	local protocol
	local local_address
	local process
	local service
	local port
	local baseline_status
	 
	while IFS= read -r line; do
		[[ -z "$line" ]] && continue
		
		protocol=$(awk '{print $1}' <<< "$line")
		local_address=$(awk '{print $5}' <<< "$line")
		process=$(grep -o 'users:(.*' <<< "$line" | head -n1)

		service=$(sed -n 's/.*users:(("\([^"]*\)".*/\1/p' <<< "$line")
		port="${local_address##*:}"
		
		if [[ "$local_address" == *"]:"* ]]; then
			port="${local_address##*:}"
		fi

		if ! [[ "$port" =~ ^[0-9]+$ ]]; then 
			continue
		fi

		if is_service_authorized "$service" "$protocol" "$port"; then
			baseline_status="YES"
		else
			baseline_status="NO"
		fi

		if [[ "$local_address" == 127.*:* || "$local_address" == "[::1]:"* ||
			"$local_address" == "127.0.0.53%"* || "$local_address" == "127.0.0.54:"* ]]; then

			PRIVILEGE=1
			EXPOSURE=1
			LIKELIHOOD=1
			CONFIDENCE=3
			
		else
			PRIVILEGE=1
			EXPOSURE=3

			if [[ "$baseline_status" == "YES" ]]; then
				LIKELIHOOD=1
			else
				LIKELIHOOD=3
			fi

			CONFIDENCE=3
		fi

		if [[ "$baseline_status" == "YES" ]]; then
			add_finding \
				"PORT" \
				"Expected listening service" \
				"A listening service was detected and matches the local authorized service baseline." \
				"Service=$service Protocol=$protocol Port=$port Bind=$local_address Baseline=YES Process=$process"
		else
			add_finding \
				"PORT" \
				"Unrecognized or unauthorized listening service" \
				"A listening service was detected that does not match the local authorized service baseline." \
				"Service=$service Protocol=$protocol Port=$port Bind=$local_address Baseline=NO Process=$process"
		fi

	done < <(sudo ss -H -lntup 2>/dev/null)

	if (( FINDING_COUNT == 0 )); then
		info "No listening sockets were successfully assessed."
	fi

}
	
