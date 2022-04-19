*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerDisputesKeywords.robot
Resource            ../../Keywords/MP/SellerMessageKeywords.robot
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
#[MKP-5988],？？
Test Check Disputes Page Fixed Element text
    [Documentation]   [MKP-5963],Check disputes page fixed element text
    [Tags]  mp    mp-ea    ea-s-dispute    ea-s-dispute-ele
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerOrderManagement.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    disputes

Test Seller Enter Dispute Detail Page And Check Fixed Element
    [Documentation]    [MKP-6969],Enter dispute detail page and check fixed element
    [Tags]    mp    mp-ea    ea-s-dispute
    Seller Disputes - Enter Dispute Details Page By Index And Status
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerDisputeDetail.json
    Seller Disputes - Get Dispute Detail Info
    Common - Check Page Contain Fixed Element    ${fixed_ele}

Test Seller Search Dispute Order By Return Id
    [Documentation]    [MKP-5966],Seller search dispute order by return id
    [Tags]    mp    mp-ea    mp-s-dispute
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Search Order By Search Value    ${Dispute_Detail}[returnId]
    Seller Disputes - Clear Search Value
    Page Should Contain    ${Dispute_Detail}[orderId]

#[MKP-5963] ？？？？
Test Seller Search Dispute Order By Dispute ID
    [Documentation]    [MKP-5967],Seller search dispute order by dispute id
    [Tags]    mp    mp-ea    mp-s-dispute
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Search Order By Search Value    ${Dispute_ID}
    Seller Disputes - Clear Search Value
    Page Should Contain    ${Dispute_ID}

Test Seller Search Dispute Order By Order Number
    [Documentation]    [MKP-5965],Seller search dispute order by order number
    [Tags]    mp    mp-ea    mp-s-dispute
    Seller Disputes - Get Dispute Info By Index
    Seller Disputes - Search Order By Search Value    ${Order_Number}
    Seller Disputes - Clear Search Value
    Page Should Contain    ${Order_Number}

Test Seller Submit Disputes For Offer Full Refund
    [Documentation]   [MKP-6007],Seller selectd offer full refund for dispute order items
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-submit    mp-rsc
    ${search_status_list}    Create List    ${Status_List[0]}    ${Status_List[1]}
    Seller Disputes - Filter - Search Order By Status List    ${search_status_list}
    Seller Disputes - Skip IF No Order On List
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[0]}

Test Seller Submit Disputes For Offer Partial Refund
    [Documentation]  [MKP-6008],Seller selected offer partial refund for dispute order items
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-submit    mp-rsc
    ${search_status_list}    Create List    ${Status_List[0]}    ${Status_List[1]}
    Seller Disputes - Filter - Search Order By Status List    ${search_status_list}
    Seller Disputes - Skip IF No Order On List
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    ${Decisions[1]}

Test Seller Submit Disputes For Different Decisions
    [Documentation]  [MKP-6009],Seller selected offer partial refund for Different decisions
    [Tags]    mp    mp-ea    mp-s-dispute      mp-s-dispute-submit    mp-rsc
    ${search_status_list}    Create List    ${Status_List[0]}    ${Status_List[1]}
    Seller Disputes - Filter - Search Order By Status List    ${search_status_list}
    Seller Disputes - Skip IF No Order On List
    Seller Disputes - Flow - Eneter Dispute Page To Mack Decision    -1

Test Seller Submit Escalate Disputes
    [Documentation]  [MKP-6004],Seller submit escalate for dispute order items
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
    [Documentation]  [MKP-6010],Seller selected reject refund for dispute order items, do many times
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

Test Seller Filter Order By Duration And Status
    [Documentation]  [MKP-5976],Seller filters dispute order by Duration and status,then check order date and status
    [Tags]    mp    mp-ea    mp-s-dispute   mp-s-dispute-filter
    [Template]    Seller Disputes - Filter - Search Order By Duration And Status
    Past 7 Days     Dispute Opened    Dispute In Process    Offer Rejected
    Past 30 Days    Offer Made    Offer Rejected    Dispute Resolved
    Past 6 Months    Dispute Escalated    Escalation Under Review    Dispute Canceled

Test Seller Filter Order By Status And Check Result
    [Documentation]  [MKP-5959],Seller filters dispute order by status and check result
    [Tags]    mp    mp-ea    mp-s-dispute   mp-s-dispute-filter
    [Template]    Seller Disputes - Filter - Search Order By Status And Check Result
    1
    2
    5
    7

Test Seller Filter Order By Duration And Check Result
    [Documentation]  [MKP-5973],Seller filters dispute order by duration and check result
    [Tags]    mp    mp-ea    mp-s-dispute   mp-s-dispute-filter
    [Template]    Seller Disputes - Filter - Search Order By Duration And Check Result
    All Time
    Today
    Yesterday
    Past 7 Days
    Past 30 Days
    Past 6 Months

Test Seller Eneter Order Detail Page And Check Fixed Element Text
    [Documentation]  [MKP-6970],Seller enter order detail page and back dispute list page
    [Tags]    mp    mp-ea    mp-s-dispute
    Seller Disputes - Enter Order Detail Page By Index
    Seller Disputes - Back To Disputes List On Order Detail Page

Test Click Dispute Table Header Text To Sort Data And Check Result
    [Documentation]    [MKP-5987], Click Dispute Table Header Text To Sort Data And Check Result
    [Tags]    mp    mp-ea    ea-s-dispute-sort
    [Template]    Common - Check Sort Data After Click Table Header Text
    Dispute ID          firstClick      iconNotFollow       1       string
    Dispute ID          secondClick     iconNotFollow       1       string
    Status              firstClick      iconNotFollow       3       status
    Status              secondClick     iconNotFollow       3       status
    Order Number        firstClick      iconNotFollow       4       string
    Order Number        secondClick     iconNotFollow       4       string

Test Contact Buyer On Dispute Detail Page
    [Documentation]    [MKP-5989],Contact buyer on dispute detail page
    [Tags]    mp    mp-ea   mp-s-dispute   mp-s-dispute-msg
    Seller Disputes - Enter Dispute Details Page By Index And Status
    Seller Message - Contact Buyer - Click Button Contact Buyer
    Seller Message - Contact Buyer - Input Send Message   ${None}
    Seller Message - Contact Buyer - Click Button Send    ${None}
    ${now_time}    Get Time
    ${input_msg}    Set Variable    Send Dispute Msg at ${now_time}
    Seller Message - Contact Buyer - Input Send Message    ${input_msg}
    Seller Message - Contact Buyer - Add Attach File
    Seller Message - Contact Buyer - Click Button Send    ${input_msg}

