*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_LST_EMAIL}    ${SELLER_PWD}    ${SELLER_LST_NAME}
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
Test Create New Listing - Save Draft On Step 1
    [Documentation]    [MKP-5218,MKP-5222],Create new no variant listing and save draft on step 1
    [Tags]    mp    mp-ea    ea-lst    ea-lst-draft
    ${Listing_Info}    Get Listing Body
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    Flow - Create - Step 1
    Create&Update - Select Item Has No End Date
    Create - Click Save As Draft
    Listing - Check Listing Save Draft Success

Test Create New Listing - No Variants - Save Draft On Step 2
    [Documentation]    Create new no variant listing and save draft on step 2
    [Tags]    mp    mp-ea    ea-lst    ea-lst-draft
    ${Listing_Info}    Get Listing Body
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    Flow - Create - Step 1
    Create - Click Save And Next
    Flow - Create - Step 2 - No Variants
    Create - Click Save As Draft
    Listing - Check Listing Save Draft Success

Test Create New Listing - Have Variants - Save Draft On Step 2
    [Documentation]    Create new hava variant listing and save draft on step 2
    [Tags]    mp    mp-ea    ea-lst   ea-lst-draft
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    Flow - Create - Step 1
    Create - Click Save And Next
    Flow - Create - Step 2 - Have Variants
    Create - Click Save As Draft
    Listing - Check Listing Save Draft Success

Test Create New Listing - No Variants - Save Draft On Step 3
    [Documentation]    Create new no variant listing and save draft on step 3
    [Tags]    mp    mp-ea    ea-lst   ea-lst-draft
    ${Listing_Info}    Get Listing Body
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    Flow - Create - Step 1
    Create - Click Save And Next
    Flow - Create - Step 2 - No Variants
    Create - Click Save And Next    2
    Flow - Create - Step 3 - No Variants
    Create - Click Save As Draft
    Listing - Check Listing Save Draft Success

Test Create New Listing - Have Variants - Save Draft On Step 3
    [Documentation]    Create new hava variant listing and save draft on step 3
    [Tags]    mp    mp-ea    ea-lst   ea-lst-draft
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    Flow - Create - Step 1
    Create - Click Save And Next
    Flow - Create - Step 2 - Have Variants
    Create - Click Save And Next    2
    Flow - Create - Step 3 - Have Variants
    Create - Click Save As Draft
    Listing - Check Listing Save Draft Success