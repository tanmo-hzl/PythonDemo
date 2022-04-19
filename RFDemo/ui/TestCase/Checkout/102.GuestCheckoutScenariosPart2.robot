*** Settings ***
Documentation     Test Suite For smoke Checkout Tests Flow
Resource          ../../Keywords/Checkout/GuestBusinessKeywords.robot
Library           ../../TestData/Checkout/GuestGenerateAddress.py

Suite Setup      Initial Custom Selenium Keywords
Test Setup       Environ Browser Selection And Setting   ${ENV}   ${BROWSER}
Test Teardown    Finalization Processment



*** Test Cases ***

Guest - Buyer Buys 1 MIK Product STH item, 1 BOPIS and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK|PIS      1|1    1|1      Credit Card

Guest - Buyer Buys 2 Different MIK Product STH item, 4 different MIK Products SDD, under $50 and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK|SDD    2|4    1|1|1|1|1|1      Credit Card

Guest - Buyer Buys 2 Different Marketplace Product from 1 Storefront and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKPS     2    1|1       Credit Card

Guest - Buyer Buys 1 Marketplace Product from 3 Different Storefronts and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKP      3    1|1|1     Credit Card

Guest - Buyer Buys 1 Makerplace Product and 1 Makerplace Class from the same store Storefront and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKRS|MKRS CLASS      1|1      1|1       Credit Card

Guest - Buyer Buys 1 Makerplace Product from 3 Different Storefronts and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKR                3        1|1|1     Credit Card

Guest - Buyer Buys 1 MIK Product STH and 1 Makerplace Product and 1 Marketplace Product and uses CC to Checkout
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MIK|MKR|MKP        1|1|1    1|1|1     Credit Card

Guest - Buyer Buys 2 different MIK Product and 1 MKR Product and 1 MKR Class and 2 MKP uses CC to Checkout from different Stores
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-smoke    full-run
    MKR|MKR CLASS|MKP|PIS|PISM    1|1|2|1|1    1|1|1|1|1|2    Credit Card    2

Guest - Hotfix Agile Verify - 1 MIK Product and 1 SDD Product and 1 MIK Class and 1 MKP and 1 MKR and 1 MKR Class with Gift Card
    [Template]   Guest Checkout Work Flow Add To Cart
    [Tags]   ck-hotfix   full-run
    MIK|SDD|MIK CLASS|MKP|MKR|MKR CLASS    1|1|1|1|1|1    1|1|1|1|1|1    Gift Card
