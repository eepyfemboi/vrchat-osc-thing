@echo off
set "downloadDir=%USERPROFILE%\Downloads\vrc_osc"
set "zipFile=%downloadDir%\osc.zip"
set "githubURL=https://github.com/CoC-Fire/vrchat-osc-thing/releases/download/7/osc.zip"
set "confirmationURL=https://user-images.githubusercontent.com/101527472/189733533-957f6e92-ebba-4c67-b857-f1abac9d0eb3.gif"
set "shortcutName=VRChat OSC"
set "oscExe=%downloadDir%"

echo Since this is compiled with pyinstaller, and pyinstaller compiles similar to malware, creating a windows defender exception may be required.
echo If you have already created an exception in windows defender, you may skip this step.
echo If you know what youre doing, i would recommend installing the most recent version of python from python.org, then running the osc script directly from
echo the osc.py file on the github repo
echo Keep in mind that you must run `pip install python-osc gputil psutil asyncio winsdk` for the script to work.
echo The script will still attempt to run if you choose not to create an exception, but if you get a notification saying 'threats detected', you may need to create an exception.
echo Optionally you can create an exception manually in windows defender, but that's more complicated.
set /p "createexception=y/n: "
if /i "%createexception%"=="y" (
    echo Elevating permissions...
    powershell -Command "Start-Process -FilePath powershell -ArgumentList '-Command Add-MpPreference -ExclusionPath \"%oscExe%\"' -Verb RunAs"
    echo Creating exception...
)

rem Check if the directory exists
if not exist "%downloadDir%" (
    echo Directory "%downloadDir%" does not exist. Downloading and extracting...

    rem Create the directory
    mkdir "%downloadDir%"

    rem Download the zip file using PowerShell
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%githubURL%', '%zipFile%')"

    rem Extract the contents using PowerShell
    powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%downloadDir%' -Force"
)

echo Would you like to create a start menu shortcut?
set /p "createshortcut=y/n: "
if /i "%createshortcut%"=="y" (
    echo Creating start menu shortcut...

    set "startMenuPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\"
    set "shortcutPath=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\VRChat OSC"
    (
        echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
        echo Set oLink = oWS.CreateShortcut^("%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\VRChat OSC.lnk"^)
        echo oLink.TargetPath = "%oscExe%"
        echo oLink.Save
    ) > CreateShortcut.vbs
    cscript //nologo CreateShortcut.vbs
    del CreateShortcut.vbs
    
)

rem Ask the user to confirm OSC in VRChat
echo Please confirm that you have OSC enabled in VRChat by checking this link (ctrl + click to open in browser): %confirmationURL% then press enter to continue
set /p "confirmation=Confirm: "

rem If the user confirms, switch directory and run osc.exe
cd "%downloadDir%"
start osc.exe

exit /b 0
