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
REPORT="report_$(date +%B-%d).txt"
echo "" > "$REPORT"

# This is just to mark the time and date of when the information was gathered
echo "======= System Summary Report =======" | tee -a "$REPORT"
echo "Report Date: $(date)" >> "$REPORT"
echo "" | tee -a "$REPORT"

# Command to return the hostname.
echo "------- Hostname -------" | tee -a "$REPORT"
echo "$(hostname)" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# OS Version, this will check if the command lsb_release is available
# on the PATH. If it isn't it will instead cat /etc/os-release for the
# same information in a different format.
echo "------- OS Version -------" | tee -a "$REPORT"
if command -v lsb_release &> /dev/null; then
	echo "`lsb_release -a`" | tee -a "$REPORT" 2>/dev/null
else
	echo "`cat /etc/os-release`" | tee -a "$REPORT"
fi
echo "" | tee -a "$REPORT"

# Memory Information
echo "------- Memory Information -------" | tee -a "$REPORT"
echo "`free -h`" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# Uptime
echo "------- Uptime -------" | tee -a "$REPORT"
echo "`uptime -p`" | tee -a "$REPORT"
