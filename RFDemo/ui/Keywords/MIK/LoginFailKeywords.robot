*** Settings ***
Library        String
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot

*** Variables ***
${password}
${email}
${firstName}

*** Keywords ***
Sign in Fail
    [Arguments]   ${email}  ${password}  ${Cur_User_Name}=summer
    Input Text And Wait  //input[@id="email"]  ${email}
    Input Text And Wait  //input[@id="password"]  ${password}
    Click On The Element And Wait  //div[text()='SIGN IN']/parent::button