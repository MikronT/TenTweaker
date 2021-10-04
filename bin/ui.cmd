@echo off
chcp 65001>nul

call %*
exit /b !errorLevel!







:init
  set exec=%1\%~nx0



  set column_left=call !exec! :column_left
  set column_right=call !exec! :column_right

  set align_left=call !exec! :align_left
  set align_right=call !exec! :align_right

  set logo=call !exec! :logo
  set title=call !exec! :title
  set item=call !exec! :item
  set input=call !exec! :input



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

  echo.color=0b
  echo.clear=screen


  echo.cursor1=3 2
  echo.text=[       ] ==^>

  echo.up
  echo.right
  echo.color=0e
  echo.text=MikronT

  echo.up
  echo.right=13
  echo.text=%program_name%


  echo.cursor1=17 3
  echo.color=0f
  echo.text=%lang_logo1%


  echo.cursor1=2 4
  echo.text=━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


  echo.cursor1=4 5
  echo.color=0b
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



  echo.color=0f
  call echo.text=%%lang_!arg_title!%%

  if "!arg_sub!" NEQ "" (
    echo.color=07
    call echo.text=%%lang_!arg_sub!%%
  )

  echo.color=0b
  echo.down
exit /b







:item
  set arg_option=%1
  if "!arg_option!" NEQ "" set arg_option=!arg_option:"=!
  if "!arg_option!" ==  "" exit /b

  set arg_name=%2
  if "!arg_name!" NEQ "" set arg_name=!arg_name:"=!
  if "!arg_name!" ==  "" exit /b



  echo.color=0f
  echo.text=^(!arg_option!^)

  echo.up
  echo.right=4
  echo.color=0b
  call echo.text=%%lang_!arg_name!%%

  echo.left=4
exit /b







:input
  echo.cursor1=1 39
  echo.color=0f
  echo.text=^>
exit /b