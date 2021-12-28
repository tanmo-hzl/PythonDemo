*** Settings ***
Resource        ../../Keywords/Common/MapCommonKeywords.robot
Resource        ../../Keywords/Common/CommonKeywords.robot

*** Variables ***
${Application_No}


*** Keywords ***
Search By Company Name
    [Arguments]    ${name}
    Clear Element Value    //*[@id="saerchValue"]
    Input Text    //*[@id="saerchValue"]    ${name}
    Press Keys    //*[@id="saerchValue"]     RETURN

Mouse Over To Application By Company Name
    [Arguments]    ${company_name}
    wait until element is visible  //div[text()="${company_name}"]/../following-sibling::td[6]
    ${Application_No}    Get Text    //div[text()="${company_name}"]/../following-sibling::td[1]
    Set Suite Variable    ${Application_No}    ${Application_No}
    Sleep   1
    Mouse Over  //div[text()="${company_name}"]/../..
    Wait Until Element Is Visible  ((//div[starts-with(@class,"${Application_No}")]/div/div)[1]/following-sibling::*)[1]

Approve Application
    [Arguments]    ${sure}=${True}
    Click Element  ((//div[starts-with(@class,"${Application_No}")]/div/div)[1]/following-sibling::*)[1]
    Wait Until Element Is Visible  //div[text()="Approve"]/parent::button
    Sleep    1
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="Approve"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Are you sure you want to approve this seller?"]

Reject Application
    [Arguments]    ${sure}=${True}
    Click Element  ((//div[starts-with(@class,"${Application_No}")]/div/div)[2]/following-sibling::*)[1]
    Wait Until Element Is Visible    //p[text()="Are you sure you want to reject this seller?"]
    Wait Until Element Is Visible    //div[text()="Reject"]/parent::button
    Sleep    1
    Input Text    //textarea[contains(@class,"chakra-textarea")]    Auto UI Test, Reject It.
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="Reject"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Are you sure you want to reject this seller?"]


