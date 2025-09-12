#!/usr/bin/env bash
# This script is meant to be run before the hardening process and collect
# system information. This will be the first to appear in the master list
# once all scripts run.

# This is a safety net for the script. It keeps the script from ignoring
# errors, exits the script if any command fails, treats undefined variables
# errors and exits, and will return a failure if any command in a pipe fails.
set -Eeuo pipefail

# Defining a variable for the output file then making sure if it exists that
# it is a blank document.
PRE_HARDEN_REPORT="pre_harden_report.txt"
echo "" > "$PRE_HARDEN_REPORT"
LINE_BREAK=""

# This is just to mark the time and date of when the information was gathered
echo "======= System Summary Report =======" >> "$PRE_HARDEN_REPORT"
echo "Report Date: $(date)" >> "$PRE_HARDEN_REPORT"
echo "$LINE_BREAK" >> "$PRE_HARDEN_REPORT"

# Command to return the hostname.
echo "------- Hostname -------" >> "$PRE_HARDEN_REPORT"
hostname >> "$PRE_HARDEN_REPORT"
echo "$LINE_BREAK" >> "$PRE_HARDEN_REPORT"

# OS Version, this will check if the command lsb_release is available
# on the PATH. If it isn't it will instead cat /etc/os-release for the
# same information in a different format.
echo "------- OS Version -------" >> "$PRE_HARDEN_REPORT"
if command -v lsb_release &> /dev/null; then
	lsb_release -a >> "$PRE_HARDEN_REPORT" 2>/dev/null
else
	cat /etc/os-release >> "$PRE_HARDEN_REPORT"
fi
echo "$LINE_BREAK" >> "$PRE_HARDEN_REPORT"

# Memory Information
echo "------- Memory Information -------" >> "$PRE_HARDEN_REPORT"
free -h >> "$PRE_HARDEN_REPORT"
echo "$LINE_BREAK" >> "$PRE_HARDEN_REPORT"

# Uptime
echo "------- Uptime -------" >> "$PRE_HARDEN_REPORT"
uptime -p >> "$PRE_HARDEN_REPORT"
echo "$LINE_BREAK" >> "$PRE_HARDEN_REPORT"
