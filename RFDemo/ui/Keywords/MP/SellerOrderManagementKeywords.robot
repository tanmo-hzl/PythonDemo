*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SellerOrderManagementLib.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../Keywords/MP/EAInitialSellerDataAPiKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Cur_Order_Number}
${Cur_Order_Information}
${Cur_Order_Items}
${Order_Item_One}
${Cur_Order_Total}
@{Orders_Status}
${Export_Order_Info}    ${None}
${API_Order_Detail}

*** Keywords ***
Seller Order - Filter - Open Filter
    Wait Until Element Is Visible    ${Filter_Btn_Ele1}
    Click Element    ${Filter_Btn_Ele1}
    Wait Until Element Is Visible    ${Filter_View_Results}
    Sleep    0.5

Seller Order - Filter - View_Results
    Sleep    0.5
    Click Element    ${Filter_View_Results}
    Wait Until Element Is Not Visible     ${Filter_View_Results}
    Wait Loading Hidden
    Sleep    0.5

Seller Order - Filter - Clear All Filter
    Seller Order - Filter - Open Filter
    Click Element    ${Filter_Clear_All}
    Wait Until Element Is Not Visible    ${Filter_View_Results}
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Seller Order - Filter - Search Order By Status Single
    [Documentation]   Pending Confirmation,Ready to Ship,Partially Shipped,
                    ...    Shipped, Delivered, Cancelled,Completed
    [Arguments]    ${status}=Pending Confirmation
    Seller Order - Filter - Open Filter
    ${status_order_count}    Get Text    //p[text()="${status}"]/../../following-sibling::p
    Click Element    //p[text()="${status}"]/../parent::label[starts-with(@class,"chakra-checkbox")]
    Seller Order - Filter - View_Results
    [Return]    ${status_order_count}

Seller Order - Get Results Total Number
    Wait Until Page Contains Element    //table/../following-sibling::div//p
    ${count}    Get Element Count    //table/../following-sibling::div//p
    IF    ${count}>0
        ${result}    Get Text    //table/../following-sibling::div//p
        ${order_total}    Evaluate    '${result}'.split(" ")\[2\]
        Set Suite Variable    ${Cur_Order_Total}    ${order_total}
    END

Seller Order - View New Orders And Confirm All
    ${count}    Get Element Count     //*[text()="View New Orders"]
    IF    ${count}>0
        Click Element    //*[text()="View New Orders"]/parent::button
        Wait Until Element Is Visible    //*[text()="Confirm All New Orders"]
        Click Element    //*[text()="Confirm All New Orders"]/parent::button
        Wait Until Element Is Visible    //*[contains(text(),"Success")]
        Wait Until Element Is Visible    //*[text()="You have confirmed all new orders."]
        Wait Until Element Is Not Visible    //*[contains(text(),"Success")]
    ELSE
        Skip    There are no new orders at present.
    END

Seller Order - Filter - Search Order By Status List
    [Documentation]   Pending Confirmation,Ready to Ship,Partially Shipped,
                    ...    Shipped, Delivered, Cancelled,Completed
    [Arguments]    ${status}
    Seller Order - Filter - Clear All Filter
    Seller Order - Filter - Open Filter
    ${item}    Set Variable
    ${total_order_count}    Set Variable     0
    FOR    ${item}   IN    @{status}
        ${status_order_count}    Get Text    //p[text()="${item}"]/../../following-sibling::p
        Click Element    //p[text()="${item}"]/../parent::label[starts-with(@class,"chakra-checkbox")]
        ${total_order_count}    Evaluate    ${total_order_count}+${status_order_count}
    END
    Seller Order - Filter - View_Results
    [Return]    ${total_order_count}

Seller Order - Filter - Search Order By Purchased Within
    [Documentation]    All Time,Today,Yesterday,Past 7 Days,Past 30 Days,Past 6 Months,Past Year,Custom
    [Arguments]    ${value}=All Time    ${start_days}=-7    ${end_days}=0
    Seller Order - Filter - Clear All Filter
    Seller Order - Filter - Open Filter
    ${base_ele}    Set Variable    //p[text()="${value}"]/../../parent::label[starts-with(@class,"chakra-radio")]
    ${date_range}    Create List    ${start_days}    ${end_days}
    IF    "${value}"!="Custom"
        Click Element    ${base_ele}
        ${status_order_count}    Get Text    //p[text()="${value}"]/following-sibling::p
        Seller Order - Filter - View_Results
        Seller Order - Get Results Total Number
        Run Keyword And Ignore Error    Seller Order - Compare Filter Total And Page Total    ${value}    ${status_order_count}
    ELSE
        ${date_range}    Common - Filter Select Date Range    ${base_ele}    ${date_range}    ${False}
        Seller Order - Filter - View_Results
    END
    Seller Order - Check Current Page Order Date    ${value}    ${date_range}
    Common - Page Turning    Last
    Seller Order - Check Current Page Order Date    ${value}    ${date_range}

Seller Order - Compare Filter Total And Page Total
    [Arguments]    ${value}    ${filter_total}
    IF   '${Cur_Order_Total}'!='${filter_total}'
        Fail    ${value}, Filter=${filter_total},Results=${Cur_Order_Total}
    END

Seller Order - Filter - Search Order By Purchased Within And Status
    [Arguments]    ${time}    @{status}
    Seller Order - Filter - Clear All Filter
    Seller Order - Filter - Open Filter
    Click Element    //p[text()="${time}"]/../../parent::label[starts-with(@class,"chakra-radio")]
    FOR    ${item}   IN    @{status}
        Click Element    //p[text()="${item}"]/../parent::label[starts-with(@class,"chakra-checkbox")]
    END
    Seller Order - Filter - View_Results
    Common - Page Turning    Next
    Seller Order - Check Current Page Order Status    ${status}
    Seller Order - Check Current Page Order Date    ${time}
    Common - Page Turning    First
    Seller Order - Check Current Page Order Status    ${status}
    Seller Order - Check Current Page Order Date    ${time}

Seller Order - Filter - Check Filter Results By Selected Status Quantity
    [Arguments]    ${status_quantity}=1
    ${status}    Get Order Status By Number    ${status_quantity}
    ${order_total}    Seller Order - Filter - Search Order By Status List    ${status}
    Sleep    1
    Seller Order - Get Results Total Number
    Run Keyword And Ignore Error    Seller Order - Compare Filter Total And Page Total    ${status}    ${order_total}
    Seller Order - Check Current Page Order Status    ${status}
    Common - Page Turning    Last
    Seller Order - Check Current Page Order Status    ${status}

Seller Order - Check Current Page Order Status
    [Arguments]    ${status_list}
    ${count}    Get Element Count    //table//tbody//tr
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${${count}+1}
        ${page_status}    Get Text     //table//tbody//tr[${index}]/td[4]//span[2]
        List Should Contain Value    ${status_list}    ${page_status}
    END

Seller Order - Check Current Page Order Date
    [Arguments]    ${purchased_within}    ${date_range}=${None}
    IF    "${purchased_within}"!="Custom"
        ${date_range}    Get Date Range By Purchased Within    ${purchased_within}
    END
    ${tr_count}    Get Element Count    //table//tbody//tr
    IF    ${tr_count}>0
        ${page_date}    Get Text    //table//tbody/tr[1]/td[5]//p
        Check Page Date In Filter Date Range    ${page_date}    ${date_range}    ${purchased_within}
        ${page_date}    Get Text    //table//tbody/tr[${tr_count}]/td[5]//p
        Check Page Date In Filter Date Range    ${page_date}    ${date_range}    ${purchased_within}
    END

Seller Order - Clear Search Value
    Clear Element Value     //input[@id="searchOrders"]
    Wait Loading Hidden

Seller Order - Search Order By Search Value
    [Arguments]    ${search_value}
    Seller Order - Clear Search Value
    Input Text    //input[@id="searchOrders"]    ${search_value}
    Sleep    0.2
    Press Keys    //input[@id="searchOrders"]    ${RETURN_OR_ENTER}
    Sleep    0.2
    Wait Loading Hidden

Seller Order - Search Order And Check Results
    [Arguments]    ${search_value}    ${in_table}=${True}    ${fail_msg}=${None}
    Seller Order - Search Order By Search Value    ${search_value}
    IF    "${in_table}"=="${True}"
        ${count}    Get Element Count    //*[contains(text(),"${search_value}")]
    ELSE
        ${count}    Get Element Count    //p[starts-with(text(),"THP")]
    END
    Seller Order - Clear Search Value
    IF    ${count}==0
        Fail    Fail to ${fail_msg}.
    END

Seller Order - Enter To Order Detail Page By Line Index
    [Arguments]    ${index}=1
    Sleep    1
    ${count}    Get Element Count    //p[starts-with(text(),"THP")]/../parent::button
    IF   '${count}'=='0'
        #Capture Page Screenshot    filename=EMBED
        Skip    There are no order on list
    END
    IF  ${index}>${count}
        ${count}    Set Variable    ${count}
    ELSE
        ${count}    Set Variable    ${index}
    END
    Seller Order - Get Order Information By Line Index    ${count}
    Click Element    (//p[starts-with(text(),"THP")]/../parent::button)[${count}]
    Wait Until Element Is Visible    //h1[text()="Order Details"]
    Wait Until Element Is Visible    //table//img[@alt="Product Image"]
    Sleep    1

Seller Order - Get Order Information By Line Index
    [Arguments]    ${index}=1
    ${Cur_Order_Number}    Get Text    (//p[starts-with(text(),"THP")])[${index}]
    ${parent_number}    Evaluate     '${Cur_Order_Number}'.split("-")\[0\]\[3:\]
    Set Suite Variable    ${Cur_Order_Number}    ${Cur_Order_Number}
    ${customer_name}      Get Text       //tbody/tr[${index}]/td[2]/p
    ${first_name}     Evaluate    '${customer_name}'.split(" ")\[0\]
    ${last_name}     Evaluate    '${customer_name}'.split(" ")\[1\]
    ${status}     Get Text       //tbody/tr[${index}]/td[4]/div/span[2]
    ${date}     Get Text         //tbody/tr[${index}]/td[5]/div/p
    ${total}     Get Text        //tbody/tr[1]/td[6]/p
    ${Cur_Order_Information}        Create Dictionary       customerName=${customer_name}        status=${status}
    ...                date=${date}    total=${total}    orderNumber=${Cur_Order_Number}    parentNumber=${parent_number}
    ...                firstName=${first_name}    lastName=${last_name}
    Set Suite Variable      ${Cur_Order_Information}        ${Cur_Order_Information}

Seller Order - Actions - Select Action By Index
    [Documentation]    See Order Details,Export,See Invoice
    [Arguments]    ${action}    ${index}=1
    ${action_ele}    Set Variable    (//table//button[contains(@id,"menu-button")])[${index}]
    Wait Until Element Is Visible    ${action_ele}
    Click Element    ${action_ele}
    Wait Until Element Is Visible    ${action_ele}/following-sibling::div//p[text()="${action}"]
    Click Element    ${action_ele}/following-sibling::div//p[text()="${action}"]

Seller Order - Actions - Select Action By Order Number
    [Documentation]    See Order Details,Export,See Invoice
    [Arguments]    ${action}    ${order_number}
    ${action_ele}    Set Variable    //p[text()="${order_number}"]/../../../../td[1]/button
    Wait Until Element Is Visible    ${action_ele}
    Click Element    ${action_ele}
    Wait Until Element Is Visible    ${action_ele}/following-sibling::div//p[text()="${action}"]
    Click Element    ${action_ele}/following-sibling::div//p[text()="${action}"]

Seller Order - Actions - See Order Details By Index
    [Arguments]    ${index}=1
    Seller Order - Actions - Select Action By Index    See Order Details    ${index}
    Sleep    1
    Wait Loading Hidden
    Wait Until Element Is Visible    //h1[text()="Order Details"]

Seller Order - Actions - Export Order Info By Order Number
    Remove Download File By Part Name    order_*.xlsx
    Remove Download File If Existed    order_${Cur_Order_Number}.xlsx
    Seller Order - Actions - Select Action By Order Number    Export    ${Cur_Order_Number}
    ${results}    ${file_path}    Wait Until File Download     order_${Cur_Order_Number}.xlsx
    IF    '${results}'=='${False}'
        Fail    Fail to export order ${Cur_Order_Number}.
    END
    ${export_info}    Read Download Excel    ${file_path}
    Set Suite Variable    ${Export_Order_Info}    ${export_info[1]}

Seller Order - Actions - Check Export Order Info
    [Arguments]    ${index}=1
    ${len}    Get Length    ${Export_Order_Info}
    IF    ${len} == 1
        Page Should Contain Element    //table//tbody/tr/td[2]//p[text()="${Export_Order_Info}[3]"]
        Page Should Contain Element    //table//tbody/tr/td[3]//p[text()="${Export_Order_Info}[2]"]
        Page Should Contain Element    //table//tbody/tr/td[4]//span[text()="${Export_Order_Info}[0]"]
        Page Should Contain     ${Export_Order_Info}[10]
    END

Seller Order - Actions - See Invoice By Order Number
    Seller Order - Actions - Select Action By Order Number    See Invoice    ${Cur_Order_Number}
    Wait Until Element Is Visible    //div[text()="Print Invoice"]
    Wait Until Element Is Visible    //div[text()="${Cur_Order_Number}"]

Seller Order - Actions - Close Invoice Windows
    Wait Until Element Is Visible    //div[@id="printInvoice"]/../following-sibling::button
    Click Element    //div[@id="printInvoice"]/../following-sibling::button
    Wait Until Element Is Not Visible    //div[text()="${Cur_Order_Number}"]

Seller Order - Actions - Check Export Info If Export Success On Invoice Windows
    ${len}    Get Length    ${Export_Order_Info}
    IF    ${len} == 1
        ${subtotal}    Get Text    //p[text()="Subtotal"]/following-sibling::p
        Should Be Equal As Strings    $${Export_Order_Info}[6]    ${subtotal}
        ${shipping_rate}    Get Text    //p[text()="Shipping & Handling"]/following-sibling::p
        Should Be Equal As Strings    $${Export_Order_Info}[9]    ${shipping_rate}
        ${tax}    Get Text    //p[text()="Tax"]/following-sibling::p
        Should Be Equal As Strings    $${Export_Order_Info}[8]    ${tax}
        ${total}    Get Text    //p[text()="Order Total"]/following-sibling::p
        Should Be Equal As Strings    $${Export_Order_Info}[10]    ${total}
    END

Seller Order - Actions - Check Order Items Info On Invoice Windows
    ${items}    Get Json Value    ${Cur_Order_Items}    items
    FOR    ${item}    IN    @{items}
        Page Should Contain Element    //p[text()="${item}[name]"]
        ${sku}    Set Variable    ${item}[sku]
        Page Should Contain Element    //p[text()="${sku}"]
        Page Should Contain Element    //p[text()="${item}[quantity]"]
        IF    "${Cur_Order_Items}[discounts]"=="${False}"
            Page Should Contain Element    //p[text()="${item}[cost]"]
            Page Should Contain Element    //p[text()="${item}[subtotal]"]
        END
    END
    IF    "${Cur_Order_Items}[discounts]"=="${False}"
        ${subtotal}    Get Text    //p[text()="Subtotal"]/following-sibling::p
        Should Be Equal As Strings    ${Cur_Order_Items}[subtotal]    ${subtotal}
    END
    ${shipping_rate}    Get Text    //p[text()="Shipping & Handling"]/following-sibling::p
    Should Be Equal As Strings    ${Cur_Order_Items}[shipping_rate]    ${shipping_rate}
    ${tax}    Get Text    //p[text()="Tax"]/following-sibling::p
    Should Be Equal As Strings    ${Cur_Order_Items}[tax]    ${tax}
    ${total}    Get Text    //p[text()="Order Total"]/following-sibling::p
    Should Be Equal As Strings    ${Cur_Order_Items}[total]    ${total}
    Page Should Contain Element    //*[contains(text(),"Total payment from this card")]

Seller Order - Confirm Order On Order Detail Page
    Wait Until Element Is Visible    //p[text()="New order waiting for confirmation."]
    Click Element    //div[text()="Confirm Order"]/parent::button
    Wait Until Element Is Not Visible   //div[text()="Confirm Order"]/parent::button
    Wait Until Element Is Visible    //p[text()="Ship your items"]

Seller Order - Select All Item On Order Detail Page
    ${all_selected_ele}    Set Variable    //table/tr//*[contains(@class,"icon-tabler-square")]
    Wait Until Element Is Enabled    ${all_selected_ele}
    Wait Until Element Is Visible    ${all_selected_ele}
    Click Element    ${all_selected_ele}
    Sleep   1
#    Wait Until Page Contains Element    //table/tr//*[contains(@class,"icon-tabler-square-check")]

Seller Order - Select One Item On Order Detail Page
    Wait Until Element Is Visible    //table//tbody/tr
    ${count}   Get Element Count    //table//tbody/tr
    ${cur_handle_count}    Set Variable     0
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${${count}+1}
        ${disabled_count}    Get Element Count    //table//tbody/tr[${index}]/td[1]/*[@pointer-events="none"]
        IF    ${disabled_count}==0
            ${cur_handle_count}    Evaluate    ${cur_handle_count}+1
            Click Element    //table//tbody/tr[${index}]/td[1]/*[contains(@class,"icon-tabler-square")]
            Wait Until Page Contains Element    //table//tbody/tr[${index}]/td[1]/*[contains(@class,"icon-tabler-square-check")]
            Exit For Loop
        ELSE
            ${cur_handle_count}    Evaluate    ${cur_handle_count}+1
        END
    END
    Sleep    0.5
    IF    ${cur_handle_count}==${count}
        ${is_all_handled}   Set Variable    ${True}
    ELSE
        ${is_all_handled}   Set Variable    ${False}
    END
    [Return]    ${is_all_handled}


Seller Order - Select Items By Product Name On Order Detail Page
    [Arguments]    ${name}
    Click Element   //p[contains(text(),"${name}")]/../parent::*/preceding-sibling::*//*[contains(@class,"icon-tabler-square")]
    Sleep    1

Seller Order - Select Items By SKU On Order Detail Page
    [Arguments]    ${sku}
    ${item_count}    Get Element Count    //table//tbody/tr
    ${sku}    Set Variable    SKU# ${sku}
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${item_count}
          ${text}    Get Text    //table//tbody/tr[${index}]//td[3]/div/div/p
          Run Keyword If    '${text}'=='${sku}'    Click Element    //table//tbody/tr[1]/td[1]//*
          Exit For Loop If    '${text}'=='${sku}'
    END

Seller Order - Cancel One Item For Partially Shipped Order
    [Arguments]    ${sure}=${True}
    ${count}    Get Element Count    //table//tbody/tr
    IF    ${count}==1
        Skip    This Partially Shipped Order can't cancel
    END
    Wait Until Element Is Enabled    //p[text()="Cancel Item"]/../parent::button
    Click Element    //p[text()="Cancel Item"]/../parent::button
    Wait Until Element Is Visible    //p[text()="Cancel on the item level"]
    IF    '${sure}'=='${True}'
        Seller Order - Select Cancel Order Reason And Confirm Cancellation
    ELSE
        Click Element    //div[text()="Cancel"]/parent::button
        Wait Until Element Is Not Visible    //p[text()="Cancel on the item level"]
    END


Seller Order - Cancel Order On Order Detail Page
    [Arguments]    ${sure}=${True}
    Wait Until Element Is Enabled    //div[text()="Cancel Order"]/parent::button
    Click Element    //div[text()="Cancel Order"]/parent::button
    Wait Until Element Is Visible    //p[text()="Cancel the Order"]
    IF    '${sure}'=='${True}'
        Seller Order - Select Cancel Order Reason And Confirm Cancellation
    ELSE
        Click Element    //div[text()="Cancel"]/parent::button
        Wait Until Element Is Not Visible    //p[text()="Cancel the Order"]
    END

Seller Order - Select Cancel Order Reason And Confirm Cancellation
    Click Element    //select[@id="reason"]
    Sleep    0.5
    Click Element    //option[text()="Out of Stock"]
    Sleep    1
    Click Element    //div[text()="Confirm Cancellation"]/parent::button
    Wait Until Element Is Visible    //*[text()="Your order has been cancelled successfully!"]
    Click Element    //div[text()="Close"]/parent::button
    Wait Until Element Is Not Visible    //*[text()="Your order has been cancelled successfully!"]

Seller Order - Check Result After Cancel Order
    [Arguments]    ${is_all_handled}    ${status}
    Sleep    1
    IF    "${is_all_handled}"=="${False}"
        Page Should Contain Element    //p[text()="${status}"]
    ELSE
        IF   '${status}'=='${Orders_Status[0]}' or '${status}'=='${Orders_Status[1]}'
            Wait Until Element Is Visible    //p[text()="Cancelled"]
        ELSE IF   '${status}'=='${Orders_Status[2]}'
            Wait Until Element Is Visible    //p[text()="Shipped"]
        END
    END

Seller Order - Ship One Item For Partially Shipped Order
    [Arguments]    ${carrier}=UPS
    ${actions_flag}    Check Order Item Actions By Order Detail    ${API_Order_Detail}
    IF    "${actions_flag}"=="${True}"
        Wait Until Element Is Visible    //p[text()="Ship Item"]/../parent::button
        Click Element    //p[text()="Ship Item"]/../parent::button
        Seller Order - Select Carrier And Input Tracking Number
    ELSE
        Page Should Not Contain Element    //p[text()="Ship Item"]/../parent::button
    END

Seller Order - Ship Item On Order Detail Page
    [Arguments]    ${carrier}=UPS
    Seller Order - Click Button Ship Item
    Seller Order - Select Carrier And Input Tracking Number

Seller Order - Click Button Ship Item
    Wait Until Element Is Enabled    //div[starts-with(text(),"Ship Item ")]/parent::button
    Click Element    //div[starts-with(text(),"Ship Item ")]/parent::button
    Wait Until Element Is Visible    //header//p[text()="Ship Item"]

Seller Order - Reduce Shipped Items Quantity
    [Arguments]    ${reduce_number}=1
    Wait Until Element Is Visible    //header//p[text()="Ship Item"]
    ${count}    Get Element Count    (//*[@aria-label="Number Stepper"])
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${${count}+1}
        ${reduce_index}    Set Variable
        FOR    ${reduce_index}  IN RANGE    ${reduce_number}
            ${item_count}    Get Text    (//*[@aria-label="Number Stepper"])[${index}]
            IF    "${item_count}"!="1"
                Click Element    (//*[@aria-label="Number Stepper"])[${index}]/../div[1]
            END
        END
    END

Seller Order - Select Carrier And Input Tracking Number
    [Arguments]    ${new_traking_number}=${True}
    ${carrieries}    Create List    ups    fedex    usps    dhl
    Wait Until Element Is Visible    //header//p[text()="Ship Item"]
    IF    "${new_traking_number}"=="${True}"
        ${carrier}    Evaluate    random.choice(${carrieries})
        Select From List By Value    //select[@id="carrier"]    ${carrier}
        ${number}    Evaluate    random.randint(1000000000,9999999999)
        Sleep    0.5
        Clear Element Value    //input[@id="trackingNumber"]
        Input Text    //input[@id="trackingNumber"]    ${number}
        Sleep    0.5
    END
    CLick Element    //div[text()="Add Tracking Number"]/parent::button
    Sleep    1
    Wait Until Element Is Not Visible    //div[text()="Add Tracking Number"]/parent::button    ${MAX_TIME_OUT}
    Wait Until Element Is Visible     //*[contains(text(),"Shipment created successfully")]
    Page Should Contain Element     //*[text()="Tracking number added to shipping."]
    Click Element    //*[contains(text(),"Shipment created successfully")]/../following-sibling::button
    Wait Until Element Is Not Visible     //*[contains(text(),"Shipment created successfully")]

Seller Order - Search Order By Buyer Name And Status
    [Arguments]    ${name}    ${status}=Shipped
    Seller Order - Filter - Clear All Filter
    Seller Order - Search Order By Search Value    ${name}
    Seller Order - Filter - Search Order By Status Single    ${status}

Seller Order - Back To Order List On Order Detail Page
    Scroll Last Button Into View
    Click Element    //p[text()="Back"]/parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Seller Order - Close Order Detail Page
    ${count}    Get Element Count    //*[contains(@class,'icon-tabler-x')]/parent::button
    Run Keyword If    '${count}'=='1'    Click Element    //*[contains(@class,'icon-tabler-x')]/parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Seller Order - Go To Order Detail Page By Status
    [Arguments]    ${status}    ${date_range}=${None}    ${need_api_detail}=${False}
    ${order_info}    API - Get Seller Order Info By Status And Customer Email    ${status}    ${date_range}
    ${order_number}    Set Variable    ${order_info}[orderNumber]
    Log   EA_Report_Data=${order_number}
    IF    "${need_api_detail}"=="${True}"
        ${order_detail}    API - Seller Get Order Detail By Order Number    ${order_number}
        Set Suite Variable    ${API_Order_Detail}    ${order_detail}
    END
    Go To    ${URL_MIK}/mp/seller/order-details/${order_number}?type=1
    Wait Until Element Is Visible    //h1[text()="Order Details"]
    Wait Until Element Is Visible    //table//img[@alt="Product Image"]
    Sleep    1
    Click Element    //h1[text()="Order Details"]

Flow - Seller Order - Search Pending Confirm Order And Confirm It
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[0]}
    Page Should Contain Element    //p[text()="${Orders_Status[0]}"]
    Seller Order - Select All Item On Order Detail Page
    Seller Order - Confirm Order On Order Detail Page
    Seller Order - Back To Order List On Order Detail Page

Flow - Seller Order - Ship Items By API
    [Arguments]    ${status}    ${all_item_ship}=allItemShip    ${all_quantity_ship}=allQuantityShip
    ${all_item_ship}    Set Variable If      "${all_item_ship}"=="allItemShip"     ${True}    ${False}
    ${all_quantity_ship}    Set Variable If    "${all_quantity_ship}"=="allQuantityShip"     ${True}    ${False}
    API - Flow - Ship Item    ${status}    ${all_item_ship}    ${all_quantity_ship}

Flow - Seller Order - Ship One Item For Ready To Ship Order
    [Arguments]    ${start_date}=-7    ${end_date}=0
    ${date_range}    Create List     ${start_date}    ${end_date}
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[1]}    ${date_range}
    Seller Order - Select One Item On Order Detail Page
    Seller Order - Ship Item On Order Detail Page
    Seller Order - Back To Order List On Order Detail Page


Flow - Seller Order - Search Order By Buyer Name And Status Then Enter Detail Page
    [Arguments]    ${name}    ${status}    ${is_loop}=${False}
    Seller Order - Filter - Search Order By Status List    ${status}
#    Seller Order - Search Order By Search Value    ${name}
    ${order_count}    Get Element Count    //p[contains(text(),"${name}")]
    IF   "${is_loop}"=="${False}"
        Skip IF  '${order_count}'=='0'    No order status is ${status}!
    ELSE
        IF  '${order_count}'=='0'
            Skip    No order status in ${status}!
        END
    END
    ${line_index}    Evaluate    random.randint(1,${order_count})
    Seller Order - Enter To Order Detail Page By Line Index    ${line_index}


Seller Order - Export Order By Status
    [Arguments]    ${status_list}
    Click Element    //div[text()="Download Report"]/parent::button
    Wait Until Element Is Visible    //header//p[text()="Bulk Export Order Details"]
    Click Element    //select[@name="selectOrderStatus"]
    ${status}    Set Variable
    FOR    ${status}    IN    @{status_list}
        Wait Until Element Is Visible    //option[text()="${status}"]
        Sleep    0.5
        Click Element    //option[text()="${status}"]
        Sleep    0.5
#        Wait Until Element Is Visible    //span[contains(text(),"${status}")]
    END
    Wait Until Element Is Enabled    //div[text()="Export Selected Order Details"]/parent::button
    Click Element    //div[text()="Export Selected Order Details"]/parent::button

Seller Order - Export File Manually And Check
    [Arguments]    ${status}
    IF    ${Cur_Order_Total}>0
        Wait Until Element Is Visible    //header//p[text()="Export Order Details to Spreadsheet - Export Success"]
        Remove Download File If Existed    order_excel.xlsx
        Click Element    //*[text()="Click Here to Download File Manually"]/parent::button
        Wait Until Element Is Not Visible    //*[text()="Click Here to Download File Manually"]/parent::button
        ${results}    ${file_path}    Wait Until File Download    order_excel.xlsx
        IF    "${results}"=="${False}"
            Fail    Fail to export file By ${status}.
        END
        ${order_export}    Read Download Excel    ${file_path}
        ${order_count}    Get Length    ${order_export}
        ${order_count}    Evaluate    ${order_count}-1
        Run Keyword And Ignore Error    Seller Order - Compare Filter Total And Page Total    ${status}    ${order_count}
    ELSE
        Wait Until Element Is Visible    //p[text()="Export Order Details to Spreadsheet - Export Failed"]
        Click Element    //div[text()="Back to Order Management"]/parent::button
        Wait Until Element Is Not Visible    //p[text()="Export Order Details to Spreadsheet - Export Failed"]
    END

Seller Order - Export Order By Status And Check Results
    [Arguments]    ${quantity}=1
    ${status_list}    Get Order Status By Number    ${quantity}
    Reload Page
    Seller Order - Filter - Search Order By Status List    ${status_list}
    Seller Order - Get Results Total Number
    Seller Order - Export Order By Status     ${status_list}
    Seller Order - Export File Manually And Check    ${status_list}

Seller Order - Export All Order
    Click Element    //div[text()="Download Report"]/parent::button
    Wait Until Element Is Visible    //header//p[text()="Bulk Export Order Details"]
    Sleep    1
    Click Element    //div[text()="Export All Orders Details"]/parent::button

Seller Order - Get Order Items Info
    Wait Until Element Is Visible    //table//tbody/tr
    ${count}    Get Element Count    //table//tbody/tr
    ${index}   Set Variable
    ${items}   Create List
    FOR    ${index}    IN RANGE    1    ${${count}+1}
        ${name}    Get Text    //table//tbody/tr[${index}]/td[3]/div/p
        ${sku}     Get Text    //table//tbody/tr[${index}]/td[3]/div/div/p
        ${sku}    Evaluate    '${sku}'\[5:\]
        ${quantity}    Get Text    //table//tbody/tr[${index}]/td[5]//p
        ${cost}    Get Text    //table//tbody/tr[${index}]/td[6]//p
        ${item_subtotal}    Get Text    //table//tbody/tr[${index}]/td[7]//p
        ${item}    Create Dictionary    name=${name}    sku=${sku}    quantity=${quantity}
        ...    cost=${cost}    subtotal=${item_subtotal}
        Set Suite Variable    ${Order_Item_One}     ${item}
        Append To List    ${items}    ${item}
    END
    ${discounts_count}    Get Element Count    //p[text()="Discounts"]
    IF    ${discounts_count}==1
        ${discounts}   Set Variable     ${True}
    ELSE
        ${discounts}   Set Variable     ${False}
    END
    ${subtotal}    Get Text    //p[text()="Total"]/../following-sibling::div/p[1]
    IF    ${discounts}==${True}
        ${discounts_total}    Get Text    //p[text()="Total"]/../following-sibling::div/p[2]
        ${shipping_rate}    Get Text    //p[text()="Total"]/../following-sibling::div/p[3]
        ${tax}    Get Text    //p[text()="Total"]/../following-sibling::div/p[4]
        ${total}    Get Text    //p[text()="Total"]/../following-sibling::div/p[5]
    ELSE
        ${discounts_total}    Set Variable    -$0
        ${shipping_rate}    Get Text    //p[text()="Total"]/../following-sibling::div/p[2]
        ${tax}    Get Text    //p[text()="Total"]/../following-sibling::div/p[3]
        ${total}    Get Text    //p[text()="Total"]/../following-sibling::div/p[4]
    END
    ${Cur_Order_Items}    Create Dictionary    items=${items}    subtotal=${subtotal}    shipping_rate=${shipping_rate}
    ...    tax=${tax}    total=${total}    discounts=${discounts}    discounts_total=${discounts_total}
    Set Suite Variable    ${Cur_Order_Items}    ${Cur_Order_Items}
    ${address}    Get Text    //p[text()="Customer Name"]/../following-sibling::div/div[2]/p
    ${is_AK}    Evaluate    "${address}".count("AK")
    IF    ${is_AK}
          Should Be Equal As Strings    ${tax}    $0.00
    END


