#!/usr/bin/env bash
# This is going through and checking and updating file permissions and checking for password text files that are more
# obvious.

set -Eeuo pipefail

REPORT="report_$(date +%B-%d).txt"

echo "" | tee -a "$REPORT"
echo "======= File Permissions =======" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

sudo find /home -type d -exec chmod 755 {} +
sudo find /home -type f -exec chmod 644 {} +
sudo find /home -type f -iname "*.sh" -exec chmod 755 {} +

sudo find /home -xdev -type f ! -perm 644 -printf 'CHECK PERMISSIONS %m %u:%g %p\n' | tee -a "$REPORT"
sudo find /home -xdev -type d ! -perm 755 -printf 'CHECK PERMISSIONS %m %u:%g %p\n' | tee -a "$REPORT"

sudo find -type f "/home/syadmin/Scripts/$REPORT" -exec chmod 644 2>/dev/null
