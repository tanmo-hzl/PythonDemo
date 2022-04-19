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
    [Arguments]    ${email_prefix}    ${title}    ${check_title_count}=1
    FOR    ${index}    IN RANGE    15
        Click Element    //li[@ng-click="refreshList()"]
        Sleep   1
        ${count}    Get Element Count    //ul[@class="email-list hide-on-xs"]//li//span[contains(text(),"${email_prefix}")]
        ${title_count}   Get Element Count    //*[contains(text(),"${title}")]
        Exit For Loop If    ${title_count}>=${check_title_count}
        Sleep   1
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
    [Arguments]    ${email_prefix}    ${title}    ${title_count}=1
    Switch Browser    email
    Enter Spanmail Page    ${email_prefix}
    Refresh Email List To Check Title    ${email_prefix}    ${title}    ${title_count}

Confirm Buyer Sign Up Email
    [Arguments]    ${title}
    Click Element    //*[contains(text(),"${title}")]
    Switch To Spanmail Iframe
    Wait Until Element Is Visible    //*[text()="Verify My Email"]
    Click Element    //*[text()="Verify My Email"]
    Unselect Frame
    Sleep    1
    ${win_handles}    Get Window Handles
    Switch Window    ${win_handles[1]}
    Wait Until Element Is Visible    //div[text()="CONTINUE SHOPPING"]/parent::button
    Wait Until Element Is Visible    //*[contains(text(),"Your")]
    Sleep    1
    ${text}    Get Text    //*[contains(text(),"Your")]
    Should Be Equal As Strings    ${text}    Your email address has been successfully verified.
    Click Element    //div[text()="CONTINUE SHOPPING"]/parent::button
    Wait Until Element Is Visible      //*[text()="SIGN IN"]/parent::button

Switch To Spanmail Iframe
    Wait Until Page Contains Element    //*[@name="preview-iframe"]
    Sleep    1
    Select Frame    //*[@name="preview-iframe"]

Delete Email After Read
    Click Element    //*[@ng-click="delete(item)"]
    Sleep    1

Check Submit Pre Application Email Detail
    [Arguments]    ${title}
    Click Element    //*[text()="${title}"]
    Switch To Spanmail Iframe
    Page Should Contain    Your Marketplace application has been submitted.
    Page Should Contain    We’ve received your application for a seller account and it’s
    Page Should Contain    APPLICATION NUMBER
    Page Should Contain    DATE SENT
    Unselect Frame
    Delete Email After Read

Check Seller Approved Email Detail
    [Arguments]    ${title}    ${isBuyer}=${False}
    Click Element    //*[text()="${title}"]
    Switch To Spanmail Iframe
    Sleep    1
    Wait Until Element Is Visible    //*[text()="START REGISTRATION"]
#    Page Should Contain    Your Marketplace application has been approved!
#    Page Should Contain    We’ve approved your application for a Marketplace Seller Account.
#    Page Should Contain    APPLICATION NUMBER
#    Page Should Contain    DATE APPROVED
#    Wait Until Element Is Visible    //*[text()="Application Details"]/../following-sibling::a
#    Click Element    //*[text()="Application Details"]/../following-sibling::a
#    Execute Javascript     document.querySelector("#viewButton").click()
    Click Element    //*[text()="START REGISTRATION"]
    Unselect Frame
    ${handles}    Get Window Handles
    Switch Window    ${handles[1]}
    IF    "${isBuyer}"=="${False}"
        Wait Until Element Is Visible    //*[text()="Let’s Start. Create a Seller Account"]
        Close Window
        Switch Window    ${handles[0]}
    ELSE
        Wait Until Element Is Visible    //*[text()="Pick a name for your store."]
    END

Get Verification Code By Title
    [Arguments]    ${title}
    Click Element    //*[contains(text(),"${title}")]
    Switch To Spanmail Iframe
    Sleep    1
    Wait Until Page Contains    Two-Step Verification
    Sleep    1
    ${code}    Get Text    //*[@id="codeText"]
    Unselect Frame
    Delete Email After Read
    [Return]    ${code}
