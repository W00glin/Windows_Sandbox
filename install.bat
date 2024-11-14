@echo off
echo Waiting for network connection...
:waitForNetwork
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    timeout /t 2 >nul
    goto waitForNetwork
)
echo Network connection established

REM Create directory for temporary downloads
mkdir C:\Sandbox_Downloads
cd C:\Sandbox_Downloads

REM === Web Browsers Installation ===
echo Downloading and installing Chrome...
REM Download and silently install Chrome
curl -L -o chrome_installer.exe https://dl.google.com/chrome/install/latest/chrome_installer.exe
if exist chrome_installer.exe (
    start /wait chrome_installer.exe /silent /install
)

REM Download and silently install Firefox
echo Downloading and installing Firefox...
curl -L -o firefox_installer.exe "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
if exist firefox_installer.exe (
    start /wait firefox_installer.exe /silent
)

REM === Security Tools Installation ===
REM Download and install Wireshark with desktop shortcuts
echo Downloading and installing Wireshark...
curl -L -o wireshark_installer.exe "https://2.na.dl.wireshark.org/win64/Wireshark-4.4.1-x64.exe"
if exist wireshark_installer.exe (
    echo Starting Wireshark installation...
    start /wait wireshark_installer.exe /S /quicklaunch /desktopicon
)

REM Download and silently install Nmap
echo Downloading and installing Nmap...
curl -L -o nmap_installer.exe "https://nmap.org/dist/nmap-7.94-setup.exe"
if exist nmap_installer.exe (
    start /wait nmap_installer.exe /S
)

REM Download and install WireGuard
echo Downloading and installing WireGuard...
curl -L -o wireguard_installer.exe "https://download.wireguard.com/windows-client/wireguard-installer-amd64-0.5.3.exe"
if exist wireguard_installer.exe (
    start /wait wireguard_installer.exe /S
)

REM === Development Tools Installation ===
REM Download and install VS Code silently, prevent auto-launch
echo Downloading and installing Visual Studio Code...
curl -L -o vscode_installer.exe "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
if exist vscode_installer.exe (
    start /wait vscode_installer.exe /VERYSILENT /MERGETASKS=!runcode
)

REM === Utility Tools Installation ===
REM Download and silently install 7-Zip
echo Downloading and installing 7-Zip...
curl -L -o 7zip_installer.exe "https://www.7-zip.org/a/7z2301-x64.exe"
if exist 7zip_installer.exe (
    start /wait 7zip_installer.exe /S
)

REM === Sysinternals Suite Installation ===
echo Installing Complete Sysinternals Suite...
mkdir C:\SysinternalTools
cd C:\SysinternalTools

REM Download and extract complete Sysinternals Suite
echo Downloading Sysinternals Suite...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$url = 'https://download.sysinternals.com/files/SysinternalsSuite.zip'; ^
$outfile = 'C:\SysinternalTools\SysinternalsSuite.zip'; ^
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
Invoke-WebRequest -Uri $url -OutFile $outfile; ^
if (Test-Path $outfile) { ^
    Add-Type -AssemblyName System.IO.Compression.FileSystem; ^
    [System.IO.Compression.ZipFile]::ExtractToDirectory($outfile, 'C:\SysinternalTools'); ^
    Remove-Item $outfile ^
}"

REM Create shortcuts for commonly used Sysinternals tools
echo Creating Sysinternals shortcuts...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$WshShell = New-Object -ComObject WScript.Shell; ^
$toolList = @( ^
    @{Name = 'Process Explorer'; File = 'procexp.exe'}, ^
    @{Name = 'Autoruns'; File = 'autoruns.exe'}, ^
    @{Name = 'TCPView'; File = 'Tcpview.exe'}, ^
    @{Name = 'Process Monitor'; File = 'Procmon.exe'}, ^
    @{Name = 'PsExec'; File = 'PsExec.exe'}, ^
    @{Name = 'Handle'; File = 'handle.exe'}, ^
    @{Name = 'ListDLLs'; File = 'ListDLLs.exe'}, ^
    @{Name = 'PsList'; File = 'PsList.exe'}, ^
    @{Name = 'Strings'; File = 'Strings.exe'}, ^
    @{Name = 'VMMap'; File = 'VMMap.exe'}, ^
    @{Name = 'WinObj'; File = 'WinObj.exe'} ^
); ^
foreach ($tool in $toolList) { ^
    $toolPath = Join-Path 'C:\SysinternalTools' $tool.File; ^
    if (Test-Path $toolPath) { ^
        $shortcutPath = Join-Path 'C:\Users\WDAGUtilityAccount\Desktop' ($tool.Name + '.lnk'); ^
        $Shortcut = $WshShell.CreateShortcut($shortcutPath); ^
        $Shortcut.TargetPath = $toolPath; ^
        $Shortcut.Save(); ^
    } ^
}"

REM Create shortcut to Sysinternals folder
echo Creating "Sysinternals Tools" folder shortcut on desktop...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$WshShell = New-Object -ComObject WScript.Shell; ^
$Shortcut = $WshShell.CreateShortcut('C:\Users\WDAGUtilityAccount\Desktop\Sysinternals Tools.lnk'); ^
$Shortcut.TargetPath = 'C:\SysinternalTools'; ^
$Shortcut.Save()"

REM Display installation completion message
echo Installation complete! You can find:
echo - Chrome and Firefox in the Start Menu
echo - Wireshark on the Desktop
echo - Process Monitor and other Sysinternals tools on the Desktop
echo - Nmap in the Start Menu
echo - WireGuard in the Start Menu
echo - Visual Studio Code in the Start Menu
echo - 7-Zip in the Start Menu
echo - Complete Sysinternals Suite in C:\SysinternalTools
echo - Shortcuts to common Sysinternals tools on the Desktop
echo.
echo Note: Some programs might need a restart of the sandbox to appear in the Start Menu.
pause