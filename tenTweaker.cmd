@echo off
chcp 65001>nul

setlocal EnableExtensions EnableDelayedExpansion

pushd "%~dp0"



for /f "tokens=1-5,* delims=- " %%i in ("%*") do (
  if "%%i" NEQ "" set key_%%i
  if "%%j" NEQ "" set key_%%j
  if "%%k" NEQ "" set key_%%k
  if "%%l" NEQ "" set key_%%l
  if "%%l" NEQ "" set key_%%m
)

if "%key_main_adminRightsChecking%" == ""                set key_main_adminRightsChecking=true
if "%key_main_reboot%" == ""                             set key_main_reboot=none
if "%key_main_registryMerge%" == ""                      set key_main_registryMerge=true
if "%key_tools_administrativeTools_hiddenOptions%" == "" set key_tools_administrativeTools_hiddenOptions=false

start /min powershell "Exit"

if "%key_main_adminRightsChecking%" == "true" (
  net session>nul 2>nul

  if !errorLevel! GEQ 1 (
    echo.^(^^^!^) Please, run as Admin
    timeout /nobreak /t 2 >nul
    exit
  )
)

if not exist temp md temp

set errorLevel=
reg query HKCU >nul 2>nul

(
  if %errorLevel% LSS 1 if "%key_main_registryMerge%" == "true" (
    reg export HKCU\Console\%%SystemRoot%%_system32_cmd.exe temp\consoleSettings.reg /y
    reg add    HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ColorTable00     /t REG_DWORD /d 0          /f
    reg add    HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FaceName         /t REG_SZ    /d Consolas   /f
    reg add    HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontFamily       /t REG_DWORD /d 0x0000036  /f
    reg add    HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontSize         /t REG_DWORD /d 0x00100008 /f
    reg add    HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v FontWeight       /t REG_DWORD /d 0x0000190  /f
    reg add    HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v ScreenBufferSize /t REG_DWORD /d 0x2329006a /f
    reg add    HKCU\Console\%%SystemRoot%%_system32_cmd.exe /v WindowSize       /t REG_DWORD /d 0x001e006e /f

    start "" "%~nx0" --main_adminRightsChecking=false --main_registryMerge=false
    exit
  ) else if exist temp\consoleSettings.reg (
    reg delete HKCU\Console\%%SystemRoot%%_system32_cmd.exe /va /f
    reg import temp\consoleSettings.reg
  )
)>nul 2>nul



set program_name=Ten Tweaker
set program_name_ns=%~n0
set program_version=3.0 Alpha 1
set program_version_number=30011

set module_choice=bin\choice.exe /n
set module_powershell=start /wait /min "" powershell
set module_wget=bin\wget.exe --quiet --no-check-certificate --tries=1

set appxMgmt=call bin\lib.cmd :appxMgmt
set getState=call bin\lib.cmd :getState
set logo=call bin\lib.cmd :logo
set main=call bin\main.cmd
set reboot_computer=call bin\main.cmd :reboot_computer
set restartExplorer=call bin\lib.cmd :restartExplorer
set sBuilder_build=call set sBuilder_text=%%sBuilder_text%%
set settings_apply=call bin\lib.cmd :settings_apply
set settings_import=for /f "eol=# delims=" %%i in ('type "settings.ini" 2^^^>nul') do call set setting_%%i
set settings_save=call bin\lib.cmd :settings_save



set update_version_output=temp\%program_name_ns%.version
set update_version_url=https://drive.google.com/uc?export=download^^^&id=1ZeM5bnX0fWs7njKL2ZTeYc2ctv0FmGRs

set setting_firstRun=true
set setting_language=english







%settings_import%

if "%setting_firstRun%" == "true" (
  set setting_firstRun=false
  %settings_apply%
  %main% :language_menu force
) else %settings_apply%

(
  if "%key_main_reboot%" == "services_sppsvc" (
    for /l %%i in (4,-1,1)  do rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 %~dp0res\tools_administrativeTools_unHookExec.inf
    for /l %%i in (4,-1,1)  do reg import res\services_sppsvc_registry.reg
    for /l %%i in (10,-1,1) do sc start sppsvc
    for /l %%i in (4,-1,1)  do reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v %program_name_ns%_services_sppsvc /f
    %reboot_computer% force
  ) else (
    %module_wget% "%update_version_url%" --output-document="%update_version_output%"

    for /f "tokens=1-3 delims=." %%i in (%update_version_output%) do (
      if "%%k" NEQ "" ( set update_program_version_number=%%i%%j%%k
      ) else set update_program_version_number=%%i%%j0
    )
    if !update_program_version_number! GTR %program_version_number% echo.>temp\return_update_available
  )
)>nul 2>nul

%main% :main_menu
exit