@echo off
chcp 65001>nul

net session>nul 2>nul
if %errorLevel% GEQ 1 goto :startAsAdmin

%~d0
cd "%~dp0"





call :logo
echo.^(^i^) Ten Tweaker is running...
echo.
timeout /nobreak /t 1 >nul

echo.^(^!^) The author is not responsible for any possible damage to the computer^!
echo.^(^?^) Are you sure^? ^(Enter or close^)
pause>nul





goto :mainMenu
rem reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f





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
set errorLevel=
call :logo
echo.^(^>^) Choose action:
echo.    ^(1^) Control Windows Update
echo.    ^(2^) Control suggestions and auto completion
echo.    ^(3^) Setup Microsoft Office Professional Plus 2016
echo.
echo.
echo.
choice /c 123 /n /m "> "


if "%errorLevel%" == "1" call :windowsUpdateControlMenu
if "%errorLevel%" == "2" call :suggestionsControlMenu
if "%errorLevel%" == "3" call :officeSetupMenu


if "%errorLevel%" == "1234567890" exit /b
goto :mainMenu















:windowsUpdateControlMenu
set windowsUpdateState=enabled
for /f "skip=3 tokens=1,2,3* delims= " %%i in ('sc query wuauserv') do if "%%i" == "STATE" if "%%k" == "1" set windowsUpdateState=disabled

set errorLevel=

call :logo
echo.^(^i^) Windows Update Control Menu
echo.
echo.^(^!^) Current Windows Update state: %windowsUpdateState%
echo.
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Clear Windows Update distributions
echo.    ^(2^) Disable Windows Update Center and remove all downloaded updates
echo.    ^(3^) Enable Windows Update Center and launch it
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 1230 /n /m "> "

if "%errorLevel%" == "4" exit /b
call :windowsUpdateControlAction%errorLevel%
goto :windowsUpdateControlMenu





:windowsUpdateControlAction1
call :logo
echo.^(^i^) Removing downloaded Windows Update Center distributions of updates...
for /l %%i in (4,-1,1) do rd /s /q %WinDir%\SoftwareDistribution\Download
timeout /nobreak /t 1 >nul
exit /b





:windowsUpdateControlAction2
call :logo
echo.^(^i^) Terminating the Windows Update Center...
for /l %%i in (4,-1,1) do sc stop wuauserv
timeout /nobreak /t 1 >nul

echo.^(^i^) Disabling Windows Update Center...
for /l %%i in (4,-1,1) do sc config wuauserv start=disabled
timeout /nobreak /t 1 >nul

echo.^(^i^) Removing downloaded Windows Update Center distributions of updates...
for /l %%i in (4,-1,1) do rd /s /q %WinDir%\SoftwareDistribution\Download
timeout /nobreak /t 1 >nul

echo.^(^i^) Closing access to downloaded Windows Update Center distributions of updates directory...
for /l %%i in (4,-1,1) do echo.>%WinDir%\SoftwareDistribution\Download
timeout /nobreak /t 1 >nul
exit /b





:windowsUpdateControlAction3
call :logo
echo.^(^i^) Enabling Windows Update Center...
for /l %%i in (4,-1,1) do sc config wuauserv start=auto
timeout /nobreak /t 1 >nul

echo.^(^i^) Launching Windows Update Center...
for /l %%i in (4,-1,1) do sc start wuauserv
timeout /nobreak /t 1 >nul

echo.^(^i^) Opening access to downloaded Windows Update Center distributions of updates directory...
for /l %%i in (4,-1,1) do del /q "%WinDir%\SoftwareDistribution\Download"
timeout /nobreak /t 1 >nul
exit /b















:suggestionsControlMenu
set suggestions_autoSuggestState=disabled
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest') do if "%%i" == "yes" set suggestions_autoSuggestState=enabled

set suggestions_appendCompletionState=disabled
for /f "skip=2 tokens=4,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion"') do if "%%i" == "yes" set suggestions_appendCompletionState=enabled

set suggestions_startTrackProgsState=disabled
for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs') do if "%%i" == "0x1" set suggestions_startTrackProgsState=enabled

set errorLevel=

call :logo
echo.^(^i^) Suggestions Control Menu
echo.
echo.^(^!^) Auto Suggest state: %suggestions_autoSuggestState%
echo.^(^!^) Append Completion state: %suggestions_appendCompletionState%
echo.^(^!^) Start Track Progs state: %suggestions_startTrackProgsState%
echo.
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Auto Suggest
echo.    ^(2^) Append Completion
echo.    ^(3^) Start Track Progs
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 1230 /n /m "> "

if "%errorLevel%" == "1" if "%suggestions_autoSuggestState%" == "disabled" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest /t REG_SZ /d yes /f
) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest /t REG_SZ /d no /f
if "%errorLevel%" == "2" if "%suggestions_appendCompletionState%" == "disabled" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ /d yes /f
) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ /d no /f
if "%errorLevel%" == "3" if "%suggestions_appendCompletionState%" == "disabled" (
  reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v Start_TrackProgs /t REG_SZ /d 00000001 /f
) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v Start_TrackProgs /t REG_SZ /d 00000000 /f
if "%errorLevel%" == "4" exit /b
goto :suggestionsControlMenu















:officeSetupMenu
set officeSetupURL=https://onedrive.live.com/download?cid=D3AF852448CB4BF6^&resid=D3AF852448CB4BF6%%21259^&authkey=AAK3Qw80R8to-VE
set officeSetupAdditionalURL=https://public.dm.files.1drv.com/y4mTqNAebstFsw9p507h2xqKwivr_pHN6OwyaEAA3-xavLhFr_9HmsF-bF931oFmOZ-ynEy53Blug8XG1FLTmT0VT36kjGfbT1a_tItImyjwJqqKSTp1qCXBdPbKmlI5uNy0P6tkSMicg32ddWL3Z91nyoXV8SXymCpC_Bwp1SoqzBjBNAV4CXfr5t-QtlkJapj/Microsoft%%20Office%%20Professional%%20Plus%%202016.iso?access_token=EwAIA61DBAAUcSSzoTJJsy%%2bXrnQXgAKO5cj4yc8AAdNI1D0Km20nFjkwjZJAiQrksgJ3Bpa5AYk%%2fVPN9VGXuBitjIC6LhGh3WQcX%%2fE%%2f0V9IPo7%%2f2JLzjJnJ9%%2bSwX%%2bNm37S8I6zXYsDfy7AervE2iGE%%2bSJ901s1sjMHULB%%2btCGYvsUIEHNQTPA4dAn8gCmlrpp%%2f%%2f6cGuJnBlc2jysi1%%2bxKUcREdO8tfwpLvXaR9W%%2btDp5kKiLXvKuG9H0gCLpbknzFMkyaeeGemUTzGRglwqTTPlp94%%2fEmaMW9O5qg2STAFqKV6H%%2f%%2flNtevRIoCctJgU9dXcOfbc5YdRhySjbBGJxDLReJJk4X2zeRvq62G3ITD25jEOwYufL7POHXJOe47kDZgAACEMQTepMithw2AEdh0sQB%%2bLFCpxLdVafSfaeStp31%%2fHUPqg7TeINPS7DuEP3Ga%%2fqOPNX6CtkWzkrodHWyXsQj5eSV6ZMFZdZa2zrxSntXJs%%2bkaVAMLvGtXN8lwMXjyCZw8yhboCdwEqR8IzbgZsTR5DOXGLAcq%%2fRt81DQzUnnsHdnsuDO%%2ffELmE8ccu3eBp3ntqzz9MqxpsLotGpmwL5y72QWnmFM4UnCEhTYo1QzYoxyELtavpBik5y2%%2fSLUthnrXtxUGLuj9xAHcXfewJmGbhA3DVSnKdx9RqckzYjqBBISzqYQVmbWJeYsZIQaQrhcOkudEbpVTUplF4I%%2bYOJqiOCSI6W9lL6fTWdLuMYgsXTnnMtFMNPYeTTaYDQoZj1GqAZckKcdscy%%2b%%2foNZXkSNlPaJEZdZoozvuEFgRzt%%2fmWM9YvS7aCfia6kwDRxY9VEYwLvPQNhFpg3DGpTI%%2brrKokLUs6q9TIUBUfD1SUbXMTnN8cB1Jpsveic9wAfhg837RZVdBvfWZOYnv4myviNwqtXjgaxtzwpb6atb4EEOy6KQLAhqbZwHBdWIQhypIqFfRcATwpSENEP%%2b2hF7T878znu3rE%%2fJYijcuk%%2fH8GlzFi7y7y9%%2bl3hsW4L7eb6ybZD%%2fy7JEAI%%3d
set officeSetupISO=Microsoft Office Professional Plus 2016.iso

set errorLevel=

call :logo
echo.^(^i^) Microsoft Office Professional Plus 2016 Setup Menu
echo.
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

if "%errorLevel%" == "1" call :officeSetup
if "%errorLevel%" == "2" exit /b
exit /b





:officeSetup
set errorLevel=
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
timeout /nobreak /t 5 >nul

choice /c yn /n /m "(>) Setup is completed? (y/n) > "
if "%errorLevel%" == "2" goto :officeSetup
set errorLevel=

echo.^(^i^) Unmounting iso file...
powershell.exe "Dismount-DiskImage ""%~dp0%officeSetupISO%"""
timeout /nobreak /t 1 >nul
exit /b















:logo
title [MikronT] Ten Tweaker
color 0b
cls
echo.
echo.
echo.    [MikronT] ==^> Ten Tweaker
echo.   =====================================
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