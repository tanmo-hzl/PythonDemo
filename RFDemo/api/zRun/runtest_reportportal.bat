@echo off
echo Execute RobotFramework test with reportportal

if "%2"=="" (
    robot --listener robotframework_reportportal.listener --variable RP_UUID:"ba3ab889-43bb-451f-bfdd-10a6d51bab1d" --variable RP_ENDPOINT:"http://10.16.2.105/" --variable RP_LAUNCH:"API_Automation_EA_Launch" --variable RP_PROJECT:"AUTOMATION-ROBOT-API" --outputdir ../Results -i %1  ../TestCase
) else (
    robot --listener robotframework_reportportal.listener --variable RP_UUID:"ba3ab889-43bb-451f-bfdd-10a6d51bab1d" --variable RP_ENDPOINT:"http://10.16.2.105/" --variable RP_LAUNCH:"API_Automation_EA_Launch" --variable RP_PROJECT:"AUTOMATION-ROBOT-API" --outputdir ../Results -i %1 -v ENV:%2  ../TestCase
)

@echo on
