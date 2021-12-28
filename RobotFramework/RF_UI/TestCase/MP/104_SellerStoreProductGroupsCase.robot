*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerStoreSettingsKeywords.robot
Resource            ../../Keywords/MAP/MarketplaceStoreManagementKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keyword   Initial Data And Open Browser   ${URL_MIK}
Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS
${Group_Count}


*** Test Cases ***
Test Seller Sign In And Enter Storefront
    [Documentation]    Seller Sign In and enter Storefront Page
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    Set Suite Variable    ${Cur_User_Name}    ${SELLER_NAME}
    User Sign In - MP    ${SELLER_EMAIL}    ${SELLER_PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Create Product Groups
    [Documentation]   Add a new product groups
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    Store Left Meun - Store Settings - Product Groups
    Product Groups - Click Button - Create Product Groups
    Product Groups - Waiting Edit Page Load
    Product Groups - Input Group Name
    Product Groups - Search Listing    t
    Product Groups - Add Items To Group After Search
    Product Groups - Stop Search Listing
    Product Groups - Click Button - Save

Test Update Product Groups
    [Documentation]   Update product groups
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    Product Groups - Click Button Name With Group Name   edit    ${New_Group_Name}
    Product Groups - Waiting Edit Page Load
    Product Groups - Delete Added Listing If Existed
    Product Groups - Search Listing    t
    Product Groups - Add Items To Group After Search
    Product Groups - Stop Search Listing
    Product Groups - Click Button - Save

Test Show And Hide Group Items On List
    [Documentation]   Show and hide product group items
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    Product Groups - Click Button Name With Line Index    chevron-down    1
    Product Groups - Waiting Group Items Show
    Product Groups - Click Button Name With Group Name    chevron-up    ${New_Group_Name}
    Product Groups - Waiting Group Items Show    ${False}

Test Copy Product Groups
    [Documentation]   Copy product groups
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    ${count}    Product Groups - Get Total Group Quantity
    Product Groups - Click Button Name With Group Name    copy    ${New_Group_Name}
    Sleep    1
    ${new_count}    Product Groups - Get Total Group Quantity
    ${count1}    Evaluate    ${count}+1
    Should be Equal As Numbers    ${count1}    ${new_count}

Test Set Group Visible On Storefront
    [Documentation]   Set group visible on storefront
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    Product Groups - Set Group Visible On StoreFront By Index   2    ${False}
    Product Groups - Set Group Visible On StoreFront By Name    ${New_Group_Name}

Test Preview Product Groups In Storefront
    [Documentation]    Preview product groups in storefront
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    Product Groups - Preview In Storefront And Back    ${New_Group_Name}
    [Teardown]     Switch Window

Test Delete Added Product Groups
    [Documentation]   Delete Add product groups
    [Tags]    mp    mp-store-setting   mp-store-pro-group
    ${old_count}    Product Groups - Get Total Group Quantity
    Product Groups - Click Button Name With Line Index    trash    2
    Product Groups - Delete Group Pop-up Window
    Sleep    1
    Product Groups - Click Button Name With Group Name    trash    ${New_Group_Name}
    Product Groups - Delete Group Pop-up Window
    ${count}    Product Groups - Get Total Group Quantity
#    ${count1}    Evaluate    ${count}+2
#    Should be Equal As Strings    ${count1}    ${old_count}