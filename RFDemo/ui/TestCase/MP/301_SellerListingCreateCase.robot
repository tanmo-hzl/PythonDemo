*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
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
Test Create New Listing - No Variants
    [Documentation]    [MKP-5219,MKP-5225,MK9-5220],Eneter Listing Management Page and create new listing don't have variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    ${Listing_Info}    Get Listing Body
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    ${fixed_ele}    Get Listing Fixed Element     FixedElement_SellerCreateListing.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}[step1]
    Flow - Create - Step 1
    Create - Click Save And Next
    Common - Check Page Contain Fixed Element    ${fixed_ele}[step2]
    Flow - Create - Step 2 - No Variants
    Create - Click Save And Next    2
    Common - Check Page Contain Fixed Element    ${fixed_ele}[step3]
    Flow - Create - Step 3 - No Variants
    Create - Enter Listing Confirmation Page
    Common - Check Page Contain Fixed Element    ${fixed_ele}[step4]
    Create - Click Publish Campaign And Select Next Page
    Listing - Check Listing Publish Success

Test Create New Listing - No Variants - Inventory Zero
    [Documentation]    [MKP-5223,MK9-5221],Eneter Listing Management Page and create new listing don't have variants and Inventory Zero
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    ${Listing_Info}    Get Listing Body
    ${Listing_Info}    Update Listing Value By Keys    ${Listing_Info}    0    singleSku    quantity
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    Flow - Create - Step 1    2
    Create - Click Save And Next
    Flow - Create - Step 2 - No Variants
    Create - Click Save And Next    2
    Flow - Create - Step 3 - No Variants
    Create - Enter Listing Confirmation Page
    Create - Click Publish Campaign And Select Next Page
    Listing - Check Listing Publish Success    Out of stock

Test Create New Listing - Have Variants - Size
    [Documentation]    [MKP-5230],Create new listing hava one variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Flow - Create Listing - Have Variants
    Listing - Check Listing Publish Success

Test Create New Listing - Have Variants - Size And Color
    [Documentation]    [MKP-5230],Create new listing hava two variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    Set Suite Variable     ${Variant_Quantity}    2
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Flow - Create Listing - Have Variants
    Listing - Check Listing Publish Success

Test Create New Listing - Have Variants - Size And Color And Count
    [Documentation]    [MKP-5228,MKP-5229,MKP-5230],Create new listing hava three variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    Set Suite Variable     ${Variant_Quantity}    3
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Flow - Create Listing - Have Variants
    Listing - Check Listing Publish Success

#[MKP-5262], 两个卖家，非变体，同一个gtin number+type
#[MKP-5263], 两个卖家，变体，同一个gtin number+type