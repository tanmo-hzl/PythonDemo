*** Settings ***
Resource       ../../TestData/EnvData.robot

*** Variables ***
${New_Snapmail}


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
    Input Text    //*[@id="inputEmail"]    ${email}
    Execute Javascript    document.querySelector("button.btn.btn-primary.ng-binding").click()
    Sleep    2

Enter Spanmail Page
    [Arguments]    ${email}=${New_Snapmail}
    Execute Javascript    document.querySelectorAll("span.subline-from.ng-binding")[1].click()
    Sleep    1
    Go To     ${URL_EMAIL}/#/emailList/${email}@snapmail.cc
    Sleep    10

Refresh Email List
    FOR    ${index}    IN RANGE    10
        Click Element    //li[@ng-click="refreshList()"]
        Sleep   5
        ${count}    Get Element Count    //ul[@class="email-list hide-on-xs"]//li[2]
#        //*[text()="Thank you for applying to sell on Michaels Marketplace"]
        Exit For Loop If    ${count}>0
        Sleep   7
    END
    Capture Page Screenshot    email-signup.png
    Should Be Equal As Numbers    ${count}    0



