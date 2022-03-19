*** Settings ***
Resource    ../../TestData/EnvData.robot


*** Variables ***
${sleep_time}   0.5
${i_icon}    //button[@class="SignInFormstyles__SelfBtnBlock-sc-ewu6t4-1 dUUgPK"]/*
${$sign_in_i_icon}   //button[@class="SignInFormstyles__SelfBtnBlock-sc-ewu6t4-1 dUUgPK"]
${sign_in_i_text}   Checking this box keeps you signed in on this device. You may have to enter your password again when accessing account information or if you update your password.
${order_status_updates_i_text}   Michaels will send you 2 or more text messages to keep you updated on the status of your Michaels.com order. Message and data rates may apply. Text STOPALL to opt out of text messages at any time. Visit our privacy policy for more information.
${order_status_updats_i_icon}    //div[@class="css-4g6ai3"]
${add_gift_card_i_text}     Gift card can only be combined with Credit/Debit payment.
${add_gift_card_i_icon}    //div[@class="css-4g6ai3"]/*

*** Keywords ***
Verify_guest_checkout_i_icon_information
    [Documentation]
    [Arguments]  ${product}=product/85-x-11-cardstock-paper-by-recollections-50-sheets-10023428
    open browser    ${URL_MIK}    ${browser}
#    Reload page
    Maximize Browser Window
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
#    Verify_sign_in_i_icon_information
    AD Exception Handle-element visible   //div[text()="CONTINUE AS GUEST"]
    Mouse Over   //div[text()="CONTINUE AS GUEST"]
    Mouse Down   //div[text()="CONTINUE AS GUEST"]
    AD Exception Handle  //div[text()="CONTINUE AS GUEST"]
    Verify_order_status_i_icon_information
    ${a}    Create List
    AD Exception Handle-element visible  //div[text()="Next: Payment & Order Review"]
    Mouse Over   //div[text()="Next: Payment & Order Review"]
    Adding The Personal Infomation For the Getting Your Order Page  Guest    ok       ${a}
    Sleep  ${sleep_time}
    AD Exception Handle  //div[text()="Next: Payment & Order Review"]
    AD Exception Handle-element visible  //p[text()="USPS Address Suggestion"]
    AD Exception Handle-element visible  //div[text()="Use USPS Suggestion"]
    AD Exception Handle  //div[text()="Use USPS Suggestion"]
    Verify_add_gift_card_i_icon_information

add product to cart in order
    [Arguments]     ${product}=product/mini-easels-by-artists-loft-10219091
    Maximize Browser Window
    go to   ${URL_MIK}/${product}
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]    15
    AD Exception Handle-element visible     //p[contains(text(),"Ship to Me")]
    AD Exception Handle   //p[contains(text(),"Ship to Me")]
    AD Exception Handle-element visible   //div[text()="ADD TO CART"]
    AD Exception Handle   //div[text()="ADD TO CART"]
    Sleep  1
    AD Exception Handle-element visible   //div[text()="View My Cart"]
    Sleep  1
    AD Exception Handle   //div[text()="View My Cart"]
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]    15
    AD Exception Handle-element visible   //div[text()="PROCEED TO CHECKOUT"]
    AD Exception Handle   //div[text()="PROCEED TO CHECKOUT"]
    Sleep  1

Verify_sign_in_i_icon_information
    Sleep  ${sleep_time}
    AD Exception Handle-element visible   //h3[text()="Sign in to your account."]
    AD Exception Handle-element visible   ${$sign_in_i_icon}
    mouse over   ${$sign_in_i_icon}
    mouse over   ${$sign_in_i_icon}
#    AD Exception Handle-element visible   //*[text()="${sign_in_i_text}"]
    ${text}     Get text   //div[text()="${sign_in_i_text}"]
    IF  "${text}"=="${empty}"
        mouse over   ${$sign_in_i_icon}
        AD Exception Handle-element visible   //*[text()="${sign_in_i_text}"]
        ${text}     Get text   //div[text()="${sign_in_i_text}"]
    END
    Log Source
#    Sleep  2
#    Log Source
##    Log Location
#    AD Exception Handle-element visible   //*[text()="${sign_in_i_text}"]
#    ${text}     Get text   //div[text()="${sign_in_i_text}"]
    Should Be Equal As Strings   ${sign_in_i_text}   ${text}

Verify_order_status_i_icon_information
    Sleep  ${sleep_time}
    AD Exception Handle-element visible   ${order_status_updats_i_icon}
    Scroll Element Into View   ${order_status_updats_i_icon}
    Sleep  ${sleep_time}
    Mouse Over  ${order_status_updats_i_icon}
    Log Source
    AD Exception Handle-element visible   //p[text()="${order_status_updates_i_text}"]
    ${text}  Get Text   //p[text()="${order_status_updates_i_text}"]
    Should Be Equal As Strings   ${order_status_updates_i_text}   ${text}

Verify_add_gift_card_i_icon_information
    Sleep  ${sleep_time}
    AD Exception Handle-element visible  //h2[text()="Payment & Order Review"]
    AD Exception Handle-element visible  ${add_gift_card_i_icon}
    Scroll Element Into View  ${add_gift_card_i_icon}
    Sleep  ${sleep_time}
    Mouse Over  ${add_gift_card_i_icon}
    Sleep  ${sleep_time}
    AD Exception Handle-element visible  //p[contains(text(),"Gift card can only be combined with")]
    ${gift_text}    Get Text  //p[contains(text(),"Gift card can only be combined with")]
    Should Be Equal As Strings  ${gift_text}    ${add_gift_card_i_text}