*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource    ../../Keywords/Checkout/Common.robot
Resource    ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Suite Setup   Run Keywords   initial env data2



*** Variables ***
&{buyer}     user=autoCpmUi1@xxxhi.cc    password=Password123


*** Test Cases ***
01-MIK-STM-Listing-CC-BY-SignIn
    [Documentation]    Buyer Buys 2 MIK Product STH item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run   yitest    ck-smoke
    [Template]   Buy Now Work Flow Sign In Buyer Slide Page
    MIK|listing|${MIK[2]}|2||STM|${EMPTY}    Buy Now    Credit Card

02-MIK-PIS-Listing-CC-BY-SignIn
    [Documentation]    Buyer Buys 1 MIK Product PIS item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
#    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run   yitest      ck-smoke
    [Template]   Buy Now Work Flow Sign In Buyer Slide Page
    MIK|listing|${PIS[2]}|1||PIS|Glade Parks,76039    Buy Now    Credit Card

03-MIK-SDD-Listing-CC-BY-SignIn
    [Documentation]    Buyer Buys 1 MIK Product SDD item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run   yitest     ck-smoke
    ${buyer}    Create Dictionary   user=autoCpmUi3@xxxhi.cc    password=Password123
    Set Test Variable   ${buyer}     ${buyer}
    Buy Now Work Flow Sign In Buyer Slide Page     MIK|listing|${SDD[2]}|1||SDD|MacArthur Park,75063    Buy Now    Credit Card

04-MKP-Listing-CC-BY-SignIn
    [Documentation]    Buyer Buys 1 EA Product STH item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run   yitest      ck-smoke
    [Template]   Buy Now Work Flow Sign In Buyer Slide Page
    MKP|listing|${MKP[0]}|1||STM|${EMPTY}    Buy Now    Credit Card

05-MKR-Listing-CC-BY-SignIn
    [Documentation]    Buyer Buys 1 FGM Product STH item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run   yitest    ck-smoke
    [Template]   Buy Now Work Flow Sign In Buyer Slide Page
    MKR|listing|${MKR[1]}|1||STM|${EMPTY}    Buy Now    Credit Card

06-MIK Class-CC-BY-SignIn
    [Documentation]    Buyer Buys 1 FGM Product STH item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
#    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run   yitest1     ck-smoke
    [Template]   Book class only work flow2
    MIK|class|${MIK CLASS[0]}|1|BCO||${EMPTY}    Buy Now    Credit Card

#06-MIK-MKR-Listing-CC-BY-SignIn
#    [Documentation]    Buyer Buys 1 MIK Product STH item and uses CC to Buy Now, signin in slide page
#    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
#    [Teardown]    Run Keyword    Close All Browsers
#    [Tags]    full-run   yitest
#    [Template]   Buy Now Work Flow Sign In Buyer Slide Page
#    MIK|class|${MIK CLASS[1]}|1||STM|${EMPTY}    Buy Now    Credit Card

*** Keywords ***
Buy Now Work Flow Sign In Buyer Slide Page
    [Arguments]     @{product_list}
    Select Products and Purchase Type-v2   ${product_list}     ${True}     ${False}

    Payment process   ${product_list[-2]}   ${product_list[-1]}    ${PRODUCT_INFO_LIST[0]}
    log    ${ORDER_NO}


Book class only work flow2
    [Arguments]      @{product_list}
#    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[city]
    Select Products and Select Purchase Type   ${product_list}
    login in slide page    ${buyer['user']}    ${buyer['password']}
    Sleep  3
    Click Book Class Only Button
    Buy Now Class - Input All Guest Info    ${ONE_PRODUCT_INFO}[product_type]
    Book Class Only Process
    log    ${ORDER_NO}