*** Settings ***
Resource            ../Keywords/CommonRequestsKeywords.robot
Resource            ../TestData/EnvData.robot
Resource            ../Keywords/MP/StoreKeywords.robot
Resource            ../Keywords/MP/UserKeywords.robot
Resource            ../Keywords/MP/UploadFileKeywords.robot
Test Setup          Run Keywords    Set Initial Data - Store
Test Teardown       Delete All Sessions


*** Variables ***


*** Test Cases ***


Test Demo
    [Tags]  demo11
    Upload Store Logo JPEG - POST
    Upload Store Banner JPEG - POST

