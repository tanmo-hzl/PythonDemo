*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerDisputesKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Resource            ../../Keywords/MP/EAInitialDataAPiKeywords.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
...                             AND    API - Seller Sign In And Get Order Info
...                             AND    API - Get And Save Seller Dispute Order Info By Status    Offer Made    orders_seller_offer_made
Suite Teardown      Close All Browsers
Test Setup          Buyer Left Menu - Return And Dispute
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}

*** Variables ***
${Return_Url}    ?returnUrl=/buyertools/return-and-dispute
@{Dispute_Buttons}    Submit Dispute     View Dispute
@{Offer_Buttons}    Reject Offer    Accept Offer
${User_Type}    buyer
${Page_Name}    rad
${Cur_Order_Number}

*** Test Cases ***
Test Buyer Search Order And Reject Dispute
    [Documentation]    Buyer rejected paritail refund or reject refund
    [Tags]    mp    mp-ea   mp-b-dispute-pro    mp-b-dispute-reject    mp-rsc
    Buyer Disputes - Get Offer Made Order Numbers
    Buyer Disputes - List - Search Order By Value    ${Cur_Order_Number}
    Buyer Disputes - List - Eneter Detail Page By Status    Refund Declined
    Buyer Disputes - Detail - Click View Dispute
    Buyer Disputes - Process - Selected I Acknowledge Offer And Select Offer    ${Offer_Buttons[0]}
    Buyer Disputes - Process - Back To Dispute Detail

Test Buyer Search Order And Escalate Dispute
    [Documentation]    After buyer rejected seller's decision, buyer escalate dispute
    [Tags]    mp    mp-ea   mp-b-dispute-pro    mp-b-dispute-escalate    mp-rsc
    Buyer Disputes - List - Search Order By Value    ${Cur_Order_Number}
    Buyer Disputes - List - Eneter Detail Page By Status    Refund Declined
    Buyer Disputes - Detail - Click View Dispute
    Buyer Disputes - Process - Click Dispute Summary
    Buyer Disputes - Process - Click Escalate Dispute
    Buyer Disputes - Escalate - Input Escalate Info
    Buyer Disputes - Escalate - Select I Acknowledge
    Buyer Disputes - Escalate - Click Yes Or No    ${True}
    Buyer Disputes - Process - Click Back
    Buyer Disputes - Process - Back To Dispute Detail

Test Buyer Search Order And Accept Dispute
    [Documentation]    Buyer accept paritail refund or reject refund
    [Tags]    mp    mp-ea   mp-b-dispute-pro    mp-b-dispute-accept    mp-rsc
    Buyer Disputes - Get Offer Made Order Numbers
    Buyer Disputes - List - Search Order By Value    ${Cur_Order_Number}
    Buyer Disputes - List - Eneter Detail Page By Status    Refund Declined
    Buyer Disputes - Detail - Click View Dispute
    Buyer Disputes - Process - Selected I Acknowledge Offer And Select Offer    ${Offer_Buttons[1]}
    Buyer Disputes - Process - Back To Dispute Detail

Test Buyer Search Order And Cancel Dispute
    [Documentation]    Buer cancel dispute
    [Tags]    mp    mp-ea   mp-b-dispute-pro    mp-b-dispute-cancel    mp-rsc
    Buyer Disputes - Get Cancellable Order Numbers
    Buyer Disputes - List - Search Order By Value    ${Cur_Order_Number}
    Buyer Disputes - List - Eneter Detail Page By Status    Refund Declined
    Buyer Disputes - Detail - Click View Dispute
    Buyer Disputes - Process - Click Dispute Summary
    Buyer Disputes - Process - Click Cancel Dispute
    Buyer Disputes - Cancel - Input Cancel Dispute Info
    Buyer Disputes - Cancel - Selected I Acknowledge
    Buyer Disputes - Cancel - Submit Or Close    ${True}
    Buyer Disputes - Process - Click Back
    Buyer Disputes - Process - Back To Dispute Detail