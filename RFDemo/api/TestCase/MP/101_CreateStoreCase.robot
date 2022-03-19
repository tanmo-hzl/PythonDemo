*** Settings ***
Resource            ../../Keywords/MP/UserKeywords.robot
Resource            ../../Keywords/MP/StoreKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - Store
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Seller Pre Application
    [Documentation]   user apply for seller store
    [Tags]   mp-ea
    Send Seller Pre Application - POST

Test Map Manager Sign In
    [Documentation]   map user sign in
    [Tags]   mp-ea
    Map Manager Sign In - POST

Test Seller Appplication Approve
    [Documentation]  map user approve application
    [Tags]   mp-ea
    Seller Approve On Mik - Post

Test User Create And Sign In
    [Documentation]  user improve personal information
    [Tags]   mp-ea
    Seller User Create - POST

Tesr Mik Seller Sign In
    [Documentation]  mik seller sign in
    [Tags]    mp-ea
    Mik Seller Sign In - POST

Test Set Seller Bank Account
    [Documentation]  Set Seller Bank
    [Tags]   mp-ea
    Set Seller Bank Account - POST

Test Store Registration
    [Documentation]  register store information
    [Tags]   mp-ea
    Store Registration - POST

Test Update Store Profile
    [Documentation]  update store profile
    [Tags]   mp-ea
    Mik Seller Refresh Token - POST
    Update Store Profile - POST

Test Update Store Customer Service
    [Documentation]  update custome service
    [Tags]   mp-ea
    Update Store Customer Service - POST

Test Update Store Shipping Rate
    [Documentation]  update shipping rate
    [Tags]   mp-ea
    Update Store Shipping Rate - POST

Test Update Store Fulfillment
    [Documentation]  update store fulfillment
    [Tags]   mp-ea
    Update Store Fulfillment - Post

Test Update Store Return Option
    [Documentation]  update return policy
    [Tags]   mp-ea
    Update Store Return Option - Post

Test Check Store isEA Seller
    [Documentation]  check  weather EA seller
    [Tags]   mp-ea
    Check Store isEA Seller - Get

Test Get Storefront Preview
    [Documentation]  get storefrom preview
    [Tags]   mp-ea
    Get Storefront Preview - Get

Test Get Store Onboarding Verify
    [Documentation]  get onboard verify
    [Tags]   mp-ea
    Get Store Onboarding Verify - Get

Test Get Store Seller Info
    [Documentation]  get store infomation
    [Tags]    mp-ea
    Get Store Seller Info - Get


