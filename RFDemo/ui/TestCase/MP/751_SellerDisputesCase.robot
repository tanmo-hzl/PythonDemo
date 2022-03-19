*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerDisputesKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Order Management - Disputes
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/disputes
${Dispute_ID}
${Order_Number}
${Dispute_Status}
${User_Type}    seller
${Page_Name}    dis
@{Status_List}    Dispute Opened    Dispute In Process    Offer Made    Offer Rejected
...    Dispute Resolved    Dispute Escalated    Escalation Under Review    Dispute Canceled
@{Decisions}    Offer Full Refund    Offer Partial Refund    Reject Refund

*** Test Cases ***
Test Check Disputes Page Fixed Element text
    [Documentation]   Check disputes page fixed element text
    [Tags]  mp    mp-ea    ea-s-dispute    ea-s-dispute-ele
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerOrderManagement.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    disputes

Test Seller Enter Dispute Detail Page And Check Fixed Element
    [Documentation]    Enter dispute detail page and check fixed element
    [Tags]    mp    mp-ea    ea-s-dispute
    Seller Disputes - Enter Dispute Details Page By Index And Status
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerDisputeDetail.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}

Test Seller Search Dispute Order
    [Documentation]    Seller search dispute order by dispute id
    [Tags]    mp    mp-ea    mp-s-dispute
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Search Order By Search Value    ${Dispute_ID}
    Seller Disputes - Clear Search Value

Test Seller Submit Disputes For Offer Full Refund
    [Documentation]   Seller selectd offer full refund for dispute order items
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-submit    mp-rsc
    ${search_status_list}    Create List    ${Status_List[0]}    ${Status_List[1]}
    Seller Disputes - Filter - Search Order By Status List    ${search_status_list}
    Seller Disputes - Skip IF No Order On List
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[0]}

Test Seller Submit Disputes For Offer Partial Refund
    [Documentation]  Seller selected offer partial refund for dispute order items
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-submit    mp-rsc
    ${search_status_list}    Create List    ${Status_List[0]}    ${Status_List[1]}
    Seller Disputes - Filter - Search Order By Status List    ${search_status_list}
    Seller Disputes - Skip IF No Order On List
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[1]}

Test Seller Submit Escalate Disputes
    [Documentation]  Seller submit escalate for dispute order items
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-escalate    mp-rsc
    ${search_status_list}    Create List    ${Status_List[2]}    ${Status_List[1]}
    Seller Disputes - Filter - Search Order By Status List    ${search_status_list}
    Seller Disputes - Skip IF No Order On List
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Enter Dispute Details Page By Index And Status    1    ${Dispute_Status}
    Seller Disputes - Details - Click Dispute Request Details
    Seller Disputes - Process - Click Review Request
    Seller Disputes - Process - Click Dispute Summary
    Seller Disputes - Escalate - Submit Escalate Dispute
    Seller Disputes - Process - Back From Dispute Summary Page
    Seller Disputes - Process - Back Dispute Details Page

Test Seller Submit Disputes For Reject Refund
    [Documentation]  Seller selected reject refund for dispute order items, do many times
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-submit    mp-rsc
    [Template]    Seller Disputes - Flow - Submit Disputes For Reject Refund
    1
    2

Test Seller View Disputes Summary
    [Documentation]  Seller view disputes summary info
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-summary
    Seller Disputes - Filter - Clear All Filter
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Enter Dispute Details Page By Index And Status    1    ${Dispute_Status}
    Seller Disputes - Details - Click Dispute Request Details
    Seller Disputes - Process - Click Dispute Summary
    Seller Disputes - Process - Back From Dispute Summary Page
    Seller Disputes - Process - Back Dispute Details Page

Test Seller Filter Order By Status And Check Result
    [Documentation]  Seller filters dispute order by status and check result
    [Tags]    mp    mp-ea    mp-s-dispute   mp-s-dispute-filter
    [Template]    Seller Disputes - Filter - Search Order By Status And Check Result
    1
    2
    5
    7

Test Seller Filter Order By Duration And Check Result
    [Documentation]  Seller filters dispute order by duration and check result
    [Tags]    mp    mp-ea    mp-s-dispute   mp-s-dispute-filter
    [Template]    Seller Disputes - Filter - Search Order By Duration And Check Result
    All Time
    Today
    Yesterday
    Past 7 days
    Past 30 days
    Past 6 Month


Test Seller Eneter Order Detail Page And Check Fixed Element Text
    [Documentation]  Seller enter order detail page and back dispute list page
    [Tags]    mp    mp-ea    mp-s-dispute
    Seller Disputes - Enter Order Detail Page By Index
    Seller Disputes - Back To Disputes List On Order Detail Page

Test Contact Buyer On Dispute Detail Page
    [Documentation]    Contact buyer on dispute detail page
    [Tags]    mp    mp-ea   mp-s-dispute   mp-s-dispute-msg
    Seller Disputes - Enter Dispute Details Page By Index And Status
    Seller Message - Contact Buyer - Click Button Contact Buyer
    Seller Message - Contact Buyer - Input Send Message    ${False}
    Seller Message - Contact Buyer - Click Button Send
    Seller Message - Contact Buyer - Input Send Message
    Seller Message - Contact Buyer - Add Attach File
    Seller Message - Contact Buyer - Click Button Send

