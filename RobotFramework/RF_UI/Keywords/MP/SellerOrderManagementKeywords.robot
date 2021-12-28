*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Cur_Order_Number}


*** Keywords ***
Filters - Clear All Filters
    Click Element    //p[starts-with(text(),"Filters")]/following-sibling::button
    Wait Until Element Is Visible    //header[text()="Filters"]
    Click Element    //div[text()="Clear All"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Filters"]
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Filters - Search Order By Status Single
    [Documentation]   status list:Open,Awaits,Pending Confirmation,Ready to Ship,Partial Shipped,
    ...    Shipped,Partial Delivered,Delivered,Partially Pending Return,Return Requested,Return Refund,
    ...    Partial Refund,Cancelled,Partially Completed,Completed
    [Arguments]    ${status}=Pending Confirmation
    Click Element    //p[starts-with(text(),"Filters")]/following-sibling::button
    Wait Until Element Is Visible    //header[text()="Filters"]
    Click Element    //p[text()="${status}"]/../parent::label[starts-with(@class,"chakra-checkbox")]
    Sleep    1
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible     //header[text()="Filters"]
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Filters - Search Order By Status List
    [Documentation]   status list:Open,Awaits,Pending Confirmation,Ready to Ship,Partial Shipped,
    ...    Shipped,Partial Delivered,Delivered,Partially Pending Return,Return Requested,Return Refund,
    ...    Partial Refund,Cancelled,Partially Completed,Completed
    [Arguments]    @{status}
    Click Element    //p[starts-with(text(),"Filters")]/following-sibling::button
    Wait Until Element Is Visible    //header[text()="Filters"]
    ${item}    Set Variable
    FOR    ${item}   IN    @{status}
        Click Element    //p[text()="${status}"]/../parent::label[starts-with(@class,"chakra-checkbox")]
    END
    Sleep    1
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible     //header[text()="Filters"]
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Clear Search Order Number
    Clear Element Value     //input[@id="searchOrders"]

Search Order By Order Number
    [Arguments]    ${order_number}
    Input Text    //input[@id="searchOrders"]    ${order_number}
    Press Keys    //input[@id="searchOrders"]    ${RETURN_OR_ENTER}
    Sleep    2


Enter To Order Detail Page By Line Index
    [Arguments]    ${index}=1
    ${count}    Get Element Count    //p[starts-with(text(),"THP")]/../parent::button
    Skip If    '${count}'=='0'    There are no order on list
    ${count}    Run Keyword If   ${index}>${count}    Set Variable    ${count}
    ...   ELSE   Set Variable    ${index}
    ${Cur_Order_Number}    Get Text    (//p[starts-with(text(),"THP")])[${count}]
    Set Suite Variable    ${Cur_Order_Number}    ${Cur_Order_Number}
    Click Element    (//p[starts-with(text(),"THP")]/../parent::button)[${count}]
    Wait Until Element Is Visible    //h1[text()="Order Details"]
    Wait Until Element Is Visible    //table//img[@alt="Product Image"]
    Sleep    1

Confirm Order On Order Detail Page
    Wait Until Element Is Visible    //p[text()="New order waiting for confirmation."]
    Click Element    //div[text()="Confirm Order"]/parent::button
    Wait Until Element Is Not Visible   //div[text()="Confirm Order"]/parent::button

Select All Item On Order Detail Page
    Wait Until Element Is Visible    //table//th//*[contains(@class,"icon-tabler-square")]
    ${count_checked}    Get Element Count    //table//th//*[contains(@class,"icon-tabler-square-check")]
    Run Keyword If    '${count_checked}'=='0'    Click Element    //table//th//*[contains(@class,"icon-tabler-square")]/*

Select Items By Product Name On Order Detail Page
    [Arguments]    ${name}
    Click Element   //p[contains(text(),"${name}")]/../parent::*/preceding-sibling::*//*[contains(@class,"icon-tabler-square")]
    Sleep    1

Select Items By SKU On Order Detail Page
    [Arguments]    ${sku}
    ${item_count}    Get Element Count    //table//tbody/tr
    ${sku}    Set Variable    SKU# ${sku}
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${item_count}
          ${text}    Get Text    //table//tbody/tr[${index}]//td[3]/div/div/p
          Run Keyword If    '${text}'=='${sku}'    Click Element    //table//tbody/tr[1]/td[1]//*
          Exit For Loop If    '${text}'=='${sku}'
    END

Cancel Items On Order Detail Page
    [Arguments]    ${sure}=${True}
    Click Element    //div[text()="Cancel Order"]/parent::button
    Wait Until Element Is Visible    //p[text()="Cancel the Order"]
    Click Element    //select[@id="reason"]
    Click Element    //option[text()="Out of Stock"]
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="Confirm Cancellation"]/parent::button
    Run Keyword If    '${sure}'=='${True}'    Wait Until Element Is Visible    //h4[text()="Your order has been cancelled successfully!"]
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="Close"]/parent::button
    Run Keyword If    '${sure}'=='${True}'    Wait Until Element Is Visible    //p[text()="Cancelled"]
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button

Ship Item On Order Detail Page
    [Arguments]    ${sure}=${True}    ${carrier}=UPS
    Click Element    //div[starts-with(text(),"Ship Item ")]/parent::button
    Wait Until Element Is Visible    //p[text()="Ship Item"]
    Click Element    //select[@id="carrier"]
    Wait Until Element Is Visible    //option[text()="${carrier}"]
    Click Element    //option[text()="${carrier}"]
    ${number}    Evaluate    random.randint(1000000000,9999999999)
    Input Text    //input[@id="trackingNumber"]    ${number}
    Run Keyword If    '${sure}'=='${True}'    CLick Element    //div[text()="Add Tracking Number"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    CLick Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Ship Item"]
    Run Keyword If    '${sure}'=='${True}'    Wait Until Element Is Visible    //a[text()="${number}"]
    Wait Until Element Is Visible     //*[contains(text(),"Shipment created successfully")]
    Wait Until Element Is Not Visible     //*[contains(text(),"Shipment created successfully")]

Back To Order List On Order Detail Page
    Click Element    //p[text()="Back"]/parent::button
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Close Order Detail Page
    ${count}    Get Element Count    //*[contains(@class,'icon-tabler-x')]/parent::button
    Run Keyword If    '${count}'=='1'    Click Element    //*[contains(@class,'icon-tabler-x')]/parent::button
    Wait Until Element Is Visible    //p[text()="Customer Name"]