*** Settings ***
Resource            ../../Keywords/MP/UserKeywords.robot
Resource            ../../Keywords/MP/StoreKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - Store
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Seller Pre Application
    [Tags]   mp   create-store
    Send Seller Pre Application - POST

Test Map Manager Sign In
    [Tags]   mp   create-store
    Map Manager Sign In - POST

Test Seller Appplication Approve
    [Tags]   mp   create-store
    Seller Approve On Mik - Post

Test User Create And Sign In
    [Tags]   mp   create-store
    Seller User Create - POST

Tesr Mik Seller Sign In
    [Tags]   mp   create-store
    Mik Seller Sign In - POST

Test Set Company Name
    [Tags]   mp   create-store
    Set Company Name - POST

Test Set Seller Bank Account
    [Tags]   mp   create-store
    Set Seller Bank Account - POST

Test Store Registration
    [Tags]   mp   create-store
    Store Registration - POST

Test Update Store Profile
    [Tags]   mp   create-store
    Mik Seller Refresh Token - POST
    Update Store Profile - POST

Test Update Store Customer Service
    [Tags]   mp   create-store
    Update Store Customer Service - POST

Test Update Store Shipping Rate
    [Tags]   mp   create-store
    Update Store Shipping Rate - POST

Test Update Store Fulfillment
    [Tags]   mp   create-store
    Update Store Fulfillment - Post

Test Update Store Return Option
    [Tags]   mp   create-store
    Update Store Return Option - Post

Test Check Store isEA Seller
    [Tags]   mp   create-store
    Check Store isEA Seller - Get

Test Get Storefront Preview
    [Tags]   mp   create-store
    Get Storefront Preview - Get

Test Get Store Onboarding Verify
    [Tags]   mp   create-store
    Get Store Onboarding Verify - Get

Test Get Store Seller Info
    [Tags]   mp   create-store
    Get Store Seller Info - Get








