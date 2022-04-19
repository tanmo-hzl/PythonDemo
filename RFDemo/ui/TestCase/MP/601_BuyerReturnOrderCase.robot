*** Settings ***
Resource            ../../Keywords/MP/BuyerReturnsKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
...                             AND    API - Buyer Sign In
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
    ${parent_order_number}    Buyer Return - Get Returnable Order By API
    Buyer Return - Go To Order History Detail Page    ${parent_order_number}
    Buyer Return - Flow - Submit Return For All Items    ${True}

Test Buyer Create Return Order
    [Documentation]    Buyer Apply for return, quantity 2 at a time, and do many times
    [Tags]    mp    mp-ea    mp-buyer-return    mp-rsc
    ${parent_order_number}    Buyer Return - Get Returnable Order By API
    Buyer Return - Go To Order History Detail Page    ${parent_order_number}
    Buyer Return - Flow - Submit Return For All Items    ${False}

Test Buyer Create Return Order By API - Do Many Times
    [Documentation]    Buyer create return order by API, and do many times
    [Tags]    mp    mp-ea    ea-init-data
    [Template]    Buyer Return - Flow - Create Return Order By API
    allItemReturn           allQuantityReturn           buyerReason
    allItemReturn           allQuantityReturn           sellerReason
    allItemReturn           allQuantityReturn           sellerReason
    allItemReturn           allQuantityReturn           sellerReason
    allItemReturn           partialQuantityReturn       buyerReason
    allItemReturn           partialQuantityReturn       sellerReason
    partialItemReturn       partialQuantityReturn       sellerReason
    partialItemReturn       allQuantityReturn           buyerReason
    partialItemReturn       allQuantityReturn           sellerReason

Test Buyer Find Pending Return Order Then Cancel It
    [Documentation]   [MKP-5959],Buyer Cancel Return Order
    [Tags]    mp    mp-ea    mp-buyer-return    mp-buyer-return-cancel    mp-rsc
    Buyer Left Menu - Return And Dispute
    Buyer Return - Eneter Detail Page By Status    Pending Return
    Buyer Return - Cancel Pending Return Order
