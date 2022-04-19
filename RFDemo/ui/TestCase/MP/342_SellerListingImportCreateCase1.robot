*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords    Initial Env Data
...                             AND    Open And Reset Downloads Directory For Chrome  ${URL_MIK_SIGNIN}${Return_Url}    ${Download_Dir}
...                             AND    User Sign In - MP   ${SELLER_LST_EMAIL}    ${SELLER_PWD}    ${SELLER_LST_NAME}
...                             AND    API - Seller Sign In    ${SELLER_LST_EMAIL}    ${SELLER_PWD}
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
${Download_Dir}    EA-11

*** Test Cases ***
Test Import To Update Listings No Changed - Expired - No Variants
    [Documentation]    Download one listing by status then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Expired          ${False}    ${False}    ${None}    ${None}    Expired

Test Import To Update Listings No Changed - Expired - Have Variants
    [Documentation]    Download one listing by status then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Expired          ${True}     ${False}    ${None}    ${None}    Expired

Test Import To Create Listing - Draft - Single and Variants
    [Documentation]    Import to create draft listing, single and variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Active           2       1       Draft
    Draft      Suspended        2       1       Suspended
    Draft      Expired          2       1       Expired
    Draft      Out of stock     2       1       Draft

Test Import To Create Listing - Active - Single and Variants
    [Documentation]    Import to create draft listing, single and variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Active           2       1       Active
    Active      Suspended        2       1       Suspended
    Active      Expired          2       1       Expired
    Active      Out of stock     2       1       Out of stock

Test Import To Create Listing - Inactive - Single and Variants
    [Documentation]    Import to create draft listing, single and variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Active           2       2       Inactive
    Inactive      Suspended        2       2       Suspended
    Inactive      Expired          2       2       Expired
    Inactive      Out of stock     2       2       Out of stock