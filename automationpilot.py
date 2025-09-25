import subprocess
from pathlib import Path

# ------- File Path -------

BASE_DIR = Path(__file__).parent
SCRIPTS_DIR = BASE_DIR / "Scripts"

# ------- Run Script Function -------

def run_script(script_to_run):
    script_path = SCRIPTS_DIR / script_to_run
    subprocess.run("bash", str(script_path))

# ------- Class -------

class LinuxAutomationManager:
    def __init__(self):
        pass

    def run_all_scripts(self):

        count = 0

        script_order = [
            "backupos.sh",
            "preharden.sh",
            "auditusers.sh",
            "sudoprivilegedusers.sh",
            "passwordpolicy.sh",
            "filepermissionscheck.sh"
        ]

        for script in script_order:

            script_path = SCRIPTS_DIR / script

            count += 1

            result = subprocess.run(["bash", str(script_path)])

            if result.returncode == 0:
                print(f"\n[Linux Automation Manager] {script} completed successfully!")
            elif script == "filepermissionscheck.sh":
                print(f"\n[Linux Automation Manager] {script} completed successfully!")
            else:
                print(f"\n[Linux Automation Manager] {script} failed with exit code {result.returncode}")


        print(f"\n[Linux Automation Manager] Total scripts run: {count}")

# ------- Execution -------

def __main__():
    automation_bot = LinuxAutomationManager()
    automation_bot.run_all_scripts()

__main__()