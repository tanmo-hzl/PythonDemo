*** Settings ***
Resource   ../../Keywords/Checkout/VerifyIiconInformationKeyword.robot
Resource    ../../TestData/EnvData.robot
Resource    ../../Keywords/Checkout/GetYourOrderPageKeywords.robot
Resource        ../../Keywords/Checkout/OrderSummaryKeywords.robot


Suite Setup     Run Keywords   initial env data2
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
1.verify guest sign in i icon infoemation
    [Documentation]     Verify sign_in I Icon Information
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
    Verify_sign_in_i_icon_information

2.verify guest order_status i icon infoemation
    [Documentation]     Verify order_status I Icon Information
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
    Wait Until Element Is Visible   //div[text()="CONTINUE AS GUEST"]
    Mouse Over   //div[text()="CONTINUE AS GUEST"]
    Mouse Down   //div[text()="CONTINUE AS GUEST"]
    Click Element  //div[text()="CONTINUE AS GUEST"]
    Wait Until Page Contains Elements Ignore Ad   //div[text()="Next: Payment & Order Review"]
    Wait Until Element Is Enabled   //div[text()="Next: Payment & Order Review"]
    Verify_order_status_i_icon_information

3.verify guest payment add gift card i icon infoemation
    [Documentation]     Verify add gift card  I Icon Information
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
    Wait Until Element Is Visible       //div[text()="CONTINUE AS GUEST"]
    Mouse Over                          //div[text()="CONTINUE AS GUEST"]
    Mouse Down                          //div[text()="CONTINUE AS GUEST"]
    Click Element                       //div[text()="CONTINUE AS GUEST"]
    ${a}    Create List
    Wait Until Element Is Visible       //div[text()="Next: Payment & Order Review"]
    Mouse Over                          //div[text()="Next: Payment & Order Review"]
    Adding The Personal Infomation For the Getting Your Order Page  Guest    ok       ${a}
    Sleep  ${sleep_time}
    Wait Until Element Is Visible    //div[text()="Next: Payment & Order Review"]
    Click Element                       //div[text()="Next: Payment & Order Review"]
    Wait Until Element Is Visible       //p[text()="USPS Address Suggestion"]
    Wait Until Element Is Visible       //div[text()="Use USPS Suggestion"]
    Click Element                       //div[text()="Use USPS Suggestion"]
    Verify_add_gift_card_i_icon_information


4.verify order summary infoemation
    [Documentation]     Verify add gift card  I Icon Information
    [Tags]   full-run       yitest1
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    add product to cart in order
    Wait Until Element Is Visible       //div[text()="CONTINUE AS GUEST"]
    Mouse Over                          //div[text()="CONTINUE AS GUEST"]
    Mouse Down                          //div[text()="CONTINUE AS GUEST"]
    Click Element                       //div[text()="CONTINUE AS GUEST"]
    ${a}    Create List
    Wait Until Element Is Visible       //div[text()="Next: Payment & Order Review"]
    Mouse Over                          //div[text()="Next: Payment & Order Review"]
    Adding The Personal Infomation For the Getting Your Order Page  Guest    ok       ${a}
    Sleep  ${sleep_time}
    Wait Until Element Is Enabled       //div[text()="Next: Payment & Order Review"]/parent::button
    Click Element                       //div[text()="Next: Payment & Order Review"]/parent::button
    ${Usps view}  Run Keyword And Ignore Error  Wait Until Element Is Visible       //p[text()="USPS Address Suggestion"]
    IF   "${Usps view[0]}"=="FAIL"
            Wait Until Element Is Enabled       //div[text()="Next: Payment & Order Review"]/parent::button
            Click Element                       //div[text()="Next: Payment & Order Review"]/parent::button
    END
    Wait Until Element Is Visible       //div[text()="Use USPS Suggestion"]
    Click Element                       //div[text()="Use USPS Suggestion"]
    get order summary data


