*** Settings ***
Documentation     Test Suite For smoke Checkout Tests Flow
Resource          ../../Keywords/Checkout/GuestBusinessKeywords.robot
Library           ../../TestData/Checkout/GuestGenerateAddress.py

Suite Setup      Initial Custom Selenium Keywords
Test Setup       Environ Browser Selection And Setting   ${ENV}   ${BROWSER}
Test Teardown    Finalization Processment


*** Test Cases ***
Guest - Buyer Buys 1 MIK Product STH item and uses CC to Checkout
    [Documentation]
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run   multi-user
    MIK    1    1     Credit Card

Guest - Buyer Buys 1 MIK STH + 2x of 1 MIK STH item and uses PAYPAL to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK    2    1|2    Paypal

Guest - Buyer Buys 1 MIK Product BOPIS item and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    PIS    1    1      Credit Card

Guest - Buyer Buys 1 MIK Product BOPIS item from 2 different Stores and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    PISM   1    2      Credit Card    2

Guest - Buyer Buys 2x QTY of 1 MIK BOPIS item (Same Store) and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    PIS    1    2      Credit Card

Guest - Buyer Buys 1 x SDD and chooses GIFT CARD at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    SDD    1    1      Gift Card

Guest - Buyer Buys 4 different MIK Products, over $100, chooses SDD and uses CC at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    SDDH    4    1|1|1|1      Credit Card

Guest - Buyer Buys 1 MIK Product STH and 1 MIK Class from uses CC at Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run1
    MIK|MIK CLASS    1|1    1|1      Credit Card







