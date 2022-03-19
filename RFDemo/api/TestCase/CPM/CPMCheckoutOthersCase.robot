*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/CartKeywords.robot
Suite Setup      Run Keywords    Set Initial Data - MIK - User
Suite Teardown   Delete All Sessions
Library             ../../TestData/CPM/ProductsInfo.py

*** Test Cases ***
Test Get Shipping Options
    [Tags]    CPM-Shipping    cpm-Smoke
    [Documentation]    Test Get Shipping Options
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by ISPU
    CPM Get Shipping Options- GET    ${items}

Test Get Oder Number By Token
    [Tags]    CPM-Shipping    cpm-Smoke
    [Documentation]    Test Get Oder Number By Token
    CPM Get Order Number- GET

Send Sample Subscription Confirmation Email By Email Address Positive
    [Tags]    CPM-Shipping    cpm-Smoke
    [Documentation]    Send Sample Subscription Confirmation Email By Email Address Positive
    CPM Create Email Subscription Confirmation- POST

Send Sample Subscription Confirmation Email By Email Address Negative
    [Tags]    CPM-Shipping    cpm-Smoke
    [Documentation]    Send Sample Subscription Confirmation Email By Email Address Negative
    CPM Create Email Subscription Confirmation- POST    -10