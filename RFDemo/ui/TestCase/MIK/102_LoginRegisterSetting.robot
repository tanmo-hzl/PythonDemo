*** Settings ***
Documentation       This is to Login Register Verify Setting
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/LoginRegisterSetting.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...         AND   Open Browser With URL   ${URL_MIK_SIGNIN}   mikLandingUrl
Suite Teardown      Close All Browsers
Test Teardown          Verify Login Status

*** Test Cases ***
Test Buyer Sign up
    [Documentation]   Buyer Sign up
    [Tags]  mik  mik-LoginRegisterSetting  mik-Signup
    Sign up
    Go To Snapmail Browser Verify email
    Go To  ${URL_MIK_SIGNIN}
    Sign in  ${email}  ${password}

Test Verify Setting
    [Documentation]   verify setting
    [Tags]  mik  mik-LoginRegisterSetting  mik-verifysetting
    verify setting
    verify Name And Emaile

Test Add New Address
    [Documentation]   Add New Address
    [Tags]  mik  mik-LoginRegisterSetting  mik-AddAddress
    ${Address_info_dict}  Create Dictionary  firstName=summer
    ...  lastName=summer  addressLine1=5907 Wisdom Creek Dr
    ...  addressLine2=6108 Wisdom Creek Dr  city=Dallas
    ...  state=TX  zipCode=75249  phoneNumber=3252235680
    Add New Address   ${Address_info_dict}

Test Change password
    [Documentation]   Change password
    [Tags]  mik  mik-LoginRegisterSetting  mik-Changepassword
    Change password   ${password}   Password123
    Change password   Password123   ${password}

Test Add New Card
    [Documentation]   Add New Card
    [Tags]  mik  mik-LoginRegisterSetting  mik-AddCard
    ${card_info_dict}  Create Dictionary  cardHolderName=summer
    ...  cardNumber=4032030380807678  expirationDate=1025  cvv=928
    ...  firstName=summer  lastName=summer  addressLine1=5907 Wisdom Creek Dr
    ...  city=Dallas  zipCode=75249  phoneNumber=3252235680
    Add New Card  ${card_info_dict}

Test Add New List
    [Documentation]  Add New List
    [Tags]  mik  mik-LoginRegisterSetting  mik-AddList
    Add New List

Test add product to list and verify Browsing History
    [Documentation]  add product to list and verify Browsing History
    [Tags]  mik  mik-LoginRegisterSetting  mik-BrowsingHistory  mik-addproducttolist
    Add Product To List And Verify Browsing History