*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource    ../../Keywords/Checkout/Common.robot
Library    Collections

Suite Setup   Run Keywords   initial env data2
#Test Setup   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
Test Teardown     Run Keywords    clear cart if test case fail   AND    Close All Browsers

*** Variables ***



*** Test Cases ***
01 - MIK - STM - One Product - CC - Sign In Shopping Cart
    [Documentation]     Buyer Buys 1 MIK Product STH item and uses CC to Checkout, Sign in Shopping Cart
    [Tags]    ck-smoke   full-run
    [Setup]      Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]    Buyer Checkout Work Flow Sign In Shopping Cart
    MIK|listing|${MIK[1]}|1|ATC|STM|${EMPTY}    Add To Cart   Credit Card


02 - MIK Class - FGM Class - CC - Sign In Header
    [Documentation]     Add mik instore class and mik online class and fgm class to cart,and click sign in on header,checkout and placed order
    [Tags]    class
    [Setup]      Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]    Buyer Checkout Work Flow Sign In Header
    MIK|class|${MIK CLASS[0]}|2|ACTC||${EMPTY}    MIK|class|${MIK CLASS IN STORE[0]}|2|ACTC||${EMPTY}     MKR|class|${MKRS CLASS[0]}|1|ACTC||${EMPTY}
    ...     Add To Cart   Credit Card


03 - MIK Class - FGM Class - CC - Sign In
    [Documentation]     add an online class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    class
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Template]    Buyer Checkout Work Flow Paypal In Cart
    MIK|class|${MIK CLASS[0]}|2|ACTC||${EMPTY}    Add To Cart   Credit Card

04 - MIK Class - FGM Class - CC - Sign In
    [Documentation]     add an in-store class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    class
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Template]    Buyer Checkout Work Flow Paypal In Cart
    MIK|class|${MIK CLASS IN STORE[0]}|2|ACTC||${EMPTY}    Add To Cart   Credit Card


05 - MIK Class - FGM Class - CC - Sign In
    [Documentation]     add an in-store class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    class
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Template]    Buyer Checkout Work Flow Paypal In Cart
    MKR|class|${MKRS CLASS[1]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card


