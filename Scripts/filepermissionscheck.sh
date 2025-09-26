#!/usr/bin/env bash
# This is going through and checking and updating file permissions. That way I can know that every home directory is following the safe 755 or 644 modifications respective of if they're files or directories.
# This has the addded benefit of showing me all the scripts in the system since it automatically makes sure that files are 644 and so when they're executable for everyone it will flag it.

# I use set -Eeuo pipefail to make sure that the script runs smoothly and safely in case of failures. That way it exits on failure,
# catches any unset variables I missed, and catches errors in any pipelines.
set -Eeuo pipefail

# This sets the report variable and is uniform across all scripts. I also realized that lastcrawl was giving me lots of pain so I just excluded the entire cache directory for the
# purpose of demonstrating automation.
REPORT="/home/sysadmin/Linux_Python_and_Bash_Automation/Reports/report_$(date +%B-%d).txt"
CACHE="*/.cache"

# Header
echo "" | tee -a "$REPORT"
echo "======= File Permissions =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# The actual bash to find /home and find either directories or files and then updates their permissions. It also specifies any .cache directory in /home/ and skips it.
sudo find /home -path "$CACHE" -prune -o -type d -exec chmod 755 {} +
sudo find /home -path "$CACHE" -prune -o -type f -exec chmod 644 {} +
sudo find /home -path "$CACHE" -prune -o -type f -iname "*.sh" -exec chmod 755 {} +

# This is what then looks through and finds any directories or files that are not the specified permissions.
sudo find /home -path "$CACHE" -prune -o -type f ! -perm 644 -printf 'CHECK PERMISSIONS %m %u:%g %p\n' | tee -a "$REPORT"
sudo find /home -path "$CACHE" -prune -o -type d ! -perm 755 -printf 'CHECK PERMISSIONS %m %u:%g %p\n' | tee -a "$REPORT"

# Lastly just for ease it then goes through and updates the python program to executable.
sudo chmod 755 /home/sysadmin/Linux_Python_and_Bash_Automation/automationpilot.py
