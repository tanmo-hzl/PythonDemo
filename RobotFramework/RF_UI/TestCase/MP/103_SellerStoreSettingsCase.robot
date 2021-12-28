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
${Par_Case_Status}
${Random_Data}
${Old_Store_Name}   yunStore1

*** Test Cases ***
Test Seller Sign In And Enter Storefront
    [Documentation]    Seller Sign In and enter Storefront Page
    [Tags]    mp    mp-store-setting   mp-store-name    mp-store-address-desc   mp-contact-info
    Set Suite Variable    ${Cur_User_Name}    ${SELLER_NAME}
    User Sign In - MP    ${SELLER_EMAIL}    ${SELLER_PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Update Store Name
    [Documentation]    Seller submit update store name application
    [Tags]   mp-store-name
    Store Left Meun - Store Settings - Store Profile
    ${Store_Name}    Get Random Code    6
    Store Profile - Update Store Name    Store ${Store_Name}
#    User Sign Out

Test Rejected Store Name Update Application
    [Documentation]    Michaels reject seller update store name application
    [Tags]   mp-store-name   mp-store-name-approve
    Sign In Map With Admin Account
    Main Menu - To Marketplace
    Marketplace Left Menu - Vendor Management - Store Management
    Enter Tab - Store Rename Application
    Search By Company Name On Store Rename Application    ${Old_Store_Name}
    Mouse Over To Application By Company Name    ${Old_Store_Name}
    Reject Application

Test Update Store Address And Description
    [Documentation]    Seller update store address and Description
    [Tags]    mp    mp-store-setting   mp-store-address-desc
#    Go To    ${URL_MIK}
    Store Left Meun - Store Settings - Store Profile
    Store Profile - Update Store Address - City
    Store Profile - Update Store Address - State
    Store Profile - Update Strore Address - Zipcode
    Store Profile - Update Store Description
    Store Profile - Show Store Preview Info
    Sotre Settings - Click Button Save

Test Update Customer Service Primary Contact Information
    [Documentation]    Seller update Customer Service Primary Contact Information
    [Tags]    mp    mp-store-setting   mp-contact-info
    Store Left Meun - Store Settings - Customer Service
    Customer Service - Update Primary Contact Info - Email And Phone    ${SELLER_EMAIL}
    Customer Service - Delete Another Select Days
    Customer Service - Unselect All Select Days    0
    Customer Service - Update Primary Contact Info - Select Days    0    ${False}
    Customer Service - Select Time Range By Index And Name    0    start    08   30    AM
    Customer Service - Select Time Range By Index And Name    0    end    06   30    PM
    Customer Service - Add Another Select Days
    Customer Service - Unselect All Select Days    1
    Customer Service - Update Primary Contact Info - Select Days    1    ${True}
    Customer Service - Select Time Range By Index And Name    1    start    09   30    AM
    Customer Service - Select Time Range By Index And Name    1    end    08   30    PM
    Customer Service - Update Primary Contact Info - TimeZone
    Sotre Settings - Click Button Save

Test Update Customer Service Michael Contact Info
    [Documentation]    Seller update Customer Service Michael Contact Info
    [Tags]    mp    mp-store-setting   mp-contact-info
    Store Left Meun - Store Settings - Customer Service
    Customer Service - Remove Another Michael Contact
    Customer Service - Update Michael Contact Info - Unselect All Department    0
    Customer Service - Update Michael Contact Info - Department    0
    Customer Service - Update Michael Contact Info - Email And Phone    0
    Customer Service - Update Michael Contact Info - Add Another Contact
    Customer Service - Update Michael Contact Info - Unselect All Department    1
    Customer Service - Update Michael Contact Info - Department    1
    Customer Service - Update Michael Contact Info - Email And Phone    1
    Customer Service - Update Privacy Policy
    Sotre Settings - Click Button Save

