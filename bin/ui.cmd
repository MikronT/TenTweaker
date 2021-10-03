@echo off
chcp 65001>nul

call %*
exit /b !errorLevel!







:init
  set exec=%1\%~nx0



  set logo=call !exec! :logo



  set exec=
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

  echo.cursor1=1 10
exit /b