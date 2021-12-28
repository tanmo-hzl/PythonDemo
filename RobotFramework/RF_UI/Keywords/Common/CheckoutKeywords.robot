*** Settings ***
Documentation    To use these keywords, you need to enter the delivery truck page first
Library        ../../Libraries/CommonLibrary.py
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Order_Number}

*** Keywords ***
Checkout - Click Button - Proceed To Checkout
    Wait Until Element Is Not Visible    //*[@id="stepcolors"]
    Sleep    1
    Wait Until Element Is Visible    //div[text()="PROCEED TO CHECKOUT"]/parent::button
    Wait Until Element Is Enabled    //div[text()="PROCEED TO CHECKOUT"]/parent::button
    Click Element    //div[text()="PROCEED TO CHECKOUT"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Getting your Order"]
    Wait Until Element Is Visible    //div[text()="Next: Payment & Order Review"]/parent::button

Checkout - Click Button - Payment & Order Review
    Wait Until Element Is Not Visible    //*[@id="stepcolors"]
    Sleep    1
    Wait Until Element Is Enabled    //div[text()="Next: Payment & Order Review"]/parent::button
    Click Element    //div[text()="Next: Payment & Order Review"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Payment & Order Review"]
    Wait Until Element Is Visible    //div[text()="PLACE ORDER"]/parent::button

Checkout - Click Button - Place Order
    Wait Until Element Is Not Visible    //*[@id="stepcolors"]
    Wait Until Element Is Enabled    //div[text()="PLACE ORDER"]/parent::button
    Click Element    //div[text()="PLACE ORDER"]/parent::button
    Sleep    1
    Wait Until Element Is Visible    //h2[text()="Order Confirmation"]
    ${Order_Number}    Get Text     //h2[text()="Thank you, your order has been placed!"]/following-sibling::div/p
    ${Order_Number}    Evaluate    '${Order_Number}'[10:]
    Set Suite Variable    ${Order_Number}    ${Order_Number}
    Save File    buyer_order_number_return    ${Order_Number}    MP

Checkout - Selected Payment Method - Paypal
    Wait Until Element Is Visible    //p[text()="Paypal"]/../../parent::label
    Sleep    1
    Click Element    //p[text()="Paypal"]/../../parent::label
    Wait Until Element Is Visible    //div[@type="submit"]
    Wait Until Element Is Visible    //div[@type="submit"]//iframe

Checkout - Click Button - PayPal
    Wait Until Element Is Visible    //div[@type="submit"]//iframe
    Sleep    1
    Click Element    //div[@type="submit"]//iframe
    Sleep    20

Checkout - Switch To PayPal Browser
    ${browser}    Get Browser Aliases
    Select Frame    //div[@type="submit"]//iframe
    Sleep    5
    Log Source
    Sleep    10
    Input Text    //*[@id="email"]    aaa@111.com
    Unselect Frame    //div[@type="submit"]//iframe
    Log    "AAAAAAA"

Checkout - Flow - Proceed To Payment To Place
    Checkout - Click Button - Proceed To Checkout
    Checkout - Click Button - Payment & Order Review
    Checkout - Click Button - Place Order

Checkout - Class Items - Input Guset Info
    ${count}   Get Element Count    //h2[text()="Classes"]
    FOR

