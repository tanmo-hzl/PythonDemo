*** Settings ***
Documentation     Test Suite For smoke Checkout Tests Flow
Resource          ../../TestData/Checkout/config.robot
Resource          ../../Keywords/Checkout/Common.robot
Resource          ../../Keywords/Checkout/ShoppingCartPageKeywords.robot
Resource          ../../Keywords/Checkout/GetYourOrderPageKeywords.robot
Resource          ../../Keywords/Checkout/OrderReviewPageKeywords.robot
Resource          ../../Keywords/Checkout/GuestTrackOrderKeywords.robot
Library           OperatingSystem
Library           ../../TestData/Checkout/GuestGenerateAddress.py

Suite Setup      Initial Custom Selenium Keywords
Test Setup       Environ Browser Selection And Setting   ${ENV}    ${BROWSER}
Test Teardown    Finalization Processment

*** Variables ***
${TEST ENV}     ${ENV}
${Multiple Store}           Multiple pickup location are selected in this order:
${Range}                    200
${Store Name Set}           Not Set
${Multiple Store Address}   Not Set
${Paypay Amount}            Intital Paypal Amount Setting
${Store Address}            Not Set
${Lose USPS Verify}         We can't verify this address. Want to save it anyway?

*** Test Cases ***
Guest - Buy Now - Buyer Buys 1 STM And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now     credit   ck-smoke    full-run
    MIK    1    1     Credit Card

Guest - Buy Now - Buyer Buys 1 SDD And Guest Continue As Guest With Paypal
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now1     paypal  ck-smoke    full-run
    SDD    1    1     Paypal

Guest - Buy Now - Buyer Buys 1 PIS And Guest Continue As Guest With Gift Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now   gift   ck-smoke    full-run
    PIS    1    1     Gift Card

Guest - Buy Now - Buyer Buys 1 MIK Class And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now1   credit   ck-smoke     full-run
    MIK CLASS    1    1     Credit Card

Guest - Buy Now - Buyer Buys 1 MKP And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now   credit   ck-smoke     full-run
    MKP    1    1     Credit Card


*** Keywords ***
Guest Checkout Work Flow Buy Now
    [Arguments]    ${Channel Mode}   ${Items}   ${Qty}   ${Payment}    ${Promo Code}=Code Needed
    ${Address Collection}   Create List
    ${Qty Processed}        Qty Process               ${Qty}
    ${Items Count}          Calculate Items Count     ${Items}
    ${IF PIS}   ${IF MKR}   ${IF SDD}   Special Channel Detect    ${Channel Mode}

    ${Store Selection Needed}       Select Store Process                      ${Channel Mode}
    ${Store Address}                Select Store If Needed                    ${Initial Store Name}
    ${Refined Store Address}        Convert Store Address To Regular Space    ${Store Address}
    ${Product Channel Info}         Items Channel Dictionary Creation         ${Channel Mode}   ${Items}   ${TEST ENV}
    Log To Console    ${Product Channel Info}
    ${Sku List}   ${Partial Urls}   Split Skus From Partial Url               ${Product Channel Info}

    ${Shipping Info}   ${Class Set Qty}   ${Multiple Store Address}    Add Products To Cart Process - Guest Continue As Guest
    ...   ${Product Channel Info}    ${Qty Processed}

    ${Handle AD Pop}   Run Keyword And Warn On Failure     Guest Continue Next Step As       GUEST
    IF  '${Handle AD Pop}[0]' == 'FAIL'
        ${Handle AD Pop}   Run Keyword And Warn On Failure     Guest Continue Next Step As       GUEST
    END
    # Shopping Cart Page
    # Wait until the loading sign disappears


    ${Mulit Store Check}   Pick Up Detection    ${Channel Mode}
    IF  '${Mulit Store Check}' != 'Non Pick Up'
        ${Store Name Set}  ${Address Collection}   Verify The Multiple Store Selection   ${Mulit Store Check}    ${Multiple Store Address}
        ...   ${Initial Store Name}
    END

    # Get Your Order
    Wait Until Element Is Visible                //h2[text()='Getting your Order']    ${Long Waiting Time}
    Wait Until Page Does Not Contain Element     //*[@stroke="transparent"]
    Adding The Personal Infomation For the Getting Your Order Page         ${IF PIS}    ${Product Channel Info}    ${Class Set Qty}
    Sleep  5
    ${CK One}   Edit Cart Items And Subtotal Items Comparison
    IF  '${Promo Code}' != 'Code Needed'
        ${Saving Amount Res}    Add Promo Code Function    ${Promo Code}
    END
    ${Payment Review}   Verify Calculation On The Order Summary Panel and Subtals Comparison    Payment Order Review
    Wait Until Element Is Visible     //div[text()='Next: Payment & Order Review']     ${Mid Waiting Time}
#    IF  '${IF PIS}' == 'PIS Only'
#        ${Full Name}    ${Email Rough}  Add First Additional Pick Up Person
#    END

    ${USPS Verify}   ${USPS Trigger}   USPS Address Handling      Next: Payment & Order Review    ${Lose USPS Verify}   Use USPS Suggestion    ${IF PIS}

    IF  '${USPS Verify}[0]' == 'PASS'
        Click Element    //div[text()="Save"]
    ELSE IF  '${USPS Trigger}[0]' == 'PASS'
        ${Updated ZipCode}    Use USPS Suggested Address    ${IF PIS}
    END

    # Click The Place Order
    Wait Until Element Is Enabled     //h2[text()='Payment & Order Review']    ${Long Waiting Time}
    Wait Until Element Is Enabled     //h3[text()="Payment Method"]            ${Long Waiting Time}
    ${CK Two}   Edit Cart Items And Subtotal Items Comparison

    ${Place Order Total}   Verify Calculation On The Order Summary Panel and Subtals Comparison    PLACE ORDER
    Wait Until Element Is Visible     //p[text()='Edit Cart']
    ${Paypal Needed}       Payment Method Process    ${Payment}     ${IF PIS}
    IF  '${Payment}' != 'Paypal'
        Wait Until Element Is Enabled    //div[text()='PLACE ORDER']
        Sleep  2
        Click Element                    //div[text()='PLACE ORDER']
    ELSE
        Should Be Equal As Strings    ${Paypal Needed}    ${Place Order Total}
    END
#    ${HAR Log Result}   Har Log    ${Proxy}   ${Server}
    Sleep   4
    Page Should Not Contain Element            //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Visible              //h2[text()='Order Confirmation']       ${Long Waiting Time}
    ${Rough Order Number}    Get WebElements   //p[text()='ORDER NO. ']
    Should Not Be Empty      ${Rough Order Number[0].text}
    ${Extracted Number}      Number Extracted     ${Rough Order Number[0].text}
    Log    ck_order_number:${Extracted Number}
    Log To Console    ${Extracted Number}
    Run Keyword And Warn On Failure     Placed Order Should Not Contain Red Icon     ${Cart Icon Element}
    Run Keyword And Warn On Failure     Guest Track My Order Process    ${Extracted Number}   ${Channel Mode}  ${Mulit Store Check}
    ...   ${Place Order Total}   ${IF PIS}   ${IF MKR}   ${Refined Store Address}   ${Updated ZipCode}   ${Address Collection}