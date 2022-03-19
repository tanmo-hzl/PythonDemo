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

Suite Setup      Set Selenium Timeout      ${Time Initial}
Test Setup       Environ Browser Selection And Setting   ${ENV}   Firefox
Test Teardown    Finalization Processment

*** Variables ***
${TEST ENV}     ${ENV}
${Multiple Store}           Multiple pickup location are selected in this order:
${Range}                    200
${Store Name Set}           Not Set
${Multiple Store Address}   Not Set
${Paypay Amount}            Intital Paypal Amount Setting
${Store Address}            Not Set

*** Test Cases ***
Guest - Buyer Buys 1 STM And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now    full-run   credit
    MIK    1    1     Credit Card

Guest - Buyer Buys 1 SDD And Guest Continue As Guest With Paypal
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now    full-run   paypal
    SDD    1    1     Paypal

Guest - Buyer Buys 1 PIS And Guest Continue As Guest With Gift Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now    full-run   gift
    PIS    1    1     Gift Card

Guest - Buyer Buys 1 MIK Class And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now    full-run   credit
    MIK CLASS    1    1     Credit Card

Guest - Buyer Buys 1 MKR And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now    full-run   gift
    MKR    1    1     Gift Card


Guest - Buyer Buys 1 MKR Class And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now    full-run   paypal
    MKR CLASS   1    1    Paypal

Guest - Buyer Buys 1 MKP And Guest Continue As Guest With Credit Card
    [Template]   Guest Checkout Work Flow Buy Now
    [Tags]   buy-now    full-run   credit
    MKP    1    1     Credit Card




*** Keywords ***
Guest Checkout Work Flow Buy Now
    [Arguments]    ${Channel Mode}   ${Items}   ${Qty}   ${Payment}    ${Store Amount}=1
    ${Address Collection}   Create List
    ${Qty Processed}        Qty Process     ${Qty}
    ${IF PIS}               If Pick Only    ${Channel Mode}
    ${IF MKR}               If Mkr Only     ${Channel Mode}
    ${Items Count}          Calculate Items Count       ${Items}

    ${Store Selection Needed}       Select Store Process                      ${Channel Mode}
    ${Store Address}                Select Store If Needed                    ${Initial Store Name}
    ${Refined Store Address}        Convert Store Address To Regular Space    ${Store Address}
    ${Product Channel Info}         Items Channel Dictionary Creation         ${Channel Mode}   ${Items}   ${TEST ENV}
    Log To Console    ${Product Channel Info}
    ${Sku List}   ${Partial Urls}   Split Skus From Partial Url               ${Product Channel Info}

    ${Shipping Info}   ${Class Set Qty}   ${Multiple Store Address}    Add Products To Cart Process - Guest Continue As Guest
    ...   ${Product Channel Info}    ${Qty Processed}    ${Store Amount}

    ${Handle AD Pop}   Run Keyword And Warn On Failure     Guest Continue Next Step As       GUEST
    IF  '${Handle AD Pop}[0]' == 'FAIL'
        Go To   ${Home URL}/cart
    END
    # Shopping Cart Page
    # Wait until the loading sign disappears
    Wait Until Element Is Not Visible    //div[@class="css-1qbjk8g"]           ${Long Waiting Time}

    ${Mulit Store Check}   Pick Up Detection    ${Channel Mode}
    IF  '${Mulit Store Check}' != 'Non Pick Up'
        ${Store Name Set}  ${Address Collection}   Verify The Multiple Store Selection   ${Mulit Store Check}    ${Multiple Store Address}
        ...   ${Initial Store Name}
    END

    # Get Your Order
    Wait Until Element Is Visible     //h2[text()='Getting your Order']    ${Long Waiting Time}

    Adding The Personal Infomation For the Getting Your Order Page         ${IF PIS}    ${Product Channel Info}    ${Class Set Qty}
    Sleep  1
    Edit Cart Items And Subtotal Items Comparison
    Wait Until Element Is Visible     //div[text()='Next: Payment & Order Review']     ${Mid Waiting Time}
    ${Payment Review}   Verify Calculation On The Order Summary Panel and Subtals Comparison    Payment Order Review
    Sleep  2
    Click Element      //div[text()='Next: Payment & Order Review']


    # Using Suggested Address
    ${USPS Verify}   Run Keyword And Ignore Error   Wait Until Element Is Visible    //h4[text()="We can't verify this address. Want to save it anyway?"]   3
    IF  '${USPS Verify}[0]' == 'Pass'
        Click Element    //div[text()="Save"]
    ELSE
        ${Suggested Address}    Use USPS Suggested Address    ${IF PIS}
    END

    # Click The Place Order
    Wait Until Element Is Enabled     //h2[text()='Payment & Order Review']    ${Long Waiting Time}
    Wait Until Element Is Enabled     //h3[text()="Payment Method"]            ${Long Waiting Time}
    Edit Cart Items And Subtotal Items Comparison

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
    Wait Until Element Is Not Visible          //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Visible              //h2[text()='Order Confirmation']       ${Long Waiting Time}
    ${Rough Order Number}    Get WebElements   //p[text()='ORDER NO. ']
    Should Not Be Empty      ${Rough Order Number[0].text}
    ${Extracted Number}      Number Extracted     ${Rough Order Number[0].text}
    Log    ck_order_number:${Extracted Number}
    Log To Console    ${Extracted Number}
    Run Keyword And Warn On Failure     Placed Order Should Not Contain Red Icon     ${Cart Icon Element}
    Run Keyword And Warn On Failure     Guest Track My Order Process    ${Extracted Number}   ${Channel Mode}  ${Mulit Store Check}
    ...   ${Place Order Total}   ${IF PIS}   ${IF MKR}   ${Refined Store Address}   ${Address Collection}