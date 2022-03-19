@echo off
echo Will Create a new folder to save log file
echo Please execute the file in folder automation-robot-ui

@echo off
for /f "tokens=1-3 delims=-/ " %%1 in ("%date%") do set ddd=%%1%%2%%3
for /f "tokens=1-4 delims=.: " %%1 in ("%time%") do set tttt=%%1%%2%%3%%4
Set DT=%ddd%%tttt%

set DIR= %DT%
md %DIR%
cd %DIR%
@echo  %cd%

if "%2"=="" (
    robot -i %1  ../TestCase
) else (
    robot -i %1 -v ENV:%2  ../TestCase
)

@echo on
