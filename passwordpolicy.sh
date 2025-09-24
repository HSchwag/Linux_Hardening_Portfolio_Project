#!/usr/bin/env bash
# This script will automatically copy /etc/pam.d/common-password to /tmp/ and create a directory to copy it to.
# Then the script will go through, edit the copy of /etc/pam.d/common-password and then it will be sent in the report.
# This way the user can verify that the password policies were safely and correctly changed and then manually change it.
# This way there is no chance that the original is ruined or breaks the machine while still saving time and energy.

REPORT="report_$(date +%B-%d).txt"
PAM_COPY_DIR="/tmp/pam_copy"
PAM_COPY_ALTERED="/tmp/pam_copy/pam_altered_file.txt"
PAM_COPY_ORIGINAL="/tmp/pam_copy/pam_original_file_DO_NOT_ALTER.txt"

set -Eeuo pipefail

echo "" | tee -a "$REPORT"
echo "======= Password Policy Status =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# Checks to see if this is a brand new system or a system I may have been working on a little bit but still needs
# hardening. If the directory exists it moves on to make the copies of common-password and if it doesn't exist it
# creates the directory automatically.
if [ -d "$PAM_COPY_DIR" ]; then
	echo "$PAM_COPY_DIR already exists." | tee -a "$REPORT"
else
	mkdir "$PAM_COPY_DIR"
	echo "$PAM_COPY_DIR not found. Directory created." | tee -a "$REPORT"
fi

# This copy is what will be sent in the report to be verified, that way if when you're looking at the state of the
# machine you can then just login and then update the common-password file. Altering this file directly could be
# catastrophic and so it's important even when manually returning later to make a copy of the original BEFORE
# implementing any changes to the original file, that is why I create a second unaltered copy just in case the user
# makes changes to the original without first creating their own copy.
cp /etc/pam.d/common-password "$PAM_COPY_ALTERED" && cp /etc/pam.d/common-password "$PAM_COPY_ORIGINAL"


for file in "$PAM_COPY_DIR"; do
	if [ "$file" == "$PAM_COPY_DIR" ] || [ "$file" == "$PAM_COPY_ORIGINAL" ]; then
		echo "Successfully copied $file"
	fi
done

if grep -q "pam_pwquality.so" "$PAM_COPY_ALTERED"; then
	sed -i "s/^password.*pam_pwquality\.so.*/password requisite pam_pwquality.so retry=3 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/" "$PAM_COPY_ALTERED"
	echo "Copied file successfully changed in place using sed. Verify changes before altering original file." | tee -a "$REPORT"
else
	echo "password requisite pam_pwquality.so retry=3 minlen=8 ucredit=-1 lcredit=-1 dcredit =-1 ocredit=-1" | tee -a "$PAM_COPY_ALTERED" > /dev/null
	echo "An error occured while trying to use sed. Requires manual change. Changes appended to bottom." | tee -a "$REPORT"
fi
