*** Settings ***
Library        DateTime
Resource        ../../Keywords/Common/MapCommonKeywords.robot
Resource        ../../Keywords/Common/CommonKeywords.robot

*** Variables ***
${Application_No}


*** Keywords ***
Enter Tab - Store Management
    Click Element    //div[text()="Store Management"]/parent::div[@role="tab"]
    Sleep    1

Enter Tab - Store Rename Application
    Click Element    //div[text()="Store Rename Application"]/parent::div[@role="tab"]
    Sleep    1

Search By Company Name On Store Management
    [Arguments]    ${name}
    Clear Element Value    //*[@id="storeName"]
    Input Text    //*[@id="storeName"]    ${name}
    Press Keys    //*[@id="storeName"]     ${RETURN_OR_ENTER}

Search By Company Name On Store Rename Application
    [Arguments]    ${name}
    Clear Element Value    (//*[@class="ant-input search-inp"])[2]
    Input Text    (//*[@class="ant-input search-inp"])[2]    ${name}
    Press Keys    (//*[@class="ant-input search-inp"])[2]     ${RETURN_OR_ENTER}

Mouse Over To Application By Company Name
    [Arguments]    ${company_name}
    wait until element is visible  //div[text()="${company_name}"]/../preceding-sibling::td
    ${Application_No}    Get Text    //div[text()="${company_name}"]/../preceding-sibling::td
    Set Suite Variable    ${Application_No}    ${Application_No}
    Sleep   1
    Mouse Over  //div[text()="${company_name}"]/../..
    Wait Until Element Is Visible  ((//div[starts-with(@class,"${Application_No}")]/div/div)[1]/following-sibling::*)[1]

Approve Application
    [Arguments]    ${sure}=${True}
    Click Element  ((//div[starts-with(@class,"${Application_No}")]/div/div)[1]/following-sibling::*)[1]
    Wait Until Element Is Visible    //div[text()="Are you sure you want to Approve this seller?"]
    Wait Until Element Is Visible  //div[text()="Approve"]
    Run Keyword If    '${sure}'=='${True}'    Click Element  //div[text()="Confirm"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element  //div[text()="Cancel"]/parent::button

Reject Application
    [Arguments]    ${sure}=${True}
    Click Element  ((//div[starts-with(@class,"${Application_No}")]/div/div)[2]/following-sibling::*)[1]
    Wait Until Element Is Visible    //div[text()="Are you sure you want to reject this seller?"]
    Wait Until Element Is Visible    //div[text()="Reject"]
    Input Text    //textarea[contains(@id,"rejectReason")]    Auto UI Test, Reject It.
    Run Keyword If    '${sure}'=='${True}'    Click Element  //div[text()="Reject"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element  //div[text()="Cancel"]/parent::button
    Run Keyword If    '${sure}'=='${True}'    Wait Until Element Is Visible    //*[contains(text(),"Succeed")]

