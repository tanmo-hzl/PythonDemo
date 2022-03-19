*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/WishlistsKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Wishlists
Suite Teardown       Delete All Sessions


*** Test Cases ***
Get User Wishlists
    [Tags]    b2b    b2b-wishlists
    Get User Wishlists - GET

Add New Wishlists
    [Tags]    b2b    b2b-wishlists
    Add User Wishlists - POST

Update Wishlists Name
    [Tags]    b2b    b2b-wishlists
    Update Wishlists Name - PUT

Add Items To Wishlists
    [Tags]    b2b    b2b-wishlists
    Add Items To Wishlists - POST

Get Wishlists Items
    [Tags]    b2b    b2b-wishlists
    Get Wishlists Item - GET

Remove Item From Wishlists
    [Tags]    b2b    b2b-wishlists
    Remove Items From Wishlists - DELETE

Remove Wishlists
    [Tags]    b2b    b2b-wishlists
    Remove Wishlists - DELETE
