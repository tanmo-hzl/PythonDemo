*** Settings ***
Resource            ../Keywords/Common/CommonKeywords.robot
Resource            ../Keywords/MP/EAInitialSellerDataAPiKeywords.robot

*** Variables ***
${URL}          https://www.baidu.com
${BROWSER}      Chrome
@{aa}     00    11    22    33   44

*** Keywords ***


*** Test Cases ***
Test Pass
    [Documentation]    test pass pass
    [Tags]   demodd    deed
    Initial Env Data
    API - Get Store Product List





