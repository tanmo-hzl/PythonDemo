*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords    Initial Env Data
...                             AND    Open And Reset Downloads Directory For Chrome  ${URL_MIK_SIGNIN}${Return_Url}    ${Download_Dir}
...                             AND    User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
...                             AND    API - Seller Sign In
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
${Download_Dir}    EA-10

*** Test Cases ***
Test Import To Update Listings No Changed - Active - No Variants
    [Documentation]    Download one listing by status then import it - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Active          ${False}    ${False}    ${None}    ${None}    Active

Test Import To Update Listings No Changed - Active - Have Variants
    [Documentation]    Download one listing by status then import it - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Active          ${True}     ${False}    ${None}    ${None}    Active

Test Import To Create Listings - Draft - One Items - No Variants
    [Documentation]    [MKP-5479,MKP-5480],Import to create draft listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Active           0       1       Draft

Test Import To Create Listings - Draft - One Items - Have Variants
    [Documentation]    [MKP-5479,MKP-5480],Import to create draft listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Active           1       1       Draft

Test Import To Create Listings - Draft To Out Of Stock - One Items - No Variants
    [Documentation]    [MKP-5481],Import to create Draft To Out Of Stock listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Out of stock     0       1       Draft

Test Import To Create Listings - Draft To Out Of Stock - One Items - Have Variants
    [Documentation]    [MKP-5481],Import to create Draft To Out Of Stock listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Out of stock     1       1       Draft

Test Import To Create Listings - Draft To Expired - One Items - No Variants
    [Documentation]    [MKP-5482],Import to create Draft To Expired listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Expired          0       1       Expired

Test Import To Create Listings - Draft To Expired - One Items - Have Variants
    [Documentation]    [MKP-5482],Import to create Draft To Expired listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Expired          1       1       Expired

Test Import To Create Listings - Draft To Suspended - One Items - No Variants
    [Documentation]    [MKP-5484],Import to create Draft To Suspended listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Suspended        0       1       Suspended

Test Import To Create Listings - Draft To Suspended - One Items - Have Variants
    [Documentation]    [MKP-5484],Import to create Draft To Suspended listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Suspended        1       1       Suspended

Test Import To Create Listings - Active - One Items - No Variants
    [Documentation]    [MKP-5479,MKP-5480],Import to create Active listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Active           0       1       Active

Test Import To Create Listings - Active - One Items - Have Variants
    [Documentation]    [MKP-5479,MKP-5480],Import to create Active listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Active           1       1       Active

Test Import To Create Listings - Active To Out Of Stock - One Items - No Variants
    [Documentation]    [MKP-5481],Import to create Active To Out Of Stock listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Out of stock     0       1       Out of stock

Test Import To Create Listings - Active To Out Of Stock - One Items - Have Variants
    [Documentation]    [MKP-5481],Import to create Active To Out Of Stock listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Out of stock     1       1       Out of stock

Test Import To Create Listings - Active To Expired - One Items - No Variants
    [Documentation]    [MKP-5482],Import to create Active To Expired listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Expired          0       1       Expired

Test Import To Create Listings - Active To Expired - One Items - Have Variants
    [Documentation]    [MKP-5482],Import to create Active To Expired listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Expired          1       1       Expired

Test Import To Create Listings - Active To Suspended - One Items - No Variants
    [Documentation]    [MKP-5484],Import to create Active To Suspended listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Suspended        0       1       Suspended

Test Import To Create Listings - Active To Suspended - One Items - Have Variants
    [Documentation]    [MKP-5484],Import to create Active To Suspended listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Suspended        1       1       Suspended

Test Import To Create Listings - Inactive - One Items - No Variants
    [Documentation]    [MKP-5479,MKP-5480],Import to create Inactive listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Active           0       1       Inactive

Test Import To Create Listings - Inactive - One Items - Have Variants
    [Documentation]    [MKP-5479,MKP-5480],Import to create Inactive listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Active           1       1       Inactive

Test Import To Create Listings - Inactive To Out Of Stock - One Items - No Variants
    [Documentation]    [MKP-5481],Import to create Inactive To Out Of Stock listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Out of stock     0       1       Out of stock

Test Import To Create Listings - Inactive To Out Of Stock - One Items - Have Variants
    [Documentation]    [MKP-5481],Import to create Inactive To Out Of Stock listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Out of stock     1       1       Out of stock

Test Import To Create Listings - Inactive To Expired - One Items - No Variants
    [Documentation]    [MKP-5482],Import to create Inactive To Expired listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Expired          0       1       Expired

Test Import To Create Listings - Inactive To Expired - One Items - Have Variants
    [Documentation]    [MKP-5482],Import to create Inactive To Expired listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Expired          1       1       Expired

Test Import To Create Listings - Inactive To Suspended - One Items - No Variants
    [Documentation]    [MKP-5484],Import to create Inactive To Suspended listing - No Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Suspended        0       1       Suspended

Test Import To Create Listings - Inactive To Suspended - One Items - Have Variants
    [Documentation]    [MKP-5484],Import to create Inactive To Suspended listing - Have Variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Suspended        1       1       Suspended

