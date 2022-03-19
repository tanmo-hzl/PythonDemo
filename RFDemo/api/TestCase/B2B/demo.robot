*** Settings ***
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/UploadFileKeywords.robot
#Suite Setup          Run Keywords    Set Initial Data - B2B - User

*** Variables ***


*** Test Cases ***


Test Demo
    [Tags]  b2b-demo1
    Upload B2B File

