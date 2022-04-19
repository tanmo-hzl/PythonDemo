*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords    Initial Env Data
...                             AND    Open And Reset Downloads Directory For Chrome  ${URL_MIK_SIGNIN}${Return_Url}    EA-0
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Listing Management
Test Teardown       Go To Expect Url Page    ${TEST_STATUS}    ${User_Type}    ${Page_Name}

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/listing-management
${Par_Case_Status}
${Random_Data}
${User_Type}    seller
${Page_Name}    lst

*** Test Cases ***
Test Check Listing Prohibited Tips
    [Documentation]    Seller search listing by status and check result
    [Tags]    mp   mp-ea   ea-lst    ea-lst-ele-check
    Listing - Check Page Tips

Test Shipping Rate's Switch and Input Box
    [Documentation]    Update active listing information and save changes
    [Tags]    mp    mp-ea   ea-lst   ea-lst-ele-check
    ${Listing_Info}    Get Listing Body    ${False}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Enter Listing Detail Page By Index     1
    Listing Detail - Shipping Rate Switch Check - Hazardous
    Listing Detail - Shipping Rate Switch Check - Free Standard
    Update - Cancel Update Listing

Test Check Edit Page Fixed element
    [Documentation]    Check fixed element on edit listing page
    [Tags]    mp    mp-ea   ea-lst   ea-lst-ele-check
    Listing - Filter - Search Listing By Status Single    Active
    Listing - Enter Listing Detail Page By Variants Or Not    ${False}
    ${fixed_ele}    Get EA Fixed Element    FixedElement_SellerEditListing.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}
    Update - Cancel Update Listing

#[MKP-5226],[MKP-5227], 分类联动的变体类型

#Test Check Category Variant Type
#    [Documentation]    [MKP-5226],Check category variant type
#    [Tags]    block
#    Listing - Filter - Search Listing By Status Single    Active
#    Listing - Search Lisitng By Search Value    Variants
#    Listing - Enter Listing Detail Page By Index
#    Listing - Variant Type - Check Category Variant Type
#    Go To Expect Url Page    DONE    ${User_Type}    ${Page_Name}
#
#Test Check Category Variant Type Value
#    [Documentation]    Check variant type values
#    [Tags]    block
#    Listing - Filter - Search Listing By Status Single    Active
#    Listing - Search Lisitng By Search Value    Variants
#    Listing - Enter Listing Detail Page By Index
#    Listing - Variant Type - Check Variant Type Value
#    Go To Expect Url Page    DONE    ${User_Type}    ${Page_Name}

Test Listing - Search Listing By Status And Check Result
    [Documentation]    Seller search listing by status and check result
    [Tags]    mp   mp-ea   ea-lst    ea-lst-filter
    [Template]    Listing - Filter - Search Listing By Status And Check Result
    1
    2
    3
    5
    10

Test Seller Search Listing By Inventory Range And Check Result
    [Documentation]    Seller search listing by Inventory Range and check result
    [Tags]    mp   mp-ea   ea-lst    ea-lst-filter
    [Template]    Listing - Filter - Check Search Inventory Range Result
    0    0
    0    200
    190    2000
    99999    99999

Test Seller Search Listing By Primary Categories And Check Result
    [Documentation]    Seller search listing by Inventory Range and check result
    [Tags]    mp   mp-ea   ea-lst    ea-lst-filter
    [Template]    Listing - Filter - Check Search Primary Categories Result
    1
    3
    5
    6

Test Download Listing By Status
    [Documentation]    Download listing after filters order by status
    [Tags]   mp   mp-ea   ea-lst    ea-lst-download
    [Template]    Listing - Download Lisings By Status
    Archived            ${False}
    Prohibited          ${False}
    Pending Review      ${False}
    Draft               ${True}
    Inactive            ${True}
    Suspended           ${True}
    Expired             ${True}
    Out of stock        ${True}
    Active              ${True}

Test Download Template Listing Excel By Random One Category
    [Documentation]    [MKP-5473],Download template listing excel by random category
    [Tags]   mp   mp-ea   ea-lst    ea-lst-download
    Listing - Download Listing Excel Template By Random Category    1

Test Download Template Listing Excel By Random Two Category
    [Documentation]    [MKP-5473],Download template listing excel by random category
    [Tags]   mp   mp-ea   ea-lst    ea-lst-download
    Listing - Download Listing Excel Template By Random Category    2

Test Download Template Listing Excel By All Category
    [Documentation]    Download template listing excel by all category
    [Tags]   mp   mp-ea   ea-lst    ea-lst-download
    Listing - Download Listing Excel Template By All Category

Test Click Listings Table Header Text To Sort Data And Check Result
    [Documentation]    Click Listings Table Header Text To Sort Data And Check Result
    [Tags]    mp    mp-ea    ea-lst-sort
    [Template]    Common - Check Sort Data After Click Table Header Text
    Listing title       firstClick      iconFollow       3       string
    Listing title       secondClick     iconFollow       3       string
    Status              firstClick      iconFollow       4       string
    Status              secondClick     iconFollow       4       string
    Inventory           firstClick      iconFollow       5       inventory
    Inventory           secondClick     iconFollow       5       inventory
    Category            firstClick      iconFollow       6       string
    Category            secondClick     iconFollow       6       string