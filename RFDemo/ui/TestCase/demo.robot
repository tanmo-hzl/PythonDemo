*** Settings ***
Resource            ../Keywords/Common/CommonKeywords.robot
Resource            ../Keywords/MP/EAInitialDataAPiKeywords.robot

*** Variables ***
${URL}          https://www.baidu.com
${BROWSER}      Chrome
@{aa}     00    11    22    33   44

*** Keywords ***


*** Test Cases ***
Test Pass
    [Documentation]    test pass pass
    [Tags]   demodd    deed
    API - Seller Sign In And Get Order Info
    API - Get And Save Seller Order Number By Status    Shipped    orders_shipped
    API - Get And Save Seller Return Order Info By Status    ${None}    orders_seller_returns
    API - Get And Save Seller Return Order Info By Status    Refund Rejected    orders_refund_rejected
    API - Get And Save Seller Dispute Order Info By Status    ${None}    orders_seller_disputes
    API - Get And Save Seller Dispute Order Info By Status    Offer Made    orders_seller_offer_made





