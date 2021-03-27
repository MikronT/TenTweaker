@echo off
chcp 65001>nul

call %*
exit /b







:logo
  mode con:cols=124 lines=39
  title [MikronT] %program_name%
  color 0b
  cls

  echo.
  echo.
  echo.    [MikronT] ==^> %program_name%
  echo.                  %lang_logo01%
  echo.   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  echo.     %lang_logo02%
  echo.         github.com/MikronT
  echo.
  echo.
  echo.
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
  taskkill /f /im explorer.exe >nul
  timeout /nobreak /t 1 >nul
  start explorer
exit /b







:appxMgmt
  if "%1" == "get"    %module_powershell% "Get-AppxPackage *Microsoft.* | Select Name | Out-File -FilePath '%cd%\temp\return_appxPackages' -Encoding ASCII"

  if "%1" == "check"  for /f "eol=- delims=" %%i in ('find /i "Microsoft.%2" "temp\return_appxPackages"') do if "%%i" NEQ "" set %3=installed

  if "%1" == "add"    %module_powershell% "Add-AppxPackage -Path ((Get-AppxPackage -AllUsers -Name """*Microsoft.%2*""").InstallLocation + """\AppxManifest.xml""") -Register -DisableDevelopmentMode"
  if "%1" == "remove" %module_powershell% "Get-AppxPackage *Microsoft.%2* | Remove-AppxPackage"
exit /b







:getState
set errorLevel=
reg query HKCU >nul 2>nul

if %errorLevel% GEQ 1 (
  set interface_desktop_objects_thisPC=error
  set interface_desktop_objects_recycleBin=error
  set interface_desktop_objects_controlPanel=error
  set interface_desktop_objects_userFolder=error
  set interface_desktop_objects_network=error
  set interface_desktop_logonBackgroundBlur=error

  set interface_taskBar_peopleBand=error
  set interface_taskBar_commandPromptOnWinX=error
  set interface_taskBar_taskViewButton=error
  set interface_taskBar_smallIcons=error
  set interface_taskBar_buttonsCombine=error

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

  set interface_input_keyboard_languageSwitch=error
  set interface_input_keyboard_layoutSwitch=error

  set interface_input_suggestions_auto=error
  set interface_input_suggestions_appendCompletion=error
  set interface_input_suggestions_startTrackProgs=error
  set interface_input_suggestions_whenTyping=error

  set services_windowsUpdate_updateCenter=error

  set services_sppsvc_service=error

  set tools_admin_taskManager=error
  set tools_admin_controlPanel=error
  set tools_admin_runDialog=error
  set tools_admin_registryTools=disabled
  set tools_admin_cmd=error
  set tools_admin_desktop=error

  set error_main_variables_disabledRegistryTools=1
  exit /b
) else set error_main_variables_disabledRegistryTools=0





if "%1" == "interface_desktop" (
  set interface_desktop_objects_thisPC=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D}') do if "%%i" == "0x0" set interface_desktop_objects_thisPC=shown)>nul 2>nul

  set interface_desktop_objects_recycleBin=shown
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E}') do if "%%i" == "0x1" set interface_desktop_objects_recycleBin=hidden)>nul 2>nul

  set interface_desktop_objects_controlPanel=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}') do if "%%i" == "0x0" set interface_desktop_objects_controlPanel=shown)>nul 2>nul

  set interface_desktop_objects_userFolder=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee}') do if "%%i" == "0x0" set interface_desktop_objects_userFolder=shown)>nul 2>nul

  set interface_desktop_objects_network=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C}') do if "%%i" == "0x0" set interface_desktop_objects_network=shown)>nul 2>nul
  
  set interface_desktop_logonBackgroundBlur=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\Software\Policies\Microsoft\Windows\System /v DisableAcrylicBackgroundOnLogon') do if "%%i" == "0x1" set interface_desktop_logonBackgroundBlur=disabled)>nul 2>nul
)





if "%1" == "interface_taskBar" (
  set interface_taskBar_peopleBand=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand') do if "%%i" == "0x1" set interface_taskBar_peopleBand=shown)>nul 2>nul

  set interface_taskBar_commandPromptOnWinX=powerShell
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX') do if "%%i" == "0x1" set interface_taskBar_commandPromptOnWinX=commandPrompt)>nul 2>nul

  set interface_taskBar_taskViewButton=shown
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton') do if "%%i" == "0x0" set interface_taskBar_taskViewButton=hidden)>nul 2>nul

  set interface_taskBar_smallIcons=disabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons') do if "%%i" == "0x1" set interface_taskBar_smallIcons=enabled)>nul 2>nul

  set interface_taskBar_buttonsCombine=always
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel') do (
    if "%%i" == "0x1" set interface_taskBar_buttonsCombine=when is full
    if "%%i" == "0x2" set interface_taskBar_buttonsCombine=never
  ))>nul 2>nul
)





if "%1" == "interface_explorer" (
  set interface_explorer_fileExtensions=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt') do if "%%i" == "0x0" set interface_explorer_fileExtensions=shown)>nul 2>nul

  set interface_explorer_hiddenFiles=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden') do if "%%i" == "0x1" set interface_explorer_hiddenFiles=shown)>nul 2>nul

  set interface_explorer_hiddenProtectedSystemFiles=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden') do if "%%i" == "0x1" set interface_explorer_hiddenProtectedSystemFiles=shown)>nul 2>nul

  set interface_explorer_emptyDrives=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideDrivesWithNoMedia') do if "%%i" == "0x0" set interface_explorer_emptyDrives=shown)>nul 2>nul

  set interface_explorer_folderMergeConflicts=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideMergeConflicts') do if "%%i" == "0x0" set interface_explorer_folderMergeConflicts=shown)>nul 2>nul

  set interface_explorer_ribbon=hidden
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon /v MinimizedStateTabletModeOff') do if "%%i" == "0x0" set interface_explorer_ribbon=shown)>nul 2>nul

  set interface_explorer_expandToCurrentFolder=disabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v NavPaneExpandToCurrentFolder') do if "%%i" == "0x1" set interface_explorer_expandToCurrentFolder=enabled)>nul 2>nul

  set interface_explorer_statusBar=shown
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowStatusBar') do if "%%i" == "0x0" set interface_explorer_statusBar=hidden)>nul 2>nul

  set interface_explorer_fileInfoTip=shown
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowInfoTip') do if "%%i" == "0x0" set interface_explorer_fileInfoTip=hidden)>nul 2>nul

  set interface_explorer_thisPC_desktop=shown
  (for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"') do if "%%i" == "0" set interface_explorer_thisPC_desktop=hidden)>nul 2>nul

  set interface_explorer_thisPC_documents=shown
  (for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{d3162b92-9365-467a-956b-92703aca08af}"') do if "%%i" == "0" set interface_explorer_thisPC_documents=hidden)>nul 2>nul

  set interface_explorer_thisPC_downloads=shown
  (for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{088e3905-0323-4b02-9826-5d99428e115f}"') do if "%%i" == "0" set interface_explorer_thisPC_downloads=hidden)>nul 2>nul

  set interface_explorer_thisPC_music=shown
  (for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"') do if "%%i" == "0" set interface_explorer_thisPC_music=hidden)>nul 2>nul

  set interface_explorer_thisPC_pictures=shown
  (for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"') do if "%%i" == "0" set interface_explorer_thisPC_pictures=hidden)>nul 2>nul

  set interface_explorer_thisPC_videos=shown
  (for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"') do if "%%i" == "0" set interface_explorer_thisPC_videos=hidden)>nul 2>nul

  set interface_explorer_thisPC_3DObjects=shown
  (for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace ^| find /i /c "{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"') do if "%%i" == "0" set interface_explorer_thisPC_3DObjects=hidden)>nul 2>nul

  set interface_explorer_oneDriveInNavbar=shown
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree') do if "%%i" == "0x0" set interface_explorer_oneDriveInNavbar=hidden)>nul 2>nul

  set interface_explorer_autoFolderTypeDiscovery=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType') do if "%%i" == "NotSpecified" set interface_explorer_autoFolderTypeDiscovery=disabled)>nul 2>nul
)





if "%1" == "interface_input" (
  set interface_input_keyboard_languageSwitch=leftAltShift
  (for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey"') do (
    if "%%i" == "3" set interface_input_keyboard_languageSwitch=notAssigned
    if "%%i" == "2" set interface_input_keyboard_languageSwitch=ctrlShift
    if "%%i" == "4" set interface_input_keyboard_languageSwitch=graveAccent
  ))>nul 2>nul

  set interface_input_keyboard_layoutSwitch=ctrlShift
  (for /f "skip=2 tokens=4,* delims= " %%i in ('reg query "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey"') do (
    if "%%i" == "3" set interface_input_keyboard_layoutSwitch=notAssigned
    if "%%i" == "1" set interface_input_keyboard_layoutSwitch=leftAltShift
    if "%%i" == "4" set interface_input_keyboard_layoutSwitch=graveAccent
  ))>nul 2>nul

  set interface_input_suggestions_auto=disabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest') do if "%%i" == "yes" set interface_input_suggestions_auto=enabled)>nul 2>nul

  set interface_input_suggestions_appendCompletion=disabled
  (for /f "skip=2 tokens=4,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion"') do if "%%i" == "yes" set interface_input_suggestions_appendCompletion=enabled)>nul 2>nul

  set interface_input_suggestions_startTrackProgs=disabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_TrackProgs') do if "%%i" == "0x1" set interface_input_suggestions_startTrackProgs=enabled)>nul 2>nul

  set interface_input_suggestions_whenTyping=disabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\Software\Microsoft\Input\Settings /v EnableHwkbTextPrediction') do if "%%i" == "0x1" set interface_input_suggestions_whenTyping=enabled)>nul 2>nul
)





if "%1" == "programs_system" (
  %appxMgmt% get

  set programs_system_program_3DBuilder=uninstalled
  %appxMgmt% check 3DBuilder programs_system_program_3DBuilder

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

  set programs_system_program_mixedRealityPortal=uninstalled
  %appxMgmt% check MixedReality.Portal programs_system_program_mixedRealityPortal

  set programs_system_program_mobilePlans=uninstalled
  %appxMgmt% check OneConnect programs_system_program_mobilePlans

  set programs_system_program_oneNote=uninstalled
  %appxMgmt% check Office.OneNote programs_system_program_oneNote

  set programs_system_program_print3D=uninstalled
  %appxMgmt% check Print3D programs_system_program_print3D

  set programs_system_program_people=uninstalled
  %appxMgmt% check People programs_system_program_people

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
  (for /f "delims=" %%i in ('dir /a:-d /b "%winDir%\System32\gpedit.msc"') do if "%%i" == "gpedit.msc" set programs_gpeditMSC_gpeditFile=exist)>nul 2>nul
)





if "%1" == "services_windowsUpdate" (
  set services_windowsUpdate_updateDistributions=unlocked
  (for /f "delims=" %%i in ('dir /a:-d /b "%WinDir%\SoftwareDistribution\Download"') do if "%%i" == "Download" set services_windowsUpdate_updateDistributions=locked)>nul 2>nul

  set services_windowsUpdate_updateCenter=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\wuauserv /v Start') do if "%%i" == "0x4" set services_windowsUpdate_updateCenter=disabled)>nul 2>nul
)





if "%1" == "services_sppsvc" (
  set services_sppsvc_service=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKLM\SYSTEM\ControlSet001\Services\sppsvc /v Start') do if "%%i" == "0x4" set services_sppsvc_service=disabled)>nul 2>nul
)





if "%1" == "tools_admin" (
  set tools_admin_desktop=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop') do if "%%i" == "0x1" set tools_admin_desktop=disabled)>nul 2>nul

  set tools_admin_controlPanel=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel') do if "%%i" == "0x1" set tools_admin_controlPanel=disabled)>nul 2>nul

  set tools_admin_runDialog=enabled
  (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun') do if "%%i" == "0x1" set tools_admin_runDialog=disabled)>nul 2>nul

  if "%key_tools_admin_hiddenOptions%" == "true" (
    set tools_admin_registryTools=enabled

    set tools_admin_cmd=enabled
    (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD') do if "%%i" == "0x1" set tools_admin_cmd=disabled)>nul 2>nul

    set tools_admin_taskManager=enabled
    (for /f "skip=2 tokens=3,* delims= " %%i in ('reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr') do if "%%i" == "0x1" set tools_admin_taskManager=disabled)>nul 2>nul
  )
)
exit /b