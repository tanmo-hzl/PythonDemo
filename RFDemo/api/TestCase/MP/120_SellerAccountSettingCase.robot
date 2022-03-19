*** Settings ***
Resource            ../../Keywords/MP/SellerAccountSettingKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - AccountSetting
Suite Teardown       Delete All Sessions

*** Variables ***


*** Test Cases ***
Test Get User Device
    [Documentation]  query user device
    [Tags]    mp   mp-ea   ea-seller-account
    Get Account User Device - Get

Test Change Password
    [Documentation]  change password
    [Tags]    mp   mp-ea   ea-seller-account
   Update Account Two Factor Verify Code - Post
#   Update Account Two Factor Verify Auth - Post
   Update Account Password Secure - Post

Test Delete User Device
    [Documentation]  delete user device
    [Tags]    mp   mp-ea   ea-seller-account
    Delete Account User Device - Delete