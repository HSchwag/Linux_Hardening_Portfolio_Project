#!/usr/bin/env bash
# This script will be used to check the permissions in the sudo file to make sure I can see what users have what privileges.

# I use set -Eeuo pipefail to make sure that the script runs smoothly and safely in case of errors. That way it exits on failure,
# catches any unset variables I missed, and catches errors in any pipelines.
set -Eeuo pipefail

# This sets the report variable and is uniform across all scripts.
REPORT="/home/sysadmin/Linux_Python_and_Bash_Automation/Reports/report_$(date +%B-%d).txt"

# Header
echo "" | tee -a "$REPORT"
echo "======= Sudo Privileges =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# This will search through the sudoers file and check for who has sudo privileges. That way I can quickly see who has access to elevated privileges.
sudo grep -RHE '^[^#].*ALL=\(ALL(:ALL)?\)\s+ALL' /etc/sudoers /etc/sudoers.d

# It then will go through the users on the system and pass that to sudo -n -l -U for a better idea of what permissions exact users have.
users=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

for user in $users; do
	sudo -n -l -U "$user" 2>&1 | grep -e '^User' -e '(ALL*' | tee -a "$REPORT"
done
