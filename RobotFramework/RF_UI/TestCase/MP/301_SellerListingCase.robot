*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keyword   Initial Data And Open Browser   ${URL_MIK}
Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS
${Par_Case_Status}
${Random_Data}


*** Test Cases ***
Test Seller Sign In And Enter Storefront
    [Documentation]    Seller Sign In and enter Storefront Page
    [Tags]    mp    mp-listing   mp-lst-update   mp-lst-crt   mp-lst-crt-v
    Set Suite Variable    ${Cur_User_Name}    ${NAME}
    User Sign In - MP    ${EMAIL}    ${LISTING_PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}


Test Create New Listing - No Variants
    [Documentation]    Eneter Listing Management Page and create new listing don't have variants
    [Tags]    mp    mp-listing   mp-lst-crt
    ${Random_Data}    Get Random Data
    Set Suite Variable    ${Random_Data}    ${Random_Data}
    Store Left Menu - Listing Management
    Click Create A Listing Button
    Create - Input Listing Title
    Create - Select Listing Category
    Create - Input Barand And Manufacturer
    Create - Select Recommented Age
    Create - Input Description
    Create - Input Listing Tags
    Create - Input Date Range - Availabel
    Create - Click Save And Next
    Create - Upload Photos
    Create - Input Price And Quantity
    Create - Click Save And Next
    Create - Input Item Attributes - Color Family
    Create - Input Item Attributes - GTIN
    Create - Input Item Volume
    Create - Click Save And Next
    Create - Enter Listing Confirmation Page
    Create - Click Publish Campaign And Select Next Page
    [Teardown]    Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}


Test Create New Listing - Have Variants
    [Documentation]    Eneter Listing Management Page and create new listing hava variants
    [Tags]    mp    mp-listing    mp-lst-crt-v
    Run Keyword If    '${Par_Case_Status}'=='FAIL'    Create - Stop Create Listing
    ${Random_Data}    Get Random Data
    Set Suite Variable    ${Random_Data}    ${Random_Data}
    Store Left Menu - Listing Management
    Click Create A Listing Button
    Create - Input Listing Title
    Create - Select Listing Category
    Create - Input Barand And Manufacturer
    Create - Select Recommented Age
    Create - Input Description
    Create - Input Listing Tags
    Create - Input Date Range - Availabel
    Create - Click Save And Next
    Create - Upload Photos
    Create - Open Add Variations Pop-up Windows   # add variants to item
    Create - Select Variant Type One
    Create - Add Value To Variant One - Not Color
    Create - Add More Variations
    Create - Select Variant Type Two    Color
    Create - Add Value To Variant Two - Color
    Create - Save Add Variations
    Create - Upload Photos To Vaiantions
    Create - Input Variant Inventory And Price
    Create - Click Save And Next
    Create - Open Item Attributes Pop-up Window for Variations
    Create - Input Item Attributes - GTIN
    Create - Input Item Volume
    Create - Close Item Attributes Pop-up Window for Variations
    Create - Click Save And Next
    Create - Enter Listing Confirmation Page
    Create - Click Publish Campaign And Select Next Page
    [Teardown]    Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Update Listing
    [Documentation]    Update listing information
    [Tags]    mp    mp-listing   mp-lst-update
    ${Random_Data}    Get Random Data
    Set Suite Variable    ${Random_Data}    ${Random_Data}
    Run Keyword If    '${Par_Case_Status}'=='FAIL'    Create - Stop Create Listing
    Store Left Menu - Listing Management
    Filters - Clear All Filters
    Filters - Search Listing By Status    Active
    Enter Listing Detail Page By Index     1
    Update - Change Listing Title
    Update - Change Listing Category
    Update - Change Barand Name And Manufacturer
    Update - Change Selected Recommented Age
    Update - Change Description
    Update - Change Listing Tags
    Update - Select Item Has No End Date
#    Update - Change Price And Inverntory
    Update - Click Update Changes
    [Teardown]    Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Search Listing By Status Draft And Delete
    [Documentation]    Delete listing which status is Draft
    [Tags]    mp    mp-listing
    Run Keyword If    '${Par_Case_Status}'=='FAIL'    Update - Stop Update Listing
    Filters - Clear All Filters
    Filters - Search Listing By Status    Draft
    Set Listing Selected By Index
    Delete Lisitng After Selected Draft Item
    Check Listing Status By Title    Archived

Test Search Listing By Listing Title
    [Documentation]    Search listing by name which is delete
    [Tags]    mp    mp-listing
    Filters - Clear All Filters
    Filters - Search Listing By Status    Archived
    Search Lisitng By Title    ${Selected_Item_Name}

Test Search Listing By Status Archived And Recover
    [Documentation]    Recover listing which status is Archived
    [Tags]    mp    mp-listing
    Filters - Clear All Filters
    Filters - Search Listing By Status    Archived
    Set Listing Selected By Index
    Recover Listing After Selected Archived Item
    Check Listing Status By Title    Inactive

Test Search Listing By Status Inactive And Relist
    [Documentation]    Relist listing which status is Inactive
    [Tags]    mp    mp-listing
    Filters - Clear All Filters
    Filters - Search Listing By Status    Inactive
    Set Listing Selected By Index
    Relist Listing After Selected Inactive Item