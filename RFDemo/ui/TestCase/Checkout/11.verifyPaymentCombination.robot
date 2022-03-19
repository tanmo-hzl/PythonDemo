*** Settings ***
Resource    ../../TestData/EnvData.robot
Resource    ../../Keywords/Checkout/GetYourOrderPageKeywords.robot
Resource    ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Resource    ../../Keywords/Checkout/Common.robot
Suite Setup     set selenium timeout    ${TIME_OUT}
Test Teardown       close browser

*** Variables ***
${sleep_time}   0.5
${payment_slect}   /ancestor::span/preceding-sibling::span
${Credit_card}     //p[text()="Credit/Debit Card"]
${paypal}         //p[text()="Paypal"]
${google_pay}     //p[text()="Google Pay"]
${monthly}        //p[text()="Buy with monthly payments"]
${gift_card}      //p[text()="Add A Gift Card"]/preceding-sibling::div

&{guestInfo}    firstName=MO
...             lastName=DD
...             addressLine1=2901 Rio Grande Blvd
...             city=Euless
...             state=TX
...             zipCode=76039
...             email=ui_cart_smoke@snapmail.cc
...             phoneNumber=469-779-6009

*** Test Cases ***
Verifying Payment paypal only
    [Documentation]   Verifying Payment Combination in the Place Order Page - paypal only
    [Tags]  full-run       yitest
    To Place Order Page
    Sleep  ${sleep_time}
    verify payment only    ${paypal}

Verifying Payment google_pay only
    [Documentation]   Verifying Payment Combination in the Place Order Page - google_pay only
    [Tags]  full-run       yitest
    To Place Order Page
    Sleep  ${sleep_time}
    verify payment only    ${google_pay}

Verifying Payment gift card is checkbox
    [Documentation]   Verifying Payment Combination in the Place Order Page - gift card is checkbox
    [Tags]  full-run       yitest
    To Place Order Page
    Sleep  ${sleep_time}
    verify gift card is checkbox

Verifying Payment gift card only and Credit_card Combination
    [Documentation]   Verifying Payment Combination in the Place Order Page-gift card only and Credit_card Combination
    [Tags]  full-run       yitest
    To Place Order Page
    Sleep  ${sleep_time}
    verify payment only    ${Credit_card}

*** Keywords ***
To Place Order Page
    [Documentation]
    [Arguments]  ${product}=product/mini-easels-by-artists-loft-10219091
    open browser    ${URL_MIK}    ${browser}
    Maximize Browser Window
#    Reload Page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    go to   ${URL_MIK}/${product}
    AD Exception Handle-element visible     //p[contains(text(),"Ship to Me")]
    AD Exception Handle   //p[contains(text(),"Ship to Me")]
    AD Exception Handle-element visible   //div[text()="ADD TO CART"]
    AD Exception Handle   //div[text()="ADD TO CART"]
    AD Exception Handle-element visible   //div[text()="View My Cart"]
    AD Exception Handle   //div[text()="View My Cart"]
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    AD Exception Handle-element visible   //div[text()="PROCEED TO CHECKOUT"]
    AD Exception Handle   //div[text()="PROCEED TO CHECKOUT"]
    AD Exception Handle-element visible   //div[text()="CONTINUE AS GUEST"]
    Mouse Over   //div[text()="CONTINUE AS GUEST"]
    Mouse Down   //div[text()="CONTINUE AS GUEST"]
    AD Exception Handle  //div[text()="CONTINUE AS GUEST"]
    ${a}    Create List
    AD Exception Handle-element visible  //div[text()="Next: Payment & Order Review"]
    Mouse Over   //div[text()="Next: Payment & Order Review"]
    Adding The Personal Infomation For the Getting Your Order Page  Guest    ok       ${a}
    Sleep  ${sleep_time}
    AD Exception Handle  //div[text()="Next: Payment & Order Review"]
    AD Exception Handle-element visible  //p[text()="USPS Address Suggestion"]
    AD Exception Handle-element visible  //div[text()="Use USPS Suggestion"]
    AD Exception Handle  //div[text()="Use USPS Suggestion"]
    Sleep  3


