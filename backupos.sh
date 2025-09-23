#!/usr/bin/env bash
# This will create a local backup of the OS in case there is any reason at
# all that something went wrong and it is necessary to do a full reset to
# basline

set -Eeuo pipefail

# Quick reference/creates the directory if not already made
BACKUP_DIR="/home/sysadmin/Backups/"
BACKUP="/home/sysadmin/Backups/full_system_backup_$(date +%A).tar.gz"

if [ -d "$BACKUP_DIR" ]; then
	echo "[*]Backup directory present."
else
	mkdir "$BACKUP_DIR"
	echo "[+]Backup directory not present in sysadmin home... directory created."
fi

# This is a full system backup of everything excluding the backup directory
# and /proc, /tmp, /mnt, /sys, /dev, /run, /var/tmp, /home/*/.cache, /var/cache, /var/lib/docker, /swapfile, /media,
# and /lost+found. It then creates a file alongside the current date into the Backups directory.
echo "[*]Backup in progress... Please enter authorized users password and allow time for backup to complete."
sudo tar -cvpzf "$BACKUP" --exclude=/home/sysadmin/Backups/* --exclude=/proc --exclude=/tmp --exclude=/mnt --exclude=/sys --exclude=/dev --exclude=/run --exclude=/home/*/.cache --exclude=/var/tmp --exclude=media --exclude=/lost+found --exclude=/var/cache --exclude=/var/lib/docker --exclude=/swapfile / > /dev/null 2>&1

# Will look through the Backups directory and remove any exisiting daily files not done on the day of the week it is
# currently. Since it should be daily with a seperate weekly that is only removed weekly
for backup in "$BACKUP_DIR"*.tar.gz; do
	if [ ! -f "$BACKUP" ]; then
		rm -f -- "$backup"
		echo "[-]Old backup $(backup) removed!"
	else
		echo "[*]Backup created successfully!"
	fi
done
