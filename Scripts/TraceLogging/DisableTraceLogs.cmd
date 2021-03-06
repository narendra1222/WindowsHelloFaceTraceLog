@echo off
setlocal

PUSHD "%~dp0"

CALL CheckAdmin.cmd || GOTO :EOF

echo.
echo Enabling Face unlock, CredFrame, fingerprint, authux, enrollment, NGC, TPM, wbiosrvc, MFTrace logging
echo.
echo Setting permissions

SET SETACLEXE="SetACL.exe"
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\FaceReco" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\FaceTel" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\FaceTracker" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\FaceUnlock" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\FacePerf" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\BioEnrollment" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\sds_log" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\NGCTPMFingerprintCP" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\LogonUICredFrame" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\WinBioService" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1
%SETACLEXE% -on "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\MFTracing" -ot reg -actn setowner -ownr "n:builtin\Administrators" >nul 2>&1

echo.
echo Importing logging registry entries
echo.
reg import .\Config\FaceUnlock.reg
reg import .\Config\FaceReco.reg
reg import .\Config\FaceTel.reg
reg import .\Config\FaceTracker.reg
reg import .\Config\FacePerf.reg
reg import .\Config\BioEnrollment.reg
reg import .\Config\sds_log.reg
reg import .\Config\NGCTPMFingerprintCP.reg
reg import .\Config\LogonUICredFrame.reg
reg import .\Config\WinBioService.reg
reg import .\Config\MFTracing.reg

echo.
echo Stopping loggers

net stop wbiosrvc >nul 2>&1
net stop sensordataservice >nul 2>&1
net stop frameserver >nul 2>&1

logman stop FaceUnlock -ets >nul 2>&1
logman stop FaceCredProv -ets >nul 2>&1
logman stop FaceReco -ets >nul 2>&1
logman stop FaceTel -ets >nul 2>&1
logman stop FaceTracker -ets >nul 2>&1
logman stop FacePerf -ets >nul 2>&1
logman stop BioEnrollment -ets >nul 2>&1
logman stop sds_log -ets >nul 2>&1
logman stop NGCTPMFingerprintCP -ets >nul 2>&1
logman stop LogonUICredFrame -ets >nul 2>&1
logman stop WinBioService -ets >nul 2>&1
logman stop MFTracing -ets >nul 2>&1

del %WINDIR%\System32\LogFiles\WMI\FaceUnlock.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\FaceReco.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\FaceTel.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\FaceTracker.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\FacePerf.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\BioEnrollment.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\sds_log.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\NGCTPMFingerprintCP.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\LogonUICredFrame.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\WinBioService.etl* >nul 2>&1
del %WINDIR%\System32\LogFiles\WMI\MFTracing.etl* >nul 2>&1

reg import DisableAllLoggers.reg

echo.
