#!/usr/bin/env bash

KNOWN_SERVICES=(
    "accounts-daemon.service"
    "apache2.service"
    "console-setup.service"
    "cron.service"
    "getty@.service"
    "haveged.service"
    "keyboard-setup.service"
    "lightdm.service"
    "ModemManager.service"
    "networking.service"
    "NetworkManager.service"
    "nftables.service"
    "open-vm-tools.service"
    "regenerate-ssh-host-keys.service"
    "rsyslog.service"
    "smartmontools.service"
    "systemd-pstore.service"
    "systemd-resolved.service"
    "systemd-timesyncd.service"
    "tor.service"
    "ufw.service"
    "grub-install-devices.service"
    "NetworkManager-dispatcher.service"
    "NetworkManager-wait-online.service"
)

is_known_service() {
    local service="$1"
    local known

    for known in "${KNOWN_SERVICES[@]}"; do
        [[ "$service" == "$known" ]] && return 0

        if [[ "$known" == *@.service ]]; then
            local prefix="${known%@.service}"
            [[ "$service" == "$prefix"@*.service ]] && return 0
        fi
    done

    return 1
}

check_systemd() {

    if ! command -v systemctl >/dev/null 2>&1; then
        error "Required command not available: systemctl"
        return
    fi

    local service
    local enabled_state
    local active_state
    local fragment
    local exec_start
    local user
    local group
    local executable
    local owner
    local permissions
    local world_writable=false
    local group_writable=false

    while IFS= read -r service; do

        [[ -z "$service" ]] && continue

        enabled_state=$(systemctl is-enabled "$service" 2>/dev/null || echo "unknown")
        active_state=$(systemctl is-active "$service" 2>/dev/null || echo "unknown")

        fragment=$(systemctl show "$service" \
            -p FragmentPath --value 2>/dev/null || true)

        exec_start=$(systemctl show "$service" \
            -p ExecStart --value 2>/dev/null || true)

        user=$(systemctl show "$service" \
            -p User --value 2>/dev/null || true)

        group=$(systemctl show "$service" \
            -p Group --value 2>/dev/null || true)

        [[ -z "$user" ]] && user="root/default"
        [[ -z "$group" ]] && group="root/default"

        executable=""

        if [[ "$exec_start" =~ path=([^[:space:]]+) ]]; then
            executable="${BASH_REMATCH[1]}"
        elif [[ "$exec_start" =~ ^([^[:space:]]+) ]]; then
            executable="${BASH_REMATCH[1]}"
        fi

        owner="unknown"
        permissions="unknown"

        if [[ -n "$executable" && -e "$executable" ]]; then
            owner=$(stat -c '%U' "$executable" 2>/dev/null || echo "unknown")
            permissions=$(stat -c '%A' "$executable" 2>/dev/null || echo "unknown")

            if [[ "$permissions" =~ ^.[rwx-]{2}[rw][x-]{3}[rw][x-]{3}$ ]]; then
                group_writable=true
            fi

            if [[ "$permissions" =~ ^.[rwx-]{5}[rw][x-]{3}$ ]]; then
                world_writable=true
            fi
        fi

        [[ "$enabled_state" == "enabled" ]] || continue

        # -----------------------------------------------------
        # Known / expected service
        # -----------------------------------------------------

        if is_known_service "$service"; then
            continue
        fi

        # -----------------------------------------------------
        # Unknown enabled service
        # -----------------------------------------------------

        PRIVILEGE=2
        EXPOSURE=1
        LIKELIHOOD=2
        CONFIDENCE=2

        if [[ "$user" == "root" || "$user" == "root/default" ]]; then
            PRIVILEGE=3
        fi

        if [[ "$group_writable" == true ||
              "$world_writable" == true ]]; then
            LIKELIHOOD=3
            CONFIDENCE=3
        fi

        add_finding \
            "SYSTEMD" \
            "Unrecognized enabled systemd service" \
            "An enabled systemd service is not present in the local service baseline and requires investigation." \
            "Service=$service Enabled=$enabled_state Active=$active_state User=$user Group=$group ExecStart=${exec_start:-unknown} Executable=${executable:-unknown} Owner=$owner Permissions=$permissions FragmentPath=${fragment:-unknown}"

    done < <(
        systemctl list-unit-files \
            --type=service \
            --state=enabled \
            --no-legend \
            --no-pager 2>/dev/null |
        awk '{print $1}'
    )
}
