*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerDisputesKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
...                             AND    API - Buyer Sign In

Suite Teardown      Close All Browsers
Test Setup          Buyer Left Menu - Return And Dispute
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    buyer    rad

*** Variables ***
${Return_Url}    ?returnUrl=/buyertools/return-and-dispute
@{Dispute_Buttons}    Submit Dispute     View Dispute
@{Offer_Buttons}    Reject Offer    Accept Offer

*** Test Cases ***
Test Buyer Submit Dispute
    [Documentation]    [MKP-5995],Buyer submit dispute after seller refund rejected the return orde
    [Tags]    mp    mp-ea   mp-b-dispute-submit    mp-rsc
    [Template]    Buyer Disputes - Flow - Submit Dispute For Rejected Refund Order
    submitDispute

Test Buyer Submit Dispute By API - Do Many Times
    [Documentation]    [MKP-5995],Buyer submit dispute after seller refund rejected the return orde
    [Tags]    mp    mp-ea    ea-init-data
    [Template]    Buyer Disputes - Submit Dispute By API
    1       submitDispute
    2       submitDispute
    3       submitDispute
    4       submitDispute
    5       submitDispute