*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot


Suite Setup   Run Keywords   initial env data2
#Test Teardown   Run Keywords    clear cart if test case fail   AND    Close All Browsers
Test Teardown   Run Keywords    clear cart   AND    Close All Browsers

*** Variables ***

*** Test Cases ***

01-SignIn - MIK - SDD - Four Products - CC
    [Documentation]    Buyer Buys 4 different MIK Products, over $100, chooses SDD and uses CC at Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer3['user']}    ${buyer3['password']}    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDDH[0]}|1|ATC|SDD|${EMPTY}    MIK|listing|${SDDH[1]}|1|ATC|SDD|${EMPTY}     MIK|listing|${SDDH[2]}|1|ATC|SDD|${EMPTY}
    ...   MIK|listing|${SDDH[3]}|1|ATC|SDD|${EMPTY}    Add To Cart    Credit Card


02-SignIn - MIK - STM - Class - Two Products - CC
    [Documentation]    Buyer Buys 1 MIK Product STM and 1 MIK Class from uses CC at Checkout
    [Setup]    Run Keywords    Login and get account info    ${buyer3['user']}    ${buyer3['password']}     AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[1]}|1|ATC|STM|${EMPTY}    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card



03-SignIn - MIK - STM - PIS - Two Products - CC
    [Documentation]    Buyer Buys 1 MIK Product STM item, 1 BOPIS and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer3['user']}    ${buyer3['password']}    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PISM[1]}|1|ATC|PIS|0    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart   Credit Card


04-SignIn - MIK - STM - PIS - Six Products- CC
    [Documentation]    Buyer Buys 2 Different MIK Product STH item, 4 different MIK Products SDD, under $50 and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer3['user']}    ${buyer3['password']}    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[1]}|1|ATC|STM|${EMPTY}     MIK|listing|${MIK[2]}|1|ATC|STM|${EMPTY}    MIK|listing|${SDD[0]}|1|ATC|SDD|${EMPTY}
    ...   MIK|listing|${SDD[1]}|1|ATC|SDD|${EMPTY}    MIK|listing|${SDD[2]}|1|ATC|SDD|${EMPTY}    MIK|listing|${SDD[3]}|1|ATC|SDD|${EMPTY}
    ...   Add To Cart    Credit Card


05-SignIn - MKP - Two Products - CC
    [Documentation]    Buyer Buys 2 Different Marketplace Product from 1 Storefront and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   ${buyer3['user']}    ${buyer3['password']}    AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MKP|listing|${MKPS[0]}|1|ATC||${EMPTY}     MKP|listing|${MKPS[1]}|1|ATC||${EMPTY}    Add To Cart    Credit Card


06-SignIn - MKP - Three Products - CC
    [Documentation]    Buyer Buys 1 Marketplace Product from 3 Different Storefronts and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   ${buyer3['user']}    ${buyer3['password']}    AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MKP|listing|${MKP[0]}|1|ATC||${EMPTY}     MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    MKP|listing|${MKP[2]}|1|ATC||${EMPTY}
    ...   Add To Cart    Credit Card


07-SignIn - MIK-MKP - Three Products - Paypal
    [Documentation]    Buyer Buys 1 x PIS and 1 x STM and 1 x MKP, and chooses Paypal at Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer3['user']}    ${buyer3['password']}    AND    clear cart
    [Tags]    ck-hotfix
    [Template]     Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0     MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}     MKP|listing|${MKP[0]}|1|ATC||${EMPTY}    Add To Cart    Paypal


08-SignIn - MKR-MIK - Three Products - CC
    [Documentation]    Buyer Buys 1 x MKR and 1 x MKR class and 1 x MIK class, and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    ${buyer3['user']}    ${buyer3['password']}    AND    clear cart
    [Tags]    ck-hotfix
    [Template]     Buyer Checkout Work Flow
    MKR|listing|${MKR[0]}|1|ATC||${EMPTY}    MKR|class|${MKRS CLASS[0]}|1|ACTC||${EMPTY}    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart    Credit Card




