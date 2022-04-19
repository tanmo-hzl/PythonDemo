*** Settings ***
Documentation       This is to Login Register Verify Setting
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/LoginRegisterSetting.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...         AND   Open Browser With URL   ${URL_MIK_SIGNIN}   mikLandingUrl
Suite Teardown      Close All Browsers
Test Setup      Go To  ${URL_MIK_profile}

*** Test Cases ***
Test Add New List
    [Documentation]  Add New List
    [Tags]  mik  mik-ListHistory  mik-AddList
    Sign in  ${setting_email}  ${setting_pwd}
    Add New List And Verify
    Add New List

Test Add Product To List
    [Documentation]  Add Product To List
    [Tags]  mik  mik-ListHistory  mik-addproducttolist
    Add Product To List

Test Verify Browsing History The PDP
    [Documentation]  Verify Browsing History The PDP
    [Tags]  mik  mik-ListHistory  mik-BrowsingHistoryPDP
    Verify Browsing History The PDP

Test Verify Browsing History And Remove
    [Documentation]  Verify Browsing History And Remove
    [Tags]  mik  mik-ListHistory  mik-RemoveBrowsingHistory
    Verify Browsing History And Remove

Test Verify Wish List - Favorites
    [Documentation]  Verify Wish List - Favorites
    [Tags]  mik  mik-ListHistory  mik-WishListFavorites
    Verify Wish List - Favorites   Wish List
    Verify Wish List - Favorites   Favorites

Test Verify My List Ordering
    [Documentation]  Verify My List Ordering
    [Tags]  mik  mik-ListHistory  mik-MyListOrdering
    Verify My List Ordering

Test Verify My List And Remove
    [Documentation]  Verify My List And Remove
    [Tags]  mik  mik-ListHistory  mik-VerifyMyList
    Verify My List And Remove

Test Verify Dashboard
    [Documentation]  Verify Dashboard
    [Tags]  mik  mik-ListHistory  mik-VerifyDashboard
    Verify Dashboard