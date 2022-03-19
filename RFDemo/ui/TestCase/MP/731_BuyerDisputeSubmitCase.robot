*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerDisputesKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Resource            ../../Keywords/MP/EAInitialDataAPiKeywords.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
...                             AND    API - Seller Sign In And Get Order Info
...                             AND    API - Get And Save Seller Return Order Info By Status    Refund Rejected    orders_refund_rejected
...                             AND    API - Get And Save Seller Dispute Order Info By Status    ${None}    orders_seller_disputes
Suite Teardown      Close All Browsers
Test Setup          Buyer Left Menu - Return And Dispute
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    buyer    rad

*** Variables ***
${Return_Url}    ?returnUrl=/buyertools/return-and-dispute
@{Dispute_Buttons}    Submit Dispute     View Dispute
@{Offer_Buttons}    Reject Offer    Accept Offer

*** Test Cases ***
Test Buyer Search Order And Submit Dispute - Do Many Times
    [Documentation]    Buyer submit dispute after seller refund rejected the return order, do many times
    [Tags]    mp    mp-ea   mp-b-dispute-submit    mp-rsc
    [Template]    Buyer Disputes - Flow - Submit Dispute For Rejected Refund Order
    1
    2
    3
    4
