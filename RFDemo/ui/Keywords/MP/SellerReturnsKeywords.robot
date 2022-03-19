*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SellerReturnLib.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Return_ID}
${Order_Number}
${Ele_Filter}    //p[starts-with(text(),"Filter")]/parent::button
${Return_Status}
${Cur_Order_Total}

*** Keywords ***
Seller Returns - Filter - Clear All Filter
    Wait Until Element Is Visible    ${Ele_Filter}
    Click Element    ${Ele_Filter}
    Wait Until Element Is Visible    //h4[text()="Filter"]
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
    Wait Until Element Is Visible    ${Ele_Filter}
    Click Element    ${Ele_Filter}
    Seller Returns - Filter - Click Button CLEAR
    Wait Until Element Is Visible    //input[@value="${status}"]/parent::label
    Click Element    //input[@value="${status}"]/parent::label
    Sleep    1
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Return Status"]
    Sleep    0.5
    Wait Loading Hidden

Seller Returns - Filter - Search By Status And Check Result
    [Arguments]    ${status_quantity}=1
    ${status}    Get Return Status By Number    ${status_quantity}
    ${order_count}    Seller Returns - Filter - Search Order By Status List    ${status}
    Seller Returns - Get Results Total Number
    IF    "${Cur_Order_Total}"!="${order_count}"
        Fail    ${status}, Filter=${order_count}, Results=${Cur_Order_Total}
    END
    ${page_status_list}    Create List
    ${count}    Get Element Count    //table//tbody/tr
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${count}
        Wait Until Element Is Enabled    //table//tbody//tr[${index}]//td[1]//p
        ${page_status}     Get Text     //table//tbody//tr[${index}]//td[3]//span
        Append To List    ${page_status_list}    ${page_status}
    END
    FOR    ${item}    IN    @{page_status_list}
        List Should Contain Value    ${status}    ${item}
    END

Seller Returns - Filter - Search By Duration
    [Arguments]    ${duration}=All Time
    Click Element    ${Ele_Filter}
    Wait Until Element Is Visible    //p[text()="Return Status"]
    Seller Returns - Filter - Click Button CLEAR
    Sleep    1
    ${order_count}    Get Text    //p[text()="${duration}"]/following-sibling::p
    Click Element    //p[text()="${duration}"]/../../parent::label
    Sleep    1
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Return Status"]
    Wait Loading Hidden
    [Return]    ${order_count}

Seller Returns - Filter - Search By Duration And Check Result
    [Arguments]    ${duration}=All Time
    ${order_count}    Seller Returns - Filter - Search By Duration    ${duration}
    Seller Returns - Get Results Total Number
    IF    '${Cur_Order_Total}'!='${order_count}'
        Fail   ${duration}, Filter=${order_count}, Results=${Cur_Order_Total}
    END

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
    Click Element    ${Ele_Filter}
    Wait Until Element Is Visible    //p[text()="Return Status"]
    Seller Returns - Filter - Click Button CLEAR
    Sleep    1
    ${item}    Set Variable
    ${order_count}    Set Variable    0
    FOR    ${item}    IN    @{status}
        ${number}    Get Text    //p[text()="${item}"]/following-sibling::p
        ${order_count}    Evaluate    ${order_count}+${number}
        Click Element    //input[@value="${item}"]/parent::label
    END
    Sleep    1
    Click Element    //div[text()="View Results"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Return Status"]
    Wait Loading Hidden
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

Seller Returns - Submit Refund Decision
    [Arguments]    ${sure}=${True}
    Scroll Element Into View    //div[text()="SUBMIT REFUND DECISION"]/parent::button
    Click Element    //div[text()="SUBMIT REFUND DECISION"]/parent::button
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
    [Arguments]    ${index}=1     ${refund}=${True}    ${reason}=No Reason
    ${par_ele}    Set Variable    (//*[@id="returnAtion"])[${index}]
    Scroll Element Into View    ${par_ele}
    IF   '${refund}'=='${True}'
        Select From List By Value    ${par_ele}   Full refund
    ELSE
        Select From List By Value    ${par_ele}    No refund
        ${input_ele}    Set Variable    ${par_ele}/../../following-sibling::div//input[@id="refundRejectReason"]
        Wait Until Page Contains Element    ${input_ele}
        Scroll Element Into View    ${input_ele}
        ${time}    Get Time
        Input Text    ${input_ele}    ${reason},${time}.
    END

Seller Returns - Back To Return List On Return Detail Page
    Scroll Element Into View    //p[text()="Returns"]/parent::p
    Click Element    //p[text()="Returns"]/parent::p
    Wait Until Element Is Visible    //p[text()="Filter"]/parent::button

Seller Returns - Back To Return List On Order Detail Page
    Scroll Last Button Into View
    Click Element    //p[text()="Back"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Returns"]

Seller Returns - Flow - Approve Or Reject For All Items
    [Arguments]    ${approve}=${True}
    Seller Returns - Filter - Clear All Filter
    Seller Returns - Filter - Search Order By Status Single    ${Return_Status[0]}
    Seller Returns - Skip If No Order On List
    Seller Returns - Enter Return Detail Page By Line Index
    Seller Returns - Set All Items Full Or No Refund    ${approve}
    Seller Returns - Submit Refund Decision
    Seller Returns - Back To Return List On Return Detail Page

Seller Returns - Flow - Reject Refund For All Items
    [Arguments]     ${occupancy_parameter}=0
    Seller Returns - Filter - Clear All Filter
    Seller Returns - Filter - Search Order By Status Single    ${Return_Status[0]}
    ${count}    Get Element Count    //span[text()="${Return_Status[0]}"]
    Skip If    '${count}'=='0'   There are no order can reject refund.
    Seller Returns - Enter Return Detail Page By Line Index
    Seller Returns - Set All Items Full Or No Refund    ${False}
    Seller Returns - Submit Refund Decision
    Seller Returns - Back To Return List On Return Detail Page

