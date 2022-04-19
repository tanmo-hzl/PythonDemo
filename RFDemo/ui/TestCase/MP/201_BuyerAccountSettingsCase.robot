*** Settings ***
Library             ../../Libraries/MP/BuyerAccountInfoLib.py
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Resource            ../../Keywords/MP/BuyerAccountSettingKeywords.robot

Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
Suite Teardown      Close All Browsers

*** Variables ***
${Return_Url}    ?returnUrl=/buyertools/profile


*** Test Cases ***
Test Update Profile
    [Documentation]    Update buyer profile
    [Tags]    mp    ea-buyer-account    ea-buyer-profile
    Buyer Left Menu - Account Information - Profile
    Buyer - Profile - Update - Profile    ${BUYER_NAME}    AU
    Buyer - Profile - Update Profile - Click Button Save
    Buyer - Profile - Update - Profile    ${BUYER_NAME}    Auto
    Buyer - Profile - Update Profile - Click Button Save
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Manage Buyer Address - Add New Address
    [Documentation]    Add buyer Shipping address
    [Tags]    mp    mp-ea    ea-buyer-account    ea-buyer-address
    Buyer Left Menu - Account Information - Profile
    ${Address_Info}    Get Address Info
    Set Suite Variable    ${Address_Info}    ${Address_Info}
    Buyer - Profile - Address - Add A New Address
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Manage Buyer Address - Edit Address
    [Documentation]    Edit buyer Shipping address
    [Tags]    mp    ea-buyer-account    ea-buyer-address
    Buyer Left Menu - Account Information - Profile
    ${Address_Info}    Get Address Info
    Set Suite Variable    ${Address_Info}    ${Address_Info}
    Buyer - Profile - Address - Edit Address By Index
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Manage Buyer Address - Delete Address
    [Documentation]    Delete buyer Shipping address
    [Tags]    mp    mp-ea    ea-buyer-account    ea-buyer-address
    Buyer Left Menu - Account Information - Profile
    Buyer - Profile - Address - Remove Address By Index    1
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Manage Buyer Address - Set Default Address
    [Documentation]    Set default buyer Shipping address
    [Tags]    mp    mp-ea    ea-buyer-account    ea-buyer-address
    Buyer Left Menu - Account Information - Profile
#    Buyer - Profile - Address - Enter Manage Address Page
    Buyer - Profile - Address - Set Default Address By Index    1
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Buyer Update Password
    [Documentation]    Update buyer's password
    [Tags]    mp    ea-buyer-account    ea-buyer-account
    Buyer Left Menu - Account Information - Account Settings
    Buyer - Account Setting - update - Input Current Password    ${BUYER_PWD}
    Buyer - Account Setting - update - Input New Password    ${BUYER_PWD_NEW}
    Buyer - Account Setting - Save - Click Change Password
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Check Password Is Changed And Reset Password
    [Documentation]    Check password is changed and reset password
    [Tags]    mp    ea-buyer-account    ea-buyer-account
    Buyer Left Menu - Account Information - Account Settings
    Buyer - Account Setting - update - Input Current Password    ${BUYER_PWD_NEW}
    Buyer - Account Setting - update - Input New Password    ${BUYER_PWD}
    Buyer - Account Setting - Save - Click Change Password
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Add New Card If Account Don't Have Card
    [Documentation]  Add a new card if this accout don't have card
    [Tags]    mp    mp-ea    ea-buyer-account    ea-buyer-wallet
    Buyer Left Menu - Account Information - Wallet
    Buyer - Wallet - Add A New Card
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Add New or Additional Card
    [Documentation]    Add new card for buyer
    [Tags]    mp    ea-buyer-account    ea-buyer-wallet
    Buyer Left Menu - Account Information - Wallet
    Buyer - Wallet - Add Card Flow
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Edit Buyer Card
    [Documentation]    Edit buyer card Info
    [Tags]    mp    ea-buyer-account    ea-buyer-wallet
    Buyer Left Menu - Account Information - Wallet
    ${Card_Info}    Get Card Info    ${False}
    Set Suite Variable    ${Card_Info}    ${Card_Info}
    Buyer - Wallet - Click Edit By Index
    Buyer - Wallet - Update Card Infor
    Buyer - Wallet - Update Billing Address
    Buyer - Wallet - Save Card Info
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

Test Remove Buyer Card
    [Documentation]    Remove buyer card Info
    [Tags]    mp    ea-buyer-account    ea-buyer-wallet
    Buyer Left Menu - Account Information - Wallet
    Buyer - Wallet - Remove Card By Index
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

