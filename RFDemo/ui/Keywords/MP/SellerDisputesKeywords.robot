*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SellerDisputeLib.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Dispute_ID}
${Order_Number}
${Dispute_Status}
${Dispute_Decisions}
${Status_List}
@{Decisions}
${Cur_Order_Total}
${Dispute_Detail}

*** Keywords ***
Seller Disputes - Filter - Open
    Wait Loading Hidden
    Click Element    ${Filter_Btn_Ele}
    Wait Until Element Is Visible    ${Filter_View_Results}
    Sleep    0.5
    Seller Disputes - Filter - Click Button CLEAR

Seller Disputes - Filter - View Results
    Sleep    0.5
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Disputes Status"]
    Wait Loading Hidden
    Sleep    0.5

Seller Disputes - Filter - Clear All Filter
    Seller Disputes - Filter - Open
    Click Element    ${Filter_Clear_All}
    Wait Until Element Is Not Visible    ${Filter_View_Results}
    Wait Until Element Is Visible    ${Filter_Btn_Ele}
    Sleep    1

Seller Disputes - Filter - Click Button CLEAR
    Wait Until Element Is Visible    //p[text()="Disputes Status"]/following-sibling::button
    Click Element    //p[text()="Disputes Status"]/following-sibling::button
    Click Element    //p[text()="Filter by Duration"]/following-sibling::button
    Sleep    1

Seller Disputes - Filter - Search Order By Status Single
    [Documentation]    Dispute Opened,Dispute In Process,Offer Made,Offer Rejected,
    ...    Dispute Resolved,Dispute Escalated,Escalation Under Review,Dispute Canceled
    [Arguments]    ${status}
    Seller Disputes - Filter - Open
    ${order_count}    Get Text    //p[text()="${status}"]/following-sibling::p
    Click Element    //input[@value="${status}"]/parent::label
    Seller Disputes - Filter - View Results
    [Return]    ${order_count}

Seller Disputes - Filter - Search Order By Status List
    [Documentation]    Dispute Opened,Dispute In Process,Offer Made,Offer Rejected,
    ...    Dispute Resolved,Dispute Escalated,Escalation Under Review,Dispute Canceled
    [Arguments]    ${status}
    Seller Disputes - Filter - Open
    ${item}    Set Variable
    ${order_count}    Set Variable    0
    FOR    ${item}    IN    @{status}
        ${number}    Get Text    //p[text()="${item}"]/following-sibling::p
        ${order_count}    Evaluate    ${order_count}+${number}
        Click Element    //input[@value="${item}"]/parent::label
    END
    Seller Disputes - Filter - View Results
    [Return]    ${order_count}

Seller Disputes - Filter - Search Order By Duration And Status
    [Arguments]    ${duration}    @{status}
    Seller Disputes - Filter - Open
    ${item}    Set Variable
    Click Element    //p[text()="${duration}"]/../../parent::label
    FOR    ${item}    IN    @{status}
        Click Element    //input[@value="${item}"]/parent::label
    END
    Seller Disputes - Filter - View Results
    Common - Page Turning    Last
    Seller Disputes - Check Current Page Order Status    ${status}
    Seller Disputes - Check Current Page Order Date    ${duration}
    Common - Page Turning    First
    Seller Disputes - Check Current Page Order Status    ${status}
    Seller Disputes - Check Current Page Order Date    ${duration}


Seller Disputes - Filter - Search Order By Status And Check Result
    [Arguments]    ${quantity}=1
    ${status}    Get Dispute Status By Number    ${quantity}
    ${order_count}    Seller Disputes - Filter - Search Order By Status List    ${status}
    Seller Disputes - Get Results Total Number
    Run Keyword And Ignore Error    Seller Disputes - Compare Filter Total And Page Total    ${status}    ${order_count}
    Seller Disputes - Check Current Page Order Status    ${status}
    Common - Page Turning    Next
    Seller Disputes - Check Current Page Order Status    ${status}
    Common - Page Turning    Last
    Seller Disputes - Check Current Page Order Status    ${status}

Seller Disputes - Compare Filter Total And Page Total
    [Arguments]    ${value}    ${filter_total}
    IF   '${Cur_Order_Total}'!='${filter_total}'
        Fail    ${value}, Filter=${filter_total},Results=${Cur_Order_Total}
    END

Seller Disputes - Check Current Page Order Status
    [Arguments]    ${status}
    ${count}    Get Element Count    //table//tbody/tr
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${${count}+1}
        ${page_status}    Get Text    //table//tbody/tr[${index}]/td[3]//span
        List Should Contain Value    ${status}    ${page_status}
    END

Seller Disputes - Check Current Page Order Date
    [Arguments]    ${purchased_within}
    ${date_range}    Get Date Range By Purchased Within    ${purchased_within}
    ${tr_count}    Get Element Count    //table//tbody//tr
    IF    ${tr_count}>0
        ${page_date}    Get Text    //table//tbody/tr[1]/td[2]//p
        Check Page Date In Filter Date Range    ${page_date}    ${date_range}    ${purchased_within}
        ${page_date}    Get Text    //table//tbody/tr[${tr_count}]/td[2]//p
        Check Page Date In Filter Date Range    ${page_date}    ${date_range}    ${purchased_within}
    END

Seller Disputes - Filter - Search Order By Duration Single
    [Documentation]    All Time    Today    Yesterday    Past 7 days    Past 30 days    Past 6 Month
    [Arguments]    ${duration}
    Seller Disputes - Filter - Open
    ${order_count}    Get Text    //p[text()="${duration}"]/following-sibling::p
    Click Element    //p[text()="${duration}"]/../../parent::label
    Seller Disputes - Filter - View Results
    [Return]    ${order_count}

Seller Disputes - Filter - Search Order By Duration And Check Result
    [Arguments]    ${duration}=All Time
    ${order_count}    Seller Disputes - Filter - Search Order By Duration Single    ${duration}
    Seller Disputes - Get Results Total Number
    Run Keyword And Ignore Error    Seller Disputes - Compare Filter Total And Page Total    ${duration}    ${order_count}
    Seller Disputes - Check Current Page Order Date    ${duration}
    Common - Page Turning    Last
    Seller Disputes - Check Current Page Order Date    ${duration}
    Common - Page Turning    Previous
    Seller Disputes - Check Current Page Order Date    ${duration}

Seller Disputes - Get Results Total Number
    Wait Until Page Contains Element    //table/../following-sibling::div//p
    ${count}    Get Element Count    //table/../following-sibling::div//p
    IF    ${count}>0
        ${result}    Get Text    //table/../following-sibling::div//p
        ${order_total}    Evaluate    '${result}'.split(" ")\[2\]
        Set Suite Variable    ${Cur_Order_Total}    ${order_total}
    END

Seller Disputes - Skip IF No Order On List
    ${count}    Get Element Count    //table//tbody/tr
    IF    ${count}==0
        Skip   There are no order can to do test.
    END

Seller Disputes - Clear Search Value
    ${count}    Get Element Count    //*[@id="searchOrders"]/following-sibling::*
    IF   '${count}'=='1'
        Click Element     //*[@id="searchOrders"]/following-sibling::*
        Wait Loading Hidden
    END

Seller Disputes - Search Order By Search Value
    [Arguments]    ${search_value}
    Seller Disputes - Clear Search Value
    Input Text    //*[@id="searchOrders"]    ${search_value}
    Press Keys    ${None}    ${RETURN_OR_ENTER}
    Wait Loading Hidden

Seller Disputes - Get Dispute Detail Info
    ${retrun_id}    Get Text    //p[text()="Return Request ID:"]//following-sibling::p
    ${order_id}    Get Text    //p[text()="Order ID:"]//following-sibling::p
    ${Dispute_Detail}     Create Dictionary      returnId=${retrun_id}    orderId=${order_id}
    Set Suite Variable    ${Dispute_Detail}    ${Dispute_Detail}

Seller Disputes - Get Dispute Info By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    ${Filter_Btn_Ele}
    ${Dispute_ID}    Get Text    //table//tbody/tr[${index}]/td[1]//p
    ${Order_Number}    Get Text    //table//tbody/tr[${index}]/td[4]//p
    ${Dispute_Status}    Get Text    //table//tbody/tr[${index}]/td[3]//span
    Set Suite Variable    ${Dispute_ID}   ${Dispute_ID}
    Set Suite Variable    ${Order_Number}    ${Order_Number}
    Set Suite Variable    ${Dispute_Status}    ${Dispute_Status}

Seller Disputes - Save Orders Info From Previous Pages
    [Arguments]    ${page_total}=5
    ${page_index}    Set Variable
    ${order_list}    Create List
    FOR    ${page_index}    IN RANGE    ${page_total}
        ${count}    Get Element Count    //table//tbody/tr
        ${count}    Evaluate    ${count}+1
        ${index}    Set Variable
        FOR    ${index}    IN RANGE    1    ${count}
            Seller Disputes - Get Dispute Info By Index    ${index}
            ${order_info}    Create Dictionary    disputeId=${Dispute_ID}    orderNumber=${Order_Number}   status=${Dispute_Status}
            Append To List    ${order_list}    ${order_info}
        END
        ${count}    Get Element Count    //div[@aria-label="Next Page" and @disabled]
        Exit For Loop If    '${count}'=='1'
        Click Element    //div[@aria-label="Next Page"]
        Wait Loading Hidden
    END
    Save File    orders_seller_disputes    ${order_list}    MP    ${ENV}

Seller Disputes - Save Dispute Orders Info By Status
    [Arguments]    ${status}    ${file_name}=orders_seller_offer_made
    ${count}    Get Element Count    //span[text()="Offer Made"]
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    ${order_list}    Create List
    FOR    ${index}    IN RANGE    1    ${count}
        Seller Disputes - Get Dispute Info By Index    ${index}
        ${order_info}    Create Dictionary    disputeId=${Dispute_ID}    orderNumber=${Order_Number}   status=${Dispute_Status}
        Append To List    ${order_list}    ${order_info}
    END
    IF   "${file_name}"=="${None}"
        ${file_name}    Evaluate    "orders_"+"${status}".lower()
    END
    Save File    ${file_name}    ${order_list}    MP    ${ENV}

Seller Disputes - Enter Dispute Details Page By Index And Status
    [Arguments]    ${index}=1    ${status}=${None}
    Wait Until Element Is Visible    ${Filter_Btn_Ele}
    Click Element      (//table//tbody//td[1]//p)[${index}]/../parent::button
    IF    "${status}"!="${None}"
        Wait Until Element Is Visible    //p[text()="${status}"]
    END
    Wait Until Element Is Visible    //p[text()="Associated Orders:"]
    Sleep    1

Seller Disputes - Enter Order Detail Page By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    ${Filter_Btn_Ele}
    Click Element      (//table//tbody//td[4]//p)[${index}]/../parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //*[text()="Order Details"]
    Sleep    1

Seller Disputes - Back To Disputes List On Order Detail Page
    Scroll Last Button Into View
    Click Element    //p[text()="Back"]/parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //*[@id="searchOrders"]

Seller Disputes - Back To Disputes List On Dispute Detail Page
    Click Element    //p/p[text()="Disputes"]
    Wait Loading Hidden
    Wait Until Element Is Visible    //*[@id="searchOrders"]
    Sleep    1

Seller Disputes - Details - Click Dispute Request Details
    Wait Until Page Contains Element    //div[text()="Dispute Request Details"]
    Scroll Element Into View    //div[text()="Dispute Request Details"]
    Click Element    //div[text()="Dispute Request Details"]
    Wait Until Element Is Visible    //*[text()="Process Dispute"]

Seller Disputes - Process - Click Review Request
    [Arguments]    ${status}=Dispute In Process
    IF    '${status}'=='${Status_List[0]}'
        Wait Until Page Contains Element    //p[text()="Review Request"]/../parent::button
        Scroll Last Button Into View
        Click Element    //p[text()="Review Request"]/../parent::button
        Wait Until Element Is Visible    //p[text()="Make Decision"]/../parent::button
        Wait Until Element Is Visible    //b[contains(text(),"has started reviewing this dispute request.")]
    END

Seller Disputes - Process - Click Make Decision
    Wait Until Element Is Visible    //p[text()="Make Decision"]/../parent::button
    Wait Until Element Is Enabled    //p[text()="Make Decision"]/../parent::button
    Sleep    0.5
    Click Element    //p[text()="Make Decision"]/../parent::button
    Wait Until Element Is Visible    //div/p[text()="Make Decision"]


Seller Disputes - Decision - Get Decision Items Info
    [Documentation]    decision in ["Offer Full Refund", "Offer Partial Refund", "Reject Refund"] or [0,1,2]
    [Arguments]    ${decision}=0    ${refund_shipping}=${True}
    Wait Until Element Is Visible    //button[@title="Please Select an Option"]
    ${count}    Get Element Count    //table/tbody/tr
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    ${items}    Create List
    FOR    ${index}    IN RANGE    1    ${count}
        ${name}   Get Text    //table/tbody/tr[${index}]//td[1]//p//p
        ${qty}    Get Text    //table/tbody/tr[${index}]//td[3]//div
        ${amount}    Get Value    //table/tbody/tr[${index}]//td[4]//input
        ${expected}    Get Text    //table/tbody/tr[${index}]//td[5]//p//p
        ${expected_disabled}    Get Element Count    //table/tbody/tr/td[5]//input[@disabled]
        ${item}   Create Dictionary    name=${name}    qty=${qty}    amount=${amount}
        ...    expected=${expected}    expected_disabled=${expected_disabled}
        Append To List    ${items}    ${item}
    END
    ${Dispute_Decisions}    Get Dispute Decision    ${items}    ${decision}    ${refund_shipping}
    Set Suite Variable    ${Dispute_Decisions}    ${Dispute_Decisions}


Seller Disputes - Decision - Set Items Decision And Reason
    ${item_decisions}   Get Json Value    ${Dispute_Decisions}    decisions
    ${item}    Set Variable
    ${index}    Set Variable    1
    FOR    ${item}    IN    @{item_decisions}
        Seller Disputes - Decision - Select Decision By Index    ${item}[decision]    ${index}
        IF    '${item}[amount]'!='0'
            Seller Disputes - Decision - Input Refund Amount By Index    ${item}[amount]    ${index}
        END
        Seller Disputes - Decision - Input Reason By Index    ${item}[reason]    ${index}
        ${index}    Evaluate    ${index}+1
    END
    Seller Disputes - Decision - Set Refund Shipping And Handling Fee    ${Dispute_Decisions}[refundShipping]    ${item}[decision]


Seller Disputes - Decision - Select Decision By Index
    [Arguments]    ${decision}=Offer Full Refund    ${index}=1
    ${base_ele}   Set Variable    //table/tbody/tr[${index}]/td[2]//button
    Click Element    ${base_ele}
    Wait Until Element Is Visible    ${base_ele}/following-sibling::div//button
    Click Element    ${base_ele}/following-sibling::div//button[@value="${decision}"]

Seller Disputes - Decision - Input Refund Amount By Index
    [Arguments]    ${amount}=10.00    ${index}=1
    ${base_ele}   Set Variable    //table/tbody/tr[${index}]/td[4]//input
    Clear Element Value    ${base_ele}
    Input Text    ${base_ele}    ${amount}

Seller Disputes - Decision - Set Return Expected By Index
    [Arguments]    ${chekced}=No    ${index}=1
    ${base_ele}   Set Variable    //table/tbody/tr[${index}]/td[5]
    ${disable_count}    Get Element Count    ${base_ele}//input[@disabled]
    IF    '${disable_count}'=='0'
        ${text}   Get Text    ${base_ele}//div//p
        IF    '${text}'!='${chekced}'
            Click Element    ${base_ele}//label
        END
    END

Seller Disputes - Decision - Input Reason By Index
    [Arguments]    ${reason}=Test Reason    ${index}=1
    ${base_ele}   Set Variable    //table/tbody/tr[${index}]/td[6]//input
    Input Text    ${base_ele}    ${reason}

Seller Disputes - Decision - Set Refund Shipping And Handling Fee
    [Arguments]    ${refund}=${True}    ${decision}=Reject Refund
    IF    '${decision}'!='Reject Refund'
        ${count}    Get Element Count    //*[text()="Refund Shipping and Handling Fee"]/parent::label//span[contains(@class,'Mui-checked')]
        IF    '${count}'=='0' and '${refund}'=='${True}'
            Click Element    //*[text()="Refund Shipping and Handling Fee"]/parent::label
        ELSE IF   '${count}'=='1' and '${refund}'=='${False}'
            Click Element    //*[text()="Refund Shipping and Handling Fee"]/parent::label
        END
    END

Seller Disputes - Decision - Select I Acknowledge Offer
    ${base_ele}    Set Variable    //*[contains(text(),"I acknowledge that")]/parent::label
    Scroll Element Into View    ${base_ele}
    Click Element    ${base_ele}

Seller Disputes - Decision - Click Back
    Wait Until Element Is Visible    //p[text()="Back"]/parent::div
    Scroll Last Button Into View
    Click Element    //p[text()="Back"]
    Wait Until Element Is Visible   //*[text()="Process Dispute"]

Seller Disputes - Decision - Click Submit
    Wait Until Element Is Visible    //span[text()="Submit"]/parent::button
    Scroll Last Button Into View
    Click Element    //span[text()="Submit"]/parent::button
    Sleep    0.5
    Wait Until Element Is Not Visible    //div/p[text()="Make Decision"]
    Wait Until Element Is Visible   //*[text()="Process Dispute"]

Seller Disputes - Process - Back Dispute Details Page
    Click Close Icon In Top Right-hand Corner
    Wait Until Element Is Visible    //p[text()="Dispute Details"]        ${MAX_TIME_OUT}

Seller Disputes - Process - Click Dispute Summary
    Wait Until Page Contains Element    //span[text()="Dispute Summary"]/parent::button
    Scroll Last Button Into View
    Click Element    //span[text()="Dispute Summary"]/parent::button
    Wait Until Element Is Visible    //p[text()="Dispute Summary"]

Seller Disputes - Process - Back From Dispute Summary Page
    Scroll Last Button Into View
    Click Element     //p[text()="Back"]/parent::div
    Wait Until Element Is Not Visible    //p[text()="Dispute Summary"]
    Wait Until Element Is Visible    //span[text()="Dispute Summary"]/parent::button

Seller Disputes - Escalate - Submit Escalate Dispute
    [Arguments]    ${sure}=${True}
    Click Element    //span[text()="Escalate Dispute"]/parent::button
    Wait Until Element Is Visible    //h3[text()="Escalate to Michaels"]
    ${time}    Get Time
    Input Text    //textarea    Test Escalate Dispute, ${time}.
    Click Element    //div[@role="presentation"]//button[contains(@id,"menu-button")]
    Wait Until Element Is Visible    //div[@role="presentation"]//button[contains(@id,"menuitem")]
    Click Element    //div[@role="presentation"]//button[contains(@id,"menuitem")]
    Input Text    //input[contains(@title,"Please enter")]    6663334567
    Click Element    //input[@name="acknowledgment"]
    Wait Until Element Is Enabled    //span[text()="Yes"]/parent::button
    Run Keyword If    '${sure}'=='${True}'
    ...    Click Element    //span[text()="Yes"]/parent::button
    Run Keyword If    '${sure}'=='${False}'
    ...    Click Element    //span[text()="No"]/parent::button
    Wait Until Element Is Not Visible    //h3[text()="Escalate to Michaels"]
    Wait Until Element Is Visible    //*[contains(text(),"Escalate Dispute Success")]
    Wait Until Element Is Not Visible    //*[contains(text(),"Escalate Dispute Success")]

Seller Disputes - Flow - Eneter Dispute Page To Mack Decision
    [Arguments]    ${decision}
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Enter Dispute Details Page By Index And Status    1    ${Dispute_Status}
    Log   EA_Report_Data=${Dispute_ID}
    Seller Disputes - Details - Click Dispute Request Details
    Seller Disputes - Process - Click Review Request    ${Dispute_Status}
    Seller Disputes - Process - Click Make Decision
    Seller Disputes - Decision - Get Decision Items Info    ${decision}
    Seller Disputes - Decision - Set Items Decision And Reason
    Seller Disputes - Decision - Select I Acknowledge Offer
    Seller Disputes - Decision - Click Submit
    Seller Disputes - Process - Back Dispute Details Page

Seller Disputes - Flow - Submit Disputes For Reject Refund
    [Arguments]     ${occupancy_parameter}=0
    ${search_status_list}    Create List    ${Status_List[0]}    ${Status_List[1]}
    Seller Disputes - Filter - Search Order By Status List    ${search_status_list}
    Seller Disputes - Skip IF No Order On List
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[2]}
    Seller Disputes - Back To Disputes List On Dispute Detail Page