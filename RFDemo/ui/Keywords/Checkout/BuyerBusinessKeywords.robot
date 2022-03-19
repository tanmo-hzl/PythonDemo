*** Settings ***
Resource    ../../TestData/Checkout/config.robot
Resource    BuyerCheckKeywords.robot
Resource    PDPPageKeywords.robot
Resource    SlidePageKeywords.robot
Resource    GetYourOrderPageKeywords.robot
Resource    OrderReviewPageKeywords.robot
Resource    ShoppingCartPageKeywords.robot
Resource    CommonKeywords.robot
Library     ../../Libraries/Checkout/BuyerKeywords.py



*** Variables ***


*** Keywords ***

Buyer Checkout Work Flow
    [Documentation]    item_list[0]:channel:MIK,MKR,MKP; item_list[1]:product_type:listing,class; item_list[2]:sku_url; item_list[3]:sku_qty;
    ...                item_list[4]:purchase type; item_list[5]:Delivery_type:PIS,STM,SDD; item_list[6]:if PIS, Number of stores
    [Arguments]     @{product_list}
    Wait Until Element Is Visible    //p[text()="${account_info["first_name"]}"]
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
    login in shopping cart page    ${buyer['user']}    ${buyer['password']}
    Add To Cart Payment Process    ${product_list[-1]}
    log    ${ORDER_NO}

Buyer Checkout Work Flow Sign In Header
    [Arguments]     @{product_list}
    Change Store From Home Page    ${store1_info}[store_name]
    Select Products and Purchase Type    ${product_list}     ${True}
    Click View My Cart Button
    login in header     ${buyer['user']}    ${buyer['password']}
    Click Proceed To Checkout Button
    Add To Cart Payment Process    ${product_list[-1]}
    log    ${ORDER_NO}


Buyer Checkout Work Flow Paypal In Cart
    [Arguments]     @{product_list}
#    Change Store From Home Page    ${store1_info}[store_name]
    Select Products and Purchase Type    ${product_list}     ${True}
    Click View My Cart Button
    Paypal Payment In Cart
    Click Proceed To Checkout Button
    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    Save Verify Address
    Click Paypal Checkout Button
    Get order no from order confirmation



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
    ${Select Or Change}   Run Keyword And Warn On Failure    Wait Until Element Is Visible    (//p[text()="My Store:"])[1]
    IF  '${Select Or Change}[0]' == 'PASS'
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    CHANGE
        Change Store From Home Page    ${store1_info}[store_name]
    ELSE
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    SELECT
        select a store    ${store1_info}[store_name]
    END
    Select Products and Purchase Type   ${product_list}     ${True}     ${False}
    Payment process   ${product_list[-2]}   ${product_list[-1]}    ${PRODUCT_INFO_LIST[0]}
    log    ${ORDER_NO}


Login and change store
    login    ${buyer['user']}    ${buyer['password']}
    ${user_information}    Get Account Info
    Set Suite Variable     ${USER_INFO}    ${user_information}
    ${Select Or Change}   Run Keyword And Warn On Failure    Wait Until Element Is Visible    (//p[text()="My Store:"])[1]    ${Long Waiting Time}
    IF  '${Select Or Change}[0]' == 'PASS'
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    CHANGE
        Change Store From Home Page    ${store1_info}[store_name]
    ELSE
#        ${Store Address}    Select Or Change A Store In The Homepage   ${store1_info}[store_name]    SELECT
        select a store    ${store1_info}[store_name]
    END


Login and get account info
    login    ${buyer['user']}    ${buyer['password']}
    ${user_information}    Get Account Info
    Set Suite Variable     ${USER_INFO}    ${user_information}


If Close Advertising Pop-up
    [Arguments]    ${reload}
    sleep    1
    Wait Until Page Contains Element    //*[text()="Reviews"]
    IF   "${reload}"=="${True}"
        Run Keyword And Ignore Error     Wait Until Element Is Visible      //iframe[@id="attentive_creative"]
        Reload Page
        Wait Until Page Contains Element    //*[text()="Reviews"]     ${Long Waiting Time}
    END
    Sleep    1


Select Products and Purchase Type
    [Arguments]   ${product_list}     ${reload}=${False}     ${is_signin}=${True}
    sleep    1
    go to    ${Home URL}/${MIK[0]}
    If Close Advertising Pop-up     ${True}
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


Add To Cart Payment Process
    [Arguments]    ${payment_type}
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Page Contains Element     //h2[text()="Getting your Order"]
    Wait Until Element Is Visible    //h2[text()="Getting your Order"]
    Wait Until Element Is Visible    //h3[text()="Order Summary"]
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
#        Run Keyword And Warn On Failure    check shopping cart    ${PRODUCT_INFO_LIST}
        Click Proceed To Checkout Button
        Add To Cart Payment Process    ${payment_type}
    ELSE IF  "${purchase_type}" == "Buy Now"
        Buy Now Process
        Check Order Detail Page    ${ORDER_NO}   ${product_info}
    ELSE
        Book Class Only Process
        Check Order Detail Page    ${ORDER_NO}    ${product_info}
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






