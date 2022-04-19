*** Settings ***
Resource    ../../TestData/EnvData.robot
Resource     Common.robot


*** Variables ***
${sleep_time}   0.5
${i_icon}    //button[@class="SignInFormstyles__SelfBtnBlock-sc-ewu6t4-1 dUUgPK"]/*
${$sign_in_i_icon}   //button[@class="SignInFormstyles__SelfBtnBlock-sc-ewu6t4-1 dUUgPK"]
${sign_in_i_text}   Checking this box keeps you signed in on this device. You may have to enter your password again when accessing account information or if you update your password.
${order_status_updates_i_text}   Michaels will send you 2 or more text messages to keep you updated on the status of your Michaels.com order. Message and data rates may apply. Text STOPALL to opt out of text messages at any time. Visit our privacy policy for more information.
${order_status_updats_i_icon}    //div[@class="css-4g6ai3"]//*[name()="path"]
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
    Wait Until Element Is Visible   //div[text()="CONTINUE AS GUEST"]
    Mouse Over   //div[text()="CONTINUE AS GUEST"]
    Mouse Down   //div[text()="CONTINUE AS GUEST"]
    Click Element  //div[text()="CONTINUE AS GUEST"]
    Verify_order_status_i_icon_information
    ${a}    Create List
    Wait Until Element Is Visible  //div[text()="Next: Payment & Order Review"]
    Mouse Over   //div[text()="Next: Payment & Order Review"]
    Adding The Personal Infomation For the Getting Your Order Page  Guest    ok       ${a}
    Sleep  ${sleep_time}
    Click Element  //div[text()="Next: Payment & Order Review"]
    Wait Until Element Is Visible  //p[text()="USPS Address Suggestion"]
    Wait Until Element Is Visible  //div[text()="Use USPS Suggestion"]
    Click Element  //div[text()="Use USPS Suggestion"]
    Verify_add_gift_card_i_icon_information

add product to cart in order
    [Arguments]     ${product}=${MIK[0]}
    Maximize Browser Window
    go to   ${URL_MIK}/${product}
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]    15
    ${pdp normal}  Run Keyword And Ignore Error  Wait Until Element Is Visible   //div[contains(text(),"Ship to Me")]
    IF  "${pdp normal[0]}"=="FAIL"
        Reload Page
        Wait Until Page Does Not contain Element    //*[@stroke="transparent"]    15
        Wait Until Page Contains Elements Ignore Ad   //div[contains(text(),"Ship to Me")]
    END
    Click Element                   //div[contains(text(),"Ship to Me")]

    Wait Until Element Is Visible   //div[text()="Add to Cart"]
    Click Element                   //div[text()="Add to Cart"]

    Sleep  1
    Wait Until Element Is Visible   //div[text()="View My Cart"]
    Sleep  1
    Click Element                   //div[text()="View My Cart"]
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]    15

    Wait Until Element Is Visible   //div[text()="PROCEED TO CHECKOUT"]
    Click Element   //div[text()="PROCEED TO CHECKOUT"]/parent::button
    Sleep  1
    ${loop_click}  Run Keyword And Ignore Error   Wait Until Element Is Visible   //div[text()="CONTINUE AS GUEST"]
    IF  "${loop_click[0]}"=="FAIL"
        Run Keyword And Ignore Error  Click Element     //div[text()="PROCEED TO CHECKOUT"]/parent::button
    END


Verify_sign_in_i_icon_information
    Sleep  ${sleep_time}
    Wait Until Element Is Visible   //h3[text()="Sign in to your account."]
    Wait Until Element Is Visible   ${$sign_in_i_icon}
    mouse over   ${$sign_in_i_icon}
    mouse over   ${$sign_in_i_icon}
#    Wait Until Element Is Visible   //*[text()="${sign_in_i_text}"]
    ${text}     Get text   //div[text()="${sign_in_i_text}"]
    IF  "${text}"=="${empty}"
        mouse over   ${$sign_in_i_icon}
        Wait Until Element Is Visible   //*[text()="${sign_in_i_text}"]
        ${text}     Get text   //div[text()="${sign_in_i_text}"]
    END
    Log Source
#    Sleep  2
#    Log Source
##    Log Location
#    Wait Until Element Is Visible   //*[text()="${sign_in_i_text}"]
#    ${text}     Get text   //div[text()="${sign_in_i_text}"]
    Should Be Equal As Strings   ${sign_in_i_text}   ${text}

Verify_order_status_i_icon_information
    Sleep  ${sleep_time}
    Wait Until Element Is Visible   ${order_status_updats_i_icon}
    Scroll Element Into View   ${order_status_updats_i_icon}
    Sleep  ${sleep_time}
    Mouse Over  ${order_status_updats_i_icon}
    Log Source
    Wait Until Element Is Visible   //p[text()="${order_status_updates_i_text}"]
    ${text}  Get Text   //p[text()="${order_status_updates_i_text}"]
    Should Be Equal As Strings   ${order_status_updates_i_text}   ${text}

Verify_add_gift_card_i_icon_information
    Sleep  ${sleep_time}
    Wait Until Element Is Visible  //h2[text()="Payment & Order Review"]
    Wait Until Element Is Visible  ${add_gift_card_i_icon}
    Scroll Element Into View  ${add_gift_card_i_icon}
    Sleep  ${sleep_time}
    Mouse Over  ${add_gift_card_i_icon}
    Sleep  ${sleep_time}
    Wait Until Element Is Visible  //p[contains(text(),"Gift card can only be combined with")]
    ${gift_text}    Get Text  //p[contains(text(),"Gift card can only be combined with")]
    Should Be Equal As Strings  ${gift_text}    ${add_gift_card_i_text}