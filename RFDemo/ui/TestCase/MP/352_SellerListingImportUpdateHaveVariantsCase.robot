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
${Download_Dir}    EA-3

*** Test Cases ***
Test Import To Update Listings No Changed - Have Variants
    [Documentation]    Download one listing by status then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Out of stock    ${True}     ${False}    ${None}    ${None}    Out of stock
    Inactive        ${True}     ${False}    ${None}    ${None}    Inactive
    Suspended       ${True}     ${False}    ${None}    ${None}    Suspended

Test Download Active Listing And Update Status Then Import It - Have Variants
    [Documentation]    [MKP-5497,MKP-5499,MKP-5503],Download Active listing and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Active    ${True}    ${True}     Suspended          Inactive        Suspended
    Active    ${True}    ${True}     Inactive           Inactive        Inactive
    Active    ${True}    ${True}     Expired            Active          Expired
    Active    ${True}    ${True}     Out of stock       Active          Out of stock
    Active    ${True}    ${True}     Out of stock       Inactive        Out of stock


Test Download Draft Listing And Update Status Then Import It - Have Variants
    [Documentation]    [MKP-5505,MKP-5506],Download Draft listing and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Draft     ${True}    ${True}    Active         Active          Active
    Draft     ${True}    ${True}    Draft          Draft           Draft
    Draft     ${True}    ${True}    Suspended      Active          Suspended
    Draft     ${True}    ${True}    Inactive       Inactive        Inactive
    Draft     ${True}    ${True}    Out of stock   Inactive        Out of stock
    Draft     ${True}    ${True}    Out of stock   Active          Out of stock
    Draft     ${True}    ${True}    Expired        Draft           Expired
    Draft     ${True}    ${True}    Expired        Active          Expired
    Draft     ${True}    ${True}    Expired        Inactive        Expired

Test Download Expired Listing And Update Status Then Import It - Have Variants
    [Documentation]    [MKP-5500,MKP-5501],Download Expired listing after and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Expired   ${True}    ${True}    Active             Active          Active
    Expired   ${True}    ${True}    Suspended          Active          Suspended
    Expired   ${True}    ${True}    Suspended          Inactive        Suspended
    Expired   ${True}    ${True}    Inactive           Inactive        Inactive
    Expired   ${True}    ${True}    Expired            Inactive        Expired
    Expired   ${True}    ${True}    Expired            Active          Expired
    Expired   ${True}    ${True}    Out of stock       Inactive        Out of stock
    Expired   ${True}    ${True}    Out of stock       Active          Out of stock

Test Download Out of stock Listing And Update Status Then Import It - Have Variants
    [Documentation]    [MKP-5502],Download Out of stock listing and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Out of stock   ${True}    ${True}    Suspended         Active          Suspended
    Out of stock   ${True}    ${True}    Suspended         Inactive        Suspended
    Out of stock   ${True}    ${True}    Expired           Inactive        Expired
    Out of stock   ${True}    ${True}    Expired           Active          Expired
    Out of stock   ${True}    ${True}    Out of stock      Inactive        Out of stock
    Out of stock   ${True}    ${True}    Out of stock      Active          Out of stock
    Out of stock   ${True}    ${True}    Active            Active          Active
    Out of stock   ${True}    ${True}    Inactive          Inactive        Inactive

Test Download Inactive Listing And Update Status Then Import It - Have Variants
    [Documentation]    [MKP-5504],Download Inactive listing  and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Inactive    ${True}    ${True}    Active           Active          Active
    Inactive    ${True}    ${True}    Suspended        Active          Suspended
    Inactive    ${True}    ${True}    Suspended        Inactive        Suspended
    Inactive    ${True}    ${True}    Expired          Active          Expired
    Inactive    ${True}    ${True}    Expired          Inactive        Expired
    Inactive    ${True}    ${True}    Out of stock     Inactive        Out of stock
    Inactive    ${True}    ${True}    Out of stock     Active          Out of stock

Test Download Suspended Listing And Update Status Then Import It - Have Variants
    [Documentation]    [MKP-5507,MKP-5508],Download Suspended listing  and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Update Listing
    Suspended    ${True}    ${True}    Active           Active             Active
    Suspended    ${True}    ${True}    Active           Inactive           Inactive
    Suspended    ${True}    ${True}    Suspended        Inactive           Suspended
    Suspended    ${True}    ${True}    Suspended        Active             Suspended
    Suspended    ${True}    ${True}    Expired          Active             Expired
    Suspended    ${True}    ${True}    Out of stock     Active             Out of stock
    Suspended    ${True}    ${True}    Out of stock     Inactive           Out of stock

#    5515 导入更新，增加变体
#    5516 导入更新，删除变体