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
    Add New Address   ${Address_info_dict}
    Wait Until Page Contains  This address already exists within your address book

Test Edit Profile
    [Documentation]   Edit Profile
    [Tags]  mik  mik-LoginRegisterSetting  mik-EditProfile
    ${info_text}  Create Dictionary  firstName=summer   lastName=verify   mobilePhone=3252235680
#    ${Address_info_dict}  Create Dictionary  firstName=test
#    ...  lastName=chen  addressLine1=2035 Allen Genoa Rd
#    ...  addressLine2=2035 Allen Genoa Rd  city=Pasadena
#    ...  state=TX  zipCode=77502  phoneNumber=3189299637
    Edit personal Information  ${info_text}  May  12

Test Change password
    [Documentation]   Change password
    [Tags]  mik  mik-LoginRegisterSetting  mik-Changepassword
    Change password   ${password}   Password123
    wait until page contains  Success
    Change password   Password123   ${password}
    wait until page contains  Success

Test Change password - Fail
    [Documentation]   Change password - Fail
    [Tags]  mik  mik-LoginRegisterSetting  mik-ChangepasswordFail
    Change password   ${password}   ${password}
    wait until page contains      new password cannot be the same as your old password

Test Log Out Device
    [Documentation]   Log Out Device
    [Tags]  mik  mik-LoginRegisterSetting  mik-LogOutDevice
    Log Out Device

Test Add New Card And Edit Card
    [Documentation]   Add New Card
    [Tags]  mik  mik-LoginRegisterSetting  mik-AddCard
    ${card_info_dict}  Create Dictionary  cardHolderName=summer
    ...  cardNumber=4032030380807678  expirationDate=1025  cvv=928
    ...  firstName=summer  lastName=summer  addressLine1=5907 Wisdom Creek Dr
    ...  city=Dallas  zipCode=75249  phoneNumber=3252235680
    Add New Card    ${card_info_dict}
    Add Same Card   ${card_info_dict}
    Edit Card

Test Add New Card And Set Default
    [Documentation]   Add New Card And Set Default
    [Tags]  mik  mik-LoginRegisterSetting  mik-SetDefault
    ${card_info_dict}  Create Dictionary  cardHolderName=summer
    ...  cardNumber=4032039049206990  expirationDate=0826  cvv=099
    ...  firstName=summer  lastName=summer  addressLine1=5907 Wisdom Creek Dr
    ...  city=Dallas  zipCode=75249  phoneNumber=3252235680
    Add New Card    ${card_info_dict}
    Setting The Default Card

Test Remove Card
    [Documentation]   Remove Card
    [Tags]  mik  mik-LoginRegisterSetting  mik-RemoveCard
    Remove Card

Test Add Gift Cards And Remove Card
    [Documentation]   Add Gift Cards And Remove Card
    [Tags]  mik  mik-LoginRegisterSetting  mik-AddGiftCards  mik-RemoveCard
    Verify Gitf Card And Remove Card  6006496912999907486  5171