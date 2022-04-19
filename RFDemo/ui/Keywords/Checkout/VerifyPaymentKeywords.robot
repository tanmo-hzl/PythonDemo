*** Settings ***

Resource    BuyerCheckKeywords.robot
Resource    PDPPageKeywords.robot
Resource    SlidePageKeywords.robot
Resource    GetYourOrderPageKeywords.robot
Resource    OrderReviewPageKeywords.robot
Resource    ShoppingCartPageKeywords.robot
Resource    PopupMessageKeywords.robot
Resource    GuestTrackOrderKeywords.robot
Library     ../../Libraries/Checkout/BuyerKeywords.py



*** Variables ***
${sleep_time}   0.5
${payment_slect}   /ancestor::span/preceding-sibling::span
${Credit_card}     //p[text()="Credit/Debit Card"]
${paypal}         //p[text()="Paypal"]
${google_pay}     //p[text()="Google Pay"]
${monthly}        //p[text()="Buy with monthly payments"]
${gift_card}      //p[text()="Add A Gift Card"]/preceding-sibling::div

*** Keywords ***
verify select payment only
    [Arguments]     ${method}=${Credit_card}
    ${payment_list}     create list     ${Credit_card}   ${paypal}    ${google_pay}   #${monthly}
    ${value}     Create List
    FOR  ${var}  IN     @{payment_list}
        Wait Until Element Is Visible   ${var}${payment_slect}
        ${att}  get element attribute   ${var}${payment_slect}      data-checked
        Append To List   ${value}   ${att}
    END
    Log  ${value}
    ${payment_number}   Count Values In List   ${value}      ${EMPTY}
    Should Be Equal   ${payment_number}   ${1}
    ${index}    get index from list     ${payment_list}    ${method}
    Should Be Equal     ${value[${index}]}      ${EMPTY}
    Open Add A Gift Card
#    ${gift_card_num}    get element count   ${gift_card}/*
    IF  ${index}==0
#        Should Be Equal As Numbers      ${gift_card_num}    1
        Wait Until Page Contains Elements Ignore Ad  //div[text()="Apply"]/parent::button[name(@disabled)!="disabled"]
    ELSE
#        Should Be Equal As Numbers      ${gift_card_num}    0
        Wait Until Page Contains Elements Ignore Ad   //div[text()="Apply"]/parent::button[name(@disabled)="disabled"]
    END

verify payment only
    [Arguments]  ${method}=${paypal}
    wait until element is visible   ${method}
    Click Element   ${method}
    verify select payment only     ${method}

verify gift card is checkbox
    verify payment only     ${Credit_card}
    ${gift_checkbox}    get element count    ${gift_card}/div
    IF  ${gift_checkbox}==0
        wait until element is visible   ${gift_card}/*
#        ${gift_card_checkbox}   get element attribute     ${gift_card}/*    viewBox
#        Should Be Equal As Strings   ${gift_card_checkbox}      0 0 24 24
        Click Element   ${gift_card}/*
        Sleep  ${sleep_time}
        wait until element is visible   ${gift_card}/div
        ${gift_checkbox1}    get element count    ${gift_card}/div
        Should Be Equal As Numbers  ${gift_checkbox1}   1
    ELSE IF   ${gift_checkbox}==1
        wait until element is visible   ${gift_card}/*
#        ${gift_card_checkbox}   get element attribute     ${gift_card}/div/*    viewBox
#        Should Be Equal As Strings   ${gift_card_checkbox}      0 0 24 24
        Click Element   ${gift_card}/*
        Sleep  ${sleep_time}
        ${gift_checkbox1}    get element count    ${gift_card}/div
        Should Be Equal As Numbers  ${gift_checkbox1}   0
    ELSE
        Should Be Equal As Numbers  ${gift_checkbox1}   1
    END

PBF-Guest-Sign in-checkout
    [Arguments]    @{product_list}    ${payment_order}=true   ${Verfiy Point}=checkout   ${Expect_Value}=0
    Select Products and Purchase Type-v2    ${product_list}
    Payment process-v2    ${product_list[-2]}    ${product_list[-1]}     ${PRODUCT_INFO_LIST}     ${Verfiy Point}  ${payment_order}
    IF  "${Verfiy Point}"=="checkout"
        Should Be Equal As Strings  ${checkout_order_sunnary_data["Paper Bag Fees"]}      ${Expect_Value}
        Should Be Equal As Strings  ${payment_order_sunnary_data["Paper Bag Fees"]}       ${Expect_Value}
    ELSE IF  "${Verfiy Point}"=="cart"
        Should Be Equal As Strings  ${cart_order_sunnary_data["Paper Bag Fees"]}      ${Expect_Value}
    END



Select Products and Purchase Type-v2
    [Arguments]   ${product_list}     ${reload}=${False}     ${is_signin}=${True}
    sleep    1
    @{product_info_list}   Create List
    ${N_product_list}   get_list_step_value    ${product_list}   0   -2
    ${product_index}  Set Variable  ${0}
    ${select_store_purchase_type}   Create List    SDD    SDDH   PIS
    FOR   ${product}   IN    @{N_product_list}
        ${product_index}  Evaluate    ${product_index}+${1}
        @{item_list}   split_parameter   ${product}    |
        go to    ${Home URL}/${item_list[2]}
        ${Pdp 404}  Run Keyword And Ignore Error  Page 404 Message
        IF  "${Pdp 404[0]}"=="PASS"
            Reload Page
        END
        IF    "${item_list[1]}" == "listing"
            Select Item Properties In PDP    ${item_list[0]}
            IF  "${item_list[5]}" in ["SDD","SDDH"] and "${item_list[6]}"!="${EMPTY}" or "${item_list[5]}"=="PIS" and "${product_list[-2]}"=="Buy Now" and "${item_list[6]}"!="${EMPTY}"
                ${sdd_store}  split_parameter    ${item_list[6]}    ,
                ${shipping_sdd_info}   Pdp Loop select store    ${sdd_store}
            END

            IF   "${item_list[0]}" == "MIK"
                select shipping method   ${item_list[5]}
            END
        END
        IF   ${item_list[3]} > 1
            Add Product Quantity From PDP   ${item_list[1]}   ${item_list[3]}
        END
        IF   "${item_list[6]}" != "0" and "${item_list[5]}"=="PIS" and "${product_list[-2]}"!="Buy Now"
            Pick up Select Other Store From PDP      ${item_list[6]}
            Run Keyword And Warn On Failure    Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
#            ${product_info}   Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
#            Set To Dictionary     ${product_info}     pis_location=${pis_store_info_list[0]}
#            Set To Dictionary     ${product_info}     pis_location=${store2_info}

            Append To List    ${product_info_list}    ${ONE_PRODUCT_INFO}
            check view my cart popup    ${item_list[4]}   ${ONE_PRODUCT_INFO}
        ELSE IF    "${item_list[6]}" == "0" or "${item_list[6]}" == "${EMPTY}" or "${item_list[5]}" in ${select_store_purchase_type}
            Run Keyword And Warn On Failure     Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
#            ${product_info}   Get Skus Info From PDP   ${item_list[0]}   ${item_list[1]}   ${item_list[2]}    ${item_list[5]}    ${item_list[6]}
            Append To List    ${product_info_list}    ${ONE_PRODUCT_INFO}
            select purchase type if sign in    ${item_list[1]}   ${item_list[4]}   ${item_list[0]}    ${item_list[5]}    ${ONE_PRODUCT_INFO}     ${is_signin}
#            check view my cart popup    ${item_list[4]}   ${product_info}
        END
    END
    Set Test Variable    ${PRODUCT_INFO_LIST}   ${product_info_list}
    log    ${PRODUCT_INFO_LIST}

Payment process-v2
    [Arguments]   ${purchase_type}   ${payment_type}    ${product_info}      ${Verfiy Point}       ${payment-order}=true
    IF  "${purchase_type}"=="Add To Cart"
        Click View My Cart Button
#        Run Keyword And Warn On Failure    check shopping cart    ${PRODUCT_INFO_LIST}
        ${error_headle}   Run Keyword And Ignore Error   Wait Until Page Contains Elements Ignore Ad   //p[text()="Error"]
        IF  "${error_headle[0]}"=="PASS"
            Wait Until Page Contains Elements Ignore Ad    //div[text()="CLOSE"]
            Click Element                                  //div[text()="CLOSE"]
        END
        ${cart_reload}  Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad    //h3[text()="Order Summary"]
        IF  '${cart_reload[0]}'=='FAIL'
            Reload Page
            Wait Until Page Contains Elements Ignore Ad    //h3[text()="Order Summary"]
        END
        Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
        Wait Until Page Contains Elements Ignore Ad    //p[text()="Delivering to "]
        ${web_delivering_to_text}   Get Text           //p[text()="Delivering to "]
        IF   "${web_delivering_to_text[14:]}"!="${delivering_zipCode_shipping}" and "${empty}"!="${delivering_zipCode_shipping}"
            Wait Until Page Contains Elements Ignore Ad   //p[text()="Change"]
            Click Element                                 //p[text()="Change"]
            Wait Until Page Contains Elements Ignore Ad   //input[@id="zipCode"]
            Click Element                                 //input[@id="zipCode"]
            Press Keys       //input[@id="zipCode"]       ${delivering_zipCode_shipping}
            Click Element                                //div[text()="Apply"]
            Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
        END
        ${cart_order_sunnary_data}    get order summary data
        Set Test Variable  ${cart_order_sunnary_data}   ${cart_order_sunnary_data}

        Click Proceed To Checkout Button
        Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
        ${Is login}   Run Keyword And Ignore Error   Wait Until Page Contains Elements Ignore Ad   //h3[text()="Sign in to your account."]
        IF  "${Is login[0]}"=="PASS"
            IF  "${login_slide_user['email']}" != "Guest"
                login in slide page    ${login_slide_user["email"]}    ${login_slide_user["password"]}
            ELSE
                Wait Until Page Contains Elements Ignore Ad  //div[text()="CONTINUE AS GUEST"]/parent::button
                Click Element                                //div[text()="CONTINUE AS GUEST"]/parent::button
            END
        END

        Add To Cart Payment Process-v2    ${payment_type}      ${payment-order}
    ELSE IF  "${purchase_type}" == "Buy Now"
        Buy Now Process
        Run Keyword And Warn On Failure     Check Order Detail Page    ${ORDER_NO}   ${product_info}
    ELSE
        Book Class Only Process
        Run Keyword And Warn On Failure     Check Order Detail Page    ${ORDER_NO}    ${product_info}
    END

Add To Cart Payment Process-v2
    [Arguments]    ${payment_type}    ${payment-order}=true
#    ${getyourorder_ele}    Set Variable     (//*[text()="Getting your Order"])[2]
    ${order_summary_ele}     Set Variable     //h3[text()="Order Summary"]
    ${next_payment_order_review}     Set Variable      //div[text()="Next: Payment & Order Review"]/parent::button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    ${pick shipping information}    Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad   //h3[text()="Pick Up Person Information"]   10
    IF   "${pick shipping information[0]}"=="PASS"
        FOR    ${key}   ${value}   IN ZIP   ${pickupInfo.keys()}    ${pickupInfo.values()}
            Click Element  //input[@id='${key}']
            Repeat Keyword  20   Press Keys    //input[@id='${key}']   \ue003
            Press Keys     //input[@id='${key}']       ${value}
        END
    ELSE
        ${shipping_info_first_name}    Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad   //input[@id="firstName"]
        IF  "${shipping_info_first_name[0]}"=="PASS"
            FOR    ${key}   ${value}   IN ZIP   ${guestInfo.keys()}    ${guestInfo.values()}
                IF  "${key}"=="state"
                    Select From List By Value    //select[@id='${key}']    ${value}
                ELSE
                    Click Element  //input[@id='${key}']
                    Press Keys     //input[@id='${key}']       ${value}
                END
            END
        END
    END
#    Wait Until Page Contains Element     ${getyourorder_ele}
#    Wait Until Element Is Visible    ${getyourorder_ele}
    Wait Until Page Contains Element     ${order_summary_ele}
    Wait Until Element Is Visible     ${order_summary_ele}
    Wait Until Page Contains Element     ${next_payment_order_review}
    Wait Until Element Is Visible     ${next_payment_order_review}
    Run Keyword And Warn On Failure    check getting your order page    ${PRODUCT_INFO_LIST}
    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    ${checkout_order_sunnary_data}    get order summary data
    Set Test Variable  ${checkout_order_sunnary_data}   ${checkout_order_sunnary_data}
    Click Next: Payment & Order Review Button
    ${Usps_message}  Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad   //div[text()='Use USPS Suggestion']
    IF  "${Usps_message[0]}"=="PASS"
        Click Element  //div[text()='Use USPS Suggestion']
        Click Next: Payment & Order Review Button
    END
    Run Keyword And Ignore Error  Shipping Save Verify Address
#    IF  "${verify address message[0]}"=="PASS"
#        Click Next: Payment & Order Review Button
#    END
    Run Keyword And Ignore Error  Close popup Cannot Transaction
    Run Keyword And Warn On Failure    check order review page    ${PRODUCT_INFO_LIST}
    select payments method-v2    ${payment_type}
    IF  "${payment-order}"=="true"
        Click Place Order Button In Order Review Page
        ${place_order_popup_message}  Run Keyword And Ignore Error  Close popup Cannot Transaction
        IF  "${place_order_popup_message[0]}"=="PASS"
            Click Place Order Button In Order Review Page
        END
        IF  "${login_slide_user['email']}" != "Guest"
            check the order No. with add to cart
        ELSE
            Get order no from order confirmation
            Get Guest Track My Order info   ${ORDER_NO}    ${guestInfo["lastName"]}   ${guestInfo["email"]}
        END
    END


select payments method-v2
    [Arguments]    ${payment}
    IF   "${payment}" == "Gift Card"
        Select Gift Card
    ELSE IF   "${payment}" == "Paypal"
        Select Paypal
    ELSE IF   "${payment}" == "Credit Card"
        Wait Until Element Is Visible    //h2[text()="Payment & Order Review"]
        ${Credit_headle}  Run Keyword And Ignore Error   Wait Until Page Contains Elements Ignore Ad   //input[@id="cardHolderName"]
        IF  "${Credit_headle[0]}"=="PASS"

            Wait Until Page Contains Elements Ignore Ad   //input[@id="cardHolderName"]
            Click Element                                 //input[@id="cardHolderName"]
            Press Keys    //input[@id="cardHolderName"]     ${creditInfo["cardHolderName"]}
            Wait Until Page Contains Elements Ignore Ad   //input[@id="cardNumber"]
            Click Element                                 //input[@id="cardNumber"]
            Press Keys    //input[@id="cardNumber"]     ${creditInfo["cardNumber"]}
            Wait Until Page Contains Elements Ignore Ad   //input[@id="expirationDate"]
            Click Element                                 //input[@id="expirationDate"]
            Press Keys    //input[@id="expirationDate"]     ${creditInfo["expirationDate"]}
            Wait Until Page Contains Elements Ignore Ad   //input[@id="cvv"]
            Click Element                                 //input[@id="cvv"]
            Press Keys    //input[@id="cvv"]              ${creditInfo["cvv"]}
        END
        ${shipping_address_input}  Run Keyword And Ignore Error   Wait Until Page Contains Elements Ignore Ad   //h3[text()="Billing Address"]/..//input[@id="firstName"]
        IF  "${shipping_address_input[0]}"=="PASS"
                FOR    ${key}   ${value}   IN ZIP   ${guest_billing_address.keys()}    ${guest_billing_address.values()}
                    IF  "${key}"=="state"
                        Select From List By Value    //select[@id='${key}']    ${value}
                    ELSE
                        Click Element  //input[@id='${key}']
                        Press Keys     //input[@id='${key}']       ${value}
                    END
                END
        END
        ${payment_order_sunnary_data}    get order summary data
        Set Test Variable  ${payment_order_sunnary_data}   ${payment_order_sunnary_data}
#        Click Place Order Button In Order Review Page
    END

Change Store From Pdp Page-v2
    [Arguments]    ${store_name}     ${input}
    sleep    2
    Wait Until Page Contains Element     (//p[text()="My Store:"])[1]
    Wait Until Element Is Enabled       (//p[text()="My Store:"])[1]
    ${is_store_name}     Get Element Count     (//p[text()="${store_name}"])[1]
    IF   ${is_store_name} == 0
        Mouse Over                           (//p[text()="My Store:"])[1]
        Wait Until Page Contains Element     //p[text()="FIND OTHER STORES"]/..
        ${headle}  Run Keyword And Ignore Error  Click Element     //p[text()="FIND OTHER STORES"]/..
        IF  "${headle[0]}"=="FAIL"
                    Mouse Over                           (//p[text()="My Store:"])[1]
                    Wait Until Page Contains Element     //p[text()="FIND OTHER STORES"]/..
                    Click Element                        //p[text()="FIND OTHER STORES"]/..
        END
        Wait Until Page Contains Element     //p[text()='SELECT OTHER STORE']

        Wait Until Page Contains Elements Ignore Ad   //p[text()='SELECT OTHER STORE']/..//input[contains(@class,"chakra-input")]
        Input Text       //p[text()='SELECT OTHER STORE']/..//input[contains(@class,"chakra-input")]     ${input}
        Wait Until Page Contains Elements Ignore Ad     //div[@class="css-1oh8nz1"]/button
        Click Element                                   //div[@class="css-1oh8nz1"]/button
#        Select From List By Value     //select    200
        Wait Until Page Contains Elements Ignore Ad    //div[@class="css-1oh8nz1"]/div/div/button[5]
        Click Element                                  //div[@class="css-1oh8nz1"]/div/div/button[5]
        Sleep  3
        Click Element  //div[@class="chakra-input__left-element css-a8qwqz"]/*

#        Input Text                       //input[@placeholder='Enter city, state, zip']     ${input}
#        Press Keys     //input[@placeholder='Enter city, state, zip']    \ue007
#        Wait Until Page Contains Element     //select
#        Select From List By Value     //select    200
#        Click Element  //div[@class="chakra-input__left-element css-a8qwqz"]/*
        Wait Until Page Contains Element     //p[text()="${store_name}"]
        Click Element    //p[text()="${store_name}"]/preceding-sibling::div/*
        Click Element    //div[contains(text(),"CHANGE MY STORE")]/..
        Wait Until Page Contains Element     //p[text()="${store_name}"]
        sleep   1
    END

Open Add A Gift Card
    ${Gift Card down}   Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad  //*[name()="svg" and @class="icon icon-tabler icon-tabler-chevron-down"]
    IF  "${Gift Card down[0]}"=="PASS"
        Click Element   //*[name()="svg" and @class="icon icon-tabler icon-tabler-chevron-down"]
        Wait Until Page Contains Elements Ignore Ad  //*[name()="svg" and @class="icon icon-tabler icon-tabler-chevron-up"]
    END