*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Library    Collections

Suite Setup   Run Keywords   initial env data2
#Test Teardown     Run Keywords    clear cart if test case fail   AND    Close All Browsers
Test Teardown   Run Keywords    clear cart   AND    Close All Browsers

*** Variables ***



*** Test Cases ***

01-SignIn - MKR - Two Products - CC
    [Documentation]    Buyer Buys 1 Makerplace Product and 1 Makerplace Class from the same store Storefront and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info    ${buyer4['user']}    ${buyer4['password']}      AND   clear cart
    [Tags]    ck-smoke     full-run
    ${ENV}    Lower Parameter    ${ENV}
    IF    "${ENV}" != "qa"
        Skip   non qa env skip this test case
    END
    Buyer Checkout Work Flow    MKR|listing|${MKRS[0]}|1|ATC||${EMPTY}     MKR|class|${MKRS CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart    Credit Card


02-SignIn - MKR - Three Products - CC
    [Documentation]    Buyer Buys 1 Makerplace Product from 3 Different Storefronts and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info     ${buyer4['user']}    ${buyer4['password']}    AND   clear cart
    [Tags]    ck-smoke     full-run
    ${ENV}    Lower Parameter    ${ENV}
    IF    "${ENV}" != "qa"
        Skip   non qa env skip this test case
    END
    Buyer Checkout Work Flow    MKR|listing|${MKR[0]}|1|ATC||${EMPTY}     MKR|listing|${MKR[1]}|1|ATC||${EMPTY}     MKR|listing|${MKR[2]}|1|ATC||${EMPTY}    Add To Cart    Credit Card


03-SignIn - MIK-MKR-MKP - Three Products - CC
    [Documentation]    Buyer Buys 1 MIK Product STH and 1 Makerplace Product and 1 Marketplace Product and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   ${buyer4['user']}    ${buyer4['password']}    AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}     MKR|listing|${MKR[0]}|1|ATC||${EMPTY}     MKP|listing|${MKP[1]}|1|ATC||${EMPTY}
    ...   Add To Cart   Credit Card


04-SignIn - MIK-MKR-MKP - Six Products - CC
    [Documentation]    Buyer Buys 2 different MIK Product from different Stores  and 1 Makerplace Product and 1 Makerplace Class from different Makerplace Storefronts and
    ...                2 Marketplace Product  from different Storefronts and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer4['user']}    ${buyer4['password']}     AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0     MIK|listing|${PIS[1]}|1|ATC|PIS|1   MKR|class|${MKR CLASS[0]}|1|ACTC||${EMPTY}
    ...    MKR|listing|${MKR[0]}|1|ATC||${EMPTY}    MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    MKP|listing|${MKP[2]}|1|ATC||${EMPTY}
    ...    Add To Cart   Credit Card


05-SignIn - MIK-MKP - Two Products - CC
    [Documentation]    Buyer Buys 1 x SDD and 1 x EA product chooses Paypal at Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer4['user']}    ${buyer4['password']}    AND    clear cart
    [Tags]    ck-smoke     full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|1|ATC|SDD|${EMPTY}     MKP|listing|${MKP[0]}|1|ATC||${EMPTY}     Add To Cart    Paypal


06-MIK-STM-One Product-CC-Sign In Shopping Cart
    [Documentation]     Buyer Buys 1 MIK Product STH item and uses CC to Checkout, Sign in Shopping Cart
    [Tags]    ck-smoke   full-run
    [Setup]      Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]    Buyer Checkout Work Flow Sign In Shopping Cart
    MIK|listing|${MIK[1]}|1|ATC|STM|${EMPTY}    Add To Cart   Credit Card


07-MIK Class-FGM Class-CC-Sign In Header
    [Documentation]     Add mik instore class and mik online class and fgm class to cart,and click sign in on header,checkout and placed order
    [Tags]    full-run
    [Setup]      Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]    Buyer Checkout Work Flow Sign In Header
    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}    MIK|class|${MIK CLASS IN STORE[0]}|1|ACTC||${EMPTY}     MKR|class|${MKRS CLASS[0]}|1|ACTC||${EMPTY}
    ...     Add To Cart   Credit Card