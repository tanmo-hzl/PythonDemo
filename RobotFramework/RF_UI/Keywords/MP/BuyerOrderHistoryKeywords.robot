*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot

*** Keywords ***
Buyer Order - Search Order By Order Number
    [Arguments]    ${search_value}
    Clear Element Value    //input[@id="searchOrders"]
    Input Text    //*[@id="searchOrders"]     ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
    Sleep    2
    Wait Until Element Is Visible    //*[text()="Order Number"]/following-sibling::p[text()="${search_value}"]

Buyer Order - Enter Order Detial Page By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    //button[starts-with(@class,"chakra-button")]
    Click Element    (//button[starts-with(@class,"chakra-button")])[${index}]
    Wait Until Element Is Visible    //div[text()="Buy All Again"]/parent::button
    Wait Until Element Is Visible    //img[@alt="thumbnail"]
    Sleep    1

Buyer Order - Click Button - Buy All Agian
    Click Element    //div[text()="Buy All Again"]/parent::button
    Wait Until Element Is Visible    //p[text()="Success"]
    Wait Until Element Is Not Visible    //p[text()="Success"]

Buyer Order - Flow - Search Order And Buyer All Agian
    [Arguments]    ${search_value}
    Buyer Order - Search Order By Order Number    ${search_value}
    Buyer Order - Enter Order Detial Page By Index
    Buyer Order - Click Button - Buy All Agian

Buyer Order - Back Order List On Detail Page
    Click Element    //p[text()="Orders"]/parent::a
    Wait Until Element Is Not Visible    //p[text()="Orders"]/parent::a
    Wait Until Element Is Visible    //h2[text()="Order History"]

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
    Wait Until Element Is Visible    //h2[text="Create Return Order"]
    Wait Until Element Is Visible    //img[@alt="item"]

Buyer Order - Return - Select All Item
    Click Element    //p[contains(text(),"Ship to home")]/../preceding-sibling::span
    Sleep    1

Buyer Order - Return - Select Item By Name
    [Arguments]    ${name}
    Click Element    //h4[text()="${name}"]/../preceding-sibling::label/span
    Sleep    1

Buyer Order - Return - Select Item By Index
    [Arguments]    ${index}
    Click Element    (//label[contains(@class,"MuiFormControlLabel-root")][${index}])/span
    Sleep    1

Buyer Order - Return - Update Item Quantity By Name
    [Arguments]    ${name}    ${quantity}
    ${element}    Set Variable    //h4[text()="${name}"]/../../../../following-sibling::div//input
    Clear Element Value  ${element}
    Input Text    ${element}

Buyer Order - Return - Update Item Quantity By Index
    [Arguments]    ${name}    ${quantity}
    ${element}    Set Variable    //h4[text()="${name}"]/../../../../following-sibling::div//input
    Clear Element Value  ${element}
    Input Text    ${element}

Buyer Order - Return - Click Button Back
    Scroll Element Into View    //div[text()="Back"]/parent::button
    Click Element    //div[text()="Back"]/parent::button
    Sleep    1

Buyer Order - Return - Click Button Next
    Scroll Element Into View    //div[text()="Next"]/parent::button
    Click Element    //div[text()="Back"]/parent::button
    Sleep    1
