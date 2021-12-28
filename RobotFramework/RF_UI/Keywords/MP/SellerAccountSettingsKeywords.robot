*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***


*** Keywords ***
update - Input Current Password
    [Arguments]    ${old_password}
    input text    //*[@id="currentPassword"]    ${old_password}

update - Input New Password
    [Arguments]    ${new_password}
    input text    //*[@id="newPassword"]    ${new_password}
    input text    //*[@id="confirmPassword"]   ${new_password}


Save - Click Change Password
    Wait Until Element Is Visible    //*[@id="change-password-form"]/button/div
    click element    //div[text()="CHANGE PASSWORD"]/parent::button
    Sleep   1
    Wait Until Element Is Visible   //*[contains(text(),"Success")]
    Wait Until Element Is Not Visible   //*[contains(text(),"Success")]

