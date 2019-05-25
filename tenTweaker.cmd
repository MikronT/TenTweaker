@echo off
chcp 65001>nul

for /f "tokens=1-5,* delims=- " %%i in ("%*") do (
  if "%%i" NEQ "" set key_%%i
  if "%%j" NEQ "" set key_%%j
  if "%%k" NEQ "" set key_%%k
  if "%%l" NEQ "" set key_%%l
  if "%%l" NEQ "" set key_%%m
)

if "%key_main_adminRightsChecking%" == ""                set key_main_adminRightsChecking=true
if "%key_main_eula%" == ""                               set key_main_eula=true
if "%key_main_reboot%" == ""                             set key_main_reboot=none
if "%key_main_registryMerge%" == ""                      set key_main_registryMerge=true
if "%key_tools_administrativeTools_hiddenOptions%" == "" set key_tools_administrativeTools_hiddenOptions=false

setlocal EnableDelayedExpansion

if "%key_main_adminRightsChecking%" == "true" (
  net session>nul 2>nul
  if !errorLevel! GEQ 1 (
    echo.^(^^^!^) Please, run as Admin^^^!
    timeout /nobreak /t 1 >nul
  
    echo.^(^?^) Run anyway^? [Y/N]
    choice /c yn /d n /t 3 /n /m " > "
    if "!errorLevel!" NEQ "1" exit
  )
)
endlocal

%~d0
cd "%~dp0"

if not exist temp md temp

set errorLevel=
reg query HKCU >nul 2>nul

if %errorLevel% LSS 1 if "%key_main_registryMerge%" == "true" (
  reg export HKCU\Console\%%SystemRoot%%_system32_cmd.exe temp\consoleSettings.reg /y >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v CodePage         /t REG_DWORD /d 65001      /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ColorTable00     /t REG_DWORD /d 0          /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FaceName         /t REG_SZ    /d Consolas   /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontFamily       /t REG_DWORD /d 0x0000036  /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontSize         /t REG_DWORD /d 0x00100008 /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontWeight       /t REG_DWORD /d 0x0000190  /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ScreenBufferSize /t REG_DWORD /d 0x2329006a /f >nul
  reg add HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v WindowSize       /t REG_DWORD /d 0x001e006e /f >nul

  start "" cmd /c "%~dpnx0" --main_adminRightsChecking=false --main_registryMerge=false
  exit
) else if exist temp\consoleSettings.reg (
  reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /va /f >nul 2>nul
  reg import temp\consoleSettings.reg >nul 2>nul
)

set program_name=Ten Tweaker
set program_name_ns=tenTweaker

set program_version=2.1
set program_version_level1=0
set program_version_level2=0
set program_version_level3=0

for /f "tokens=1-3 delims=." %%i in ("%program_version%") do (
  if "%%i" NEQ "" set program_version_level1=%%i
  if "%%j" NEQ "" set program_version_level2=%%j
  if "%%k" NEQ "" set program_version_level3=%%k
)

set module_wget=files\wget.exe --quiet --no-check-certificate --tries=1
set module_powershell=start /wait /min powershell.exe
set appxMgmt=call :programs_system_appxPackageManagement
set stringBuilder_build=set stringBuilder_string=%%stringBuilder_string%%

set update_version_output=temp\%program_name_ns%.version
set update_version_url=https://drive.google.com/uc?export=download^^^&id=1ZeM5bnX0fWs7njKL2ZTeYc2ctv0FmGRs

set setting_eula=false
set setting_language=default
call :language_import







if exist settings.ini for /f "eol=# delims=" %%i in (settings.ini) do set setting_%%i
if "%setting_language%" NEQ "english" if "%setting_language%" NEQ "russian" if "%setting_language%" NEQ "ukrainian" call :language_menu force
call :language_import

call :logo
echo.%language_running%
echo.

if "%key_main_reboot%" == "services_sppsvc" (
  for /l %%i in (4,-1,1)  do rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 %~dp0files\tools_administrativeTools_unHookExec.inf
  for /l %%i in (4,-1,1)  do reg import files\services_sppsvc_registry.reg >nul 2>nul
  for /l %%i in (10,-1,1) do sc start sppsvc >nul 2>nul
  for /l %%i in (4,-1,1)  do reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v %program_name_ns%_services_sppsvc /f >nul 2>nul
  timeout /nobreak /t 1 >nul
  call :reboot_computer force
) else (
  %module_wget% "%update_version_url%" --output-document="%update_version_output%"

  for /f "tokens=1-3 delims=." %%l in (%update_version_output%) do (
           if "%%l" NEQ "" if %%l GTR %program_version_level1% ( set update_available=true
    ) else if "%%m" NEQ "" if %%m GTR %program_version_level2% ( set update_available=true
    ) else if "%%n" NEQ "" if %%m GTR %program_version_level3% ( set update_available=true
    )
  )

  if "%key_main_eula%" NEQ "hidden" if "%setting_eula%" NEQ "true" (
    echo.%language_eula01%
    echo.%language_eula02%
    pause>nul
    set setting_eula=true
  )
)















:main_menu
call :main_variables
call :settings_save

call :logo
echo.%language_main_menu01%
echo.%language_main_menu02%
echo.%language_main_menu03%
echo.%language_main_menu04%
echo.%language_main_menu05%
echo.%language_main_menu06%
echo.%language_main_menu07%
echo.%language_main_menu08%
echo.%language_main_menu09%
echo.%language_main_menu10%
echo.%language_main_menu11%
echo.%language_main_menu12%
echo.%language_main_menu13%
echo.%language_main_menu14%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools main_menu
if "%update_available%" == "true" (
  echo.    %language_message_update_available01%
  echo.        %language_message_update_available02% github.com/MikronT/TenTweaker/releases/latest
  echo.
)
choice /c 123456789ABCL0 /n /m "> "
set command=%errorLevel%



if "%command%" == "1" call :interface_desktopObjects
if "%command%" == "2" call :interface_languageKeySequence
if "%command%" == "3" call :interface_suggestions
if "%command%" == "4" call :interface_explorer
if "%command%" == "5" call :interface_taskBar

if "%command%" == "6" call :programs_system
if "%command%" == "7" call :programs_office
if "%command%" == "8" call :programs_gpeditMSC

if "%command%" == "9" call :services_windowsUpdate
if "%command%" == "10" call :services_sppsvc

if "%command%" == "11" call :tools_administrativeTools
if "%command%" == "12" call :tools_systemResourceChecker

if "%command%" == "13" (
  call :language_menu
  call :language_import
)

if "%command%" == "14" (
  rd /s /q temp
  exit /b
)
goto :main_menu















:interface_desktopObjects
call :main_variables interface_desktopObjects

call :logo
echo.%language_interface_desktopObjects01%
echo.
echo.
echo.%language_interface_desktopObjects02%

set stringBuilder_string=%language_interface_desktopObjects03%
if "%interface_desktopObjects_thisPC%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_desktopObjects_thisPC%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_desktopObjects04%
if "%interface_desktopObjects_userFolder%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_desktopObjects_userFolder%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_desktopObjects05%
if "%interface_desktopObjects_recycleBin%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_desktopObjects_recycleBin%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_desktopObjects06%
if "%interface_desktopObjects_network%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_desktopObjects_network%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_desktopObjects07%
if "%interface_desktopObjects_controlPanel%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_desktopObjects_controlPanel%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_interface_desktopObjects08%
echo.    %language_menuItem_restartExplorer%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 12345Y0 /n /m "> "
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
  if "%interface_languageKeySequence_inputLanguageSwitch%" NEQ "notAssigned" (
    set error_interface_languageKeySequence_twoIdenticalCombinations=1
  ) else set error_interface_languageKeySequence_twoIdenticalCombinations=0
) else set error_interface_languageKeySequence_twoIdenticalCombinations=0

call :logo
echo.%language_interface_languageKeySequence01%
echo.
echo.
echo.%language_interface_languageKeySequence02%

set stringBuilder_string=%language_interface_languageKeySequence03%
if "%interface_languageKeySequence_inputLanguageSwitch%" == "notAssigned" (
  call %stringBuilder_build% %language_stringBuilder_option_notAssigned%
) else if "%interface_languageKeySequence_inputLanguageSwitch%" == "ctrlShift" (
  call %stringBuilder_build% %language_stringBuilder_option_ctrlShift%
) else if "%interface_languageKeySequence_inputLanguageSwitch%" == "leftAltShift" (
  call %stringBuilder_build% %language_stringBuilder_option_leftAltShift%
) else if "%interface_languageKeySequence_inputLanguageSwitch%" == "graveAccent" (
  call %stringBuilder_build% %language_stringBuilder_option_graveAccent%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_languageKeySequence04%
if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "notAssigned" (
  call %stringBuilder_build% %language_stringBuilder_option_notAssigned%
) else if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "ctrlShift" (
  call %stringBuilder_build% %language_stringBuilder_option_ctrlShift%
) else if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "leftAltShift" (
  call %stringBuilder_build% %language_stringBuilder_option_leftAltShift%
) else if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "graveAccent" (
  call %stringBuilder_build% %language_stringBuilder_option_graveAccent%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
if "%error_interface_languageKeySequence_twoIdenticalCombinations%" == "1" (
  color 0c
  echo.    %language_message_error_interface_languageKeySequence_twoIdenticalCombinations%
  echo.
) else color 0b
choice /c 120 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" (
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "notAssigned" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "2" /f >nul
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "ctrlShift" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "1" /f >nul
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "leftAltShift" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "4" /f >nul
    if "%interface_languageKeySequence_inputLanguageSwitch%" == "graveAccent" reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d "3" /f >nul
  )

  if "%command%" == "2" (
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "notAssigned" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 2 /f >nul
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "ctrlShift" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 1 /f >nul
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "leftAltShift" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 4 /f >nul
    if "%interface_languageKeySequence_keyboardLayoutSwitch%" == "graveAccent" reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 3 /f >nul
  )
)

if "%command%" == "3" if "%error_interface_languageKeySequence_twoIdenticalCombinations%" NEQ "1" ( set command= & exit /b )
goto :interface_languageKeySequence















:interface_suggestions
call :main_variables interface_suggestions

call :logo
echo.%language_interface_suggestions01%
echo.
echo.
echo.%language_interface_suggestions02%

set stringBuilder_string=%language_interface_suggestions03%
if "%interface_suggestions_autoSuggest%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%interface_suggestions_autoSuggest%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_suggestions04%
if "%interface_suggestions_appendCompletion%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%interface_suggestions_appendCompletion%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_suggestions05%
if "%interface_suggestions_startTrackProgs%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%interface_suggestions_startTrackProgs%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_suggestions06%
if "%interface_suggestions_suggestionsWhenTyping%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%interface_suggestions_suggestionsWhenTyping%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 12340 /n /m "> "
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

  if "%command%" == "4" if "%interface_suggestions_suggestionsWhenTyping%" == "disabled" (
    reg add HKCU\Software\Microsoft\Input\Settings /v EnableHwkbTextPrediction /t REG_DWORD /d 1 /f >nul
  ) else reg add HKCU\Software\Microsoft\Input\Settings /v EnableHwkbTextPrediction /t REG_DWORD /d 0 /f >nul
)

if "%command%" == "5" ( set command= & exit /b )
goto :interface_suggestions















:interface_explorer
call :main_variables interface_explorer

call :logo
echo.%language_interface_explorer01%
echo.
echo.
echo.%language_interface_explorer02%

set stringBuilder_string=%language_interface_explorer03%
if "%interface_explorer_fileExtensions%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_fileExtensions%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer04%
if "%interface_explorer_ribbon%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_ribbon%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_explorer05%
if "%interface_explorer_hiddenFiles%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_hiddenFiles%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer06%
if "%interface_explorer_expandToCurrentFolder%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%interface_explorer_expandToCurrentFolder%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_explorer07%
if "%interface_explorer_hiddenProtectedSystemFiles%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_hiddenProtectedSystemFiles%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer08%
if "%interface_explorer_statusBar%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_statusBar%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_explorer09%
if "%interface_explorer_emptyDrives%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_emptyDrives%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer10%
if "%interface_explorer_fileInfoTip%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_fileInfoTip%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_explorer11%
if "%interface_explorer_folderMergeConflicts%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_folderMergeConflicts%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.%language_interface_explorer12%

set stringBuilder_string=%language_interface_explorer13%
if "%interface_explorer_thisPC_desktop%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_thisPC_desktop%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer14%
if "%interface_explorer_thisPC_pictures%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_thisPC_pictures%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_explorer15%
if "%interface_explorer_thisPC_documents%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_thisPC_documents%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer16%
if "%interface_explorer_thisPC_videos%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_thisPC_videos%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_explorer17%
if "%interface_explorer_thisPC_downloads%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_thisPC_downloads%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer18%
if "%interface_explorer_thisPC_3DObjects%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_thisPC_3DObjects%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_explorer19%
if "%interface_explorer_thisPC_music%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_thisPC_music%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_explorer20%
if "%interface_explorer_oneDriveInNavbar%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_explorer_oneDriveInNavbar%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.

set stringBuilder_string=%language_interface_explorer21%
if "%interface_explorer_autoFolderTypeDiscovery%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%interface_explorer_autoFolderTypeDiscovery%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_interface_explorer22%
echo.    %language_menuItem_restartExplorer%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 123456789ABCDEFGHIY0 /n /m "> "
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

  if "%command%" == "10" if "%interface_explorer_thisPC_desktop%" == "shown" (
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641} /f >nul
  ) else reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641} /f >nul

  if "%command%" == "11" if "%interface_explorer_thisPC_documents%" == "shown" (
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af} /f >nul
  ) else reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af} /f >nul

  if "%command%" == "12" if "%interface_explorer_thisPC_downloads%" == "shown" (
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f} /f >nul
  ) else reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f} /f >nul

  if "%command%" == "13" if "%interface_explorer_thisPC_music%" == "shown" (
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} /f >nul
  ) else reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} /f >nul

  if "%command%" == "14" if "%interface_explorer_thisPC_pictures%" == "shown" (
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8} /f >nul
  ) else reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8} /f >nul

  if "%command%" == "15" if "%interface_explorer_thisPC_videos%" == "shown" (
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} /f >nul
  ) else reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} /f >nul

  if "%command%" == "16" if "%interface_explorer_thisPC_3DObjects%" == "shown" (
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A} /f >nul
  ) else reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A} /f >nul

  if "%command%" == "17" if "%interface_explorer_oneDriveInNavbar%" == "shown" (
    reg add HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul

  if "%command%" == "18" if "%interface_explorer_autoFolderTypeDiscovery%" == "enabled" (
    reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_SZ /d NotSpecified /f >nul
  ) else reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /f >nul
)

if "%command%" == "19" call :restart_explorer
if "%command%" == "20" ( set command= & exit /b )
goto :interface_explorer















:interface_taskBar
call :main_variables interface_taskBar

call :logo
echo.%language_interface_taskBar01%
echo.
echo.
echo.%language_interface_taskBar02%

set stringBuilder_string=%language_interface_taskBar03%
if "%interface_taskBar_peopleBand%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_taskBar_peopleBand%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_taskBar04%
if "%interface_taskBar_smallIcons%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%interface_taskBar_smallIcons%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_taskBar05%
if "%interface_taskBar_commandPromptOnWinX%" == "powerShell" (
  call %stringBuilder_build% %language_stringBuilder_option_powerShell%
) else if "%interface_taskBar_commandPromptOnWinX%" == "commandPrompt" (
  call %stringBuilder_build% %language_stringBuilder_option_commandPrompt%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_interface_taskBar06%
if "%interface_taskBar_buttonsCombine%" == "always" (
  call %stringBuilder_build% %language_stringBuilder_option_always%
) else if "%interface_taskBar_buttonsCombine%" == "when is full" (
  call %stringBuilder_build% %language_stringBuilder_option_whenIsFull%
) else if "%interface_taskBar_buttonsCombine%" == "never" (
  call %stringBuilder_build% %language_stringBuilder_option_never%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_interface_taskBar07%
if "%interface_taskBar_taskViewButton%" == "shown" (
  call %stringBuilder_build% %language_stringBuilder_option_shown%
) else if "%interface_taskBar_taskViewButton%" == "hidden" (
  call %stringBuilder_build% %language_stringBuilder_option_hidden%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_interface_taskBar08%
echo.    %language_menuItem_restartExplorer%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 12345Y0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" if "%interface_taskBar_peopleBand%" == "shown" (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand /t REG_DWORD /d 0 /f >nul
  ) else reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand /t REG_DWORD /d 1 /f >nul

  if "%command%" == "2" if "%interface_taskBar_commandPromptOnWinX%" == "powerShell" (
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















:programs_system
call :main_variables programs_system

call :logo
echo.%language_programs_system01%
echo.
echo.
echo.%language_programs_system02%

set stringBuilder_string=%language_programs_system03%
if "%programs_system_program_3DViewer%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_3DViewer%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system04%
if "%programs_system_program_alarmsClock%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_alarmsClock%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system05%
if "%programs_system_program_feedbackHub%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_feedbackHub%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system06%
if "%programs_system_program_camera%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_camera%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system07%
if "%programs_system_program_getHelp%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_getHelp%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system08%
if "%programs_system_program_gameBar%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_gameBar%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system09%
if "%programs_system_program_mailCalendar%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_mailCalendar%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system10%
if "%programs_system_program_grooveMusic%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_grooveMusic%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system11%
if "%programs_system_program_maps%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_maps%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system12%
if "%programs_system_program_moviesTV%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_moviesTV%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system13%
if "%programs_system_program_messaging%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_messaging%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system14%
if "%programs_system_program_myOffice%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_myOffice%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system15%
if "%programs_system_program_mobilePlans%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_mobilePlans%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system16%
if "%programs_system_program_paint3D%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_paint3D%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system17%
if "%programs_system_program_oneNote%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_oneNote%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system18%
if "%programs_system_program_photos%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_photos%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system19%
if "%programs_system_program_print3D%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_print3D%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system20%
if "%programs_system_program_skype%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_skype%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system21%
if "%programs_system_program_solitare%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_solitare%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system22%
if "%programs_system_program_snipSketch%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_snipSketch%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system23%
if "%programs_system_program_tips%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_tips%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system24%
if "%programs_system_program_stickyNotes%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_stickyNotes%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_programs_system25%
if "%programs_system_program_yourPhone%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_yourPhone%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
call %stringBuilder_build%    %language_programs_system26%
if "%programs_system_program_store%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_store%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=                                                             %language_programs_system28%
if "%programs_system_program_voiceRecorder%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_voiceRecorder%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=                                                             %language_programs_system30%
if "%programs_system_program_weather%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_weather%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=                                                             %language_programs_system32%
if "%programs_system_program_xbox%" == "installed" (
  call %stringBuilder_build% %language_stringBuilder_option_installed%
) else if "%programs_system_program_xbox%" == "uninstalled" (
  call %stringBuilder_build% %language_stringBuilder_option_uninstalled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_programs_system33%
echo.    %language_programs_system34%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 123456789ABCDEFGHIJKLMNOPQRST0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" if "%programs_system_program_3DViewer%" == "installed" (
    %appxMgmt% remove Microsoft3DViewer
  ) else %appxMgmt% add Microsoft3DViewer

  if "%command%" == "2" if "%programs_system_program_feedbackHub%" == "installed" (
    %appxMgmt% remove WindowsFeedbackHub
  ) else %appxMgmt% add WindowsFeedbackHub

  if "%command%" == "3" if "%programs_system_program_getHelp%" == "installed" (
    %appxMgmt% remove GetHelp
  ) else %appxMgmt% add GetHelp

  if "%command%" == "4" if "%programs_system_program_mailCalendar%" == "installed" (
    %appxMgmt% remove WindowsCommunicationsApps
  ) else %appxMgmt% add WindowsCommunicationsApps

  if "%command%" == "5" if "%programs_system_program_maps%" == "installed" (
    %appxMgmt% remove WindowsMaps
  ) else %appxMgmt% add WindowsMaps

  if "%command%" == "6" if "%programs_system_program_messaging%" == "installed" (
    %appxMgmt% remove Messaging
  ) else %appxMgmt% add Messaging

  if "%command%" == "7" if "%programs_system_program_mobilePlans%" == "installed" (
    %appxMgmt% remove OneConnect
  ) else %appxMgmt% add OneConnect

  if "%command%" == "8" if "%programs_system_program_oneNote%" == "installed" (
    %appxMgmt% remove Office.OneNote
  ) else %appxMgmt% add Office.OneNote

  if "%command%" == "9" if "%programs_system_program_print3D%" == "installed" (
    %appxMgmt% remove Print3D
  ) else %appxMgmt% add Print3D

  if "%command%" == "10" if "%programs_system_program_solitare%" == "installed" (
    %appxMgmt% remove MicrosoftSolitaireCollection
  ) else %appxMgmt% add MicrosoftSolitaireCollection

  if "%command%" == "11" if "%programs_system_program_tips%" == "installed" (
    %appxMgmt% remove GetStarted
  ) else %appxMgmt% add GetStarted

  if "%command%" == "12" if "%programs_system_program_yourPhone%" == "installed" (
    %appxMgmt% remove YourPhone
  ) else %appxMgmt% add YourPhone


  if "%command%" == "13" if "%programs_system_program_alarmsClock%" == "installed" (
    %appxMgmt% remove WindowsAlarms
  ) else %appxMgmt% add WindowsAlarms

  if "%command%" == "14" if "%programs_system_program_camera%" == "installed" (
    %appxMgmt% remove WindowsCamera
  ) else %appxMgmt% add WindowsCamera

  if "%command%" == "15" if "%programs_system_program_gameBar%" == "installed" (
    %appxMgmt% remove XboxGameOverlay
    %appxMgmt% remove XboxGamingOverlay
  ) else (
    %appxMgmt% add XboxGameOverlay
    %appxMgmt% add XboxGamingOverlay
  )

  if "%command%" == "16" if "%programs_system_program_grooveMusic%" == "installed" (
    %appxMgmt% remove ZuneMusic
  ) else %appxMgmt% add ZuneMusic

  if "%command%" == "17" if "%programs_system_program_moviesTV%" == "installed" (
    %appxMgmt% remove ZuneVideo
  ) else %appxMgmt% add ZuneVideo

  if "%command%" == "18" if "%programs_system_program_myOffice%" == "installed" (
    %appxMgmt% remove MicrosoftOfficeHub
  ) else %appxMgmt% add MicrosoftOfficeHub

  if "%command%" == "19" if "%programs_system_program_paint3D%" == "installed" (
    %appxMgmt% remove MSPaint
  ) else %appxMgmt% add MSPaint

  if "%command%" == "20" if "%programs_system_program_photos%" == "installed" (
    %appxMgmt% remove Windows.Photos
  ) else %appxMgmt% add Windows.Photos

  if "%command%" == "21" if "%programs_system_program_skype%" == "installed" (
    %appxMgmt% remove SkypeApp
  ) else %appxMgmt% add SkypeApp

  if "%command%" == "22" if "%programs_system_program_snipSketch%" == "installed" (
    %appxMgmt% remove ScreenSketch
  ) else %appxMgmt% add ScreenSketch

  if "%command%" == "23" if "%programs_system_program_stickyNotes%" == "installed" (
    %appxMgmt% remove MicrosoftStickyNotes
  ) else %appxMgmt% add MicrosoftStickyNotes

  if "%command%" == "24" if "%programs_system_program_store%" == "installed" (
    %appxMgmt% remove WindowsStore
  ) else %appxMgmt% add WindowsStore

  if "%command%" == "25" if "%programs_system_program_voiceRecorder%" == "installed" (
    %appxMgmt% remove WindowsSoundRecorder
  ) else %appxMgmt% add WindowsSoundRecorder

  if "%command%" == "26" if "%programs_system_program_weather%" == "installed" (
    %appxMgmt% remove BingWeather
  ) else %appxMgmt% add BingWeather

  if "%command%" == "27" if "%programs_system_program_xbox%" == "installed" (
    %appxMgmt% remove XboxApp
  ) else %appxMgmt% add XboxApp

  if "%command%" == "28" (
    if "%programs_system_program_3DViewer%"      == "uninstalled" %appxMgmt% add Microsoft3DViewer
    if "%programs_system_program_feedbackHub%"   == "uninstalled" %appxMgmt% add WindowsFeedbackHub
    if "%programs_system_program_getHelp%"       == "uninstalled" %appxMgmt% add GetHelp
    if "%programs_system_program_mailCalendar%"  == "uninstalled" %appxMgmt% add WindowsCommunicationsApps
    if "%programs_system_program_maps%"          == "uninstalled" %appxMgmt% add WindowsMaps
    if "%programs_system_program_messaging%"     == "uninstalled" %appxMgmt% add Messaging
    if "%programs_system_program_mobilePlans%"   == "uninstalled" %appxMgmt% add OneConnect
    if "%programs_system_program_oneNote%"       == "uninstalled" %appxMgmt% add Office.OneNote
    if "%programs_system_program_print3D%"       == "uninstalled" %appxMgmt% add Print3D
    if "%programs_system_program_solitare%"      == "uninstalled" %appxMgmt% add MicrosoftSolitaireCollection
    if "%programs_system_program_tips%"          == "uninstalled" %appxMgmt% add GetStarted
    if "%programs_system_program_yourPhone%"     == "uninstalled" %appxMgmt% add YourPhone

    if "%programs_system_program_alarmsClock%"   == "uninstalled" %appxMgmt% add WindowsAlarms
    if "%programs_system_program_camera%"        == "uninstalled" %appxMgmt% add WindowsCamera
    if "%programs_system_program_gameBar%"       == "uninstalled" (
      %appxMgmt% add XboxGameOverlay
      %appxMgmt% add XboxGamingOverlay
    )
    if "%programs_system_program_grooveMusic%"   == "uninstalled" %appxMgmt% add ZuneMusic
    if "%programs_system_program_moviesTV%"      == "uninstalled" %appxMgmt% add ZuneVideo
    if "%programs_system_program_myOffice%"      == "uninstalled" %appxMgmt% add MicrosoftOfficeHub
    if "%programs_system_program_paint3D%"       == "uninstalled" %appxMgmt% add MSPaint
    if "%programs_system_program_photos%"        == "uninstalled" %appxMgmt% add Windows.Photos
    if "%programs_system_program_skype%"         == "uninstalled" %appxMgmt% add SkypeApp
    if "%programs_system_program_snipSketch%"    == "uninstalled" %appxMgmt% add ScreenSketch
    if "%programs_system_program_stickyNotes%"   == "uninstalled" %appxMgmt% add MicrosoftStickyNotes
    if "%programs_system_program_store%"         == "uninstalled" %appxMgmt% add WindowsStore
    if "%programs_system_program_voiceRecorder%" == "uninstalled" %appxMgmt% add WindowsSoundRecorder
    if "%programs_system_program_weather%"       == "uninstalled" %appxMgmt% add BingWeather
    if "%programs_system_program_xbox%"          == "uninstalled" %appxMgmt% add XboxApp
  )

  if "%command%" == "29" (
    if "%programs_system_program_3DViewer%"      == "installed" %appxMgmt% remove Microsoft3DViewer
    if "%programs_system_program_feedbackHub%"   == "installed" %appxMgmt% remove WindowsFeedbackHub
    if "%programs_system_program_getHelp%"       == "installed" %appxMgmt% remove GetHelp
    if "%programs_system_program_mailCalendar%"  == "installed" %appxMgmt% remove WindowsCommunicationsApps
    if "%programs_system_program_maps%"          == "installed" %appxMgmt% remove WindowsMaps
    if "%programs_system_program_messaging%"     == "installed" %appxMgmt% remove Messaging
    if "%programs_system_program_mobilePlans%"   == "installed" %appxMgmt% remove OneConnect
    if "%programs_system_program_oneNote%"       == "installed" %appxMgmt% remove Office.OneNote
    if "%programs_system_program_print3D%"       == "installed" %appxMgmt% remove Print3D
    if "%programs_system_program_solitare%"      == "installed" %appxMgmt% remove MicrosoftSolitaireCollection
    if "%programs_system_program_tips%"          == "installed" %appxMgmt% remove GetStarted
    if "%programs_system_program_yourPhone%"     == "installed" %appxMgmt% remove YourPhone

    if "%programs_system_program_alarmsClock%"   == "installed" %appxMgmt% remove WindowsAlarms
    if "%programs_system_program_camera%"        == "installed" %appxMgmt% remove WindowsCamera
    if "%programs_system_program_gameBar%"       == "installed" (
      %appxMgmt% remove XboxGameOverlay
      %appxMgmt% remove XboxGamingOverlay
    )
    if "%programs_system_program_grooveMusic%"   == "installed" %appxMgmt% remove ZuneMusic
    if "%programs_system_program_moviesTV%"      == "installed" %appxMgmt% remove ZuneVideo
    if "%programs_system_program_myOffice%"      == "installed" %appxMgmt% remove MicrosoftOfficeHub
    if "%programs_system_program_paint3D%"       == "installed" %appxMgmt% remove MSPaint
    if "%programs_system_program_photos%"        == "installed" %appxMgmt% remove Windows.Photos
    if "%programs_system_program_skype%"         == "installed" %appxMgmt% remove SkypeApp
    if "%programs_system_program_snipSketch%"    == "installed" %appxMgmt% remove ScreenSketch
    if "%programs_system_program_stickyNotes%"   == "installed" %appxMgmt% remove MicrosoftStickyNotes
    if "%programs_system_program_store%"         == "installed" %appxMgmt% remove WindowsStore
    if "%programs_system_program_voiceRecorder%" == "installed" %appxMgmt% remove WindowsSoundRecorder
    if "%programs_system_program_weather%"       == "installed" %appxMgmt% remove BingWeather
    if "%programs_system_program_xbox%"          == "installed" %appxMgmt% remove XboxApp
  )
)

if "%command%" == "30" ( set command= & exit /b )
goto :programs_system















:programs_system_appxPackageManagement
if "%1" == "get"    %module_powershell% "Get-AppxPackage *Microsoft.* | Select Name | Out-File -FilePath """%~dp0temp\return_appxPackages""" -Encoding ASCII"
if "%1" == "check"  for /f "eol=- delims=" %%i in ('find /i "%2" "%~dp0temp\return_appxPackages"') do if "%%i" NEQ "" set %3=installed
if "%1" == "add"    %module_powershell% "Add-AppxPackage -Path ((Get-AppxPackage -AllUsers -Name """*Microsoft.%2*""").InstallLocation + """\AppxManifest.xml""") -Register -DisableDevelopmentMode"
if "%1" == "remove" %module_powershell% "Get-AppxPackage *Microsoft.%2* | Remove-AppxPackage"
exit /b















:programs_office
call :main_variables programs_office

call :logo
echo.%language_programs_office01%
echo.
echo.
echo.%language_programs_office02%
echo.    %language_programs_office03%
echo.
echo.    %language_programs_office04%
echo.    %language_menuItem_rebootComputer%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
if "%error_programs_office_download%" == "1" (
  color 0c
  echo.    %language_message_error_programs_office_download%
  echo.
  set error_programs_office_download=0
) else color 0b
choice /c 1Z0 /n /m "> "
set command=%errorLevel%



:programs_office_setup
if "%error_main_variables_disabledRegistryTools%" NEQ "1" if "%command%" == "1" (
  call :logo
  echo.%language_programs_office01%
  echo.
  echo.

  if exist "%programs_office_setupISO%" del /q "%programs_office_setupISO%"

  echo.%language_programs_office05%
  %module_wget% --show-progress --progress=bar:force:noscroll "%programs_office_setupURL%" --output-document="%programs_office_setupISO%"
  timeout /nobreak /t 1 >nul

  for /f "skip=6 tokens=1,3,* delims= " %%i in ('dir "%~dp0%programs_office_setupISO%"') do if "%%i" == "1" if "%%j" == "0" (
    set error_programs_office_download=1
    goto :programs_office
  )

  echo.%language_programs_office06%
  %module_powershell% "Mount-DiskImage ""%~dp0%programs_office_setupISO%"""
  timeout /nobreak /t 1 >nul

  echo.%language_programs_office07%
  %module_powershell% "Get-DiskImage """%~dp0%programs_office_setupISO%""" | Get-Volume | Select-Object {$_.DriveLetter} | Out-File -FilePath """%~dp0temp\return_diskImage""" -Encoding ASCII"
  for /f "skip=3 delims= " %%i in (temp\return_diskImage) do start /wait %%i:\O16Setup.exe
  timeout /nobreak /t 1 >nul

  echo.%language_programs_office08%
  %module_powershell% "Dismount-DiskImage ""%~dp0%programs_office_setupISO%"""
  timeout /nobreak /t 1 >nul
)

if "%command%" == "2" call :reboot_computer
if "%command%" == "3" ( set command= & exit /b )
goto :programs_office















:programs_gpeditMSC
call :main_variables programs_gpeditMSC

call :logo
echo.%language_programs_gpeditMSC01%
echo.
echo.
echo.%language_programs_gpeditMSC02%

set stringBuilder_string=%language_programs_gpeditMSC03%
if "%programs_gpeditMSC_gpeditFile%" == "exist" (
  call %stringBuilder_build% %language_stringBuilder_option_exist%
) else if "%programs_gpeditMSC_gpeditFile%" == "notExist" (
  call %stringBuilder_build% %language_stringBuilder_option_notExist%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 10 /n /m "> "
set command=%errorLevel%



if "%command%" == "2" ( set command= & exit /b )

if "%error_main_variables_disabledRegistryTools%" == "1" goto :programs_gpeditMSC

dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >%programs_gpeditMSC_packagesList%
dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>%programs_gpeditMSC_packagesList%
for /f %%i in ('findstr /i . %programs_gpeditMSC_packagesList% 2^>nul') do dism /online /norestart /add-package:"%systemRoot%\servicing\Packages\%%i"
goto :programs_gpeditMSC















:services_windowsUpdate
call :main_variables services_windowsUpdate

call :logo
echo.%language_services_windowsUpdate01%
echo.
echo.
echo.%language_services_windowsUpdate02%

set stringBuilder_string=%language_services_windowsUpdate03%
if "%services_windowsUpdate_updateDistributions%" == "locked" (
  call %stringBuilder_build% %language_stringBuilder_option_locked%
) else if "%services_windowsUpdate_updateDistributions%" == "unlocked" (
  call %stringBuilder_build% %language_stringBuilder_option_unlocked%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_services_windowsUpdate04%
if "%services_windowsUpdate_updateCenter%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%services_windowsUpdate_updateCenter%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 120 /n /m "> "
set command=%errorLevel%



if "%command%" == "1" if "%services_windowsUpdate_updateDistributions%" == "unlocked" (
  for /l %%i in (4,-1,1) do if exist "%WinDir%\SoftwareDistribution\Download" rd /s /q "%WinDir%\SoftwareDistribution\Download"
  echo.>"%WinDir%\SoftwareDistribution\Download"
) else (
  del /q "%WinDir%\SoftwareDistribution\Download"
  md "%WinDir%\SoftwareDistribution\Download"
)

if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "2" if "%services_windowsUpdate_updateCenter%" == "enabled" (
    for /l %%i in (4,-1,1) do sc stop wuauserv >nul 2>nul
    for /l %%i in (4,-1,1) do sc config wuauserv start=disabled >nul 2>nul
  ) else (
    for /l %%i in (4,-1,1) do sc config wuauserv start=auto >nul 2>nul
    for /l %%i in (4,-1,1) do sc start wuauserv >nul 2>nul
  )
)

if "%command%" == "3" ( set command= & exit /b )
goto :services_windowsUpdate















:services_sppsvc
call :main_variables services_sppsvc

call :logo
echo.%language_services_sppsvc01%
echo.
echo.
echo.%language_services_sppsvc02%

set stringBuilder_string=%language_services_sppsvc03%
if "%services_sppsvc_service%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%services_sppsvc_service%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_services_sppsvc04%
echo.    %language_services_sppsvc05%
echo.    %language_menuItem_rebootComputer%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
choice /c 1Z0 /n /m "> "
set command=%errorLevel%



if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
  if "%command%" == "1" (
    for /l %%i in (4,-1,1) do reg import files\services_sppsvc_registry.reg >nul 2>nul
    for /l %%i in (10,-1,1) do sc start sppsvc >nul 2>nul
  )

  if "%command%" == "2" (
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v %program_name_ns%_services_sppsvc /t REG_SZ /d "%~dpnx0 --key_main_reboot=services_sppsvc" /f >nul
    call :reboot_computer
  )
)

if "%command%" == "3" ( set command= & exit /b )
goto :services_sppsvc















:tools_administrativeTools
call :main_variables tools_administrativeTools
if "%error_main_variables_disabledRegistryTools%" == "1" set key_tools_administrativeTools_hiddenOptions=enabled

call :logo
echo.%language_tools_administrativeTools01%
echo.
echo.
echo.%language_tools_administrativeTools02%

set stringBuilder_string=%language_tools_administrativeTools03%
if "%tools_administrativeTools_desktop%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%tools_administrativeTools_desktop%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  call %stringBuilder_build%    %language_tools_administrativeTools04%
  if "%tools_administrativeTools_registryTools%" == "enabled" (
    call %stringBuilder_build% %language_stringBuilder_option_enabled%
  ) else if "%tools_administrativeTools_registryTools%" == "disabled" (
    call %stringBuilder_build% %language_stringBuilder_option_disabled%
  ) else call %stringBuilder_build% %language_stringBuilder_option_error%
)
echo.    %stringBuilder_string%

set stringBuilder_string=%language_tools_administrativeTools05%
if "%tools_administrativeTools_controlPanel%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%tools_administrativeTools_controlPanel%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  call %stringBuilder_build%    %language_tools_administrativeTools06%
  if "%tools_administrativeTools_cmd%" == "enabled" (
    call %stringBuilder_build% %language_stringBuilder_option_enabled%
  ) else if "%tools_administrativeTools_cmd%" == "disabled" (
    call %stringBuilder_build% %language_stringBuilder_option_disabled%
  ) else call %stringBuilder_build% %language_stringBuilder_option_error%
)
echo.    %stringBuilder_string%

set stringBuilder_string=%language_tools_administrativeTools07%
if "%tools_administrativeTools_runDialog%" == "enabled" (
  call %stringBuilder_build% %language_stringBuilder_option_enabled%
) else if "%tools_administrativeTools_runDialog%" == "disabled" (
  call %stringBuilder_build% %language_stringBuilder_option_disabled%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  call %stringBuilder_build%    %language_tools_administrativeTools08%
  if "%tools_administrativeTools_taskManager%" == "enabled" (
    call %stringBuilder_build% %language_stringBuilder_option_enabled%
  ) else if "%tools_administrativeTools_taskManager%" == "disabled" (
    call %stringBuilder_build% %language_stringBuilder_option_disabled%
  ) else call %stringBuilder_build% %language_stringBuilder_option_error%
)
echo.    %stringBuilder_string%

echo.
echo.    %language_tools_administrativeTools09%
echo.    %language_menuItem_updateGroupPolicy%
echo.
echo.    %language_tools_administrativeTools10%
echo.    %language_menuItem_restartExplorer%
echo.
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  echo.    %language_tools_administrativeTools11%
  echo.    %language_menuItem_rebootComputer%
  echo.
)
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
  echo.    %language_message_tools_administrativeTools_hiddenOptions%
  echo.
  choice /c 123456XYZ0 /n /m "> "
) else choice /c 123XY0 /n /m "> "
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
    for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul
  ) else for /l %%i in (4,-1,1) do rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 %~dp0files\tools_administrativeTools_unHookExec.inf

  if "%error_main_variables_disabledRegistryTools%" NEQ "1" (
    if "%command%" == "5" if "%tools_administrativeTools_cmd%" == "enabled" (
      for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD /t REG_DWORD /d 1 /f >nul
    ) else for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD /t REG_DWORD /d 0 /f >nul

    if "%command%" == "6" if "%tools_administrativeTools_taskManager%" == "enabled" (
      for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul
    ) else for /l %%i in (4,-1,1) do reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 0 /f >nul
  )

  if "%command%" == "7" gpupdate /force >nul
  if "%command%" == "8" call :restart_explorer
  if "%command%" == "9" call :reboot_computer
  if "%command%" == "10" ( set command= & exit /b )
) else (
  if "%command%" == "4" gpupdate /force >nul
  if "%command%" == "5" call :restart_explorer
  if "%command%" == "6" ( set command= & exit /b )
)
goto :tools_administrativeTools















:tools_systemResourceChecker
call :logo
echo.%language_tools_systemResourceChecker01%
echo.
echo.
echo.%language_tools_systemResourceChecker02%
echo.    %language_tools_systemResourceChecker03%
echo.
echo.    %language_tools_systemResourceChecker04%
echo.    %language_menuItem_rebootComputer%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
choice /c 1Z0 /n /m "> "
set command=%errorLevel%



if "%command%" == "1" for /l %%i in (3,-1,1) do sfc /scannow
if "%command%" == "2" call :reboot_computer
if "%command%" == "3" ( set command= & exit /b )
goto :tools_systemResourceChecker















:language_menu
call :logo
echo.%language_language_menu01%
echo.
echo.
echo.%language_language_menu02%
echo.    ^(1^) English
echo.    ^(2^) Русский
echo.    ^(3^) Українська
if "%1" NEQ "force" (
  echo.
  echo.    %language_menuItem_goBack%
)
echo.
echo.
echo.
if "%1" NEQ "force" (
  choice /c 1230 /n /m "> "
) else choice /c 123 /n /m "> "
set command=%errorLevel%



if "%command%" == "1" set setting_language=english
if "%command%" == "2" set setting_language=russian
if "%command%" == "3" set setting_language=ukrainian
exit /b















:template
call :main_variables template

call :logo
echo.%language_template01%
echo.
echo.
echo.%language_template02%

set stringBuilder_string=%language_template03%
if "%option%" == "state1" (
  call %stringBuilder_build% %language_stringBuilder_option_state1%
) else if "%option%" == "state2" (
  call %stringBuilder_build% %language_stringBuilder_option_state2%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_template04%
if "%option%" == "state1" (
  call %stringBuilder_build% %language_stringBuilder_option_state1%
) else if "%option%" == "state2" (
  call %stringBuilder_build% %language_stringBuilder_option_state2%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

set stringBuilder_string=%language_template05%
if "%option%" == "state1" (
  call %stringBuilder_build% %language_stringBuilder_option_state1%
) else if "%option%" == "state2" (
  call %stringBuilder_build% %language_stringBuilder_option_state2%
) else call %stringBuilder_build% %language_stringBuilder_option_error%
echo.    %stringBuilder_string%

echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
if "%error_main_variables_disabledRegistryTools%" == "1" call :message_error_main_variables_disabledRegistryTools
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
reg query HKCU >nul 2>nul

if %errorLevel% GEQ 1 (
  set interface_desktopObjects_thisPC=error
  set interface_desktopObjects_recycleBin=error
  set interface_desktopObjects_controlPanel=error
  set interface_desktopObjects_userFolder=error
  set interface_desktopObjects_network=error

  set interface_languageKeySequence_inputLanguageSwitch=error
  set interface_languageKeySequence_keyboardLayoutSwitch=error

  set interface_suggestions_autoSuggest=error
  set interface_suggestions_appendCompletion=error
  set interface_suggestions_startTrackProgs=error
  set interface_suggestions_suggestionsWhenTyping=error

  set interface_explorer_fileExtensions=error
  set interface_explorer_hiddenFiles=error
  set interface_explorer_hiddenProtectedSystemFiles=error
  set interface_explorer_emptyDrives=error
  set interface_explorer_folderMergeConflicts=error
  set interface_explorer_ribbon=error
  set interface_explorer_expandToCurrentFolder=error
  set interface_explorer_statusBar=error
  set interface_explorer_fileInfoTip=error
  set interface_explorer_thisPC_desktop=error
  set interface_explorer_thisPC_documents=error
  set interface_explorer_thisPC_downloads=error
  set interface_explorer_thisPC_music=error
  set interface_explorer_thisPC_pictures=error
  set interface_explorer_thisPC_videos=error
  set interface_explorer_thisPC_3DObjects=error
  set interface_explorer_oneDriveInNavbar=error
  set interface_explorer_autoFolderTypeDiscovery=error

  set interface_taskBar_peopleBand=error
  set interface_taskBar_commandPromptOnWinX=error
  set interface_taskBar_taskViewButton=error
  set interface_taskBar_smallIcons=error
  set interface_taskBar_buttonsCombine=error

  set services_windowsUpdate_updateCenter=error

  set services_sppsvc_service=error

  set tools_administrativeTools_taskManager=error
  set tools_administrativeTools_controlPanel=error
  set tools_administrativeTools_runDialog=error
  set tools_administrativeTools_registryTools=disabled
  set tools_administrativeTools_cmd=error
  set tools_administrativeTools_desktop=error

  set error_main_variables_disabledRegistryTools=1
  exit /b
) else set error_main_variables_disabledRegistryTools=0





if "%1" == "interface_desktopObjects" (
  set interface_desktopObjects_thisPC=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D}') do if "%%i" == "0x0" set interface_desktopObjects_thisPC=shown)>nul 2>nul

  set interface_desktopObjects_recycleBin=shown
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E}') do if "%%i" == "0x1" set interface_desktopObjects_recycleBin=hidden)>nul 2>nul

  set interface_desktopObjects_controlPanel=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}') do if "%%i" == "0x0" set interface_desktopObjects_controlPanel=shown)>nul 2>nul

  set interface_desktopObjects_userFolder=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee}') do if "%%i" == "0x0" set interface_desktopObjects_userFolder=shown)>nul 2>nul

  set interface_desktopObjects_network=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C}') do if "%%i" == "0x0" set interface_desktopObjects_network=shown)>nul 2>nul
)





if "%1" == "interface_languageKeySequence" (
  set interface_languageKeySequence_inputLanguageSwitch=leftAltShift
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey"') do (
    if "%%i" == "3" set interface_languageKeySequence_inputLanguageSwitch=notAssigned
    if "%%i" == "2" set interface_languageKeySequence_inputLanguageSwitch=ctrlShift
    if "%%i" == "4" set interface_languageKeySequence_inputLanguageSwitch=graveAccent
  )

  set interface_languageKeySequence_keyboardLayoutSwitch=ctrlShift
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey"') do (
    if "%%i" == "3" set interface_languageKeySequence_keyboardLayoutSwitch=notAssigned
    if "%%i" == "1" set interface_languageKeySequence_keyboardLayoutSwitch=leftAltShift
    if "%%i" == "4" set interface_languageKeySequence_keyboardLayoutSwitch=graveAccent
  )
)





if "%1" == "interface_suggestions" (
  set interface_suggestions_autoSuggest=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest') do if "%%i" == "yes" set interface_suggestions_autoSuggest=enabled

  set interface_suggestions_appendCompletion=disabled
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion"') do if "%%i" == "yes" set interface_suggestions_appendCompletion=enabled

  set interface_suggestions_startTrackProgs=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs') do if "%%i" == "0x1" set interface_suggestions_startTrackProgs=enabled

  set interface_suggestions_suggestionsWhenTyping=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Input\Settings /v EnableHwkbTextPrediction') do if "%%i" == "0x1" set interface_suggestions_suggestionsWhenTyping=enabled
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

  set interface_explorer_thisPC_desktop=shown
  for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"') do if "%%i" == "0" set interface_explorer_thisPC_desktop=hidden

  set interface_explorer_thisPC_documents=shown
  for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{d3162b92-9365-467a-956b-92703aca08af}"') do if "%%i" == "0" set interface_explorer_thisPC_documents=hidden

  set interface_explorer_thisPC_downloads=shown
  for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{088e3905-0323-4b02-9826-5d99428e115f}"') do if "%%i" == "0" set interface_explorer_thisPC_downloads=hidden

  set interface_explorer_thisPC_music=shown
  for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"') do if "%%i" == "0" set interface_explorer_thisPC_music=hidden

  set interface_explorer_thisPC_pictures=shown
  for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"') do if "%%i" == "0" set interface_explorer_thisPC_pictures=hidden

  set interface_explorer_thisPC_videos=shown
  for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"') do if "%%i" == "0" set interface_explorer_thisPC_videos=hidden

  set interface_explorer_thisPC_3DObjects=shown
  for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"') do if "%%i" == "0" set interface_explorer_thisPC_3DObjects=hidden

  set interface_explorer_oneDriveInNavbar=shown
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree') do if "%%i" == "0x0" set interface_explorer_oneDriveInNavbar=hidden)>nul 2>nul

  set interface_explorer_autoFolderTypeDiscovery=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType') do if "%%i" == "NotSpecified" set interface_explorer_autoFolderTypeDiscovery=disabled)>nul 2>nul
)





if "%1" == "interface_taskBar" (
  set interface_taskBar_peopleBand=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand') do if "%%i" == "0x0" set interface_taskBar_peopleBand=hidden

  set interface_taskBar_commandPromptOnWinX=powerShell
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX') do if "%%i" == "0x1" set interface_taskBar_commandPromptOnWinX=commandPrompt

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





if "%1" == "programs_system" (
  %appxMgmt% get

  set programs_system_program_3DViewer=uninstalled
  %appxMgmt% check Microsoft3DViewer programs_system_program_3DViewer

  set programs_system_program_feedbackHub=uninstalled
  %appxMgmt% check WindowsFeedbackHub programs_system_program_feedbackHub

  set programs_system_program_getHelp=uninstalled
  %appxMgmt% check GetHelp programs_system_program_getHelp

  set programs_system_program_mailCalendar=uninstalled
  %appxMgmt% check WindowsCommunicationsApps programs_system_program_mailCalendar

  set programs_system_program_maps=uninstalled
  %appxMgmt% check WindowsMaps programs_system_program_maps

  set programs_system_program_messaging=uninstalled
  %appxMgmt% check Messaging programs_system_program_messaging

  set programs_system_program_mobilePlans=uninstalled
  %appxMgmt% check OneConnect programs_system_program_mobilePlans

  set programs_system_program_oneNote=uninstalled
  %appxMgmt% check Office.OneNote programs_system_program_oneNote

  set programs_system_program_print3D=uninstalled
  %appxMgmt% check Print3D programs_system_program_print3D

  set programs_system_program_solitare=uninstalled
  %appxMgmt% check MicrosoftSolitaireCollection programs_system_program_solitare

  set programs_system_program_tips=uninstalled
  %appxMgmt% check GetStarted programs_system_program_tips

  set programs_system_program_yourPhone=uninstalled
  %appxMgmt% check YourPhone programs_system_program_yourPhone


  set programs_system_program_alarmsClock=uninstalled
  %appxMgmt% check WindowsAlarms programs_system_program_alarmsClock

  set programs_system_program_camera=uninstalled
  %appxMgmt% check WindowsCamera programs_system_program_camera

  set programs_system_program_gameBar=uninstalled
  set programs_system_program_gameBar1=uninstalled
  set programs_system_program_gameBar2=uninstalled
  %appxMgmt% check XboxGameOverlay   programs_system_program_gameBar1
  %appxMgmt% check XboxGamingOverlay programs_system_program_gameBar2

  set programs_system_program_grooveMusic=uninstalled
  %appxMgmt% check ZuneMusic programs_system_program_grooveMusic

  set programs_system_program_moviesTV=uninstalled
  %appxMgmt% check ZuneVideo programs_system_program_moviesTV

  set programs_system_program_myOffice=uninstalled
  %appxMgmt% check MicrosoftOfficeHub programs_system_program_myOffice

  set programs_system_program_paint3D=uninstalled
  %appxMgmt% check MSPaint programs_system_program_paint3D

  set programs_system_program_photos=uninstalled
  %appxMgmt% check Windows.Photos programs_system_program_photos

  set programs_system_program_skype=uninstalled
  %appxMgmt% check SkypeApp programs_system_program_skype

  set programs_system_program_snipSketch=uninstalled
  %appxMgmt% check ScreenSketch programs_system_program_snipSketch

  set programs_system_program_stickyNotes=uninstalled
  %appxMgmt% check MicrosoftStickyNotes programs_system_program_stickyNotes

  set programs_system_program_store=uninstalled
  %appxMgmt% check WindowsStore programs_system_program_store

  set programs_system_program_voiceRecorder=uninstalled
  %appxMgmt% check WindowsSoundRecorder programs_system_program_voiceRecorder

  set programs_system_program_weather=uninstalled
  %appxMgmt% check BingWeather programs_system_program_weather

  set programs_system_program_xbox=uninstalled
  %appxMgmt% check XboxApp programs_system_program_xbox
)





if "%1" == "programs_system" (
  if "%programs_system_program_gameBar1%" == "%programs_system_program_gameBar2%" if "%programs_system_program_gameBar1%" == "installed" set programs_system_program_gameBar=installed
)





if "%1" == "programs_office" (
  set programs_office_setupURL=https://onedrive.live.com/download?cid=D3AF852448CB4BF6^&resid=D3AF852448CB4BF6%%21259^&authkey=AAK3Qw80R8to-VE
  set programs_office_setupISO=temp\programs_office_microsoftOfficeProfessionalPlus2016Setup.iso
)





if "%1" == "programs_gpeditMSC" (
  set programs_gpeditMSC_packagesList=temp\programs_gpeditMSC_packagesList.txt

  set programs_gpeditMSC_gpeditFile=notExist
  for /f "delims=" %%i in ('dir /a:-d /b "%winDir%\System32\gpedit.msc"') do if "%%i" == "gpedit.msc" set programs_gpeditMSC_gpeditFile=exist
)





if "%1" == "services_windowsUpdate" (
  set services_windowsUpdate_updateDistributions=unlocked
  for /f "delims=" %%i in ('dir /a:-d /b "%WinDir%\SoftwareDistribution\Download"') do if "%%i" == "Download" set services_windowsUpdate_updateDistributions=locked

  set services_windowsUpdate_updateCenter=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\wuauserv /v Start') do if "%%i" == "0x4" set services_windowsUpdate_updateCenter=disabled
)





if "%1" == "services_sppsvc" (
  set services_sppsvc_service=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\sppsvc /v Start') do if "%%i" == "0x4" set services_sppsvc_service=disabled
)





if "%1" == "tools_administrativeTools" (
  set tools_administrativeTools_desktop=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop') do if "%%i" == "0x1" set tools_administrativeTools_desktop=disabled)>nul 2>nul

  set tools_administrativeTools_controlPanel=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel') do if "%%i" == "0x1" set tools_administrativeTools_controlPanel=disabled)>nul 2>nul

  set tools_administrativeTools_runDialog=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun') do if "%%i" == "0x1" set tools_administrativeTools_runDialog=disabled)>nul 2>nul

  if "%key_tools_administrativeTools_hiddenOptions%" == "enabled" (
    set tools_administrativeTools_registryTools=enabled

    set tools_administrativeTools_cmd=enabled
    (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD') do if "%%i" == "0x1" set tools_administrativeTools_cmd=disabled)>nul 2>nul

    set tools_administrativeTools_taskManager=enabled
    (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr') do if "%%i" == "0x1" set tools_administrativeTools_taskManager=disabled)>nul 2>nul

  )
)
exit /b















:language_import
if "%setting_language%" == "default"   call :language_import_english

if "%setting_language%" == "english"   call :language_import_english
if "%setting_language%" == "russian"   call :language_import_russian
if "%setting_language%" == "ukrainian" call :language_import_ukrainian
exit /b





:language_import_english
set language_menuItem_goBack=^^(0^^) Go back
set language_menuItem_rebootComputer=^^(Z^^) Reboot computer
set language_menuItem_restartExplorer=^^(Y^^) Restart Windows Explorer
set language_menuItem_updateGroupPolicy=^^(X^^) Update group policy

set         language_stringBuilder_option_error=[error]           
set       language_stringBuilder_option_enabled=enabled           
set      language_stringBuilder_option_disabled=disabled          
set         language_stringBuilder_option_shown=shown             
set        language_stringBuilder_option_hidden=hidden            
set         language_stringBuilder_option_exist=exist             
set      language_stringBuilder_option_notExist=not exist         
set        language_stringBuilder_option_locked=locked            
set      language_stringBuilder_option_unlocked=unlocked          
set     language_stringBuilder_option_installed=installed         
set   language_stringBuilder_option_uninstalled=uninstalled       

set   language_stringBuilder_option_notAssigned=not assigned      
set     language_stringBuilder_option_ctrlShift=Ctrl + Shift      
set  language_stringBuilder_option_leftAltShift=left Alt + Shift  
set   language_stringBuilder_option_graveAccent=grave accent ^^(`^^)  

set    language_stringBuilder_option_powerShell=PowerShell        
set language_stringBuilder_option_commandPrompt=Command Prompt    

set        language_stringBuilder_option_always=always            
set    language_stringBuilder_option_whenIsFull=when is full      
set         language_stringBuilder_option_never=never             

set language_logo01=Release v%program_version%
set language_logo02=See other programs here:

set language_running=^^(i^^) %program_name% is running...
set language_eula01=^^(^^!^^) The author is not responsible for any possible damage to the computer^^!
set language_eula02=^^(^^?^^) Are you sure^^? ^^(Press Enter or close^^)

set language_main_menu01=  Interface                                                    Programs
set language_main_menu02=    ^^(1^^) Desktop objects ^^(This PC etc^^)                            ^^(6^^) System programs
set language_main_menu03=    ^^(2^^) Language key sequence ^^(Ctrl + Shift^^)                     ^^(7^^) Setup Office Professional+ 2016
set language_main_menu04=    ^^(3^^) Input suggestions and auto completion                    ^^(8^^) Setup/restore gpedit.msc
set language_main_menu05=    ^^(4^^) Windows Explorer
set language_main_menu06=    ^^(5^^) Windows Task Bar                                       Services
set language_main_menu07=                                                                 ^^(9^^) Windows Update ^^(wuauserv^^)
set language_main_menu08=  Tools                                                          ^^(A^^) Software Protection Platform Service ^^(sppsvc^^)
set language_main_menu09=    ^^(B^^) Administrative tools
set language_main_menu10=    ^^(C^^) System Resource Checker
set language_main_menu11=
set language_main_menu12=
set language_main_menu13=    ^^(L^^) Language
set language_main_menu14=    ^^(0^^) Exit

set language_interface_desktopObjects01=^^(i^^) Desktop Objects - Control Menu
set language_interface_desktopObjects02=^^(^^^>^^) Choose action to show/hide desktop object:
set language_interface_desktopObjects03=^^(1^^) This PC                           
set language_interface_desktopObjects04=^^(4^^) User Folder                       
set language_interface_desktopObjects05=^^(2^^) Recycle Bin                       
set language_interface_desktopObjects06=^^(5^^) Network                           
set language_interface_desktopObjects07=^^(3^^) Control Panel                     
set language_interface_desktopObjects08=Note: These features require to restart Windows Explorer.

set language_interface_languageKeySequence01=^^(i^^) Language Key Sequence - Control Menu
set language_interface_languageKeySequence02=^^(^^^>^^) Choose action to change key sequence:
set language_interface_languageKeySequence03=^^(1^^) Input language                    
set language_interface_languageKeySequence04=^^(2^^) Keyboard layout                   

set language_interface_suggestions01=^^(i^^) Input Suggestions - Control Menu
set language_interface_suggestions02=^^(^^^>^^) Choose action to enable/disable input suggestions:
set language_interface_suggestions03=^^(1^^) Auto suggest                      
set language_interface_suggestions04=^^(2^^) Append completion                 
set language_interface_suggestions05=^^(3^^) Start track progs                 
set language_interface_suggestions06=^^(4^^) Suggestions when typing           

set language_interface_explorer01=^^(i^^) Windows Explorer - Control Menu
set language_interface_explorer02=^^(^^^>^^) Choose action to config Windows Explorer:
set language_interface_explorer03=^^(1^^) File extensions                   
set language_interface_explorer04=^^(6^^) Ribbon ^^(option bar^^)               
set language_interface_explorer05=^^(2^^) Hidden files                      
set language_interface_explorer06=^^(7^^) Expand to open folder             
set language_interface_explorer07=^^(3^^) Protected system files            
set language_interface_explorer08=^^(8^^) Status bar                        
set language_interface_explorer09=^^(4^^) Empty drives                      
set language_interface_explorer10=^^(9^^) File info tip                     
set language_interface_explorer11=^^(5^^) Folder merge conflicts            
set language_interface_explorer12=    This PC and navigation bar objects:
set language_interface_explorer13=^^(A^^) Desktop                           
set language_interface_explorer14=^^(E^^) Pictures                          
set language_interface_explorer15=^^(B^^) Documents                         
set language_interface_explorer16=^^(F^^) Videos                            
set language_interface_explorer17=^^(C^^) Downloads                         
set language_interface_explorer18=^^(G^^) 3DObjects                         
set language_interface_explorer19=^^(D^^) Music                             
set language_interface_explorer20=^^(H^^) OneDrive                          
set language_interface_explorer21=^^(I^^) Auto folder type discovery        
set language_interface_explorer22=Note: These features require to restart Windows Explorer.

set language_interface_taskBar01=^^(i^^) Windows Task Bar - Control Menu
set language_interface_taskBar02=^^(^^^>^^) Choose action to config Windows Task Bar:
set language_interface_taskBar03=^^(1^^) People band                       
set language_interface_taskBar04=^^(4^^) Small icons                       
set language_interface_taskBar05=^^(2^^) Command prompt on Win + X         
set language_interface_taskBar06=^^(5^^) Buttons combine                   
set language_interface_taskBar07=^^(3^^) Task view button                  
set language_interface_taskBar08=Note: These features require to restart Windows Explorer.

set language_programs_system01=^^(i^^) System Programs - Control Menu
set language_programs_system02=^^(^^^>^^) Choose action to install/uninstall system programs:
set language_programs_system03=^^(1^^) 3D Viewer                         
set language_programs_system04=^^(D^^) Alarms and Clock                  
set language_programs_system05=^^(2^^) Feedback Hub                      
set language_programs_system06=^^(E^^) Camera                            
set language_programs_system07=^^(3^^) Get Help                          
set language_programs_system08=^^(F^^) Game bar                          
set language_programs_system09=^^(4^^) Mail and Calendar                 
set language_programs_system10=^^(G^^) Groove Music                      
set language_programs_system11=^^(5^^) Maps                              
set language_programs_system12=^^(H^^) Movies and TV                     
set language_programs_system13=^^(6^^) Messaging                         
set language_programs_system14=^^(I^^) My Office                         
set language_programs_system15=^^(7^^) Mobile Plans                      
set language_programs_system16=^^(J^^) Paint 3D                          
set language_programs_system17=^^(8^^) OneNote                           
set language_programs_system18=^^(K^^) Photos                            
set language_programs_system19=^^(9^^) Print 3D                          
set language_programs_system20=^^(L^^) Skype                             
set language_programs_system21=^^(A^^) Solitare                          
set language_programs_system22=^^(M^^) Snip and Sketch                   
set language_programs_system23=^^(B^^) Tips                              
set language_programs_system24=^^(N^^) Sticky Notes                      
set language_programs_system25=^^(C^^) Your Phone                        
set language_programs_system26=^^(O^^) Store                             
set language_programs_system28=^^(P^^) Voice Recorder                    
set language_programs_system30=^^(Q^^) Weather                           
set language_programs_system32=^^(R^^) Xbox                              
set language_programs_system33=^^(S^^) Install all
set language_programs_system34=^^(T^^) Uninstall all

set language_programs_office01=^^(i^^) Microsoft Office Professional+ 2016 - Setup Menu
set language_programs_office02=^^(^^^>^^) Choose action:
set language_programs_office03=^^(1^^) Run setup
set language_programs_office04=Note: This feature requires to reboot your computer.
set language_programs_office05=^^(i^^) Downloading Microsoft Office Professional+ 2016
set language_programs_office06=^^(i^^) Mounting iso file
set language_programs_office07=^^(i^^) Setup
set language_programs_office08=^^(i^^) Unmounting iso file

set language_programs_gpeditMSC01=^^(i^^) Group Policy Editor - Setup Menu
set language_programs_gpeditMSC02=^^(^^^>^^) Choose action:
set language_programs_gpeditMSC03=^^(1^^) Setup/repair gpedit.msc           

set language_services_windowsUpdate01=^^(i^^) Windows Update ^^(wuauserv^^) - Control Menu
set language_services_windowsUpdate02=^^(^^^>^^) Choose action to enable/disable Windows Update:
set language_services_windowsUpdate03=^^(1^^) Update distributions              
set language_services_windowsUpdate04=^^(2^^) Update Center ^^(wuauserv^^)          

set language_services_sppsvc01=^^(i^^) Software Protection Platform Service ^^(sppsvc^^) - Restore Menu
set language_services_sppsvc02=^^(^^^>^^) Choose action:
set language_services_sppsvc03=^^(1^^) Restore service                   
set language_services_sppsvc04=Note: This feature requires to reboot your computer two times.
set language_services_sppsvc05=      The computer will automatically reboot after the next system start.

set language_tools_administrativeTools01=^^(i^^) Windows Administrative Tools - Control Menu
set language_tools_administrativeTools02=^^(^^^>^^) Choose action to config Windows Administrative Tools:
set language_tools_administrativeTools03=^^(1^^) Desktop                           
set language_tools_administrativeTools04=^^(4^^) Registry Tools                    
set language_tools_administrativeTools05=^^(2^^) Control Panel                     
set language_tools_administrativeTools06=^^(5^^) Command Prompt                    
set language_tools_administrativeTools07=^^(3^^) Run ^^(Win + R^^)                     
set language_tools_administrativeTools08=^^(6^^) Task Manager                      
set language_tools_administrativeTools09=Note: Features ^^(2^^) and ^^(3^^) require to update group policy.
set language_tools_administrativeTools10=Note: Feature ^^(1^^) requires to restart Windows Explorer.
set language_tools_administrativeTools11=Note: Feature ^^(5^^) requires to reboot your computer.

set language_tools_systemResourceChecker01=^^(i^^) System Resource Checker - Restore Menu
set language_tools_systemResourceChecker02=^^(^^^>^^) Choose action:
set language_tools_systemResourceChecker03=^^(1^^) Run System Resource Scan and automatically repair all files with problems
set language_tools_systemResourceChecker04=Note: This feature requires to reboot your computer.

set language_language_menu01=^^(i^^) Language - Selection Menu
set language_language_menu02=^^(^^^>^^) Choose language:

set language_reboot_computer01=^^(i^^) Reboot Menu
set language_reboot_computer02=^^(^^^>^^) Choose action:
set language_reboot_computer03=^^(1^^) Reboot now
set language_reboot_computer04=^^(^^!^^) Rebooting...

set language_message_error_main_variables_disabledRegistryTools01=Registry Tools are disabled^^!
set language_message_error_main_variables_disabledRegistryTools02=If you see [error] than this feature state cannot be shown or changed^^!
set language_message_error_main_variables_disabledRegistryTools03=To fix it you must enable Registry Tools in ^^(A^^) menu ^^(with hidden options^^)^^!
set language_message_error_main_variables_disabledRegistryTools04=Please, back to main menu and read this error message again.

set language_message_error_interface_languageKeySequence_twoIdenticalCombinations=^^(^^!^^) Can not be two identical key combinations^^!

set language_message_error_programs_office_download=^^(^^!^^) Download error^^! Server not respond or no Internet connection^^!

set language_message_update_available01=^^(^^!^^) An update for %program_name% is now available^^!
set language_message_update_available02=Download it here:

set language_message_tools_administrativeTools_hiddenOptions=^^(^^!^^) Warning^^! Hidden options are shown^^! They can damage your computer^^!
exit /b





:language_import_russian
set language_menuItem_goBack=^^(0^^) Назад
set language_menuItem_rebootComputer=^^(Z^^) Перезагрузить компьютер
set language_menuItem_restartExplorer=^^(Y^^) Перезагрузить Проводник Windows
set language_menuItem_updateGroupPolicy=^^(X^^) Обновить групповую политику

set         language_stringBuilder_option_error=[ошибка]          
set       language_stringBuilder_option_enabled=включено          
set      language_stringBuilder_option_disabled=отключено         
set         language_stringBuilder_option_shown=показано          
set        language_stringBuilder_option_hidden=скрыто            
set         language_stringBuilder_option_exist=существует        
set      language_stringBuilder_option_notExist=не существует     
set        language_stringBuilder_option_locked=заблокировано     
set      language_stringBuilder_option_unlocked=розблокировано    
set     language_stringBuilder_option_installed=установлено       
set   language_stringBuilder_option_uninstalled=не установлено    

set   language_stringBuilder_option_notAssigned=не призначено     
set     language_stringBuilder_option_ctrlShift=Ctrl + Shift      
set  language_stringBuilder_option_leftAltShift=левый Alt + Shift 
set   language_stringBuilder_option_graveAccent=ударение ^^(`^^)      

set    language_stringBuilder_option_powerShell=PowerShell        
set language_stringBuilder_option_commandPrompt=Командная Строка  

set        language_stringBuilder_option_always=всегда            
set    language_stringBuilder_option_whenIsFull=когда полон       
set         language_stringBuilder_option_never=никогда           

set language_logo01=Релиз v%program_version%
set language_logo02=Смотрите другие программы здесь:

set language_running=^^(i^^) %program_name% запускается...
set language_eula01=^^(^^!^^) Автор не несет ответственности за возможные повреждения компьютера^^!
set language_eula02=^^(^^?^^) Вы уверены^^? ^^(Нажмите Enter или закройте^^)

set language_main_menu01=  Интерфейс                                                    Программы
set language_main_menu02=    ^^(1^^) Объекты рабочего стола ^^(Этот ПК и другие^^)                ^^(6^^) Системные программы
set language_main_menu03=    ^^(2^^) Сочетания клавиш смены языка ^^(Ctrl + Shift^^)              ^^(7^^) Установить Офис Профессиональный+ 2016
set language_main_menu04=    ^^(3^^) Предложения при вводе и автозаполнение                   ^^(8^^) Установить/восстановить gpedit.msc
set language_main_menu05=    ^^(4^^) Проводник Windows
set language_main_menu06=    ^^(5^^) Панель Задач Windows                                   Службы
set language_main_menu07=                                                                 ^^(9^^) Обновление Windows ^^(wuauserv^^)
set language_main_menu08=  Инструменты                                                    ^^(A^^) Служба Платформы Защиты ПО ^^(sppsvc^^)
set language_main_menu09=    ^^(B^^) Административные инструменты
set language_main_menu10=    ^^(C^^) Проверка системных ресурсов
set language_main_menu11=
set language_main_menu12=
set language_main_menu13=    ^^(L^^) Язык
set language_main_menu14=    ^^(0^^) Выход

set language_interface_desktopObjects01=^^(i^^) Объекты Рабочего Стола - Меню Управления
set language_interface_desktopObjects02=^^(^^^>^^) Выберите действие, чтобы показать / скрыть объект рабочего стола:
set language_interface_desktopObjects03=^^(1^^) Этот компьютер                    
set language_interface_desktopObjects04=^^(4^^) Папка пользователя                
set language_interface_desktopObjects05=^^(2^^) Корзина                           
set language_interface_desktopObjects06=^^(5^^) Сеть                              
set language_interface_desktopObjects07=^^(3^^) Панель управления                 
set language_interface_desktopObjects08=Примечание: Эти функции требуют перезапуска Проводника Windows.

set language_interface_languageKeySequence01=^^(i^^) Сочетания Клавиш Смены Языка - Меню Управления
set language_interface_languageKeySequence02=^^(^^^>^^) Выберите действие, чтобы изменить последовательность клавиш:
set language_interface_languageKeySequence03=^^(1^^) Язык ввода                        
set language_interface_languageKeySequence04=^^(2^^) Раскладка клавиатуры              

set language_interface_suggestions01=^^(i^^) Предложения При Вводе - Меню Управления
set language_interface_suggestions02=^^(^^^>^^) Выберите действие, чтобы включить/отключить предложения ввода:
set language_interface_suggestions03=^^(1^^) Авто предложения                  
set language_interface_suggestions04=^^(2^^) Автозаполнение                    
set language_interface_suggestions05=^^(3^^) Запустить трекинг програм         
set language_interface_suggestions06=^^(4^^) Предложения при наборе текста     

set language_interface_explorer01=^^(i^^) Проводник Windows - Меню Управления
set language_interface_explorer02=^^(^^^>^^) Выберите действие, чтобы настроить Проводник Windows:
set language_interface_explorer03=^^(1^^) Расширения файлов                 
set language_interface_explorer04=^^(6^^) Лента ^^(панель опций^^)              
set language_interface_explorer05=^^(2^^) Скрытые файлы                     
set language_interface_explorer06=^^(7^^) Развернуть к открытой папке       
set language_interface_explorer07=^^(3^^) Защищенные системные файлы        
set language_interface_explorer08=^^(8^^) Статус бар                        
set language_interface_explorer09=^^(4^^) Пустые диски                      
set language_interface_explorer10=^^(9^^) Информация о файле                
set language_interface_explorer11=^^(5^^) Конфликты слияния папок           
set language_interface_explorer12=    Объекты Этого компьютера и панели навигации:
set language_interface_explorer13=^^(A^^) Рабочий Стол                      
set language_interface_explorer14=^^(E^^) Картинки                          
set language_interface_explorer15=^^(B^^) Документы                         
set language_interface_explorer16=^^(F^^) Видео                             
set language_interface_explorer17=^^(C^^) Загрузки                          
set language_interface_explorer18=^^(G^^) 3D Объекты                        
set language_interface_explorer19=^^(D^^) Музыка                            
set language_interface_explorer20=^^(H^^) OneDrive                          
set language_interface_explorer21=^^(I^^) Авто определение типа папки       
set language_interface_explorer22=Примечание: Эти функции требуют перезапуска Проводника Windows.

set language_interface_taskBar01=^^(i^^) Панель Задач Windows - Меню Управления
set language_interface_taskBar02=^^(^^^>^^) Выберите действие, чтобы настроить Панель Задач Windows:
set language_interface_taskBar03=^^(1^^) Полоса людей                      
set language_interface_taskBar04=^^(4^^) Маленькие иконки                  
set language_interface_taskBar05=^^(2^^) Командная строка при Win + X      
set language_interface_taskBar06=^^(5^^) Совмещение кнопок                 
set language_interface_taskBar07=^^(3^^) Кнопка просмотра задач            
set language_interface_taskBar08=Примечание: Эти функции требуют перезапуска Проводника Windows.

set language_programs_system01=^^(i^^) Системные Приложения - Меню Управления
set language_programs_system02=^^(^^^>^^) Выберите действие, чтобы установить/деинсталировать системные приложения:
set language_programs_system03=^^(1^^) 3D-модели                         
set language_programs_system04=^^(D^^) Будильники и Часы                 
set language_programs_system05=^^(2^^) Обратная Связь                    
set language_programs_system06=^^(E^^) Камера                            
set language_programs_system07=^^(3^^) Помощник                          
set language_programs_system08=^^(F^^) Игровая панель                    
set language_programs_system09=^^(4^^) Почта и Календарь                 
set language_programs_system10=^^(G^^) Музыка Groove                     
set language_programs_system11=^^(5^^) Карты                             
set language_programs_system12=^^(H^^) Фильмы и Телевидение              
set language_programs_system13=^^(6^^) Сообщения                         
set language_programs_system14=^^(I^^) Office                            
set language_programs_system15=^^(7^^) Мобильные тарифы                  
set language_programs_system16=^^(J^^) Paint 3D                          
set language_programs_system17=^^(8^^) OneNote                           
set language_programs_system18=^^(K^^) Фотографии                        
set language_programs_system19=^^(9^^) Print 3D                          
set language_programs_system20=^^(L^^) Skype                             
set language_programs_system21=^^(A^^) Solitare                          
set language_programs_system22=^^(M^^) Фрагмент и Набросок               
set language_programs_system23=^^(B^^) Подсказки                         
set language_programs_system24=^^(N^^) Наклейки                          
set language_programs_system25=^^(C^^) Ваш Телефон                       
set language_programs_system26=^^(O^^) Магазин                           
set language_programs_system28=^^(P^^) Звукозаписыватель                 
set language_programs_system30=^^(Q^^) Погода                            
set language_programs_system32=^^(R^^) Xbox                              
set language_programs_system33=^^(S^^) Установить всё
set language_programs_system34=^^(T^^) Деинсталировать всё

set language_programs_office01=^^(i^^) Microsoft Офис Профессиональный+ 2016 - Меню Настройки
set language_programs_office02=^^(^^^>^^) Выберите действие:
set language_programs_office03=^^(1^^) Запустить установку
set language_programs_office04=Примечание: Эта функция требует перезагрузки Вашего компьютера.
set language_programs_office05=^^(i^^) Загрузка Microsoft Офис Профессиональный+ 2016
set language_programs_office06=^^(i^^) Подключение iso файла
set language_programs_office07=^^(i^^) Установка
set language_programs_office08=^^(i^^) Отключение iso файла

set language_programs_gpeditMSC01=^^(i^^) Редактор Групповых Политик - Меню Настройки
set language_programs_gpeditMSC02=^^(^^^>^^) Выберите действие:
set language_programs_gpeditMSC03=^^(1^^) Установить/восстановить           

set language_services_windowsUpdate01=^^(i^^) Обновление Windows ^^(wuauserv^^) - Меню Управления
set language_services_windowsUpdate02=^^(^^^>^^) Выберите действие, чтобы включить/отключить обновления Windows:
set language_services_windowsUpdate03=^^(1^^) Дистрибутивы обновлений           
set language_services_windowsUpdate04=^^(2^^) Центр обновлений ^^(wuauserv^^)       

set language_services_sppsvc01=^^(i^^) Служба Платформы Защиты Програмного Обеспечения ^^(sppsvc^^) - Меню Восстановления
set language_services_sppsvc02=^^(^^^>^^) Выберите действие:
set language_services_sppsvc03=^^(1^^) Восстановить службу               
set language_services_sppsvc04=Примечание: Эта функция требует двух перезагрузок Вашего компьютера.
set language_services_sppsvc05=            Ваш компьютер автоматически перезагрузится после следущего старта системы.

set language_tools_administrativeTools01=^^(i^^) Административные Инструменты Windows - Меню Управления
set language_tools_administrativeTools02=^^(^^^>^^) Выберите действие, чтобы настроить Административные Инструменты Windows:
set language_tools_administrativeTools03=^^(1^^) Рабочий Стол                      
set language_tools_administrativeTools04=^^(4^^) Инструменты Реестра               
set language_tools_administrativeTools05=^^(2^^) Панель Управления                 
set language_tools_administrativeTools06=^^(5^^) Командная Строка                  
set language_tools_administrativeTools07=^^(3^^) Выполнить ^^(Win + R^^)               
set language_tools_administrativeTools08=^^(6^^) Диспетчер Задач                   
set language_tools_administrativeTools09=Примечание: Функции ^^(2^^) и ^^(3^^) требуют обновить групповую политику.
set language_tools_administrativeTools10=Примечание: Функция ^^(1^^) требует перезапуска Проводника Windows.
set language_tools_administrativeTools11=Примечание: Функция ^^(5^^) требует перезагрузки Вашего компьютера.

set language_tools_systemResourceChecker01=^^(i^^) Проверка Системных Ресурсов - Меню Восстановления
set language_tools_systemResourceChecker02=^^(^^^>^^) Выберите действие:
set language_tools_systemResourceChecker03=^^(1^^) Запустить проверку системных ресурсов и автоматически исправить все файлы с проблемами
set language_tools_systemResourceChecker04=Примечание: Эта функция требует перезагрузки Вашего компьютера.

set language_language_menu01=^^(i^^) Язык - Меню Выбора
set language_language_menu02=^^(^^^>^^) Выберите язык:

set language_reboot_computer01=^^(i^^) Меню Перезагрузки
set language_reboot_computer02=^^(^^^>^^) Выберите действие:
set language_reboot_computer03=^^(1^^) Перезагрузить сейчас
set language_reboot_computer04=^^(^^!^^) Перезагрузка...

set language_message_error_main_variables_disabledRegistryTools01=Инструменты реестра отключены^^!
set language_message_error_main_variables_disabledRegistryTools02=Если вы видите [ошибка], то это состояние функции не может быть показано или изменено^^!
set language_message_error_main_variables_disabledRegistryTools03=Чтобы это исправить, вы должны включить инструменты реестра в меню ^^(A^^) ^^(со скрытыми параметрами^^)^^!
set language_message_error_main_variables_disabledRegistryTools04=Пожалуйста, вернитесь в главное меню и прочитайте это сообщение об ошибке еще раз.

set language_message_error_interface_languageKeySequence_twoIdenticalCombinations=^^(^^!^^) Не может быть двух одинаковых комбинаций клавиш^^!

set language_message_error_programs_office_download=^^(^^!^^) Ошибка загрузки^^! Сервер не отвечает или нет подключения к Интернету^!

set language_message_update_available01=^^(^^!^^) Доступно обновление для %program_name%^^!
set language_message_update_available02=Загрузите его здесь:

set language_message_tools_administrativeTools_hiddenOptions=^^(^^!^^) Предупреждение^^! Скрытые параметры отображаются^^! Они могут повредить Ваш компьютер^^!
exit /b





:language_import_ukrainian
set language_menuItem_goBack=^^(0^^) Назад
set language_menuItem_rebootComputer=^^(Z^^) Перезавантажити комп'ютер
set language_menuItem_restartExplorer=^^(Y^^) Перезавантажити Провідник Windows
set language_menuItem_updateGroupPolicy=^^(X^^) Оновити групову політику

set         language_stringBuilder_option_error=[помилка]         
set       language_stringBuilder_option_enabled=увімкнено         
set      language_stringBuilder_option_disabled=вимкнено          
set         language_stringBuilder_option_shown=показано          
set        language_stringBuilder_option_hidden=сховано           
set         language_stringBuilder_option_exist=існує             
set      language_stringBuilder_option_notExist=не існує          
set        language_stringBuilder_option_locked=заблоковано       
set      language_stringBuilder_option_unlocked=розблоковано      
set     language_stringBuilder_option_installed=установлено       
set   language_stringBuilder_option_uninstalled=не установлено    

set   language_stringBuilder_option_notAssigned=не визначено      
set     language_stringBuilder_option_ctrlShift=Ctrl + Shift      
set  language_stringBuilder_option_leftAltShift=лівий Alt + Shift 
set   language_stringBuilder_option_graveAccent=наголос ^^(`^^)       

set    language_stringBuilder_option_powerShell=PowerShell        
set language_stringBuilder_option_commandPrompt=Командний Рядок   

set        language_stringBuilder_option_always=завжди            
set    language_stringBuilder_option_whenIsFull=коли повний       
set         language_stringBuilder_option_never=ніколи            

set language_logo01=Реліз v%program_version%
set language_logo02=Дивіться інші програми тут:

set language_running=^^(i^^) %program_name% запускається...
set language_eula01=^^(^^!^^) Автор не несе відповідальності за можливі пошкодження комп'ютера^^!
set language_eula02=^^(^^?^^) Ви впевнені^^? ^^(Натисніть Enter або закрийте^^)

set language_main_menu01=  Інтерфейс                                                    Програми
set language_main_menu02=    ^^(1^^) Об'єкти робочого столу ^^(Цей ПК та інші^^)                  ^^(6^^) Системні програми
set language_main_menu03=    ^^(2^^) Комбінації клавіш зміни мови ^^(Ctrl + Shift^^)              ^^(7^^) Установити Офіс Професійний+ 2016
set language_main_menu04=    ^^(3^^) Пропозиції при введенні та автозаповнення                ^^(8^^) Установити/відновити gpedit.msc
set language_main_menu05=    ^^(4^^) Провідник Windows
set language_main_menu06=    ^^(5^^) Панель Завдань Windows                                 Служби
set language_main_menu07=                                                                 ^^(9^^) Оновлення Windows ^^(wuauserv^^)
set language_main_menu08=  Інструменти                                                    ^^(A^^) Служба Платформи Захисту ПО ^^(sppsvc^^)
set language_main_menu09=    ^^(B^^) Адміністративні інструменти
set language_main_menu10=    ^^(C^^) Перевірка системних ресурсів
set language_main_menu11=
set language_main_menu12=
set language_main_menu13=    ^^(L^^) Мова
set language_main_menu14=    ^^(0^^) Вихід

set language_interface_desktopObjects01=^^(i^^) Об'єкти Робочого Столу - Меню Управління
set language_interface_desktopObjects02=^^(^^^>^^) Виберіть дію, щоб показати/приховати об'єкт робочого столу:
set language_interface_desktopObjects03=^^(1^^) Цей комп'ютер                     
set language_interface_desktopObjects04=^^(4^^) Папка користувача                 
set language_interface_desktopObjects05=^^(2^^) Кошик                             
set language_interface_desktopObjects06=^^(5^^) Мережа                            
set language_interface_desktopObjects07=^^(3^^) Панель управління                 
set language_interface_desktopObjects08=Примітка: Ці функції потребують перезапуску Провідника Windows.

set language_interface_languageKeySequence01=^^(i^^) Комбінації Клавіш Зміни Мови - Меню Управління
set language_interface_languageKeySequence02=^^(^^^>^^) Виберіть дію, щоб змінити комбінації клавіш:
set language_interface_languageKeySequence03=^^(1^^) Мова введення                     
set language_interface_languageKeySequence04=^^(2^^) Розкладка клавіатури              

set language_interface_suggestions01=^^(i^^) Пропозиції При Введенні - Меню Управління
set language_interface_suggestions02=^^(^^^>^^) Виберіть дію, щоб включити/відключити пропозиції введення:
set language_interface_suggestions03=^^(1^^) Авто пропозиції                   
set language_interface_suggestions04=^^(2^^) Автозаповнення                    
set language_interface_suggestions05=^^(3^^) Запустити трекінг програм         
set language_interface_suggestions06=^^(4^^) Пропозиції при наборі тексту      

set language_interface_explorer01=^^(i^^) Провідник Windows - Меню Управління
set language_interface_explorer02=^^(^^^>^^) Виберіть дію, щоб налаштувати Провідник Windows:
set language_interface_explorer03=^^(1^^) Розширення файлів                 
set language_interface_explorer04=^^(6^^) Стрічка ^^(панель опцій^^)            
set language_interface_explorer05=^^(2^^) Приховані файли                   
set language_interface_explorer06=^^(7^^) Розгорнути до відкритої папки     
set language_interface_explorer07=^^(3^^) Захищені системні файли           
set language_interface_explorer08=^^(8^^) Рядок стану                       
set language_interface_explorer09=^^(4^^) Порожні диски                     
set language_interface_explorer10=^^(9^^) Інформація про файл               
set language_interface_explorer11=^^(5^^) Конфлікти об'єднання папок        
set language_interface_explorer12=    Об'єкти Цього комп'ютера і панелі навігації:
set language_interface_explorer13=^^(A^^) Робочий Стіл                      
set language_interface_explorer14=^^(E^^) Зображення                        
set language_interface_explorer15=^^(B^^) Документи                         
set language_interface_explorer16=^^(F^^) Відео                             
set language_interface_explorer17=^^(C^^) Завантаження                      
set language_interface_explorer18=^^(G^^) 3D Об'єкти                        
set language_interface_explorer19=^^(D^^) Музика                            
set language_interface_explorer20=^^(H^^) OneDrive                          
set language_interface_explorer21=^^(I^^) Авто визначення типу папки        
set language_interface_explorer22=Примітка: Ці функції потребують перезапуску Провідника Windows.

set language_interface_taskBar01=^^(i^^) Панель Завдань Windows - Меню Управління
set language_interface_taskBar02=^^(^^^>^^) Виберіть дію, щоб налаштувати Панель Завдань Windows:
set language_interface_taskBar03=^^(1^^) Полоса людей                      
set language_interface_taskBar04=^^(4^^) Маленькі іконки                   
set language_interface_taskBar05=^^(2^^) Командний рядок при Win + X       
set language_interface_taskBar06=^^(5^^) Зміщення кнопок                   
set language_interface_taskBar07=^^(3^^) Кнопка перегляду завдань          
set language_interface_taskBar08=Примітка: Ці функції потребують перезапуску Провідника Windows.

set language_programs_system01=^^(i^^) Системні Програми - Меню Управління
set language_programs_system02=^^(^^^>^^) Виберіть дію, щоб установити/деінсталювати системні програми:
set language_programs_system03=^^(1^^) 3D-моделі                         
set language_programs_system04=^^(D^^) Будильники та Годинники           
set language_programs_system05=^^(2^^) Зворотній Зв'язок                 
set language_programs_system06=^^(E^^) Камера                            
set language_programs_system07=^^(3^^) Помічник                          
set language_programs_system08=^^(F^^) Ігрова панель                     
set language_programs_system09=^^(4^^) Пошта і Календар                  
set language_programs_system10=^^(G^^) Музика Groove                     
set language_programs_system11=^^(5^^) Карти                             
set language_programs_system12=^^(H^^) Фільми й Телепрограми             
set language_programs_system13=^^(6^^) Повідомлення                      
set language_programs_system14=^^(I^^) Office                            
set language_programs_system15=^^(7^^) Мобільні тарифи                   
set language_programs_system16=^^(J^^) Paint 3D                          
set language_programs_system17=^^(8^^) OneNote                           
set language_programs_system18=^^(K^^) Фотографії                        
set language_programs_system19=^^(9^^) Print 3D                          
set language_programs_system20=^^(L^^) Skype                             
set language_programs_system21=^^(A^^) Solitare                          
set language_programs_system22=^^(M^^) Фрагмент і Ескіз                  
set language_programs_system23=^^(B^^) Підказки                          
set language_programs_system24=^^(N^^) Наліпки                           
set language_programs_system25=^^(C^^) Ваш Телефон                       
set language_programs_system26=^^(O^^) Магазин                           
set language_programs_system28=^^(P^^) Звукозаписувач                    
set language_programs_system30=^^(Q^^) Погода                            
set language_programs_system32=^^(R^^) Xbox                              
set language_programs_system33=^^(S^^) Установити все
set language_programs_system34=^^(T^^) Деінсталювати все

set language_programs_office01=^^(i^^) Microsoft Офіс Професійний+ 2016 - Меню Налаштування
set language_programs_office02=^^(^^^>^^) Виберіть дію:
set language_programs_office03=^^(1^^) Запустити встановлення
set language_programs_office04=Примітка: Ця функція потребує перезавантаження Вашого комп'ютера.
set language_programs_office05=^^(i^^) Завантаження Microsoft Офіс Професійний+ 2016
set language_programs_office06=^^(i^^) Підключення iso файлу
set language_programs_office07=^^(i^^) Встановлення
set language_programs_office08=^^(i^^) Відключення iso файлу

set language_programs_gpeditMSC01=^^(i^^) Редактор Групових Політик - Меню Налаштування
set language_programs_gpeditMSC02=^^(^^^>^^) Виберіть дію:
set language_programs_gpeditMSC03=^^(1^^) Установити/відновити              

set language_services_windowsUpdate01=^^(i^^) Оновлення Windows ^^(wuauserv^^) - Меню Управління
set language_services_windowsUpdate02=^^(^^^>^^) Виберіть дію, щоб увімкнути/вимкнути оновлення Windows:
set language_services_windowsUpdate03=^^(1^^) Дистрибутиви оновлень             
set language_services_windowsUpdate04=^^(2^^) Центр оновлень ^^(wuauserv^^)         

set language_services_sppsvc01=^^(i^^) Служба Платформи Захисту Програмного Забезпечення ^^(sppsvc^^) - Меню Відновлення
set language_services_sppsvc02=^^(^^^>^^) Виберіть дію:
set language_services_sppsvc03=^^(1^^) Відновити службу                  
set language_services_sppsvc04=Примітка: Ця функція потребує двох перезавантажень Вашого комп'ютера.
set language_services_sppsvc05=          Ваш комп'ютер автоматично перезавантажиться після наступного старту системи.

set language_tools_administrativeTools01=^^(i^^) Адміністративні Інструменти Windows - Меню Управління
set language_tools_administrativeTools02=^^(^^^>^^) Виберіть дію, щоб налаштувати Адміністративні Інструменти Windows:
set language_tools_administrativeTools03=^^(1^^) Робочий Стіл                      
set language_tools_administrativeTools04=^^(4^^) Інструменти Реєстру               
set language_tools_administrativeTools05=^^(2^^) Панель Управління                 
set language_tools_administrativeTools06=^^(5^^) Командний Рядок                   
set language_tools_administrativeTools07=^^(3^^) Виконати ^^(Win + R^^)                
set language_tools_administrativeTools08=^^(6^^) Диспетчер Завдань                 
set language_tools_administrativeTools09=Примітка: Функції ^^(2^^) и ^^(3^^) потребують оновити групову політику.
set language_tools_administrativeTools10=Примітка: Функція ^^(1^^) потребує перезапуску Провідника Windows.
set language_tools_administrativeTools11=Примітка: Функція ^^(5^^) потребує перезавантаження Вашого комп'ютера.

set language_tools_systemResourceChecker01=^^(i^^) Перевірка Системних Ресурсів - Меню Відновлення
set language_tools_systemResourceChecker02=^^(^^^>^^) Виберіть дію:
set language_tools_systemResourceChecker03=^^(1^^) Запустити перевірку системних ресурсів та автоматично виправити всі файли з проблемами
set language_tools_systemResourceChecker04=Примітка: Ця функція потребує перезавантаження Вашого комп'ютера.

set language_language_menu01=^^(i^^) Мова - Меню Вибору
set language_language_menu02=^^(^^^>^^) Виберіть мову:

set language_reboot_computer01=^^(i^^) Меню Перезавантаження
set language_reboot_computer02=^^(^^^>^^) Виберіть дію:
set language_reboot_computer03=^^(1^^) Перезавантажити зараз
set language_reboot_computer04=^^(^^!^^) Перезавантаження...

set language_message_error_main_variables_disabledRegistryTools01=Інструменти реєстру відключені^^!
set language_message_error_main_variables_disabledRegistryTools02=Якщо ви бачите [помилка], то це стан формальної процедури не може показано або змінено^^!
set language_message_error_main_variables_disabledRegistryTools03=Щоб це виправити, ви повинні включити інструменти реєстру в меню ^^(A^^) ^^(з прихованими параметрами^^)^^!
set language_message_error_main_variables_disabledRegistryTools04=Будь ласка, поверніться в головне меню і прочитайте це повідомлення про помилку ще раз.

set language_message_error_interface_languageKeySequence_twoIdenticalCombinations=^^(^^!^^) Не може бути двох ідентичних комбінацій клавіш^^!

set language_message_error_programs_office_download=^^(^^!^^) Помилка завантаження^^! Сервер не відповідає або немає підключення до Інтернету^!

set language_message_update_available01=^^(^^!^^) Доступно оновлення для %program_name%^^!
set language_message_update_available02=Завантажте його тут:

set language_message_tools_administrativeTools_hiddenOptions=^^(^^!^^) Попередження^^! Приховані параметри відображаються^^! Вони можуть пошкодити Ваш комп'ютер^^!
exit /b















:settings_save
echo.# %program_name% Settings #>settings.ini
echo.eula=%setting_eula%>>settings.ini
echo.language=%setting_language%>>settings.ini
exit /b















:logo
mode con:cols=124 lines=39
title [MikronT] %program_name%
color 0b
cls
echo.
echo.
echo.    [MikronT] ==^> %program_name%
echo.                  %language_logo01%
echo.   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.     %language_logo02%
echo.         github.com/MikronT
echo.
echo.
echo.
exit /b















:message_error_main_variables_disabledRegistryTools
echo.    ^(^!^) %language_message_error_main_variables_disabledRegistryTools01%
echo.        %language_message_error_main_variables_disabledRegistryTools02%
if "%1" == "main_menu" (
  echo.        %language_message_error_main_variables_disabledRegistryTools03%
) else echo.        %language_message_error_main_variables_disabledRegistryTools04%
echo.
exit /b















:restart_explorer
taskkill /f /im explorer.exe >nul
timeout /nobreak /t 1 >nul
start "" "%winDir%\explorer.exe"
exit /b















:reboot_computer
if "%*" == "force" ( shutdown /r /t 7 & exit )

call :logo
echo.%language_reboot_computer01%
echo.
echo.
echo.%language_reboot_computer02%
echo.    %language_reboot_computer03%
echo.
echo.    %language_menuItem_goBack%
echo.
echo.
echo.
choice /c 10 /n /m "> "
set command=%errorLevel%



if "%command%" == "2" ( set command= & exit /b )

echo.%language_reboot_computer04%
shutdown /r /t 5
timeout /nobreak /t 5 >nul
exit