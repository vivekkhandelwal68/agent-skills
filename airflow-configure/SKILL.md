---
name: airflow-configure
description: configure Airflow project by automatically installing required os level packages and python packages and then running `astro dev start` command to start the Airflow project.it recives path to packages.txt and requirements.txt.
compatibility: opencode
---

## Instructions
1. DO NOT draft plans or generate code.
2. DO NOT scan the project for file and directories.
3. SKIP this step if path to packages.txt is not provided. trigger the packages setup script using the bash tool by passing the first argument as packagetype=os and  file path as second arguments to ensure consistent environment handling:
   bash ~/.config/opencode/skills/airflow-configure/scripts/packages_setup.sh os /path/to/packages.txt
4. SKIP this step if path to requirements.txt is not provided. trigger the packages setup script using the bash tool by passing the first argument as packagetype=python and  file path as second arguments to ensure consistent environment handling:
   bash ~/.config/opencode/skills/airflow-configure/scripts/packages_setup.sh python /path/to/requirements.txt
5. After installing the required packages, trigger the command to start the Airflow project using the bash tool:
   bash ~/.config/opencode/skills/airflow-configure/scripts/setup.sh
6. Display the exact output of the script to the user.
7. If the script encounters an error, capture and display the error message to the user without attempting to fix it.  