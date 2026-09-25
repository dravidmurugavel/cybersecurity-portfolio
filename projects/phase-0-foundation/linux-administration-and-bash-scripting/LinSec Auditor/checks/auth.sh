#!/usr/bin/env bash

check_failed_logins() {

    local auth_log="/var/log/auth.log"

    if [[ ! -r "$auth_log" ]]; then
        error "Authentication log is unavailable: $auth_log"
        return
    fi

    local failed_total
    local source_ip
    local target_user
    local failed_count
    local successful_after
    local uid
    local privilege
    local exposure
    local likelihood
    local confidence

    # ---------------------------------------------------------
    # Total failed SSH authentication attempts
    # ---------------------------------------------------------

    failed_total=$(sudo awk '
        $5 ~ /^sshd/ &&
        /Failed password|Invalid user|authentication failure/ {
            count++
        }
        END {
            print count+0
        }
    ' "$auth_log" 2>/dev/null)

    if [[ "$failed_total" -eq 0 ]]; then
        pass "No failed SSH authentication attempts detected."
        echo "  Evidence: $auth_log"
        return
    fi

    echo "  Total failed SSH attempts: $failed_total"

    # ---------------------------------------------------------
    # Analyze source IPs
    # ---------------------------------------------------------

    while IFS= read -r source_ip; do

        [[ -z "$source_ip" ]] && continue

        failed_count=$(sudo awk -v ip="$source_ip" '
            $5 ~ /^sshd/ &&
            /Failed password|Invalid user|authentication failure/ &&
            $0 ~ ip {
                count++
            }
            END {
                print count+0
            }
        ' "$auth_log" 2>/dev/null)

        # -----------------------------------------------------
        # Determine target username
        # -----------------------------------------------------

        target_user=$(sudo awk -v ip="$source_ip" '
            $5 ~ /^sshd/ &&
            /Failed password for/ &&
            $0 ~ ip {
                for (i=1; i<=NF; i++) {
                    if ($i == "for" && $(i+1) != "invalid") {
                        print $(i+1)
                        exit
                    }
                }
            }
        ' "$auth_log" 2>/dev/null)

        [[ -z "$target_user" ]] && target_user="unknown"

        # -----------------------------------------------------
        # Determine target privilege
        # -----------------------------------------------------

        uid=$(getent passwd "$target_user" 2>/dev/null | cut -d: -f3)

        if [[ "$uid" == "0" ]]; then
            privilege=3
        elif [[ "$uid" =~ ^[0-9]+$ && "$uid" -lt 60000 ]]; then
            privilege=2
        else
            privilege=1
        fi

        # -----------------------------------------------------
        # Exposure
        # -----------------------------------------------------

        exposure=3

        # -----------------------------------------------------
        # Likelihood
        # -----------------------------------------------------

        if (( failed_count >= 20 )); then
            likelihood=3
        elif (( failed_count >= 5 )); then
            likelihood=2
        else
            likelihood=1
        fi

        confidence=3

        # -----------------------------------------------------
        # Successful login after failures
        # -----------------------------------------------------

        successful_after=$(sudo awk -v ip="$source_ip" '
            $5 ~ /^sshd/ &&
            /Accepted password|Accepted publickey/ &&
            $0 ~ ip {
                count++
            }
            END {
                print count+0
            }
        ' "$auth_log" 2>/dev/null)

        if (( successful_after > 0 )); then
            likelihood=3
            confidence=3
        fi

        add_finding \
            "AUTH" \
            "Failed SSH authentication activity" \
            "Failed SSH authentication attempts were detected from a source address and require review for brute-force activity, unauthorized access attempts, or expected administrative activity." \
            "SourceIP=$source_ip FailedAttempts=$failed_count TargetUser=$target_user SuccessfulLoginsAfter=$successful_after Privilege=$privilege Log=$auth_log"

    done < <(
        sudo awk '
            $5 ~ /^sshd/ &&
            /Failed password|Invalid user|authentication failure/ {
                for (i=1; i<=NF; i++) {
                    if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
                        print $i
                    }
                }
            }
        ' "$auth_log" 2>/dev/null |
        sort -u
    )

    # ---------------------------------------------------------
    # Summary
    # ---------------------------------------------------------

    if (( failed_total < 5 )); then
        info "Low-volume failed SSH authentication activity detected: $failed_total"
    elif (( failed_total < 20 )); then
        warn "Repeated failed SSH authentication activity detected: $failed_total"
    else
        warn "High-volume failed SSH authentication activity detected: $failed_total"
    fi
}
