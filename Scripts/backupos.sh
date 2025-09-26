#!/usr/bin/env bash
# This will create a local backup of the OS. That way if there is any reason at all that something went wrong I can restart from
# a known clean baseline. This will be the first script run by automationpilot.py to ensure a clean backup to restart from just in case.

# I use set -Eeuo pipefail to make sure that the script runs smoothly and safely in case of errors. That way it exits on failure,
# catches any unset variables I missed, and catches errors in any pipelines.
set -Eeuo pipefail

# This sets the report variable and is uniform across all scripts. The two variables are just to make sure that the Backups directory
# is already made and that the backup is made with the current day of the week included in the title.
REPORT="/home/sysadmin/Linux_Python_and_Bash_Automation/Reports/report_$(date +%B-%d).txt"
BACKUP_DIR="/home/sysadmin/Backups/"
DAILY_BACKUP="/home/sysadmin/Backups/full_system_backup_$(date +%A).tar.gz"

# This makes sure that if there already is a report in the Reports/ directory with the same day and month that it gets wiped clean for this report.
echo "" > "$REPORT"

# I use echo with nothing to create blank space between the lines just for ease of reading. I use tee -a to both print the blank space
# to the console and add it to the report. I don't need to do that in the above echo since tee -a just appends the piped output
# to the bottom of the file.
echo "" | tee -a "$REPORT"
echo "======= Backup Status =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# This checks to see if the directory exists or not. If it doesn't exist then it makes the directory to prepare for the backup.
if [ -d "$BACKUP_DIR" ]; then
	echo "[*]Backup directory present." | tee -a "$REPORT"
else
	mkdir "$BACKUP_DIR"
	echo "[+]Backup directory not present in sysadmin home... directory created." | tee -a "$REPORT"
fi

# This is a full system backup of everything excluding the backup directory
# and /proc, /tmp, /mnt, /sys, /dev, /run, /var/tmp, /home/*/.cache, /var/cache, /var/lib/docker, /swapfile, /media,
# and /lost+found. It then creates a file alongside the current date into the Backups directory.
echo "[*]Backup in progress... Please enter authorized users password and allow time for backup to complete."
sudo tar -cvpzf "$DAILY_BACKUP" --exclude=/home/sysadmin/Backups/* --exclude=/proc --exclude=/tmp --exclude=/mnt --exclude=/sys --exclude=/dev --exclude=/run --exclude=/home/*/.cache --exclude=/var/tmp --exclude=media --exclude=/lost+found --exclude=/var/cache --exclude=/var/lib/docker --exclude=/swapfile / > /dev/null 2>&1

# Will look through the Backups directory and remove any exisiting daily files not done on the day of the week it is
# currently. That way any old backups are automatically removed and not confused with the most up to date one.
for backup in "$BACKUP_DIR"*.tar.gz; do
	if [ "$backup" != "$DAILY_BACKUP" ]; then
		echo "[-]Old backup $backup removed!" | tee -a "$REPORT"
		rm -f -- "$backup"
	else
		echo "[+]Backup created successfully!" | tee -a "$REPORT"
	fi
done
