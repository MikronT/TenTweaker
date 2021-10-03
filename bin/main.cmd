@echo off
chcp 65001>nul

call %*
exit /b !errorLevel!







:init
  set exec=%1\%~nx0



  set main=call !exec!

  set rebootComputer=call !exec! :rebootComputer



  set exec=
exit /b















:language_menu
  (
    %logo%
    echo.text=%lang_lang_menu01%
    echo.skip
    echo.skip
    echo.text=^(^>^) %lang_lang_menu02%
    echo.cursor1_right=2
    echo.text=^(1^) English
    echo.text=^(2^) Português
    echo.text=^(3^) Русский
    echo.text=^(4^) Українська

    if "%1" NEQ "force" (
      echo.skip
      echo.text=^(0^) %lang_menuItem_goBack%
    )
    echo.skip
    echo.skip
    echo.skip
    echo.cursor1_left=2
    echo.text=^>
  )>%layout%
  %module_cursor%
  if "%1" NEQ "force" (
         %module_choice% /c 12340
  ) else %module_choice% /c 1234
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
echo.    ^(^^^!^) %lang_eula%
echo.
if "%error_reg%"         == "true" call :msg_error_reg main_menu
if "%key_hiddenOptions%" == "true" call :msg_warning_hiddenOptions
if "%update_available%"  == "true" call :msg_info_update
%module_choice% /c 123456789ABL0 /m "> "
set command=%errorLevel%



if "%command%" == "1" ( call :interface_desktop
) else if "%command%" == "2"  ( call :interface_taskbar
) else if "%command%" == "3"  ( call :interface_explorer
) else if "%command%" == "4"  ( call :interface_input
) else if "%command%" == "5"  ( call :programs_system
) else if "%command%" == "6"  ( call :programs_office
) else if "%command%" == "7"  ( call :programs_gpeditMSC
) else if "%command%" == "8"  ( call :services_wuaserv
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
       if "%interface_desktop_thisPC%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_thisPC%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                               %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(4^) %lang_interface_desktop04%
       if "%interface_desktop_userFolder%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_userFolder%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_desktop05%
       if "%interface_desktop_trash%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_trash%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                              %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(5^) %lang_interface_desktop06%
       if "%interface_desktop_net%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_net%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                            %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_desktop07%
       if "%interface_desktop_control%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_desktop_control%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.

set sBuilder_text=^(6^) %lang_interface_desktop08%
       if "%interface_desktop_logonBlur%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_desktop_logonBlur%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_interface_desktop09%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_reg%" == "true" call :msg_error_reg
%module_choice% /c 123456Y0 /m "> "
set command=%errorLevel%



if "%error_reg%" NEQ "true" (
  if "%command%" == "1" (
    if "%interface_desktop_thisPC%"     == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_desktop_trash%"      == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_desktop_control%"    == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_desktop_userFolder%" == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
    if "%interface_desktop_net%"        == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "6" (
    if "%interface_desktop_logonBlur%"  == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKLM\Software\Policies\Microsoft\Windows\System /v DisableAcrylicBackgroundOnLogon /t REG_DWORD /d !temp_cmd! /f
  )
)>nul 2>nul
if "%command%" == "7" ( %restartExplorer%
) else if "%command%" == "8" exit /b
goto :interface_desktop















:interface_taskbar
%getState% interface_taskbar

%logo%
echo.^(i^) %lang_interface_taskbar01%
echo.
echo.
echo.^(^>^) %lang_interface_taskbar02%

set sBuilder_text=^(1^) %lang_interface_taskbar03%
       if "%interface_taskbar_people%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_taskbar_people%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                               %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(4^) %lang_interface_taskbar04%
       if "%interface_taskbar_small%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_taskbar_small%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_taskbar05%
       if "%interface_taskbar_winXcmd%" == "ps"  ( %sBuilder_build% %lang_sBuilder_ps%
) else if "%interface_taskbar_winXcmd%" == "cmd" ( %sBuilder_build% %lang_sBuilder_cmd%
) else                                             %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(5^) %lang_interface_taskbar06%
       if "%interface_taskbar_combined%" == "always" ( %sBuilder_build% %lang_sBuilder_always%
) else if "%interface_taskbar_combined%" == "ifFull" ( %sBuilder_build% %lang_sBuilder_ifFull%
) else if "%interface_taskbar_combined%" == "never"  ( %sBuilder_build% %lang_sBuilder_never%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_taskbar07%
       if "%interface_taskbar_taskView%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_taskbar_taskView%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_interface_taskbar08%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_reg%" == "true" call :msg_error_reg
%module_choice% /c 12345Y0 /m "> "
set command=%errorLevel%



if "%error_reg%" NEQ "true" (
  if "%command%" == "1" (
    if "%interface_taskbar_people%"   == "shown"    ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand       /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_taskbar_winXcmd%"  == "ps"       ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v DontUsePowerShellOnWinX /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_taskbar_taskView%" == "shown"    ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton      /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_taskbar_small%"    == "disabled" ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons       /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
    if "%interface_taskbar_combined%" == "always"   ( set temp_cmd=1 ) else if "%interface_taskbar_combined%" == "ifFull" ( set temp_cmd=2 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarGlomLevel        /t REG_DWORD /d !temp_cmd! /f
  )
)>nul 2>nul
if "%command%" == "6" ( %restartExplorer%
) else if "%command%" == "7" exit /b
goto :interface_taskbar















:interface_explorer
%getState% interface_explorer

%logo%
echo.^(i^) %lang_interface_explorer01%
echo.
echo.
echo.^(^>^) %lang_interface_explorer02%

set sBuilder_text=^(1^) %lang_interface_explorer03%
       if "%interface_explorer_extensions%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_extensions%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(6^) %lang_interface_explorer04%
       if "%interface_explorer_ribbon%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_ribbon%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_explorer05%
       if "%interface_explorer_hidden%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_hidden%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(7^) %lang_interface_explorer06%
       if "%interface_explorer_expand%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_explorer_expand%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_explorer07%
       if "%interface_explorer_hiddenSys%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_hiddenSys%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(8^) %lang_interface_explorer08%
       if "%interface_explorer_statusbar%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_statusbar%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(4^) %lang_interface_explorer09%
       if "%interface_explorer_emptyDrives%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_emptyDrives%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(9^) %lang_interface_explorer10%
       if "%interface_explorer_infoTip%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_infoTip%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(5^) %lang_interface_explorer11%
       if "%interface_explorer_conflicts%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_conflicts%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
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
       if "%interface_explorer_oneDrive%" == "shown"  ( %sBuilder_build% %lang_sBuilder_shown%
) else if "%interface_explorer_oneDrive%" == "hidden" ( %sBuilder_build% %lang_sBuilder_hidden%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%
echo.

set sBuilder_text=^(I^) %lang_interface_explorer21%
       if "%interface_explorer_autoType%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_explorer_autoType%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    %lang_interface_explorer22%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_reg%" == "true" call :msg_error_reg
%module_choice% /c 123456789ABCDEFGHIY0 /m "> "
set command=%errorLevel%



if "%error_reg%" NEQ "true" (
  if "%command%" == "1" (
    if "%interface_explorer_extensions%"       == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt                  /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_explorer_hidden%"           == "hidden"  ( set temp_cmd=1 ) else set temp_cmd=2
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden                       /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_explorer_hiddenSys%"        == "hidden"  ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden              /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_explorer_emptyDrives%"      == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideDrivesWithNoMedia        /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
    if "%interface_explorer_conflicts%"        == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideMergeConflicts           /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "6" (
    if "%interface_explorer_ribbon%"           == "hidden"  ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon   /v MinimizedStateTabletModeOff  /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "7" (
    if "%interface_explorer_expand%"           == "enabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v NavPaneExpandToCurrentFolder /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "8" (
    if "%interface_explorer_statusbar%"        == "shown"   ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowStatusBar                /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "9" (
    if "%interface_explorer_infoTip%"          == "shown"   ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowInfoTip                  /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "10" (
    if "%interface_explorer_thisPC_desktop%"   == "shown"   ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641} /f

  ) else if "%command%" == "11" (
    if "%interface_explorer_thisPC_documents%" == "shown"   ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af} /f

  ) else if "%command%" == "12" (
    if "%interface_explorer_thisPC_downloads%" == "shown"   ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f} /f

  ) else if "%command%" == "13" (
    if "%interface_explorer_thisPC_music%"     == "shown"   ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} /f

  ) else if "%command%" == "14" (
    if "%interface_explorer_thisPC_pictures%"  == "shown"   ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8} /f

  ) else if "%command%" == "15" (
    if "%interface_explorer_thisPC_videos%"    == "shown"   ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} /f

  ) else if "%command%" == "16" (
    if "%interface_explorer_thisPC_3DObjects%" == "shown"   ( set temp_cmd=delete ) else set temp_cmd=add
    reg !temp_cmd! HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A} /f

  ) else if "%command%" == "17" (
    if "%interface_explorer_oneDrive%"         == "shown"   ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "18" (
    if "%interface_explorer_autoType%" == "disabled" (
        reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /f
    ) else reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_SZ /d NotSpecified /f
  )
)>nul 2>nul
if "%command%" == "19" ( %restartExplorer%
) else if "%command%" == "20" exit /b
goto :interface_explorer















:interface_input
%getState% interface_input
if "%error_reg%" NEQ "true" if "%interface_input_langKey%" == "%interface_input_layoutKey%" (
  if "%interface_input_langKey%" NEQ "notAssigned" (
           set error_identicalKeys=true
  ) else set error_identicalKeys=false
) else set error_identicalKeys=false

%logo%
echo.^(i^) %lang_interface_input01%
echo.
echo.
echo.^(^>^) %lang_interface_input02%

set sBuilder_text=^(1^) %lang_interface_input03%
       if "%interface_input_suggestions%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_suggestions%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_interface_input04%
       if "%interface_input_completion%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_completion%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_interface_input05%
       if "%interface_input_progTracking%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_progTracking%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(4^) %lang_interface_input06%
       if "%interface_input_onTyping%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%interface_input_onTyping%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.^(^>^) %lang_interface_input07%

set sBuilder_text=^(5^) %lang_interface_input08%
       if "%interface_input_langKey%" == "notAssigned"  ( %sBuilder_build% %lang_sBuilder_notAssigned%
) else if "%interface_input_langKey%" == "ctrlShift"    ( %sBuilder_build% %lang_sBuilder_ctrlShift%
) else if "%interface_input_langKey%" == "leftAltShift" ( %sBuilder_build% %lang_sBuilder_leftAltShift%
) else if "%interface_input_langKey%" == "graveAccent"  ( %sBuilder_build% %lang_sBuilder_graveAccent%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(6^) %lang_interface_input09%
       if "%interface_input_layoutKey%" == "notAssigned"  ( %sBuilder_build% %lang_sBuilder_notAssigned%
) else if "%interface_input_layoutKey%" == "ctrlShift"    ( %sBuilder_build% %lang_sBuilder_ctrlShift%
) else if "%interface_input_layoutKey%" == "leftAltShift" ( %sBuilder_build% %lang_sBuilder_leftAltShift%
) else if "%interface_input_layoutKey%" == "graveAccent"  ( %sBuilder_build% %lang_sBuilder_graveAccent%
) else                                                      %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.

if "%error_reg%"           == "true"   call :msg_error_reg
if "%error_identicalKeys%" == "true" ( call :msg_error_identicalKeys
  color 0c
) else color 0b

%module_choice% /c 1234560 /m "> "
set command=%errorLevel%



if "%error_reg%" NEQ "true" (
  if "%command%" == "1" (
    if "%interface_input_suggestions%"  == "disabled" ( set temp_cmd=yes ) else set temp_cmd=no
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v AutoSuggest         /t REG_SZ    /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%interface_input_completion%"   == "disabled" ( set temp_cmd=yes ) else set temp_cmd=no
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete /v "Append Completion" /t REG_SZ    /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%interface_input_progTracking%" == "disabled" ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced     /v Start_TrackProgs    /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "4" (
    if "%interface_input_onTyping%"     == "disabled" ( set temp_cmd=1 ) else set temp_cmd=0
    reg add HKCU\Software\Microsoft\Input\Settings /v EnableHwkbTextPrediction /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "5" (
           if "%interface_input_langKey%" == "notAssigned"  ( set temp_cmd=2
    ) else if "%interface_input_langKey%" == "ctrlShift"    ( set temp_cmd=1
    ) else if "%interface_input_langKey%" == "leftAltShift" ( set temp_cmd=4
    ) else if "%interface_input_langKey%" == "graveAccent"    set temp_cmd=3
    reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d !temp_cmd! /f

  ) else if "%command%" == "6" (
           if "%interface_input_layoutKey%" == "notAssigned"  ( set temp_cmd=2
    ) else if "%interface_input_layoutKey%" == "ctrlShift"    ( set temp_cmd=1
    ) else if "%interface_input_layoutKey%" == "leftAltShift" ( set temp_cmd=4
    ) else if "%interface_input_layoutKey%" == "graveAccent"    set temp_cmd=3
    reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d !temp_cmd! /f
  )
)>nul 2>nul
if "%command%" == "7" if "%error_identicalKeys%" NEQ "true" exit /b
goto :interface_input















:programs_system
%getState% programs_system

%logo%
echo.^(i^) %lang_programs_system01%
echo.
echo.
echo.^(^>^) %lang_programs_system02%

set sBuilder_text=^(1^) %lang_programs_system03%
       if "%programs_system_3DBuilder%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_3DBuilder%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(G^) %lang_programs_system04%
       if "%programs_system_clock%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_clock%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_programs_system05%
       if "%programs_system_3DViewer%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_3DViewer%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(H^) %lang_programs_system06%
       if "%programs_system_camera%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_camera%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_programs_system07%
       if "%programs_system_feedback%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_feedback%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(I^) %lang_programs_system08%
       if "%programs_system_gamebar%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_gamebar%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(4^) %lang_programs_system09%
       if "%programs_system_getHelp%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_getHelp%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(J^) %lang_programs_system10%
       if "%programs_system_music%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_music%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(5^) %lang_programs_system11%
       if "%programs_system_mailCal%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_mailCal%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(K^) %lang_programs_system12%
       if "%programs_system_movies%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_movies%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(6^) %lang_programs_system13%
       if "%programs_system_maps%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_maps%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(L^) %lang_programs_system14%
       if "%programs_system_office%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_office%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(7^) %lang_programs_system15%
       if "%programs_system_messaging%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_messaging%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(M^) %lang_programs_system16%
       if "%programs_system_paint3D%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_paint3D%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(8^) %lang_programs_system17%
       if "%programs_system_portal%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_portal%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(N^) %lang_programs_system18%
       if "%programs_system_photos%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_photos%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(9^) %lang_programs_system19%
       if "%programs_system_mobPlans%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_mobPlans%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(O^) %lang_programs_system20%
       if "%programs_system_skype%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_skype%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(A^) %lang_programs_system21%
       if "%programs_system_oneNote%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_oneNote%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(P^) %lang_programs_system22%
       if "%programs_system_snip%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_snip%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(B^) %lang_programs_system23%
       if "%programs_system_people%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_people%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                  %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(Q^) %lang_programs_system24%
       if "%programs_system_notes%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_notes%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(C^) %lang_programs_system25%
       if "%programs_system_print3D%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_print3D%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(R^) %lang_programs_system26%
       if "%programs_system_store%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_store%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                 %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(D^) %lang_programs_system27%
       if "%programs_system_solitare%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_solitare%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                    %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(S^) %lang_programs_system28%
       if "%programs_system_rec%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_rec%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                               %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(E^) %lang_programs_system29%
       if "%programs_system_tips%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_tips%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(T^) %lang_programs_system30%
       if "%programs_system_weather%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_weather%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                   %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(F^) %lang_programs_system31%
       if "%programs_system_yourPhone%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_yourPhone%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                     %sBuilder_build% %lang_sBuilder_error%
%sBuilder_build%    ^(U^) %lang_programs_system32%
       if "%programs_system_xbox%" == "installed"   ( %sBuilder_build% %lang_sBuilder_installed%
) else if "%programs_system_xbox%" == "uninstalled" ( %sBuilder_build% %lang_sBuilder_uninstalled%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(V^) %lang_programs_system33%
echo.    ^(W^) %lang_programs_system34%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_reg%" == "true" call :msg_error_reg
%module_choice% /c 123456789ABCDEFGHIJKLMNOPQRSTUVW0 /m "> "
set command=%errorLevel%



if "%error_reg%" NEQ "true" (
         if "%command%" == "1"  ( if "%programs_system_3DBuilder%" == "installed" ( %appxMgmt% remove 3DBuilder                    ) else %appxMgmt% add 3DBuilder
  ) else if "%command%" == "2"  ( if "%programs_system_3DViewer%"  == "installed" ( %appxMgmt% remove Microsoft3DViewer            ) else %appxMgmt% add Microsoft3DViewer
  ) else if "%command%" == "3"  ( if "%programs_system_feedback%"  == "installed" ( %appxMgmt% remove WindowsFeedbackHub           ) else %appxMgmt% add WindowsFeedbackHub
  ) else if "%command%" == "4"  ( if "%programs_system_getHelp%"   == "installed" ( %appxMgmt% remove GetHelp                      ) else %appxMgmt% add GetHelp
  ) else if "%command%" == "5"  ( if "%programs_system_mailCal%"   == "installed" ( %appxMgmt% remove WindowsCommunicationsApps    ) else %appxMgmt% add WindowsCommunicationsApps
  ) else if "%command%" == "6"  ( if "%programs_system_maps%"      == "installed" ( %appxMgmt% remove WindowsMaps                  ) else %appxMgmt% add WindowsMaps
  ) else if "%command%" == "7"  ( if "%programs_system_messaging%" == "installed" ( %appxMgmt% remove Messaging                    ) else %appxMgmt% add Messaging
  ) else if "%command%" == "8"  ( if "%programs_system_portal%"    == "installed" ( %appxMgmt% remove MixedReality.Portal          ) else %appxMgmt% add MixedReality.Portal
  ) else if "%command%" == "9"  ( if "%programs_system_mobPlans%"  == "installed" ( %appxMgmt% remove OneConnect                   ) else %appxMgmt% add OneConnect
  ) else if "%command%" == "10" ( if "%programs_system_oneNote%"   == "installed" ( %appxMgmt% remove Office.OneNote               ) else %appxMgmt% add Office.OneNote
  ) else if "%command%" == "11" ( if "%programs_system_people%"    == "installed" ( %appxMgmt% remove People                       ) else %appxMgmt% add People
  ) else if "%command%" == "12" ( if "%programs_system_print3D%"   == "installed" ( %appxMgmt% remove Print3D                      ) else %appxMgmt% add Print3D
  ) else if "%command%" == "13" ( if "%programs_system_solitare%"  == "installed" ( %appxMgmt% remove MicrosoftSolitaireCollection ) else %appxMgmt% add MicrosoftSolitaireCollection
  ) else if "%command%" == "14" ( if "%programs_system_tips%"      == "installed" ( %appxMgmt% remove GetStarted                   ) else %appxMgmt% add GetStarted
  ) else if "%command%" == "15" ( if "%programs_system_yourPhone%" == "installed" ( %appxMgmt% remove YourPhone                    ) else %appxMgmt% add YourPhone
  ) else if "%command%" == "16" ( if "%programs_system_clock%"     == "installed" ( %appxMgmt% remove WindowsAlarms                ) else %appxMgmt% add WindowsAlarms
  ) else if "%command%" == "17" ( if "%programs_system_camera%"    == "installed" ( %appxMgmt% remove WindowsCamera                ) else %appxMgmt% add WindowsCamera
  ) else if "%command%" == "18" ( if "%programs_system_gamebar%"   == "installed" (
      %appxMgmt% remove XboxGameOverlay
      %appxMgmt% remove XboxGamingOverlay
    ) else (
      %appxMgmt% add XboxGameOverlay
      %appxMgmt% add XboxGamingOverlay
    )
  ) else if "%command%" == "19" ( if "%programs_system_music%"   == "installed" ( %appxMgmt% remove ZuneMusic            ) else %appxMgmt% add ZuneMusic
  ) else if "%command%" == "20" ( if "%programs_system_movies%"  == "installed" ( %appxMgmt% remove ZuneVideo            ) else %appxMgmt% add ZuneVideo
  ) else if "%command%" == "21" ( if "%programs_system_office%"  == "installed" ( %appxMgmt% remove MicrosoftOfficeHub   ) else %appxMgmt% add MicrosoftOfficeHub
  ) else if "%command%" == "22" ( if "%programs_system_paint3D%" == "installed" ( %appxMgmt% remove MSPaint              ) else %appxMgmt% add MSPaint
  ) else if "%command%" == "23" ( if "%programs_system_photos%"  == "installed" ( %appxMgmt% remove Windows.Photos       ) else %appxMgmt% add Windows.Photos
  ) else if "%command%" == "24" ( if "%programs_system_skype%"   == "installed" ( %appxMgmt% remove SkypeApp             ) else %appxMgmt% add SkypeApp
  ) else if "%command%" == "25" ( if "%programs_system_snip%"    == "installed" ( %appxMgmt% remove ScreenSketch         ) else %appxMgmt% add ScreenSketch
  ) else if "%command%" == "26" ( if "%programs_system_notes%"   == "installed" ( %appxMgmt% remove MicrosoftStickyNotes ) else %appxMgmt% add MicrosoftStickyNotes
  ) else if "%command%" == "27" ( if "%programs_system_store%"   == "installed" ( %appxMgmt% remove WindowsStore         ) else %appxMgmt% add WindowsStore
  ) else if "%command%" == "28" ( if "%programs_system_rec%"     == "installed" ( %appxMgmt% remove WindowsSoundRecorder ) else %appxMgmt% add WindowsSoundRecorder
  ) else if "%command%" == "29" ( if "%programs_system_weather%" == "installed" ( %appxMgmt% remove BingWeather          ) else %appxMgmt% add BingWeather
  ) else if "%command%" == "30" ( if "%programs_system_xbox%"    == "installed" ( %appxMgmt% remove XboxApp              ) else %appxMgmt% add XboxApp
  ) else if "%command%" == "31" (
    for %%i in (3DBuilder Microsoft3DViewer WindowsFeedbackHub GetHelp WindowsCommunicationsApps WindowsMaps Messaging MixedReality.Portal OneConnect Office.OneNote Print3D MicrosoftSolitaireCollection GetStarted YourPhone WindowsAlarms WindowsCamera XboxGameOverlay XboxGamingOverlay ZuneMusic ZuneVideo MicrosoftOfficeHub MSPaint Windows.Photos SkypeApp ScreenSketch MicrosoftStickyNotes WindowsStore WindowsSoundRecorder BingWeather XboxApp) do %appxMgmt% add %%i
  ) else if "%command%" == "32" (
    for %%i in (3DBuilder Microsoft3DViewer WindowsFeedbackHub GetHelp WindowsCommunicationsApps WindowsMaps Messaging MixedReality.Portal OneConnect Office.OneNote Print3D MicrosoftSolitaireCollection GetStarted YourPhone WindowsAlarms WindowsCamera XboxGameOverlay XboxGamingOverlay ZuneMusic ZuneVideo MicrosoftOfficeHub MSPaint Windows.Photos SkypeApp ScreenSketch MicrosoftStickyNotes WindowsStore WindowsSoundRecorder BingWeather XboxApp) do %appxMgmt% remove %%i
  )
)
if "%command%" == "33" exit /b
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
if "%error_reg%"                      == "true"   call :msg_error_reg
if "%error_programs_office_download%" == "true" ( call :msg_error_office
  set error_programs_office_download=false
  color 0c
) else color 0b
%module_choice% /c 1Z0 /m "> "
set command=%errorLevel%



:programs_office_setup
if "%error_reg%" NEQ "true" if "%command%" == "1" (
  %logo%
  echo.^(i^) %lang_programs_office01%
  echo.
  echo.

  if exist "%programs_office_setupISO%" del /q "%programs_office_setupISO%"

  echo.^(i^) %lang_programs_office05%
  %module_wget% --show-progress --progress=bar:force:noscroll "%programs_office_setupURL%" --output-document="%programs_office_setupISO%"
  timeout /nobreak /t 1 >nul

  for /f "skip=6 tokens=1,3,* delims= " %%i in ('dir "%cd%\%programs_office_setupISO%"') do if "%%i" == "1" if "%%j" == "0" (
    set error_programs_office_download=true
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
) else if "%command%" == "2" ( %rebootComputer%
) else if "%command%" == "3" exit /b
goto :programs_office















:programs_gpeditMSC
%getState% programs_gpeditMSC

%logo%
echo.^(i^) %lang_programs_gpeditMSC01%
echo.
echo.
echo.^(^>^) %lang_programs_gpeditMSC02%

set sBuilder_text=^(1^) %lang_programs_gpeditMSC03%
       if "%programs_gpeditMSC_file%" == "exist"    ( %sBuilder_build% %lang_sBuilder_exist%
) else if "%programs_gpeditMSC_file%" == "notExist" ( %sBuilder_build% %lang_sBuilder_notExist%
) else                                                %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_reg%" == "true" call :msg_error_reg
%module_choice% /c 10 /m "> "
set command=%errorLevel%



if "%command%" == "1" (
  if "%error_reg%" NEQ "true" (
    (
      dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum
      dir /b %systemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum
    )>%programs_gpeditMSC_packagesList%
    for /f %%i in ('findstr /i . %programs_gpeditMSC_packagesList% 2^>nul') do dism /online /norestart /add-package:"%systemRoot%\servicing\Packages\%%i"
  )
) else if "%command%" == "2" exit /b
goto :programs_gpeditMSC















:services_wuaserv
%getState% services_wuaserv

%logo%
echo.^(i^) %lang_services_wuaserv01%
echo.
echo.
echo.^(^>^) %lang_services_wuaserv02%

set sBuilder_text=^(1^) %lang_services_wuaserv03%
       if "%services_wuaserv_distrs%" == "locked"   ( %sBuilder_build% %lang_sBuilder_locked%
) else if "%services_wuaserv_distrs%" == "unlocked" ( %sBuilder_build% %lang_sBuilder_unlocked%
) else                                               %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_services_wuaserv04%
       if "%services_wuaserv_center%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%services_wuaserv_center%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                               %sBuilder_build% %lang_sBuilder_error%
echo.    %sBuilder_text%

echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_reg%" == "true" call :msg_error_reg
%module_choice% /c 120 /m "> "
set command=%errorLevel%



if "%command%" == "1" (
  if "%services_wuaserv_distrs%" == "unlocked" (
    if exist "%WinDir%\SoftwareDistribution\Download" for /l %%i in (1,1,3) do (
      rd /s /q "%WinDir%\SoftwareDistribution\Download"
      timeout /t 1
    )
    echo.>"%WinDir%\SoftwareDistribution\Download"
  ) else (
    del /q "%WinDir%\SoftwareDistribution\Download"
    md     "%WinDir%\SoftwareDistribution\Download"
  )
)>nul 2>nul
if "%error_reg%" NEQ "true" (
  if "%command%" == "2" if "%services_wuaserv_center%" == "enabled" (
    for /l %%i in (1,1,3) do sc stop   wuauserv
    for /l %%i in (1,1,3) do sc config wuauserv start=disabled
  ) else (
    for /l %%i in (1,1,3) do sc config wuauserv start=auto
    for /l %%i in (1,1,3) do sc start  wuauserv
  )
)>nul 2>nul
if "%command%" == "3" exit /b
goto :services_wuaserv















:services_sppsvc
%getState% services_sppsvc

%logo%
echo.^(i^) %lang_services_sppsvc01%
echo.
echo.
echo.^(^>^) %lang_services_sppsvc02%

set sBuilder_text=^(1^) %lang_services_sppsvc03%
       if "%services_sppsvc_sve%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%services_sppsvc_sve%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                            %sBuilder_build% %lang_sBuilder_error%
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
if "%error_reg%" == "true" call :msg_error_reg
%module_choice% /c 1Z0 /m "> "
set command=%errorLevel%



if "%error_reg%" NEQ "true" (
  if "%command%" == "1" (
    (
      for /l %%i in (1,1,4) do reg import res\sppsvc.reg
      for /l %%i in (1,1,10) do sc start sppsvc
    )>nul 2>nul
  ) else if "%command%" == "2" (
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v %program_name_ns%_services_sppsvc /t REG_SZ /d "%~f0 /reboot sppsvc" /f >nul
    %rebootComputer%
  )
)
if "%command%" == "3" exit /b
goto :services_sppsvc















:tools_admin
%getState% tools_admin
if "%error_reg%" == "true" set key_hiddenOptions=true

%logo%
echo.^(i^) %lang_tools_admin01%
echo.
echo.
echo.^(^>^) %lang_tools_admin02%

set sBuilder_text=^(1^) %lang_tools_admin03%
       if "%tools_admin_desktop%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%tools_admin_desktop%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                            %sBuilder_build% %lang_sBuilder_error%
if "%key_hiddenOptions%" == "true" (
  %sBuilder_build%    ^(4^) %lang_tools_admin04%
         if "%tools_admin_reg%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
  ) else if "%tools_admin_reg%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
  ) else                                        %sBuilder_build% %lang_sBuilder_error%
)
echo.    %sBuilder_text%

set sBuilder_text=^(2^) %lang_tools_admin05%
       if "%tools_admin_control%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%tools_admin_control%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                            %sBuilder_build% %lang_sBuilder_error%
if "%key_hiddenOptions%" == "true" (
  %sBuilder_build%    ^(5^) %lang_tools_admin06%
         if "%tools_admin_cmd%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
  ) else if "%tools_admin_cmd%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
  ) else                                        %sBuilder_build% %lang_sBuilder_error%
)
echo.    %sBuilder_text%

set sBuilder_text=^(3^) %lang_tools_admin07%
       if "%tools_admin_run%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
) else if "%tools_admin_run%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
) else                                        %sBuilder_build% %lang_sBuilder_error%
if "%key_hiddenOptions%" == "true" (
  %sBuilder_build%    ^(6^) %lang_tools_admin08%
         if "%tools_admin_taskMgr%" == "enabled"  ( %sBuilder_build% %lang_sBuilder_enabled%
  ) else if "%tools_admin_taskMgr%" == "disabled" ( %sBuilder_build% %lang_sBuilder_disabled%
  ) else                                            %sBuilder_build% %lang_sBuilder_error%
)
echo.    %sBuilder_text%

echo.
echo.    %lang_tools_admin09%
echo.    ^(X^) %lang_menuItem_updateGroupPolicy%
echo.
echo.    %lang_tools_admin10%
echo.    ^(Y^) %lang_menuItem_restartExplorer%
echo.
if "%key_hiddenOptions%" == "true" (
  echo.    %lang_tools_admin11%
  echo.    ^(Z^) %lang_menuItem_rebootComputer%
  echo.
)
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
if "%error_reg%"         == "true"   call :msg_error_reg
if "%key_hiddenOptions%" == "true" ( call :msg_warning_hiddenOptions
       %module_choice% /c 123456XYZ0 /m "> "
) else %module_choice% /c 123XY0 /m "> "
set command=%errorLevel%



if "%error_reg%" NEQ "true" (
  if "%command%" == "1" (
    if "%tools_admin_desktop%" == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDesktop      /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "2" (
    if "%tools_admin_control%" == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel /t REG_DWORD /d !temp_cmd! /f

  ) else if "%command%" == "3" (
    if "%tools_admin_run%"     == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
    reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun          /t REG_DWORD /d !temp_cmd! /f
  )
)>nul 2>nul

if "%key_hiddenOptions%" == "true" (
  if "%command%" == "4" (
    if "%tools_admin_reg%" == "disabled" (
      for /l %%i in (1,1,4) do rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 %cd%\res\unHookExec.inf
    ) else reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f
  )

  if "%error_reg%" NEQ "true" (
    if "%command%" == "5" (
      if "%tools_admin_cmd%"     == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
      reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCMD     /t REG_DWORD /d !temp_cmd! /f

    ) else if "%command%" == "6" (
      if "%tools_admin_taskMgr%" == "disabled" ( set temp_cmd=0 ) else set temp_cmd=1
      reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d !temp_cmd! /f
    )
  )>nul 2>nul

  if "%command%" == "7" ( gpupdate /force >nul
  ) else if "%command%" == "8"  ( %restartExplorer%
  ) else if "%command%" == "9"  ( %rebootComputer%
  ) else if "%command%" == "10" exit /b
) else (
  if "%command%" == "4" ( gpupdate /force >nul
  ) else if "%command%" == "5" ( %restartExplorer%
  ) else if "%command%" == "6" exit /b
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



if "%command%" == "1" ( for /l %%i in (1,1,3) do sfc /scannow
) else if "%command%" == "2" ( %rebootComputer%
) else if "%command%" == "3" exit /b
goto :tools_syscheck

























:msg_info_update
  echo.    ^(^^^!^) %lang_msg_info_update1%
  echo.        %lang_msg_info_update2%
  echo.            github.com/MikronT/TenTweaker/releases/latest
  echo.
exit /b



:msg_warning_hiddenOptions
  echo.    ^(^^^!^) %lang_msg_warning_hiddenOptions%
  echo.
exit /b



:msg_error_identicalKeys
  echo.    ^(^^^!^) %lang_msg_error_identicalKeys%
  echo.
exit /b



:msg_error_office
  echo.    ^(^^^!^) %lang_msg_error_office%
  echo.
exit /b



:msg_error_reg
  echo.    ^(^^^!^) %lang_msg_error_reg1%
  echo.        %lang_msg_error_reg2%

  if "%1" == "main_menu" (
         echo.        %lang_msg_error_reg3%
  ) else echo.        %lang_msg_error_reg4%

  echo.
exit /b















:rebootComputer
if "%*" == "force" ( shutdown /r /t 7 & exit )

%logo%
echo.^(i^) %lang_rebootComputer01%
echo.
echo.
echo.^(^>^) %lang_rebootComputer02%
echo.    ^(1^) %lang_rebootComputer03%
echo.
echo.    ^(0^) %lang_menuItem_goBack%
echo.
echo.
echo.
%module_choice% /c 10 /m "> "
set command=%errorLevel%



if "%command%" == "2" exit /b

echo.^(^^^!^) %lang_rebootComputer04%
shutdown /r /t 15
timeout /nobreak /t 13 >nul
exit