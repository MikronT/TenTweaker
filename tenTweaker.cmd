@echo off
chcp 65001>nul

setlocal EnableExtensions EnableDelayedExpansion

pushd "%~dp0"



set program_name=Ten Tweaker
set program_name_ns=%~n0
set program_version=3.0 Alpha 1
set program_version_number=30011



set module_choice=bin\choice.exe /n
set module_elevate=bin\elevate.vbs
set module_powershell=start /wait /min "" powershell -ep bypass -nop -w 1
set module_wget=bin\wget.exe --quiet --no-check-certificate --tries=1

for /f "delims=" %%i in ('dir /a:-d /b "bin\*.cmd" 2^>nul') do call "bin\%%i" :init bin

set sBuilder_build=call set sBuilder_text=%%sBuilder_text%%



set key_elevate=false
set key_hiddenOptions=false
set key_reboot=null
set key_skipRegMerge=false

:parser
  set temp_key=%1
  set temp_value=%2
  if "!temp_key!" NEQ "" set temp_key=!temp_key:"=!
  if "!temp_key!" NEQ "" (
    set temp_key=!temp_key:~1!
                    if /i "!temp_key!" == "elevate"       ( set key_!temp_key!=true
             ) else if /i "!temp_key!" == "hiddenOptions" ( set key_!temp_key!=true
             ) else if /i "!temp_key!" == "reboot"        ( set key_!temp_key!=!temp_value:"=!
    shift /1 )
    shift /1
    goto :parser
  )

set setting_firstRun=true
set setting_language=english

net session>nul 2>nul
if "!errorLevel!" == "0" (
       set state_admin_privileges=true
) else set state_admin_privileges=false

set update_version_output=temp\%program_name_ns%.version
set update_version_url=https://drive.google.com/uc?export=download^^^&id=1ZeM5bnX0fWs7njKL2ZTeYc2ctv0FmGRs





if "%key_elevate%" == "false" if "%state_admin_privileges%" == "false" (
  set args=
  if "%key_hiddenOptions%" ==  "true" set args=!args! /hiddenOptions
  if "%key_reboot%"        NEQ "null" set args=!args! /reboot !key_reboot!

  %module_elevate% "%cd%" "%~nx0" !args! /elevate
  exit
)



if not exist "temp" md "temp"



%settings_load%

if "%setting_firstRun%" == "true" (
  set setting_firstRun=false
  %settings_apply%
  %main% :language_menu force
) else %settings_apply%



(
  if "%key_reboot%" == "sppsvc" (
    for /l %%i in (1,1, 4) do rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 %cd%\res\unHookExec.inf
    for /l %%i in (1,1, 4) do reg import res\sppsvc.reg
    for /l %%i in (1,1,10) do sc start sppsvc
    for /l %%i in (1,1, 4) do reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v %program_name_ns%_services_sppsvc /f
    %rebootComputer% force
  ) else (
    %module_wget% "%update_version_url%" --output-document="%update_version_output%"

    for /f "tokens=1-3 delims=." %%i in (%update_version_output%) do (
      if "%%k" NEQ "" (
             set update_program_version_number=%%i%%j%%k
      ) else set update_program_version_number=%%i%%j0
    )
    if !update_program_version_number! GTR %program_version_number% echo.>temp\return_update_available
  )
)>nul 2>nul



%main% :main_menu
exit