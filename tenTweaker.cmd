@echo off
chcp 65001>nul

net session>nul 2>nul
if %errorLevel% GEQ 1 (
  echo.^(^!^) Please, run as Admin^!
  timeout /nobreak /t 3 >nul
  exit
)

%~d0
cd "%~dp0"

if not exist temp md temp

for /f "tokens=1,2,3,4,* delims=- " %%i in ("%*") do (
  set %%i
  set %%j
  set %%k
  set %%l
)

if "%key_main_registryMerge%" NEQ "true" (
  reg export HKCU\Console\%%SystemRoot%%_system32_cmd.exe temp\consoleSettings.reg /y >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v CodePage         /t REG_DWORD /d 65001      /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ColorTable00     /t REG_DWORD /d 0          /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FaceName         /t REG_SZ    /d Consolas   /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontFamily       /t REG_DWORD /d 0x0000036  /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontSize         /t REG_DWORD /d 0x00100008 /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontWeight       /t REG_DWORD /d 0x0000190  /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ScreenBufferSize /t REG_DWORD /d 0x2329006a /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v WindowSize       /t REG_DWORD /d 0x001e006e /f >nul

  start "" cmd /c "%~dpnx0" --key_main_registryMerge=true
  exit
) else if exist temp\consoleSettings.reg (
  reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /va /f
  reg import temp\consoleSettings.reg >nul
)

set module_wget=files\wget.exe --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate --tries=3

set stringBuilder_build=set stringBuilder_string=%%stringBuilder_string%%
set option_enabled=enabled         
set option_disabled=disabled        
set option_shown=shown           
set option_hidden=hidden          
set option_error=[error]         





call :logo
echo.^(i^) Ten Tweaker is running...
echo.
timeout /nobreak /t 1 >nul

if "%key_main_reboot%" == "services_sppsvc" (
  for /l %%i in (10,-1,1) do sc start sppsvc
  for /l %%i in (4,-1,1) do reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v tenTweaker_services_sppsvc /f
) else (
  if "%key_main_eula%" NEQ "hidden" (
    echo.^(^!^) The author is not responsible for any possible damage to the computer^!
    echo.^(^?^) Are you sure^? ^(Enter or close^)
    pause>nul
  )
  goto :main_menu
)





call :logo
echo.^(i^) The work is completed^!
echo.
timeout /nobreak /t 1 >nul

echo.^(^?^) Reboot now^? ^(Enter or close^)
pause>nul
call :reboot_computer
exit















:main_menu
call :main_variables

call :logo
echo.  Interface                                                   Setup
echo.    ^(1^) Desktop objects ^(This PC etc^)                           ^(6^) Setup Office Professional+ 2016
echo.    ^(2^) Language key sequence ^(Ctrl + Shift^)                    ^(7^) Setup/restore gpedit.msc
echo.    ^(3^) Input suggestions and auto completion
echo.    ^(4^) Windows Explorer                                      Services
echo.    ^(5^) Windows Task Bar                                        ^(8^) Windows Update ^(wuauserv^)
echo.                                                                ^(9^) Software Protection Platform Service ^(sppsvc^)
echo.  Tools
echo.    ^(A^) Manage Administrative Tools
echo.
echo.
echo.    ^(0^) Exit
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools main_menu
choice /c 123456789A0 /n /m "> "
set command=%errorLevel%



if "%command%" == "1" call :interface_desktopObjects
if "%command%" == "2" call :interface_languageKeySequence
if "%command%" == "3" call :interface_suggestions
if "%command%" == "4" call :interface_explorer
if "%command%" == "5" call :interface_taskBar

if "%command%" == "6" call :setup_office
if "%command%" == "7" call :setup_gpeditMSC

if "%command%" == "8" call :services_windowsUpdate
if "%command%" == "9" call :services_sppsvc

if "%command%" == "10" call :tools_administrativeTools

if "%command%" == "11" (
  rd /s /q temp
  exit /b
)
goto :main_menu















:interface_desktopObjects
call :main_variables interface_desktopObjects

call :logo
echo.^(i^) Desktop Objects - Control Menu
echo.
echo.
echo.^(^>^) Choose action to show/hide desktop object:

set stringBuilder_string=^(1^) This PC                            
if "%interface_desktopObjects_thisPC%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_desktopObjects_thisPC%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(4^) User Folder                        
if "%interface_desktopObjects_userFolder%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_desktopObjects_userFolder%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=^(2^) Recycle Bin                        
if "%interface_desktopObjects_recycleBin%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_desktopObjects_recycleBin%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(5^) Network                            
if "%interface_desktopObjects_network%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_desktopObjects_network%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

echo.    ^(3^) Control Panel                       %interface_desktopObjects_controlPanel%
echo.
echo.    Note: These features require to restart Windows Explorer.
echo.    ^(E^) Restart Windows Explorer
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 12345E0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" if "%interface_desktopObjects_thisPC%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 1 /f >nul

  if "%command%" == "2" if "%interface_desktopObjects_recycleBin%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 1 /f >nul

  if "%command%" == "3" if "%interface_desktopObjects_controlPanel%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 1 /f >nul

  if "%command%" == "4" if "%interface_desktopObjects_userFolder%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d 1 /f >nul

  if "%command%" == "5" if "%interface_desktopObjects_network%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 1 /f >nul
)

if "%command%" == "6" call :restart_explorer
if "%command%" == "7" ( set command= & exit /b )
goto :interface_desktopObjects















:interface_languageKeySequence
call :main_variables interface_languageKeySequence
if "%error_main_variables_disabledRegistryTools%" NEQ "1" if "%interface_languageKeySequence_inputLanguageSwitch%" == "%interface_languageKeySequence_keyboardLayoutSwitch%" (
  if "%interface_languageKeySequence_inputLanguageSwitch%" NEQ "Not assigned" (
    set error_interface_languageKeySequence=1
  ) else set error_interface_languageKeySequence=0
) else set error_interface_languageKeySequence=0

call :logo
echo.^(i^) Language Key Sequence - Control Menu
echo.
echo.
echo.^(^>^) Choose action to change key sequence:
echo.    ^(1^) Input language                      %interface_languageKeySequence_inputLanguageSwitch%
echo.    ^(2^) Keyboard layout                     %interface_languageKeySequence_keyboardLayoutSwitch%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
if "%error_interface_languageKeySequence%" == "1" (
  color 0c
  echo.    ^(^!^) Can not be two identical key combinations^!
  echo.
  echo.
  echo.
) else color 0b
choice /c 120 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" (
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "Not assigned" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "2" /f >nul
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "Ctrl + Shift" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "1" /f >nul
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "Left Alt + Shift" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "4" /f >nul
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "Grave accent (`)" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "3" /f >nul
  )

  if "%command%" == "2" (
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "Not assigned" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 2 /f >nul
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "Ctrl + Shift" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 1 /f >nul
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "Left Alt + Shift" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 4 /f >nul
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "Grave accent (`)" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 3 /f >nul
  )
)

if "%command%" == "3" if "%error_interface_languageKeySequence%" NEQ "1" ( set command= & exit /b )
goto :interface_languageKeySequence















:interface_suggestions
call :main_variables interface_suggestions

call :logo
echo.^(i^) Input Suggestions - Control Menu
echo.
echo.
echo.^(^>^) Choose action to enable/disable input suggestions:
echo.    ^(1^) Auto Suggest                        %interface_suggestions_autoSuggest%
echo.    ^(2^) Append Completion                   %interface_suggestions_appendCompletion%
echo.    ^(3^) Start Track Progs                   %interface_suggestions_startTrackProgs%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 1230 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" if "%interface_suggestions_autoSuggest%" == "disabled" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest /t REG_SZ /d yes /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest /t REG_SZ /d no /f >nul

  if "%command%" == "2" if "%interface_suggestions_appendCompletion%" == "disabled" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ /d yes /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ /d no /f >nul

  if "%command%" == "3" if "%interface_suggestions_startTrackProgs%" == "disabled" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs /t REG_DWORD /d 1 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs /t REG_DWORD /d 0 /f >nul
)

if "%command%" == "4" ( set command= & exit /b )
goto :interface_suggestions















:interface_explorer
call :main_variables interface_explorer

call :logo
echo.^(i^) Windows Explorer - Control Menu
echo.
echo.
echo.^(^>^) Choose action to config Windows Explorer:

set stringBuilder_string=^(1^) File extensions                    
if "%interface_explorer_fileExtensions%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_explorer_fileExtensions%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(6^) Ribbon ^(option bar^)                
if "%interface_explorer_ribbon%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_explorer_ribbon%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=^(2^) Hidden files                       
if "%interface_explorer_hiddenFiles%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_explorer_hiddenFiles%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(7^) Expand to open folder              
if "%interface_explorer_expandToCurrentFolder%" == "enabled" (
  call %stringBuilder_build% %option_enabled%
) else if "%interface_explorer_expandToCurrentFolder%" == "disabled" (
  call %stringBuilder_build% %option_disabled%
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=^(3^) Hidden protected system files      
if "%interface_explorer_hiddenProtectedSystemFiles%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_explorer_hiddenProtectedSystemFiles%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(8^) Status bar                         
if "%interface_explorer_statusBar%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_explorer_statusBar%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=^(4^) Empty drives                       
if "%interface_explorer_emptyDrives%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_explorer_emptyDrives%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(9^) File info tip                      
if "%interface_explorer_fileInfoTip%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_explorer_fileInfoTip%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

echo.    ^(5^) Folder merge conflicts              %interface_explorer_folderMergeConflicts%
echo.
echo.
echo.    Note: These features require to restart Windows Explorer.
echo.    ^(E^) Restart Windows Explorer
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 123456789E0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" if "%interface_explorer_fileExtensions%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 1 /f >nul

  if "%command%" == "2" if "%interface_explorer_hiddenFiles%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden /t REG_DWORD /d 1 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden /t REG_DWORD /d 2 /f >nul

  if "%command%" == "3" if "%interface_explorer_hiddenProtectedSystemFiles%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden /t REG_DWORD /d 1 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden /t REG_DWORD /d 0 /f >nul

  if "%command%" == "4" if "%interface_explorer_emptyDrives%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideDrivesWithNoMedia /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideDrivesWithNoMedia /t REG_DWORD /d 1 /f >nul

  if "%command%" == "5" if "%interface_explorer_folderMergeConflicts%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideMergeConflicts /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideMergeConflicts /t REG_DWORD /d 1 /f >nul

  if "%command%" == "6" if "%interface_explorer_ribbon%" == "hidden" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon /v MinimizedStateTabletModeOff /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon /v MinimizedStateTabletModeOff /t REG_DWORD /d 1 /f >nul

  if "%command%" == "7" if "%interface_explorer_expandToCurrentFolder%" == "disabled" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v NavPaneExpandToCurrentFolder /t REG_DWORD /d 1 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v NavPaneExpandToCurrentFolder /t REG_DWORD /d 0 /f >nul

  if "%command%" == "8" if "%interface_explorer_statusBar%" == "shown" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowStatusBar /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowStatusBar /t REG_DWORD /d 1 /f >nul

  if "%command%" == "9" if "%interface_explorer_fileInfoTip%" == "shown" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowInfoTip /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowInfoTip /t REG_DWORD /d 1 /f >nul
)

if "%command%" == "10" call :restart_explorer
if "%command%" == "11" ( set command= & exit /b )
goto :interface_explorer















:interface_taskBar
call :main_variables interface_taskBar

call :logo
echo.^(i^) Windows Task Bar - Control Menu
echo.
echo.
echo.^(^>^) Choose action to config Windows Task Bar:

set stringBuilder_string=^(1^) Peaple band                        
if "%interface_taskBar_peopleBand%" == "shown" (
  call %stringBuilder_build% %option_shown%
) else if "%interface_taskBar_peopleBand%" == "hidden" (
  call %stringBuilder_build% %option_hidden%
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(4^) Small icons                        
if "%interface_taskBar_smallIcons%" == "enabled" (
  call %stringBuilder_build% %option_enabled%
) else if "%interface_taskBar_smallIcons%" == "disabled" (
  call %stringBuilder_build% %option_disabled%
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=^(2^) Command prompt on Win + X          
if "%interface_taskBar_commandPromptOnWinX%" == "PowerShell" (
  call %stringBuilder_build% PowerShell      
) else if "%interface_taskBar_commandPromptOnWinX%" == "Command Prompt" (
  call %stringBuilder_build% Command Prompt  
) else call %stringBuilder_build% %option_error%
call %stringBuilder_build%    ^(5^) Buttons combine                    
if "%interface_taskBar_buttonsCombine%" == "always" (
  call %stringBuilder_build% always          
) else if "%interface_taskBar_buttonsCombine%" == "when is full" (
  call %stringBuilder_build% when is full    
) else if "%interface_taskBar_buttonsCombine%" == "never" (
  call %stringBuilder_build% never           
) else call %stringBuilder_build% %option_error%
echo.    %stringBuilder_string%

echo.    ^(3^) Task view button                    %interface_taskBar_taskViewButton%
echo.
echo.    Note: These features require to restart Windows Explorer.
echo.    ^(E^) Restart Windows Explorer
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 12345E0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" if "%interface_taskBar_peopleBand%" == "shown" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand /t REG_DWORD /d 1 /f >nul

  if "%command%" == "2" if "%interface_taskBar_commandPromptOnWinX%" == "PowerShell" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX /t REG_DWORD /d 1 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX /t REG_DWORD /d 0 /f >nul

  if "%command%" == "3" if "%interface_taskBar_taskViewButton%" == "shown" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton /t REG_DWORD /d 1 /f >nul

  if "%command%" == "4" if "%interface_taskBar_smallIcons%" == "disabled" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons /t REG_DWORD /d 1 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons /t REG_DWORD /d 0 /f >nul

  if "%command%" == "5" (
    if "%interface_taskBar_buttonsCombine%" == "always" reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel /t REG_DWORD /d 1 /f >nul
    if "%interface_taskBar_buttonsCombine%" == "when is full" reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel /t REG_DWORD /d 2 /f >nul
    if "%interface_taskBar_buttonsCombine%" == "never" reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel /t REG_DWORD /d 0 /f >nul
  )
)

if "%command%" == "6" call :restart_explorer
if "%command%" == "7" ( set command= & exit /b )
goto :interface_taskBar















:setup_office
call :main_variables setup_office

call :logo
echo.^(i^) Microsoft Office Professional+ 2016 - Setup Menu
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Run setup
echo.
echo.    Note: This feature requires to reboot your computer.
echo.    ^(R^) Reboot computer
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
if "%error_setup_office%" == "1" (
  color 0c
  echo.    ^(^!^) Download error^! Server not respond or no Internet connection^!
  echo.
  echo.
  echo.
  set error_setup_office=0
) else color 0b
choice /c 1R0 /n /m "> "
set command=%errorLevel%



:setup_office_setup
if "%error_main_variables_disabledRegistryTools%" NEQ "1" if "%command%" == "1" (
  call :logo
  if exist "%setup_office_setupISO%" del /q "%setup_office_setupISO%"

  echo.^(i^) Downloading Microsoft Office Professional Plus 2016 Setup
  %module_wget% "%setup_office_setupURL%" --output-document="%setup_office_setupISO%"
  timeout /nobreak /t 1 >nul

  for /f "skip=6 tokens=1,3,* delims= " %%i in ('dir "%~dp0%setup_office_setupISO%"') do if "%%i" == "1" if "%%j" == "0" (
    set error_setup_office=1
    goto :setup_office
  )

  echo.^(i^) Mounting iso file...
  start /wait /min powershell.exe "Mount-DiskImage ""%~dp0%setup_office_setupISO%"""
  timeout /nobreak /t 1 >nul

  echo.^(i^) Setup...
  for /f "skip=3" %%i in ('powershell.exe "Get-DiskImage """%~dp0%setup_office_setupISO%""" | Get-Volume | Select-Object {$_.DriveLetter}"') do start /wait %%i:\O16Setup.exe
  timeout /nobreak /t 1 >nul

  echo.^(i^) Unmounting iso file...
  start /wait /min powershell.exe "Dismount-DiskImage ""%~dp0%setup_office_setupISO%"""
  timeout /nobreak /t 1 >nul
)

if "%command%" == "2" call :reboot_computer
if "%command%" == "3" ( set command= & exit /b )
goto :setup_office















:setup_gpeditMSC
call :main_variables setup_gpeditMSC

call :logo
echo.^(i^) Group Policy Editor - Setup Menu
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Setup/repair gpedit.msc             %setup_gpeditMSC_gpeditFile%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 10 /n /m "> "
set command=%errorLevel%



if "%command%" == "2" ( set command= & exit /b )

if "%error_main_variables_disabledRegistryTools%" == "1" goto :setup_gpeditMSC

dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >%setup_gpeditMSC_packagesList%
dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>%setup_gpeditMSC_packagesList%
for /f %%i in ('findstr /i . %setup_gpeditMSC_packagesList% 2^>nul') do dism /online /norestart /add-package:"%systemRoot%\servicing\Packages\%%i"
goto :setup_gpeditMSC















:services_windowsUpdate
set services_windowsUpdate_updateDistributions=unlocked
for /f "delims=" %%i in ('dir /a:-d /b "%WinDir%\SoftwareDistribution\Download"') do if "%%i" == "Download" set services_windowsUpdate_updateDistributions=locked

call :main_variables services_windowsUpdate

call :logo
echo.^(i^) Windows Update ^(wuauserv^) - Control Menu
echo.
echo.
echo.^(^>^) Choose action to enable/disable Windows Update:
echo.    ^(1^) Update distributions                %services_windowsUpdate_updateDistributions%
echo.    ^(2^) Update Center ^(wuauserv^)            %services_windowsUpdate_updateCenter%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 120 /n /m "> "
set command=%errorLevel%



if "%command%" == "1" if "%services_windowsUpdate_updateDistributions%" == "unlocked" (
  for /l %%i in (4,-1,1) do rd /s /q "%WinDir%\SoftwareDistribution\Download"
  echo.>"%WinDir%\SoftwareDistribution\Download"
) else (
  del /q "%WinDir%\SoftwareDistribution\Download"
  md "%WinDir%\SoftwareDistribution\Download"
)

if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "2" if "%services_windowsUpdate_updateCenter%" == "enabled" (
    for /l %%i in (4,-1,1) do sc stop wuauserv
    for /l %%i in (4,-1,1) do sc config wuauserv start=disabled
  ) else (
    for /l %%i in (4,-1,1) do sc config wuauserv start=auto
    for /l %%i in (4,-1,1) do sc start wuauserv
  )
)

if "%command%" == "3" ( set command= & exit /b )
goto :services_windowsUpdate















:services_sppsvc
call :main_variables services_sppsvc

call :logo
echo.^(i^) Software Protection Platform Service ^(sppsvc^) - Restore Menu
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Restore service                     %services_sppsvc_service%
echo.
echo.    Note: This feature requires to reboot your computer two times.
echo.          The computer will automatically reboot after the next system start.
echo.    ^(R^) Reboot computer
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 1R0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" (
    for /l %%i in (4,-1,1) do reg import files\services_sppsvc_registry.reg >nul
    for /l %%i in (10,-1,1) do sc start sppsvc
  )

  if "%command%" == "2" (
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v tenTweaker_services_sppsvc /t REG_SZ /d "%~dpnx0 --key_main_reboot=services_sppsvc" /f >nul
    call :reboot_computer
  )
)

if "%command%" == "3" ( set command= & exit /b )
goto :services_sppsvc















:tools_administrativeTools
call :main_variables tools_administrativeTools
if "%error_main_variables_disabledRegistryTools%" == "1" set key_tools_administrativeTools_hiddenOptions=enabled

call :logo
echo.^(i^) Windows Administrative Tools - Control Menu
echo.
echo.
echo.^(^>^) Choose action to config Windows Administrative Tools:

set stringBuilder_string=^(1^) Desktop                            
if "%tools_administrativeTools_desktop%" == "enabled" (
  call %stringBuilder_build% %option_enabled%
) else if "%tools_administrativeTools_desktop%" == "disabled" (
  call %stringBuilder_build% %option_disabled%
) else call %stringBuilder_build% %option_error%
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  call %stringBuilder_build%    ^(4^) Registry Tools                     
  if "%tools_administrativeTools_registryTools%" == "enabled" (
    call %stringBuilder_build% %option_enabled%
  ) else if "%tools_administrativeTools_registryTools%" == "disabled" (
    call %stringBuilder_build% %option_disabled%
  ) else call %stringBuilder_build% %option_error%
)
echo.    %stringBuilder_string%

set stringBuilder_string=^(2^) Control Panel                      
if "%tools_administrativeTools_controlPanel%" == "enabled" (
  call %stringBuilder_build% %option_enabled%
) else if "%tools_administrativeTools_controlPanel%" == "disabled" (
  call %stringBuilder_build% %option_disabled%
) else call %stringBuilder_build% %option_error%
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  call %stringBuilder_build%    ^(5^) Command Prompt                     
  if "%tools_administrativeTools_cmd%" == "enabled" (
    call %stringBuilder_build% %option_enabled%
  ) else if "%tools_administrativeTools_cmd%" == "disabled" (
    call %stringBuilder_build% %option_disabled%
  ) else call %stringBuilder_build% %option_error%
)
echo.    %stringBuilder_string%

set stringBuilder_string=^(3^) Run ^(Win + R^)                      
if "%tools_administrativeTools_runDialog%" == "enabled" (
  call %stringBuilder_build% %option_enabled%
) else if "%tools_administrativeTools_runDialog%" == "disabled" (
  call %stringBuilder_build% %option_disabled%
) else call %stringBuilder_build% %option_error%
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  call %stringBuilder_build%    ^(6^) Task Manager                       
  if "%tools_administrativeTools_taskManager%" == "enabled" (
    call %stringBuilder_build% %option_enabled%
  ) else if "%tools_administrativeTools_taskManager%" == "disabled" (
    call %stringBuilder_build% %option_disabled%
  ) else call %stringBuilder_build% %option_error%
)
echo.    %stringBuilder_string%

echo.
echo.    Note: These features require to update group policy.
echo.    ^(U^) Update group policy
echo.
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  echo.    Note: Features ^(3^), ^(5^) and ^(6^) require to restart Windows Explorer.
) else echo.    Note: Feature ^(3^) requires to restart Windows Explorer.
echo.    ^(E^) Restart Windows Explorer
echo.
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  echo.    Note: Feature ^(5^) requires to reboot your computer.
  echo.    ^(R^) Reboot computer
  echo.
)
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  echo.    ^(^!^) Warning^! Hidden Options are shown^! They can kill your PC^!
  echo.
  choice /c 123456UER0 /n /m "> "
) else choice /c 123UE0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" if "%tools_administrativeTools_desktop%" == "enabled" (
    for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop /t REG_DWORD /d 1 /f >nul
  ) else for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop /t REG_DWORD /d 0 /f >nul

  if "%command%" == "2" if "%tools_administrativeTools_controlPanel%" == "enabled" (
    for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel /t REG_DWORD /d 1 /f >nul
  ) else for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel /t REG_DWORD /d 0 /f >nul

  if "%command%" == "3" if "%tools_administrativeTools_runDialog%" == "enabled" (
    for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun /t REG_DWORD /d 1 /f >nul
  ) else for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun /t REG_DWORD /d 0 /f >nul
)

if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  if "%command%" == "4" if "%tools_administrativeTools_registryTools%" == "enabled" (
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul
  ) else for /l %%i in (4,-1,1) do rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 %~dp0files\tools_administrativeTools_unHookExec.inf

  if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
    if "%command%" == "5" if "%tools_administrativeTools_cmd%" == "enabled" (
      for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD /t REG_DWORD /d 1 /f >nul
    ) else for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD /t REG_DWORD /d 0 /f >nul

    if "%command%" == "6" if "%tools_administrativeTools_taskManager%" == "enabled" (
      for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul
    ) else for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 0 /f >nul
  )

  if "%command%" == "7" for /l %%i in (4,-1,1) do gpupdate /force >nul
  if "%command%" == "8" call :restart_explorer
  if "%command%" == "9" call :reboot_computer
  if "%command%" == "10" ( set command= & exit /b )
) else (
  if "%command%" == "4" for /l %%i in (4,-1,1) do gpupdate /force >nul
  if "%command%" == "5" call :restart_explorer
  if "%command%" == "6" ( set command= & exit /b )
)
goto :tools_administrativeTools















:template
call :main_variables template

call :logo
echo.^(i^) Template - Control Menu
echo.
echo.
echo.^(^>^) Choose action to config template:
echo.    ^(1^) Option                              %option%
echo.    ^(2^) Option                              %option%
echo.    ^(3^) Option                              %option%
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :errorMessage_main_variables_disabledRegistryTools
choice /c 1230 /n /m "> "
set command=%errorLevel%



if "%command%" == "1" if "%option%" == "" (
  command
) else command

if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "2" if "%option%" == "" (
    command
  ) else command

  if "%command%" == "3" if "%option%" == "" (
    command
  ) else command
)

if "%command%" == "4" ( set command= & exit /b )
goto :template















:main_variables
set errorLevel=
reg query HKCU >nul

if %errorLevel% GEQ 1 (
  set interface_desktopObjects_thisPC=[error]
  set interface_desktopObjects_recycleBin=[error]
  set interface_desktopObjects_controlPanel=[error]
  set interface_desktopObjects_userFolder=[error]
  set interface_desktopObjects_network=[error]

  set interface_languageKeySequence_inputLanguageSwitch=[error]
  set interface_languageKeySequence_keyboardLayoutSwitch=[error]

  set interface_suggestions_autoSuggest=[error]
  set interface_suggestions_appendCompletion=[error]
  set interface_suggestions_startTrackProgs=[error]

  set interface_explorer_fileExtensions=[error]
  set interface_explorer_hiddenFiles=[error]
  set interface_explorer_hiddenProtectedSystemFiles=[error]
  set interface_explorer_emptyDrives=[error]
  set interface_explorer_folderMergeConflicts=[error]
  set interface_explorer_ribbon=[error]
  set interface_explorer_expandToCurrentFolder=[error]
  set interface_explorer_statusBar=[error]
  set interface_explorer_fileInfoTip=[error]

  set interface_taskBar_peopleBand=[error]
  set interface_taskBar_commandPromptOnWinX=[error]
  set interface_taskBar_taskViewButton=[error]
  set interface_taskBar_smallIcons=[error]
  set interface_taskBar_buttonsCombine=[error]

  set setup_gpeditMSC_gpeditFile=[error]

  set services_windowsUpdate_updateCenter=[error]

  set services_sppsvc_service=[error]

  set tools_administrativeTools_taskManager=[error]
  set tools_administrativeTools_controlPanel=[error]
  set tools_administrativeTools_runDialog=[error]
  set tools_administrativeTools_registryTools=disabled
  set tools_administrativeTools_cmd=[error]
  set tools_administrativeTools_desktop=[error]

  set error_main_variables_disabledRegistryTools=1
  exit /b
) else set error_main_variables_disabledRegistryTools=0





if "%1" == "interface_desktopObjects" (
  set interface_desktopObjects_thisPC=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D}') do if "%%i" == "0x0" set interface_desktopObjects_thisPC=shown

  set interface_desktopObjects_recycleBin=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E}') do if "%%i" == "0x1" set interface_desktopObjects_recycleBin=hidden

  set interface_desktopObjects_controlPanel=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}') do if "%%i" == "0x0" set interface_desktopObjects_controlPanel=shown

  set interface_desktopObjects_userFolder=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee}') do if "%%i" == "0x0" set interface_desktopObjects_userFolder=shown

  set interface_desktopObjects_network=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C}') do if "%%i" == "0x0" set interface_desktopObjects_network=shown
)





if "%1" == "interface_languageKeySequence" (
  set interface_languageKeySequence_inputLanguageSwitch=Left Alt + Shift
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey"') do (
    if "%%i" == "3" set interface_languageKeySequence_inputLanguageSwitch=Not assigned
    if "%%i" == "2" set interface_languageKeySequence_inputLanguageSwitch=Ctrl + Shift
    if "%%i" == "4" set interface_languageKeySequence_inputLanguageSwitch=Grave accent ^(`^)
  )

  set interface_languageKeySequence_keyboardLayoutSwitch=Ctrl + Shift
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey"') do (
    if "%%i" == "3" set interface_languageKeySequence_keyboardLayoutSwitch=Not assigned
    if "%%i" == "1" set interface_languageKeySequence_keyboardLayoutSwitch=Left Alt + Shift
    if "%%i" == "4" set interface_languageKeySequence_keyboardLayoutSwitch=Grave accent ^(`^)
  )
)





if "%1" == "interface_suggestions" (
  set interface_suggestions_autoSuggest=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest') do if "%%i" == "yes" set interface_suggestions_autoSuggest=enabled

  set interface_suggestions_appendCompletion=disabled
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion"') do if "%%i" == "yes" set interface_suggestions_appendCompletion=enabled

  set interface_suggestions_startTrackProgs=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs') do if "%%i" == "0x1" set interface_suggestions_startTrackProgs=enabled
)





if "%1" == "interface_explorer" (
  set interface_explorer_fileExtensions=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt') do if "%%i" == "0x0" set interface_explorer_fileExtensions=shown

  set interface_explorer_hiddenFiles=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden') do if "%%i" == "0x1" set interface_explorer_hiddenFiles=shown

  set interface_explorer_hiddenProtectedSystemFiles=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden') do if "%%i" == "0x1" set interface_explorer_hiddenProtectedSystemFiles=shown

  set interface_explorer_emptyDrives=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideDrivesWithNoMedia') do if "%%i" == "0x0" set interface_explorer_emptyDrives=shown

  set interface_explorer_folderMergeConflicts=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideMergeConflicts') do if "%%i" == "0x0" set interface_explorer_folderMergeConflicts=shown

  set interface_explorer_ribbon=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon /v MinimizedStateTabletModeOff') do if "%%i" == "0x0" set interface_explorer_ribbon=shown

  set interface_explorer_expandToCurrentFolder=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v NavPaneExpandToCurrentFolder') do if "%%i" == "0x1" set interface_explorer_expandToCurrentFolder=enabled

  set interface_explorer_statusBar=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowStatusBar') do if "%%i" == "0x0" set interface_explorer_statusBar=hidden

  set interface_explorer_fileInfoTip=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowInfoTip') do if "%%i" == "0x0" set interface_explorer_fileInfoTip=hidden
)





if "%1" == "interface_taskBar" (
  set interface_taskBar_peopleBand=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand') do if "%%i" == "0x0" set interface_taskBar_peopleBand=hidden

  set interface_taskBar_commandPromptOnWinX=PowerShell
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX') do if "%%i" == "0x1" set interface_taskBar_commandPromptOnWinX=Command Prompt

  set interface_taskBar_taskViewButton=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton') do if "%%i" == "0x0" set interface_taskBar_taskViewButton=hidden

  set interface_taskBar_smallIcons=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons') do if "%%i" == "0x1" set interface_taskBar_smallIcons=enabled

  set interface_taskBar_buttonsCombine=always
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel') do (
    if "%%i" == "0x1" set interface_taskBar_buttonsCombine=when is full
    if "%%i" == "0x2" set interface_taskBar_buttonsCombine=never
  )
)





if "%1" == "setup_office" (
  set setup_office_setupURL=https://onedrive.live.com/download?cid=D3AF852448CB4BF6^&resid=D3AF852448CB4BF6%%21259^&authkey=AAK3Qw80R8to-VE
  set setup_office_setupISO=temp\setup_office_microsoftOfficeProfessionalPlus2016Setup.iso
)





if "%1" == "setup_gpeditMSC" (
  set setup_gpeditMSC_packagesList=temp\setup_gpeditMSC_packagesList.txt

  set setup_gpeditMSC_gpeditFile=not exist
  for /f "delims=" %%i in ('dir /a:-d /b "%winDir%\System32\gpedit.msc"') do if "%%i" == "gpedit.msc" set setup_gpeditMSC_gpeditFile=exist
)





if "%1" == "services_windowsUpdate" (
  set services_windowsUpdate_updateCenter=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\wuauserv /v Start') do if "%%i" == "0x4" set services_windowsUpdate_updateCenter=disabled
)





if "%1" == "services_sppsvc" (
  set services_sppsvc_service=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\sppsvc /v Start') do if "%%i" == "0x4" set services_sppsvc_service=disabled
)





if "%1" == "tools_administrativeTools" (
  set tools_administrativeTools_taskManager=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr') do if "%%i" == "0x1" set tools_administrativeTools_taskManager=disabled

  set tools_administrativeTools_controlPanel=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel') do if "%%i" == "0x1" set tools_administrativeTools_controlPanel=disabled

  set tools_administrativeTools_runDialog=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun') do if "%%i" == "0x1" set tools_administrativeTools_runDialog=disabled

  if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
    set tools_administrativeTools_registryTools=enabled

    set tools_administrativeTools_cmd=enabled
    for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD') do if "%%i" == "0x1" set tools_administrativeTools_cmd=disabled

    set tools_administrativeTools_desktop=enabled
    for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop') do if "%%i" == "0x1" set tools_administrativeTools_desktop=disabled
  )
)
exit /b















:logo
mode con:cols=124 lines=38
title [MikronT] Ten Tweaker
color 0b
cls
echo.
echo.
echo.    [MikronT] ==^> Ten Tweaker
echo.                  Beta v0.97
rem echo.                  Release v1.0
echo.   ===========================
echo.     See other here:
echo.         github.com/MikronT
echo.
echo.
echo.
exit /b







:errorMessage_main_variables_disabledRegistryTools
echo.    ^(^!^) Registry Tools are disabled^!
echo.        If you see [error] than this feature state cannot be shown or changed^!
if "%1" == "main_menu" (
  echo.        To fix it you must enable Registry Tools in ^(A^) menu ^(with hidden options^)^!
) else echo.        Please, back to main menu and read this error message again.
echo.
exit /b







:restart_explorer
taskkill /f /im explorer.exe >nul
timeout /nobreak /t 1 >nul
start "" "%winDir%\explorer.exe"
exit /b







:reboot_computer
call :logo
echo.^(i^) Reboot Menu
echo.
echo.
echo.^(^>^) Choose action:
echo.    ^(1^) Reboot now
echo.
echo.    ^(0^) Go back
echo.
echo.
echo.
choice /c 10 /n /m "> "
set command=%errorLevel%



if "%command%" == "2" ( set command= & exit /b )

echo.    ^(^!^) Rebooting...
shutdown /r /t 3
timeout /nobreak /t 3 >nul
exit