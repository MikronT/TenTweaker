@echo off
chcp 65001>nul

call %*
exit /b !errorLevel!







:init
  set exec=%1\%~nx0



  set logo=call !exec! :logo

  set settings_load=call !exec! :settings_load
  set settings_apply=call !exec! :settings_apply
  set settings_save=call !exec! :settings_save

  set restartExplorer=call !exec! :restartExplorer

  set appxMgmt=call !exec! :appxMgmt

  set getState=call !exec! :getState


  set exec=
exit /b















:settings_load
  for /f "eol=# delims=" %%i in ('type "settings.ini" 2^>nul') do call set setting_%%i
exit /b







:settings_apply
  set temp_lang_set=default english
  if "%setting_language%" NEQ "english" set temp_lang_set=!temp_lang_set! %setting_language%

  for %%i in (!temp_lang_set!) do for /f "eol=# delims=" %%j in ('type "res\lang\%%i.lang" 2^>nul') do call set lang_%%j
exit /b







:settings_save
  (
    echo.# %program_name% Settings #
    echo.
    echo.firstRun=%setting_firstRun%
    echo.language=%setting_language%
  )>settings.ini
exit /b















:restartExplorer
  (
    taskkill /f /im explorer.exe
    timeout /nobreak /t 1 
  )>nul
  start explorer
exit /b















:appxMgmt
  if "%1" == "get"    %module_powershell% "Get-AppxPackage *Microsoft.* | Select Name | Out-File -FilePath '%cd%\temp\appxPackages' -Encoding ASCII"

  if "%1" == "check"  for /f "eol=- delims=" %%i in ('find /i "Microsoft.%2" "temp\appxPackages"') do if "%%i" NEQ "" set %3=installed

  if "%1" == "add"    %module_powershell% "Add-AppxPackage -Path ((Get-AppxPackage -AllUsers -Name """*Microsoft.%2*""").InstallLocation + """\AppxManifest.xml""") -Register -DisableDevelopmentMode"
  if "%1" == "remove" %module_powershell% "Get-AppxPackage *Microsoft.%2* | Remove-AppxPackage"
exit /b















:getState
set errorLevel=
reg query HKCU >nul 2>nul

if %errorLevel% GEQ 1 (
  set interface_desktop_thisPC=error
  set interface_desktop_trash=error
  set interface_desktop_control=error
  set interface_desktop_userFolder=error
  set interface_desktop_net=error
  set interface_desktop_logonBlur=error

  set interface_taskbar_people=error
  set interface_taskbar_winXcmd=error
  set interface_taskbar_taskView=error
  set interface_taskbar_small=error
  set interface_taskbar_combined=error

  set interface_explorer_extensions=error
  set interface_explorer_hidden=error
  set interface_explorer_hiddenSys=error
  set interface_explorer_emptyDrives=error
  set interface_explorer_conflicts=error
  set interface_explorer_ribbon=error
  set interface_explorer_expand=error
  set interface_explorer_statusbar=error
  set interface_explorer_infoTip=error
  set interface_explorer_thisPC_desktop=error
  set interface_explorer_thisPC_documents=error
  set interface_explorer_thisPC_downloads=error
  set interface_explorer_thisPC_music=error
  set interface_explorer_thisPC_pictures=error
  set interface_explorer_thisPC_videos=error
  set interface_explorer_thisPC_3DObjects=error
  set interface_explorer_oneDrive=error
  set interface_explorer_autoType=error

  set interface_input_suggestions=error
  set interface_input_completion=error
  set interface_input_progTracking=error
  set interface_input_onTyping=error

  set interface_input_langKey=error
  set interface_input_layoutKey=error

  set services_wuaserv_center=error

  set services_sppsvc_sve=error

  set tools_admin_taskMgr=error
  set tools_admin_control=error
  set tools_admin_run=error
  set tools_admin_reg=disabled
  set tools_admin_cmd=error
  set tools_admin_desktop=error

  set error_reg=true
  exit /b
) else set error_reg=false





if "%1" == "interface_desktop" (
  set interface_desktop_thisPC=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D}') do if "%%i" == "0x0" set interface_desktop_thisPC=shown

  set interface_desktop_trash=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E}') do if "%%i" == "0x1" set interface_desktop_trash=hidden

  set interface_desktop_control=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}') do if "%%i" == "0x0" set interface_desktop_control=shown

  set interface_desktop_userFolder=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee}') do if "%%i" == "0x0" set interface_desktop_userFolder=shown

  set interface_desktop_net=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C}') do if "%%i" == "0x0" set interface_desktop_net=shown
  
  set interface_desktop_logonBlur=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\Software\Policies\Microsoft\Windows\System /v DisableAcrylicBackgroundOnLogon') do if "%%i" == "0x1" set interface_desktop_logonBlur=disabled
)>nul 2>nul





if "%1" == "interface_taskbar" (
  set interface_taskbar_people=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand') do if "%%i" == "0x1" set interface_taskbar_people=shown

  set interface_taskbar_winXcmd=ps
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX') do if "%%i" == "0x1" set interface_taskbar_winXcmd=cmd

  set interface_taskbar_taskView=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton') do if "%%i" == "0x0" set interface_taskbar_taskView=hidden

  set interface_taskbar_small=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons') do if "%%i" == "0x1" set interface_taskbar_small=enabled

  set interface_taskbar_combined=always
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel') do (
    if "%%i" == "0x1" set interface_taskbar_combined=ifFull
    if "%%i" == "0x2" set interface_taskbar_combined=never
  )
)>nul 2>nul





if "%1" == "interface_explorer" (
  set interface_explorer_extensions=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt') do if "%%i" == "0x0" set interface_explorer_extensions=shown

  set interface_explorer_hidden=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden') do if "%%i" == "0x1" set interface_explorer_hidden=shown

  set interface_explorer_hiddenSys=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden') do if "%%i" == "0x1" set interface_explorer_hiddenSys=shown

  set interface_explorer_emptyDrives=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideDrivesWithNoMedia') do if "%%i" == "0x0" set interface_explorer_emptyDrives=shown

  set interface_explorer_conflicts=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideMergeConflicts') do if "%%i" == "0x0" set interface_explorer_conflicts=shown

  set interface_explorer_ribbon=hidden
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon /v MinimizedStateTabletModeOff') do if "%%i" == "0x0" set interface_explorer_ribbon=shown

  set interface_explorer_expand=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v NavPaneExpandToCurrentFolder') do if "%%i" == "0x1" set interface_explorer_expand=enabled

  set interface_explorer_statusbar=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowStatusBar') do if "%%i" == "0x0" set interface_explorer_statusbar=hidden

  set interface_explorer_infoTip=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowInfoTip') do if "%%i" == "0x0" set interface_explorer_infoTip=hidden

  set interface_explorer_thisPC_desktop=shown
  for /f "delims=" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"') do if "%%i" == "0" set interface_explorer_thisPC_desktop=hidden

  set interface_explorer_thisPC_documents=shown
  for /f "delims=" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{d3162b92-9365-467a-956b-92703aca08af}"') do if "%%i" == "0" set interface_explorer_thisPC_documents=hidden

  set interface_explorer_thisPC_downloads=shown
  for /f "delims=" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{088e3905-0323-4b02-9826-5d99428e115f}"') do if "%%i" == "0" set interface_explorer_thisPC_downloads=hidden

  set interface_explorer_thisPC_music=shown
  for /f "delims=" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"') do if "%%i" == "0" set interface_explorer_thisPC_music=hidden

  set interface_explorer_thisPC_pictures=shown
  for /f "delims=" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"') do if "%%i" == "0" set interface_explorer_thisPC_pictures=hidden

  set interface_explorer_thisPC_videos=shown
  for /f "delims=" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"') do if "%%i" == "0" set interface_explorer_thisPC_videos=hidden

  set interface_explorer_thisPC_3DObjects=shown
  for /f "delims=" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"') do if "%%i" == "0" set interface_explorer_thisPC_3DObjects=hidden

  set interface_explorer_oneDrive=shown
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree') do if "%%i" == "0x0" set interface_explorer_oneDrive=hidden

  set interface_explorer_autoType=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType') do if "%%i" == "NotSpecified" set interface_explorer_autoType=disabled
)>nul 2>nul





if "%1" == "interface_input" (
  set interface_input_suggestions=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest') do if "%%i" == "yes" set interface_input_suggestions=enabled

  set interface_input_completion=disabled
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion"') do if "%%i" == "yes" set interface_input_completion=enabled

  set interface_input_progTracking=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs') do if "%%i" == "0x1" set interface_input_progTracking=enabled

  set interface_input_onTyping=disabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Input\Settings /v EnableHwkbTextPrediction') do if "%%i" == "0x1" set interface_input_onTyping=enabled

  set interface_input_langKey=leftAltShift
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey"') do (
    if "%%i" == "3" set interface_input_langKey=notAssigned
    if "%%i" == "2" set interface_input_langKey=ctrlShift
    if "%%i" == "4" set interface_input_langKey=graveAccent
  )

  set interface_input_layoutKey=ctrlShift
  for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey"') do (
    if "%%i" == "3" set interface_input_layoutKey=notAssigned
    if "%%i" == "1" set interface_input_layoutKey=leftAltShift
    if "%%i" == "4" set interface_input_layoutKey=graveAccent
  )
)>nul 2>nul





if "%1" == "programs_system" (
  %appxMgmt% get

  set programs_system_3DBuilder=uninstalled
  %appxMgmt% check 3DBuilder programs_system_3DBuilder

  set programs_system_3DViewer=uninstalled
  %appxMgmt% check Microsoft3DViewer programs_system_3DViewer

  set programs_system_feedback=uninstalled
  %appxMgmt% check WindowsFeedbackHub programs_system_feedback

  set programs_system_getHelp=uninstalled
  %appxMgmt% check GetHelp programs_system_getHelp

  set programs_system_mailCal=uninstalled
  %appxMgmt% check WindowsCommunicationsApps programs_system_mailCal

  set programs_system_maps=uninstalled
  %appxMgmt% check WindowsMaps programs_system_maps

  set programs_system_messaging=uninstalled
  %appxMgmt% check Messaging programs_system_messaging

  set programs_system_portal=uninstalled
  %appxMgmt% check MixedReality.Portal programs_system_portal

  set programs_system_mobPlans=uninstalled
  %appxMgmt% check OneConnect programs_system_mobPlans

  set programs_system_oneNote=uninstalled
  %appxMgmt% check Office.OneNote programs_system_oneNote

  set programs_system_print3D=uninstalled
  %appxMgmt% check Print3D programs_system_print3D

  set programs_system_people=uninstalled
  %appxMgmt% check People programs_system_people

  set programs_system_solitare=uninstalled
  %appxMgmt% check MicrosoftSolitaireCollection programs_system_solitare

  set programs_system_tips=uninstalled
  %appxMgmt% check GetStarted programs_system_tips

  set programs_system_yourPhone=uninstalled
  %appxMgmt% check YourPhone programs_system_yourPhone


  set programs_system_clock=uninstalled
  %appxMgmt% check WindowsAlarms programs_system_clock

  set programs_system_camera=uninstalled
  %appxMgmt% check WindowsCamera programs_system_camera

  set programs_system_gameBar=uninstalled
  set programs_system_gameBar1=uninstalled
  set programs_system_gameBar2=uninstalled
  %appxMgmt% check XboxGameOverlay   programs_system_gameBar1
  %appxMgmt% check XboxGamingOverlay programs_system_gameBar2
  if "%programs_system_gameBar1%" == "%programs_system_gameBar2%" if "%programs_system_gameBar1%" == "installed" set programs_system_gameBar=installed

  set programs_system_music=uninstalled
  %appxMgmt% check ZuneMusic programs_system_music

  set programs_system_movies=uninstalled
  %appxMgmt% check ZuneVideo programs_system_movies

  set programs_system_office=uninstalled
  %appxMgmt% check MicrosoftOfficeHub programs_system_office

  set programs_system_paint3D=uninstalled
  %appxMgmt% check MSPaint programs_system_paint3D

  set programs_system_photos=uninstalled
  %appxMgmt% check Windows.Photos programs_system_photos

  set programs_system_skype=uninstalled
  %appxMgmt% check SkypeApp programs_system_skype

  set programs_system_snip=uninstalled
  %appxMgmt% check ScreenSketch programs_system_snip

  set programs_system_notes=uninstalled
  %appxMgmt% check MicrosoftStickyNotes programs_system_notes

  set programs_system_store=uninstalled
  %appxMgmt% check WindowsStore programs_system_store

  set programs_system_rec=uninstalled
  %appxMgmt% check WindowsSoundRecorder programs_system_rec

  set programs_system_weather=uninstalled
  %appxMgmt% check BingWeather programs_system_weather

  set programs_system_xbox=uninstalled
  %appxMgmt% check XboxApp programs_system_xbox
)





if "%1" == "programs_office" (
  set programs_office_setupURL=https://onedrive.live.com/download?cid=D3AF852448CB4BF6^&resid=D3AF852448CB4BF6%%21259^&authkey=AAK3Qw80R8to-VE
  set programs_office_setupISO=temp\programs_office_microsoftOfficeProfessionalPlus2016Setup.iso
)





if "%1" == "programs_gpeditMSC" (
  set programs_gpeditMSC_packagesList=temp\programs_gpeditMSC_packagesList.txt

  set programs_gpeditMSC_file=notExist
  for /f "delims=" %%i in ('dir /a:-d /b "%winDir%\System32\gpedit.msc"') do if "%%i" == "gpedit.msc" set programs_gpeditMSC_file=exist
)>nul 2>nul





if "%1" == "services_wuaserv" (
  set services_wuaserv_distrs=unlocked
  for /f "delims=" %%i in ('dir /a:-d /b "%WinDir%\SoftwareDistribution\Download"') do if "%%i" == "Download" set services_wuaserv_distrs=locked

  set services_wuaserv_center=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\System\ControlSet001\Services\wuauserv /v Start') do if "%%i" == "0x4" set services_wuaserv_center=disabled
)>nul 2>nul





if "%1" == "services_sppsvc" (
  set services_sppsvc_sve=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\System\ControlSet001\Services\sppsvc /v Start') do if "%%i" == "0x4" set services_sppsvc_sve=disabled
)>nul 2>nul





if "%1" == "tools_admin" (
  set tools_admin_desktop=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop') do if "%%i" == "0x1" set tools_admin_desktop=disabled

  set tools_admin_control=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel') do if "%%i" == "0x1" set tools_admin_control=disabled

  set tools_admin_run=enabled
  for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun') do if "%%i" == "0x1" set tools_admin_run=disabled

  if "%key_hiddenOptions%" == "true" (
    set tools_admin_reg=enabled

    set tools_admin_cmd=enabled
    for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD') do if "%%i" == "0x1" set tools_admin_cmd=disabled

    set tools_admin_taskMgr=enabled
    for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr') do if "%%i" == "0x1" set tools_admin_taskMgr=disabled
  )
)>nul 2>nul
exit /b