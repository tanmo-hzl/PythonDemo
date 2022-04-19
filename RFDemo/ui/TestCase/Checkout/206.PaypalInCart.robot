
*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Library    Collections

Suite Setup   Run Keywords   initial env data2
Test Teardown     Run Keywords    clear cart if test case fail   AND    Close All Browsers

*** Variables ***
&{buyer11}       user=neivi128@snapmail.cc               password=Aa123456


*** Test Cases ***

01-Sign In-MIK Online Class-Paypal in cart
    [Documentation]     [Sign In]add a MIK online class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    full-run
    [Setup]    Run Keywords   Login and change store    ${buyer11['user']}    ${buyer11['password']}     AND    clear cart
    [Template]    Buyer Checkout Work Flow Paypal In Cart
    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card

02-Sign In-MIK In-store Class-Paypal in cart
    [Documentation]     [Sign In]add a MIK in-store class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    full-run
    [Setup]    Run Keywords   Login and change store    ${buyer11['user']}    ${buyer11['password']}     AND    clear cart
    [Template]    Buyer Checkout Work Flow Paypal In Cart
    MIK|class|${MIK CLASS IN STORE[0]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card


03-Sign In-MKR Class-Paypal in cart
    [Documentation]     [Sign In]add a MKR class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    full-run
    [Setup]    Run Keywords   Login and change store    ${buyer11['user']}    ${buyer11['password']}     AND    clear cart
    [Template]    Buyer Checkout Work Flow Paypal In Cart
    MKR|class|${MKRS CLASS[1]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card


04-Guest-MIK Online Class-Paypal in cart
    [Documentation]     [Guest]add an online class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    full-run
    [Setup]    Run Keyword   Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]    Guest Checkout Work Flow Paypal In Cart
    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card

05-Guest-MIK In store Class-Paypal in cart
    [Documentation]     [Guest]add an in-store class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    full-run
    [Setup]    Run Keyword   Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     Guest Checkout Work Flow Paypal In Cart
    MIK|class|${MIK CLASS IN STORE[0]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card


06-Guest-MIK Class-FGM Class-Paypal in cart
    [Documentation]     [Guest]add an in-store class to cart,click"paypal checkout">sign in>pay now,palced order
    [Tags]    full-run
    [Setup]    Run Keyword   Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]    Guest Checkout Work Flow Paypal In Cart
    MKR|class|${MKRS CLASS[1]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card