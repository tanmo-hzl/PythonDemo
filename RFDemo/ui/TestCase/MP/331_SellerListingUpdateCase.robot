*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
...                             AND    API - Seller Sign In    ${SELLER_EMAIL}    ${SELLER_PWD}
...                             AND    Listing - Update Listing Taxonomy File
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
Test Update Draft Listing And Save Changes - No Variants
    [Documentation]    [MKP-5232],Update Draft listing information and save changes - No Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Draft    1    ${False}
    Flow - Update Listing - Update All Information
    Update - Click Save Changes
    Listing - Check Listing Save Draft Success

Test Update Draft Listing And Publish - No Variants
    [Documentation]    [MKP-5231],Update Draft listing information and publish - No Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Draft    1    ${False}
    Flow - Update Listing - Update All Information
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success

Test Update Draft Listing And Save Changes - Have Variants
    [Documentation]    [MKP-5232],Update Draft listing information and save changes - Have Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Draft    1    ${True}
    Flow - Update Listing - Update All Information
    Update - Click Save Changes
    Listing - Check Listing Save Draft Success

Test Update Draft Listing And Publish - Have Variants
    [Documentation]    [MKP-5231],Update Draft listing information and publish - Have Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Draft    1    ${True}
    Flow - Update Listing - Update All Information
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success

Test Update Active Listing And Save Changed - No Variants
    [Documentation]    [MKP-5233],Update Active listing information and save changes - No Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Active    1    ${False}
    Update - Change Listing Title
    Update - Change Barand Name And Manufacturer
    Create&Update - Select Optional Info    ${False}
    Flow - Update Listing If Category Need Update
    Update - Change Description
    Update - Change Listing Tags
    Update - Change Date Range End
    Update - Upload Photos
    Create&Update - Set Shipping Policy
    Create&Update - Override Shipping Rate
    Create&Update - Set Return Policy
    Update - Click Save Changes

Test Update Active Listing And Save Changes - Have Variants
    [Documentation]    [MKP-5238],Update Active listing information and save changes - Have Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Active    2    ${True}
    Flow - Update Listing - Update All Information
    Update - Click Save Changes
    Listing - Check Listing Publish Success

Test Update Out Of Stock Listing And Save Changes - No Variants
    [Documentation]    [MKP-5235],Update Out Of Stock listing information and save changes - No Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Out of stock    1    ${False}
    Flow - Update Listing If Category Need Update
    Create - Input Price And Quantity
    Update - Click Save Changes

Test Update Out Of Stock Listing And Save Changes - Have Variants
    [Documentation]    [MKP-5235],Update Out Of Stock listing information and save changes - Have Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Out of stock    3    ${True}
    Flow - Update Listing If Category Need Update
    Create&Update - Select All To Update Variant Inventory And Price
    Update - Click Save Changes

Test Update Out Of Stock Listing And Publish - No Variants
    [Documentation]    [MKP-5234],Update Out Of Stock listing information and Publish - No Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Out of stock    1    ${False}
    Flow - Update Listing If Category Need Update
    Create - Input Price And Quantity
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success

Test Update Out Of Stock Listing And Publish - Have Variants
    [Documentation]    [MKP-5234],Update Out Of Stock listing information and Publish - Have Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Out of stock    3    ${True}
    Flow - Update Listing If Category Need Update
    Create&Update - Select All To Update Variant Inventory And Price
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success

Test Update Suspended Listing And Save Changes - No Variants
    [Documentation]    [MKP-5236],Update Suspended listing information and save changes - No Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Suspended    1    ${False}
    Flow - Update Listing If Category Need Update
    Create - Input Barand And Manufacturer
    Create - Input Description
    Update - Click Save Changes

Test Update Suspended Listing And Save Changes - Have Variants
    [Documentation]    [MKP-5236],Update Suspended listing information and save changes - Have Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Suspended    3    ${True}
    Flow - Update Listing If Category Need Update
    Create - Input Barand And Manufacturer
    Create - Input Description
    Update - Click Save Changes

Test Update Suspended Listing And Publish - No Variants
    [Documentation]    [MKP-5237],Update Suspended listing information and save changes - No Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Suspended    1    ${False}
    Flow - Update Listing If Category Need Update
    Create - Input Barand And Manufacturer
    Create - Input Description
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success

Test Update Suspended Listing And Publish - Have Variants
    [Documentation]    [MKP-5237],Update Suspended listing information and save changes - Have Variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Listing - Filter Listing By API And Go To Edit Page    Suspended    3    ${True}
    Flow - Update Listing If Category Need Update
    Create - Input Barand And Manufacturer
    Create - Input Description
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success
