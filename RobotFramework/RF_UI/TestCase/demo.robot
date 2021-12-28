*** Settings ***
Library             Selenium2Library
Suite Teardown      Close Browser

*** Variables ***
${URL}          https://www.baidu.com
${BROWSER}      Chrome

*** Test Cases ***
Test Demo
    [Tags]   demodd
    Open Browser    ${URL}    ${BROWSER}
    Sleep    10





