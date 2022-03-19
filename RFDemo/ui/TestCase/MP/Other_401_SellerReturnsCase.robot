*** Settings ***
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerReturnsKeywords.robot
Resource            ../../Keywords/MP/SellerDisputesKeywords.robot
Resource            ../../TestData/MP/ReturnData.robot
Suite Setup         Run Keywords   Initial Env Data    configReturn.ini
...                                AND    Open Browser With URL     ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${SELLER_EMAIL_RETURN}    ${SELLER_PWD_RETURN}    ${SELLER_NAME_RETURN}
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/returns
@{Return_Status}    Pending Return    Refund Rejected    Returned    Return Cancelled    Pending Refund
@{Status_List}    Dispute Opened    Dispute In Process    Offer Made    Offer Rejected
...    Dispute Resolved    Dispute Escalated    Escalation Under Review    Dispute Canceled
@{Decisions}    Offer Full Refund    Offer Partial Refund    Reject Refund
${Cur_Return_ID}    R20458219403116547
${Cur_Dispute_ID}


*** Test Cases ***
Test Seller Reject Return Order
    [Documentation]    Seller reject refund
    [Tags]    seller-re
    Store Left Menu - Order Management - Returns
    Seller Returns - Search Order By Return ID    ${Cur_Return_ID}
    Seller Returns - Enter Return Detail Page By Line Index
    Seller Returns - Set All Items Full Or No Refund    ${False}
    Seller Returns - Submit Refund Decision
    Seller Returns - Back To Order List On Return Detail Page

Test Submit Disputes For Offer Full Refund
    [Documentation]    Submit Disputes For Offer Full Refund
    [Tags]   se-full-refund
    Store Left Menu - Order Management - Disputes
    Seller Disputes - Search Order By Search Value    ${Cur_Dispute_ID}
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[0]}

Test Submit Disputes For Offer Partial Refund
    [Documentation]   Submit Disputes For Offer Partial Refund
    [Tags]    se-partial-refund
    Store Left Menu - Order Management - Disputes
    Seller Disputes - Search Order By Search Value    ${Cur_Dispute_ID}
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[1]}

Test Submit Escalate Disputes
    [Documentation]    Submit Escalate Disputes
    [Tags]    se-dis-esc
    Store Left Menu - Order Management - Disputes
    Seller Disputes - Search Order By Search Value    ${Cur_Dispute_ID}
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Enter Dispute Details Page By Index And Status    1    ${Dispute_Status}
    Seller Disputes - Details - Click Dispute Request Details
    Seller Disputes - Process - Click Review Request
    Seller Disputes - Process - Click Dispute Summary
    Seller Disputes - Escalate - Submit Escalate Dispute
    Seller Disputes - Process - Back From Dispute Summary Page
    Seller Disputes - Process - Back Dispute Details Page

Test Submit Disputes For Reject Refund
    [Documentation]    Submit Disputes For Reject Refund
    [Tags]    se-no-refund
    Store Left Menu - Order Management - Disputes
    Seller Disputes - Search Order By Search Value    ${Cur_Dispute_ID}
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[2]}