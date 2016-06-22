@echo off
REM pack the memory stick with freesbb
IF "%1"=="" GOTO PARAM
IF NOT EXIST %1 GOTO PARAM

copy /Y start_setup_all.sh %1

rmdir /s /q %1\freesbb
del /q %1\setup_freesbb.sh
if NOT "%2"=="freesbb" GOTO END

mkdir %1\freesbb
xcopy /S ..\freesbb %1\freesbb
copy /Y ..\setup_freesbb.sh %1

goto END

:PARAM
echo 1 parameters required: USB Stick drive (for instance F:), optional second parameter "freesbb" if freesbb is desired

:END