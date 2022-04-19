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
    [Tags]   practice   credit
    MIK    1    1     Credit Card

Guest - Buyer Buys 1 MIK STH + 2x of 1 MIK STH item and uses PAYPAL to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   paypal
    MIK    2    1|2    Paypal

Guest - Buyer Buys 1 MIK Product BOPIS item and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    PIS    1    1      Credit Card

Guest - Buyer Buys 1 MIK Product BOPIS item from 2 different Stores and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    PISM   1    2      Credit Card    2

Guest - Buyer Buys 2x QTY of 1 MIK BOPIS item (Same Store) and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    PIS    1    2      Credit Card

Guest - Buyer Buys 1 x SDD and chooses GIFT CARD at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   gift
    SDD    1    1      Gift Card

Guest - Buyer Buys 4 different MIK Products, over $100, chooses SDD and uses CC at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    SDDH    4    1|1|1|1    Credit Card

Guest - Buyer Buys 1 MIK Product STH and 1 MIK Class from uses CC at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    MIK|MIK CLASS    1|1    1|1    Credit Card

Guest - Buyer Buys 1 MIK Product STH item, 1 BOPIS and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    MIK|PIS      1|1    1|1      Credit Card

Guest - Buyer Buys 2 Different MIK Product STH item, 4 different MIK Products SDD, under $50 and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    MIK|SDD    2|4    1|1|1|1|1|1      Credit Card

Guest - Buyer Buys 2 Different Marketplace Product from 1 Storefront and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    MKPS     2    1|1       Credit Card

Guest - Buyer Buys 1 Marketplace Product from 3 Different Storefronts and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    MKP      3    1|1|1     Credit Card

Guest - Buyer Buys 1 Makerplace Product and 1 Makerplace Class from the same store Storefront and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice1   credit
    MKRS|MKRS CLASS      1|1      1|1       Credit Card

Guest - Buyer Buys 1 Makerplace Product from 3 Different Storefronts and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    MKR                3        1|1|1     Credit Card

Guest - Buyer Buys 1 MIK Product STH and 1 Makerplace Product and 1 Marketplace Product and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice   credit
    MIK|MKR|MKP        1|1|1    1|1|1     Credit Card

Guest - Buyer Buys 2 different MIK Product and 1 MKR Product and 1 MKR Class and 2 MKP uses CC to Checkout from different Stores
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   practice1   credit
    MKR|MKR CLASS|MKP|PIS|PISM    1|1|2|1|1    1|1|1|1|1|2    Credit Card    2

Guest - Hotfix Agile Verify - 1 MIK Product and 1 SDD Product and 1 MIK Class and 1 MKP and 1 MKR and 1 MKR Class with Gift Card
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   agile-hotfix1   gift
    MIK|SDD|MIK CLASS|MKP|MKR|MKR CLASS    1|1|1|1|1|1    1|1|1|1|1|1    Gift Card

Guest - Hotfix Agile Verify - 1 MIK STH Product and 1 SDD Product Use CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   agile-hotfix   credit
    MIK|SDD    1|1    1|1   Credit Card

Guest - Hotfix Agile Verify - 1 MKP Product and 1 MKR Product Use Gift Card to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   agile-hotfix   gift
    MKP|MKR    1|1    1|1   Gift Card

Guest - Hotfix Agile Verify - 1 BOPIS with 3 Store Selection and 1 MIK Class Use Paypal to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   agile-hotfix   paypal
    PISM|MIK CLASS    1|1     2|1      Paypal    3

*** Keywords ***
Guest Checkout Work Flow Add To Cart
    [Arguments]    ${Channel Mode}   ${Items}   ${Qty}   ${Payment}    ${Store Amount}=1
    ${Address Collection}   Create List
    ${Qty Processed}        Qty Process               ${Qty}
    ${Items Count}          Calculate Items Count     ${Items}
    ${IF PIS}   ${IF MKR}   ${IF SDD}   Special Channel Detect    ${Channel Mode}

    ${Store Selection Needed}       Select Store Process                      ${Channel Mode}
    ${Store Address}                Select Store If Needed                    ${Initial Store Name}
    ${Refined Store Address}        Convert Store Address To Regular Space    ${Store Address}
    ${Product Channel Info}         Items Channel Dictionary Creation         ${Channel Mode}   ${Items}   ${TEST ENV}
    ${Sku List}   ${Partial Urls}   Split Skus From Partial Url               ${Product Channel Info}
    Log To Console     ${Product Channel Info}
    ${Shipping Info}   ${Class Set Qty}   ${Multiple Store Address}    Add Products To Cart Process
    ...   ${Product Channel Info}    ${Qty Processed}    ${Store Amount}

    ${Handle AD Pop}   Run Keyword And Warn On Failure    Click Element    //div[text()='View My Cart']
    IF  '${Handle AD Pop}[0]' == 'FAIL'
        Go To   ${Home URL}/cart
    END

    # Shopping Cart Page
    # Wait until the loading sign disappears
    Wait Until Page Does Not Contain Element     //*[@stroke="transparent"]
    Wait Until Element Is Visible                //*[text()='Shopping Cart']
    Wait Until Element Is Enabled                //div[text()='PROCEED TO CHECKOUT']

    ${Cart Valid Error}   Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()="Sorry, a problem has occurred."]   3
    IF  '${Cart Valid Error}[0]' == 'PASS'
        Wait Until Element Is Enabled   //div[text()="CLOSE"]
        Click Element                   //div[text()="CLOSE"]
    END

    ${Mulit Store Check}   Pick Up Detection    ${Channel Mode}
    IF  '${Mulit Store Check}' != 'Non Pick Up'
        ${Store Name Set}  ${Address Collection}   Verify The Multiple Store Selection   ${Mulit Store Check}    ${Multiple Store Address}
        ...   ${Initial Store Name}
    END
    ${Deliver to Element}   Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()="Delivering to "]    5
    IF  '${Deliver to Element}[0]' == 'PASS'
        ${ZipCode Updated}   Change ZipCode Adjust Different ZipCode      76039
    END
    Verify Skus On Cart Page    ${Sku List}
    Run Keyword And Warn On Failure   Cart Verify Items Added and Subtotal Calculate   ${Items Count}   ${IF PIS}   ${Store Amount}
    ${Temp Cart}   Verify Calculation On The Order Summary Panel and Subtals Comparison    CART
    #${Cart Res}    Verify Subtotal Items Correctness Compare Cart With Order Summary

    ${Cart List}   Extract Each Product Href Data In The Cart
    ${Cart List}   ${Product List}    Rearrange Lists    ${Cart List}    ${Partial Urls}
    Run Keyword And Warn On Failure   Should Be Equal    ${Cart List}    ${Product List}

    ${Shipping Info From Cart Page Rough}      Get Webelements            //div[@id='Selected Shipping']
    ${Shipping Info From Cart Page Refined}    Extract Shipping Info      ${Shipping Info From Cart Page Rough}
    ${Updated Shipping}    Remove Simple Ship To Me   ${Shipping Info}

    Run Keyword And Warn On Failure   Trending Now Exists
    Run Keyword And Warn On Failure   Shipping Align Based On PDP and Cart   ${Shipping Info From Cart Page Refined}   ${Updated Shipping}

    Wait Until Element Is Visible    //div[text()='PROCEED TO CHECKOUT']    ${Long Waiting Time}
    Click Element                    //div[text()='PROCEED TO CHECKOUT']
    Click Again If No Reaction       //div[text()='PROCEED TO CHECKOUT']    CONTINUE AS GUEST
    Guest Continue Next Step As      GUEST


    # Get Your Order
    Wait Until Element Is Visible     //h2[text()='Getting your Order']    ${Long Waiting Time}
    Sleep  2
    Adding The Personal Infomation For the Getting Your Order Page         ${IF PIS}    ${Product Channel Info}    ${Class Set Qty}
    ${CK One}   Edit Cart Items And Subtotal Items Comparison
    Run Keyword And Ignore Error    SDD Delivery Instructions     ${IF SDD}      ${Delivery Instruction}
    ${Compare Res}    Run Keyword And Ignore Error   Checkout Process - Qty And Price Calculation Compare with Subtotals
    Log To Console   ${Compare Res}
    ${Payment Review}   Verify Calculation On The Order Summary Panel and Subtals Comparison    Payment Order Review
    Sleep  2
    Wait Until Element Is Visible     //div[text()='Next: Payment & Order Review']     ${Mid Waiting Time}
    ${USPS Verify}   ${USPS Trigger}   USPS Address Handling      Next: Payment & Order Review    ${Lose USPS Verify}   Use USPS Suggestion   ${IF PIS}

    IF  '${USPS Verify}[0]' == 'PASS'
        Click Element    //div[text()="Save"]
    ELSE IF  '${USPS Trigger}[0]' == 'PASS'
        ${Updated ZipCode}   Use USPS Suggested Address    ${IF PIS}
    END
    # Click The Place Order
    Wait Until Element Is Enabled     //h2[text()='Payment & Order Review']    60
    Wait Until Element Is Enabled     //h3[text()="Payment Method"]            ${Long Waiting Time}
    ${CK Two}   Edit Cart Items And Subtotal Items Comparison
    SDD Instruction Verify   ${IF SDD}     ${Delivery Instruction}
    ${Place Order Total}     Verify Calculation On The Order Summary Panel and Subtals Comparison    PLACE ORDER
    ${Checkout Panel Stats}  Get All Relevant Number Before Placing Order
    ${Compare Res}    Run Keyword And Ignore Error   Checkout Process - Qty And Price Calculation Compare with Subtotals
    Log  ck_order_stats:${Checkout Panel Stats}

    Wait Until Element Is Visible        //p[text()='Edit Cart']
    ${Paypal Needed}     Payment Method Process    ${Payment}     ${IF PIS}
    IF  '${Payment}' != 'Paypal'
        Wait Until Element Is Enabled    //div[text()='PLACE ORDER']
        Sleep  2
        Click Element                    //div[text()='PLACE ORDER']
    ELSE
        Should Be Equal As Strings    ${Paypal Needed}    ${Place Order Total}
    END
#    ${HAR Log Result}   Har Log    ${Proxy}   ${Server}
    Sleep   2
    Page Should Not Contain Element            //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Not Visible          //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Visible              //h2[text()='Order Confirmation']       ${Long Waiting Time}
    ${Rough Order Number}    Get WebElements   //p[text()='ORDER NO. ']
    Should Not Be Empty      ${Rough Order Number[0].text}
    ${Extracted Number}      Number Extracted     ${Rough Order Number[0].text}
    SDD Instruction Verify   ${IF SDD}    ${Delivery Instruction}
    Log    ck_order_number:${Extracted Number}
    Log To Console    ${Extracted Number}
    Run Keyword And Warn On Failure     Placed Order Should Not Contain Red Icon     ${Cart Icon Element}
    Run Keyword And Warn On Failure     Guest Track My Order Process    ${Extracted Number}   ${Channel Mode}  ${Mulit Store Check}
    ...   ${Place Order Total}   ${IF PIS}   ${IF MKR}   ${Refined Store Address}   ${Updated ZipCode}   ${Address Collection}



