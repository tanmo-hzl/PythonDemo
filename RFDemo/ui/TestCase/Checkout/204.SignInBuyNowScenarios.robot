*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource    ../../Keywords/Checkout/InventoryAPIKeywords.robot
#Resource    ../../Keywords/Checkout/Common.robot



Suite Setup   Run Keywords   initial env data2
#Suite Teardown    Close Browser
#Test Setup    Run Keywords   Login and change store    AND    clear cart

*** Variables ***
&{buyer5}       user=abc190@snapmail.cc
...             password=Aa123456

&{buyer6}       user=neivi123@snapmail.cc
...             password=Aa123456


&{buyer10}      user=neivi127@snapmail.cc
...             password=Aa123456

&{buyer12}      user=neivi129@snapmail.cc
...             password=Aa123456

&{billAddress1}    firstName=MO
...               lastName=DD
...               addressLine1=2435 Marfa Ave
...               state=TX
...               city=Dallas
...               zipCode=75216
...               phoneNumber=469-779-6009





*** Test Cases ***

01-SignIn-MIK-Listing-STH-CC-BY
    [Documentation]    Buyer Buys 1 MIK Product STH with Item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info    ${buyer10['user']}    ${buyer10['password']}   AND    clear cart
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|BY|STM|${EMPTY}    Buy Now    Credit Card


02-SignIn-MIK-Listing-PIS-CC-BY
    [Documentation]    Buyer Buys 2x Qty of 1 MIK Product BOPIS item and uses CC to Buy Now
    [Setup]    Run Keywords   Login and change store     ${buyer10['user']}    ${buyer10['password']}    AND    clear cart
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|2|BY|PIS|0    Buy Now    Credit Card


03-SignIn-MIK-Listing-SDD-CC-BY
    [Documentation]    Buyer Buys 1 SDD and chooses CC at Buy Now
    [Setup]    Run Keywords   Login and change store    ${buyer10['user']}    ${buyer10['password']}    AND    clear cart
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|1|BY|SDD|${EMPTY}    Buy Now    Credit Card


04-SignIn-MIK-Class-CC-BY
    [Documentation]    Buyer Buys 1 MIK Class and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info    ${buyer10['user']}    ${buyer10['password']}    AND    clear cart
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|class|${MIK CLASS[0]}|1|BCO||${EMPTY}    Book Class Only    Credit Card


05-SignIn-MKP-Listing-CC-BY
    [Documentation]    Buyer Buys 1 MKP Product item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info    ${buyer10['user']}    ${buyer10['password']}    AND    clear cart
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MKP|listing|${MKP[2]}|1|BY||${EMPTY}    Buy Now    Credit Card


06-SignIn-MIK-Listing-STH-CC-BY
    [Documentation]    [no default address] Buyer Buys 1 MIK Product STH with Item and uses CC to Buy Now
    [Setup]    Run Keywords    Login    ${buyer5['user']}    ${buyer5['password']}     AND    clear cart
    [Teardown]    Run Keywords     Delete default address     ${guestInfo}[addressLine1]     AND     Close All Browsers
#    [Setup]    Run Keywords     CK Buyer login    ${buyer5}[user]     ${buyer5}[password]    AND    Login    ${buyer5['user']}    ${buyer5['password']}
#    [Teardown]    Run Keywords     Delete User Address    AND     Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Sign-in buy now work flow no default address
    ${guestInfo}     MIK|listing|${MIK[0]}|1|BY|STM|${EMPTY}    Buy Now    Credit Card


07-SignIn-MIK-Listing-SDD-CC-BY
    [Documentation]    [no default address] Buyer Buys 1 SDD and chooses CC at Buy Now
    [Setup]    Run Keywords    Login    ${buyer5['user']}    ${buyer5['password']}    AND    clear cart
    [Teardown]    Run Keywords     Delete default address     ${guestInfo}[addressLine1]     AND     Close All Browsers
#    [Setup]    Run Keywords     CK Buyer login    ${buyer5}[user]     ${buyer5}[password]    AND    Login    ${buyer5['user']}    ${buyer5['password']}
#    [Teardown]    Run Keywords     Delete User Address    AND     Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Sign-in buy now work flow no default address
    ${guestInfo}     MIK|listing|${SDD[0]}|1|BY|SDD|${EMPTY}    Buy Now    Credit Card


08-SignIn-MIK-Listing-PIS-CC-BY
    [Documentation]    [no default address] Buyer Buys 2x Qty of 1 MIK Product BOPIS item and uses CC to Buy Now
    [Setup]    Run Keywords    Login    ${buyer5['user']}    ${buyer5['password']}    AND    clear cart
    [Teardown]    Run Keyword     Close All Browsers
    [Tags]    ck-smoke    full-run
    [Template]   Sign-in buy now work flow no default address
    ${guestInfo}     MIK|listing|${PIS[0]}|2|BY|PIS|${EMPTY}    Buy Now    Credit Card


09-SignIn-MIK-class-CC-BY
    [Documentation]    [no credit card] Buyer Buys 2x Qty 1 MIK Class and uses CC to Buy Now
    [Setup]    Run Keywords    CK Buyer login    ${buyer12}[user]     ${buyer12}[password]    AND    Login    ${buyer12['user']}    ${buyer12['password']}
    ...        AND    clear cart
    [Teardown]     Run Keywords     Delete a Credit Card   AND   Close All Browsers
    [Tags]    ck-smoke    full-run
    @{product_list}     Create List     MIK|class|${MIK CLASS[0]}|2|BCO||${EMPTY}     Book Class Only    Credit Card
    Select Products and Select Purchase Type   ${product_list}
    Add payment credit card in slide page      ${creditInfo}     ${billAddress1}
    Buy Now Class - Input All Guest Info    ${ONE_PRODUCT_INFO}[product_type]
    Book Class Only Process


99-SignIn-MIK-class-CC-BY
    [Documentation]    [no credit card] Buyer Buys 2x Qty 1 MIK Class and uses CC to Buy Now
    [Setup]    Run Keyword    CK Buyer login    neivi129@snapmail.cc     Aa123456
    [Teardown]     Run Keywords     Delete a Credit Card   AND   Close All Browsers
    [Tags]    delete-cc
    @{product_list}     Create List     MIK|class|${MIK CLASS[0]}|2|BCO||${EMPTY}     Book Class Only    Credit Card


10-SignIn-MKR-Listing-CC-BY
    [Documentation]    Buyer Buys 1 MKR Product item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info    ${buyer10['user']}    ${buyer10['password']}    AND    clear cart
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MKR|listing|${MKRS[0]}|1|BY||${EMPTY}    Buy Now    Credit Card


11-SignIn-MKR-Class-CC-BY
    [Documentation]    Buyer Buys 1 MKR Class item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info    ${buyer10['user']}    ${buyer10['password']}    AND    clear cart
    [Teardown]    Run Keywords     Update default address    AND    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MKR|class|${MKRS CLASS[0]}|1|BCO||${EMPTY}    Book Class Only    Credit Card


12-MIK-STM-Listing-CC-BY-SignIn
    [Documentation]    Buyer Buys 1 MIK Product STH item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Buy Now Work Flow Sign In Slide Page
    MIK|listing|${MIK[2]}|1|BY||${EMPTY}    Buy Now    Credit Card


#13-MIK-Class-CC-BY-SignIn
#    [Documentation]    click"book class only",input right"email"and"password",click"sign in",will in PDP,click"book class only"again to place order
#    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
#    [Teardown]    Run Keyword    Close All Browsers
#    [Tags]    full-run
#    [Template]      Book class only work flow2
#    MIK|class|${MIK CLASS[0]}|1|BCO||${EMPTY}    Book Class Only    Credit Card



13-MIK-Class-CC-BY-SignIn
    [Documentation]    click"book class only",input incorrect"email"or"password",will give promot
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    @{product_list}     Create List      MIK|class|${MIK CLASS[0]}|1|BCO||${EMPTY}    Book Class Only    Credit Card
    Select Products and Select Purchase Type   ${product_list}
    login in slide page    ${buyer10['user']}    aaaaa
    Check sign in error promot


14-SignIn-MIK-Two or More Class-CC-BY
    [Documentation]    [Class] - Book class only - if book 2 or more classes,will need 2 or more guest info,and those info can the same
    [Setup]    Run Keywords    Login and get account info    ${buyer10['user']}    ${buyer10['password']}
    ...    AND    clear cart    AND    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]     Book Class With Same Guest Info
    MIK|class|${MIK CLASS[0]}|2|BCO||${EMPTY}    Book Class Only    Credit Card
    MIK|class|${MIK CLASS[0]}|3|BCO||${EMPTY}    Book Class Only    Credit Card


15-Add coupon code in buy now
    [Documentation]    Buy_now - add coupon code to apply buys mik item,should work normally
    [Setup]    Run Keywords    Login and get account info    ${buyer10['user']}    ${buyer10['password']}    AND    clear cart
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    @{product_list}     Create List      MIK|listing|${PIS[0]}|1|BY||${EMPTY}    Buy Now    ${EMPTY}
    Select Products and Select Purchase Type   ${product_list}
    Add a coupon code     22MADEBYYOU



*** Keywords ***

Check sign in error promot
    Wait Until Element Is Visible     //h3[text()="Sign in"]/following-sibling::p
    ${error_message}    Get Text    //h3[text()="Sign in"]/following-sibling::p
    Should Be Equal As Strings       ${error_message}     The email or password you entered did not match our record. Please double-check and try again.


Delete address
    Go To    ${HOME URL}/buyertools/profile
    Wait Until Page Contains Element

Add a coupon code
    [Arguments]    ${coupon_code}
    Wait Until Element Is Visible    //div[text()="Add a Promo Code"]
    Click Element    //div[text()="Add a Promo Code"]
    Input Text     //input[@id="promoCode"]     ${coupon_code}
    Wait Until Page Contains Element     //div[text()="Apply"]/..
    Click Element     //div[text()="Apply"]/..
    Wait Until Page Contains Element      //p[text()="${coupon_code}"]
    Wait Until Page Contains Element      //p[text()="Savings"]



Book class only work flow2
    [Arguments]      @{product_list}
    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    Select Products and Select Purchase Type   ${product_list}
    login in slide page    ${buyer6['user']}    ${buyer6['password']}
    Click Book Class Only Button
    Buy Now Class - Input All Guest Info    ${ONE_PRODUCT_INFO}[product_type]
    Book Class Only Process
    log    ${ORDER_NO}


Sign-in buy now work flow no default address
    [Arguments]      ${consignee}    @{product_list}
    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    Select Products and Select Purchase Type   ${product_list}
    ${IF PIS}    Input Guest Info In Get Your Order     ${pickupInfo}     ${consignee}
    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    Wait Until Element Is Visible     //div[text()='Next: Payment & Order Review']     ${Long Waiting Time}
    ${USPS Verify}   ${USPS Trigger}   USPS Address Handling      Next: Payment & Order Review    ${Lose USPS Verify}   Use USPS Suggestion
    IF  '${USPS Verify}[0]' == 'PASS'
        Click Element    //div[text()="Save"]
    ELSE IF  '${USPS Trigger}[0]' == 'PASS'
        ${Updated ZipCode}    Use USPS Suggested Address    ${IF PIS}
    END
    Wait Until Element Is Visible     //h2[text()='Payment & Order Review']    ${Long Waiting Time}
    Wait Until Element Is Visible     //h3[text()="Payment Method"]            ${Long Waiting Time}
    ${Checkout Panel Stats}  Get All Relevant Number Before Placing Order
    Log    ck_order_stats:${Checkout Panel Stats}
    ${is_credit_card}   Run Keyword And Warn On Failure     Wait Until Element Is Visible     //p[text()="Default Payment method"]    5
    IF   "${is_credit_card}" == "FAIL"
        Payment Method Process    ${product_list[-1]}    ${IF PIS}    ${Paypay Amount}
    END
    IF  '${product_list[-1]}' != 'Paypal'
        Wait Until Element Is Enabled    //div[text()='PLACE ORDER']
        Sleep  2
        Click Element                    //div[text()='PLACE ORDER']
    ELSE
        Should Be Equal As Strings    ${Paypal Needed}    ${Place Order Total}
    END
    Sleep   4
    Page Should Not Contain Element            //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Not Visible          //h3[text()="Unable to Process Payment"]
    Wait Until Element Is Visible              //h2[text()='Order Confirmation']       ${Long Waiting Time}
    ${Rough Order Number}    Get WebElements   //p[text()='ORDER NO. ']
    Should Not Be Empty      ${Rough Order Number[0].text}
    ${Extracted Number}      Number Extracted     ${Rough Order Number[0].text}
    Log    ck_order_number:${Extracted Number}



Delete a Credit Card
    ${res}    Get Credit Card - GET
    ${bank_card_id}    Set Variable     ${res[0]}[bankCardId]
    IF   "${bank_card_id}" != "${EMPTY}"
        Delete Credit Card - DELETE     ${bank_card_id}
    END


