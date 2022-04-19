*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords    Initial Env Data
...                             AND    Open And Reset Downloads Directory For Chrome  ${URL_MIK_SIGNIN}${Return_Url}    ${Download_Dir}
...                             AND   User Sign In - MP   ${SELLER_LST_EMAIL}    ${SELLER_PWD}    ${SELLER_LST_NAME}
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
${Download_Dir}    EA-2

*** Test Cases ***
Test Import To Update Listings No Changed - No Variants
    [Documentation]    Download one listing by status then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Out of stock    ${False}    ${False}    ${None}    ${None}    Out of stock
    Inactive        ${False}    ${False}    ${None}    ${None}    Inactive
    Suspended       ${False}    ${False}    ${None}    ${None}    Suspended

Test Download Active Listing And Update Status Then Import It - No Variants
    [Documentation]    [MKP-5497,MKP-5499,MKP-5503],Download Active listing and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Active    ${False}    ${True}     Suspended         Active          Suspended
    Active    ${False}    ${True}     Inactive          Inactive        Inactive
    Active    ${False}    ${True}     Expired           Active          Expired
    Active    ${False}    ${True}     Out of stock      Inactive        Out of stock
    Active    ${False}    ${True}     Out of stock      Active          Out of stock

Test Download Draft Listing And Update Status Then Import It - No Variants
    [Documentation]    [MKP-5505,MKP-5506],Download Draft listing and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Draft     ${False}    ${True}    Active         Active          Active
    Draft     ${False}    ${True}    Draft          Draft           Draft
    Draft     ${False}    ${True}    Suspended      Active          Suspended
    Draft     ${False}    ${True}    Inactive       Inactive        Inactive
    Draft     ${False}    ${True}    Out of stock   Inactive        Out of stock
    Draft     ${False}    ${True}    Out of stock   Active          Out of stock
    Draft     ${False}    ${True}    Expired        Draft           Expired
    Draft     ${False}    ${True}    Expired        Active          Expired
    Draft     ${False}    ${True}    Expired        Inactive        Expired

Test Download Expired Listing And Update Status Then Import It - No Variants
    [Documentation]    [MKP-5500,MKP-5501],Download Expired listing after and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Expired   ${False}    ${True}    Active             Active          Active
    Expired   ${False}    ${True}    Suspended          Active          Suspended
    Expired   ${False}    ${True}    Suspended          Inactive        Suspended
    Expired   ${False}    ${True}    Inactive           Inactive        Inactive
    Expired   ${False}    ${True}    Expired            Inactive        Expired
    Expired   ${False}    ${True}    Expired            Active          Expired
    Expired   ${False}    ${True}    Out of stock       Inactive        Out of stock
    Expired   ${False}    ${True}    Out of stock       Active          Out of stock

Test Download Out of stock Listing And Update Status Then Import It - No Variants
    [Documentation]    [MKP-5502],Download Out of stock listing and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Out of stock   ${False}    ${True}    Suspended         Active          Suspended
    Out of stock   ${False}    ${True}    Suspended         Inactive        Suspended
    Out of stock   ${False}    ${True}    Expired           Inactive        Expired
    Out of stock   ${False}    ${True}    Expired           Active          Expired
    Out of stock   ${False}    ${True}    Out of stock      Inactive        Out of stock
    Out of stock   ${False}    ${True}    Out of stock      Active          Out of stock
    Out of stock   ${False}    ${True}    Active            Active          Active
    Out of stock   ${False}    ${True}    Inactive          Inactive        Inactive

Test Download Inactive Listing And Update Status Then Import It - No Variants
    [Documentation]    [MKP-5504],Download Inactive listing  and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Inactive    ${False}    ${True}    Active           Active          Active
    Inactive    ${False}    ${True}    Suspended        Active          Suspended
    Inactive    ${False}    ${True}    Suspended        Inactive        Suspended
    Inactive    ${False}    ${True}    Expired          Active          Expired
    Inactive    ${False}    ${True}    Expired          Inactive        Expired
    Inactive    ${False}    ${True}    Out of stock     Inactive        Out of stock
    Inactive    ${False}    ${True}    Out of stock     Active          Out of stock

Test Download Suspended Listing And Update Status Then Import It - No Variants
    [Documentation]    [MKP-5507,MKP-5508],Download Suspended listing  and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Suspended    ${False}    ${True}    Active           Active             Active
    Suspended    ${False}    ${True}    Active           Inactive           Inactive
    Suspended    ${False}    ${True}    Suspended        Inactive           Suspended
    Suspended    ${False}    ${True}    Suspended        Active             Suspended
    Suspended    ${False}    ${True}    Expired          Active             Expired
    Suspended    ${False}    ${True}    Out of stock     Active             Out of stock
    Suspended    ${False}    ${True}    Out of stock     Inactive           Out of stock
