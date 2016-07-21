@echo off
REM Copyright (C) Schweizerische Bundesbahnen SBB, 2016
REM pack the memory stick with freesbb
REM pack_usb_stick <keyfile_with_path> <setup_startscript_with_path>
IF "%1"=="" GOTO PARAM
IF NOT EXIST %1 GOTO FILE

copy /Y start_setup.sh %1

IF EXIST %1\freesbb rmdir /s /q %1\freesbb
mkdir %1\freesbb

xcopy /S ..\freesbb %1\freesbb
copy /Y ..\setup_freesbb.sh %1\

IF "%2"=="" GOTO END
IF NOT EXIST %2 GOTO END
copy /Y %2 %1\

IF "%3"=="" GOTO END
IF NOT EXIST %3 GOTO END
copy /Y %3 %1\

IF "%4"=="" GOTO END
IF NOT EXIST %4 GOTO END
copy /Y %4 %1\

goto END

:PARAM
echo 1 parameters required: USB Stick drive (for instance F:), 3 optional parameters: 3 optional parameters: key file with path, start script with path, ssmtp.conf with path
goto END

:FILE
echo Drive or path %1 not found
goto END

:END