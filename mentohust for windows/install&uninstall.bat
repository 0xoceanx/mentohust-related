color 0a
pushd %~dp0
set WinVer=VistaWin7
ver|find /i "5">nul && set WinVer=WinXP
if /I not "%WinVer%"=="WinXP" (
echo.
echo.请确定您已使用管理员身份运行该脚本
pause >nul
)

:Start
cls
echo.
echo　　　　　　　　　　╔══════════════════╗
echo　　　　　　　　　　║　　　　WinPcap　安装 ^& 卸载　　　　║
echo　　　　　　╔═══╩══════════════════╩═══╗
echo　　　　　　║　　　　　　　　　　　　　　　　　　　　　　　　　　║
echo　　　　　　║　　　　1、安装　　　 2、卸载　　　　3、退出　　　　║
echo　　　　　　║　　　　　　　　　　　　　　　　　　　　　　　　　　║
echo　　　　　　╚══════════════════════════╝
echo.　
SET /P Choice=　　　　　请选择要进行的操作[1-3]，然后回车：
cls
echo.
If "%Choice%"=="" Goto Start
Set Choice=%Choice:~0,1%
if /I "%Choice%"=="1" goto Install
if /I "%Choice%"=="2" goto Uninstall
if /I "%Choice%"=="3" goto End
goto End

:Install
if /I "%PROCESSOR_IDENTIFIER:~0,3%"=="x64" (
move /Y "wpcap.dll" "%SystemRoot%\systemWOW64"
move /Y "Packet.dll" "%SystemRoot%\systemWOW64"
move /Y "x64_npf.sys" "%SystemRoot%\system32\drivers\npf.sys"
del "x86_npf.sys" 2>nul
) else (
move /Y "wpcap.dll" "%SystemRoot%\system32"
move /Y "Packet.dll" "%SystemRoot%\system32"
move /Y "x86_npf.sys" "%SystemRoot%\system32\drivers\npf.sys"
del "x64_npf.sys" 2>nul
)
sc query NPF | find "NPF">nul && sc delete NPF
sc create NPF type= kernel binpath= "system32\drivers\NPF.sys" displayname= "WinPcap Packet Driver (NPF)"
echo.安装完成，按任意键退出
pause >nul
goto End

:Uninstall
net stop NPF
sc delete NPF
if /I "%PROCESSOR_IDENTIFIER:~0,3%"=="x64" (
move /Y "%SystemRoot%\systemWOW64\wpcap.dll" .
move /Y "%SystemRoot%\systemWOW64\Packet.dll" .
move /Y "%SystemRoot%\system32\drivers\npf.sys" ".\x64_npf.sys"
) else (
move /Y "%SystemRoot%\system32\wpcap.dll" .
move /Y "%SystemRoot%\system32\Packet.dll" .
move /Y "%SystemRoot%\system32\drivers\npf.sys" ".\x86_npf.sys"
)
echo.卸载完成，按任意键退出
pause >nul
goto End

:End
cls
color 0f
popd