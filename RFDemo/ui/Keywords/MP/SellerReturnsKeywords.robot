*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SellerReturnLib.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot
Resource       EAInitialSellerDataAPiKeywords.robot

*** Variables ***
${Return_ID}
${Order_Number}
${Ele_Filter}    //p[starts-with(text(),"Filter")]/parent::button
${Return_Status}
${Cur_Order_Total}
${Pending_Return_Order}
${Cur_Return_Id}

*** Keywords ***
Seller Returns - Get Pending Return Order By API
    [Arguments]    ${have_returned}=haveReturned    ${min_item_count}=1    ${min_flag}=${False}
    ${return_list}    API - Get Seller Return Order List By Kwargs    status=${Return_Status[0]}
    IF    "${have_returned}"=="haveReturned"
        ${returned_flag}    Set Variable    ${True}
    ELSE
        ${returned_flag}    Set Variable    ${False}
    END
    ${pending_return_order}    Get Require Pending Return Order    ${return_list}    ${returned_flag}    ${min_item_count}    ${min_flag}
    Set Suite Variable    ${Pending_Return_Order}    ${pending_return_order}

Seller Returns - Flow - Submit Refund Decision By API
    [Arguments]    ${index}    ${have_returned}=haveReturned    ${min_item_count}=1    ${min_flag}=${True}    ${decision}=reject
    Seller Returns - Get Pending Return Order By API    ${have_returned}    ${min_item_count}    ${min_flag}
    API - Seller Submit Refund Decision      ${pending_return_order}[returnOrderNumber]    ${decision}

Seller Returns - Compare Order And Return Detail Data By API
    [Arguments]    ${order_index}=0
    ${return_list}    API - Get Seller Return Order List By Kwargs    status=${Return_Status[2]}
    ${order_number_list}    Get Non Duplicate Order Number    ${return_list}
    ${cus_order_number}    Set Variable    ${order_number_list[${order_index}]}
    ${order_detail}    API - Seller Get Order Detail By Order Number    ${cus_order_number}
    ${order_return_list}    API - Get Seller Return Order List By Kwargs    keyWords=${cus_order_number}
    ${order_return_details}    Create List
    FOR    ${item}    IN    @{order_return_list}
        ${return_detail}    API - Get Return Order Detail By Return Id    ${item}[returnOrderNumber]
        Append To List    ${order_return_details}    ${return_detail}
    END
    Compare Order And Return Detail Data    ${order_detail}    ${order_return_details}

Seller Returns - Go To Return Order Detail Page
    ${len}    Get Length    ${pending_return_order}
    IF   ${len}==0
        Skip   No order can do test
    END
    Set Suite Variable    ${Cur_Return_Id}    ${pending_return_order}[returnOrderNumber]
    Go To    ${URL_MIK}/mp/sellertools/returns?detaiReturnId=${Cur_Return_Id}
    Log   EA_Report_Data=${Cur_Return_Id}
    Wait Until Page Contains    Contact Buyer
    Sleep    1

Seller Returns - Check Return Order Status By API
    [Arguments]    ${expected_status}
    ${data}    API - Get Return Order Detail By Return Id    ${Cur_Return_Id}
    ${now_status}    Get Json Value    ${data}    status
    ${expected_status}    Get Return Order Status Value    ${expected_status}
    List Should Not Contain Value    ${expected_status}    ${now_status}

Seller Returns - Filter - Open
    Wait Until Element Is Visible    ${Ele_Filter}
    Click Element    ${Ele_Filter}
    Wait Until Element Is Visible    //h4[text()="Filter"]
    Seller Returns - Filter - Click Button CLEAR

Seller Returns - Filter - View Results
    Sleep    0.5
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Return Status"]
    Sleep    0.5
    Wait Loading Hidden

Seller Returns - Filter - Clear All Filter
    Seller Returns - Filter - Open
    Click Element    //div[text()="Clear All"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Filter"]
    Sleep    1
    Wait Loading Hidden

Seller Returns - Filter - Click Button CLEAR
    Wait Until Element Is Visible    //p[text()="Return Status"]/following-sibling::button
    Click Element    //p[text()="Return Status"]/following-sibling::button
    Click Element    //p[text()="Filter by Duration"]/following-sibling::button
    Sleep    1

Seller Returns - Filter - Search Order By Status Single
    [Documentation]  Pending Return,Return Rejected,Returned,Return Cancelled,Pending Refund
    [Arguments]    ${status}
    Seller Returns - Filter - Open
    Wait Until Element Is Visible    //input[@value="${status}"]/parent::label
    Click Element    //input[@value="${status}"]/parent::label
    Seller Returns - Filter - View Results

Seller Returns - Filter - Search By Status And Check Result
    [Arguments]    ${status_quantity}=1
    ${status}    Get Return Status By Number    ${status_quantity}
    ${order_count}    Seller Returns - Filter - Search Order By Status List    ${status}
    Seller Returns - Get Results Total Number
    Run Keyword And Ignore Error    Seller Returns - Compare Filter Total And Page Total    ${status}    ${order_count}
    Seller Returns - Check Return Order Status After Page Turning    ${status}

Seller Returns - Compare Filter Total And Page Total
    [Arguments]    ${value}    ${filter_total}
    IF   '${Cur_Order_Total}'!='${filter_total}'
        Fail    ${value}, Filter=${filter_total},Results=${Cur_Order_Total}
    END

Seller Returns - Filter - Search By Duration
    [Arguments]    ${duration}=All Time
    Seller Returns - Filter - Open
    ${order_count}    Get Text    //p[text()="${duration}"]/following-sibling::p
    Click Element    //p[text()="${duration}"]/../../parent::label
    Seller Returns - Filter - View Results
    [Return]    ${order_count}

Seller Returns - Filter - Search By Duration And Status
    [Arguments]    ${duration}    @{status}
    Seller Returns - Filter - Open
    Click Element    //p[text()="${duration}"]/../../parent::label
    FOR    ${item}    IN    @{status}
        Click Element    //input[@value="${item}"]/parent::label
    END
    Seller Returns - Filter - View Results
    Seller Returns - Check Return Order Status After Page Turning    ${status}
    Seller Returns - Check Current Page Order Date    ${duration}
    Common - Page Turning    First
    Seller Returns - Check Current Page Order Date    ${duration}

Seller Returns - Check Return Order Status After Page Turning
    [Arguments]    ${status}
    Seller Returns - Check Current Page Order Status    ${status}
    Common - Page Turning    Next
    Seller Returns - Check Current Page Order Status    ${status}
    Common - Page Turning    Last
    Seller Returns - Check Current Page Order Status    ${status}

Seller Returns - Check Current Page Order Status
    [Arguments]    ${status}
    ${count}    Get Element Count    //table//tbody/tr
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${${count}+1}
        ${page_status}    Get Text    //table//tbody/tr[${index}]/td[3]//span
        List Should Contain Value    ${status}    ${page_status}
    END

Seller Returns - Check Current Page Order Date
    [Arguments]    ${purchased_within}
    ${date_range}    Get Date Range By Purchased Within    ${purchased_within}
    ${tr_count}    Get Element Count    //table//tbody//tr
    IF    ${tr_count}>0
        ${page_date}    Get Text    //table//tbody/tr[1]/td[2]//p
        Check Page Date In Filter Date Range    ${page_date}    ${date_range}    ${purchased_within}
        ${page_date}    Get Text    //table//tbody/tr[${tr_count}]/td[2]//p
        Check Page Date In Filter Date Range    ${page_date}    ${date_range}    ${purchased_within}
    END

Seller Returns - Filter - Search By Duration And Check Result
    [Arguments]    ${duration}=All Time
    ${order_count}    Seller Returns - Filter - Search By Duration    ${duration}
    Seller Returns - Get Results Total Number
    Run Keyword And Ignore Error    Seller Returns - Compare Filter Total And Page Total    ${duration}    ${order_count}
    Seller Returns - Check Current Page Order Date    ${duration}
    Common - Page Turning    Last
    Seller Returns - Check Current Page Order Date    ${duration}
    Common - Page Turning    Previous
    Seller Returns - Check Current Page Order Date    ${duration}

Seller Returns - Get Results Total Number
    Wait Until Page Contains Element    //table/following-sibling::div//p
    ${count}    Get Element Count    //table/following-sibling::div//p
    IF    ${count}>0
        ${result}    Get Text    //table/following-sibling::div//p
        ${order_total}    Evaluate    '${result}'.split(" ")\[2\]
        Set Suite Variable    ${Cur_Order_Total}    ${order_total}
    END

Seller Returns - Skip If No Order On List
    ${count}    Get Element Count    //table//tbody/tr
    IF    ${count}==0
        Skip    There Are no order can to do test.
    END

Seller Returns - Save Orders Info From Previous Pages
    [Arguments]    ${page_total}=5
    ${page_index}    Set Variable
    ${seller_return_orders}    Create List
    FOR    ${page_index}    IN RANGE    ${page_total}
        ${count}    Get Element Count    //table//tbody/tr
        ${count}    Evaluate    ${count}+1
        ${index}    Set Variable
        FOR    ${index}    IN RANGE    1    ${count}
            Wait Until Element Is Enabled    //table//tbody//tr[${index}]//td[1]//p
            ${return_id}    Get Text    //table//tbody//tr[${index}]//td[1]//p
            ${order_number}    Get Text    //table//tbody//tr[${index}]//td[4]//p
            ${date_opened}     Get Text     //table//tbody//tr[${index}]//td[2]//p
            ${status}     Get Text     //table//tbody//tr[${index}]//td[3]//span
            ${order_info}    Create Dictionary     returnId=${return_id}    orderNumber=${order_number}
            ...    dateOpen=${date_opened}    status=${status}
            Append To List    ${seller_return_orders}    ${order_info}
        END
        ${count}    Get Element Count    //div[@aria-label="Next Page" and @disabled]
        Exit For Loop If    '${count}'=='1'
        Click Element    //div[@aria-label="Next Page"]
        Wait Loading Hidden
    END
    Save File    orders_seller_returns    ${seller_return_orders}    MP    ${ENV}


Seller Returns - Save Refund Orders Info By Status
    [Arguments]    ${status}    ${file_name}=${None}
    Sleep    0.5
    ${count}    Get Element Count    //td//span[text()="${status}"]
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    ${refund_rejected_orders}    Create List
    FOR    ${index}    IN RANGE    1    ${count}
        Wait Until Element Is Enabled    //table//tbody//tr[${index}]//td[1]//p
        ${return_id}    Get Text    //table//tbody//tr[${index}]//td[1]//p
        ${order_number}    Get Text    //table//tbody//tr[${index}]//td[4]//p
        ${order_info}    Create Dictionary     returnId=${return_id}    orderNumber=${order_number}
        Append To List    ${refund_rejected_orders}    ${order_info}
    END
    IF    '${file_name}'=='${None}'
        ${file_name}    Evaluate    'orders_'+'${status}'.lower()
    END
    Save File    ${file_name}    ${refund_rejected_orders}    MP    ${ENV}

Seller Returns - Filter - Search Order By Status List
    [Documentation]  Pending Return,Return Rejected,Returned,Return Cancelled,Pending Refund
    [Arguments]    ${status}
    Seller Returns - Filter - Open
    ${item}    Set Variable
    ${order_count}    Set Variable    0
    FOR    ${item}    IN    @{status}
        ${number}    Get Text    //p[text()="${item}"]/following-sibling::p
        ${order_count}    Evaluate    ${order_count}+${number}
        Click Element    //input[@value="${item}"]/parent::label
    END
    Seller Returns - Filter - View Results
    [Return]    ${order_count}

Seller Returns - Clear Search Value
    ${count}    Get Element Count    //*[@id="searchOrders"]/following-sibling::*
    IF   '${count}'=='1'
        Click Element     //*[@id="searchOrders"]/following-sibling::*
        Wait Loading Hidden
    END

Seller Returns - Search Order By Return ID
    [Arguments]    ${o_number}
    Input Text    //*[@id="searchOrders"]    ${o_number}
    Press Keys    ${None}    ${RETURN_OR_ENTER}
    Wait Loading Hidden

Seller Returns - Get Return Order Info By Line Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    ${Ele_Filter}
    ${Return_ID}    Get Text    //table//tbody/tr[${index}]//td[1]//p
    ${Order_Number}    Get Text    //table//tbody/tr[${index}]//td[4]//p
    ${date}    Get Text    //table//tbody/tr[${index}]//td[2]//p
    ${status}    Get Text    //table//tbody/tr[${index}]//td[3]//span
    ${buyer_name}    Get Text    //table//tbody/tr[${index}]//td[5]//p
    Set Suite Variable    ${Return_ID}   ${Return_ID}
    Set Suite Variable    ${Order_Number}    ${Order_Number}
    ${order_info}    Create Dictionary    date=${date}    status=${status}    buyer_name=${buyer_name}
    [Return]    ${order_info}

Seller Returns - Enter Return Detail Page By Line Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    ${Ele_Filter}
    ${count}    Get Element Count    (//table//tbody//td[1]//p)[${index}]/../parent::button
    IF    ${count}==1
        Click Element      (//table//tbody//td[1]//p)[${index}]/../parent::button
        Wait Until Element Is Visible    //img[@alt="thumbnail"]
    ELSE
        #Capture Page Screenshot    filename=EMBED
        Skip    There are no return order on line ${index}
    END
    Sleep    1

Seller Returns - Enter Order Detail Page By Line Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    ${Ele_Filter}
    Click Element      (//table//tbody//td[4]//p)[${index}]/../parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //img[@alt="Product Image"]
    Sleep    1

Seller Returns - Click Button Submit Refund Decision
    Scroll Element Into View    //div[text()="SUBMIT REFUND DECISION"]/parent::button
    Click Element    //div[text()="SUBMIT REFUND DECISION"]/parent::button


Seller Returns - Submit Refund Decision Pop-Ups
    [Arguments]    ${sure}=${True}
    Seller Returns - Click Button Submit Refund Decision
    Wait Until Element Is Visible    //p[text()="Refund Confirmation"]
    Sleep    1
    Run Keyword If    '${sure}'=='${True}'
    ...    Click Element    //div[text()="CONFIRM REFUND DECISION"]/parent::button
    Run Keyword If    '${sure}'=='${False}'
    ...    Click Element    //div[text()="CANCEL"]/parent::button
    Wait Until Element Is Visible    //div[text()="SUBMIT REFUND DECISION"]/parent::button[@disabled]
    Sleep    1
    Log Source
    Wait Until Element Is Visible    //*[contains(text(),"decision updated")]
    Wait Until Element Is Not Visible    //*[contains(text(),"decision updated")]


Seller Returns - Set All Items Full Or No Refund
    [Arguments]    ${refund}=${True}
    ${count}    Get Element Count    //*[@id="returnAtion"]
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${count}
        Seller Returns - Select Decision By Index    ${index}    ${refund}
    END

Seller Returns - Select Decision By Index
    [Arguments]    ${index}=1     ${refund}=${True}    ${fill_reason}=${True}
    ${par_ele}    Set Variable    (//*[@id="returnAtion"])[${index}]
    Scroll Element Into View    ${par_ele}
    IF   '${refund}'=='${True}'
        Select From List By Value    ${par_ele}   Full refund
    ELSE
        Select From List By Value    ${par_ele}    No refund
        ${input_ele}    Set Variable    ${par_ele}/../../following-sibling::div//input[@id="refundRejectReason"]
        Wait Until Page Contains Element    ${input_ele}
        Scroll Element Into View    ${input_ele}
        IF    "${fill_reason}"=="${True}"
            ${time}    Get Time
            Input Text    ${input_ele}    Test No Refund, ${time}.
        END
    END

Seller Returns - Back To Return List On Return Detail Page
    Scroll Element Into View    //p[text()="Returns"]/parent::p
    Click Element    //p[text()="Returns"]/parent::p
    Wait Until Element Is Visible    //p[text()="Filter"]/parent::button

Seller Returns - Back To Return List On Order Detail Page
    Scroll Last Button Into View
    Click Element    //p[text()="Back"]/parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //*[@id="searchOrders"]




