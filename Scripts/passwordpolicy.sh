#!/usr/bin/env bash
# This script will automatically copy /etc/pam.d/common-password to /tmp/ and create a directory to copy it to.
# Then the script will go through, edit one of the copies of /etc/pam.d/common-password and the status of the altered copy is included in the report.
# This way the user can verify that the password policies were safely and correctly changed and then manually change the original.
# This way there is no chance that the original is ruined or breaks the machine while still saving time and energy.

# This sets the report variable and is uniform across all scripts. This also specifies the temporary directory for the common-password copies.
# It also specifies the two copies to be made; the copy that will be altered by the script and an extra unaltered copy named to make sure there is no confusion and in case of any errors after manual changes.
REPORT="/home/sysadmin/Linux_Python_and_Bash_Automation/Reports/report_$(date +%B-%d).txt"
PAM_COPY_DIR="/tmp/pam_copy"
PAM_COPY_ALTERED="/tmp/pam_copy/pam_altered_file.txt"
PAM_COPY_ORIGINAL="/tmp/pam_copy/pam_original_file_DO_NOT_ALTER.txt"

# I use set -Eeuo pipefail to make sure that the script runs smoothly and safely in case of failures. That way it exits on failure,
# catches any unset variables I missed, and catches errors in any pipelines.
set -Eeuo pipefail

# Header
echo "" | tee -a "$REPORT"
echo "======= Password Policy Status =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# Checks to see if the temporary directory has already been made that way if it has reset the directory and copies are always fresh.  If the directory exists it moves on to make the copies of common-password and if it doesn't exist it
# creates the directory automatically.
if [ -d "$PAM_COPY_DIR" ]; then
	echo "$PAM_COPY_DIR already exists." | tee -a "$REPORT"
else
	mkdir "$PAM_COPY_DIR"
	echo "$PAM_COPY_DIR not found. Directory created." | tee -a "$REPORT"
fi

# This makes the two copies and names them accordingly.
cp /etc/pam.d/common-password "$PAM_COPY_ALTERED" && cp /etc/pam.d/common-password "$PAM_COPY_ORIGINAL"

# The script will then go through the temporary directory and check every file present to then make sure it is the two copies. It then will print to the report both copies so that I can manually verify the two copies are present.
for file in "$PAM_COPY_DIR"; do
	if [ "$file" == "$PAM_COPY_DIR" ] || [ "$file" == "$PAM_COPY_ORIGINAL" ]; then
		echo "Successfully copied $file" | tee -a "$REPORT"
	fi
done

# This will then check for the copy to be altered and will first attempt to use sed to change the line in place with the updated password policy that I want. Otherwise it will instead place the new policy at the bottom so I can manually alter the file myself after verifying the changes were made correctly.
if grep -q "pam_pwquality.so" "$PAM_COPY_ALTERED"; then
	sed -i "s/^password.*pam_pwquality\.so.*/password requisite pam_pwquality.so retry=3 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/" "$PAM_COPY_ALTERED"
	echo "Copied file successfully changed in place using sed. Verify changes before altering original file." | tee -a "$REPORT"
else
	echo "password requisite pam_pwquality.so retry=3 minlen=8 ucredit=-1 lcredit=-1 dcredit =-1 ocredit=-1" | tee -a "$PAM_COPY_ALTERED" > /dev/null
	echo "An error occured while trying to use sed. Requires manual change. Changes appended to bottom." | tee -a "$REPORT"
fi
