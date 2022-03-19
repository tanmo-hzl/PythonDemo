*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
...                             AND    API - Seller Sign In And Get Order Info
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

Test Create New Listing - Save Draft On Step 1
    [Documentation]    Create new no variant listing and save draft on step 1
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
    [Tags]    mp    mp-ea    ea-lst   ea-lst-draft2
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
    [Documentation]    Create new have variant listing and save draft on step 3
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

Test Create New Listing - No Variants
    [Documentation]    Eneter Listing Management Page and create new listing don't have variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create1
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
    [Documentation]    Eneter Listing Management Page and create new listing don't have variants and Inventory Zero
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    ${Listing_Info}    Get Listing Body
    ${Listing_Info}    Update Listing Value By Keys    ${Listing_Info}    0    singleSku    quantity
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Click Create A Listing Button
    Flow - Create - Step 1
    Create - Click Save And Next
    Flow - Create - Step 2 - No Variants
    Create - Click Save And Next    2
    Flow - Create - Step 3 - No Variants
    Create - Enter Listing Confirmation Page
    Create - Click Publish Campaign And Select Next Page
    Listing - Check Listing Publish Success    Out of stock

Test Create New Listing - Have Variants - Size
    [Documentation]    Create new listing hava one variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Flow - Create Listing - Have Variants
    Listing - Check Listing Publish Success

Test Create New Listing - Have Variants - Size And Color
    [Documentation]    Create new listing hava two variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    Set Suite Variable     ${Variant_Quantity}    2
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Flow - Create Listing - Have Variants
    Listing - Check Listing Publish Success

Test Create New Listing - Have Variants - Size And Color And Count
    [Documentation]    Create new listing hava three variants
    [Tags]    mp    mp-ea    ea-lst    ea-lst-create
    Set Suite Variable     ${Variant_Quantity}    3
    ${Listing_Info}    Get Listing Body    ${True}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Flow - Create Listing - Have Variants
    Listing - Check Listing Publish Success

Test Update Draft Listing And Save Changes - No Variants
    [Documentation]    Update Draft listing information and save changes
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${False}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Enter Listing Detail Page By Variants Or Not    ${False}
    Flow - Update Listing - Update All Information
    Update - Click Save Changes
    Listing - Check Listing Save Draft Success

Test Update Draft Listing And Publish - No Variants
    [Documentation]    Update Draft listing information and publish
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${False}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Enter Listing Detail Page By Variants Or Not    ${False}
    Flow - Update Listing - Update All Information
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success

Test Update Draft Listing And Save Changes - Have Variants
    [Documentation]    Update Draft listing information and save changes
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${False}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Enter Listing Detail Page By Variants Or Not    ${True}
    Flow - Update Listing - Update All Information
    Update - Click Save Changes
    Listing - Check Listing Save Draft Success

Test Update Draft Listing And Publish - Have Variants
    [Documentation]    Update Draft listing information and publish
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    Set Suite Variable     ${Variant_Quantity}    1
    ${Listing_Info}    Get Listing Body    ${False}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Enter Listing Detail Page By Variants Or Not    ${True}
    Flow - Update Listing - Update All Information
    Update - Click Publish
    Create&Update - Publish Confirmed
    Listing - Check Listing Publish Success

Test Update Active Listing Without Price And Inventory
    [Documentation]    Update active listing information and save changes
    [Tags]    mp    mp-ea    ea-lst    ea-lst-update
    ${Listing_Info}    Get Listing Body    ${False}    ${True}    3
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    Listing - Filter - Search Listing By Status Single    Active
    Listing - Enter Listing Detail Page By Index     1
    Update - Change Listing Title
    Update - Change Barand Name And Manufacturer
    Create&Update - Select Optional Info    ${False}
    Update - Change Description
    Update - Change Listing Tags
    Update - Change Date Range End
    Update - Change Subscription Setting
    Update - Upload Photos
    Create&Update - Set Shipping Policy
    Create&Update - Override Shipping Rate
    Create&Update - Set Return Policy
    Update - Click Save Changes

Test Shipping Rate's Switch and Input Box
    [Documentation]    Update active listing information and save changes
    [Tags]    mp    mp-ea   ea-lst   ea-lst-update
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

Test Delete One Listing Which Status Draft
    [Documentation]    Delete listing which status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Set Multiple Listings Selected By Status    Draft    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover One Listing Which Status Is Draft To Archived
    [Documentation]    Recover listing which status is Archived which parent status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    1
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Deactivate One Listing Which Status Is Active
    [Documentation]    Deactivate listing which status is Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Active
    Listing - Set Multiple Listings Selected By Status    Active    1
    Listing - Deactivate Listing After Seleted Active Item
    Listing - Check Listing Status By Title    Inactive

Test Delete One Listing Which Status Is Active To Inactive
    [Documentation]    Delete listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover One Listing Which Status Is Inactive To Archived
    [Documentation]    Recover listing which status is Archived and parent status is Inactive, Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    1
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist One Listing Which Status Is Archived To Inactive
    [Documentation]    Relist listing which status is Inactive and the parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete One Listing Which Status Is Expired
    [Documentation]    Delete one listing which status is expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover One Listing Which Status Is Expired To Archived
    [Documentation]    Recover one listing which status is Archived and parent status is Expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    1
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist One Listing Which Status Is Archived To Expired
    [Documentation]    Relist two listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete Three Listing Which Status Is Draft
    [Documentation]    Delete three listing which status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Set Multiple Listings Selected By Status    Draft    3
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Draft To Archived
    [Documentation]    Recover two listing which status is Archived and parent status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Deactivate Three Listing Which Status Is Active
    [Documentation]    Deactivate three listing which status is Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Active
    Listing - Set Multiple Listings Selected By Status    Active    3
    Listing - Deactivate Listing After Seleted Active Item   3
    Listing - Check Listing Status By Title    Inactive

Test Delete Three Listing Which Status Is Active To Inactive
    [Documentation]    Delete two listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    3
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Inactive To Archived
    [Documentation]    Recover two listing which status is Archived and parent status is Inactive, Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist Two Listing Which Status Is Archived To Inactive
    [Documentation]    Relist two listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    2
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete Two Listing Which Status Is Expired
    [Documentation]    Delete one listing which status is expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    2
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Expired To Archived
    [Documentation]    Recover one listing which status is Archived and parent status is Expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist Two Listing Which Status Is Archived To Expired
    [Documentation]    Relist two listing which status is Inactive and parent status is Expired,Archived
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    2
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete Two Listing Which Status Is Expired And Inactive
    [Documentation]    Delete one listing which status is expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Clear All Filter
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Expired And Inactive To Archived
    [Documentation]    Recover one listing which status is Archived and parent status is Expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Clear All Filter
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist Two Listing Which Status Is Expired And Inactive
    [Documentation]    Relist two listing which status is Inactive and parent status is Expired,Archived
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Clear All Filter
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

#Test Check Category Variant Type
#    [Documentation]    Check category variant type
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
    Active              ${True}
    Draft               ${True}
    Inactive            ${True}
    Suspended           ${True}
    Expired             ${True}
    Out of Stock        ${True}
    Archived            ${False}
    Prohibited          ${False}
    Pending Review      ${False}

Test Download Template Listing Excel By Random Category
    [Documentation]    Download template listing excel by random category
    [Tags]   mp   mp-ea   ea-lst    ea-lst-download
    Listing - Download Listing Excel Template By Random Category

Test Download Template Listing Excel By All Category
    [Documentation]    Download template listing excel by all category
    [Tags]   mp   mp-ea   ea-lst    ea-lst-download
    Listing - Download Listing Excel Template By All Category

Test Download Listing By Status Then Import It - No Variants
    [Documentation]    Download one listing by status then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Expired         ${False}    ${False}    ${None}    ${None}    Expired
    Out of stock    ${False}    ${False}    ${None}    ${None}    Out of stock
    Inactive        ${False}    ${False}    ${None}    ${None}    Inactive
    Active          ${False}    ${False}    ${None}    ${None}    Active
    Suspended       ${False}    ${False}    ${None}    ${None}    Suspended

Test Download Listing By Status Then Import It - Have Variants
    [Documentation]    Download one listing by status then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Expired         ${True}     ${False}    ${None}    ${None}    Expired
    Out of stock    ${True}     ${False}    ${None}    ${None}    Out of stock
    Inactive        ${True}     ${False}    ${None}    ${None}    Inactive
    Active          ${True}     ${False}    ${None}    ${None}    Active
    Suspended       ${True}     ${False}    ${None}    ${None}    Suspended

Test Import To Create Listing - Draft - No Variants
    [Documentation]    Import to create draft listing, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Active           0       1       Draft
    Draft      Suspended        0       1       Suspended
    Draft      Expired          0       1       Expired
    Draft      Out of stock     0       1       Draft

Test Import To Create Listing - Draft - Have Variants
    [Documentation]    Import to create draft listing, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Active           1       1       Draft
    Draft      Suspended        1       1       Suspended
    Draft      Expired          1       1       Expired
    Draft      Out of stock     1       1       Out of stock

Test Import To Create Listing - Draft - Single and Variants
    [Documentation]    Import to create draft listing, single and variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Draft      Active           2       1       Draft
    Draft      Suspended        2       1       Suspended
    Draft      Expired          2       1       Expired
    Draft      Out of stock     2       1       Draft

Test Import To Create Listing - Active - No Variants
    [Documentation]    Import to create draft listing, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Active           0       2       Active
    Active      Suspended        0       2       Suspended
    Active      Expired          0       2       Expired
    Active      Out of stock     0       2       Out of stock

Test Import To Create Listing - Active - Have Variants
    [Documentation]    Import to create draft listing, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Active           1       1       Active
    Active      Suspended        1       1       Suspended
    Active      Expired          1       1       Expired
    Active      Out of stock     1       1       Out of stock

Test Import To Create Listing - Active - Single and Variants
    [Documentation]    Import to create draft listing, single and variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Active      Active           2       1       Active
    Active      Suspended        2       1       Suspended
    Active      Expired          2       1       Expired
    Active      Out of stock     2       1       Out of stock

Test Import To Create Listing - Inactive - No Variants
    [Documentation]    Import to create draft listing, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Active           0       1       Inactive
    Inactive      Suspended        0       1       Suspended
    Inactive      Expired          0       1       Expired
    Inactive      Out of stock     0       1       Inactive

Test Import To Create Listing - Inactive - Have Variants
    [Documentation]    Import to create draft listing, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Active           1       2       Inactive
    Inactive      Suspended        1       2       Suspended
    Inactive      Expired          1       2       Expired
    Inactive      Out of stock     1       2       Inactive

Test Import To Create Listing - Inactive - Single and Variants
    [Documentation]    Import to create draft listing, single and variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import To Create Listing
    Inactive      Active           2       2       Inactive
    Inactive      Suspended        2       2       Suspended
    Inactive      Expired          2       2       Expired
    Inactive      Out of stock     2       2       Inactive

Test Download Active Listing And Update Status Then Import It - No Variants
    [Documentation]    Download Active listing and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Active    ${False}    ${True}     Suspended         Active          Suspended
    Active    ${False}    ${True}     Inactive          Inactive        Inactive
    Active    ${False}    ${True}     Expired           Active          Expired
    Active    ${False}    ${True}     Out of stock      Inactive        Out of stock
    Active    ${False}    ${True}     Out of stock      Active          Out of stock

Test Download Active Listing And Update Status Then Import It - Have Variants
    [Documentation]    Download Active listing and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Active    ${True}    ${True}     Suspended          Inactive        Suspended
    Active    ${True}    ${True}     Inactive           Inactive        Inactive
    Active    ${True}    ${True}     Expired            Active          Expired
    Active    ${True}    ${True}     Out of stock       Active          Out of stock
    Active    ${True}    ${True}     Out of stock       Inactive        Out of stock

Test Download Draft Listing And Update Status Then Import It - No Variants
    [Documentation]    Download Draft listing and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Draft     ${False}    ${True}    Active         Active          Active
    Draft     ${False}    ${True}    Draft          Draft           Draft
    Draft     ${False}    ${True}    Suspended      Active          Suspended
    Draft     ${False}    ${True}    Inactive       Inactive        Inactive
    Draft     ${False}    ${True}    Out of stock   Inactive        Inactive
    Draft     ${False}    ${True}    Out of stock   Active          Out of stock
    Draft     ${False}    ${True}    Expired        Draft           Expired
    Draft     ${False}    ${True}    Expired        Active          Expired
    Draft     ${False}    ${True}    Expired        Inactive        Expired

Test Download Draft Listing And Update Status Then Import It - Have Variants
    [Documentation]    Download Draft listing and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Draft     ${True}    ${True}    Active         Active          Active
    Draft     ${True}    ${True}    Draft          Draft           Draft
    Draft     ${True}    ${True}    Suspended      Active          Suspended
    Draft     ${True}    ${True}    Inactive       Inactive        Inactive
    Draft     ${True}    ${True}    Out of stock   Inactive        Inactive
    Draft     ${True}    ${True}    Out of stock   Active          Out of stock
    Draft     ${True}    ${True}    Expired        Draft           Expired
    Draft     ${True}    ${True}    Expired        Active          Expired
    Draft     ${True}    ${True}    Expired        Inactive        Expired

Test Download Expired Listing And Update Status Then Import It - No Variants
    [Documentation]    Download Expired listing after and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Expired   ${False}    ${True}    Active             Active          Active
    Expired   ${False}    ${True}    Suspended          Active          Suspended
    Expired   ${False}    ${True}    Suspended          Inactive        Suspended
    Expired   ${False}    ${True}    Inactive           Inactive        Inactive
    Expired   ${False}    ${True}    Expired            Inactive        Expired
    Expired   ${False}    ${True}    Expired            Active          Expired
    Expired   ${False}    ${True}    Out of stock       Inactive        Out of stock
    Expired   ${False}    ${True}    Out of stock       Active          Out of stock

Test Download Expired Listing And Update Status Then Import It - Have Variants
    [Documentation]    Download Expired listing after and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Expired   ${True}    ${True}    Active             Active          Active
    Expired   ${True}    ${True}    Suspended          Active          Suspended
    Expired   ${True}    ${True}    Suspended          Inctive         Suspended
    Expired   ${True}    ${True}    Inactive           Inactive        Inactive
    Expired   ${True}    ${True}    Expired            Inactive        Expired
    Expired   ${True}    ${True}    Expired            Active          Expired
    Expired   ${True}    ${True}    Out of stock       Inactive        Out of stock
    Expired   ${True}    ${True}    Out of stock       Active          Out of stock

Test Download Out of stock Listing And Update Status Then Import It - No Variants
    [Documentation]    Download Out of stock listing and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Out of stock   ${False}    ${True}    Suspended         Active          Suspended
    Out of stock   ${False}    ${True}    Suspended         Inactive        Suspended
    Out of stock   ${False}    ${True}    Expired           Inactive        Expired
    Out of stock   ${False}    ${True}    Expired           Active          Expired
    Out of stock   ${False}    ${True}    Out of stock      Inactive        Out of stock
    Out of stock   ${False}    ${True}    Out of stock      Active          Out of stock
    Out of stock   ${False}    ${True}    Active            Active          Active
    Out of stock   ${False}    ${True}    Inactive          Inactive        Inactive

Test Download Out of stock Listing And Update Status Then Import It - Have Variants
    [Documentation]    Download Out of stock listing and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Out of stock   ${True}    ${True}    Suspended         Active          Suspended
    Out of stock   ${True}    ${True}    Suspended         Inactive        Suspended
    Out of stock   ${True}    ${True}    Expired           Inactive        Expired
    Out of stock   ${True}    ${True}    Expired           Active          Expired
    Out of stock   ${True}    ${True}    Out of stock      Inactive        Out of stock
    Out of stock   ${True}    ${True}    Out of stock      Active          Out of stock
    Out of stock   ${True}    ${True}    Active            Active          Active
    Out of stock   ${True}    ${True}    Inactive          Inactive        Inactive

Test Download Inactive Listing And Update Status Then Import It - No Variants
    [Documentation]    Download Inactive listing  and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Inactive    ${False}    ${True}    Active           Active          Active
    Inactive    ${False}    ${True}    Suspended        Active          Suspended
    Inactive    ${False}    ${True}    Suspended        Inactive        Suspended
    Inactive    ${False}    ${True}    Expired          Active          Expired
    Inactive    ${False}    ${True}    Expired          Inactive        Expired
    Inactive    ${False}    ${True}    Out of stock     Inactive        Out of stock
    Inactive    ${False}    ${True}    Out of stock     Active          Out of stock

Test Download Inactive Listing And Update Status Then Import It - Have Variants
    [Documentation]    Download Inactive listing  and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Inactive    ${True}    ${True}    Active           Active          Active
    Inactive    ${True}    ${True}    Suspended        Active          Suspended
    Inactive    ${True}    ${True}    Suspended        Inactive        Suspended
    Inactive    ${True}    ${True}    Expired          Active          Expired
    Inactive    ${True}    ${True}    Expired          Inactive        Expired
    Inactive    ${True}    ${True}    Out of stock     Inactive        Out of stock
    Inactive    ${True}    ${True}    Out of stock     Active          Out of stock

Test Download Suspended Listing And Update Status Then Import It - No Variants
    [Documentation]    Download Suspended listing  and update info then import it, no variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Suspended    ${False}    ${True}    Active           Active             Active
    Suspended    ${False}    ${True}    Active           Inactive           Inactive
    Suspended    ${False}    ${True}    Suspended        Inactive           Suspended
    Suspended    ${False}    ${True}    Suspended        Active             Suspended
    Suspended    ${False}    ${True}    Expired          Active             Expired
    Suspended    ${False}    ${True}    Out of stock     Active             Out of stock
    Suspended    ${False}    ${True}    Out of stock     Inactive           Out of stock

Test Download Suspended Listing And Update Status Then Import It - Have Variants
    [Documentation]    Download Suspended listing  and update info then import it, have variants
    [Tags]   mp   mp-ea   ea-lst    ea-lst-import
    [Template]    Listing - Import to Update listing After Export
    Suspended    ${True}    ${True}    Active           Active             Active
    Suspended    ${True}    ${True}    Active           Inactive           Inactive
    Suspended    ${True}    ${True}    Suspended        Inactive           Suspended
    Suspended    ${True}    ${True}    Suspended        Active             Suspended
    Suspended    ${True}    ${True}    Expired          Active             Expired
    Suspended    ${True}    ${True}    Out of stock     Active             Out of stock
    Suspended    ${True}    ${True}    Out of stock     Inactive           Out of stock