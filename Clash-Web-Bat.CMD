@echo off &title clash ����
::CODER BY pcysanji 2020-02-24
mode con cols=44 lines=24
color f1
SET PATH="%~dp0";"%~dp0App";%PATH%
:menu
CD /D %~DP0
taskkill /IM subconverter.exe >NUL 2>NUL
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >NUL
cls
echo.&echo.
echo -------------------------------------
echo.
echo  clash web ����̨
echo.
echo.  [1]   ���� clash
echo.
echo.  [2]   �ر� clash
echo.
echo.  [3]   ���������ļ�
echo.
echo.  [4]   ���ӵ���������
echo.
echo.  [5]   ���� GeoIP ���ݿ�
echo.
echo.  [X]   �˳�
echo.
echo -------------------------------------
echo.
choice /C:12345X /N /M "���������ѡ�� ��"

if errorlevel 6 exit
if errorlevel 5 goto :geoipupdate
if errorlevel 4 goto :startup
if errorlevel 3 goto :subconvert
if errorlevel 2 goto :stop-clash
if errorlevel 1 goto :start-clash

:start-clash
taskkill /IM clash-win64.exe >NUL 2>NUL
wscript ".\App\startclash.vbs" 
start http://127.0.0.1:9090/ui/#/proxies &cls
msg %username% /time:10s �����ɹ������� clash web ����̨�ɽ���ϵͳ����������
echo.
echo -------------------------------------
echo �����ɹ����Ƿ�����ϵͳ����
echo.
echo.&echo  [1]  �ǣ�������ϵͳ����
echo.&echo  [2]  �񲢷������˵�
echo.
echo.&echo  [X]  ֱ���˳�
echo.
echo ==============================
echo.
echo.
choice /C:12X /N /M "���������ѡ�� ��"

if errorlevel 3 exit
if errorlevel 2 goto :menu
if errorlevel 1 goto :setproxy

:setproxy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >NUL
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "127.0.0.1:7890" /f >NUL
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "" /f >NUL

echo ϵͳ����������ɣ�����������ز˵���&pause >NUL 2>NUL
goto menu

:stop-clash
taskkill /IM clash-win64.exe >NUL 2>NUL
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >NUL
echo �ɹ��ر�clash������������ز˵���&pause >NUL 2>NUL
goto menu

:subconvert
CLS
taskkill /IM clash-win64.exe >NUL 2>NUL
cd ".\App\subconverter"
wscript start-subconverter.vbs
CD /D %~DP0
echo.&echo.
echo -------------------------------------
echo.
set /p URL=�����붩�ĵ�ַ���س�:
copy  /y ".\Profile\*.yaml"  ".\Profile\*.yaml-bak" >NUL 2>NUL
cls
echo.&echo.
echo -------------------------------------
echo.
echo �����벻����׺��,���鴿Ӣ�ĵ������ļ�����ֱ�ӻس������ļ�����Ϊ config
echo.
set /p configname=�����������ļ������س�:
if "%configname%"=="" (wget -O ".\Profile\config.yaml" "%URL%") else (
wget -O ".\Profile\%configname%.yaml" "%URL%" )
cls
echo.&echo.
echo -------------------------------------
echo.
echo ������ɣ��������ļ�.yaml����Ϊ.yaml-bak���Ƿ����� Clash��
echo.
echo.  [1]   ���� clash
echo.
echo.  [2]   ���ز˵�
echo.
echo.  [X]   �˳�
echo.
choice /C:12X /N /M "���������ѡ�� ��"

if errorlevel 3 goto exit
if errorlevel 2 goto menu
if errorlevel 1 call selectprofile

:startup
call startup.bat
exit

:geoipupdate
cd "%~DP0Profile\" 
wget -O GeoLite2-Country.tar.gz "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=oeEqpP5QI21N&suffix=tar.gz"
7za.exe e GeoLite2-Country.tar.gz
7za e GeoLite2-Country.tar "GeoLite2-Country*\GeoLite2-Country.mmdb" -aoa
del "Country.mmdb" /f /q
del "GeoLite2-Country.tar*" /f /q
ren GeoLite2-Country.mmdb Country.mmdb
cls
echo.&echo.
echo -------------------------------------
echo.
echo ���³ɹ�������������ز˵���&pause >NUL 2>NUL
goto menu

:exit
taskkill /IM subconverter.exe >NUL 2>NUL
taskkill /IM clash-win64.exe >NUL 2>NUL
exit