*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot


Suite Setup   Run Keywords   initial env data2
#Suite Teardown    Close Browser
#Test Setup    Run Keywords   Login and change store    AND    clear cart
Test Teardown   Run Keywords    clear cart if test case fail   AND    Close All Browsers

*** Variables ***

*** Test Cases ***

01-SignIn - MIK - STM - One Product - CC
    [Documentation]    Buyer Buys 1 MIK Product STH item and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    Credit Card


02-SignIn - MIK - STM - Three Products - Paypal
    [Documentation]    Buyer Buys 1 MIK STH + 2x of 1 MIK STH item and uses PAYPAL to Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    MIK|listing|${MIK[1]}|2|ATC|STM|${EMPTY}    Add To Cart   Paypal


03-SignIn - MIK - PIS - One Product - CC
    [Documentation]    Buyer Buys 1 MIK Product BOPIS item and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0    Add To Cart   Credit Card


04-SignIn - MIK - PIS - Two Products - CC
    [Documentation]    Buyer Buys 1 MIK Product BOPIS item from 2 different Stores and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0    MIK|listing|${PIS[0]}|1|ATC|PIS|1    Add To Cart   Credit Card


05-SignIn - MIK - PIS - Two Products - CC
    [Documentation]    Buyer Buys 2x QTY of 1 MIK BOPIS item (Same Store) and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[2]}|2|ATC|PIS|0    Add To Cart   Credit Card


06-SignIn - MIK - SDD - One Product - Gift Card
    [Documentation]    Buyer Buys 1 x SDD and chooses GIFT CARD at Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|1|ATC|SDD|${EMPTY}    Add To Cart    Gift Card


07-SignIn - MIK - SDD - Four Products - CC
    [Documentation]    Buyer Buys 4 different MIK Products, over $100, chooses SDD and uses CC at Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|1|ATC|SDD|${EMPTY}    MIK|listing|${SDD[1]}|1|ATC|SDD|${EMPTY}     MIK|listing|${SDDH[0]}|1|ATC|SDD|${EMPTY}
    ...   MIK|listing|${SDD[3]}|1|ATC|SDD|${EMPTY}    Add To Cart    Credit Card


08-SignIn - MIK - STM - Class - Two Products - CC
    [Documentation]    Buyer Buys 1 MIK Product STM and 1 MIK Class from uses CC at Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[1]}|1|ATC|STM|${EMPTY}    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart   Credit Card


09-SignIn - MIK - STM - PIS - Two Products - CC
    [Documentation]    Buyer Buys 1 MIK Product STM item, 1 BOPIS and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PISM[1]}|1|ATC|PIS|0    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart   Credit Card


10-SignIn - MIK - STM - PIS - Six Products- CC
    [Documentation]    Buyer Buys 2 Different MIK Product STH item, 4 different MIK Products SDD, under $50 and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[1]}|1|ATC|STM|${EMPTY}     MIK|listing|${MIK[2]}|1|ATC|STM|${EMPTY}    MIK|listing|${SDD[0]}|1|ATC|SDD|${EMPTY}
    ...   MIK|listing|${SDD[1]}|1|ATC|SDD|${EMPTY}    MIK|listing|${SDD[2]}|1|ATC|SDD|${EMPTY}    MIK|listing|${SDD[3]}|1|ATC|SDD|${EMPTY}
    ...   Add To Cart    Credit Card


11-SignIn - MKP - Two Products - CC
    [Documentation]    Buyer Buys 2 Different Marketplace Product from 1 Storefront and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MKP|listing|${MKPS[0]}|1|ATC||${EMPTY}     MKP|listing|${MKPS[1]}|1|ATC||${EMPTY}    Add To Cart    Credit Card


12-SignIn - MKP - Three Products - CC
    [Documentation]    Buyer Buys 1 Marketplace Product from 3 Different Storefronts and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MKP|listing|${MKP[0]}|1|ATC||${EMPTY}     MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    MKP|listing|${MKP[2]}|1|ATC||${EMPTY}
    ...   Add To Cart    Credit Card


13-SignIn - MKR - Two Products - CC
    [Documentation]    Buyer Buys 1 Makerplace Product and 1 Makerplace Class from the same store Storefront and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MKR|listing|${MKRS[0]}|1|ATC||${EMPTY}     MKR|class|${MKRS CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart    Credit Card


14-SignIn - MKR - Three Products - CC
    [Documentation]    Buyer Buys 1 Makerplace Product from 3 Different Storefronts and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MKR|listing|${MKR[0]}|1|ATC||${EMPTY}     MKR|listing|${MKR[1]}|1|ATC||${EMPTY}     MKR|listing|${MKR[2]}|1|ATC||${EMPTY}    Add To Cart    Credit Card


15-SignIn - MIK-MKR-MKP - Three Products - CC
    [Documentation]    Buyer Buys 1 MIK Product STH and 1 Makerplace Product and 1 Marketplace Product and uses CC to Checkout
    [Setup]    Run Keywords    Login and get account info   AND   clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}     MKR|listing|${MKR[0]}|1|ATC||${EMPTY}     MKP|listing|${MKP[1]}|1|ATC||${EMPTY}
    ...   Add To Cart   Credit Card


16-SignIn - MIK-MKR-MKP - Six Products - CC
    [Documentation]    Buyer Buys 2 different MIK Product from different Stores  and 1 Makerplace Product and 1 Makerplace Class from different Makerplace Storefronts and
    ...                2 Marketplace Product  from different Storefronts and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0     MIK|listing|${PIS[1]}|1|ATC|PIS|1   MKR|class|${MKR CLASS[0]}|1|ACTC||${EMPTY}
    ...    MKR|listing|${MKR[0]}|1|ATC||${EMPTY}    MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    MKP|listing|${MKP[2]}|1|ATC||${EMPTY}
    ...    Add To Cart   Credit Card


17-SignIn - MIK - One Product - CC
    [Documentation]    Buyer Buys 1 x SDD and chooses Paypal at Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-smoke     full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|1|ATC|SDD|${EMPTY}     Add To Cart    Paypal


18-SignIn - MIK-MKP - Three Products - Paypal
    [Documentation]    Buyer Buys 1 x PIS and 1 x STM and 1 x MKP, and chooses Paypal at Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-hotfix
    [Template]     Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|ATC|PIS|0     MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}     MKP|listing|${MKP[0]}|1|ATC||${EMPTY}    Add To Cart    Paypal


19-SignIn - MKR-MIK - Three Products - CC
    [Documentation]    Buyer Buys 1 x MKR and 1 x MKR class and 1 x MIK class, and uses CC to Checkout
    [Setup]    Run Keywords   Login and change store    AND    clear cart
    [Tags]    ck-hotfix
    [Template]     Buyer Checkout Work Flow
    MKR|listing|${MKR[0]}|1|ATC||${EMPTY}    MKR|class|${MKRS CLASS[0]}|1|ACTC||${EMPTY}    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}    Add To Cart    Credit Card




