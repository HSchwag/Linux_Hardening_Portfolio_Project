#!/usr/bin/env bash
# This will go through the users and groups on the system and give a report about which users have what privileges
# by looking at the groups they are apart of and also check to see if their account is locked or not.

set -Eeuo pipefail

# Just the text file that will be populated with the report.
USER_AUDIT_REPORT="user_audit_report.txt"
echo "" > "$USER_AUDIT_REPORT"
LINE_BREAK=""

# Header
echo "======= User and Group Audit Report =======" > "$USER_AUDIT_REPORT"
echo "$LINE_BREAK" >> "$USER_AUDIT_REPORT"

# This is just looking through /etc/passwd to find any users that the UID is above 1000 (human user not a system user.)
# and then also makes sure that the user isn't named nobody. Once it has done this it prints out the name of the user.
# Afterwards I pipe that output into a while function that looks at the user and gets the groups they are currently in.
# Then it runs passwd -S to show whether that persons account is locked, has a password, or has no password.

awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd \
| while read -r user; do
	echo -n "$user: " >> "$USER_AUDIT_REPORT"
	id -nG "$user" >> "$USER_AUDIT_REPORT"
	sudo passwd -S "$user" >> "$USER_AUDIT_REPORT"
	echo "$LINE_BREAK" >> "$USER_AUDIT_REPORT"
done

