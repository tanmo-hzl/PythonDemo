*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource    ../../Keywords/Checkout/Common.robot


Suite Setup   Run Keywords   initial env data2
#Suite Teardown    Close Browser
#Test Setup    Run Keywords   Login and change store    AND    clear cart

*** Variables ***

*** Test Cases ***

01-SignIn-MIK-Listing-STH-CC-BY
    [Documentation]    Buyer Buys 1 MIK Product STH item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${MIK[0]}|1|BY|STM|${EMPTY}    Buy Now    Credit Card


02-SignIn-MIK-Listing-PIS-CC-BY
    [Documentation]    Buyer Buys 1 MIK Product PickUp item and uses CC to Buy Now
    [Setup]    Run Keywords   Login and change store
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${PIS[0]}|1|BY|PIS|0    Buy Now    Credit Card


03-SignIn-MIK-Listing-SDD-CC-BY
    [Documentation]    Buyer Buys 2 MIK Product SDD item and uses CC to Buy Now
    [Setup]    Run Keywords   Login and change store
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|2|BY|SDD|${EMPTY}    Buy Now    Credit Card


04-SignIn-MIK-Class-CC-BY
    [Documentation]    Buyer Buys 1 MIK Class and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info
    [Teardown]    Run Keywords     Update default address    AND    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MIK|class|${MIK CLASS[0]}|2|BCO||${EMPTY}    Book Class Only    Credit Card


05-SignIn-MKR-Listing-CC-BY
    [Documentation]    Buyer Buys 1 MKR Product item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MKR|listing|${MKRS[0]}|1|BY||${EMPTY}    Buy Now    Credit Card


06-SignIn-MKR-Class-CC-BY
    [Documentation]    Buyer Buys 1 MKR Class item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info
    [Teardown]    Run Keywords     Update default address    AND    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MKR|class|${MKRS CLASS[0]}|1|BCO||${EMPTY}    Book Class Only    Credit Card


07-SignIn-MKP-Listing-CC-BY
    [Documentation]    Buyer Buys 1 MKP Product item and uses CC to Buy Now
    [Setup]    Run Keywords    Login and get account info
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Checkout Work Flow
    MKP|listing|${MKP[2]}|1|BY||${EMPTY}    Buy Now    Credit Card


08-MIK-STM-Listing-CC-BY-SignIn
    [Documentation]    Buyer Buys 1 MIK Product STH item and uses CC to Buy Now, signin in slide page
    [Setup]    Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Teardown]    Run Keyword    Close All Browsers
    [Tags]    full-run
    [Template]   Buyer Buy Now Work Flow Sign In Slide Page
    MIK|listing|${MIK[2]}|1|BY||${EMPTY}    Buy Now    Credit Card
