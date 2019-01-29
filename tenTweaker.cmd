@echo off
chcp 65001>nul

if "%1" NEQ "--reboot" (
  net session>nul 2>nul
  if %errorLevel% GEQ 1 goto :startAsAdmin
)

%~d0
cd "%~dp0"





call :logo
echo.^(^i^) Ten Tweaker is running...
echo.
timeout /nobreak /t 1 >nul

if "%1" == "--reboot" (
  if "%2" == "sppsvcActivator" (
    for /l %%i in (10,-1,1) do sc start sppsvc
    for /l %%i in (4,-1,1) do reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v TenTweaker_SPPSvcActivator /f
  )
) else (
  echo.^(^!^) The author is not responsible for any possible damage to the computer^!
  echo.^(^?^) Are you sure^? ^(Enter or close^)
  pause>nul
  goto :mainMenu
)





call :logo
echo.^(^i^) The work is completed^!
echo.
timeout /nobreak /t 1 >nul

echo.^(^?^) Reload now^? ^(Enter or close^)
pause>nul

echo.^(^!^) Reboot^!
shutdown /r /t 5
timeout /t 4 >nul
exit















:mainMenu
call :logo
echo.^(^i^) Main Menu
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Add or remove desktop objects ^(This PC, Recycle Bin etc^)
echo.    ^(2^) Control suggestions and auto completion
echo.    ^(3^) Control Windows Update
echo.    ^(4^) Setup Microsoft Office Professional Plus 2016
echo.    ^(5^) Restore Software Protection Platform Service ^(SPPSvc^)
echo.
echo.
echo.
choice /c 12345 /n /m "> "
set command=%errorLevel%


if "%command%" == "1" call :desktopObjectsMenu
if "%command%" == "2" call :suggestionsControlMenu
if "%command%" == "3" call :windowsUpdateControlMenu
if "%command%" == "4" call :officeSetupMenu
if "%command%" == "5" call :sppsvcActivatorMenu

if "%errorLevel%" == "1234567890" exit /b
goto :mainMenu















:desktopObjectsMenu
set desktopObjects_thisPC=hidden
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D}') do if "%%i" == "0x0" set desktopObjects_thisPC=shown

set desktopObjects_recycleBin=hidden
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E}') do if "%%i" == "0x0" set desktopObjects_recycleBin=shown

set desktopObjects_controlPanel=hidden
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}') do if "%%i" == "0x0" set desktopObjects_controlPanel=shown

set desktopObjects_userFolder=hidden
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee}') do if "%%i" == "0x0" set desktopObjects_userFolder=shown

set desktopObjects_network=hidden
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C}') do if "%%i" == "0x0" set desktopObjects_network=shown

call :logo
echo.^(^i^) Desktop Objects Control Menu
echo.
echo.
echo.^(^>^) Choose action to show/hide desktop object:
echo.    ^(1^) This PC             %desktopObjects_thisPC%
echo.    ^(2^) Recycle Bin         %desktopObjects_recycleBin%
echo.    ^(3^) Control Panel       %desktopObjects_controlPanel%
echo.    ^(4^) User Folder         %desktopObjects_userFolder%
echo.    ^(5^) Network             %desktopObjects_network%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 123450 /n /m "> "
set command=%errorLevel%


if "%command%" == "1" if "%desktopObjects_thisPC%" == "hidden" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
) else reg add reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 1 /f

if "%command%" == "2" if "%desktopObjects_recycleBin%" == "hidden" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 0 /f
) else reg add reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 1 /f

if "%command%" == "3" if "%desktopObjects_controlPanel%" == "hidden" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f
) else reg add reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 1 /f

if "%command%" == "4" if "%desktopObjects_userFolder%" == "hidden" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d 0 /f
) else reg add reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d 1 /f

if "%command%" == "5" if "%desktopObjects_network%" == "hidden" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 0 /f
) else reg add reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 1 /f

if "%command%" == "6" ( set command= & exit /b )
goto :desktopObjectsMenu















:suggestionsControlMenu
set suggestions_autoSuggest=disabled
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest') do if "%%i" == "yes" set suggestions_autoSuggest=enabled

set suggestions_appendCompletion=disabled
for /f "skip=2 tokens=4,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion"') do if "%%i" == "yes" set suggestions_appendCompletion=enabled

set suggestions_startTrackProgs=disabled
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs') do if "%%i" == "0x1" set suggestions_startTrackProgs=enabled

call :logo
echo.^(^i^) Suggestions Control Menu
echo.
echo.
echo.^(^>^) Choose action to enable/disable suggestions:
echo.    ^(1^) Auto Suggest            %suggestions_autoSuggest%
echo.    ^(2^) Append Completion       %suggestions_appendCompletion%
echo.    ^(3^) Start Track Progs       %suggestions_startTrackProgs%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 1230 /n /m "> "
set command=%errorLevel%


if "%command%" == "1" if "%suggestions_autoSuggest%" == "disabled" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest /t REG_SZ /d yes /f
) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest /t REG_SZ /d no /f

if "%command%" == "2" if "%suggestions_appendCompletion%" == "disabled" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ /d yes /f
) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ /d no /f

if "%command%" == "3" if "%suggestions_startTrackProgs%" == "disabled" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v Start_TrackProgs /t REG_SZ /d 00000001 /f
) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v Start_TrackProgs /t REG_SZ /d 00000000 /f

if "%command%" == "4" ( set command= & exit /b )
goto :suggestionsControlMenu















:windowsUpdateControlMenu
set windowsUpdate_updateDistributions=unlocked
for /f "delims=" %%i in ('dir /a:-d /b %WinDir%\SoftwareDistribution\Download') do if "%%i" == "Download" set windowsUpdate_updateDistributions=locked

set windowsUpdate_updateCenter=enabled
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\wuauserv /v Start') do if "%%i" == "0x4" set windowsUpdate_updateCenter=disabled

call :logo
echo.^(^i^) Windows Update Control Menu
echo.
echo.
echo.^(^>^) Choose action to enable/disable Windows Update:
echo.    ^(1^) Windows Update distributions       %windowsUpdate_updateDistributions%
echo.    ^(2^) Windows Update Center              %windowsUpdate_updateCenter%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 120 /n /m "> "
set command=%errorLevel%


if "%command%" == "1" if "%windowsUpdate_updateDistributions%" == "unlocked" (
  for /l %%i in (4,-1,1) do rd /s /q "%WinDir%\SoftwareDistribution\Download"
  echo.>"%WinDir%\SoftwareDistribution\Download"
) else (
  del /q "%WinDir%\SoftwareDistribution\Download"
  md "%WinDir%\SoftwareDistribution\Download"
)

if "%command%" == "2" if "%windowsUpdate_updateCenter%" == "enabled" (
  for /l %%i in (4,-1,1) do sc stop wuauserv
  for /l %%i in (4,-1,1) do sc config wuauserv start=disabled
) else (
  for /l %%i in (4,-1,1) do sc config wuauserv start=auto
  for /l %%i in (4,-1,1) do sc start wuauserv
)

if "%command%" == "3" ( set command= & exit /b )
goto :windowsUpdateControlMenu















:officeSetupMenu
set officeSetupURL=https://onedrive.live.com/download?cid=D3AF852448CB4BF6^&resid=D3AF852448CB4BF6%%21259^&authkey=AAK3Qw80R8to-VE
set officeSetupAdditionalURL=https://public.dm.files.1drv.com/y4mTqNAebstFsw9p507h2xqKwivr_pHN6OwyaEAA3-xavLhFr_9HmsF-bF931oFmOZ-ynEy53Blug8XG1FLTmT0VT36kjGfbT1a_tItImyjwJqqKSTp1qCXBdPbKmlI5uNy0P6tkSMicg32ddWL3Z91nyoXV8SXymCpC_Bwp1SoqzBjBNAV4CXfr5t-QtlkJapj/Microsoft%%20Office%%20Professional%%20Plus%%202016.iso?access_token=EwAIA61DBAAUcSSzoTJJsy%%2bXrnQXgAKO5cj4yc8AAdNI1D0Km20nFjkwjZJAiQrksgJ3Bpa5AYk%%2fVPN9VGXuBitjIC6LhGh3WQcX%%2fE%%2f0V9IPo7%%2f2JLzjJnJ9%%2bSwX%%2bNm37S8I6zXYsDfy7AervE2iGE%%2bSJ901s1sjMHULB%%2btCGYvsUIEHNQTPA4dAn8gCmlrpp%%2f%%2f6cGuJnBlc2jysi1%%2bxKUcREdO8tfwpLvXaR9W%%2btDp5kKiLXvKuG9H0gCLpbknzFMkyaeeGemUTzGRglwqTTPlp94%%2fEmaMW9O5qg2STAFqKV6H%%2f%%2flNtevRIoCctJgU9dXcOfbc5YdRhySjbBGJxDLReJJk4X2zeRvq62G3ITD25jEOwYufL7POHXJOe47kDZgAACEMQTepMithw2AEdh0sQB%%2bLFCpxLdVafSfaeStp31%%2fHUPqg7TeINPS7DuEP3Ga%%2fqOPNX6CtkWzkrodHWyXsQj5eSV6ZMFZdZa2zrxSntXJs%%2bkaVAMLvGtXN8lwMXjyCZw8yhboCdwEqR8IzbgZsTR5DOXGLAcq%%2fRt81DQzUnnsHdnsuDO%%2ffELmE8ccu3eBp3ntqzz9MqxpsLotGpmwL5y72QWnmFM4UnCEhTYo1QzYoxyELtavpBik5y2%%2fSLUthnrXtxUGLuj9xAHcXfewJmGbhA3DVSnKdx9RqckzYjqBBISzqYQVmbWJeYsZIQaQrhcOkudEbpVTUplF4I%%2bYOJqiOCSI6W9lL6fTWdLuMYgsXTnnMtFMNPYeTTaYDQoZj1GqAZckKcdscy%%2b%%2foNZXkSNlPaJEZdZoozvuEFgRzt%%2fmWM9YvS7aCfia6kwDRxY9VEYwLvPQNhFpg3DGpTI%%2brrKokLUs6q9TIUBUfD1SUbXMTnN8cB1Jpsveic9wAfhg837RZVdBvfWZOYnv4myviNwqtXjgaxtzwpb6atb4EEOy6KQLAhqbZwHBdWIQhypIqFfRcATwpSENEP%%2b2hF7T878znu3rE%%2fJYijcuk%%2fH8GlzFi7y7y9%%2bl3hsW4L7eb6ybZD%%2fy7JEAI%%3d
set officeSetupISO=Microsoft Office Professional Plus 2016.iso

call :logo
echo.^(^i^) Microsoft Office Professional Plus 2016 Setup Menu
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Run setup
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 10 /n /m "> "
set command=%errorLevel%


if "%command%" == "2" ( set command= & exit /b )

:officeSetup
call :logo
if not exist "%officeSetupISO%" (
  echo.^(^i^) Downloading Microsoft Office Professional Plus 2016 Setup
  wget.exe --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate --tries=3 "%officeSetupURL%" --output-document="%officeSetupISO%"
  if not exist "%officeSetupISO%" if "%officeSetupURL%" NEQ "%officeSetupAdditionalURL%" (
    set officeSetupURL=%officeSetupAdditionalURL%
    goto :officeSetup
  )
  timeout /nobreak /t 1 >nul
)

echo.^(^i^) Mounting iso file...
powershell.exe "Mount-DiskImage ""%~dp0%officeSetupISO%"""
timeout /nobreak /t 1 >nul

echo.^(^i^) Running setup...
for /f "skip=3" %%i in ('powershell.exe "Get-DiskImage """%~dp0%officeSetupISO%""" | Get-Volume | Select-Object {$_.DriveLetter}"') do start /wait %%i:\O16Setup.exe
timeout /nobreak /t 1 >nul

choice /c yn /n /m "(>) Setup is completed? (y/n) > "
set command=%errorLevel%
if "%command%" == "2" goto :officeSetup

echo.^(^i^) Unmounting iso file...
powershell.exe "Dismount-DiskImage ""%~dp0%officeSetupISO%"""
timeout /nobreak /t 1 >nul
goto :officeSetupMenu















:sppsvcActivatorMenu
set sppsvc_service=enabled
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\sppsvc /v Start') do if "%%i" == "0x4" set sppsvc_service=disabled

call :logo
echo.^(^i^) SPPSvc Activator Menu
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Restore Software Protection Platform Service ^(SPPSvc^)       %sppsvc_service%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 10 /n /m "> "
set command=%errorLevel%


if "%command%" == "2" ( set command= & exit /b )

for /l %%i in (4,-1,1) do reg import files\sppsvcActivator_registry.reg
for /l %%i in (10,-1,1) do sc start sppsvc
for /l %%i in (4,-1,1) do reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v TenTweaker_SPPSvcActivator /t REG_SZ /d """%~dp0sppsvcActivatorRebooter.cmd""" /f
goto :sppsvcActivatorMenu















:logo
title [MikronT] Ten Tweaker
color 0b
cls
echo.
echo.
echo.    [MikronT] ==^> Ten Tweaker
echo.   ===========================
echo.     See other here:
echo.         github.com/MikronT
echo.
echo.
echo.
exit /b







:startAsAdmin
echo.^(^!^) Please, run as Admin^!
timeout /nobreak /t 3 >nul
exit