*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot

*** Variables ***
${Returnable_Order_Number}    ${None}

*** Keywords ***
Buyer Order - Search Order By Search Value
    [Arguments]    ${search_value}
    Wait Until Element Is Visible   //input[@id="searchOrders"]
    Clear Element Value    //input[@id="searchOrders"]
    Input Text    //*[@id="searchOrders"]     ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
    Wait Loading Hidden

Buyer Order - Loop Enter Detail Page Find Returnable Order
    [Arguments]    ${order_numbers}
    ${order}    Set Variable
    ${index}    Set Variable    0
    FOR    ${order}    IN    @{order_numbers}
        ${index}    Evaluate    ${index}+1
        Exit For Loop If    ${index}>10
        Set Suite Variable    ${Returnable_Order_Number}    ${order}
        Buyer Order - Search Order By Search Value    ${order}
        Buyer Order - Enter Order Detail Page By Index
        ${count}    Get Element Count    //div[text()="Return"]/parent::button
        Exit For Loop If    '${count}'=='1'
        Click Element    //p[text()="Orders"]/parent::a[contains(@href,"order-history")]
        Wait Until Element Is Visible    //h2/div[text()="Order History"]
        Buyer Order - Clear Search Value
    END
    ${now_url}    Get Location
    ${url_mp_buy_order_history}   Set Variable    ${URL_MIK}/mp/buyertools/order-history
    IF   '${now_url}'=='${url_mp_buy_order_history}'
        #Capture Page Screenshot    filename=EMBED
        Skip   There are no order can be return
    END


Buyer Order - Clear Search Value
    ${ele}    Set Variable    //*[@id="searchOrders"]/following-sibling::*[contains(@class,"icon-tabler-x")]
    ${count}    Get Element Count    ${ele}
    Run Keyword If    '${count}'=='1'    Click Element    ${ele}
    Wait Loading Hidden

Buyer Order - Enter Order Detail Page By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    //button[starts-with(@class,"chakra-button")]
    Click Element    (//button[starts-with(@class,"chakra-button")])[${index}]
    Wait Loading Hidden
    Wait Until Element Is Visible    //div[text()="Buy All Again"]/parent::button
    Wait Until Element Is Visible    //img[@alt="thumbnail"]

Buyer Order - Click Button - Buy All Agian
    Click Element    //div[text()="Buy All Again"]/parent::button
    Wait Until Element Is Visible    //p[text()="Success"]
    Wait Until Element Is Not Visible    //p[text()="Success"]

Buyer Order - Flow - Search Order And Buyer All Agian
    [Arguments]    ${search_value}
    Buyer Order - Search Order By Search Value    ${search_value}
    Buyer Order - Enter Order Detail Page By Index
    Buyer Order - Click Button - Buy All Agian

Buyer Order - Back Order List On Detail Page
    Click Element    //p[text()="Orders"]/parent::a
    Wait Until Element Is Not Visible    //p[text()="Orders"]/parent::a
    Wait Until Element Is Visible    //h2/div[text()="Order History"]

Buyer Order - Enter Cancel Items Page
    ${count}    Get Element Count    //div[text()="Cancel Items"]/parent::button
    Run Keyword If    '${count}'=='1'    Click Element    //div[text()="Cancel Items"]/parent::button
    Run Keyword If    '${count}'=='1'    Wait Until Element Is Not Visible    //h2[text()="Select suborders to cancel"]

Buyer Order - Cancel Items - Select Items On Cancel Items Page
    Click Element    //input[@type="checkboxa"]
    Wait Until Element Is Visible    //button[starts-with(@id,"menu-button")]

Buyer Order - Cancel Items - Select Cancellation Reason And Input Note
    Click Element    //button[starts-with(@id,"menu-button")]
    Wait Until Element Is Visible    //button[text()="Changed My Mind"]
    Click Element    //button[text()="Changed My Mind"]
    ${code}    Get Uuid Split
    Input Text    //input[@data-testid="Note"]    Note Info, ${code}.

Buyer Order - Cancel Items - Click Button - Next
    Scroll Element Into View    /span[text()="Next"]/parent::button
    Click Element    //span[text()="Next"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Cancel Review"]

Buyer Order - Cancel Items - Click Button - Cancel
    Scroll Element Into View    /span[text()="Cancel"]/parent::button
    Click Element    //span[text()="Cancel"]/parent::button
    Wait Until Element Is Visible    //div[text()="Buy All Again"]/parent::button
    Wait Until Element Is Visible    //img[@alt="thumbnail"]

Buyer Order - Cancel Items - Click Button - Submit
    Scroll Element Into View    /span[text()="Submit"]/parent::button
    Click Element    //span[text()="Submit"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Cancellation confirmation"]

Buyer Order - Cancel Items - Click Button - Back
    Scroll Element Into View    /span[text()="Back"]/parent::button
    Click Element    //span[text()="Back"]/parent::button
    Wait Until Element Is Visible    //span[text()="Next"]/parent::button

Buyer Order - Cancel Items - Stop Cancel Items
    Click Element    //*[@id="root"]//a
    Wait Until Element Is Visible    //div[text()="Buy All Again"]/parent::button
    Wait Until Element Is Visible    //img[@alt="thumbnail"]

Buyer Order - Back To Order Detail On Cancellation Confirmation Page
    Click Element   //span[text()="Order Details Page"]
    Wait Until Element Is Visible    //div[text()="Buy All Again"]/parent::button
    Wait Until Element Is Visible    //img[@alt="thumbnail"]
    Page Should Contain Element    //p[contains(text(),"Cancelled")]

Buyer Order - Click Button - Return
    Wait Until Element Is Visible    //div[text()="Return"]/parent::button
    Click Element    //div[text()="Return"]/parent::button
    Sleep    1
    Wait Until Element Is Visible    //p[text()="Create Return Order"]
    Wait Until Element Is Visible    //img[@alt="item"]

Buyer Order - Save Order Number On First Page
    [Arguments]    ${file_name}=orders_buyer
    ${base_ele}   Set Variable    //button[starts-with(@class,"chakra-button")]/div/div[1]//p[text()="Order Number"]
    Wait Until Element Is Visible     ${base_ele}
    ${count}   Get Element Count         ${base_ele}
    ${new_count}    Set Variable    ${count}+1
    ${orders_list}    Create List
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${new_count}
        ${order_number}    Get Text    (//button[starts-with(@class,"chakra-button")]/div/div[1]//p[text()="Order Number"]/following-sibling::p)[${index}]
        ${purchased_date}    Get Text    (//p[text()="Purchased Date"]/following-sibling::div)[${index}]
        ${total}     Get Text    (//p[text()="Order Total"]/following-sibling::p)[${index}]
        ${order_info}    Create Dictionary    orderNumber=${order_number}    purchasedDate=${purchased_date}    total=${total}
        Append To List    ${orders_list}    ${order_info}
    END
    Save File    ${file_name}    ${orders_list}    MP    ${ENV}

Buyer Order - Check Order Can Return Again
    [Arguments]    ${order_number}
    Buyer Order - Search Order By Search Value    ${order_number}
    Buyer Order - Enter Order Detail Page By Index
    ${count}    Get Element Count    //div[text()="Return"]/parent::button
    IF    ${count}==1
        ${returnable}    Set Variable    ${True}
    ELSE
        ${returnable}    Set Variable    ${False}
    END
    [Return]    ${returnable}