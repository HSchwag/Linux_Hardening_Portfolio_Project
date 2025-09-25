#!/usr/bin/env bash
# This will go through the users and groups on the system and give a report about which users have what privileges
# by looking at the groups they are apart of and also check to see if their account is locked or not.

set -Eeuo pipefail

# Just the text file that will be populated with the report.
REPORT="/home/sysadmin/Linux_Python_and_Bash_Automation/Reports/report_$(date +%B-%d).txt"

# Header
echo "" | tee -a "$REPORT"
echo "======= User and Group Audit Report =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# This is just looking through /etc/passwd to find any users that the  UID is above 1000 (human user not a system user.)
# and then also makes sure that the user isn't named nobody. Once it has done this it prints out the name of the user.
# Afterwards I pipe that output into a while function that looks at the user and gets the groups they are currently in.
# Then it runs passwd -S to show whether that persons account is locked, has a password, or has no password.

awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd \
| while read -r user; do
	echo -n "$user: " | tee -a "$REPORT"
	id -nG "$user" | tee -a "$REPORT"
	sudo passwd -S "$user" | tee -a "$REPORT"
	echo "" | tee -a "$REPORT"
done

