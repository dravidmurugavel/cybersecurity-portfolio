#!/usr/bin/env bash

check_cron() {
	
	if ! command -v crontab >/dev/null 2>&1; then
		error "Required command not available: crontab"
		return
	fi

	local found=false
	local user_cron 
	local system_cron 
	local cron_file
	local line
	local schedule
	local run_user
	local command
	local owner
	local target
	local permissions
	local privileges
	local exposure
	local likelihood
	local confidence

	#-----------------------------------
	# Current user's crontab
	#-----------------------------------
	
	user_cron=$(crontab -l 2>/dev/null || true)

	while IFS= read -r line; do
		[[ -z "$line" ]] && continue
		[[ "$line" =~ ^[[:space:]]*# ]] && continue

		schedule=$(awk '{print $1" "$2" "$3" "$4" "$5}' <<< "$line")
		command=$(awk '{for (i=6; i<=NF; i++) printf "%s%s",$i,(i<NF?" ":"")]' <<< "$line")

		[[ -z "$command" ]] && continue
	
		found=true
		PRIVILEGE=1
		EXPOSURE=1
		LIKELIHOOD=2
		CONFIDENCE=3

		add_finding \
			"CRON" \
			"User cron job detected." \
			"A scheduled command exists in the current user's crontab and should be reviewed for expected persistence." \
			"User=$(id -un) Schedule=$schedule Command=$command"

	done <<< "$user_cron"

	#--------------------------------------
	# /etc/crontab
	#--------------------------------------

	if [[ -r /etc/crontab ]]; then

		system_cron=$(grep -Ev '^[[:space:]]*(#|$)' /etc/crontab)

		while IFS= read -r line; do
			[[ -z "$line" ]] && continue

			schedule=$(awk '{print $1" "$2" "$3" "$4" "$5}' <<< "$line")
			run_user=$(awk '{print $6}' <<< "$line")
			command=$(awk '{for (i=7; i<=NF; i++) printf "%s%s",$i,(i<NF?" ":"")}' <<< "$line")
		
			[[ -z "$command" ]] && continue
			found=true

			if [[ "$run_user" == "root" ]]; then
                		PRIVILEGE=3
                		LIKELIHOOD=1
           		else
                		PRIVILEGE=1
                		LIKELIHOOD=1
            		fi

                	EXPOSURE=1
                	CONFIDENCE=3

                	add_finding \
                		"CRON" \
                		"System cron job detected" \
                		"A system-wide scheduled command was identified and should be reviewed for expected execution and ownership." \
                		"File=/etc/crontab User=$run_user Schedule=$schedule Command=$command"

		done <<< "$system_cron"
	fi


	#---------------------------------------
	# /etc/cron.d/
	#---------------------------------------

	if [[ -d /etc/cron.d ]]; then

    		while IFS= read -r cron_file; do

       		[[ -z "$cron_file" ]] && continue
        	[[ "$(basename "$cron_file")" == ".placeholder" ]] && continue

        	while IFS= read -r line; do
			[[ -z "$line" ]] && continue
        		[[ "$line" =~ ^[[:space:]]*# ]] && continue

            		schedule=$(awk '{print $1" "$2" "$3" "$4" "$5}' <<< "$line")
            		run_user=$(awk '{print $6}' <<< "$line")
            		command=$(awk '{for (i=7; i<=NF; i++) printf "%s%s",$i,(i<NF?" ":"")}' <<< "$line")

            		[[ -z "$command" ]] && continue

            		found=true

            		owner=$(stat -c '%U' "$cron_file" 2>/dev/null || echo "unknown")
            		permissions=$(stat -c '%A' "$cron_file" 2>/dev/null || echo "unknown")

            	if [[ "$run_user" == "root" ]]; then
                	PRIVILEGE=3
            	else
                	PRIVILEGE=1
            	fi

            	EXPOSURE=1
            	LIKELIHOOD=1
            	CONFIDENCE=3

            # World/group writable cron configuration is more concerning.
            	if [[ "$permissions" == *w* ]]; then
                	LIKELIHOOD=3
            	fi

            	add_finding \
                	"CRON" \
                	"Cron configuration detected" \
                	"A scheduled task was found in /etc/cron.d/ and should be reviewed for ownership, privileges, and command legitimacy." \
                	"File=$cron_file Owner=$owner Permissions=$permissions User=$run_user Schedule=$schedule Command=$command"

        	done < "$cron_file"

    	done < <(find /etc/cron.d -maxdepth 1 -type f -print 2>/dev/null)

	fi

	#-------------------------------------------
	# Periodic cron directories
	#-------------------------------------------

	for target in /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly; do
		[[ -d "$target" ]] || continue
		while IFS= read -r cron_file; do
			[[ -z "$cron_file" ]] && continue
			found=true
			
			owner=$(stat -c '%U' "$cron_file" 2>/dev/null || echo "unknown")
			permissions=$(stat -c '%A' "$cron_file" 2>/dev/null || echo "unknown")
		
			PRIVILEGE=3
			EXPOSURE=1
			LIKELIHOOD=1
			CONFIDENCE=3

			if [[ "$run_user" == "root" ]]; then
				LIKELIHOOD=3
			fi
			add_finding \
				"CRON" \
				"Periodic cron script detected" \
				"A script exists in a system periodic cron directory and should be reviewed for ownership, permissions, and expected behavior." \
				"Directory=$target File=$cron_file Owner=$owner Permissions=$permissions"
		done < <(find "$target" -maxdepth 1 -type f -print 2>/dev/null)
	done
	if [[ "$found" == false ]]; then
		pass "No active cron jobs detected."
	fi
}
