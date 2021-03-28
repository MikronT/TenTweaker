@echo off
chcp 65001>nul

call %*
exit /b















:language_menu
%logo%
echo.^(i^) %lang_lang_menu01%
echo.
echo.
echo.^(^>^) %lang_lang_menu02%
echo.    ^(1^) English
echo.    ^(2^) Português
echo.    ^(3^) Русский
echo.    ^(4^) Українська
if "%1" NEQ "force" (
  echo.
  echo.    ^(0^) %lang_menuItem_goBack%
)
echo.
echo.
echo.
if "%1" NEQ "force" (
       %module_choice% /c 12340 /m "> "
) else %module_choice% /c 1234  /m "> "
set command=%errorLevel%



if "%command%" == "1" ( set setting_language=english
) else if "%command%" == "2" ( set setting_language=portuguese
) else if "%command%" == "3" ( set setting_language=russian
) else if "%command%" == "4"   set setting_language=ukrainian

%settings_apply%
exit /b















:main_menu
%getState%
%settings_save%

if exist temp\return_update_available set update_available=true

%logo%
echo.  %lang_main_menu01%
echo.  %lang_main_menu02%
echo.  %lang_main_menu03%
echo.  %lang_main_menu04%
echo.  %lang_main_menu05%
echo.  %lang_main_menu06%
echo.  %lang_main_menu07%
echo.  %lang_main_menu08%
echo.  %lang_main_menu09%
echo.
echo.
echo.    ^(L^) %lang_main_menu10%
echo.    ^(0^) %lang_main_menu11%
echo.
echo.
echo.^(^^^!^) %lang_eula%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg main_menu
if "%update_available%" == "true" (
  echo.    ^(^^^!^) %lang_message_update_available01%
  echo.        %lang_message_update_available02% github.com/MikronT/TenTweaker/releases/latest
  echo.
)
%module_choice% /c 123456789ABL0 /m "> "
set command=%errorLevel%



if "%command%" == "1" ( call :interface_desktop
) else if "%command%" == "2"  ( call :interface_taskBar
) else if "%command%" == "3"  ( call :interface_explorer
) else if "%command%" == "4"  ( call :interface_input
) else if "%command%" == "5"  ( call :programs_system
) else if "%command%" == "6"  ( call :programs_office
) else if "%command%" == "7"  ( call :programs_gpeditMSC
) else if "%command%" == "8"  ( call :services_windowsUpdate
) else if "%command%" == "9"  ( call :services_sppsvc
) else if "%command%" == "10" ( call :tools_admin
) else if "%command%" == "11" ( call :tools_syscheck
) else if "%command%" == "12" ( call :language_menu
) else if "%command%" == "13" ( rd /s /q temp & exit )
goto :main_menu















:interface_desktop
%getState% interface_desktop

%logo%
echo.^(i^) %lang_interface_desktop01%
echo.
echo.
echo.^(^>^) %lang_interface_desktop02%

set sBuilder_text=^(1^) %lang_interface_desktop03%
       if "%interface_desktop_objects_thisPC%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_objects_thisPC%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                       %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(4^) %lang_interface_desktop04%
       if "%interface_desktop_objects_userFolder%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_objects_userFolder%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_desktop05%
       if "%interface_desktop_objects_recycleBin%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_objects_recycleBin%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(5^) %lang_interface_desktop06%
       if "%interface_desktop_objects_network%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_objects_network%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                        %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_desktop07%
       if "%interface_desktop_objects_controlPanel%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_objects_controlPanel%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                             %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.

set sBuilder_text=^(6^) %lang_interface_desktop08%
       if "%interface_desktop_logonBackgroundBlur%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_desktop_logonBackgroundBlur%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                              %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_interface_desktop09%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
%module_choice% /c 123456Y0 /m "> "
set command=%errorLevel%



if "%error_state_reg%" NEQ "1" (
  if "%command%" == "1" (
    if "%interface_desktop_objects_thisPC%"       == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_desktop_objects_recycleBin%"   == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_desktop_objects_controlPanel%" == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_desktop_objects_userFolder%"   == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
    if "%interface_desktop_objects_network%"      == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "6" (
    if "%interface_desktop_logonBackgroundBlur%" == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKLM\Software\Policies\Microsoft\Windows\System /v DisableAcrylicBackgroundOnLogon /t REG_DWORD /d !temp_cmd! /f
  )
)>nul 2>nul
if "%command%" == "7" ( %restartExplorer%
) else if "%command%" == "8" ( set command= & exit /b )
goto :interface_desktop















:interface_taskBar
%getState% interface_taskBar

%logo%
echo.^(i^) %lang_interface_taskBar01%
echo.
echo.
echo.^(^>^) %lang_interface_taskBar02%

set sBuilder_text=^(1^) %lang_interface_taskBar03%
       if "%interface_taskBar_peopleBand%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_taskBar_peopleBand%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(4^) %lang_interface_taskBar04%
       if "%interface_taskBar_smallIcons%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_taskBar_smallIcons%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_taskBar05%
       if "%interface_taskBar_commandPromptOnWinX%" == "powerShell"    ( %sBuilder_build% %lang_sBuilder_powerShell%
) else if "%interface_taskBar_commandPromptOnWinX%" == "commandPrompt" ( %sBuilder_build% %lang_sBuilder_commandPrompt%
) else                                                                   %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(5^) %lang_interface_taskBar06%
       if "%interface_taskBar_buttonsCombine%" == "always" ( %sBuilder_build% %lang_sBuilder_always%
) else if "%interface_taskBar_buttonsCombine%" == "ifRoom" ( %sBuilder_build% %lang_sBuilder_whenIsFull%
) else if "%interface_taskBar_buttonsCombine%" == "never"  ( %sBuilder_build% %lang_sBuilder_never%
) else                                                       %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_taskBar07%
       if "%interface_taskBar_taskViewButton%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_taskBar_taskViewButton%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                       %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_interface_taskBar08%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
%module_choice% /c 12345Y0 /m "> "
set command=%errorLevel%



if "%error_state_reg%" NEQ "1" (
  if "%command%" == "1" (
    if "%interface_taskBar_peopleBand%"          == "shown"      ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand       /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_taskBar_commandPromptOnWinX%" == "powerShell" ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_taskBar_taskViewButton%"      == "shown"      ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton      /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_taskBar_smallIcons%"          == "disabled"   ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons       /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
    if "%interface_taskBar_buttonsCombine%"      == "always"     ( set temp_cmd=1 ) else if "%interface_taskBar_buttonsCombine%" == "ifRoom" ( set temp_cmd=2 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel        /t REG_DWORD /d !temp_cmd! /f
  )
)>nul 2>nul
if "%command%" == "6" ( %restartExplorer%
) else if "%command%" == "7" ( set command= & exit /b )
goto :interface_taskBar















:interface_explorer
%getState% interface_explorer

%logo%
echo.^(i^) %lang_interface_explorer01%
echo.
echo.
echo.^(^>^) %lang_interface_explorer02%

set sBuilder_text=^(1^) %lang_interface_explorer03%
       if "%interface_explorer_fileExtensions%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_fileExtensions%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                        %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(6^) %lang_interface_explorer04%
       if "%interface_explorer_ribbon%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_ribbon%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_explorer05%
       if "%interface_explorer_hiddenFiles%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_hiddenFiles%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(7^) %lang_interface_explorer06%
       if "%interface_explorer_expandToCurrentFolder%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_explorer_expandToCurrentFolder%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_explorer07%
       if "%interface_explorer_hiddenProtectedSystemFiles%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_hiddenProtectedSystemFiles%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                                    %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(8^) %lang_interface_explorer08%
       if "%interface_explorer_statusBar%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_statusBar%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(4^) %lang_interface_explorer09%
       if "%interface_explorer_emptyDrives%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_emptyDrives%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(9^) %lang_interface_explorer10%
       if "%interface_explorer_fileInfoTip%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_fileInfoTip%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(5^) %lang_interface_explorer11%
       if "%interface_explorer_folderMergeConflicts%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_folderMergeConflicts%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                              %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_interface_explorer12%

set sBuilder_text=^(A^) %lang_interface_explorer13%
       if "%interface_explorer_thisPC_desktop%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_thisPC_desktop%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                        %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(E^) %lang_interface_explorer14%
       if "%interface_explorer_thisPC_pictures%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_thisPC_pictures%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                         %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(B^) %lang_interface_explorer15%
       if "%interface_explorer_thisPC_documents%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_thisPC_documents%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                          %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(F^) %lang_interface_explorer16%
       if "%interface_explorer_thisPC_videos%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_thisPC_videos%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                       %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(C^) %lang_interface_explorer17%
       if "%interface_explorer_thisPC_downloads%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_thisPC_downloads%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                          %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(G^) %lang_interface_explorer18%
       if "%interface_explorer_thisPC_3DObjects%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_thisPC_3DObjects%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                          %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(D^) %lang_interface_explorer19%
       if "%interface_explorer_thisPC_music%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_thisPC_music%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                      %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(H^) %lang_interface_explorer20%
       if "%interface_explorer_oneDriveInNavbar%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_oneDriveInNavbar%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                          %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%
echo.

set sBuilder_text=^(I^) %lang_interface_explorer21%
       if "%interface_explorer_autoFolderTypeDiscovery%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_explorer_autoFolderTypeDiscovery%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_interface_explorer22%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
%module_choice% /c 123456789ABCDEFGHIY0 /m "> "
set command=%errorLevel%



if "%error_state_reg%" NEQ "1" (
  if "%command%" == "1" (
    if "%interface_explorer_fileExtensions%"             == "hidden"   ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt                  /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_explorer_hiddenFiles%"                == "hidden"   ( set temp_cmd=1 ) else set temp_cmd=2
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden                       /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_explorer_hiddenProtectedSystemFiles%" == "hidden"   ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden              /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_explorer_emptyDrives%"                == "hidden"   ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideDrivesWithNoMedia        /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
    if "%interface_explorer_folderMergeConflicts%"       == "hidden"   ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideMergeConflicts           /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "6" (
    if "%interface_explorer_ribbon%"                     == "hidden"   ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon   /v MinimizedStateTabletModeOff  /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "7" (
    if "%interface_explorer_expandToCurrentFolder%"      == "disabled" ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v NavPaneExpandToCurrentFolder /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "8" (
    if "%interface_explorer_statusBar%"                  == "shown"    ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowStatusBar                /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "9" (
    if "%interface_explorer_fileInfoTip%"                == "shown"    ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowInfoTip                  /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "10" (
    if "%interface_explorer_thisPC_desktop%"   == "shown" ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641} /f

  ) else if "%command%" == "11" (
    if "%interface_explorer_thisPC_documents%" == "shown" ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af} /f

  ) else if "%command%" == "12" (
    if "%interface_explorer_thisPC_downloads%" == "shown" ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f} /f

  ) else if "%command%" == "13" (
    if "%interface_explorer_thisPC_music%"     == "shown" ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} /f

  ) else if "%command%" == "14" (
    if "%interface_explorer_thisPC_pictures%"  == "shown" ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8} /f

  ) else if "%command%" == "15" (
    if "%interface_explorer_thisPC_videos%"    == "shown" ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} /f

  ) else if "%command%" == "16" (
    if "%interface_explorer_thisPC_3DObjects%" == "shown" ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A} /f

  ) else if "%command%" == "17" (
    if "%interface_explorer_oneDriveInNavbar%" == "shown" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "18" (
    if "%interface_explorer_autoFolderTypeDiscovery%" == "enabled" (
           reg add    "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_SZ /d NotSpecified /f
    ) else reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /f
  )
)>nul 2>nul
if "%command%" == "19" ( %restartExplorer%
) else if "%command%" == "20" ( set command= & exit /b )
goto :interface_explorer















:interface_input
%getState% interface_input
if "%error_state_reg%" NEQ "1" if "%interface_input_keyboard_languageSwitch%" == "%interface_input_keyboard_layoutSwitch%" (
  if "%interface_input_keyboard_languageSwitch%" NEQ "notAssigned" (
    set error_interface_input_keyboard_keySequence_twoIdentical=1
  ) else set error_interface_input_keyboard_keySequence_twoIdentical=0
) else set error_interface_input_keyboard_keySequence_twoIdentical=0

%logo%
echo.^(i^) %lang_interface_input01%
echo.
echo.
echo.^(^>^) %lang_interface_input02%

set sBuilder_text=^(1^) %lang_interface_input03%
       if "%interface_input_suggestions_auto%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_suggestions_auto%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                         %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_input04%
       if "%interface_input_suggestions_appendCompletion%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_suggestions_appendCompletion%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                                     %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_input05%
       if "%interface_input_suggestions_startTrackProgs%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_suggestions_startTrackProgs%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                                    %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(4^) %lang_interface_input06%
       if "%interface_input_suggestions_whenTyping%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_suggestions_whenTyping%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                               %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.^(^>^) %lang_interface_input07%

set sBuilder_text=^(5^) %lang_interface_input08%
       if "%interface_input_keyboard_languageSwitch%" == "notAssigned"  ( %sBuilder_build% %lang_sBuilder_notAssigned%
) else if "%interface_input_keyboard_languageSwitch%" == "ctrlShift"    ( %sBuilder_build% %lang_sBuilder_ctrlShift%
) else if "%interface_input_keyboard_languageSwitch%" == "leftAltShift" ( %sBuilder_build% %lang_sBuilder_leftAltShift%
) else if "%interface_input_keyboard_languageSwitch%" == "graveAccent"  ( %sBuilder_build% %lang_sBuilder_graveAccent%
) else                                                                    %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(6^) %lang_interface_input09%
       if "%interface_input_keyboard_layoutSwitch%" == "notAssigned"  ( %sBuilder_build% %lang_sBuilder_notAssigned%
) else if "%interface_input_keyboard_layoutSwitch%" == "ctrlShift"    ( %sBuilder_build% %lang_sBuilder_ctrlShift%
) else if "%interface_input_keyboard_layoutSwitch%" == "leftAltShift" ( %sBuilder_build% %lang_sBuilder_leftAltShift%
) else if "%interface_input_keyboard_layoutSwitch%" == "graveAccent"  ( %sBuilder_build% %lang_sBuilder_graveAccent%
) else                                                                  %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.

if "%error_state_reg%" == "1" call :message_error_state_reg
if "%error_interface_input_keyboard_keySequence_twoIdentical%" == "1" (
  color 0c
  echo.    ^(^^^!^) %lang_message_error_interface_input_keyboard_keySequence_twoIdentical%
  echo.
) else color 0b

%module_choice% /c 1234560 /m "> "
set command=%errorLevel%



if "%error_state_reg%" NEQ "1" (
  if "%command%" == "1" (
    if "%interface_input_suggestions_auto%"             == "disabled"    ( set temp_cmd=yes ) else set temp_cmd=no
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest         /t REG_SZ    /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_input_suggestions_appendCompletion%" == "disabled"    ( set temp_cmd=yes ) else set temp_cmd=no
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ    /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_input_suggestions_startTrackProgs%"  == "disabled"    ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced     /v Start_TrackProgs    /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_input_suggestions_whenTyping%"       == "disabled"    ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Input\Settings /v EnableHwkbTextPrediction /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
           if "%interface_input_keyboard_languageSwitch%" == "notAssigned"  ( set temp_cmd=2
    ) else if "%interface_input_keyboard_languageSwitch%" == "ctrlShift"    ( set temp_cmd=1
    ) else if "%interface_input_keyboard_languageSwitch%" == "leftAltShift" ( set temp_cmd=4
    ) else if "%interface_input_keyboard_languageSwitch%" == "graveAccent"    set temp_cmd=3
    reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d !temp_cmd! /f

  ) else if "%command%" == "6" (
           if "%interface_input_keyboard_layoutSwitch%"   == "notAssigned"  ( set temp_cmd=2
    ) else if "%interface_input_keyboard_layoutSwitch%"   == "ctrlShift"    ( set temp_cmd=1
    ) else if "%interface_input_keyboard_layoutSwitch%"   == "leftAltShift" ( set temp_cmd=4
    ) else if "%interface_input_keyboard_layoutSwitch%"   == "graveAccent"    set temp_cmd=3
    reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey"   /t REG_SZ /d !temp_cmd! /f
  )
)>nul 2>nul
if "%command%" == "7" if "%error_interface_input_keyboard_keySequence_twoIdentical%" NEQ "1" ( set command= & exit /b )
goto :interface_input















:programs_system
%getState% programs_system

%logo%
echo.^(i^) %lang_programs_system01%
echo.
echo.
echo.^(^>^) %lang_programs_system02%

set sBuilder_text=^(1^) %lang_programs_system03%
       if "%programs_system_program_3DBuilder%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_3DBuilder%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                             %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(G^) %lang_programs_system04%
       if "%programs_system_program_alarmsClock%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_alarmsClock%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                               %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_programs_system05%
       if "%programs_system_program_3DViewer%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_3DViewer%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                            %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(H^) %lang_programs_system06%
       if "%programs_system_program_camera%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_camera%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                          %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_programs_system07%
       if "%programs_system_program_feedbackHub%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_feedbackHub%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                               %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(I^) %lang_programs_system08%
       if "%programs_system_program_gameBar%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_gameBar%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(4^) %lang_programs_system09%
       if "%programs_system_program_getHelp%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_getHelp%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(J^) %lang_programs_system10%
       if "%programs_system_program_grooveMusic%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_grooveMusic%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                               %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(5^) %lang_programs_system11%
       if "%programs_system_program_mailCalendar%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_mailCalendar%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                                %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(K^) %lang_programs_system12%
       if "%programs_system_program_moviesTV%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_moviesTV%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                            %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(6^) %lang_programs_system13%
       if "%programs_system_program_maps%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_maps%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                        %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(L^) %lang_programs_system14%
       if "%programs_system_program_myOffice%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_myOffice%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                            %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(7^) %lang_programs_system15%
       if "%programs_system_program_messaging%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_messaging%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                             %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(M^) %lang_programs_system16%
       if "%programs_system_program_paint3D%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_paint3D%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(8^) %lang_programs_system17%
       if "%programs_system_program_mixedRealityPortal%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_mixedRealityPortal%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                                      %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(N^) %lang_programs_system18%
       if "%programs_system_program_photos%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_photos%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                          %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(9^) %lang_programs_system19%
       if "%programs_system_program_mobilePlans%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_mobilePlans%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                               %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(O^) %lang_programs_system20%
       if "%programs_system_program_skype%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_skype%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                         %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(A^) %lang_programs_system21%
       if "%programs_system_program_oneNote%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_oneNote%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(P^) %lang_programs_system22%
       if "%programs_system_program_snipSketch%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_snipSketch%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                              %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(B^) %lang_programs_system23%
       if "%programs_system_program_people%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_people%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                          %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(Q^) %lang_programs_system24%
       if "%programs_system_program_stickyNotes%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_stickyNotes%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                               %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(C^) %lang_programs_system25%
       if "%programs_system_program_print3D%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_print3D%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(R^) %lang_programs_system26%
       if "%programs_system_program_store%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_store%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                         %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(D^) %lang_programs_system27%
       if "%programs_system_program_solitare%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_solitare%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                            %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(S^) %lang_programs_system28%
       if "%programs_system_program_voiceRecorder%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_voiceRecorder%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(E^) %lang_programs_system29%
       if "%programs_system_program_tips%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_tips%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                        %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(T^) %lang_programs_system30%
       if "%programs_system_program_weather%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_weather%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                           %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(F^) %lang_programs_system31%
       if "%programs_system_program_yourPhone%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_yourPhone%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                             %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(U^) %lang_programs_system32%
       if "%programs_system_program_xbox%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_program_xbox%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                        %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(V^) %lang_programs_system33%
echo.    ^(W^) %lang_programs_system34%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
%module_choice% /c 123456789ABCDEFGHIJKLMNOPQRSTUVW0 /m "> "
set command=%errorLevel%



if "%error_state_reg%" NEQ "1" (
         if "%command%" == "1"  ( if "%programs_system_program_3DBuilder%"          == "installed" ( %appxMgmt% remove 3DBuilder                    ) else %appxMgmt% add 3DBuilder
  ) else if "%command%" == "2"  ( if "%programs_system_program_3DViewer%"           == "installed" ( %appxMgmt% remove Microsoft3DViewer            ) else %appxMgmt% add Microsoft3DViewer
  ) else if "%command%" == "3"  ( if "%programs_system_program_feedbackHub%"        == "installed" ( %appxMgmt% remove WindowsFeedbackHub           ) else %appxMgmt% add WindowsFeedbackHub
  ) else if "%command%" == "4"  ( if "%programs_system_program_getHelp%"            == "installed" ( %appxMgmt% remove GetHelp                      ) else %appxMgmt% add GetHelp
  ) else if "%command%" == "5"  ( if "%programs_system_program_mailCalendar%"       == "installed" ( %appxMgmt% remove WindowsCommunicationsApps    ) else %appxMgmt% add WindowsCommunicationsApps
  ) else if "%command%" == "6"  ( if "%programs_system_program_maps%"               == "installed" ( %appxMgmt% remove WindowsMaps                  ) else %appxMgmt% add WindowsMaps
  ) else if "%command%" == "7"  ( if "%programs_system_program_messaging%"          == "installed" ( %appxMgmt% remove Messaging                    ) else %appxMgmt% add Messaging
  ) else if "%command%" == "8"  ( if "%programs_system_program_mixedRealityPortal%" == "installed" ( %appxMgmt% remove MixedReality.Portal          ) else %appxMgmt% add MixedReality.Portal
  ) else if "%command%" == "9"  ( if "%programs_system_program_mobilePlans%"        == "installed" ( %appxMgmt% remove OneConnect                   ) else %appxMgmt% add OneConnect
  ) else if "%command%" == "10" ( if "%programs_system_program_oneNote%"            == "installed" ( %appxMgmt% remove Office.OneNote               ) else %appxMgmt% add Office.OneNote
  ) else if "%command%" == "11" ( if "%programs_system_program_people%"             == "installed" ( %appxMgmt% remove People                       ) else %appxMgmt% add People
  ) else if "%command%" == "12" ( if "%programs_system_program_print3D%"            == "installed" ( %appxMgmt% remove Print3D                      ) else %appxMgmt% add Print3D
  ) else if "%command%" == "13" ( if "%programs_system_program_solitare%"           == "installed" ( %appxMgmt% remove MicrosoftSolitaireCollection ) else %appxMgmt% add MicrosoftSolitaireCollection
  ) else if "%command%" == "14" ( if "%programs_system_program_tips%"               == "installed" ( %appxMgmt% remove GetStarted                   ) else %appxMgmt% add GetStarted
  ) else if "%command%" == "15" ( if "%programs_system_program_yourPhone%"          == "installed" ( %appxMgmt% remove YourPhone                    ) else %appxMgmt% add YourPhone
  ) else if "%command%" == "16" ( if "%programs_system_program_alarmsClock%"        == "installed" ( %appxMgmt% remove WindowsAlarms                ) else %appxMgmt% add WindowsAlarms
  ) else if "%command%" == "17" ( if "%programs_system_program_camera%"             == "installed" ( %appxMgmt% remove WindowsCamera                ) else %appxMgmt% add WindowsCamera
  ) else if "%command%" == "18" ( if "%programs_system_program_gameBar%"            == "installed" (
      %appxMgmt% remove XboxGameOverlay
      %appxMgmt% remove XboxGamingOverlay
    ) else (
      %appxMgmt% add XboxGameOverlay
      %appxMgmt% add XboxGamingOverlay
    )
  ) else if "%command%" == "19" ( if "%programs_system_program_grooveMusic%"   == "installed" ( %appxMgmt% remove ZuneMusic            ) else %appxMgmt% add ZuneMusic
  ) else if "%command%" == "20" ( if "%programs_system_program_moviesTV%"      == "installed" ( %appxMgmt% remove ZuneVideo            ) else %appxMgmt% add ZuneVideo
  ) else if "%command%" == "21" ( if "%programs_system_program_myOffice%"      == "installed" ( %appxMgmt% remove MicrosoftOfficeHub   ) else %appxMgmt% add MicrosoftOfficeHub
  ) else if "%command%" == "22" ( if "%programs_system_program_paint3D%"       == "installed" ( %appxMgmt% remove MSPaint              ) else %appxMgmt% add MSPaint
  ) else if "%command%" == "23" ( if "%programs_system_program_photos%"        == "installed" ( %appxMgmt% remove Windows.Photos       ) else %appxMgmt% add Windows.Photos
  ) else if "%command%" == "24" ( if "%programs_system_program_skype%"         == "installed" ( %appxMgmt% remove SkypeApp             ) else %appxMgmt% add SkypeApp
  ) else if "%command%" == "25" ( if "%programs_system_program_snipSketch%"    == "installed" ( %appxMgmt% remove ScreenSketch         ) else %appxMgmt% add ScreenSketch
  ) else if "%command%" == "26" ( if "%programs_system_program_stickyNotes%"   == "installed" ( %appxMgmt% remove MicrosoftStickyNotes ) else %appxMgmt% add MicrosoftStickyNotes
  ) else if "%command%" == "27" ( if "%programs_system_program_store%"         == "installed" ( %appxMgmt% remove WindowsStore         ) else %appxMgmt% add WindowsStore
  ) else if "%command%" == "28" ( if "%programs_system_program_voiceRecorder%" == "installed" ( %appxMgmt% remove WindowsSoundRecorder ) else %appxMgmt% add WindowsSoundRecorder
  ) else if "%command%" == "29" ( if "%programs_system_program_weather%"       == "installed" ( %appxMgmt% remove BingWeather          ) else %appxMgmt% add BingWeather
  ) else if "%command%" == "30" ( if "%programs_system_program_xbox%"          == "installed" ( %appxMgmt% remove XboxApp              ) else %appxMgmt% add XboxApp
  ) else if "%command%" == "31" (
    for %%i in (3DBuilder Microsoft3DViewer WindowsFeedbackHub GetHelp WindowsCommunicationsApps WindowsMaps Messaging MixedReality.Portal OneConnect Office.OneNote Print3D MicrosoftSolitaireCollection GetStarted YourPhone WindowsAlarms WindowsCamera XboxGameOverlay XboxGamingOverlay ZuneMusic ZuneVideo MicrosoftOfficeHub MSPaint Windows.Photos SkypeApp ScreenSketch MicrosoftStickyNotes WindowsStore WindowsSoundRecorder BingWeather XboxApp) do %appxMgmt% add %%i
  ) else if "%command%" == "32" (
    for %%i in (3DBuilder Microsoft3DViewer WindowsFeedbackHub GetHelp WindowsCommunicationsApps WindowsMaps Messaging MixedReality.Portal OneConnect Office.OneNote Print3D MicrosoftSolitaireCollection GetStarted YourPhone WindowsAlarms WindowsCamera XboxGameOverlay XboxGamingOverlay ZuneMusic ZuneVideo MicrosoftOfficeHub MSPaint Windows.Photos SkypeApp ScreenSketch MicrosoftStickyNotes WindowsStore WindowsSoundRecorder BingWeather XboxApp) do %appxMgmt% remove %%i
  )
)
if "%command%" == "33" ( set command= & exit /b )
goto :programs_system















:programs_office
%getState% programs_office

%logo%
echo.^(i^) %lang_programs_office01%
echo.
echo.
echo.^(^>^) %lang_programs_office02%
echo.    ^(1^) %lang_programs_office03%
echo.
echo.    %lang_programs_office04%
echo.    ^(Z^) %lang_menuItem_rebootComputer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
if "%error_programs_office_download%" == "1" (
  color 0c
  echo.    ^(^^^!^) %lang_message_error_programs_office_download%
  echo.
  set error_programs_office_download=0
) else color 0b
%module_choice% /c 1Z0 /m "> "
set command=%errorLevel%



:programs_office_setup
if "%error_state_reg%" NEQ "1" if "%command%" == "1" (
  %logo%
  echo.^(i^) %lang_programs_office01%
  echo.
  echo.

  if exist "%programs_office_setupISO%" del /q "%programs_office_setupISO%"

  echo.^(i^) %lang_programs_office05%
  %module_wget% --show-progress --progress=bar:force:noscroll "%programs_office_setupURL%" --output-document="%programs_office_setupISO%"
  timeout /nobreak /t 1 >nul

  for /f "skip=6 tokens=1,3,* delims= " %%i in ('dir "%cd%\%programs_office_setupISO%"') do if "%%i" == "1" if "%%j" == "0" (
    set error_programs_office_download=1
    goto :programs_office
  )

  echo.^(i^) %lang_programs_office06%
  %module_powershell% "Mount-DiskImage ""%cd%\%programs_office_setupISO%"""
  timeout /nobreak /t 1 >nul

  echo.^(i^) %lang_programs_office07%
  %module_powershell% "Get-DiskImage """%cd%\%programs_office_setupISO%""" | Get-Volume | Select-Object {$_.DriveLetter} | Out-File -FilePath """%cd%\temp\return_diskImage""" -Encoding ASCII"
  for /f "skip=3 delims= " %%i in (temp\return_diskImage) do start /wait %%i:\O16Setup.exe
  timeout /nobreak /t 1 >nul

  echo.^(i^) %lang_programs_office08%
  %module_powershell% "Dismount-DiskImage ""%cd%\%programs_office_setupISO%"""
  timeout /nobreak /t 1 >nul
) else if "%command%" == "2" ( %reboot_computer%
) else if "%command%" == "3" ( set command= & exit /b )
goto :programs_office















:programs_gpeditMSC
%getState% programs_gpeditMSC

%logo%
echo.^(i^) %lang_programs_gpeditMSC01%
echo.
echo.
echo.^(^>^) %lang_programs_gpeditMSC02%

set sBuilder_text=^(1^) %lang_programs_gpeditMSC03%
       if "%programs_gpeditMSC_gpeditFile%" == "exist"    ( %sBuilder_build% %lang_sBuilder_exist%
) else if "%programs_gpeditMSC_gpeditFile%" == "notExist" ( %sBuilder_build% %lang_sBuilder_notExist%
) else                                                      %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
%module_choice% /c 10 /m "> "
set command=%errorLevel%



if "%command%" == "1" (
  if "%error_state_reg%" NEQ "1" (
    (
      dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum
      dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum
    )>%programs_gpeditMSC_packagesList%
    for /f %%i in ('findstr /i . %programs_gpeditMSC_packagesList% 2^>nul') do dism /online /norestart /add-package:"%systemRoot%\servicing\Packages\%%i"
  )
) else if "%command%" == "2" ( set command= & exit /b )
goto :programs_gpeditMSC















:services_windowsUpdate
%getState% services_windowsUpdate

%logo%
echo.^(i^) %lang_services_windowsUpdate01%
echo.
echo.
echo.^(^>^) %lang_services_windowsUpdate02%

set sBuilder_text=^(1^) %lang_services_windowsUpdate03%
       if "%services_windowsUpdate_updateDistributions%" == "locked"   ( %sBuilder_build% %lang_sBuilder_locked%
) else if "%services_windowsUpdate_updateDistributions%" == "unlocked" ( %sBuilder_build% %lang_sBuilder_unlocked%
) else                                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_services_windowsUpdate04%
       if "%services_windowsUpdate_updateCenter%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%services_windowsUpdate_updateCenter%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                            %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
%module_choice% /c 120 /m "> "
set command=%errorLevel%



if "%command%" == "1" if "%services_windowsUpdate_updateDistributions%" == "unlocked" (
  for /l %%i in (4,-1,1) do if exist "%WinDir%\SoftwareDistribution\Download" rd /s /q "%WinDir%\SoftwareDistribution\Download"
  echo.>"%WinDir%\SoftwareDistribution\Download"
) else (
  del /q "%WinDir%\SoftwareDistribution\Download"
  md     "%WinDir%\SoftwareDistribution\Download"
)
if "%error_state_reg%" NEQ "1" (
  if "%command%" == "2" if "%services_windowsUpdate_updateCenter%" == "enabled" (
    for /l %%i in (4,-1,1) do sc stop   wuauserv
    for /l %%i in (4,-1,1) do sc config wuauserv start=disabled
  ) else (
    for /l %%i in (4,-1,1) do sc config wuauserv start=auto
    for /l %%i in (4,-1,1) do sc start  wuauserv
  )
)>nul 2>nul
if "%command%" == "3" ( set command= & exit /b )
goto :services_windowsUpdate















:services_sppsvc
%getState% services_sppsvc

%logo%
echo.^(i^) %lang_services_sppsvc01%
echo.
echo.
echo.^(^>^) %lang_services_sppsvc02%

set sBuilder_text=^(1^) %lang_services_sppsvc03%
       if "%services_sppsvc_service%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%services_sppsvc_service%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_services_sppsvc04%
echo.    %lang_services_sppsvc05%
echo.    ^(Z^) %lang_menuItem_rebootComputer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
%module_choice% /c 1Z0 /m "> "
set command=%errorLevel%



if "%error_state_reg%" NEQ "1" (
  if "%command%" == "1" (
    (
      for /l %%i in (4,-1,1) do reg import res\services_sppsvc_registry.reg
      for /l %%i in (10,-1,1) do sc start sppsvc
    )>nul 2>nul
  ) else if "%command%" == "2" (
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v %program_name_ns%_services_sppsvc /t REG_SZ /d "%cd%\%program_name_ns%.cmd --main_reboot=services_sppsvc" /f >nul
    %reboot_computer%
  )
)
if "%command%" == "3" ( set command= & exit /b )
goto :services_sppsvc















:tools_admin
%getState% tools_admin
if "%error_state_reg%" == "1" set key_tools_admin_hiddenOptions=true

%logo%
echo.^(i^) %lang_tools_admin01%
echo.
echo.
echo.^(^>^) %lang_tools_admin02%

set sBuilder_text=^(1^) %lang_tools_admin03%
       if "%tools_admin_desktop%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%tools_admin_desktop%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                            %sBuilder_build% %lang_sBuilder_error%
if "%key_tools_admin_hiddenOptions%" == "true" (
  %sBuilder_build%    ^(4^) %lang_tools_admin04%
         if "%tools_admin_registryTools%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
  ) else if "%tools_admin_registryTools%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
  ) else                                                  %sBuilder_build% %lang_sBuilder_error%
)
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_tools_admin05%
       if "%tools_admin_controlPanel%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%tools_admin_controlPanel%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
if "%key_tools_admin_hiddenOptions%" == "true" (
  %sBuilder_build%    ^(5^) %lang_tools_admin06%
         if "%tools_admin_cmd%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
  ) else if "%tools_admin_cmd%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
  ) else                                        %sBuilder_build% %lang_sBuilder_error%
)
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_tools_admin07%
       if "%tools_admin_runDialog%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%tools_admin_runDialog%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                              %sBuilder_build% %lang_sBuilder_error%
if "%key_tools_admin_hiddenOptions%" == "true" (
  %sBuilder_build%    ^(6^) %lang_tools_admin08%
         if "%tools_admin_taskManager%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
  ) else if "%tools_admin_taskManager%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
  ) else                                                %sBuilder_build% %lang_sBuilder_error%
)
echo.    %sBuilder_text%

echo.
echo.    %lang_tools_admin09%
echo.    ^(X^) %lang_menuItem_updateGroupPolicy%
echo.
echo.    %lang_tools_admin10%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
if "%key_tools_admin_hiddenOptions%" == "true" (
  echo.    %lang_tools_admin11%
  echo.    ^(Z^) %lang_menuItem_rebootComputer%
  echo.
)
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_state_reg%" == "1" call :message_error_state_reg
if "%key_tools_admin_hiddenOptions%" == "true" (
  echo.    ^(^^^!^) %lang_message_tools_admin_hiddenOptions%
  echo.
  %module_choice% /c 123456XYZ0 /m "> "
) else %module_choice% /c 123XY0 /m "> "
set command=%errorLevel%



if "%error_state_reg%" NEQ "1" (
  if "%command%" == "1" (
    if "%tools_admin_desktop%"       == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop      /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%tools_admin_controlPanel%"  == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%tools_admin_runDialog%"     == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun          /t REG_DWORD /d !temp_cmd! /f
  )
)>nul 2>nul

if "%key_tools_admin_hiddenOptions%" == "true" (
  if "%command%" == "4" (
    if "%tools_admin_registryTools%" == "disabled" (
      for /l %%i in (4,-1,1) do rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 %cd%\res\tools_admin_unHookExec.inf
    ) else reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f
  )

  if "%error_state_reg%" NEQ "1" (
    if "%command%" == "5" (
      if "%tools_admin_cmd%"         == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
      reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD     /t REG_DWORD /d !temp_cmd! /f

    ) else if "%command%" == "6" (
      if "%tools_admin_taskManager%" == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
      reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d !temp_cmd! /f
    )
  )>nul 2>nul

  if "%command%" == "7" ( gpupdate /force >nul
  ) else if "%command%" == "8"  ( %restartExplorer%
  ) else if "%command%" == "9"  ( %reboot_computer%
  ) else if "%command%" == "10" ( set command= & exit /b )
) else (
  if "%command%" == "4" ( gpupdate /force >nul
  ) else if "%command%" == "5" ( %restartExplorer%
  ) else if "%command%" == "6" ( set command= & exit /b )
)
goto :tools_admin















:tools_syscheck
%logo%
echo.^(i^) %lang_tools_syscheck01%
echo.
echo.
echo.^(^>^) %lang_tools_syscheck02%
echo.    ^(1^) %lang_tools_syscheck03%
echo.
echo.    %lang_tools_syscheck04%
echo.    ^(Z^) %lang_menuItem_rebootComputer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
%module_choice% /c 1Z0 /m "> "
set command=%errorLevel%



if "%command%" == "1" ( for /l %%i in (3,-1,1) do sfc /scannow
) else if "%command%" == "2" ( %reboot_computer%
) else if "%command%" == "3" ( set command= & exit /b )
goto :tools_syscheck

























:message_error_state_reg
echo.    ^(^!^) %lang_message_error_state_reg01%
echo.        %lang_message_error_state_reg02%
if "%1" == "main_menu" (
       echo.        %lang_message_error_state_reg03%
) else echo.        %lang_message_error_state_reg04%
echo.
exit /b















:reboot_computer
if "%*" == "force" ( shutdown /r /t 7 & exit )

%logo%
echo.^(i^) %lang_reboot_computer01%
echo.
echo.
echo.^(^>^) %lang_reboot_computer02%
echo.    ^(1^) %lang_reboot_computer03%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
%module_choice% /c 10 /m "> "
set command=%errorLevel%



if "%command%" == "2" ( set command= & exit /b )

echo.^(^^^!^) %lang_reboot_computer04%
shutdown /r /t 15
timeout /nobreak /t 13 >nul
exit