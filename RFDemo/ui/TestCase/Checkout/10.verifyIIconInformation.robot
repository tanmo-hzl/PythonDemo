*** Settings ***
Resource   ../../Keywords/Checkout/VerifyIiconInformationKeyword.robot
Resource    ../../TestData/EnvData.robot
Resource    ../../Keywords/Checkout/GetYourOrderPageKeywords.robot
Resource        ../../Keywords/Checkout/Common.robot
Resource        ../../Keywords/Checkout/OrderSummaryKeywords.robot
Suite Setup     set selenium timeout    ${TIME_OUT}
Test Teardown   close browser

*** Variables ***
${sleep_time}   0.5

&{guestInfo}    firstName=MO
...             lastName=DD
...             addressLine1=2901 Rio Grande Blvd
...             city=Euless
...             state=TX
...             zipCode=76039
...             email=ui_cart_smoke@snapmail.cc
...             phoneNumber=469-779-6009

*** Test Cases ***
verify guest sign in i icon infoemation
    [Documentation]     Verify sign_in I Icon Information
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
    Verify_sign_in_i_icon_information

verify guest order_status i icon infoemation
    [Documentation]     Verify order_status I Icon Information
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
    AD Exception Handle-element visible   //div[text()="CONTINUE AS GUEST"]
    Mouse Over   //div[text()="CONTINUE AS GUEST"]
    Mouse Down   //div[text()="CONTINUE AS GUEST"]
    AD Exception Handle  //div[text()="CONTINUE AS GUEST"]
    Verify_order_status_i_icon_information

verify guest payment add gift card i icon infoemation
    [Documentation]     Verify add gift card  I Icon Information
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
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
    Verify_add_gift_card_i_icon_information


verify order summary infoemation
    [Documentation]     Verify add gift card  I Icon Information
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
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
    get order summary data


