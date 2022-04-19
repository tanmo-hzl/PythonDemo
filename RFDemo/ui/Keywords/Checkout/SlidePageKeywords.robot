*** Settings ***
Library    SeleniumLibrary     run_on_failure=Capture Screenshot and embed it into the report
Resource    ../../TestData/Checkout/config.robot
Resource    BuyerCheckKeywords.robot
Resource    PDPPageKeywords.robot

Library     Collections
Library     ../../Libraries/Checkout/BuyerKeywords.py


*** Variables ***
${items_added_to_cart_text}   //*[text()="Items added to cart!"]
${view_my_cart_ele}    //div[text()="View My Cart"]
${items_atc_ele}    (//*[contains(text(),"Items added to cart!")])
${name_eles}    ${items_atc_ele}/../following-sibling::div[1]/div/p
${product_eles}    ${items_atc_ele}/../following-sibling::div[1]/div/div/p

${bn_img_ele}    //p[text()="Buy Now"]/../..//img

*** Keywords ***


Buy Now Process
#    ${Checkout Panel Stats}  Get All Relevant Number Before Placing Order
#    Log    ck_order_stats:${Checkout Panel Stats}
    Click Place Order Button In Buy Now Page
    ${payment_err_message}  Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad  //*[contains(text(),"Unable to Process Payment")]
    IF  "${payment_err_message[0]}"=="PASS"
         Log Source
         Wait Until Page Contains Elements Ignore Ad  //*[text()="Close"]
         Click Element                                //*[text()="Close"]
#         Wait Until Element Is Visible                //p[text()="Buy Now"]
#         Click Element                                //p[text()="Buy Now"]
         Click Buy Now Button    ${PRODUCT_INFO_LIST[0]["channel"]}
         Wait Until Element Is Visible    //h3[contains(text(),"Order Summary")]
         Scroll Element Into View    //div[text()="PLACE ORDER"]/parent::button
         Click Element   //div[text()="PLACE ORDER"]/parent::button
    END
    ${orderNo}    Get OrderNo
    Set Suite Variable    ${ORDER_NO}    ${orderNo}
    log    ck_order_number:${orderNo}
#    Click Continue Shipping Button

Get OrderNo
    Wait Until Element Is Visible    //p[text()="Order Confirmation"]
#    ${e_orderNo_text}  Get Text   //p[text()="Order Confirmation"]/../following-sibling::div/div/p[2]
    ${e_orderNo_text}    Get Text    //p[text()="Thank you, your order has been placed."]/following-sibling::p
    ${orderNo}    Set Variable    ${e_orderNo_text[10:]}
    [Return]    ${orderNo}

Click Continue Shipping Button
    Wait Until Element Is Visible    //div[text()="CONTINUE SHOPPING"]
    Click Element    //div[text()="CONTINUE SHOPPING"]


Click Place Order Button In Buy Now Page
    Sleep    3
    Wait Until Page Contains Element     //p[text()="Buy Now"]
    Wait Until Element Is Visible    //p[text()="Buy Now"]
    Wait Until Element Is Visible    //h3[contains(text(),"Order Summary")]
    Wait Until Element Is Visible    //p[contains(text(),"Total:")]
    Scroll Element Into View    //div[text()="PLACE ORDER"]/parent::button
    ${err_win}      Run Keyword And Ignore Error    Wait Until Page Contains Element  //*[contains(text(),"Sorry, we cannot process your transaction.")]
    IF  "${err_win[0]}"=="PASS"
        Wait Until Page Contains Element    //div[text()="TRY AGAIN"]/parent::button
        Click Element  //div[text()="TRY AGAIN"]/parent::button
        Wait Until Page Contains Element   //button[@class="chakra-modal__close-btn css-iwhjmc"]
        Click Element  //button[@class="chakra-modal__close-btn css-iwhjmc"]
#        Wait Until Page Contains Element     //p[text()="Buy Now"]
#        Wait Until Element Is Visible        //p[text()="Buy Now"]
#        Click Element                        //p[text()="Buy Now"]
        Click Buy Now Button   ${PRODUCT_INFO_LIST[0]["channel"]}
        Wait Until Element Is Visible       //h3[contains(text(),"Order Summary")]
        Scroll Element Into View           //div[text()="PLACE ORDER"]/parent::button
        Sleep  1
    END
    Wait Until Element Is Enabled   //div[text()="PLACE ORDER"]/parent::button
    Click Element    //div[text()="PLACE ORDER"]/parent::button


Book Class Only Process
#    ${Checkout Panel Stats}  Get All Relevant Number Before Placing Order
#    Log    ck_order_stats:${Checkout Panel Stats}
    Click Register & Pay Button
    Wait Until Element Is Visible    //p[text()="Successfully booked"]
    Page Should Contain Element     //p[text()="Successfully booked"]
    ${order_no}    get order no from order history
    Set Suite Variable    ${ORDER_NO}    ${order_no}
    log    ck_order_number:${order_no}

Click Register & Pay Button
    Sleep    3
#    Wait Until Element Is Visible   //h3[text()="Register for Online Class"]
    Wait Until Element Is Visible     //h4[text()="Guest 1"]
    Wait Until Element Is Enabled    //div[text()="Register & Pay"]
    Click Element    //div[text()="Register & Pay"]



Click View My Cart Button
    Wait Until Page Contains Element    //*[text()="Items added to cart!"]
    wait until element is visible    //*[text()="Items added to cart!"]
    Wait Until Element Is Enabled    //div[text()="View My Cart"]
    click element    xpath=//div[text()="View My Cart"]


Click Continue as Guest Button
    Wait Until Page Contains Element    //div[text()="CONTINUE AS GUEST"]/..
    wait until element is visible    //div[text()="CONTINUE AS GUEST"]/..
    click element    //div[text()="CONTINUE AS GUEST"]/..

Login In Slide Page And Get Account Info
    login in slide page     ${buyer['user']}    ${buyer['password']}
    ${user_information}    Get Account Info
    Set Suite Variable     ${USER_INFO}    ${user_information}

login in slide page
    [Arguments]     ${user}    ${password}
    Sleep    2
    Wait Until Page Contains Element     //label[text()="Email Address"]
    Wait Until Element Is Visible    //label[text()="Email Address"]
    wait until element is visible    //input[@id="email"]
    click element    //input[@id="email"]
#    input text    //input[@id="email"]    ${user}
#    input text    //input[@id="password"]    ${password}
    Press Keys    //input[@id="email"]    ${user}
    click element    //input[@type="password"]
    Press Keys    //input[@type="password"]    ${password}
    ${sign in eles}     Get Webelements   //div[text()="SIGN IN"]/parent::button
    ${sign in eles length}  Get Length   ${sign in eles}
    IF  ${sign in eles length}>1
        click button   ${sign in eles}[-1]
    ELSE
        click button    //div[text()="SIGN IN"]/parent::button
    END

#Check store name
#    [Arguments]    ${store_name}
#    ${A_store_name}    Get Text    ${items_atc_ele}/../following-sibling::div[1]/div/p[1]
#    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${store_name}    ${A_store_name}

check view my cart popup
    [Arguments]     ${purchase_type}   ${product_info}
    IF  "${purchase_type}" == "ATC" or "${purchase_type}" == "ACTC"
        Check View My Cart Slide Page   ${product_info}
    END


Check View My Cart Slide Page
    [Arguments]    ${product_info}
    Wait Until Element Is Visible    ${items_added_to_cart_text}
    Wait Until Element Is Visible    ${view_my_cart_ele}
    Wait Until Element Is Visible    //div[text()="Continue Shopping"]
    ${items_atc_ele}     Set Variable       ${items_atc_ele}
    ${name_eles}         Get Webelements    ${name_eles}
    ${A_store_name}      Get Text           ${name_eles[0]}
    ${A_product_name}    Get Text           ${name_eles[1]}
    ${product_eles}      Get Webelements    ${product_eles}
    ${A_price}           Get Text           ${product_eles[0]}
    ${A_qty}             Get Text           ${product_eles[1]}
    Check Item Properties                   ${product_info}
    ${items}   Get Text   (//*[contains(text(),"Items added to cart!")])/../following-sibling::div[2]/div/div/p[1]
    Sleep   1
    ${subtotal}    Get Text    (//*[contains(text(),"Items added to cart!")])/../following-sibling::div[2]/div/div/p[2]
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${product_info}[store_name]      ${A_store_name}      store name are inconsistent in view my cart slide page
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${product_info}[product_name]    ${A_product_name}    product name are inconsistent in view my cart slide page
    Run Keyword And Warn On Failure    Should Be Equal As Strings    price:${product_info}[price]     price:${A_price}     product price are inconsistent in view my cart slide page
    Run Keyword And Warn On Failure    Should Be Equal As Strings    QTY: ${product_info}[qty]        ${A_qty}             product qty are inconsistent in view my cart slide page
    Run Keyword And Warn On Failure    Should Be Equal As Strings    Subtotal (${product_info}[qty] items)    ${items}     product subtotal items are inconsistent in view my cart slide page
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${product_info}[subtotal]        ${subtotal}          product subtotal are inconsistent in view my cart slide page


Check Item Properties
    [Arguments]    ${product_info}
    ${isSize}   Get Element Count    ${items_atc_ele}/../following-sibling::div[1]//p[text()="Size"]
    IF   ${isSize} > 0
#    IF    '${product_info}[size]' != '${EMPTY}'
        ${A_size}   Get Text     ${items_atc_ele}/../following-sibling::div[1]//p[text()="Size"]/following-sibling::p
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${product_info}[size]    ${A_size}     product sizes are inconsistent in view my cart slide page
    END
#    ${isColor}   Get Element Count     ${items_atc_ele}/../following-sibling::div[1]//p[text()="Color"]
#    IF   ${isColor} > 0     #and "${product_info}[color]" != "0"
    IF    "${product_info}[color]" != "${EMPTY}"
        ${A_color}   Get Text    ${items_atc_ele}/../following-sibling::div[1]//p[text()="Color"]/following-sibling::p
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${product_info}[color]    ${A_color}    product color are inconsistent in view my cart slide page
    END
#    ${isCount}   Get Element Count   ${items_atc_ele}/../following-sibling::div[1]//p[text()="Count"]
#    IF   ${isCount} > 0
    IF    "${product_info}[count]" != "${EMPTY}"
        ${A_count}   Get Text    ${items_atc_ele}/../following-sibling::div[1]//p[text()="Count"]/following-sibling::p
        Run Keyword And Warn On Failure     Should Be Equal As Strings    ${product_info}[count]    ${A_count}    product counts are inconsistent in view my cart slide page
    END


Check Buy Now Slide Page
    #to do
    [Arguments]     ${product_type}    ${shipping_method}    ${product_info}
    sleep   2
    Wait Until Page Contains Element     //p[text()="Buy Now"]
    Wait Until Element Is Visible    //p[text()="Buy Now"]
    Wait Until Page Contains Element    //h3[contains(text(),"Order Summary")]
    Wait Until Element Is Visible    //p[contains(text(),"Total:")]
    Check Pay Card In Buy Now Slide Page     ${product_type}
    IF   "${product_type}" == "listing"
        Check Product Info In Buy Now    ${product_info}
        IF   "${shipping_method}" == "STM"
            Check Ship to Home Info In Buy Now Slide Page
        ELSE IF    "${shipping_method}" == "SDD"
            Check SDD Info In Buy Now Slide Page
        ELSE IF    "${shipping_method}" == "PIS"
            Check Pickup Info In Buy Now Slide Page
        END
        Check Order Summary In Buy Now     ${product_info}
    ELSE IF   "${product_type}" == "class"
        Check Guest1 Info in slide page
        Check class order summary in buy now
    END


Check Guest1 Info in slide page
    ${Guest1_ele}     Set Variable     //h4[text()="Guest 1"]/following-sibling::div
    Wait Until Page Contains Element     //h4[text()="Guest 1"]/following-sibling::div
    ${guest1_first_name}    Get Element Attribute    ${Guest1_ele}//input[@id="firstName"]      value
    ${guest1_last_name}     Get Element Attribute    ${Guest1_ele}//input[@id="lastName"]       value
    ${guest1_email}         Get Element Attribute    ${Guest1_ele}//input[@id="email"]          value
    ${guest1_phone}         Get Element Attribute    ${Guest1_ele}//input[@id="phoneNumber"]    value
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${guest1_first_name}    ${account_info}[first_name]    Guest1 first name are inconsistent in buy now slide page
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${guest1_last_name}     ${account_info}[last_name]     Guest1 last name are inconsistent in buy now slide page
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${guest1_email}     ${account_info}[email]    Guest1 email are inconsistent in buy now slide page
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${guest1_phone}     ${account_info}[phone]    Guest1 phone are inconsistent in buy now slide page


Check class order summary in buy now
    [Arguments]    ${product_info}
    ${price}    Set Variable    ${product_info}[price]
    ${qty}      Set Variable    ${product_info}[qty]
    ${E_class_subtotal}   Evaluate    ${price[1:]}*${qty}
    ${E_class_subtotal}   Evaluate    "{:.2f}".format(${E_class_subtotal})
    ${class_subtotal}    Get Text    //p[text()="Class"]/following-sibling::p
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${class_subtotal}   $${E_class_subtotal}     class subtotal are inconsistent in buy now slide page
    ${estimated_tax}   Get Text    //p[text()="Estimated Tax"]/following-sibling::p
    ${class_total}    Get Text    //p[text()="Total:"]/following-sibling::p
    IF   "${estimated_tax}" == "TBD"
        ${estimated_tax}    Set Variable    0.00
    END
    ${E_class_total}    Evaluate    float(${class_subtotal[1:]}) + float(${estimated_tax[1:]})
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${class_total}    $${E_class_total}    class total are inconsistent in buy now slide page



Buy Now Class - Input All Guest Info
    [Arguments]     ${product_type}
    IF   "${product_type}" == "class"
        sleep   2
        ${Guest_Ele}    Set Variable    (//h4[contains(text(),"Guest")])
        Wait Until Page Contains Elements Ignore Ad     ${Guest_Ele}
        Wait Until Element Is Visible     ${Guest_Ele}
        ${count}    Get Element Count    ${Guest_Ele}
        ${count}    Evaluate    ${count} - 1
        ${Guest_Data}    Get Class Guest Info    ${count}
        ${index}    Set Variable    2
        FOR    ${Guest_Info}    IN    @{Guest_Data}
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]    ${Guest_Info}[firstName]
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]    ${Guest_Info}[lastName]
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]    ${Guest_Info}[email]
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]    ${Guest_Info}[phone]
            ${index}    Evaluate    ${index}+1
        END
    END


Buy Now Class - Input Same Guest Info
    [Arguments]     ${account_info}
    sleep   2
    ${Guest_Ele}    Set Variable    (//h4[contains(text(),"Guest")])
    Wait Until Page Contains Element     ${Guest_Ele}
    Wait Until Element Is Visible     ${Guest_Ele}
    ${count}    Get Element Count    ${Guest_Ele}
    ${count}    Evaluate    ${count} - 1
#        ${Guest_Data}    Get Class Guest Info    ${count}
    ${index}    Set Variable    2
    FOR    ${i}    IN RANGE   ${count}
        Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]    ${account_info}[first_name]
        Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]    ${account_info}[last_name]
        Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]    ${account_info}[email]
        Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]    ${account_info}[phone]
        ${index}    Evaluate    ${index}+1
    END


Check Product Info In Buy Now
    [Arguments]    ${product_info}
    ${img_ele}    Set Variable      //img[@alt="thumbnail"]
    ${img_src}    Get Element Attribute     ${img_ele}    src
    Run Keyword And Warn On Failure    Should Not Be Empty    ${img_src}    product thumbnail is not empty
    ${product_text}    Get Text    ${img_ele}/../div
    ${product_text}    Split Parameter     ${product_text}    \n
    ${product_name}    Set Variable     ${product_text[0]}
    ${product_qty}     Set Variable     ${product_text[1]}
    Run Keyword And Warn On Failure    Should Be Equal As Strings     ${product_info}[product_name]    ${product_name}    product name are inconsistent in buy now slide page
    Run Keyword And Warn On Failure    Should Be Equal As Strings     QTY: ${product_info}[qty]     ${product_qty}    product qty are inconsistent in buy now slide page
    Check Item Properties in Buy Now Slide Page     ${product_info}


Check Item Properties in Buy Now Slide Page
    [Arguments]    ${product_info}
    ${img_ele}    Set Variable     //img[@alt="thumbnail"]
#    ${isSize}   Get Element Count    ${items_atc_ele}/../following-sibling::div[1]//p[text()="Size"]
    IF   '${product_info}[size]' != '${EMPTY}'
        ${A_size}   Get Text     ${img_ele}/../div//p[text()="Size"]/following-sibling::p
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${product_info}[size]    ${A_size}     product sizes are inconsistent in view my cart slide page
    END
#    ${isColor}   Get Element Count     ${items_atc_ele}/../following-sibling::div[1]//p[text()="Color"]
    IF    "${product_info}[color]" != "${EMPTY}"
        ${A_color}   Get Text    ${img_ele}/../div//p[text()="Color"]/following-sibling::p
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${product_info}[color]    ${A_color}    product color are inconsistent in view my cart slide page
    END
#    ${isCount}   Get Element Count   ${items_atc_ele}/../following-sibling::div[1]//p[text()="Count"]
    IF    "${product_info}[count]" != "${EMPTY}"
        ${A_count}   Get Text    ${img_ele}/../div//p[text()="Count"]/following-sibling::p
        Run Keyword And Warn On Failure     Should Be Equal As Strings    ${product_info}[count]    ${A_count}    product counts are inconsistent in view my cart slide page
    END



Check Pay Card In Buy Now Slide Page
    [Arguments]    ${product_type}
    ${E_credit_card_num}    Set Variable     ${signin_CC_info}[credit_card_number]
    ${E_card_end}    Set Variable     ****${E_credit_card_num[-4:]}
    ${E_expiration}    Set Variable     ${signin_CC_info}[expiration]
    IF   "${product_type}" == "listing"
        ${card_end}    Get Text    //p[text()="ending in "]/span
    ELSE IF   "${product_type}" == "class"
        ${card_end}    Get Text    //p[text()="Visa"]/following-sibling::p
        ${expiration}    Get Text    //p[text()="Expiration"]/following-sibling::p
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${E_expiration}    ${expiration}   expiration of credit card are inconsistent in view my cart slide page
    END
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${E_card_end}    ${card_end}    Last four digits of credit card are inconsistent in view my cart slide page



Check Ship to Home Info In Buy Now Slide Page
    ${STH_Info}    Get Text    //h3[text()="Ship to Home"]/../../following-sibling::p
    ${user}    Set Variable    ${USER_INFO[0]} ${USER_INFO[1]}
    ${address1}    Upper Parameter    ${USER_INFO[2]}
    ${address1}    Split Parameter    ${address1}    ,
    ${address2}    Set Variable     ${address1[0]},${address1[1]}, ${address1[3]}, ${address1[2]}
    ${E_STH_Info}    Catenate     ${user}\n${address2}, US
    Run Keyword And Warn On Failure    Should Be Equal As Strings     ${STH_Info}    ${E_STH_Info}    STH consignee info are inconsistent in buy now slide page


Check SDD Info In Buy Now Slide Page
    ${SDD_Info}    Get Text    //h3[text()="Same Day Delivery"]/../../following-sibling::p
    ${user}    Set Variable    ${USER_INFO[0]} ${USER_INFO[1]}
    ${address1}    Upper Parameter    ${USER_INFO[2]}
    ${address1}    Split Parameter    ${address1}    ,
    ${address2}    Set Variable     ${address1[0]},${address1[1]}, ${address1[3]}, ${address1[2]}
    ${E_SDD_Info}    Catenate     ${user}\n${address2}, US
    Run Keyword And Warn On Failure    Should Be Equal As Strings     ${SDD_Info}    ${E_SDD_Info}    SDD consignee info are inconsistent in buy now slide page


Check Pickup Info In Buy Now Slide Page
    ${pickup_location_text}    Get Text     //p[text()="Pickup Location:"]/following-sibling::p
    ${pickup_location}    Split Parameter    ${pickup_location_text}    \n
    ${A_pickup_location}    Catenate    ${pickup_location[0]},${pickup_location[1]},${pickup_location[2]},${pickup_location[3]}
    ${E_pickup_location}    Set Variable     ${pickup_location_in_buy_now}
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${A_pickup_location}    ${E_pickup_location}    pickup_location are inconsistent in buy now slide page
    ${pipup_person_name}    Get Text    //p[text()="Pickup Person"]/../../following-sibling::p[1]
    ${pipup_person_email}    Get Text     //p[text()="Pickup Person"]/../../following-sibling::p[2]
    ${user}    Set Variable    ${USER_INFO[0]} ${USER_INFO[1]}
#    ${address1}    Upper Parameter    ${USER_INFO[2]}
#    ${address1}    Split Parameter    ${address1}    ,
#    ${address2}    Set Variable     ${address1[0]},${address1[1]}, ${address1[3]}, ${address1[2]}
#    ${E_pipup_person_address}    Catenate     ${user}\n${address2}, US
    ${E_mail}    Set Variable     ${USER_INFO[4]}
#    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${pipup_person_address}    ${E_pipup_person_address}    pipup_person_address are inconsistent in buy now slide page
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${pipup_person_name}    ${user}     user name is wrong in buy now slide page
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${pipup_person_email}    ${E_mail}    pipup_person_email is wrong in buy now slide page



Check Order Summary In Buy Now
    [Arguments]    ${product_info}
    ${order_summary_ele}    Set Variable    //h3[text()="Order Summary"]
    ${subtotal_text}    Get Text     ${order_summary_ele}/following-sibling::div[1]
    ${subtotal_text}   Split Parameter    ${subtotal_text}   \n
    ${A_item_nums}   Set Variable    ${subtotal_text[0]}
    ${A_subtotal}    Set Variable    ${subtotal_text[1]}
    ${price}    Set Variable    ${product_info}[price]
    ${E_subtotal}    Evaluate    float(${price[1:]}) * int(${product_info}[qty])
    ${E_subtotal}    Evaluate    "{:.2f}".format(${E_subtotal})
#    IF   "${product_info}[qty]" == "1"
    Run Keyword And Warn On Failure    Should Be Equal As Strings    Subtotal (${product_info}[qty] items)    ${A_item_nums}   Product qty subtotal are inconsistent in buy now slide page
#    ELSE
#        Run Keyword And Warn On Failure    Should Be Equal As Strings    Subtotal (${product_info}[qty] items)    ${A_item_nums}   Product qty subtotal are inconsistent in buy now slide page
#    END
    ${E_subtotal}    Catenate     $${E_subtotal}
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${E_subtotal}   ${A_subtotal}    Product subtotal amount are inconsistent in buy now slide page
    Check Order Summary Order Total In Buy Now     ${A_subtotal}    ${product_info}
#    Set Test Variable    ${ITEM_NUMS_IN_BN}     ${A_item_nums}
    Set Suite Variable    ${SUBTOATL_IN_BN}    ${E_subtotal}


Check Order Summary In Order Detail
    [Arguments]    ${product_info}
    ${order_summary_ele}    Set Variable    //h4[contains(text(),"Order Summary")]
    ${subtotal_text}    Get Text     ${order_summary_ele}/..//following-sibling::div[1]
    ${subtotal_text}   Split Parameter    ${subtotal_text}   \n
    ${A_item_nums}   Set Variable    ${subtotal_text[0]}
    ${A_subtotal}    Set Variable    ${subtotal_text[1]}
    IF   "${product_info}[qty]" == "1"
        Run Keyword And Warn On Failure    Should Be Equal As Strings    Subtotal (${product_info}[qty] item)     ${A_item_nums}   Product qty subtotal are inconsistent in order detail page
    ELSE
        Run Keyword And Warn On Failure    Should Be Equal As Strings    Subtotal (${product_info}[qty] items)     ${A_item_nums}   Product qty subtotal are inconsistent in order detail page
    END
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${SUBTOATL_IN_BN}    ${A_subtotal}    Product subtotal amount are inconsistent in order detail page
    Check Order Summary Order Total In Order Detail     ${A_subtotal}    ${product_info}


Check Order Summary Order Total In Order Detail
    [Arguments]     ${subtotal}    ${product_info}
    Sleep    1
    ${SDD_fee}    Set Variable    $0.00
    ${order_total}    Get Text    //p[text()="Order Total"]/following-sibling::p
    ${shipping_handling}    Get Text     //p[text()="Shipping & Handling"]/following-sibling::p
    IF   "${shipping_handling}" == "FREE"
        ${shipping_handling}    Set Variable    $0.00
    END
    IF   "${product_info}[shipping_method]" == "SDD"
        ${SDD_fee}   Get Text    //p[text()="Same Day Delivery"]/following-sibling::p
    END
    ${tax}   Get Text     //p[text()="Tax"]/following-sibling::p
    ${E_total}   Evaluate    float(${subtotal[1:]})+float(${SDD_fee[1:]})+float(${tax[1:]})+${shipping_handling[1:]}
    ${E_total}   Evaluate    format(${E_total},".2f")
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${order_total}    $${E_total}    product total amount are inconsistent in order detail page


Check Order Summary Order Total In Buy Now
    [Arguments]     ${subtotal}    ${product_info}
    log    ${subtotal}
    sleep   1
    Wait Until Page Does Not Contain Element    //span[text()="Loading..."]
    ${A_total}    Get Text    //p[text()="Total:"]/following-sibling::h4
    ${estimated_tax}    Get Text    //p[text()="Estimated Tax"]/following-sibling::p
    IF   "$" in "${estimated_tax}"
        ${estimated_tax}    Set Variable     ${estimated_tax[1:]}
    ELSE
        ${estimated_tax}    Set Variable     ${estimated_tax}
    END
    ${estimated_shipping}    Set Variable    $0.00
    ${SDD_fee}    Set Variable    $0.00
    ${other_fee}   Set Variable    $0.00
    IF   "${product_info}[channel]" == "MIK"
        IF   "${product_info}[shipping_method]" == "STM"
            ${estimated_shipping}    Get Text    //p[text()="Estimated Shipping"]/following-sibling::p
        ELSE IF    "${product_info}[shipping_method]" == "SDD"
            ${SDD_fee}    Get Text    //p[text()="Same Day Delivery"]/following-sibling::p/span
        END
    ELSE
        ${estimated_shipping}    Get Text    //p[text()="Estimated Shipping"]/following-sibling::p
    END
    ${is_other_fee}   Get Element Count    //p[text()="Other Fees"]
    IF   ${is_other_fee} > 0
        ${other_fee}   Get Text   //p[text()="Other Fees"]/following-sibling::p
    END
    log    ${subtotal[1:]}
    log    ${SDD_fee[1:]}
    log    ${estimated_shipping[1:]}
    log    ${estimated_tax[1:]}
    log    ${other_fee[1:]}
    ${E_total}   Evaluate    float(${subtotal[1:]})+float(${SDD_fee[1:]})+float(${estimated_shipping[1:]})+float(${estimated_tax})+float(${other_fee[1:]})
    ${E_total}   Evaluate    format(${E_total},".2f")
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${A_total}    $${E_total}    product total amount are inconsistent in buy now slide page


Check Order Detail Page
    [Arguments]    ${order_num}    ${product_info}
    Check order number in detail page    ${order_num}
    Check Payment Method In Oeder Detail
    IF   "${product_info}[shipping_method]" == "PIS"
        Check Pickup Info In Order Detail Page
    ELSE IF   "${product_info}[shipping_method]" == "STM" or "${product_info}[shipping_method]" == "SDD"
        Check Ship to Address In Order Detail
    END
    Check Order Status and Store Name In Order Detail     ${product_info}
    Check Product Info In Order Detail Page     ${product_info}
    Check Order Summary In Order Detail     ${product_info}



Check order number in detail page
    [Arguments]    ${order_num}
    go to    ${Home URL}/buyertools/order-history?detail=${order_num}
    Wait Until Page Contains Element     //p[text()="Order Detail"]
    Wait Until Page Contains Element    (//h4)[1]
    Wait Until Element Is Visible    (//h4)[1]
    ${order_num_text}    Get Text     (//h4)[1]
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${order_num_text}    Order #${order_num}    order number is wrong in order detail page
    ${placed_time}    Get Text    (//h4)[1]/following-sibling::div/p[1]
    ${now_date}    Get Now Time
    Run Keyword And Warn On Failure    Should Be Equal As Strings     ${placed_time}    Placed ${now_date}    placed time is wrong in order detail page
    Run Keyword And Warn On Failure    Page Should Contain Element     //p[text()="View Receipt"]
    Run Keyword And Warn On Failure    Page Should Contain Element     //div[text()="Buy All Again"]/parent::button


Check Pickup Info In Order Detail Page
    ${order_status_type}    Get Text    //div[text()="Get Directions"]/../../preceding-sibling::div/div
    ${order_status_type}    Split Parameter     ${order_status_type}    \n
    ${order_status_type}    Catenate     ${order_status_type[0]}${order_status_type[1]}${order_status_type[2]}
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${order_status_type}    Order Placed - In Store Pickup    order status and type is wrong in order detail page
    ${pickup_location}   Get Text   //div[text()="Get Directions"]/../div[1]
    ${E_pickup_location}    Set Variable    ${pickup_location_in_order_detail}
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${pickup_location}    ${E_pickup_location}    pickup_location are inconsistent in order detail page
    ${original_pickup_person}    Get Text    //p[text()="Original Pickup Person:"]/following-sibling::p
    ${A_email}   Get Text   //p[text()="Email:"]/following-sibling::p
    ${user_name}    Set Variable    ${USER_INFO[0]} ${USER_INFO[1]}
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${original_pickup_person}    ${user_name}    original_pickup_person is wrong in order detail page
    Run Keyword And Warn On Failure     Should Be Equal As Strings    ${A_email}    ${account_info}[email]    email is wrong in order detail page


Check Order Status and Store Name In Order Detail
    [Arguments]    ${product_info}
    IF   "${product_info}[channel]" == "MKP" or "${product_info}[channel]" == "MKR"
        ${store_name}    Get Text    //p[contains(text(),"Sold & shipped by")]/following-sibling::p
        ${E_store_name}    capitalize_parameter     ${product_info}[store_name]
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${store_name}    ${E_store_name}     store name is wrong in order detail page
        Run Keyword And Warn On Failure    Page should contain element    //div[text()="In Progress"]    In Progress order status locator can't be found
    ELSE
        Run Keyword And Warn On Failure     Page should contain element    //h4[text()="Order #"]/../../following-sibling::div//*[name()="svg"]    Michaels's logo locator can't be found
    END
    IF   "${product_info}[shipping_method]" == "STM" or "${product_info}[shipping_method]" == "SDD"
        Run Keyword And Warn On Failure     Page should contain element    //div[text()="Order Placed"]    Order Placed order status locator can't be found
    END
    IF    "${product_info}[product_type]" == "class"
        ${now_date}    Get Now Time
        Run Keyword And Warn On Failure     Page should contain element    //div[text()='Class Booked "${now_date}"']    Class booked order status locator can't be found
    END
    IF   "${product_info}[shipping_method]" == "SDD"
        ${SDD_text}    Get Text    //div[text()="Order Placed"]/../following-sibling::p
        Run Keyword And Warn On Failure     Should Be Equal As Strings    ${SDD_text[3:]}    Same Day Delivery     SDD text is wrong in order detail page
    END



Check Ship to Address In Order Detail
    ${ship_to_address}    Get Text    //p[text()="Ship To"]/../following-sibling::div
    ${ship_to_address}    Split Parameter     ${ship_to_address}    \n
    ${ship_to_address}    Set Variable     ${ship_to_address[0]} ${ship_to_address[1]}
    ${E_ship_to_address}    Set Variable    ${pickup_location_in_order_detail}
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${ship_to_address}    ${E_ship_to_address}    ship to address is wrong in order detail page


Check Payment Method In Oeder Detail
    ${card_number}    Get Text    (//p[text()="Payment Method"]/../following-sibling::div/div/div/div/button/p)[1]
    ${E_card_number}    Set Variable    ${signin_CC_info}[credit_card_number]
    ${E_card_number}    Set Variable    ${E_card_number[-4:]}
    Run Keyword And Warn On Failure     Should Be Equal As Strings     ${card_number}    ending in ${E_card_number}    the credit card last four digtil number is wrong in order detail page
    ${payment_amount}    Get Text    (//p[text()="Payment Method"]/../following-sibling::div/div/div/div/button/p)[2]
    ${order_total}    Get Text    //p[text()="Order Total"]/following-sibling::p
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${payment_amount}    ${order_total}    payment amount is wrong in order detail page


Check Product Info In Order Detail Page
    [Arguments]    ${product_info}
    ${img_ele}    Set Variable     //a/img[@alt="thumbnail"]
    ${img_src}    Get Element Attribute     ${img_ele}    src
    Run Keyword And Warn On Failure    Should Not Be Empty    ${img_src}    product thumbnail is not empty
    ${product_text}    Get Text    ${img_ele}/../following-sibling::div/div
    ${product_text}    Split Parameter     ${product_text}    \n
    ${product_name}    Set Variable     ${product_text[0]}
    Run Keyword And Warn On Failure    Should Be Equal As Strings     ${product_name}    ${product_info}[product_name]    product name are inconsistent in detail page
    IF   "${product_info}[product_type]" == "listing"
        ${product_qty}     Set Variable     ${product_text[1]}
        ${price_text}    Set Variable      ${product_text[2]}
        IF   "Reg" in "${price_text}"
            ${price_text}    Split Parameter    ${price_text}
            ${price}    Set Variable    ${price_text[0]}
            ${reg_price}    Set Variable     ${price_text[1]}
        ELSE
            ${price}    Set Variable    ${price_text}
        END
        ${price}    Set Variable     ${price[:-1]}
        Run Keyword And Warn On Failure    Should Be Equal As Strings     ${product_qty}    QTY ${product_info}[qty]    product qty are inconsistent in order detail page
        Run Keyword And Warn On Failure    Should Be Equal As Strings     ${price}    ${product_info}[price]    product price are inconsistent in order detail page
    ELSE IF    "${product_info}[product_type]" == "class"
        ${store_name}    Set Variable     ${product_text[1]}
        ${Attendees}    Set Variable     ${product_text[-2]}
        ${price}    Set Variable     ${product_text[-1]}
        Run Keyword And Warn On Failure     Should Be Equal As Strings     ${store_name}    ${product_info}[store_name]    store name are inconsistent in order detail page
        Run Keyword And Warn On Failure     Should Be Equal As Strings     ${Attendees}     Attendees: ${product_info}[qty]     Attendees are inconsistent in order detail page
        Run Keyword And Warn On Failure     Should Be Equal As Strings     ${price}     ${product_info}[price]    class price are inconsistent in order detail page
    END


Update default address
    go to    ${Home URL}/buyertools/profile
    Wait Until Page Contains Element     //p[text()="Edit Profile"]/..
    Wait Until Element Is Visible    //p[text()="Edit Profile"]/..
    Click Element      //p[text()="Edit Profile"]/..
    Scroll Element Into View     //div[text()="Save"]/..
    ${address}    Set Variable     ${account_info}[address]
    ${address}    Split Parameter    ${address}    ,
    ${address}    Set Variable     ${address[0]}
    ${address}    Upper Parameter     ${address}
    ${default_address_ele}    Set Variable      (//p[contains(text(),"${address}")]/preceding-sibling::button)[1]
    Wait Until Page Contains Element    ${default_address_ele}
    Wait Until Element Is Visible     ${default_address_ele}
    Click Element     ${default_address_ele}
    Wait Until Element Is Visible    //div[text()="Save"]/..
    Click Element    //div[text()="Save"]/..
    sleep   1


Delete default address
    [Arguments]     ${address}
    sleep   2
    go to    ${Home URL}/buyertools/profile
    sleep   2
    Reload Page
    Wait Until Page Contains Element     //p[text()="Edit Profile"]/..
    Wait Until Element Is Visible    //p[text()="Edit Profile"]/..
    Click Element      //p[text()="Edit Profile"]/..
    Scroll Element Into View     //div[text()="Save"]/..
#    ${address}    Upper Parameter     ${address}
#    ${delete_icon_ele}    Set Variable     //p[contains(text(),"${address}")]/../following-sibling::div/button[2]
    ${status}    Run Keyword And Ignore Error     Wait Until Page Contains Element     //p[contains(text(),"${address}")]/../following-sibling::div/button[2]    5
    IF    "${status[0]}" == "FAIL"
        ${address}    Upper Parameter     ${address}
        Wait Until Page Contains Element     //p[contains(text(),"${address}")]/../following-sibling::div/button[2]    5
        Click Element       //p[contains(text(),"${address}")]/../following-sibling::div/button[2]
    ELSE
        Click Element       //p[contains(text(),"${address}")]/../following-sibling::div/button[2]
    END
    Wait Until Page Contains Element     //p[contains(text(),"Remove Address?")]
    Wait Until Element Is Visible     //p[contains(text(),"Remove Address?")]
    Wait Until Page Contains Element     //div[contains(text(),"Delete")]
    Click Element    //div[contains(text(),"Delete")]
    Wait Until Page Does Not Contain Element     //p[contains(text(),"${address}")]/../following-sibling::div/button[2]
    Wait Until Element Is Visible    //div[text()="Save"]/..
    Click Element    //div[text()="Save"]/..
    sleep   1


Buy Now Payment Select
    [Arguments]    ${update card}=false
    ${Slide Paymet}  Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad  //div[text()="Add"]/parent::button
    IF  "${Slide Paymet[0]}"=="PASS"
        Wait Until Page Contains Elements Ignore Ad   //div[text()="Add"]/parent::button
        Click Element                                 //div[text()="Add"]/parent::button
        Wait Until Page Contains Elements Ignore Ad   //p[text()="Credit Cards"]
        Wait Until Page Contains Elements Ignore Ad   //p[text()="Add Additional Card"]/parent::button
        Click Element                                 //p[text()="Add Additional Card"]/parent::button
        Wait Until Page Contains Elements Ignore Ad   //h2[text()="Card Information"]
        FOR  ${key}  ${value}  IN ZIP  ${creditInfo.keys()}    ${creditInfo.values()}
            Click Element   //input[@id="${key}"]
            Press Keys      //input[@id="${key}"]    ${value}
        END
        Wait Until Page Contains Elements Ignore Ad    //p[text()="Billing Information"]
        FOR    ${key}   ${value}   IN ZIP   ${billAddress.keys()}    ${billAddress.values()}
            IF   '${key}' != 'state'
                Click Element  //input[@id='${key}']
                Press Keys     //input[@id='${key}']       ${value}
            ELSE IF   '${key}' == 'state'
                Select From List By Value    //select[@id="${key}"]    ${value}
            END
        END
        Wait Until Page Contains Elements Ignore Ad   //div[text()="Save"]/parent::button
        Click Element                                 //div[text()="Save"]/parent::button
        Wait Until Page Contains Elements Ignore Ad   //p[text()="Verify Address"]
        Wait Until Page Contains Elements Ignore Ad   //div[text()="SAVE"]/parent::button
        Click Element  //div[text()="SAVE"]/parent::button
    ELSE
        Wait Until Page Contains Element   //div[text()="Change"]
            IF  "${update card}"=="true"
                Click Element     //div[text()="Change"]
                Wait Until Page Contains Element    //p[text()="Change"]
                Wait Until Page Contains Element    //p[text()="Credit Cards"]
                Wait Until Page Contains Element    //label[@class="e1g7q6s60 css-10qeu3y" and @data-checked=""]
                ${two_cc}  Run Keyword And Ignore Error   Wait Until Page Contains Element    //label[@class="e1g7q6s60 css-10qeu3y" and name(@data-checked)!="data-checked"]
                IF   "${two_cc[0]}"=="FAIL"
                    Wait Until Page Contains Elements Ignore Ad   //p[text()="Credit Cards"]
                    Wait Until Page Contains Elements Ignore Ad   //p[text()="Add Additional Card"]/parent::button
                    Click Element                                 //p[text()="Add Additional Card"]/parent::button
                    Wait Until Page Contains Elements Ignore Ad   //h2[text()="Card Information"]
                    FOR  ${key}  ${value}  IN ZIP  ${creditInfo1.keys()}    ${creditInfo1.values()}
                        Click Element   //input[@id="${key}"]
                        Press Keys      //input[@id="${key}"]    ${value}
                    END
                    Wait Until Page Contains Elements Ignore Ad    //p[text()="Billing Information"]
                    FOR    ${key}   ${value}   IN ZIP   ${billAddress1.keys()}    ${billAddress1.values()}
                        IF   '${key}' != 'state'
                            Click Element  //input[@id='${key}']
                            Press Keys     //input[@id='${key}']       ${value}
                        ELSE IF   '${key}' == 'state'
                            Select From List By Value    //select[@id="${key}"]    ${value}
                        END
                    END
                    Wait Until Page Contains Elements Ignore Ad   //div[text()="Save"]/parent::button
                    Click Element                                 //div[text()="Save"]/parent::button
                    Wait Until Page Contains Elements Ignore Ad   //p[text()="Verify Address"]
                    Wait Until Page Contains Elements Ignore Ad   //div[text()="SAVE"]/parent::button
                    Click Element  //div[text()="SAVE"]/parent::button
                END
                Wait Until Page Contains Element    //label[@class="e1g7q6s60 css-10qeu3y" and name(@data-checked)!="data-checked"]
                Click Element                       //label[@class="e1g7q6s60 css-10qeu3y" and name(@data-checked)!="data-checked" ]
                Wait Until Page Contains Element    //div[text()="USE SELECTED PAYMENT"]/..
                Click Element                       //div[text()="USE SELECTED PAYMENT"]/..
            END
    END

Get buy Now tax data
    Wait Until Page Contains Element   //p[text()="Estimated Tax"]
    ${tax}      Get Text               //p[text()="Estimated Tax"]/following-sibling::p
    [Return]      ${tax[1:]}


Click Buy Now Class Register & Pay
    Wait Until Page Contains Element   //div[text()="Register & Pay"]/..
    Click Element                      //div[text()="Register & Pay"]/..


Add payment credit card in slide page
    [Arguments]     ${creditInfo}     ${billAddress}
    ${add_payment_ele}    Set Variable    //p[contains(text(),"Register for")]/../following-sibling::button
    Wait Until Element Is Visible     //div[text()="Add"]/parent::button
    Click Element     //div[text()="Add"]/parent::button
    Add A Credit Card     ${creditInfo}     ${billAddress}
    Wait Until Element Is Visible     //p[text()="Default Payment Method"]
    Click Element     //div[text()="USE SELECTED PAYMENT"]/..
    Sleep    1


Remove credit card in wallet
    sleep    1
    Go To    ${HOME URL}/buyertools/wallet
    Wait Until Element Is Visible     //h2[text()="Wallet"]
    Wait Until Element Is Visible     //h4[text()="Credit and Debit Cards"]/..//*[name()="svg"]/../parent::button
    Click Element     //h4[text()="Credit and Debit Cards"]/..//*[name()="svg"]/../parent::button
    Wait Until Element Is Visible     //p[text()="Remove"]/../..
    Click Element     //p[text()="Remove"]/../..
    Wait Until Element Is Visible     //p[text()="Remove Card Confirmation"]
    Click Element    //div[text()="Confirm"]
    sleep    1

View All Rewards
    Wait Until Page Contains Elements Ignore Ad   //div[text()="View All Rewards"]/parent::button
    Click Element                                 //div[text()="View All Rewards"]/parent::button

Apply a voucher
    Wait Until Page Contains Elements Ignore Ad  //div[@class="css-1jf5i1d"]//button[text()="Apply"]
    ${voucher_ele_list}  Get Webelements         //div[@class="css-1jf5i1d"]//button[text()="Apply"]
    IF  ${voucher_ele_list}
        Click Element    ${voucher_ele_list[0]}
    END

Close View All Rewards Slide Page
    Wait Until Page Contains Elements Ignore Ad  //div[text()="Close"]/parent::button
    Click Element   //div[text()="Close"]/parent::button


Select number voucher apply
    [Arguments]  ${number}
    View All Rewards
    FOR  ${i} IN RANGE   ${number}
        Apply a voucher
        Sleep  1






