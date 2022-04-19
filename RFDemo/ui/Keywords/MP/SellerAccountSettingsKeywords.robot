*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../Keywords/Common/SnapmailKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Email_Prefix}

*** Keywords ***
Update - Input Current Password
    [Arguments]    ${old_password}
    Scroll Element Into View    //div[text()="CHANGE PASSWORD"]/parent::button
    input text    //*[@id="currentMima"]    ${old_password}

Update - Input New Password
    [Arguments]    ${new_password}
    input text    //*[@id="newMima"]    ${new_password}
    input text    //*[@id="confirmMima"]   ${new_password}


Save - Click Change Password
    Wait Until Element Is Visible    //*[@id="change-password-form"]/button/div
    click element    //div[text()="CHANGE PASSWORD"]/parent::button
    Sleep   1
    Wait Until Element Is Visible   //*[contains(text(),"Success")]
    Wait Until Element Is Not Visible   //*[contains(text(),"Success")]

Seller Account - Check Two Step Verification Is Open
    Wait Until Page Contains Element    //*[text()="Two Step Verification"]/following-sibling::div//p
    ${text}    Get Text    //*[text()="Two Step Verification"]/following-sibling::div//p
    ${open}   Set Variable    ${False}
    IF    "${text}"=="Enabled"
        ${open}   Set Variable    ${True}
    END
    [Return]    ${open}

Seller Account - Open Two Step Verification
    [Arguments]    ${open}    ${title_count}=1
    ${old_status}    Seller Account - Check Two Step Verification Is Open
    IF    "${old_status}"=="${False}" and "${open}"=="${True}"
        Click Element    //*[text()="Two Step Verification"]/following-sibling::div//label
        Seller Account - CONTINUE VERIFICATION    ${title_count}
    ELSE IF    "${old_status}"=="${True}" and "${open}"=="${False}"
        Click Element    //*[text()="Two Step Verification"]/following-sibling::div//label
        Seller Account - CONTINUE VERIFICATION    ${title_count}
    END

Seller Account - CONTINUE VERIFICATION
    [Arguments]     ${title_count}=1
    Click Element    //*[text()="CONTINUE VERIFICATION"]
    Wait Until Page Contains    Receive code via e-mail
    Click Element    //*[text()="GET CODE"]
    ${title}    Set Variable    here is your verification code for updating security settings
    Check Email has been Received Contains Title     ${Email_Prefix}    ${title}    ${title_count}
    ${code}    Get Verification Code By Title    ${title}
    Switch Browser    seller
    Input Text    //*[@id="code"]    ${code}
    Click Element    //*[text()="SUBMIT"]
    Wait Until Page Contains    Authentication is successful
    Wait Until Page Does Not Contain    Authentication is successful

Seller Account - Sign In With Two Step Verification
    [Arguments]    ${open}     ${url}    ${email}    ${pwd}    ${name}
    Open Browser With URL    ${url}    seller
    Wait Until Element Is Visible    //input[@id="email"]
    Input Text    //input[@id="email"]     ${email}
    Sleep   1
    Input Text    //input[@id="password"]     ${pwd}
    Sleep   1
    Click Element  //div[text()="SIGN IN"]/parent::button[@type="submit"]
    Set Suite Variable    ${Cur_User_Name}    ${name}
    IF    "${open}"=="${None}"
        Sleep    5
        ${count}    Get Element Count    //*[text()="Two-Step Verification"]
        IF    ${count}==1
            Seller Account - Input Two Step Verification Info After Input Account Info
        END
    END
    IF    "${open}"=="${True}"
        Seller Account - Input Two Step Verification Info After Input Account Info
    END
    Wait Until Page Contains    ${Cur_User_Name}

Seller Account - Input Two Step Verification Info After Input Account Info
    [Arguments]    ${title_count}=1
    Wait Until Page Contains    Two-Step Verification
    ${title}    Set Variable    here is your Two-Step verification code
    Check Email has been Received Contains Title     ${Email_Prefix}    ${title}    ${title_count}
    ${code}    Get Verification Code By Title    ${title}
    Switch Browser    seller
    Input Text    //*[@id="code"]    ${code}
    Click Element    //*[text()="Submit"]
