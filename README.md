# Linux Automation Project (MVP)

This project shows I can automate real system tasks. It started from my Linux hardening work in bootcamp and I turned it into a working script suite that creates backups, generates a system report, audits users/sudo, and normalizes permissions. This is a **minimum viable product** to demonstrate end-to-end automation.

---

## What it does

- **Backup & rotate**  
  Creates a day-named tarball (e.g., `full_system_backup_Thursday.tar.gz`) and removes older day files.
- **System report**  
  Captures hostname, OS version, memory, uptime, sudo privileges, password policy status, and permission findings.
- **User & sudo audits**  
  Lists human users, groups, lock/password status, and per-user sudo rules (filtered to the useful lines).
- **Permission normalization**  
  Sets **dirs → 755**, **files → 644**, and flags anything that doesn’t match (skips noisy `~/.cache`).

---

## Repo layout

Linux_Python_and_Bash_Automation/
├── automationpilot.py # Orchestrator: runs Scripts/ in order and prints status
├── Reports/ # Generated reports (e.g., report_September-26.txt)
└── Scripts/
  ├── backupos.sh — Creates a daily system backup tarball (rotates old backups, skips temp/cache dirs).
  ├── preharden.sh — Collects basic system info (hostname, OS version, memory, uptime) for the report.
  ├── auditusers.sh — Audits human users: lists groups, password/lock status, and adds to the report.
  ├── sudoprivilegedusers.sh — Checks sudoers and lists which users have elevated privileges.
  ├── passwordpolicy.sh — Copies and safely edits PAM common-password to enforce stronger password policy.
  └── filepermissionscheck.sh — Normalizes file/dir permissions (dirs 755, files 644), flags deviations.
