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
  ├── backupos.sh
  ├── preharden.sh
  ├── auditusers.sh
  ├── sudoprivilegedusers.sh
  ├── passwordpolicy.sh
  └── filepermissionscheck.sh
