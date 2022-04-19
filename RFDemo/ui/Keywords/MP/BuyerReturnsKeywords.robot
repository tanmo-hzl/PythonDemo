*** Settings ***
Library             ../../Libraries/CommonLibrary.py
Library             ../../Libraries/MP/BuyerAccountInfoLib.py
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerOrderHistoryKeywords.robot
Resource            ../../Keywords/MP/EAInitialBuyerDataAPiKeywords.robot

*** Variables ***
${Return_Reasons}
${Reason}

*** Keywords ***
Buyer Return - Click Return Button On Order Detail Page
    Wait Until Page Contains Element    //div[text()="Return"]
    Scroll Element Into View    //div[text()="Return"]
    Click Element    //div[text()="Return"]/parent::button
    Sleep    1
    Wait Until Element Is Visible    //p[text()="Create Return Order"]
    Wait Until Element Is Visible    //img[@alt="item"]

Buyer Return - Search Order
    [Arguments]    ${search_value}
    Clear Element Value    //*[@id="searchOrders"]
    Input Text    //*[@id="searchOrders"]    ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
    Wait Loading Hidden

Buyer Return - Clear Search Value
    ${ele}    Set Variable    //*[@id="searchOrders"]/following-sibling::*[contains(@class,"icon-tabler-x")]
    ${count}    Get Element Count    ${ele}
    Run Keyword If    '${count}'=='1'    Click Element    ${ele}
    Wait Loading Hidden

Buyer Return - Filter - Clear All
    Wait Until Element Is Visible    //p[starts-with(text(),"Filter")]/../parent::button
    Click Element    //p[starts-with(text(),"Filter")]/../parent::button
    Wait Until Element Is Visible    ${Filter_View_Results}
    Sleep    1
    Click Element    ${Filter_Clear_All}
    Wait Until Element Is Not Visible    ${Filter_View_Results}
    Wait Loading Hidden
    Wait Until Element Is Visible    ${Filter_View_Results}

Buyer Return - Filter By Duration
    [Documentation]    [All Time,Today,Past 2 days,Past 7 days,Past 30 days,Past 6 Month,Past Year]
    [Arguments]    ${duration}=All Time
    Wait Until Element Is Visible    //p[starts-with(text(),"Filter")]/../parent::button
    Click Element    //p[starts-with(text(),"Filter")]/../parent::button
    Wait Until Element Is Visible    ${Filter_View_Results}
    Sleep    1
    Click Element    //p[text()="${duration}"]/../../parent::label
    Click Element    ${Filter_View_Results}
    Wait Until Element Is Not Visible    ${Filter_View_Results}
    Wait Loading Hidden
    Wait Until Element Is Visible     ${Filter_View_Results}

Buyer Return - Eneter Detail Page By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    //button[contains(@class,"chakra-button")]
    Click Element    (//button[contains(@class,"chakra-button")])[${index}]
    Wait Loading Hidden
    Wait Until Element Is Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //img[@alt="thumbnail"]

Buyer Return - Eneter Detail Page By Status
    [Arguments]    ${status}=Pending Return
    Wait Until Element Is Visible    //button[contains(@class,"chakra-button")]
    Click Element    //div[text()="${status}"]/../..
    Wait Loading Hidden
    Wait Until Element Is Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //img[@alt="thumbnail"]


Buyer Return - Back To Order List On Order Detail Page
    Click Element    //p[text()="Return and Dispute"]/../parent::a
    Wait Until Element Is Not Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filter")]/../parent::button

Buyer Return - Cancel Pending Return Order
    [Arguments]    ${sure}=${True}
    Click Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Visible    //*[text()="Cancel Return"]
    Wait Until Element Is Visible    //p[text()="Are you sure you want to cancel your return order ?"]
    IF    '${sure}'=='${True}'
        Click Element  //div[text()="Confirm"]/parent::button
        Wait Until Element Is Visible    //*[text()="Success"]
        Wait Until Element Is Not Visible    //*[text()="Success"]
        Page Should Contain Element    //p[text()="Cancelled"]
    ELSE
        Click Element  //div[text()="Close"]/parent::button
    END

Buyer Return - Selected All Items
    Wait Until Page Contains Element   //input[@aria-label="primary checkbox"]
    ${check_all_ele}   Set Variable    (//span[contains(@class,"checkAll")]//input[@aria-label="primary checkbox"])
    ${count}    Get Element Count       ${check_all_ele}
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${count}
        ${js_index}   Evaluate    ${index}-1
        Execute Javascript    document.querySelectorAll("span.checkAll")[${js_index}].scrollIntoView()
        Sleep    0.5
        ${checkable}    Get Element Attribute    (//span[contains(@class,"checkAll")])[${index}]     aria-disabled
        IF    '${checkable}'=='false'
            Wait Until Element Is Enabled    ${check_all_ele}\[${index}\]
            Click Element    ${check_all_ele}\[${index}\]
#            Execute Javascript    document.querySelectorAll("span.checkAll input")[${js_index}].click()
        END
        Sleep    0.5
    END
    Sleep    2

Buyer Return - Get Returnable Items Info
    ${items_name}    Create List
    ${items_price}    Create List
    ${items_quantity}    Create List
    ${count}    Get Element Count    //input[@data-testid="input num"]
    ${index}   Set Variable
    FOR    ${index}    IN RANGE    1    ${count}+1
        ${name}    Get Text    (//input[@data-testid="input num"])[${index}]/../preceding-sibling::p
        Append To List    ${items_name}    ${name}
        ${price}    Get Text  (//input[@data-testid="input num"])[${index}]/../following-sibling::div/p
        Append To List    ${items_price}    ${price}
        ${quantity}    Get Value  (//input[@data-testid="input num"])[${index}]
        Append To List    ${items_quantity}    ${quantity}
    END
    ${Return_Reasons}     Get Return Reason Info    ${items_name}    ${items_price}    ${items_quantity}
    Set Suite Variable    ${Return_Reasons}    ${Return_Reasons}

Buyer Return - Set Returnable Items Quantity
    ${item}    Set Variable
    ${index}   Set Variable    1
    FOR    ${item}    IN    @{Return_Reasons}
        Buyer Return - Input Return Item Quantity By Index    ${index}    ${item}[quantity]    ${item}[maxQuantity]
        ${index}    Evaluate    ${index}+1
    END

Buyer Return - Input Return Item Quantity By Index
    [Arguments]    ${index}=1     ${quantity}=1    ${max_quantity}=1
    ${ele_text}    Set Variable    (//input[@data-testid="input num"])[${index}]
    ${ele_but}    Set Variable    (//button[@data-testid="minus-button"])[${index}]
    ${btn_index}    Evaluate     (${index}-1)*2
    Execute Javascript    document.querySelectorAll("button.chakra-button")[${btn_index}].scrollIntoView()
    ${item}   Set Variable
    FOR    ${item}   IN RANGE    1    ${max_quantity}
        ${text}    Get Value    ${ele_text}
        Exit For Loop If    '${text}'=='${quantity}'
        Execute Javascript    document.querySelectorAll("button.chakra-button")[${btn_index}].click()
        Sleep  0.1
    END

Buyer Return - Stop Return Items
    [Arguments]    ${sure}=${True}
    Scroll Element Into View    //button[contains(@class,'MuiButtonBase-root')]
    Click Element    //button[contains(@class,'MuiButtonBase-root')]
    Wait Until Element Is Visible    //p[text()="Cancel Return Items"]
    Run Keyword If    '${sure}'=='${True}'    Click Element    //span[text()="Yes"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //span[text()="No"]/parent::button
    Run Keyword If    '${sure}'=='${True}'    Wait Until Element Is Visible    //p[text()="Order Detail"]

Buyer Return - Click Back
    Scroll Last Button Into View
    Click Element    //span[text()="Back"]/parent::button
    Sleep    1

Buyer Return - Click Next
    Scroll Last Button Into View
    Execute Javascript    var count = document.querySelectorAll("button[type=button]"); count[count.length-1].click();
#    Click Element    //span[text()="Next"]/parent::button

Buyer Return - Click Submit
    Wait Until Page Contains Element    //span[text()="Submit"]/parent::button
    Scroll Last Button Into View
    Click Element    //span[text()="Submit"]/parent::button
    Sleep    0.5
    Wait Until Element Is Visible    //*[text()="View Return Details"]

Buyer Return - View Return Detail After Submit
    Wait Until Element Is Visible    //span[text()="View Return Details"]/parent::button
    Click Element    //span[text()="View Return Details"]/parent::button
    Wait Until Element Is Visible    //p[text()="Return and Dispute"]/../parent::a
    Wait Loading Hidden
    Page Should Contain    Refund Summary

Buyer Return - Cancel Return Request After Submit
    Wait Until Element Is Visible    //span[text()="View Return Details"]/parent::button
    Scroll Last Button Into View
    ${count}    Get Element Count    //span[text()="Cancel Return Request"]/parent::button
    IF    ${count}==1
        Click Element    //span[text()="Cancel Return Request"]/parent::button
        Wait Until Element Is Visible    //header[text()="Cancel Return Request"]
        Page Should Contain Element    //p[text()="Are you sure to cancel the return order ?"]
        Click Element    //span[text()="Confirm"]/parent::button
        Wait Until Element Is Not Visible    //span[text()="Cancel Return Request"]/parent::button
        Wait Until Element Is Visible    //p[text()="Your return order has been cancelled successfully."]
        Click Element    //p[text()="Tips"]/following-sibling::*
        Click Element    //span[text()="View Return Details"]/parent::button
        Wait Until Element Is Visible    //p[text()="Return and Dispute"]/../parent::a
        Wait Loading Hidden
        Page Should Contain Element    //p[text()="Cancelled"]
    ELSE
        Pass Execution    This return order can't be cancel!
    END

Buyer Return - Change Customer Address
    Click Element    //button[contains(@class,"changeAddressButton")]
    Wait Until Element Is Visible    //header[text()="Customer Address Change"]
    ${address}    Get Address Info
    Clear Element Value    //input[@placeholder="Please enter address1"]
    Input Text    //input[@placeholder="Please enter address1"]    ${address}[address1]
    Clear Element Value    //input[@placeholder="Please enter address2"]
    Input Text    //input[@placeholder="Please enter address2"]    ${address}[address2]
    Clear Element Value    //input[@placeholder="Please enter zip code"]
    Input Text    //input[@placeholder="Please enter zip code"]    ${address}[zipcode]
    Clear Element Value    //input[@placeholder="Please enter city"]
    Input Text    //input[@placeholder="Please enter city"]    ${address}[city]
    Clear Element Value    //input[@placeholder="Please enter state"]
    Input Text    //input[@placeholder="Please enter state"]    ${address}[state]
    Click Element    //*[text()="Submit"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Customer Address Change"]
    Wait Until Element Is Visible    //*[text()="Submitted successfully"]
    Click Element    //p[text()="Tips"]/following-sibling::*
    Wait Until Element Is Not Visible    //*[text()="Submitted successfully"]

Buyer Return - Set Returnable Items Reason Info
    ${item}    Set Variable
    ${index}   Set Variable    1
    FOR    ${item}    IN    @{Return_Reasons}
        ${js_index}   Evaluate    ${index}-1
        Execute Javascript    document.querySelectorAll("div[role='region'] > div")[${js_index}].scrollIntoView()
        Sleep    1
        Buyer Return - Select Return Reason By Index    ${index}    ${item}[reason_value]
        Buyer Return - Select Condition Of The Item By Index    ${index}    ${item}[condition]
        Buyer Return - Input Reason Notes By Index    ${index}    ${item}[notes]
        Buyer Return - Upload Photos By Index    ${index}    ${item}[photos]
        ${index}    Evaluate    ${index}+1
    END

Buyer Return - Select Return Reason By Index
    [Arguments]    ${index}=1    ${re_reason}=Changed Mind
    ${ele}  Set Variable    (//div[contains(@class,"ReasonPageFrom1")])[${index}]//p[text()="Return Reason"]/../following-sibling::div//button[contains(@id,"menu-button")]
    Wait Until Element Is Visible    ${ele}
    Wait Until Element Is Enabled    ${ele}
    Click Element    ${ele}
    Sleep    0.5
    Wait Until Element Is Visible   ${ele}/following-sibling::div//button\[@value="Changed Mind"\]
    IF    ${index}==1
        ${reason_index}    Evaluate    (${index}-1)*2
        Execute Javascript    document.querySelectorAll("div.fli_menu_list_wrapper")[${reason_index}].scrollIntoView()
        Sleep    0.5
    END
    Click Element   ${ele}/following-sibling::div//button[contains(@id,"menuitem") and @value="${re_reason}"]

Buyer Return - Select Condition Of The Item By Index
    [Arguments]    ${index}=1    ${condition}=${None}
    IF   '${condition}'!='${None}'
        ${ele}  Set Variable    (//div[contains(@class,"ReasonPageFrom1")])[${index}]//p[text()="Condition of the item"]/../following-sibling::div/button
        Click Element    ${ele}
        Wait Until Element Is Visible    ${ele}/following-sibling::div//button
        Click Element    ${ele}/following-sibling::div//button[@value="${condition}"]
    END

Buyer Return - Input Reason Notes By Index
    [Arguments]   ${index}=1    ${notes}=Notes
    Input Text    (//div[contains(@class,"ReasonPageFrom1")]//*[@data-testid="Notes"])[${index}]    ${notes}

Buyer Return - Upload Photos By Index
    [Arguments]    ${index}=1    ${photos}=${None}
    IF   '${photos}'!='${None}'
        Click Element    (//div[contains(@class,"ReasonPageFrom1")])[${index}]//p[text()="Add photos or videos"]
        Wait Until Element Is Visible    //header[text()="Add photos or videos"]
        ${width}    ${height}    Get Window Size
        Choose File    //*[@id="upload-photo"]    ${photos}
        Sleep    0.5
        Wait Until Page Does Not Contain Element   //span[text()="Loading..."]
        Sleep    0.5
        Click Element    //span[text()="Submit"]/parent::button
        Wait Until Element Is Not Visible    //span[text()="Submit"]/parent::button
    END

Buyer Return - Save Return Order Info By Parent Order Number
    [Arguments]    ${par_order_number}
    Buyer Return - Search Order    ${par_order_number}
    ${index}    Set Variable
    ${return_order_list}    Create List
    FOR    ${index}    IN RANGE    10
        ${page_order_count}    Get Element Count  (//button//div[2]//p[text()="Return Numbers"])
        ${page_order_count}    Evaluate    ${page_order_count}+1
        ${order_index}    Set Variable
        FOR    ${order_index}    IN RANGE    1    ${page_order_count}
            ${return_numbers}    Get Text     (//button//div[2]//p[text()="Return Numbers"])[${order_index}]/following-sibling::p
            ${refund_total}    Get Text     (//button//div[3]//p[text()="Refund Total"])[${order_index}]/following-sibling::p
            ${order_status}    Get Text     (//button//div[4]//p[text()="Status"])[${order_index}]/following-sibling::p
            ${update_time}    Get Text     (//button//div[5]//p[text()="Update Time"])[${order_index}]/following-sibling::p
            ${eturn_order_info}    Create Dictionary    returnNumber=${return_numbers}    refundTotal=${refund_total}
            ...    orderStatus=${order_status}    updateTime=${update_time}
            Append To List    ${return_order_list}    ${eturn_order_info}
        END
        ${next_page_disabled}    Get Element Count    //div[@aria-label="Next Page" and @disabled]
        Exit For Loop If    ${next_page_disabled}==1
        Click Element    //div[@aria-label="Next Page"]
        Wait Loading Hidden
        Sleep    1
    END
    Save File    orders_buyer_return    ${return_order_list}    MP    ${ENV}

Buyer Return - Return Order Again And Again
    [Arguments]    ${order_numbers}
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    2
        Buyer Left Menu - Orders & Purchases - Order History
        ${returnalbe}    Buyer Order - Check Order Can Return Again    ${order_numbers}
        Exit For Loop If    "${returnalbe}"=="${False}"
        Buyer Return - Flow - Submit Return For All Items
    END

Buyer Return - Flow - Submit Return For All Items
    [Arguments]    ${cancel_return}=${False}
    Buyer Return - Click Return Button On Order Detail Page
    Buyer Return - Change Customer Address
    Buyer Return - Selected All Items
    Buyer Return - Get Returnable Items Info
    Buyer Return - Set Returnable Items Quantity
    Buyer Return - Click Next
    Buyer Return - Set Returnable Items Reason Info
    Buyer Return - Click Next
    Buyer Return - Click Submit
    IF     "${cancel_return}"=="${False}"
        Buyer Return - View Return Detail After Submit
    ELSE
        Buyer Return - Cancel Return Request After Submit
    END

Buyer Return - Get Shipping And Completed Order By API
    ${order_list}    API - Get Buyer Order List
    ${returnable_orders}    Get Shipping And Completed Order    ${order_list}
    [Return]    ${returnable_orders}

Buyer Return - Get Returnable Order By API
    ${order_numbers}    Buyer Return - Get Shipping And Completed Order By API
    ${order_len}    Get Length    ${order_numbers}
    Skip If    '${order_len}'=='0'    There are no order can return
    ${order}    Set Variable
    ${return_parent_order_number}    Set Variable    ${None}
    FOR    ${order}    IN    @{order_numbers}
        ${returnable}    API - Check Buyer Order Actionable By Parent Order Number    ${order}    return
        IF    "${returnable}"=="${True}"
            ${return_parent_order_number}    Set Variable    ${order}
            Set Suite Variable    ${Returnable_Order_Number}    ${order}
            Exit For Loop
        END
    END
    [Return]    ${return_parent_order_number}

Buyer Return - Go To Order History Detail Page
    [Arguments]    ${parent_order_number}=${None}
    IF    "${parent_order_number}"!="${None}"
        Go To    ${URL_MIK}/buyertools/order-history?detail=${parent_order_number}
        Log   EA_Report_Data=${parent_order_number}
        Wait Loading Hidden
        Wait Until Element Is Visible    //div[text()="Buy All Again"]/parent::button
        Wait Until Element Is Visible    //img[@alt="thumbnail"]
    ELSE
        Skip   There are no order can create return order.
    END


Buyer Return - Flow - Create Return Order By API
    [Arguments]    ${partial_item_return}=${False}    ${partial_quantity_return}=${False}    ${buyer_reason}=${False}
    ${return_parent_order_number}    Buyer Return - Get Returnable Order By API
    ${partial_item_return}    Set Variable If     "${partial_item_return}"=="partialItemReturn"    ${True}    ${False}
    ${partial_quantity_return}    Set Variable If     "${partial_item_return}"=="partialQuantityReturn"    ${True}    ${False}
    ${buyer_reason}    Set Variable If     "${partial_item_return}"=="buyerReason"    ${True}    ${False}
    IF    "${return_parent_order_number}"!="${None}"
        API - Buyer Create Return Order By Parent Order Number    ${return_parent_order_number}
        ...    ${partial_item_return}    ${partial_quantity_return}    ${buyer_reason}
        IF    "${partial_item_return}"=="${True}" or "${partial_quantity_return}"=="${True}"
            ${returnable}    API - Check Buyer Order Actionable By Parent Order Number    ${return_parent_order_number}    return
            IF    "${returnable}"=="${True}"
                API - Buyer Create Return Order By Parent Order Number    ${return_parent_order_number}
                ...    ${False}    ${False}    ${buyer_reason}
            END
        END
    ELSE
        Skip   There are no order can create return order by API.
    END
