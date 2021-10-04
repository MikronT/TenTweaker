@echo off
chcp 65001>nul

call %*
exit /b !errorLevel!







:init
  set exec=%1\%~nx0



  set color_default=07
  set color_logo=0f
  set color_title=%color_logo%
  set color_subtitle=%color_default%
  set color_accent=0b
  set color_info=%color_default%
  set color_warn=%color_title%
  set color_error=0c

  set message_info=info
  set message_warn=warning
  set message_error=error



  set column_left=call !exec! :column_left
  set column_right=call !exec! :column_right

  set align_left=call !exec! :align_left
  set align_right=call !exec! :align_right



  set logo=call !exec! :logo
  set title=call !exec! :title
  set item=call !exec! :item
  set input=call !exec! :input

  set message=call !exec! :message
  set message_info_disclaimer=call !exec! :message_info_disclaimer
  set message_info_hiddenOptions=call !exec! :message_info_hiddenOptions
  set message_info_update=call !exec! :message_info_update
  set message_error_keys=call !exec! :message_error_keys
  set message_error_office=call !exec! :message_error_office
  set message_error_registryInaccessible=call !exec! :message_error_registryInaccessible



  set exec=
exit /b















:column_left
  echo.cursor1=1 10
exit /b



:column_right
  echo.cursor1=61 10
exit /b







:align_left
  echo.left=120
exit /b



:align_right
  %align_left%
  echo.right=60
exit /b















:logo
  title [MikronT] %program_name%

  echo.screen_width=120
  echo.screen_height=40
  echo.screen_margin=1

  echo.color=%color_default%
  echo.clear=screen


  echo.cursor1=3 2
  echo.color=%color_accent%
  echo.text=[       ] ==^>

  echo.up
  echo.right
  echo.color=%color_logo%
  echo.text=MikronT

  echo.up
  echo.right=13
  echo.text=%program_name%


  echo.cursor1=17 3
  echo.color=%color_default%
  echo.text=%lang_logo1%


  echo.cursor1=2 4
  echo.color=%color_logo%
  echo.text=━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


  echo.cursor1=4 5
  echo.color=%color_default%
  echo.text=%lang_logo2%

  echo.cursor1=8 6
  echo.text=github.com/MikronT

  %column_left%
exit /b







:title
  set arg_title=%1
  if "!arg_title!" NEQ "" set arg_title=!arg_title:"=!
  if "!arg_title!" ==  "" exit /b

  set arg_sub=%2
  if "!arg_sub!" NEQ "" set arg_sub=!arg_sub:"=!



  echo.color=%color_title%
  call echo.text=%%lang_!arg_title!%%

  if "!arg_sub!" NEQ "" (
    echo.color=%color_subtitle%
    call echo.text=%%lang_!arg_sub!%%
  )

  echo.down
  echo.color=%color_default%
exit /b







:item
  set arg_option=%1
  if "!arg_option!" NEQ "" set arg_option=!arg_option:"=!
  if "!arg_option!" ==  "" exit /b

  set arg_name=%2
  if "!arg_name!" NEQ "" set arg_name=!arg_name:"=!
  if "!arg_name!" ==  "" exit /b



  echo.color=%color_accent%
  echo.text=^(!arg_option!^)

  echo.up
  echo.right=4
  echo.color=%color_default%
  call echo.text=%%lang_!arg_name!%%

  echo.left=4
  echo.color=%color_default%
exit /b







:input
  echo.cursor1=1 39
  echo.color=%color_accent%
  echo.text=^>
exit /b















:message
  set arg_level=%1
  if "!arg_level!" NEQ "" set arg_level=!arg_level:"=!
  if "!arg_level!" NEQ "%message_info%" if "!arg_level!" NEQ "%message_warn%" if "!arg_level!" NEQ "%message_error%" exit /b

  set arg_msg=%2
  if "!arg_msg!" NEQ "" set arg_msg=!arg_msg:"=!
  if "!arg_msg!" ==  "" exit /b



  echo.color=%color_accent%
         if "!arg_level!" == "%message_info%" ( echo.text=^(i^)
  ) else if "!arg_level!" == "%message_warn%" ( echo.text=^(^^^!^)
  ) else if "!arg_level!" == "%message_error%"  echo.text=^(E^)

  echo.up
  echo.right=4
         if "!arg_level!" == "%message_info%" ( echo.color=%color_info%
  ) else if "!arg_level!" == "%message_warn%" ( echo.color=%color_warn%
  ) else if "!arg_level!" == "%message_error%"  echo.color=%color_error%
  call echo.text=%%lang_!arg_msg!%%

  echo.left=4
  echo.color=%color_default%
exit /b







:message_info_disclaimer
  echo.down=2
  %message% %message_info% eula
exit /b







:message_info_hiddenOptions
  echo.down=2
  %message% %message_info% msg_warning_hiddenOptions
exit /b







:message_info_update
  echo.down=2
  %message% %message_info% msg_info_update1

  echo.right=4
  echo.text=%lang_msg_info_update2%

  echo.right=4
  echo.text=github.com/MikronT/TenTweaker/releases/latest

  echo.left=8
exit /b







:message_error_keys
  echo.down=2
  %message% %message_error% msg_error_identicalKeys
exit /b







:message_error_office
  echo.down=2
  %message% %message_error% msg_error_office
exit /b







:message_error_registryInaccessible
  echo.down=2
  %message% %message_error% msg_error_reg1

  echo.right=4
  echo.text=%lang_msg_error_reg2%
  echo.text=%lang_msg_error_reg3%
  echo.text=%lang_msg_error_reg4%
exit /b