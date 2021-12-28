*** Settings ***
Resource            ../Keywords/CommonRequestsKeywords.robot
Resource            ../TestData/EnvData.robot
Resource            ../Keywords/EA/StoreKeywords.robot
Resource            ../Keywords/EA/UserKeywords.robot
Resource            ../Keywords/EA/UploadFileKeywords.robot
Test Setup          Run Keywords    Set Initial Data - Store
Test Teardown       Delete All Sessions


*** Variables ***


*** Test Cases ***


Test Demo
    [Tags]  demo
    Log   1111

