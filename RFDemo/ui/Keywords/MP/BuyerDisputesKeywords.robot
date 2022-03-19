*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/BuyerDisputeLib.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Reason_List}
${Disputable_Order_Number}    ${None}
${BUYER_EMAIL}
${Cur_Order_Number}    ${None}
${Dispute_Buttons}

*** Keywords ***
Buyer Disputes - List - Loop To Get Return Declined Order
    ${disputable_order_numbers}    Create List
    ${base_ele}   Set Variable   (//div[text()="Refund Declined"]/../../parent::div/preceding-sibling::div//p[text()="Return Numbers"]/following-sibling::p)
    ${count}    Get Element Count    ${base_ele}
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${count}
        ${order_number}    Get Text    ${base_ele}\[${index}\]
        Append To List    ${disputable_order_numbers}    ${order_number}
    END
    Save File    orders_refund_declined    ${disputable_order_numbers}    MP    ${ENV}

Buyer Disputes - List - Loop To Get Order By Dispute Status
    [Arguments]    ${status}=Submit Dispute
    ${return_numbers}    Get Disputable Order Ids    ${Disputable_Order_Number}    ${ENV}
    ${return_number}    Set Variable
    ${index}    Set Variable    0
    FOR    ${return_number}    IN    @{return_numbers}
        ${index}    Evaluate    ${index}+1
        Exit For Loop If    ${index}>10
        Set Suite Variable    ${Disputable_Order_Number}    ${return_number}
        Buyer Disputes - List - Search Order By Value    ${return_number}
        Buyer Disputes - List - Eneter Detail Page By Index    1    ${True}
        ${count}    Get Element Count    //div[text()="${status}"]/parent::button
        Exit For Loop If    '${count}'=='1'
        Buyer Disputes - Detail - Back To Order List On Detail Page
        Buyer Disputes - List - Clear Search Value
    END
    ${now_url}    Get Location
    ${url_mp_dispute}   Set Variable    ${URL_MIK}/buyertools/return-and-dispute
    IF   '${now_url}'=='${url_mp_dispute}'
        #Capture Page Screenshot    filename=EMBED
        Skip   No order can ${status}.
    END

Buyer Disputes - Get Offer Made Order Numbers
    ${Offer_Made_Orders}    Get Offer Made Order Ids    ${Cur_Order_Number}    ${ENV}
    ${order_len}    Get Length    ${Offer_Made_Orders}
    IF   "${order_len}"=="0"
        Skip    No order status is Offer Made!
    END
    Set Suite Variable    ${Cur_Order_Number}    ${Offer_Made_Orders[0]}

Buyer Disputes - Get Cancellable Order Numbers
    ${Offer_Made_Orders}    Get Cancellable Order Ids    ${None}    ${ENV}
    ${order_len}    Get Length    ${Offer_Made_Orders}
    IF   "${order_len}"=="0"
        Skip    No order is calcellable!
    END
    Set Suite Variable    ${Cur_Order_Number}    ${Offer_Made_Orders[0]}



Buyer Disputes - List - Search Order By Value
    [Arguments]    ${search_value}
    Clear Element Value    //*[@id="searchOrders"]
    Input Text    //*[@id="searchOrders"]    ${search_value}
    Press Keys    //*[@id="searchOrders"]    ${RETURN_OR_ENTER}
    Wait Loading Hidden

Buyer Disputes - List - Clear Search Value
    ${ele}    Set Variable    //*[@id="searchOrders"]/following-sibling::*[contains(@class,"icon-tabler-x")]
    ${count}    Get Element Count    ${ele}
    Run Keyword If    '${count}'=='1'    Click Element    ${ele}
    Wait Loading Hidden

Buyer Disputes - List - Eneter Detail Page By Index
    [Arguments]    ${index}=1   ${disputable}=${False}
    Wait Until Element Is Visible    //button[contains(@class,"chakra-button")]
    Click Element    (//button[contains(@class,"chakra-button")])[${index}]
    Wait Loading Hidden
    Wait Until Element Is Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //img[@alt="thumbnail"]
    IF    '${disputable}'=='${True}'
        Wait Until Element Is Visible    //div[contains(text(),"Dispute")]/parent::button
    END

Buyer Disputes - List - Eneter Detail Page By Status
    [Arguments]    ${status}=Refund Declined   ${disputable}=${False}
    Wait Until Element Is Visible    //button[contains(@class,"chakra-button")]
    Click Element    //button[contains(@class,"chakra-button")]//*[text()="${status}"]
    Wait Loading Hidden
    Wait Until Element Is Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //img[@alt="thumbnail"]
    IF    '${disputable}'=='${True}'
        Wait Until Element Is Visible    //div[contains(text(),"Dispute")]/parent::button
    END

Buyer Disputes - Detail - Click Submit Dispute
    Wait Until Element Is Visible    //div[text()="Submit Dispute"]/parent::button
    Click Element    //div[text()="Submit Dispute"]/parent::button
    Wait Until Element Is Visible    //*[text()="Reason for Dispute"]

Buyer Disputes - Detail - Click View Dispute
    Wait Until Element Is Visible    //div[text()="View Dispute"]/parent::button
    Click Element    //div[text()="View Dispute"]/parent::button
    Wait Until Element Is Visible    //*[text()="Process Dispute"]

Buyer Disputes - Submit - Select All Items
    Wait Until Element Is Visible      //input[@aria-label="primary checkbox"]/../..
    Click Element    //input[@aria-label="primary checkbox"]/../..
    Checkbox Should Be Selected    //input[@aria-label="primary checkbox"]

Buyer Disputes - Submit - Get Items Count Dispute Reason
    ${count}    Get Element Count    //p[text()="SKU No."]
    ${Reason_List}    Get Dispute Reason    ${count}
    Set Suite Variable    ${Reason_List}    ${Reason_List}

Buyer Disputes - Submit - Loop Add Dispute Reason And Notes To Items
    Buyer Disputes - Submit - Get Items Count Dispute Reason
    Execute Javascript    var count = document.querySelectorAll("button[type=button]"); count[count.length-1].scrollIntoView();
    ${reason_info}    Set Variable
    ${index}    Evaluate    1
    FOR    ${reason_info}    IN    @{Reason_List}
        Execute Javascript    document.querySelectorAll('div[role="region"] > div')[${index}].scrollIntoView()
#        ${item_area_index}    Evaluate      ${index}+1
#        Scroll Element Into View    //*[@role="region"]/div[${item_area_index}]
        Buyer Disputes - Submit - Select Dispute Reason By Index    ${reason_info}[reason]    ${index}
        Buyer Disputes - Submit - Input Dispute Notes By Index    ${reason_info}[notes]    ${index}
        IF   '${reason_info}[photo]'!='${None}'
            Buyer Disputes - Submit - Upload Dispute Photos By Index    ${reason_info}[photo]    ${index}
        END
        ${index}    Evaluate    ${index}+1
    END

Buyer Disputes - Submit - Select Dispute Reason By Index
    [Arguments]    ${reason}    ${index}=1
    ${base_ele}    Set Variable    (//p[text()="Dispute Reason"]/../following-sibling::div/button)
    Wait Until Element Is Visible    ${base_ele}
    Click Element    ${base_ele}\[${index}\]
    Sleep    0.5
    Wait Until Element Is Visible    ${base_ele}\[${index}\]/following-sibling::div//button\[@value="Changed Mind"\]
    IF    ${index}==1
        ${reason_index}     Evaluate    (${index}-1)*2
        Execute Javascript    document.querySelector("div.fli_menu_list_wrapper").scrollIntoView()
        Sleep    0.5
    END
    Click Element    ${base_ele}\[${index}\]/following-sibling::div//button\[@value="${reason}"\]

Buyer Disputes - Submit - Input Dispute Notes By Index
    [Arguments]    ${notes}    ${index}=1
    Input Text  (//input[@data-testid="Notes"])[${index}]    ${notes}

Buyer Disputes - Submit - Upload Dispute Photos By Index
    [Arguments]    ${photos}    ${index}=1
    Scroll Element Into View    (//p[text()="Add Photos or Videos"])[${index}]
    Click Element    (//p[text()="Add Photos or Videos"])[${index}]
    Wait Until Element Is Visible    //header[text()="Add photos or videos"]
    Choose File    //*[@id="upload-photo"]    ${photos}
    Sleep    1
    Wait Until Element Is Not Visible    //*[text()="Loading..."]
    Click Element    //span[text()="Submit"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Add photos or videos"]

Buyer Disputes - Submit - Click Next
    Wait Until Element Is Enabled    //span[text()="Next"]/parent::button
    Execute Javascript    document.querySelector("button.A-dXXu > span").scrollIntoView()
    Execute Javascript    document.querySelector("button.A-dXXu").click()
    Wait Until Element Is Visible    //span[text()="Submit"]/parent::button

Buyer Disputes - Submit - Check Dispute Submit Info
    Wait Until Page Contains Element    //span[text()="Submit"]/parent::button
    ${reason_info}    Set Variable
    FOR    ${reason_info}    IN    @{Reason_List}
        Page Should Contain Element    //p[text()="${reason_info}[reason]"]
        Page Should Contain Element    //p[text()="${reason_info}[notes]"]
    END

Buyer Disputes - Submit - Click Submit
    ${submit_ele}   Set Variable    //span[text()="Submit"]/parent::button
    Wait Until Element Is Visible    ${submit_ele}
    Scroll Element Into View    ${submit_ele}
    Click Element    ${submit_ele}
    Wait Until Element Is Not Visible    ${submit_ele}
    Wait Until Element Is Visible    //*[text()="Dispute Confirmation"]

Buyer Disputes - Submit - Click View Dispute Details
    Wait Until Element Is Visible    //span[text()="View Dispute Details"]/parent::button
    Click Element    //span[text()="View Dispute Details"]/parent::button
    Wait Until Element Is Visible    //*[text()="Process Dispute"]

Buyer Disputes - Submit - Cancel Submit
    [Arguments]    ${sure}=${True}
    Click Close Icon In Top Right-hand Corner
    Wait Until Element Is Visible    //p[text()="Cancel Dispute Items"]
    Run Keyword If    '${sure}'=='${True}'    Click Element    //span[text()="Yes']/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //span[text()="No']/parent::button
    Wait Until Element Is Not Visible    //p[text()="Cancel Dispute Items"]
    Run Keyword If    '${sure}'=='${True}'    Wait Until Element Is Visible    //p[text()="Return and Dispute"]

Buyer Disputes - Detail - Back To Order List On Detail Page
    Click Element    //p[text()="Return and Dispute"]/parent::a
    Wait Until Element Is Not Visible    //p[text()="Payment Method"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filter")]/../parent::button

Buyer Disputes - Process - Selected I Acknowledge Offer And Select Offer
    [Arguments]    ${offer}=Reject Offer
    Scroll Last Button Into View
    ${count}    Get Element Count    //p[contains(text(),"I acknowledge that acceptance of the offer is final and irreversible")]
    IF    ${count}>0
        Click Element    //p[contains(text(),"I acknowledge that acceptance of the offer is final and irreversible")]/../parent::label
        Click Element    //a[text()="${offer}"]
        Wait Until Element Is Not Visible    //a[text()="${offer}"]
    ELSE
        Skip    There are no order can ${offer}.
    END

Buyer Disputes - Process - Click Dispute Summary
    Scroll Last Button Into View
    Click Element    //span[text()="Dispute Summary"]/parent::button
    Wait Until Element Is Visible    //*[text()="Dispute Summary"]

Buyer Disputes - Process - Back To Dispute Detail
    Click Close Icon In Top Right-hand Corner
    Wait Until Element Is Not Visible    //*[text()="Process Dispute"]
    Wait Until Page Contains Element    //a[text()="Contact Seller"]        ${MAX_TIME_OUT}

Buyer Disputes - Process - Click Back
    Scroll Last Button Into View
    Click Element    //p[text()="Back"]/parent::div
    Wait Until Element Is Not Visible    //p[text()="Back"]/parent::div
    Wait Until Element Is Visible    //*[text()="Process Dispute"]

Buyer Disputes - Process - Click Cancel Dispute
    Scroll Last Button Into View
    Click Element    //span[text()="Cancel Dispute"]/parent::button
    Wait Until Element Is Visible    //h3[text()="Cancel Dispute"]

Buyer Disputes - Cancel - Input Cancel Dispute Info
    Wait Until Element Is Visible    //h3[text()="Cancel Dispute"]
    ${cancel_info}    Get Cancel Info
    Click Element     //*[@role="none presentation"]//button[contains(@class,"fli_menu_button")]
    Wait Until Element Is Visible    //button[text()="Item Received"]
    Click Element    //button[text()="${cancel_info}[reason]"]
    Input Text    //*[@data-testid="Add Notes"]    ${cancel_info}[notes]

Buyer Disputes - Cancel - Selected I Acknowledge
     [Arguments]    ${accpet}=${True}
    ${base_ele}    Set Variable    //span[contains(text(),"I acknowledge that this cancellation is final and irreversible")]/parent::label
    ${count}    Get Element Count    ${base_ele}/span[contains(@class,"Mui-checked")]
    IF   '${count}'=='0' and '${accpet}'=='${True}'
        Click Element    ${base_ele}
    ELSE IF  '${count}'=='1' and '${accpet}'=='${False}'
        Click Element    ${base_ele}
    END

Buyer Disputes - Cancel - Submit Or Close
    [Arguments]    ${sure}=${True}
    Wait Until Element Is Enabled    //span[text()="Cancel Dispute"]/parent::button
    Run Keyword If    '${sure}'=='${True}'    Click Element    //*[@role="presentation"]//span[text()="Cancel Dispute"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //*[@role="presentation"]//span[text()="Close"]/parent::button
    Wait Until Element Is Not Visible    //h3[text()="Cancel Dispute"]

Buyer Disputes - Process - Click Escalate Dispute
    Scroll Last Button Into View
    Click Element    //span[text()="Escalate Dispute"]/parent::button
    Wait Until Element Is Visible    //h3[text()="Escalate to Michaels"]

Buyer Disputes - Escalate - Input Escalate Info
    ${escalate_info}    Get Escalate Info
    Input Text    //*[@data-testid="Escalation Reason"]    ${escalate_info}[reason]
    Click Element    //*[@role="presentation"]//*[@aria-haspopup="menu"]
    Wait Until Element Is Visible    //button[text()="Email"]
    Click Element    //button[text()="${escalate_info}[contact]"]
    IF    '${escalate_info}[contact]'=='Email'
        Input Text    //*[@data-testid="input"]    ${BUYER_EMAIL}
    ELSE
        Input Text    //*[@data-testid="input"]    ${escalate_info}[phone]
    END

Buyer Disputes - Escalate - Select I Acknowledge
     [Arguments]    ${accpet}=${True}
    ${base_ele}    Set Variable    //span[contains(text(),"I acknowledge that once escalated to Michaels")]/parent::label
    ${count}    Get Element Count    ${base_ele}/span[contains(@class,"Mui-checked")]
    IF   '${count}'=='0' and '${accpet}'=='${True}'
        Click Element    ${base_ele}
    ELSE IF  '${count}'=='1' and '${accpet}'=='${False}'
        Click Element    ${base_ele}
    END

Buyer Disputes - Escalate - Click Yes Or No
    [Arguments]    ${sure}=${True}
    Run Keyword If    '${sure}'=='${True}'    Click Element    //span[text()="Yes"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //span[text()="No"]/parent::button
    Wait Until Element Is Not Visible    //h3[text()="Escalate to Michaels"]

Buyer Disputes - Flow - Submit Dispute For Rejected Refund Order
    [Arguments]    ${occupancy_parameter}=0
    Buyer Left Menu - Return And Dispute
    Buyer Disputes - List - Loop To Get Order By Dispute Status    ${Dispute_Buttons[0]}
    Buyer Disputes - Detail - Click Submit Dispute
    Buyer Disputes - Submit - Select All Items
    Buyer Disputes - Submit - Loop Add Dispute Reason And Notes To Items
    Buyer Disputes - Submit - Click Next
    Buyer Disputes - Submit - Click Submit
    Buyer Disputes - Submit - Click View Dispute Details
    Buyer Disputes - Process - Back To Dispute Detail