*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Cur_Order_Number}
${Return_Order_Number}
${Order_Number}

*** Keywords ***
Filters - Clear All Filters
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button
    Click Element    //p[starts-with(text(),"Filters")]/../parent::button
    Wait Until Element Is Visible    //h4[text()="Filters"]
    Click Element    //div[text()="Clear All"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Filters"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button

Filters - Search Order By Status Single
    [Documentation]  Partially Pending Return,Pending Return,Partially Returned,Returned,Return Cancelled,Refund Rejected
    [Arguments]    ${status}
    Click Element    //p[starts-with(text(),"Filters")]/../parent::button
    Wait Until Element Is Visible    //p[text()="Order Status"]
    Click Element    //input[@value="${status}"]/parent::label
    Sleep    1
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Order Status"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button

Filters - Search Order By Status List
    [Documentation]  Partially Pending Return,Pending Return,Partially Returned,Returned,Return Cancelled,Refund Rejected
    [Arguments]    @{status}
    Click Element    //p[starts-with(text(),"Filters")]/../parent::button
    Wait Until Element Is Visible    //p[text()="Order Status"]
    ${item}    Set Variable
    FOR    ${item}    IN    @{status}
        Click Element    //input[@value="${item}"]/parent::label
    END
    Sleep    1
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Order Status"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button

Clear Search Order Number
    Clear Element Value    //*[@id="searchOrders"]

Search Order by Order Number
    [Arguments]    ${order_number}
    Input Text    //*[@id="searchOrders"]    ${order_number}
    Press Keys    ${None}    RETURN
    Sleep    2
    Wait Until Element Is Visible    //*[contains(text(),"${order_number}")]

Get Order Number From First Line
    Wait Until Element Is Visible    //button[starts-with(@class,"chakra-button")]
    ${Return_Order_Number}    Get Text    (//button//p[text()="Return Numbers"]/following-sibling::p)[1]
    ${Order_Number}    Get Text    (//button//p[text()="Order Numbers"]/following-sibling::p)[1]
    Set Suite Variable    ${Return_Order_Number}    ${Return_Order_Number}
    Set Suite Variable    ${Order_Number}    ${Order_Number}

Enter Order Detail Page By Line Index
    [Arguments]   ${index}=1
    Wait Until Element Is Visible    //button[starts-with(@class,"chakra-button")]
    CLick Element    (//button[starts-with(@class,"chakra-button")])[${index}]
    Wait Until Element IS Visible    //img[@alt="thumbnail"]
    Wait Until Element IS Visible    //p[text()="Payment Method"]
    Sleep    1

Approve Refund On Order Detail Page
    Click Element    //div[text()="Approve Refund"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="Approve Refund"]/parent::button
    Wait Until Element Is Visible    //p[text()="Returned"]

Reject Refund On Order Detail Page
    Click Element    //div[text()="Reject Refund"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="Reject Refund"]/parent::button
    Wait Until Element Is Visible    //p[text()="Refund Rejected"]

Back To Order List On Order Detail Page
    Click Element    //p[text()="Return and Dispute"]/parent::a
    Wait Until Element Is Visible    //button//p[text()="Return Numbers"]

Select Order Which Have Disputes
    Filters - Clear All Filters
    Filters - Search Order By Status Single     Refund Rejected
    ${count}    Get Element Count    //button[starts-with(@class,"chakra-button")]
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${count}+1
        Enter Order Detail Page By Line Index    ${index}
        ${dispute_count}    Get Element Count    //div[text()="View Dispute"]/parent::button
        Exit For Loop If    '${dispute_count}'=='1'
        Back To Order List On Order Detail Page
    END

Enter Dispute Page
    Click Element    //div[text()="View Dispute"]/parent::button
    Wait Until Element Is Visible    //span[text()="Dispute Summary"]/parent::button

Back To Order Detail On View Dispute Page
    Click Element    //*[contains(@class,"MuiButtonBase-root")]/parent::a
    Wait Until Element IS Visible    //img[@alt="thumbnail"]
    Wait Until Element Is Visible    //h4[text()="Return Summary"]

Enter Dispute Summary Page
    Sleep    1
    Click Element    //span[text()="Dispute Summary"]/parent::button
    Wait Until Element Is Visible    //p[text()="Dispute Summary"]

Back To View Dispute On Dispute Summary Page
    Click Element     //p[text()="Back"]/parent::div
    Wait Until Element Is Not Visible    //p[text()="Dispute Summary"]
    Wait Until Element Is Visible    //span[text()="Dispute Summary"]/parent::button

