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
${Lose USPS Verify}         We can't verify this address. Want to save it anyway?

*** Test Cases ***
Guest - Buyer Buys 1 MIK Product STH item and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK    1    1     Credit Card

Guest - Buyer Buys 1 MIK STH + 2x of 1 MIK STH item and uses PAYPAL to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK    2    1|2    Paypal

Guest - Buyer Buys 1 MIK Product BOPIS item and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    PIS    1    1      Credit Card

Guest - Buyer Buys 1 MIK Product BOPIS item from 2 different Stores and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    PISM   1    2      Credit Card    2

Guest - Buyer Buys 2x QTY of 1 MIK BOPIS item (Same Store) and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    PIS    1    2      Credit Card

Guest - Buyer Buys 1 x SDD and chooses GIFT CARD at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    SDD    1    1      Gift Card

Guest - Buyer Buys 4 different MIK Products, over $100, chooses SDD and uses CC at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    SDDH    4    1|1|1|1      Credit Card

Guest - Buyer Buys 1 MIK Product STH and 1 MIK Class from uses CC at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK|MIK CLASS    1|1    1|1      Credit Card

Guest - Buyer Buys 1 MIK Product STH item, 1 BOPIS and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK|PIS      1|1    1|1      Credit Card

Guest - Buyer Buys 2 Different MIK Product STH item, 4 different MIK Products SDD, under $50 and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK|SDD    2|4    1|1|1|1|1|1      Credit Card

Guest - Buyer Buys 2 Different Marketplace Product from 1 Storefront and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKPS     2    1|1       Credit Card

Guest - Buyer Buys 1 Marketplace Product from 3 Different Storefronts and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKP      3    1|1|1     Credit Card

Guest - Buyer Buys 1 Makerplace Product and 1 Makerplace Class from the same store Storefront and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKRS|MKRS CLASS      1|1      1|1       Credit Card

Guest - Buyer Buys 1 Makerplace Product from 3 Different Storefronts and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKR                3        1|1|1     Credit Card

Guest - Buyer Buys 1 MIK Product STH and 1 Makerplace Product and 1 Marketplace Product and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK|MKR|MKP        1|1|1    1|1|1     Credit Card

Guest - Buyer Buys 2 different MIK Product and 1 MKR Product and 1 MKR Class and 2 MKP uses CC to Checkout from different Stores
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke1    full-run
    MKR|MKR CLASS|MKP|PIS|PISM    1|1|2|1|1    1|1|1|1|1|2    Credit Card    2

Guest - Hotfix Agile Verify - 1 MIK Product and 1 SDD Product and 1 MIK Class and 1 MKP and 1 MKR and 1 MKR Class with Gift Card
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-hotfix   full-run
    MIK|SDD|MIK CLASS|MKP|MKR|MKR CLASS    1|1|1|1|1|1    1|1|1|1|1|1    Gift Card



*** Keywords ***
Guest Checkout Work Flow Add To Cart
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
    ${Sku List}   ${Partial Urls}   Split Skus From Partial Url               ${Product Channel Info}
    Log To Console     ${Product Channel Info}

    ${Shipping Info}   ${Class Set Qty}   ${Multiple Store Address}    Add Products To Cart Process
    ...   ${Product Channel Info}    ${Qty Processed}    ${Store Amount}

    ${Handle AD Pop}   Run Keyword And Warn On Failure     Click Element      //div[text()='View My Cart']
    IF  '${Handle AD Pop}[0]' == 'FAIL'
        Go To   ${Home URL}/cart
    END
    # Shopping Cart Page
    # Wait until the loading sign disappears
    Wait Until Element Is Not Visible    //div[@class="css-1qbjk8g"]           ${Long Waiting Time}
    Wait Until Element Is Visible        //*[text()='Shopping Cart']
    Wait Until Element Is Enabled        //div[text()='PROCEED TO CHECKOUT']

    ${Cart Valid Error}   Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()="Sorry, a problem has occurred."]   5
    IF  '${Cart Valid Error}[0]' == 'PASS'
        Wait Until Element Is Enabled   //div[text()="CLOSE"]
        Click Element                   //div[text()="CLOSE"]
    END


    ${Mulit Store Check}   Pick Up Detection    ${Channel Mode}
    IF  '${Mulit Store Check}' != 'Non Pick Up'
        ${Store Name Set}  ${Address Collection}   Verify The Multiple Store Selection   ${Mulit Store Check}    ${Multiple Store Address}
        ...   ${Initial Store Name}
    END
    ${Zip Display}    Delivering To Zipcode Verify     Delivering to
    Log To Console   ${Zip Display}
    Verify Skus On Cart Page    ${Sku List}
    Run Keyword And Warn On Failure   Cart Verify Items Added and Subtotal Calculate   ${Items Count}   ${IF PIS}   ${Store Amount}
    ${Temp Cart}   Verify Calculation On The Order Summary Panel and Subtals Comparison    CART
    Verify Subtotal Items Correctness Compare Cart With Order Summary

    ${Cart List}   Extract Each Product Href Data In The Cart
    ${Cart List}   ${Product List}    Rearrange Lists    ${Cart List}    ${Partial Urls}
    Run Keyword And Warn On Failure   Should Be Equal    ${Cart List}    ${Product List}

    ${Shipping Info From Cart Page Rough}      Get Webelements            //div[@id='Selected Shipping']
    ${Shipping Info From Cart Page Refined}    Extract Shipping Info      ${Shipping Info From Cart Page Rough}
    ${Updated Shipping}       Remove Simple Ship To Me   ${Shipping Info}

    Run Keyword And Warn On Failure   Trending Now Exists
    Run Keyword And Warn On Failure   Shipping Align Based On PDP and Cart   ${Shipping Info From Cart Page Refined}   ${Updated Shipping}

    Wait Until Element Is Visible     //div[text()='PROCEED TO CHECKOUT']     ${Long Waiting Time}
    Click Element                     //div[text()='PROCEED TO CHECKOUT']
    Guest Continue Next Step As       GUEST


    # Get Your Order
    Wait Until Element Is Visible     //h2[text()='Getting your Order']    ${Long Waiting Time}

    Adding The Personal Infomation For the Getting Your Order Page         ${IF PIS}    ${Product Channel Info}    ${Class Set Qty}
    Sleep  1
    Edit Cart Items And Subtotal Items Comparison
    Wait Until Element Is Visible     //div[text()='Next: Payment & Order Review']     ${Mid Waiting Time}
    ${Payment Review}   Verify Calculation On The Order Summary Panel and Subtals Comparison    Payment Order Review
    Sleep  2

    ${USPS Verify}   ${USPS Trigger}   USPS Address Handling      Next: Payment & Order Review    ${Lose USPS Verify}   Use USPS Suggestion

    IF  '${USPS Verify}[0]' == 'PASS'
        Click Element    //div[text()="Save"]
    ELSE IF  '${USPS Trigger}[0]' == 'PASS'
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



