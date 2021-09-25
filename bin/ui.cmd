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
  mode con:cols=124 lines=39
  title [MikronT] %program_name%
  color 0b
  cls

  echo.
  echo.
  echo.    [MikronT] ==^> %program_name%
  echo.                  %lang_logo1%
  echo.   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  echo.     %lang_logo2%
  echo.         github.com/MikronT
  echo.
  echo.
  echo.
exit /b