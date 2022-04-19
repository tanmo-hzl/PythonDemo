*** Settings ***
Library        String
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/MIK/LoginRegisterSetting.robot
Resource       ../../Keywords/Common/MikCommonKeywords.robot

*** Keywords ***
Sign in - Fail
    [Arguments]   ${email}  ${password}  ${Cur_User_Name}=summer
    Input Text And Wait  //input[@id="email"]  ${email}
    Input Text And Wait  //input[@id="password"]  ${password}
    Click On The Element And Wait  //div[text()='SIGN IN']/parent::button

Sign In - Forget Password - change password
    [Arguments]   ${email}  ${password}=${null}
    IF  ${password}==${null}
        ${password}  Generate Random String  10  PASSWORDpassword12345678
    END
    Sign in - Fail  ${email}  ${password}
    Wait Until Page Contains  The email or password you entered did not match our record
    Click On The Element And Wait  //span[text()='Forgot your password?']
    Input Text And Wait  //input[@id="email"]  ${email}
    Click On The Element And Wait  //div[text()='Submit']/parent::button
    Wait Until Page Contains  An email has been sent to reset your password.
    Go To Snapmail Browser Verify Email  ${email}  password  ${password}
    Sign in  ${email}  ${password}

Verify passwords in ciphertext and plain text
    [Arguments]  ${password}
    Input Text And Wait  //input[@id="password"]  ${password}
    Wait Until Page Contains Element  //input[@id="password" and @type="password"]
    Click On The Element And Wait  //input[@id="password"]/following-sibling::div/*
    Wait Until Page Contains Element  //input[@id="password" and @type="text"]
