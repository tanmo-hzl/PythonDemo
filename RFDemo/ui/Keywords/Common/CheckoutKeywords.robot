*** Settings ***
Documentation    To use these keywords, you need to enter the delivery truck page first
Library        ../../Libraries/CommonLibrary.py
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Order_Number}

*** Keywords ***
Checkout - Click Button - Proceed To Checkout
    Sleep    2
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Element Is Visible    //div[text()="PROCEED TO CHECKOUT"]/parent::button        ${MAX_TIME_OUT}
    Wait Until Element Is Enabled    //div[text()="PROCEED TO CHECKOUT"]/parent::button
    Click Element    //div[text()="PROCEED TO CHECKOUT"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Getting your Order"]        ${MAX_TIME_OUT}
    Wait Until Element Is Visible    //div[text()="Next: Payment & Order Review"]/parent::button        ${MAX_TIME_OUT}

Checkout - Click Button - Payment & Order Review
    Sleep    2
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Element Is Enabled    //div[text()="Next: Payment & Order Review"]/parent::button
    Click Element    //div[text()="Next: Payment & Order Review"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Payment & Order Review"]        ${MAX_TIME_OUT}
    Wait Until Element Is Visible    //div[text()="PLACE ORDER"]/parent::button        ${MAX_TIME_OUT}

Checkout - Click Button - Place Order
    Sleep    2
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Element Is Enabled    //div[text()="PLACE ORDER"]/parent::button
    Click Element    //div[text()="PLACE ORDER"]/parent::button
    Sleep    5
    ${count}     Get Element Count    //*[contains(text(),"Unable to Process Payment")]
    IF    ${count}>0
        Click Element    //*[text()="Close"]
    ELSE
        Wait Until Element Is Visible    //h2[text()="Order Confirmation"]        ${MAX_TIME_OUT}
    END
#    ${Order_Number}    Get Text     //h2[text()="Thank you, your order has been placed!"]/following-sibling::div/p
#    ${Order_Number}    Evaluate    '${Order_Number}'[10:]
#    Set Suite Variable    ${Order_Number}    ${Order_Number}
#    Save File    buyer_order_number_return    ${Order_Number}    MP    ${ENV}

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
    Sleep    2

Checkout - Switch To PayPal Browser
    ${handles}   Get Window Handles
    Switch Window    ${handles[1]}

Checkout - Flow - Proceed To Payment To Place
    Checkout - Click Button - Proceed To Checkout
    Checkout - Click Button - Payment & Order Review
    Checkout - Click Button - Place Order



