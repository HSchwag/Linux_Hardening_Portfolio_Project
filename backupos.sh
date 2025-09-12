#!/usr/bin/env bash
# This will create a local backup of the OS in case there is any reason at
# all that something went wrong and it is necessary to do a full reset to
# basline

set -Eeuo pipefail

# Quick reference/creates the directory if not already made
BACKUP_DIR="/home/sysadmin/Backups"

# Will look through the Backups directory and remove any exisiting daily files
# since it should be daily with a seperate weekly that is only removed weekly
for backup in "$BACKUP_DIR"/full_system_backup_*.tar.gz; do
	rm -f -- "$backup"
done 

# This is a full system backup of everything excluding the backup directory
# and /proc, /tmp, /mnt, /sys, /dev, /run, /var/tmp, /home/*/.cache, /var/cache, /var/lib/docker, /swapfile, /media,
# and /lost+found. It then creates a file alongside the current date into the Backups directory.
sudo tar -cvpzf /home/sysadmin/Backups/full_system_backup_2025-09-12.tar.gz --exclude=/home/sysadmin/Backups/* --exclude=/proc --exclude=/tmp --exclude=/mnt --exclude=/sys --exclude=/dev --exclude=/run --exclude=/home/*/.cache --exclude=/var/tmp --exclude=media --exclude=/lost+found --exclude=/var/cache --exclude=/var/lib/docker --exclude=/swapfile /
