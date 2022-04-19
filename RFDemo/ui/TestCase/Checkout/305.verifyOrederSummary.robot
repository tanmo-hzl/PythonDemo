*** Settings ***
Resource    ../../TestData/EnvData.robot
Resource    ../../Keywords/Checkout/OrderSummaryKeywords.robot
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource    ../../Keywords/Checkout/BundleItemKeywords.robot
Resource    ../../Keywords/Checkout/verifyCartKeywords.robot

Suite Setup   Run Keywords   initial env data2
Test Teardown   Run Keywords    Clear Cart   AND    Close All Browsers

*** Variables ***
&{qa_tax_buyer}     email=tax_exempt_ui@snapmail.cc     password=TaxExempt123
...                first_name=Tax
&{stg_tax_buyer}     email=tst02non-tax@lista.cc     password=Test1234
...                first_name=non
&{tst_tax_buyer}     email=tax_exempt_tst@snapmail.cc    password=TaxExempt123
...                first_name=TSTtaxExempt
&{account_info}       first_name=${${env}_tax_buyer["first_name"]}
*** Test Cases ***
1.verify free tax states purchase goods duty-free-PIS_and_STM
    [Tags]    full-run     yitest
#    [Setup]  Clear Cart
    verify free tax fun      MIK|listing|${PIS[0]}|1|ATC|PIS|0     MKR|listing|${MKR[0]}|1|ATC||${EMPTY}
    ...    MIK|listing|${MIK[0]}|1|ATC|STM|0
    ...   Add To Cart   Credit Card

2.verify STM address no free tax states purchase goods duty-free
    [Tags]    full-run     yitest

    verify free tax fun      MIK|listing|${PIS[0]}|1|ATC|PIS|0     MKR|listing|${MKR[0]}|1|ATC||${EMPTY}
    ...    MIK|listing|${MIK[0]}|1|ATC|STM|0
    ...   Add To Cart   Credit Card     ship_address=tax     expect_tax=1.32


3.verify no free tax states purchase goods duty-free_PIS_and_STM
    [Tags]    full-run     yitest
    verify free tax fun      MIK|listing|${PIS[0]}|1|ATC|PIS|1     MKR|listing|${MKR[0]}|1|ATC||${EMPTY}
    ...    MIK|listing|${MIK[2]}|1|ATC|STM|0
    ...   Add To Cart   Credit Card        ship_address=tax        expect_tax=0.36

4.verify pick store no free tax states purchase goods duty-free
    [Tags]    full-run     yitest
    verify free tax fun      MIK|listing|${PIS[0]}|1|ATC|PIS|1     MKR|listing|${MKR[0]}|1|ATC||${EMPTY}
    ...    MIK|listing|${MIK[0]}|1|ATC|STM|0
    ...   Add To Cart   Credit Card     ship_address=no tax     expect_tax=$0.36    store_name=Southdale Shopping Center

#暂时不使用，不上线，没维护
#5.[Bundle] - GiftCard -When using a gift card, you must choose a credit card
#    [Documentation]   [Bundle] - GiftCard -When using a gift card, you must choose a credit card
#    [Tags]    full-run      yitest
##    [Arguments]
##    Open Browser       ${url_mik}   chrome
#    Login   ${${env}_tax_buyer["email"]}    ${${env}_tax_buyer["password"]}
#    clear cart
#    select a bundle product to cart    ${Bundle item[0]}|2|2|1|1
#    Click View My Cart Button
##        Run Keyword And Warn On Failure    check shopping cart    ${PRODUCT_INFO_LIST}
#    Click Proceed To Checkout Button
##    Add To Cart Payment Process    Credit Card
#    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
#    Wait Until Page Contains Element     //h2[text()="Getting your Order"]
#    Wait Until Element Is Visible    //h2[text()="Getting your Order"]
#    Wait Until Element Is Visible    //h3[text()="Order Summary"]
##    Run Keyword And Warn On Failure    check getting your order page    ${PRODUCT_INFO_LIST}
##    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
#    Click Next: Payment & Order Review Button
##    Run Keyword And Warn On Failure    check order review page    ${PRODUCT_INFO_LIST}
#    select payments method    Gift Card
#    check the order No. with add to cart
#
#6.[Bundle]-The same bundle at different items checkout successfully
#    [Documentation]   [Bundle] - The same SKU, skus in option are different, and the order is successful at the same time
#    [Tags]    full-run      yitest
##    [Arguments]
##    Open Browser       ${url_mik}   chrome
#    Login   ${${env}_tax_buyer["email"]}    ${${env}_tax_buyer["password"]}
#    clear cart
#    select a bundle product to cart    ${Bundle item[0]}|2|2|1|1
#    select a bundle product to cart    ${Bundle item[0]}|3|3|1|2
#    Click View My Cart Button
##        Run Keyword And Warn On Failure    check shopping cart    ${PRODUCT_INFO_LIST}
#    Click Proceed To Checkout Button
##    Add To Cart Payment Process    Credit Card
#    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
#    Wait Until Page Contains Element     //h2[text()="Getting your Order"]
#    Wait Until Element Is Visible    //h2[text()="Getting your Order"]
#    Wait Until Element Is Visible    //h3[text()="Order Summary"]
##    Run Keyword And Warn On Failure    check getting your order page    ${PRODUCT_INFO_LIST}
##    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
#    Click Next: Payment & Order Review Button
##    Run Keyword And Warn On Failure    check order review page    ${PRODUCT_INFO_LIST}
#    select payments method    Credit Card
#    check the order No. with add to cart



*** Keywords ***
verify free tax fun
    [Documentation]   Whether the harvest address is tax-free in the tax-free state, and whether the pickup store address is tax-free in the tax-free state
    [Arguments]    @{product_sku}     ${ship_address}=no tax        ${expect_tax}=0.0     ${store_name}=MacArthur Park
    Set Library Search Order    CustomSeleniumKeywords
    Login   ${${env}_tax_buyer["email"]}    ${${env}_tax_buyer["password"]}
    Select Store If Needed     MacArthur Park
#    select a store-state    tx    md=Southdale Shopping Center
    Clear Cart
    ${store}       Create Dictionary     store_name=${store_name}      zipcode=65039
    Set Test Variable    ${store2_info}    ${store}
#    ${product_list}    Create List     MIK|listing|${MIK[0]}|1|ATC|PIS|1     MKR|listing|${MKR[0]}|1|ATC||${EMPTY}
#    ...    MIK|listing|${MIK[1]}|1|ATC|PIS|1
#    ...   Add To Cart   Credit Card
    Select Products and Purchase Type   ${product_sku}
    Click View My Cart Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]     ${Long Waiting Time}
    ${cart_bug}   Run Keyword And Ignore Error     Wait Until Element Is Visible    //p[text()="Remove All Items"]
    IF  "${cart_bug[0]}"=="FAIL"
        Reload Page
    END
    Close Cart Initiate Error popup
    Click Proceed To Checkout Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Page Contains Element     //h2[text()="Getting your Order"]
    Wait Until Element Is Visible   //h2[text()="Getting your Order"]
    Wait Until Element Is Visible    //h3[text()="Order Summary"]
    select tax address    ${ship_address}
    Wait Until Element Is Visible    //div[text()="Next: Payment & Order Review"]
    ${data}     get order summary data
    Click Element  //div[text()="Next: Payment & Order Review"]
    Sleep  1
    Wait Until Element Is Visible    //div[text()="PLACE ORDER"]
    ${data1}     get order summary data
    log    ${data1["Estimated Tax"]}
    IF  "0.0" == "${expect_tax}"
        Should Be Equal As Strings    ${data1["Estimated Tax"]}     ${expect_tax}
    ELSE IF   "0.0" != "${expect_tax}"
        Should Not Be Equal As Strings    ${data1["Estimated Tax"]}     "0.0"
    END



