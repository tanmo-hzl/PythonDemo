*** Settings ***
Resource    BuyerCheckKeywords.robot
Resource    PDPPageKeywords.robot
Resource    SlidePageKeywords.robot
Resource    GetYourOrderPageKeywords.robot
Resource    OrderReviewPageKeywords.robot
Resource    ShoppingCartPageKeywords.robot
Library     ../../Libraries/Checkout/BuyerKeywords.py



*** Variables ***
${Paypay Amount}            Intital Paypal Amount Setting
${Lose USPS Verify}         We can't verify this address. Want to save it anyway?


*** Keywords ***

Buyer Checkout Work Flow
    [Documentation]    item_list[0]:channel:MIK,MKR,MKP; item_list[1]:product_type:listing,class; item_list[2]:sku_url; item_list[3]:sku_qty;
    ...                item_list[4]:purchase type; item_list[5]:Delivery_type:PIS,STM,SDD; item_list[6]:if PIS, Number of stores
    [Arguments]     @{product_list}
    Wait Until Page Contains Element    //p[text()="${account_info["first_name"]}"]
    Select Products and Purchase Type     ${product_list}
    Payment process   ${product_list[-2]}   ${product_list[-1]}    ${PRODUCT_INFO_LIST[0]}
    log    ${ORDER_NO}



#Buyer Checkout Work Flow Change Store In Cart
#    [Arguments]     @{product_list}
#    Wait Until Element Is Visible    //p[text()="${user_name}"]
#    Select Products And Check   ${product_list}
#    click view my cart
#    change store from cart    ${PRODUCT_INFO_LIST[1]}[sku]
#    Add To Cart Payment Process   ${product_list[-1]}



Buyer Checkout Work Flow Sign In Shopping Cart
    [Arguments]     @{product_list}
#    ${Select Or Change}   Run Keyword And Warn On Failure    Wait Until Element Is Visible    (//p[text()="My Store:"])[1]
#    IF  '${Select Or Change}[0]' == 'PASS'
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    CHANGE
#    ELSE
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    SELECT
#    END
    Select Products and Purchase Type    ${product_list}     ${True}
    Click View My Cart Button
    Click Proceed To Checkout Button
    login in shopping cart page    ${buyer4['user']}    ${buyer4['password']}
    Add To Cart Payment Process    ${product_list[-1]}
    log    ${ORDER_NO}

Buyer Checkout Work Flow Sign In Header
    [Arguments]     @{product_list}
    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    Select Products and Purchase Type    ${product_list}     ${True}
    Click View My Cart Button
    login in header     ${buyer4['user']}    ${buyer4['password']}
    Click Proceed To Checkout Button
    Add To Cart Payment Process    ${product_list[-1]}
    log    ${ORDER_NO}


Buyer Checkout Work Flow Paypal In Cart
    [Arguments]     @{product_list}
#    Change Store From Home Page    ${store1_info}[store_name]
    Select Products and Purchase Type    ${product_list}     ${True}
    Click View My Cart Button
    Paypal Payment In Cart
#    Click Proceed To Checkout Button
    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    Click Next: Payment & Order Review Button
    Save Verify Address
    Run Keyword And Warn On Failure      Check Paypal Be Selected in Order Review
    Click Paypal Checkout Button
    Get order no from order confirmation
#    Update Default Address



Guest Checkout Work Flow Paypal In Cart
    [Arguments]     @{product_list}
#    Change Store From Home Page    ${store1_info}[store_name]
    Select Products and Purchase Type    ${product_list}     ${True}
    Click View My Cart Button
    Paypal Payment In Cart
#    Click Proceed To Checkout Button
    Input Phone Number    ${account_info}[phone]
    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    Click Next: Payment & Order Review Button
    Save Verify Address
    Run Keyword And Warn On Failure      Check Paypal Be Selected in Order Review
    Click Paypal Checkout Button
    Get order no from order confirmation


Book Class With Same Guest Info
    [Arguments]     @{product_list}
    Select Products and Select Purchase Type   ${product_list}
#    Click Book Class Only Button
    Buy Now Class - Input Same Guest Info     ${account_info}
    Book Class Only Process
    log    ${ORDER_NO}



Click Paypal Checkout Button
    ${paypal_checkout_ele}    Set Variable     //p[text()="Checkout"]/..
    Wait Until Page Contains Element     ${paypal_checkout_ele}
    Wait Until Element Is Visible     ${paypal_checkout_ele}
    Click Element     ${paypal_checkout_ele}


Save Verify Address
    Wait Until Page Contains Element     //p[text()="Verify Address"]
    Wait Until Element Is Visible    //p[text()="Verify Address"]
    CLick Element    //div[text()="SAVE"]/..



Buyer Buy Now Work Flow Sign In Slide Page
    [Arguments]     @{product_list}
#    ${Select Or Change}   Run Keyword And Warn On Failure    Wait Until Element Is Visible    (//p[text()="My Store:"])[1]
#    IF  '${Select Or Change}[0]' == 'PASS'
##        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    CHANGE
#        Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
#    ELSE
##        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    SELECT
#        select a store    ${store1_info}[store_name]
#    END
    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    Select Products and Select Purchase Type   ${product_list}
    login in slide page    ${buyer10['user']}    ${buyer10['password']}
    Payment process   ${product_list[-2]}   ${product_list[-1]}    ${PRODUCT_INFO_LIST[0]}
    log    ${ORDER_NO}


Book Class Only Work Flow Sign In Slide Page
    [Arguments]     @{product_list}
    Change Store From Home Page    ${store1_info}[store_name]
    Select Products and Purchase Type   ${product_list}     ${True}     ${False}
    login in slide page    ${buyer['user']}    ${buyer['password']}
    Book Class Only Process
    log    ${ORDER_NO}


Guest Use PO.Box Address To Place Order
    [Arguments]     ${consignee}    @{product_list}
#    Change Store From Home Page    ${store1_info}[store_name]
    Select Products and Purchase Type   ${product_list}     ${True}     ${False}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Continue as Guest Button
    ${IF PIS}    Input Guest Info In Get Your Order     ${pickupInfo}     ${consignee}
    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    Wait Until Element Is Visible     //div[text()='Next: Payment & Order Review']     ${Mid Waiting Time}
    ${USPS Verify}   ${USPS Trigger}   USPS Address Handling      Next: Payment & Order Review    ${Lose USPS Verify}   Use USPS Suggestion
    IF  '${USPS Verify}[0]' == 'PASS'
        Click Element    //div[text()="Save"]
    ELSE IF  '${USPS Trigger}[0]' == 'PASS'
        ${Updated ZipCode}    Use USPS Suggested Address    ${IF PIS}
    END
    Wait Until Element Is Visible     //h2[text()='Payment & Order Review']    ${Long Waiting Time}
    Wait Until Element Is Visible     //h3[text()="Payment Method"]            ${Long Waiting Time}
    Payment Method Process    ${product_list[-1]}    ${IF PIS}    ${Paypay Amount}
    IF  '${product_list[-1]}' != 'Paypal'
        Wait Until Element Is Enabled    //div[text()='PLACE ORDER']
        Sleep  2
        Click Element                    //div[text()='PLACE ORDER']
    ELSE
        Should Be Equal As Strings    ${Paypal Needed}    ${Place Order Total}
    END
    Sleep   4
    Page Should Not Contain Element            //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Not Visible          //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Visible              //h2[text()='Order Confirmation']       ${Long Waiting Time}
    ${Rough Order Number}    Get WebElements   //p[text()='ORDER NO. ']
    Should Not Be Empty      ${Rough Order Number[0].text}
    ${Extracted Number}      Number Extracted     ${Rough Order Number[0].text}
    Log    ck_order_number:${Extracted Number}


item that it can not ship to PO box address
    [Arguments]     ${consignee}    @{product_list}
#    @{product_list}    Create List     MIK|listing|${P.O.Box item[0]}|1|ATC|STM|${EMPTY}   Add To Cart    ${EMPTY}
    Select Products and Purchase Type   ${product_list}     ${True}     ${False}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Continue as Guest Button
    ${IF PIS}    Input Guest Info In Get Your Order     ${pickupInfo}     ${consignee}
    Click Next: Payment & Order Review Button
    Check error message for PO Box Address


Login and change store
    [Arguments]     ${user}     ${password}
#    login    ${buyer['user']}    ${buyer['password']}
    login     ${user}     ${password}
    ${user_information}    Get Account Info
    Set Suite Variable     ${USER_INFO}    ${user_information}
    ${Select Or Change}   Run Keyword And Warn On Failure    Wait Until Element Is Visible    (//p[text()="My Store:"])[1]    ${Long Waiting Time}
    IF  '${Select Or Change}[0]' == 'PASS'
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    CHANGE
        Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    ELSE
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    SELECT
        select a store    ${store1_info}[store_name]
    END


Login and get account info
    [Arguments]     ${user}     ${password}
#    login    ${buyer['user']}    ${buyer['password']}
    login     ${user}     ${password}
    ${user_information}    Get Account Info
    Set Suite Variable     ${USER_INFO}    ${user_information}



Select Products and Purchase Type
    [Arguments]   ${product_list}     ${reload}=${False}     ${is_signin}=${True}
    sleep    1
    @{product_info_list}   Create List
    ${N_product_list}   get_list_step_value    ${product_list}   0   -2
    FOR   ${product}   IN    @{N_product_list}
        @{item_list}   split_parameter   ${product}    |
        go to    ${Home URL}/${item_list[2]}
        ${ENV}    Lower Parameter    ${ENV}
        IF    "${ENV}" != "qa" and "${item_list[0]}" == "MKR"
            Continue For Loop
        END
        IF    "${item_list[1]}" == "listing"
            Select Item Properties In PDP    ${item_list[0]}
            IF   "${item_list[0]}" == "MIK"
                select shipping method   ${item_list[5]}
            END
        END
        IF   ${item_list[3]} > 1
            Add Product Quantity From PDP   ${item_list[1]}   ${item_list[3]}
        END
        IF   "${item_list[6]}" > "0"
            Select Other Store From PDP    ${item_list[6]}
            Run Keyword And Warn On Failure    Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
#            ${product_info}   Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
#            Set To Dictionary     ${product_info}     pis_location=${pis_store_info_list[0]}
#            Set To Dictionary     ${product_info}     pis_location=${store2_info}
            Append To List    ${product_info_list}    ${ONE_PRODUCT_INFO}
            check view my cart popup    ${item_list[4]}   ${ONE_PRODUCT_INFO}
        ELSE IF    "${item_list[6]}" == "0" or "${item_list[6]}" == "${EMPTY}"
            Run Keyword And Warn On Failure     Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
#            ${product_info}   Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
            Append To List    ${product_info_list}    ${ONE_PRODUCT_INFO}
            select purchase type if sign in    ${item_list[1]}   ${item_list[4]}   ${item_list[0]}    ${item_list[5]}    ${ONE_PRODUCT_INFO}     ${is_signin}
#            check view my cart popup    ${item_list[4]}   ${product_info}
        END
    END
    Set Test Variable    ${PRODUCT_INFO_LIST}   ${product_info_list}
    log    ${PRODUCT_INFO_LIST}


Select Products and Select Purchase Type
    [Arguments]   ${product_list}
    sleep    1
    @{product_info_list}   Create List
    ${N_product_list}   get_list_step_value    ${product_list}   0   -2
    FOR   ${product}   IN    @{N_product_list}
        @{item_list}   split_parameter   ${product}    |
        go to    ${Home URL}/${item_list[2]}
        IF    "${item_list[1]}" == "listing"
            Select Item Properties In PDP    ${item_list[0]}
            IF   "${item_list[0]}" == "MIK"
                select shipping method   ${item_list[5]}
            END
        END
        IF   ${item_list[3]} > 1
            Add Product Quantity From PDP   ${item_list[1]}   ${item_list[3]}
        END
        IF   "${item_list[6]}" > "0"
            Select Other Store From PDP    ${item_list[6]}
            Run Keyword And Warn On Failure    Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
            Append To List    ${product_info_list}    ${ONE_PRODUCT_INFO}
            check view my cart popup    ${item_list[4]}   ${ONE_PRODUCT_INFO}
        ELSE IF    "${item_list[6]}" == "0" or "${item_list[6]}" == "${EMPTY}"
            Run Keyword And Warn On Failure     Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
            Append To List    ${product_info_list}    ${ONE_PRODUCT_INFO}
            select purchase type    ${item_list[1]}   ${item_list[4]}   ${item_list[0]}    ${ONE_PRODUCT_INFO}
        END
    END
    Set Test Variable    ${PRODUCT_INFO_LIST}   ${product_info_list}
    log    ${PRODUCT_INFO_LIST}




Add To Cart Payment Process
    [Arguments]    ${payment_type}
#    ${getyourorder_ele}    Set Variable     (//*[text()="Getting your Order"])[2]
    ${order_summary_ele}     Set Variable     //h3[text()="Order Summary"]
    ${next_payment_order_review}     Set Variable      //div[text()="Next: Payment & Order Review"]/parent::button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
#    Wait Until Page Contains Element     ${getyourorder_ele}
#    Wait Until Element Is Visible    ${getyourorder_ele}
    Wait Until Page Contains Element     ${order_summary_ele}
    Wait Until Element Is Visible     ${order_summary_ele}
    Wait Until Page Contains Element     ${next_payment_order_review}
    Wait Until Element Is Visible     ${next_payment_order_review}
    Run Keyword And Warn On Failure    check getting your order page    ${PRODUCT_INFO_LIST}
    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    Click Next: Payment & Order Review Button
    Run Keyword And Warn On Failure    check order review page    ${PRODUCT_INFO_LIST}
    select payments method    ${payment_type}
    check the order No. with add to cart

Paypal in Cart Process
    Paypal Payment In Cart


Payment process
    [Arguments]   ${purchase_type}   ${payment_type}    ${product_info}
    IF  "${purchase_type}"=="Add To Cart"
        Click View My Cart Button
        Sleep    1
#        Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]     ${Long Waiting Time}
#        sleep    1
#        Reload Page
#        Run Keyword And Warn On Failure    check shopping cart    ${PRODUCT_INFO_LIST}
        Click Proceed To Checkout Button
        Add To Cart Payment Process    ${payment_type}
    ELSE IF  "${purchase_type}" == "Buy Now"
        Buy Now Process
        Run Keyword And Warn On Failure     Check Order Detail Page    ${ORDER_NO}   ${product_info}
    ELSE
        Book Class Only Process
        Run Keyword And Warn On Failure     Check Order Detail Page    ${ORDER_NO}    ${product_info}
    END

select a store
    [Arguments]    ${store_name}
    Wait Until Element Is Visible    //p[text()="Select a Store"]/../../parent::button
    Wait Until Element Is Enabled    //p[text()="Select a Store"]/../../parent::button
    Click Element     //p[text()="Select a Store"]/../../parent::button
    Wait Until Element Is Visible    //p[text()='SELECT OTHER STORE']
    Input Text    //input[contains(@class,"chakra-input")]     ${store_name}
    Wait Until Element Is Visible    //select
    Select From List By Value     //select    200
    Wait Until Element Is Visible    //p[text()="${store_name}"]
#    ${store_name}    Get Text    //p[text()="MY STORE"]/../div/div[1]
#    ${store_address}    Get Text    //p[text()="MY STORE"]/../div/div[2]
    Wait Until Element Is Not Visible    //p[text()='Select a Store']
    Wait Until Page Contains Element    //button[@aria-label="Close"]
    Wait Until Element Is Visible    //button[@aria-label="Close"]
    Click Element     //button[@aria-label="Close"]
    Wait Until Element Is Visible    //p[text()="${store_name}"]
    sleep   1
#    [Return]    ${store_address}






