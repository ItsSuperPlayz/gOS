@echo off
setlocal EnableDelayedExpansion
mode con: cols=53 lines=19
chcp 65001
for /f %%a in ('copy /z "%~f0" nul') do set "CR=%%a"
for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "BS=%%A"
cls
title gOS
call :logo
call :bar
timeout 3 /nobreak >nul
for /f "tokens=1,2,3,4 delims=:." %%a in ('echo %time%') do (set /a h=%%a) & (set /a m=%%b) & (set /a s=%%c) & (set /a ms=%%d)
<nul set /p =.!BS!%bar1%!CR!
call :text
call :reset
<nul set /p =.!BS!%bar2%!CR!
net session >nul 2>nul
if %errorlevel% neq 0 (
call :fail 1
)
<nul set /p =.!BS!%bar3%!CR!
net start beep >nul 2>nul
<nul set /p =.!BS!%bar4%!CR!
net stop beep >nul 2>nul
<nul set /p =.!BS!%bar5%!CR!
cd /d %temp%
if exist gOS_settings.txt (for /f "tokens=1,2,3,4 delims=; " %%A in (gOS_settings.txt) do (set hidectrl=%%A) & (set back=%%B) & (set fore=%%C) & (set delay=%%D))
<nul set /p =.!BS!%bar6%!CR!
for /f "tokens=1,2,3,4 delims=:." %%a in ('echo %time%') do (set /a h=%%a - %h%) & (set /a m=%%b - %m%) & (set /a s=%%c - %s%) & (if %%d geq %ms% (set /a ms=%%d - %ms%) else (set /a ms-=%%d) & (set /a s-=1))
set /a s=%h% * 3600 + %m% * 60 + %s%
timeout 3 /nobreak >nul
::<nul set /p =%bar7%!CR!Done in %s%.%ms%s.
<nul set /p =%bar7%!CR!!BS!
timeout 2 /nobreak >nul
:draw
color %back%%fore%
if %hidectrl%==0 (mode con: cols=53 lines=19) else (mode con: cols=53 lines=17)
cls
call :reset
if %tab%==1 call :tab_1 & call :content_1
if %tab%==2 call :tab_2 & call :content_2
if %tab%==3 call :tab_3 & call :content_3
if %tab%==4 call :tab_4 & call :content_4
if %hidectrl%==0 (call :tab_5) else (call :tab_7)
call :help
goto main
:main
choice /c ADWSF /n >nul
if %errorlevel%==1 goto limit_l
if %errorlevel%==2 goto limit_r
if %errorlevel%==3 goto limit_u
if %errorlevel%==4 goto limit_d
if %errorlevel%==5 goto choices
goto main
:limit_l
if %tab%==1 goto main
set /a tab-=1
set select=1
set confirm=0
goto draw
:limit_r
if %tab%==4 goto main
set /a tab+=1
set select=1
set confirm=0
goto draw
:limit_u
if %select%==1 goto main
if %tab%==3 (
if %select%==9 (set select=3) & goto draw
)
if %tab%==4 goto main
set /a select-=1
set confirm=0
goto draw
:limit_d
if %tab%==2 (
if %select%==4 goto main
)
if %tab%==3 (
if %select%==10 goto main
if %select%==3 set select=9 & goto draw
)
if %tab%==4 goto main
set /a select+=1
set confirm=0
goto draw
:choices
if %tab%==2 goto power
if %tab%==3 goto settings
goto main
:power
if %select%==1 (
cls
call :logo
net start beep >nul 2>nul
timeout 3 /nobreak >nul
exit
)
if %select%==2 shutdown /s /t %delay%
if %select%==3 shutdown /r /t %delay%
if %select%==4 (
shutdown /s /fw /t %delay% >nul 2>nul
if %errorlevel% neq 0 (
<nul set /p =This feature is not supported on your computer.!CR!
goto main
)
)
if %delay%==0 (
if %select%==2 (<nul set /p =Shutting down...                                     !CR!) & goto main
if %select%==3 (<nul set /p =Restarting...                                        !CR!) & goto main
if %select%==4 (<nul set /p =Restarting...                                        !CR!) & goto main
) else (
if %select%==2 (<nul set /p =Shutting down in %delay% seconds.          [C]ancel!CR!)
if %select%==3 (<nul set /p =Restarting in %delay% seconds.          [C]ancel!CR!)
if %select%==4 (<nul set /p =Restarting in %delay% seconds.          [C]ancel!CR!)
)
:c
choice /c c /n >nul
if %errorlevel%==1 (
shutdown /a
<nul set /p =Canceled shutdown / restart.                        !CR!
goto main
) else (
goto c
)
goto draw
:settings
if %select%==1 (
if %hidectrl%==0 (set hidectrl=1) & goto draw
set hidectrl=0 & goto draw
)
if %select%==2 goto color
if %select%==3 goto delay
if %select%==9 goto save
if %select%==10 goto resetdefaults
goto draw
:delay
if %delay%==0 (set delay=3) & goto draw
if %delay%==3 (set delay=5) & goto draw
if %delay%==5 (set delay=10) & goto draw
if %delay%==10 (set delay=30) & goto draw
if %delay%==30 (set delay=60) & goto draw
if %delay%==60 (set delay=0) & goto draw
:save
cd /d %temp%
echo %hidectrl%;%back%;%fore%;%delay% >gOS_settings.txt
<nul set /p =Successfully saved settings.                        !CR!
goto main
:resetdefaults
if %confirm%==0 (
set confirm=1
<nul set /p =%ctext%!CR!
goto main
)
if %confirm%==1 (
set confirm=0
call :defaults
cd /d %temp%
if exist gOS_settings.txt (del gOS_settings.txt)
goto draw
)
:color
cls
call :reset
call :tab_3
call :box_1
if %hidectrl%==0 call :tab_6
if %hidectrl%==1 call :tab_7
set /p input=Choose background color (current: %back%): 
for %%A in (%colorcode%) do (if /i "%input%"=="%%A" (set back=%%A) & (goto color2))
goto color
:color2
cls
call :reset
call :tab_3
call :box_1
if %hidectrl%==0 call :tab_6
if %hidectrl%==1 call :tab_7
set /p input=Choose text color (current: %fore%): 
for %%A in (%colorcode%) do (if /i "%input%"=="%%A" (set fore=%%A) & (goto color3))
goto color2
:color3
color %back%%fore%
goto draw
:logo
echo.
echo.
echo.
echo.
echo.
echo                         _____ _____
echo                   _____/     \     \
echo                  /     ^|  ^|  ^|  ^|__/
echo                  ^|  ^|  ^|  ^|  ^|__   \
echo                  ^|  ^|  ^|  ^|  ^|  ^|  ^|
echo                  \__   \_____/_____/
echo                  \_____/
echo.
echo.
goto :eof
:tab_1
echo ╔════════════╦══════════════════════════════════════╗
echo ║    MAIN    ║    power      settings       about   ║
echo ║            ╚══════════════════════════════════════╣
goto :eof
:content_1
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
goto :eof
:tab_2
echo ╔════════════╦════════════╦═════════════════════════╗
echo ║    main    ║    POWER   ║  settings       about   ║
echo ╠════════════╝            ╚═════════════════════════╣
goto :eof
:content_2
if %select%==1 (set select1l=%la%) & (set select1r=%ra%)
if %select%==2 (set select2l=%la%) & (set select2r=%ra%)
if %select%==3 (set select3l=%la%) & (set select3r=%ra%)
if %select%==4 (set select4l=%la%) & (set select4r=%ra%)
echo ║                                                   ║
echo ║%select1l%Quit gOS%select1r%                                       ║
echo ║                                                   ║
echo ║%select2l%Shut down%select2r%                                      ║
echo ║%select3l%Restart%select3r%                                        ║
echo ║%select4l%Boot to BIOS%select4r%                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
goto :eof
:tab_3
echo ╔═════════════════════════╦════════════╦════════════╗
echo ║    main         power   ║  SETTINGS  ║    about   ║
echo ╠═════════════════════════╝            ╚════════════╣
goto :eof
:content_3
if %select%==1 (set select1l=%la%) & (set select1r=%ra%)
if %select%==2 (set select2l=%la%) & (set select2r=%ra%)
if %select%==3 (set select3l=%la%) & (set select3r=%ra%)
if %select%==9 (set select9l=%la%) & (set select9r=%ra%)
if %select%==10 (set select10l=%la%) & (set select10r=%ra%)
if %hidectrl%==1 set state1=%on%
if %delay% neq 0 (
if %delay% geq 10 (set state2= %delay%) else (set state2=  %delay%)
)
echo ║                                                   ║
echo ║%select1l%Hide controls%select1r%                             %state1%  ║
echo ║%select2l%Change background and text color%select2r%               ║
echo ║%select3l%POWER delay%select3r%                               %state2%  ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║%select9l%Save settings%select9r%                                  ║
echo ║%select10l%Reset to defaults%select10r%                              ║
echo ║                                                   ║
goto :eof
:tab_4
echo ╔══════════════════════════════════════╦════════════╗
echo ║    main         power      settings  ║    ABOUT   ║
echo ╠══════════════════════════════════════╝            ║
goto :eof
:content_4
echo ║                                                   ║
echo ║                                                   ║
echo ║                        gOS                        ║
echo ║               Build 1 - 25.01.2024                ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
echo ║                                                   ║
goto :eof
:tab_5
echo ╠═══════════════════════════════════════════════════╣
echo ║    [A] ←   [D] →   [W] ↑   [S] ↓   [F] Select     ║
echo ╚═══════════════════════════════════════════════════╝
goto :eof
:tab_6
echo ╠═══════════════════════════════════════════════════╣
echo ║                   [ENTER] Select                  ║
echo ╚═══════════════════════════════════════════════════╝
goto :eof
:tab_7
echo ╚═══════════════════════════════════════════════════╝
goto :eof
:tab_8
echo ╠═══════════════════════════════════════════════════╣
echo ║          [A] ←     [D] →     [F] Select           ║
echo ╚═══════════════════════════════════════════════════╝
goto :eof
:tab_9
echo ╠═══════════════════════════════════════════════════╣
echo ║                                                   ║
echo ╚═══════════════════════════════════════════════════╝
goto :eof
:box_1
echo ║                                                   ║
echo ║  ╔═════════════════════════════════════════════╗  ║
echo ║  ║     0 = Black          8 = Gray             ║  ║
echo ║  ║     1 = Blue           9 = Light Blue       ║  ║
echo ║  ║     2 = Green          A = Light Green      ║  ║
echo ║  ║     3 = Aqua           B = Light Aqua       ║  ║
echo ║  ║     4 = Red            C = Light Red        ║  ║
echo ║  ║     5 = Purple         D = Light Purple     ║  ║
echo ║  ║     6 = Yellow         E = Light Yellow     ║  ║
echo ║  ║     7 = White          F = Bright White     ║  ║
echo ║  ╚═════════════════════════════════════════════╝  ║
echo ║                                                   ║
goto :eof
:text
set blank=  
set ctext=Press [F] again to confirm action.                   
set la=˃ 
set ra= ˂
set on= ON
set off=OFF
set tab=1
set select=1
set confirm=0
set colorcode=0;1;2;3;4;5;6;7;8;9;A;B;C;D;E;F
:defaults
set hidectrl=0
set back=1
set fore=F
set delay=0
goto :eof
:reset
set input=none
set select1l=%blank%
set select1r=%blank%
set select2l=%blank%
set select2r=%blank%
set select3l=%blank%
set select3r=%blank%
set select4l=%blank%
set select4r=%blank%
set select9l=%blank%
set select9r=%blank%
set select10l=%blank%
set select10r=%blank%
set state1=%off%
set state2=%off%
goto :eof
:help
set text= 
if %tab%==2 (
if %select%==1 set text=Quits this program.
if %select%==2 set text=Shuts down this computer.
if %select%==3 set text=Restarts this computer.
if %select%==4 set text=Restarts then automatically enters BIOS.
)
if %tab%==3 (
if %select%==1 set text=Hides the control instructions bar.
if %select%==2 set text=Self-explanatory.
if %select%==3 set "text=Adds delay (in seconds) to options in "POWER" tab."
if %select%==9 set text=Saves the current settings.
if %select%==10 set text=Resets all settings to its defaults.
)
<nul set /p =%text%!CR!
goto :eof
:bar
set bar1=               ░░░░░░░░░░░░░░░░░░░░░░░
set bar2=               ███░░░░░░░░░░░░░░░░░░░░
set bar3=               ████████░░░░░░░░░░░░░░░
set bar4=               █████████████░░░░░░░░░░
set bar5=               ██████████████████░░░░░
set bar6=               ███████████████████████
set bar7=.                                     
goto :eof
:fail
if %1==1 (
echo.
echo Boot failed: NO_ADMIN_PRIVILEGES
pause >nul
exit
)
if %1==2 (
echo.
echo Boot failed: LOAD_CONFIG_FAIL
pause >nul
exit
)
goto :eof
endlocal
::BUILD 0 - 14.01.2024
::- Designed UI
::- Added "ABOUT" text
::- Added Settings
::BUILD 1 - 25.01.2024
::- Added "POWER" options
::- Fixed bugs
::- Simplified scripts