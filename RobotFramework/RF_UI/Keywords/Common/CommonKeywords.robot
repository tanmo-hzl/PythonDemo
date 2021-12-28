*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Cur_Case_Status}    ${True}
${Par_Case_Status}    PASS
${Fail_Skip}    ${True}

*** Keywords ***
Initial Env Data
    Set Selenium Timeout     ${TIME_OUT}
    ${config}    Get Config Ini    ${ENV}
    ${item}    Set Variable
    FOR    ${item}    IN    &{config}
        LOG    ${item[0]}
        Set Suite Variable    ${${item[0]}}    ${item[1]}
    END
    ${RETURN_OR_ENTER}    Return Or Enter Key
    Set Suite Variable    ${RETURN_OR_ENTER}   ${RETURN_OR_ENTER}
    ${CTRL_OR_COMMAND}    Ctrl Or Command Key
    Set Suite Variable    ${CTRL_OR_COMMAND}   ${CTRL_OR_COMMAND}

Initial Data And Open Browser
    [Arguments]    ${url}    ${brower_name}=buyer
    Initial Env Data
    Set Selenium Timeout     ${TIME_OUT}
    Open Browser    ${url}    ${BROWSER}    ${brower_name}
    Sleep   1
    Maximize Browser Window
    Wait Until Element Is Visible    //p[text()='Sign In']

Open Browser - MP
    [Arguments]    ${brower_name}=buyer
    Initial Env Data
    Set Selenium Timeout     ${TIME_OUT}
    Open Browser    ${URL_MIK}    ${BROWSER}    ${brower_name}
    Sleep   1
    Maximize Browser Window
    Wait Until Element Is Visible    //p[text()='Sign In']

User Sign In - MP
    [Arguments]    ${email}    ${pwd}    ${name}
    Click Element  //*[text()='Sign In']
    Wait Until Element Is Visible    //input[@id="email"]
    input text    //input[@id="email"]     ${email}
    Sleep   1
    input text    //input[@id="password"]     ${pwd}
    Sleep   1
    click button  //*[@type="submit"]
    Wait Until Element Is Visible    //p[text()='${name}']

Clear Element Value
    [Arguments]    ${element}
    Click Element    ${element}
    Press Keys     None     ${CTRL_OR_COMMAND}+A
    Press Keys     None     DELETE
#    Clear Input Value By Keyboard

Open Browser With URL
    [Arguments]    ${URL}    ${URL_ALIAS}
    Set Selenium Timeout     ${TIME_OUT}
    Open Browser    ${URL}    ${BROWSER}    ${URL_ALIAS}
    Maximize Browser Window

