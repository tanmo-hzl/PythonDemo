*** Settings ***
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerOrderHistoryKeywords.robot
Resource            ../../Keywords/MP/BuyerReturnsKeywords.robot
Resource            ../../Keywords/MP/BuyerDisputesKeywords.robot
Resource            ../../TestData/MP/ReturnData.robot
Suite Setup         Run Keywords   Initial Env Data    configReturn.ini
...                                AND    Open Browser With URL     ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL_RETURN}    ${BUYER_PWD_RETURN}    ${BUYER_NAME_RETURN}
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}      ?returnUrl=/buyertools/order-history
${Repeat_Count}    1
${Cur_Order_Number}    2304236823615099
@{Dispute_Buttons}    Submit Dispute     View Dispute
@{Offer_Buttons}    Reject Offer    Accept Offer

*** Test Cases ***
Test Buyer Submit Return Order Apply
    [Documentation]    Buyer return all product which order is shipped
    [Tags]    buyer-re
    Buyer Left Menu - Orders & Purchases - Order History
    Buyer Order - Search Order By Search Value    ${Cur_Order_Number}
    Buyer Order - Enter Order Detail Page By Index
    Buyer Return - Flow - Submit Return For All Items

Test Save Return Order Info By Parent Order Number
    [Documentation]    Buyer save return order info by parent order number
    [Tags]    buyer-re-save
    Buyer Left Menu - Return And Dispute
    Buyer Return - Save Return Order Info By Parent Order Number    ${Cur_Order_Number}


Test Buyer Submit Dispute For Reject Refund Order
    [Documentation]    Buyer submit dispute for reject refund order
    [Tags]    buyer-dispute-sub
    Buyer Left Menu - Return And Dispute
    Buyer Disputes - List - Search Order By Value    ${Cur_Order_Number}
    Buyer Disputes - List - Eneter Detail Page By Index    1    ${True}
    Buyer Disputes - Detail - Click Submit Dispute
    Buyer Disputes - Submit - Select All Items
    Buyer Disputes - Submit - Loop Add Dispute Reason And Notes To Items
    Buyer Disputes - Submit - Click Next
    Buyer Disputes - Submit - Click Submit
    Buyer Disputes - Submit - Click View Dispute Details
    Buyer Disputes - Process - Back To Dispute Detail

Test Buyer Reject Dispute
    [Documentation]   Buyer Reject Dispute
    [Tags]    buyer-dispute-reject
    Buyer Left Menu - Return And Dispute
    Buyer Disputes - List - Search Order By Value    ${Cur_Order_Number}
    Buyer Disputes - List - Eneter Detail Page By Index
    Buyer Disputes - Detail - Click View Dispute
    Buyer Disputes - Process - Selected I Acknowledge Offer And Select Offer    ${Offer_Buttons[0]}
    Buyer Disputes - Process - Back To Dispute Detail

Test Search Order And Escalate Dispute
    [Documentation]    Buyer Search Order And Escalate Dispute
    [Tags]    buyer-dispute-escalate
    Buyer Left Menu - Return And Dispute
    Buyer Disputes - List - Search Order By Value    ${Cur_Order_Number}
    Buyer Disputes - List - Eneter Detail Page By Index
    Buyer Disputes - Detail - Click View Dispute
    Buyer Disputes - Process - Click Dispute Summary
    Buyer Disputes - Process - Click Escalate Dispute
    Buyer Disputes - Escalate - Input Escalate Info
    Buyer Disputes - Escalate - Select I Acknowledge
    Buyer Disputes - Escalate - Click Yes Or No    ${True}
    Buyer Disputes - Process - Click Back
    Buyer Disputes - Process - Back To Dispute Detail