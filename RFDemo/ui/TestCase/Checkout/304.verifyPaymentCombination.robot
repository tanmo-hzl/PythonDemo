*** Settings ***
Resource    ../../TestData/EnvData.robot
Resource    ../../Keywords/Checkout/GetYourOrderPageKeywords.robot
Resource    ../../Keywords/Checkout/VerifyPaymentKeywords.robot

Suite Setup     Run Keywords   initial env data2
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
1.Verifying Payment paypal only
    [Documentation]   Verifying Payment Combination in the Place Order Page - paypal only
    [Tags]  full-run       yitest
    To Place Order Page
    Sleep  ${sleep_time}
    verify payment only    ${paypal}

2.Verifying Payment google_pay only
    [Documentation]   Verifying Payment Combination in the Place Order Page - google_pay only
    [Tags]  full-run       yitest
    To Place Order Page
    Sleep  ${sleep_time}
    verify payment only    ${google_pay}

3.Verifying Payment gift card is checkbox
    [Documentation]   Verifying Payment Combination in the Place Order Page - gift card is checkbox
    [Tags]  full-run       yitest
    To Place Order Page
    Sleep  ${sleep_time}
    verify gift card is checkbox

4.Verifying Payment gift card only and Credit_card Combination
    [Documentation]   Verifying Payment Combination in the Place Order Page-gift card only and Credit_card Combination
    [Tags]  full-run       yitest1
    To Place Order Page
    Sleep  ${sleep_time}
    verify payment only    ${Credit_card}

*** Keywords ***
To Place Order Page
    [Documentation]
    [Arguments]  ${product}=${MIK[0]}
    open browser    ${URL_MIK}    ${browser}
    Maximize Browser Window
#    Reload Page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    go to   ${URL_MIK}/${product}
    Wait Until Element Is Visible       //div[contains(text(),"Ship to Me")]
    Click Element                       //div[contains(text(),"Ship to Me")]
    Wait Until Element Is Visible       //div[text()="Add to Cart"]
    Click Element                       //div[text()="Add to Cart"]
    Wait Until Element Is Visible       //div[text()="View My Cart"]
    Click Element                       //div[text()="View My Cart"]
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    Wait Until Element Is Visible       //div[text()="PROCEED TO CHECKOUT"]/parent::button
    Click Element                       //div[text()="PROCEED TO CHECKOUT"]/parent::button
    ${Guest view}  Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad       //div[text()="CONTINUE AS GUEST"]
    IF  "${Guest view[0]}"=="FAIL"
        Wait Until Element Is Visible       //div[text()="PROCEED TO CHECKOUT"]/parent::button
        Click Element                       //div[text()="PROCEED TO CHECKOUT"]/parent::button
    END
    Mouse Over                          //div[text()="CONTINUE AS GUEST"]
    Mouse Down                          //div[text()="CONTINUE AS GUEST"]
    Click Element                       //div[text()="CONTINUE AS GUEST"]
    ${a}    Create List
    Wait Until Element Is Visible       //div[text()="Next: Payment & Order Review"]
    Mouse Over                          //div[text()="Next: Payment & Order Review"]
    Adding The Personal Infomation For the Getting Your Order Page  Guest    ok       ${a}
    Sleep  2
    Wait Until Element Is Visible       //div[text()="Next: Payment & Order Review"]
    Click Element                       //div[text()="Next: Payment & Order Review"]/parent::button
    Wait Until Element Is Visible       //p[text()="USPS Address Suggestion"]
    Wait Until Element Is Visible       //div[text()="Use USPS Suggestion"]
    Click Element                       //div[text()="Use USPS Suggestion"]
    Sleep  3


