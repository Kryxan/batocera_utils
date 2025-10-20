#!/bin/bash

LID_STATE_FILE="/proc/acpi/button/lid/LID0/state"
SLEEP_DURATION=1200        # seconds before shutdown (60 min)

detect_sleep_mode() {
    local supported_modes
    supported_modes=$(cat /sys/power/state)

    if echo "${supported_modes}" | grep -qw "mem"; then
        echo "mem"
    elif echo "${supported_modes}" | grep -qw "standby"; then
        echo "standby"
    elif echo "${supported_modes}" | grep -qw "freeze"; then
        echo "freeze"
    else
        echo "none"
    fi
}

handle_sleep_and_shutdown() {
    echo "Preparing for sleep..."

    # Shutdown controllers (example: uhubctl)
    if command -v uhubctl >/dev/null 2>&1; then
        uhubctl -a off
        echo "Controllers powered off"
    fi

    sleep_mode=$(detect_sleep_mode)
    echo "Detected sleep mode: ${sleep_mode}"

    if [ "${sleep_mode}" != "none" ] && command -v rtcwake >/dev/null 2>&1; then
        rtcwake -m "${sleep_mode}" -s "${SLEEP_DURATION}"
        echo "System resumed from rtcwake sleep"
    else
        echo "Sleep not supported, shutting down"
        poweroff
    fi

    # Re-check lid state or idle time before shutdown
    if grep -q 'closed' "${LID_STATE_FILE}"; then
        echo "Lid still closed, proceeding to shutdown"
        poweroff
    else
        echo "User activity detected, aborting shutdown"
    fi
}
handle_sleep_and_shutdown
