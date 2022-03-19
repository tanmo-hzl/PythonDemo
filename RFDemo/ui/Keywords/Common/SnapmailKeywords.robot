*** Settings ***
Resource       ../../TestData/EnvData.robot

*** Variables ***
${New_Snapmail}
${Seller_Info}

*** Keywords ***
Open Snapmail Browser
    [Arguments]    ${browser_name}=email
    Open Browser    ${URL_EMAIL}    ${BROWSER}     ${browser_name}
    Maximize Browser Window
#    Wait Until Element Is Visible    //h1[contains(@class,"heading")]
    Sleep    1

Add New Snapmail
    [Arguments]    ${email}=${New_Snapmail}
    Execute Javascript    document.querySelector("a.email-item ").click()
    Wait Until Element Is Visible    //*[@id="inputEmail"]
    Clear Element Value  //*[@id="inputEmail"]
    Input Text    //*[@id="inputEmail"]    ${email}
    Execute Javascript    document.querySelector("button.btn.btn-primary.ng-binding").click()
    Sleep    2

Enter Spanmail Page
    [Arguments]    ${email}=${New_Snapmail}
    Execute Javascript    document.querySelectorAll("span.subline-from.ng-binding")[1].click()
    Sleep    1
    Go To     ${URL_EMAIL}/#/emailList/${email}@snapmail.cc
    Sleep    10

Refresh Email List To Check Title
    [Arguments]    ${email_prefix}    ${title}
    FOR    ${index}    IN RANGE    10
        Click Element    //li[@ng-click="refreshList()"]
        Sleep   1
        ${count}    Get Element Count    //ul[@class="email-list hide-on-xs"]//li//span[contains(text(),"${email_prefix}")]
        ${title_count}   Get Element Count    //*[contains(text(),"${title}")]
        Exit For Loop If    ${count}>0 and ${title_count}>0
        Sleep   2
    END
    IF    ${title_count}==0
        Capture Screenshot And Embed It Into The Report
        Fail    No received email contains title: ${title}
    END

Flow - Add Email To Snapmail
    [Arguments]    ${email_prefix}
    Open Snapmail Browser    email
    Switch Browser    email
    Add New Snapmail    ${email_prefix}

Check Email has been Received Contains Title
    [Arguments]    ${email_prefix}    ${title}
    Switch Browser    email
    Enter Spanmail Page    ${email_prefix}
    Refresh Email List To Check Title    ${email_prefix}    ${title}

Start Registration From Applicatin Approve Email Detail
    [Arguments]    ${title}
    Click Element    //*[contains(text(),"${title}")]
    Wait Until Page Contains Element    //*[@name="preview-iframe"]
    Sleep    1
    Select Frame    //*[@name="preview-iframe"]
    Wait Until Element Is Visible    //*[text()="START REGISTRATION"]
    Click Element    //*[text()="START REGISTRATION"]
    Unselect Frame
    Sleep    1
    ${win_handles}    Get Window Handles
    Switch Window    ${win_handles[1]}


Confirm Buyer Sign Up Email
    [Arguments]    ${title}
    Click Element    //*[contains(text(),"${title}")]
    Wait Until Page Contains Element    //*[@name="preview-iframe"]
    Sleep    1
    Select Frame    //*[@name="preview-iframe"]
    Wait Until Element Is Visible    //a[text()="Verify My Email"]
    Click Element    //a[text()="Verify My Email"]
    Unselect Frame
    Sleep    1
    ${win_handles}    Get Window Handles
    Switch Window    ${win_handles[1]}
    Wait Until Element Is Visible    //div[text()="CONTINUE SHOPPING"]/parent::button
    ${text}    Get Text    //h2
    Should Be Equal As Strings    ${text}    Your email address has been successfully verified.
    Click Element    //div[text()="CONTINUE SHOPPING"]/parent::button
    Wait Until Element Is Visible      //h1[text()="Sign in"]


