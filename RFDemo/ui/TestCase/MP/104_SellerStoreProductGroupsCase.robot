*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerStoreSettingsKeywords.robot
Resource            ../../Keywords/MAP/MarketplaceStoreManagementKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/product-groups
${Group_Count}


*** Test Cases ***
Test Check Store Settings - Product Groups Page Fixed Element text
    [Documentation]   Check Product Groups page fixed element text
    [Tags]  mp    mp-ea    ea-store-group    ea-store-group-ele
    Store Left Meun - Store Settings - Product Groups
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerStoreSettings.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    productGroups

Test Create Product Groups
    [Documentation]   Add a new product groups
    [Tags]    mp    mp-ea    ea-store-group
    Store Left Meun - Store Settings - Product Groups
    Product Groups - Click Button - Create Product Groups
    Product Groups - Input Group Name
    Product Groups - Search Listing    t
    Product Groups - Add Items To Group After Search
    Product Groups - Stop Search Listing
    Product Groups - Click Button - Save
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Product Groups - Click Button - Back

Test Copy Product Groups
    [Documentation]   Copy product groups
    [Tags]    mp    mp-ea    ea-store-group
    ${count}    Product Groups - Get Total Group Quantity
    Product Groups - Get Group Name By Index
    Product Groups - Copy Group By Group Name    ${Cur_Group_Name}
    ${new_count}    Product Groups - Get Total Group Quantity
    ${count1}    Evaluate    ${count}+1
    Should be Equal As Numbers    ${count1}    ${new_count}

Test Update Copy Product Groups
    [Documentation]   Update product groups
    [Tags]    mp    mp-ea    ea-store-group
    Product Groups - Edit Group By Group Name     ${Cur_Group_Name} - copy
    Product Groups - Delete Added Listing If Existed
    Product Groups - Search Listing    t
    Product Groups - Add Items To Group After Search
    Product Groups - Stop Search Listing
    Product Groups - Click Button - Save
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Product Groups - Click Button - Back

Test Show And Hide Group Items On List
    [Documentation]   Show and hide product group items
    [Tags]    mp    mp-ea    ea-store-group
    Product Groups - Show Group Item By Group Name    ${Cur_Group_Name}
    Product Groups - Hide Group Item By Group Name    ${Cur_Group_Name}

Test Set Group Visible In Storefront
    [Documentation]   Set group visible in storefront
    [Tags]    mp    mp-ea    ea-store-group
    Product Groups - Set Group Visible In StoreFront By Name    ${Cur_Group_Name}

Test Preview Product Groups In Storefront
    [Documentation]    Preview product groups in storefront
    [Tags]    mp    mp-ea    ea-store-group
    Product Groups - Preview In Storefront And Back    ${Cur_Group_Name}
    [Teardown]     Switch Window

Test Delete Added Product Groups
    [Documentation]   Delete Add product groups
    [Tags]    mp    mp-ea    ea-store-group
    ${old_count}    Product Groups - Get Total Group Quantity
    Product Groups - Delete Group By Group Name    ${Cur_Group_Name}
    Sleep    1
    Product Groups - Delete Group By Group Name    ${Cur_Group_Name} - copy
    ${count}    Product Groups - Get Total Group Quantity
    ${count1}    Evaluate    ${count}+2
    Should be Equal As Strings    ${count1}    ${old_count}