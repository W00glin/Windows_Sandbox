# Windows_Sandbox
Repo to house my Windows Sandbox VM config files. I use this for when I need to quickly install something, see what it might do, and understand its impact. I will continually update this config with more relevant tools as I see fit.

## Using the Preconfigured Sandbox

1. Create a new Windows Sandbox instance on your machine.
2. When the sandbox environment is ready, the `install.bat` script will automatically run, downloading and installing the following programs:
   - Google Chrome (latest version)
   - Mozilla Firefox (latest version)
   - Wireshark (4.4.1)
   - Nmap (7.94)
   - OBS
   - Visual Studio Code (latest stable)
   - 7-Zip (latest version)
   - Full Windows Sysinterals Suite
3. You may need to move the `install.bat` file to your Downloads folder for your specific user in order for the sandbox to properly install all of the programs.

## Sysinternals Suite
The full Sysinternals suite is installed in `C:\SysinternalTools`. Shortcuts for common tools like Process Explorer, Autoruns, and TCPView are placed on the desktop.

## Additional Details
- All installations are done silently/unattended.
- A "Sysinternals Tools" folder shortcut is placed on the desktop.
- Some programs may require restarting the sandbox to appear in the Start Menu.
- This also maps your Downloads folder for your specific user to the Downloads folder in the VM.
