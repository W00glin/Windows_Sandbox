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
curl -L -o chrome_installer.exe https://dl.google.com/chrome/install/latest/chrome_installer.exe
if exist chrome_installer.exe (
    start /wait chrome_installer.exe /silent /install
)

echo Downloading and installing Firefox...
curl -L -o firefox_installer.exe "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
if exist firefox_installer.exe (
    start /wait firefox_installer.exe /silent
)

REM === Security Tools Installation ===
echo Downloading and installing Wireshark...
curl -L -o wireshark_installer.exe "https://2.na.dl.wireshark.org/win64/Wireshark-4.4.1-x64.exe"
if exist wireshark_installer.exe (
    start /wait wireshark_installer.exe /S /quicklaunch /desktopicon
)

echo Downloading and installing Nmap...
curl -L -o nmap_installer.exe "https://nmap.org/dist/nmap-7.94-setup.exe"
if exist nmap_installer.exe (
    start /wait nmap_installer.exe /S
)

echo Downloading and installing WireGuard...
curl -L -o wireguard_installer.exe "https://download.wireguard.com/windows-client/wireguard-installer-amd64-0.5.3.exe"
if exist wireguard_installer.exe (
    start /wait wireguard_installer.exe /S
)

REM === Tailscale Installation ===
echo Downloading and installing Tailscale...
curl -L -o tailscale_installer.msi "https://pkgs.tailscale.com/stable/tailscale-setup.exe"
if exist tailscale_installer.msi (
    msiexec /i tailscale_installer.msi /quiet /norestart
)

REM === Development Tools Installation ===
echo Downloading and installing Visual Studio Code...
curl -L -o vscode_installer.exe "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
if exist vscode_installer.exe (
    start /wait vscode_installer.exe /VERYSILENT /MERGETASKS=!runcode
)

REM === Utility Tools Installation ===
echo Downloading and installing 7-Zip...
curl -L -o 7zip_installer.exe "https://www.7-zip.org/a/7z2301-x64.exe"
if exist 7zip_installer.exe (
    start /wait 7zip_installer.exe /S
)

REM === Sysinternals Suite Installation ===
echo Installing Complete Sysinternals Suite...
mkdir C:\SysinternalTools
cd C:\SysinternalTools

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

echo Creating "Sysinternals Tools" folder shortcut on desktop...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"$WshShell = New-Object -ComObject WScript.Shell; ^
$Shortcut = $WshShell.CreateShortcut('C:\Users\WDAGUtilityAccount\Desktop\Sysinternals Tools.lnk'); ^
$Shortcut.TargetPath = 'C:\SysinternalTools'; ^
$Shortcut.Save()"

echo Installation complete!
pause
