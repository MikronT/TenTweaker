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
  echo.text=[MikronT] ==^> %program_name%

  echo.cursor1=17 3
  echo.text=%lang_logo1%

  echo.cursor1=2 4
  echo.text=━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  echo.cursor1=4 5
  echo.text=%lang_logo2%

  echo.cursor1=8 6
  echo.text=github.com/MikronT

  %column_left%
exit /b







:input
  %align_left%
  echo.down=3
  echo.text=^>
exit /b