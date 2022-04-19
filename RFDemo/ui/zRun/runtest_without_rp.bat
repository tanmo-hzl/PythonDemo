@echo off
echo Execute Robot Test without reportportal

if "%2"=="" (
    robot -i %1  ../TestCase
) else (
    robot -i %1 -v ENV:%2  ../TestCase
)

@echo on
