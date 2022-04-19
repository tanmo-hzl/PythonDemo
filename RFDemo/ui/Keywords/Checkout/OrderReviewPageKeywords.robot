*** Settings ***
Resource    ../../TestData/Checkout/config.robot
Resource    BuyerCheckKeywords.robot

Library     ../../Libraries/Checkout/BuyerKeywords.py
Library     ../../TestData/Checkout/GuestGenerateAddress.py
Library     SeleniumLibrary
Library     OperatingSystem
Library     ../../Libraries/CustomSeleniumKeywords.py    run_on_failure=Capture Screenshot and embed it into the report    implicit_wait=0.2 seconds
Resource    ../../TestData/Checkout/config.robot



*** Variables ***
${Paypal Xpath}    //div[@type="submit"]//iframe[@title="PayPal"]
${Paypal Email}    //input[@id="email"]
${Paypal Pswd}     //input[@id="password"]
${Paypal Login}    //button[@id="btnLogin"]

*** Keywords ***
Payment Method Process
    [Arguments]   ${Payment}    ${IF PIS}    ${Paypal Amount}=${Paypay Amount}
    IF   '${Payment}' == 'Credit Card'
        FOR    ${key}   ${value}   IN ZIP   ${creditInfo.keys()}    ${creditInfo.values()}
            Input Text        //input[@id='${key}']    ${value}
        END
        IF   '${IF PIS}' == 'PIS Only'
            FOR    ${key}   ${value}   IN ZIP   ${billAddress.keys()}    ${billAddress.values()}
                ${Error Handle}    Run Keyword And Ignore Error    Input Text    //input[@id='${key}']     ${value}
                IF  '${Error Handle}[0]' == 'FAIL'
                    Select From List By Value    //select[@id='${key}']    ${value}
                END
            END
        END

    ELSE IF   '${Payment}' == 'Gift Card'
        FOR    ${key}   ${value}   IN ZIP   ${creditInfo.keys()}    ${creditInfo.values()}
            Input Text        //input[@id='${key}']    ${value}
        END
        IF   '${IF PIS}' == 'PIS Only'
            FOR    ${key}   ${value}   IN ZIP   ${billAddress.keys()}    ${billAddress.values()}
                Input Text    //input[@id='${key}']       ${value}
            END
        END
        Wait Until Element Is Enabled     //p[text()='Add A Gift Card']
#        Execute Javascript       document.getElementById('giftCardNumber')[1].scrollIntoView({behavior: 'smooth', block: 'center'})
        ${Gift Card Display}     Run Keyword And Ignore Error    Wait Until Element Is Enabled   //input[@id='giftCardNumber']     7
        IF   '${Gift Card Display}[0]' == 'FAIL'
            Click Element                 //p[text()='Add A Gift Card']
        END

        Input Text    //input[@id='giftCardNumber']    ${giftInfo['giftCard']}
        Input Text    //input[@id='pin']               ${giftInfo['pin']}
        Wait Until Element Is Visible     //div[text()='Apply']
        Click Element                     //div[text()='Apply']
        Run Keyword And Warn On Failure   Wait Until Element Is Visible    //div[text()='Remove']
        Sleep  2
    ELSE IF   '${Payment}' == 'Paypal'
        Order Review - Select Paypal Option And Click The Button
        ${handles}       Get Window Handles
        Switch Window    ${handles[1]}
        Maximize Browser Window
        ${Paypal Amount}    Paypal Interface Payment Process
        Wait Until Page Contains Element   //p[text()="Processing..."]
        Run Keyword And Warn On Failure    Wait Until Page Does Not Contain Element   //p[text()="Processing..."]
        Switch Window   ${handles[0]}
        Wait Until Page Does Not Contain Element     //*[@stroke="transparent"]

    END
    [Return]   ${Paypal Amount}




select payments method
    [Arguments]    ${payment}
    IF   "${payment}" == "Gift Card"
        Select Gift Card
    ELSE IF   "${payment}" == "Paypal"
        Select Paypal
    ELSE IF   "${payment}" == "Credit Card"
        Select Credit Card
    END


Select Gift Card
    Wait Until Element Is Enabled    //p[text()="Add A Gift Card"]
    Click Element    //p[text()="Add A Gift Card"]
    ${is_gift_Card}   Get Element Count   //p[text()="Gift Cards from Wallet"]
    IF   ${is_gift_Card} > 0
        Click Element   //p[text()="Apply"]
        Wait Until Element Is Visible     //div[text()="Undo"]
    ELSE
        Input Text    //input[@id="giftCardNumber"]   ${giftInfo}[giftCard]
        Input Text    //input[@id="pin"]   ${giftInfo}[pin]
        Click Element    //div[text()="Apply"]
    END
#    ${Checkout Panel Stats}  Get All Relevant Number Before Placing Order
#    Log    ck_order_stats:${Checkout Panel Stats}
    Click Place Order Button In Order Review Page

Select Credit Card
    Wait Until Element Is Visible    //h2[text()="Payment & Order Review"]
#    ${Checkout Panel Stats}  Get All Relevant Number Before Placing Order
#    Log    ck_order_stats:${Checkout Panel Stats}
    Click Place Order Button In Order Review Page

Click Place Order Button In Order Review Page
    Scroll Element Into View    //div[text()="PLACE ORDER"]/parent::button
    Wait Until Element Is Visible   //div[text()="PLACE ORDER"]/parent::button
    Click Button    //div[text()="PLACE ORDER"]/parent::button
    sleep    2
    Page Should Not Contain Element     //h3[text()="Unable to Process Payment"]

Select Paypal
    Click Paypal Radio
#    ${Checkout Panel Stats}  Get All Relevant Number Before Placing Order
#    Log    ck_order_stats:${Checkout Panel Stats}
    Paypal Payment

Click Paypal Radio
    Wait Until Page Contains Element     //p[text()="Paypal"]
    Wait Until Element Is Visible    //p[text()="Paypal"]
    Click Element    //p[text()="Paypal"]
    sleep    2

Click Undo Button for gift card
    Click Element    //div[text()="Undo"]

Check gift card hiden from order summary
    Page Should Not Contain     //p[text()="Gift Card"]

Click Change Payment
    Wait Until Page Contains Element     //p[text()="Change Payment"]
    Wait Until Element Is Visible      //p[text()="Change Payment"]
    Click Element    //p[text()="Change Payment"]


Get total amount from order summary
    Wait Until Page Contains Element     //*[text()="Total:"]/following-sibling::h4
    ${total_amout}    Get Text     //*[text()="Total:"]/following-sibling::h4
    [Return]    ${total_amout}

Click Apply button for gift card
    Click Element   //p[text()="Apply"]

Get gift card from order summary
    Wait Until Page Contains Element     //p[text()="Gift Card"]
    ${gift_card_amount}    Get Text     //p[text()="Gift Card"]/following-sibling::p
    [Return]    ${gift_card_amount}

Check gift card pay amount equal total amout
    [Arguments]     ${total_amout}
    ${gift_card_amount}    Get gift card from order summary
    Should Be Equal As Strings      ${gift_card_amount}    -${total_amout}

Check credit card still be selected
    Page should Contain Element    //p[contains(text(),"Visa")]/../../../../..//preceding-sibling::label[@data-checked]


Check gift card has been banned
    ${class}     Get Element Attribute     (//p[text()="Add A Gift Card"]/..//*[name()="svg"])[1]    class
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${class}    icon icon-tabler icon-tabler-ban


Click Google Pay Radio
    Wait Until Page Contains Element    //p[text()="Google Pay"]
    Wait Until Element Is Visible    //p[text()="Google Pay"]
    Click Element    //p[text()="Google Pay"]

Click Gift Card Check-box
    ${gift_card_checkbox_ele}    Set Variable     //p[text()="Add A Gift Card"]
    Wait Until Page Contains Element     ${gift_card_checkbox_ele}
    Wait Until Element Is Enabled    ${gift_card_checkbox_ele}
    Click Element    ${gift_card_checkbox_ele}

Add A Card In Order Review
    [Arguments]    ${gift_card}    ${pin}
    Wait Until Page Contains Element     //p[contains(text(),"Add A Gift Card")]
    Wait Until Element Is Visible     //p[contains(text(),"Add A Gift Card")]
    Click Element    (//p[contains(text(),"Add A Gift Card")]/..//*[name()="svg"])[3]
    Input Text    //input[@id="giftCardNumber"]     ${gift_card}
    Input Text    //input[@id="pin"]     ${pin}
    Wait Until Element Is Visible     //div[text()='Apply']
    Click Element                     //div[text()='Apply']
    sleep   1


Check Gift Card In Order Review2
    [Arguments]     ${E_gift_card}     ${E_balance}
    Wait Until Page Contains Element     //p[contains(text(),"ending in")]/../h4
    Wait Until Element Is Visible     //p[contains(text(),"ending in")]/../h4
    ${gift_card}    Get Text     //p[contains(text(),"ending in")]/../h4
    ${balance}    Get Text    //p[contains(text(),"ending in")]/../following-sibling::div
    ${E_gift_card}    Set Variable     ****${E_gift_card[-4:]}
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${gift_card}     ${E_gift_card}
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${balance}     ${E_balance}

Check non-existed gift card in order review
    [Arguments]     ${E_gift_card}
#    ${E_gift_card}    Set Variable     ****${E_gift_card[-4:]}
#    Page Should Not Contain     ****${E_gift_card[-4:]}
    Wait Until Page Does Not Contain Element     //p[text()="Gift Cards from Wallet"]
    


Check add valid gift card
    [Arguments]     ${gift_card}
    ${gift_card}    Set Variable      ${gift_card[-4:]}
    ${end_gift_card}     Get Text     //p[text()="ending in"]/following-sibling::h4
    Run Keyword And Warn On Failure      Should Be Equal As Strings    ${end_gift_card}     ****${gift_card}
    Run Keyword And Warn On Failure   Wait Until Element Is Visible    //div[text()='Remove']
#    ${class}    Get Element Attribute     //h4[contains(text(),"${gift_card}")]/../following-sibling::div//*[name()="svg"]
#    Should Be Equal As Strings     ${class}     icon icon-tabler icon-tabler-circle-check

Check add gift card with balance 0
    Page should Contain Element     //p[contains(text(),"Cannot add card with $0 balance")]

Check add invalid gift card
    Page should Contain Element     //p[contains(text(),"Invalid Card Number and PIN combination")]

check order review page
    [Arguments]    ${product_info}
    Wait Until Page Contains Element     //h2[contains(text(),"Payment & Order Review")]    ${Mid Waiting Time}
    Wait Until Element Is Visible    //h2[contains(text(),"Payment & Order Review")]    ${Mid Waiting Time}
    Wait Until Page Contains Element     //h3[contains(text(),"Order Review")]    ${Mid Waiting Time}
    check pickup multiple store tips     ${product_info}
    Check Payment Method
#    Check Shipping to Address    ${product_info}
#    check sku pickup location    OR   ${product_info}
#    ${skus_subtotal}    check sku info in GYO or OR page    ${product_info}
    ${skus_subtotal}    ${total_items}    Check Skus Info in GYO or OR Page    ${product_info}
#    ${total_items}    get items from GYO or OR page
    check order summary    ${total_items}   ${skus_subtotal}   OR


get total shipping fee from order review page
    ${total_STH_fees}    Set Variable    $0.00
    ${is_STH_fee}    Get Element Count    //div[contains(@class,"ShipMethodItem")]
    IF    ${is_STH_fee} > 0
        ${STH_fee_eles}   Get Webelements   //div[contains(@class,"ShipMethodItem")]//p
        @{STH_fees}    Create List
        FOR    ${STH_fee_ele}    IN    @{STH_fee_eles}
            ${STH_fee_text}    Get Text    ${STH_fee_ele}
            IF   "- $" in "${STH_fee_text}"
                ${STH_fee_list}    Split Parameter    ${STH_fee_text}   -
                ${STH_fee_text}    Set Variable     ${STH_fee_list[-1]}
                IF   "$0" in "${STH_fee_text}"
                    ${STH_fee}   Set Variable   0.00
                ELSE
                    ${STH_fee}    Evaluate    ${STH_fee_text[2:]}
                END
                ${STH_fee}    Evaluate    float(${STH_fee})
                Append To List     ${STH_fees}    ${STH_fee}
            END
        END
        ${total_STH_fees}    Evaluate    sum(${STH_fees})
        ${total_STH_fees}   Evaluate    "{:.2f}".format(${total_STH_fees})
        ${total_STH_fees}    Catenate    $${total_STH_fees}
    END
    [Return]    ${total_STH_fees}


Check Gift Card In Order Review
    Wait Until Page Contains Element     //p[contains(text(),"ending in")]/../h4
    Wait Until Element Is Visible     //p[contains(text(),"ending in")]/../h4
    ${gift_card}    Get Text     //p[contains(text(),"ending in")]/../h4
    ${balance}    Get Text    //p[contains(text(),"ending in")]/../following-sibling::div
    ${E_gift_card}    Set Variable     ${signin_giftInfo}[giftCard]
    ${E_gift_card}    Set Variable     ****${E_gift_card[-4:]}
#    ${E_balance}     Set Variable    ${WALLET_INFO[3]}
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${gift_card}     ${E_gift_card}
#    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${balance}     ${E_balance}


Check Payment Method
    Wait Until Element Is Visible     //p[contains(text(),"Visa")]
    ${credit_card}    Get Text     //p[contains(text(),"Visa")]
    ${expiration}    Get Text    //p[contains(text(),"Expiration")]/..
    ${expiration}    Split Parameter    ${expiration}    \n
    ${expiration}    Set Variable     ${expiration[1]}
    ${E_credit_card_num}    Set Variable     ${signin_CC_info}[credit_card_number]
    ${E_credit_card}    Set Variable     Visa ****${E_credit_card_num[-4:]}
    ${E_expiration}    Set Variable     ${signin_CC_info}[expiration]
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${credit_card}     ${E_credit_card}
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${expiration}     ${E_expiration}
    Wait Until Element Is Visible     //p[contains(text(),"ending in")]/..
    ${gift_card}    Get Text     //p[contains(text(),"ending in")]/../h4
    ${balance}    Get Text    //p[contains(text(),"ending in")]/../following-sibling::div
    ${E_gift_card}    Set Variable     ${signin_giftInfo}[giftCard]
    ${E_gift_card}    Set Variable     ****${E_gift_card[-4:]}
#    ${E_balance}     Set Variable    ${WALLET_INFO[3]}
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${gift_card}     ${E_gift_card}
#    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${balance}     ${E_balance}
    Run Keyword And Warn On Failure     Page Should Contain Element     //p[contains(text(),"Visa")]/../../../../../../label[@data-checked]

Set Delivery Address
    [Arguments]     ${delivery_address}
    ${address}    Set Variable     ${delivery_address[1][:-1]}
    ${address}    Split Parameter     ${address}    ,
    ${delivery_address}     Catenate     ${address[0]}, ${address[1]}, ${address[2]}, ${address[3]}
    [Return]     ${delivery_address}


Check Ship to Home Address
    ${shipping_to_address}     Get Text     //p[contains(text(),"shipping to:")]
    ${delivery_address}    Set Delivery Address    ${DELIVERY_ADDRESS}
    ${shipping_to_address}    Set Variable    ${shipping_to_address[12:]}
    Run Keyword And Warn On Failure    Should Contain    ${shipping_to_address}     ${delivery_address}


Check MKR Shipping to Address
    ${MKR_shipping_to_eles}    Get Webelements    //h2[contains(text(),"Shipped from")]/../../div[2]
    FOR    ${ele}    IN    @{MKR_shipping_to_eles}
        ${MKR_shipping_to_address}    Get Text    ${ele}
        ${delivery_address}    Set Delivery Address    ${DELIVERY_ADDRESS}
        ${shipping_to_address}    Set Variable    ${shipping_to_address[12:]}
        Run Keyword And Warn On Failure    Should Contain     ${MKR_shipping_to_address}    ${delivery_address}
    END


Check Shipping to Address
    [Arguments]     ${product_info}
    @{shipping_method_list}    Create List
    @{channel_list}    Create List
    FOR    ${sku_info}    IN    @{product_info}
        ${shipping_method}    Set Variable    ${sku_info}[shipping_method]
        ${channel}    Set Variable     ${sku_info}[channel]
        Append To List     ${shipping_method_list}    ${shipping_method}
        Append To List     ${channel_list}     ${channel}
    END
    IF  'STM' in ${shipping_method_list} or 'MKP' in ${channel_list}
        Check Ship to Home Address
    ELSE IF    'MKR' in ${channel_list}
        Check MKR Shipping to Address
    END


Order Review - Select Paypal Option and Click the Button
    Run Keyword And Ignore Error        Wait Until Element Is Enabled        //p[text()="Paypal"]
    Run Keyword And Ignore Error        Click Element                        //p[text()="Paypal"]
    Wait Until Page Contains Element    ${Paypal Xpath}    ${Long Waiting Time}
    Wait Until Element Is Enabled       ${Paypal Xpath}    ${Long Waiting Time}
    Sleep  2
    Click Element                       ${Paypal Xpath}

Paypal Interface Payment Process
    Wait Until Element Is Visible    ${Paypal Email}
    Click Element                    ${Paypal Email}
    Input Text                       ${Paypal Email}    ${paypalInfo.email}
    Click Element                    //button[@id="btnNext"]
    Wait Until Element Is Visible    ${Paypal Pswd}
    Execute Javascript               document.getElementById('password').click()
    Click Element                    ${Paypal Login}
    Set Focus To Element             ${Paypal Pswd}
    Execute Javascript               document.querySelector("#password").value='${paypalInfo.password}'
    Wait Until Element Is Visible    ${Paypal Login}
    Click Element                    ${Paypal Login}
    If Close Cookie Popup

    Wait Until Element Is Enabled      //button[@id="payment-submit-btn"]     ${Mid Waiting Time}
    ${Paypal Amount}   Get Text        //span[contains(@class,"Cart_cartAmount_4dnoL")]
    ${Paypal Amount}   Set Variable    ${Paypal Amount.split(" ")[0].replace("$", "")}
    Execute Javascript                 document.querySelector("#payment-submit-btn").click()
    [Return]    ${Paypal Amount}










