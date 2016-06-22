@echo off
REM pack the memory stick with freesbb
IF "%1"=="" GOTO PARAM
IF NOT EXIST %1 GOTO PARAM

rmdir /s /q %1\freesbb
mkdir %1\freesbb
xcopy /S ..\freesbb %1\freesbb
copy /Y start_sbb_setup.sh %1\

goto END

:PARAM
echo 1 parameters required: USB Stick drive (for instance F:)

:END