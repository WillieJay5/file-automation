# File Automation

This is an organization of my file automation scripts. With these being used in a windows environment, the languages used are powershell and python. 

## Auto-Organize-Downloads
This pair of scripts is meant for two separate functions. 
1. auto-organize-downloads.py is meant to organize your downloads folder into different folders depending on the file type.
2. watch_downloads.ps1 is meant to set up a watcher using PowerShell in order to check when something is downloaded to the Downloads Folder. When any changes are made to the downloads folder, it runs the auto-organize-downloads.py script.

   This script is meant to be run at boot using a group policy or scheduled task, which this script would then silently run in the background. 

   Added redundancy to check if an instance is already running, kill it, then start the new instance.
