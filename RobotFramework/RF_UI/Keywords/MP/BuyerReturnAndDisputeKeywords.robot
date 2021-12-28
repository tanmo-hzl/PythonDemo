*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot

*** Variables ***
${Retrunable_Count}


*** Keywords ***
Buyer Return - Search Order
    [Arguments]    ${search_value}
    Clear Element Value    //*[@id="searchOrders"]
    Input Text    //*[@id="searchOrders"]    ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
    Sleep    1
    Wait Until Element Is Visible    //p[text()="Return Numbers"]/following-sibling::p

Buyer Return - Filters - Clear All
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button
    Click Element    //p[starts-with(text(),"Filters")]/../parent::button
    Wait Until Element Is Visible    //h4[text()="Filters"]
    Sleep    1
    Click Element    //div[text()="Clear All"]/parent::button
    Wait Until Element Is Not Visible    //h4[text()="Filters"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button

Buyer Return - Filters By Duration
    [Documentation]    [All Time,Today,Past 2 days,Past 7 days,Past 30 days,Past 6 Month,Past Year]
    [Arguments]    ${duration}=All Time
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button
    Click Element    //p[starts-with(text(),"Filters")]/../parent::button
    Wait Until Element Is Visible    //h4[text()="Filters"]
    Sleep    1
    Click Element    //p[text()="${duration}"]/../../parent::label
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //h4[text()="Filters"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button

Buyer Return - Eneter Detail Page By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    //button[contains(@class,"chakra-button")]
    Click Element    (//button[contains(@class,"chakra-button")])[${index}]
    Wait Until Element Is Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //img[@alt="thumbnail"]

Buyer Return - Back To Order List On Detail Page
    Click Element    //p[text()="Return and Dispute"]/parent::a
    Wait Until Element Is Not Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button

Buyer Return - Cancel Pending Return Order
    [Arguments]    ${sure}=${True}
    Click Element    //div[text()="cancel"]/parent::button
    Wait Until Element Is Visible    //h3[text()="Cancel Return"]
    Wait Until Element Is Visible    //p[text()="Are you sure you want to cancel your return order ?"]
    Run Keyword If    '${sure}'=='${True}'    Click Element  //div[text()="Confirm"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element  //div[text()="Close"]/parent::button

Buyer Return - Eneter Create Return Order Page
    Wait Until Element Is Visible    //*[text()="Return"]/parent::button
    Click Element    //*[text()="Return"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Create Return Order"]

Buyer Return - Selected All Items
    Wait Until Element Is Visible    //p[text()="Quantity"]/../../..//input
    Click Element    //p[text()="Quantity"]/../../..//input
    Checkbox Should Be Selected    //p[text()="Quantity"]/../../..//input

Buyer Return - Get Returnable Items Count
    ${disable_count}    Get Element Count    //div[@role="region"]//label//input[@disabled]
    ${all_count}    Get Element Count    //div[@role="region"]//label//input
    ${able_count}    Evaluate    ${all_count}-${disable_count}
    Set Suite Variable    ${Retrunable_Count}    ${able_count}

Update Return Item Quantity
    [Arguments]    ${index}    ${quantity}=2
    ${element}    Set Variable    (//div[@role="region"]//div[contains(@class,"chakra-stack")]/input)[${index}]
    Clear Element Value    ${element}
    Input Text    ${element}    ${quantity}



