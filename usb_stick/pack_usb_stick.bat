@echo off
REM Copyright (C) Schweizerische Bundesbahnen SBB, 2016
REM pack the memory stick with freesbb
IF "%1"=="" GOTO PARAM
IF NOT EXIST %1 GOTO FILE

copy /Y start_setup.sh %1

IF EXIST %1\freesbb rmdir /s /q %1\freesbb
mkdir %1\freesbb

xcopy /S ..\freesbb %1\freesbb
copy /Y ..\setup_freesbb.sh %1\

IF NOT EXIST %2 GOTO END
copy /Y %2 %1\

IF NOT EXIST %3 GOTO END
copy /Y %3 %1\

goto END

:PARAM
echo 1 parameters required: USB Stick drive (for instance F:), 2 optional parameters: key file with path, start script with path
goto END

:FILE
echo Drive or path %1 not found
goto END

:END