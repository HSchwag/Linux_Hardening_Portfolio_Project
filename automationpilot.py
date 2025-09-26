# I import subprocess to be able to run my bash scripts and Path is important so that even if I am not in the same
# directory as my python program it will always know the path to the scripts in the sub directory.
import subprocess
from pathlib import Path

# ------- File Path -------

# Takes this program and where it is located and passes it to SCRIPT_DIR to specify the correct directory.
BASE_DIR = Path(__file__).parent
SCRIPTS_DIR = BASE_DIR / "Scripts"

# ------- Run Script Function -------

# This is called by run_all in the class function so that I can quickly add more small functions without cluttering
# the class.
def run_script(script_to_run):
    script_path = SCRIPTS_DIR / script_to_run
    subprocess.run("bash", str(script_path))

# ------- Class -------

# I like to use OOP both to demonstrate I know how to do it but also it makes it a lot easier to specify different
# functions later. I could add a seperate reporting function to double check, add different commands I may want to run
# independent of the scripts, or run the scripts with specific conditions later.
class LinuxAutomationManager:
    def __init__(self):
        pass

    def run_all_scripts(self):

# This is just for my sake so I can make sure all the scripts run and if I want to add more later or maybe exclude one later
# on it's easier to quickly verify without scrolling through a giant output. 
        count = 0

# This is to give me the freedom to run scripts as I please and in which order.
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

# This is so that in the console I have an extra set of outputs I know is coming from this python program directly.
# Makes it way easier to debug and tell what went wrong.
            if result.returncode == 0:
                print(f"\n[Linux Automation Manager] {script} completed successfully!")
            else:
                print(f"\n[Linux Automation Manager] {script} failed with exit code {result.returncode}")


        print(f"\n[Linux Automation Manager] Total scripts run: {count}")

# ------- Execution -------

# I then set apart the main function so that I can easily tell what I have running and in what order then I run it.
def __main__():
    automation_bot = LinuxAutomationManager()
    automation_bot.run_all_scripts()

__main__()