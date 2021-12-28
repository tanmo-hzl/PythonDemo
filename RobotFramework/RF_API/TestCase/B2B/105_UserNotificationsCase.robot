*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/NotificationsKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Notifications
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Get User Notifications
    [Tags]   b2b    b2b-notifications
    Get User Notifications List - GET

Test Remove User Notifications
    [Tags]   b2b    b2b-notifications
    Del User Notifications - PATCH





