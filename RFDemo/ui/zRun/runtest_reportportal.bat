@echo off
echo Execute RobotFramework test with reportportal

set project=%1
set launch=UIAutomation_%2_%3
echo %launch%
if "%3"=="" (
    robot --listener robotframework_reportportal.listener --variable RP_UUID:"ba3ab889-43bb-451f-bfdd-10a6d51bab1d" --variable RP_ENDPOINT:"http://10.16.2.105/" --variable RP_LAUNCH:%launch% --variable RP_PROJECT:%project% --variable RP_ATTACH_LOG:"True" --outputdir ../Results -i %2  ../TestCase
) else (
    robot --listener robotframework_reportportal.listener --variable RP_UUID:"ba3ab889-43bb-451f-bfdd-10a6d51bab1d" --variable RP_ENDPOINT:"http://10.16.2.105/" --variable RP_LAUNCH:%launch% --variable RP_PROJECT:%project% --variable RP_ATTACH_LOG:"True" --outputdir ../Results -i %2 -v ENV:%3  ../TestCase
)

@echo on
