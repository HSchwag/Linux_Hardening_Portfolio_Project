#!/usr/bin/env bash
# This script will be used to check the permissions in the sudo file to make sure I can see what users have what
# privileges.

set -Eeuo pipefail

REPORT="/home/sysadmin/Linux_Python_and_Bash_Automation/Reports/report_$(date +%B-%d).txt"

echo "" | tee -a "$REPORT"
echo "======= Sudo Privileges =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# Comfortable using SUDO here since it's just grep. RHE (recursive, show file name, lets me search for ().)
# ^ line starts with, [^#] basically NOT # aka comment, .* searches document for anything matching the ALL=\...
sudo grep -RHE '^[^#].*ALL=\(ALL(:ALL)?\)\s+ALL' /etc/sudoers /etc/sudoers.d

users=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

for user in $users; do
	sudo -n -l -U "$user" 2>&1 | grep -e '^User' -e '(ALL*' | tee -a "$REPORT"
done
