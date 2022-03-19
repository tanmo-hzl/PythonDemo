*** Settings ***
Resource            ../../Keywords/MP/BuyerReturnsKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Resource            ../../Keywords/MP/EAInitialDataAPiKeywords.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
...                             AND    API - Seller Sign In And Get Order Info
...                             AND    API - Get And Save Seller Order Number By Status    Shipped    orders_shipped
...                             AND    API - Get And Save Seller Return Order Info By Status    ${None}    orders_seller_returns
Suite Teardown      Close All Browsers
Test Setup          Buyer Left Menu - Orders & Purchases - Order History
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    buyer    orh

*** Variables ***
${Return_Url}    ?returnUrl=/buyertools/order-history
${Order_Number}
${Returnable_Order_Number}    ${None}


*** Test Cases ***
Test Buyer Create Return Order Then Cancel It
    [Documentation]    Buyer return product which order is shipped then cancel return order
    [Tags]    mp    mp-ea    mp-buyer-return    mp-buyer-return-cancel    mp-rsc
    ${order_numbers}    Get Shipped Order Numbers    ${Returnable_Order_Number}    ${ENV}
    Buyer Order - Loop Enter Detail Page Find Returnable Order    ${order_numbers}
    Buyer Return - Flow - Submit Return For All Items    ${True}

Test Buyer Create Return Order - Do Many Times
    [Documentation]    Buyer Apply for return for many times, quantity 2 at a time, and do many times
    [Tags]    mp    mp-ea    mp-buyer-return    mp-rsc
    [Template]    Buyer Return - Flow - Create Return Order
    1
    2
    3
    4

Test Buyer Find Pending Return Order Then Cancel It
    [Documentation]   Buyer Cancel Return Order
    [Tags]    mp    mp-ea    mp-buyer-return    mp-buyer-return-cancel    mp-rsc
    Buyer Left Menu - Return And Dispute
    Buyer Return - Eneter Detail Page By Status    Pending Return
    Buyer Return - Cancel Pending Return Order
