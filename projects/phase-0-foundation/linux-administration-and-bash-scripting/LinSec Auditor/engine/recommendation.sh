#!/usr/bin/env bash

generate_recommendation() {
	case "$SEVERITY" in
		CRITICAL)
		   RECOMMENDATION="Immediately investigate the finding, validate authorization, preserve relevant evidence, and review containment actions."
		   ;;
		HIGH)
		   RECOMMENDATION="Investigate promptly, validate authorization and exposure, and review appropriate containment actions."
		   ;;
		MEDIUM)
		   RECOMMENDATION="Review the configuration, validate the supporting evidence, and determine whether corrective action is required."
		   ;;
		LOW)
		   RECOMMENDATION="Review the finding during routine security hardening and confirm that the configuration is expected."
		   ;;
		INFO)
		   RECOMMENDATION="Document the finding and review it for security awareness or future hardening."
		   ;;
		*)
		   echo "ERROR: Invalid severity: $SEVERITY"
		   return 1
		   ;;
	esac

	return 0
}
