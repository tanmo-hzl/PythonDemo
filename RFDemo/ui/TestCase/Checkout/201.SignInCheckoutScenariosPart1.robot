*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource    ../../Keywords/Checkout/InventoryAPIKeywords.robot


Suite Setup   Run Keywords   initial env data2    AND    CK Buyer login    ${buyer}[user]     ${buyer}[password]
Test Teardown   Run Keywords    clear cart if test case fail    AND    Close All Browsers
#Test Teardown   Run Keywords    clear cart   AND    Close All Browsers


*** Variables ***

*** Test Cases ***

01-SignIn - MIK - STM - One Product - CC
    [Documentation]    Buyer Buys 1 MIK Product STH item and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   ${buyer['user']}    ${buyer['password']}    AND   clear cart
    [Tags]    ck-smoke    full-run  multi-user
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    Credit Card


02-SignIn - MIK - STM - Three Products - Paypal
    [Documentation]    Buyer Buys 1 MIK STH + 2x of 1 MIK STH item and uses PAYPAL to Checkout
    [Setup]    Run Keywords    Login and get account info   ${buyer['user']}    ${buyer['password']}      AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    MIK|listing|${MIK[1]}|2|ATC|STM|${EMPTY}    Add To Cart   Paypal


03-SignIn - MIK - PIS - One Product - CC
    [Documentation]    Buyer Buys 1 MIK Product BOPIS item and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer['user']}    ${buyer['password']}    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0    Add To Cart   Credit Card


04-SignIn - MIK - PIS - Two Products - CC
    [Documentation]    Buyer Buys 1 MIK Product BOPIS item from 2 different Stores and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer['user']}    ${buyer['password']}    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0    MIK|listing|${PIS[0]}|1|ATC|PIS|1    Add To Cart   Credit Card


05-SignIn - MIK - PIS - Two Products - CC
    [Documentation]    Buyer Buys 2x QTY of 1 MIK BOPIS item (Same Store) and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer['user']}    ${buyer['password']}    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[2]}|2|ATC|PIS|0    Add To Cart   Credit Card


06-SignIn - MIK - SDD - One Product - Gift Card
    [Documentation]    Buyer Buys 1 x SDD and chooses GIFT CARD at Checkout
    [Setup]    Run Keywords   Init User Gift Card    AND    Login and change store    ${buyer['user']}    ${buyer['password']}     AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|1|ATC|SDD|${EMPTY}    Add To Cart    Gift Card







