@echo off
::Auto-elevate Admistrator by Matt (https://stackoverflow.com/a/12264592)
:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~dpnx0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )
:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO Please wait...
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
if '%cmdInvoke%'=='1' goto InvokeCmd 
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation
:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"
:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B
:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::                                                                    gOS starts here
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
timeout 3 /nobreak >nul
<nul set /p =.!BS!%bar7%!CR!
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
:ctrl
choice /c ADWSF /n >nul
if %errorlevel%==1 goto limit_l
if %errorlevel%==2 goto limit_r
if %errorlevel%==3 goto limit_u
if %errorlevel%==4 goto limit_d
if %errorlevel%==5 goto choices
goto ctrl
:limit_l
if %tab%==1 goto ctrl
set /a tab-=1
set select=1
set confirm=0
set egg=0
goto draw
:limit_r
if %tab%==4 goto ctrl
set /a tab+=1
set select=1
set confirm=0
goto draw
:limit_u
if %select%==1 goto ctrl
if %tab%==3 (
if %select%==9 (set select=3) & goto draw
)
if %tab%==4 goto ctrl
set /a select-=1
set confirm=0
goto draw
:limit_d
if %tab%==1 goto ctrl
if %tab%==2 (
if %select%==4 goto ctrl
)
if %tab%==3 (
if %select%==10 goto ctrl
if %select%==3 set select=9 & goto draw
)
if %tab%==4 (
set /a egg+=1
if %egg%==4 (<nul set /p =What are you nerd doing here?)
goto ctrl
)
set /a select+=1
set confirm=0
goto draw
:choices
if %tab%==1 goto main
if %tab%==2 goto power
if %tab%==3 goto settings
goto ctrl
:main
if %select%==1 (
goto activator0
)
goto draw
:activator0
cls
call :tab_1 & call :box_2
if %hidectrl%==1 (call :tab_7) else (call :tab_10)
choice /c yn /n >nul
if %errorlevel%==1 goto activator
if %errorlevel%==2 goto draw
:activator
cls
call :tab_1 & call :box_3
if %hidectrl%==1 (call :tab_7) else (call :tab_9)
<nul set /p =Checking internet connection...!CR!
ver >nul
ping google.com >nul
if %errorlevel% neq 0 (
<nul set /p =Failed: No internet connection.  [Any key] Go back  !CR!
pause >nul
goto draw
)
<nul set /p =Beginning the activation process...                 !CR!
timeout 2 /nobreak >nul
<nul set /p =Detecting Office 2010...                            !CR!
if exist "%ProgramFiles%\Microsoft Office\Office14\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office14" & (<nul set /p =Found Office 2010. Activating...                    !CR!) & goto office14
if exist "%ProgramFiles(x86)%\Microsoft Office\Office14\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office14" & (<nul set /p =Found Office 2010. Activating...                    !CR!) & goto office14
<nul set /p =Detecting Office 2013...                            !CR!
if exist "%ProgramFiles%\Microsoft Office\Office15\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office15" & goto office15
if exist "%ProgramFiles(x86)%\Microsoft Office\Office15\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office15" & goto office15
<nul set /p =Detecting Office 2016 / 2019 / 2021 / 365...        !CR!
if exist "%ProgramFiles%\Microsoft Office\Office16" cd /d "%ProgramFiles%\Microsoft Office\Office16" & goto office16
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16" & goto office16
<nul set /p =Failed: No Office was found.     [Any key] Go back  !CR!
pause >nul
goto draw
:office14
timeout 2 /nobreak >nul
<nul set /p =(1 / 3) Installing license key...                   !CR!
cscript ospp.vbs /inpkey:VYBBJ-TRJPB-QFQRF-QFT4D-H3GVB >%temp%\log.txt
cscript ospp.vbs /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT >>%temp%\log.txt
<nul set /p =(2 / 3) Changing host...                            !CR!
cscript ospp.vbs /sethst:kms8.msguides.com >>%temp%\log.txt
cscript ospp.vbs /setprt:1688 >%temp%\log.txt
<nul set /p =(3 / 3) Activating...                               !CR!
cscript ospp.vbs /act >>%temp%\log.txt
goto activator2
:office15
<nul set /p =Found Office 2013. Activating...                    !CR!
goto office14
:office16
for /f %x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%x" >nul && goto 2016
for /f %x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%x" >nul && goto 2019
for /f %x in ('dir /b ..\root\Licenses16\ProPlus2021VL_KMS*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%x" >nul && goto 2021
exit
:2016
<nul set /p =Found Office 2016 / 365. Activating...              !CR!
timeout 2 /nobreak >nul
<nul set /p =(1 / 3) Installing license key...                   !CR!
cscript ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >%temp%\log.txt
cscript ospp.vbs /unpkey:BTDRB >>%temp%\log.txt
cscript ospp.vbs /unpkey:KHGM9 >>%temp%\log.txt
cscript ospp.vbs /unpkey:CPQVG >>%temp%\log.txt
<nul set /p =(2 / 3) Changing host...                            !CR!
cscript ospp.vbs /sethst:107.175.77.7 >>%temp%\log.txt
cscript ospp.vbs /setprt:1688 >>%temp%\log.txt
<nul set /p =(3 / 3) Activating...                               !CR!
cscript ospp.vbs /act >>%temp%\log.txt
goto activator2
:2019
<nul set /p =Found Office 2019. Activating...                    !CR!
timeout 2 /nobreak >nul
<nul set /p =(1 / 3) Installing license key...                   !CR!
cscript ospp.vbs /unpkey:6MWKP >%temp%\log.txt
cscript ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP >>%temp%\log.txt
<nul set /p =(2 / 3) Changing host...                            !CR!
cscript ospp.vbs /sethst:107.175.77.7 >>%temp%\log.txt
cscript ospp.vbs /setprt:1688 >>%temp%\log.txt
<nul set /p =(3 / 3) Activating...                               !CR!
cscript ospp.vbs /act >>%temp%\log.txt
goto activator2
:2021
<nul set /p =Found Office 2021. Activating...                    !CR!
timeout 2 /nobreak >nul
<nul set /p =(1 / 3) Installing license key...                   !CR!
cscript ospp.vbs /unpkey:6F7TH >%temp%\log.txt
cscript ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH >>%temp%\log.txt
<nul set /p =(2 / 3) Changing host...                            !CR!
cscript ospp.vbs /sethst:107.175.77.7 >>%temp%\log.txt
cscript ospp.vbs /setprt:1688 >>%temp%\log.txt
<nul set /p =(3 / 3) Activating...                               !CR!
cscript ospp.vbs /act >>%temp%\log.txt
:activator2
ver >nul
find /i "Product activation successful" %temp%\log.txt >nul
if %errorlevel%==1 (
<nul set /p =Failed: Please try again.        [Any key] Go back  !CR!
pause >nul
) else (
<nul set /p =Activation succeeded.            [Any key] Go back  !CR!
pause >nul
)
del %temp%\log.txt
goto draw
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
goto ctrl
)
)
if %delay%==0 (
if %select%==2 (<nul set /p =Shutting down...                                     !CR!) & goto ctrl
if %select%==3 (<nul set /p =Restarting...                                        !CR!) & goto ctrl
if %select%==4 (<nul set /p =Restarting...                                        !CR!) & goto ctrl
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
goto ctrl
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
echo %hidectrl%;%back%;%fore%;%delay% >%temp%\gOS_settings.txt
<nul set /p =Successfully saved settings.                        !CR!
goto ctrl
:resetdefaults
if %confirm%==0 (
set confirm=1
<nul set /p =%ctext%!CR!
goto ctrl
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
set /p input=Set background color (current: %back%): 
for %%A in (%colorcode%) do (if /i "%input%"=="%%A" (set back=%%A) & (goto color2))
goto color
:color2
cls
call :reset
call :tab_3
call :box_1
if %hidectrl%==0 call :tab_6
if %hidectrl%==1 call :tab_7
set /p input=Set text color (current: %fore%): 
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
if %select%==1 (set select1l=%la%) & (set select1r=%ra%)
echo ║                                                   ║
echo ║%select1l%MS Office Activator%select1r%                            ║
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
echo ║       This program is designed to work on         ║
echo ║        Windows Command Prompt (cmd.exe).          ║
echo ║   May not render correctly on Windows Terminal.   ║
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
:tab_10
echo ╠═══════════════════════════════════════════════════╣
echo ║                 [Y]es      [N]o                   ║
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
:box_2
echo ║                                                   ║
echo ║  ╔═════════════════════════════════════════════╗  ║
echo ║  ║                   WARNING                   ║  ║
echo ║  ║                                             ║  ║
echo ║  ║ This feature VIOLATES Microsoft Terms of    ║  ║
echo ║  ║ Use (microsoft.com/en-us/legal/terms-of-use)║  ║
echo ║  ║                                             ║  ║
echo ║  ║ Using this will most likely VOID your       ║  ║
echo ║  ║ current license key.                        ║  ║
echo ║  ║           Are you sure to continue?         ║  ║
echo ║  ╚═════════════════════════════════════════════╝  ║
echo ║                                                   ║
goto :eof
:box_3
echo ║                                                   ║
echo ║  ╔═════════════════════════════════════════════╗  ║
echo ║  ║                 Please wait...              ║  ║
echo ║  ║                                             ║  ║
echo ║  ║Activation methods by MS Guides(msguides.com)║  ║
echo ║  ║                                             ║  ║
echo ║  ║ After activation ends SUCCESSFULLY, open    ║  ║
echo ║  ║ any Office application and go to Files ^>    ║  ║
echo ║  ║ Account to check the activation status.     ║  ║
echo ║  ║Note: This feature may not work as intended. ║  ║
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
set egg=0
set colorcode=0;1;2;3;4;5;6;7;8;9;A;B;C;D;E;F
:defaults
set hidectrl=0
set back=0
set fore=7
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
set "text= "
if %tab%==1 (
if %select%==1 set text=Activates all versions of Office with no costs.
)
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
set bar1=              ░░░░░░░░░░░░░░░░░░░░░░░░░
set bar2=              █████░░░░░░░░░░░░░░░░░░░░
set bar3=              ██████████░░░░░░░░░░░░░░░
set bar4=              ███████████████░░░░░░░░░░
set bar5=              ████████████████████░░░░░
set bar6=              █████████████████████████
set bar7=                                       
goto :eof
:fail
if %1==1 (
echo.
echo Boot failed: No Administrator privileges.
pause >nul
exit
)
if %1==2 (
echo.
echo Boot failed: Failed while loading settings.
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
::- Added help text
::- Added progress bar at boot (actually works!)
::- Stole some office activator :D
::- Stole auto-elevate from Matt LOL
::- Fixed bugs