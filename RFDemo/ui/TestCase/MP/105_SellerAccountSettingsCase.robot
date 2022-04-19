*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerAccountSettingsKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/account-settings
${Email_Prefix}

*** Test Cases ***
Test Seller Sign In With Open Or Close Two Step Verification
    [Documentation]   [MKP-6916],Seller Sign In With Open Or Close Two Step Verification
    [Tags]  mp    mp-ea    ea-s-account
    Initial Env Data
    ${email_prefix}    Evaluate    "${SELLER_ACT_EMAIL}".split("@")\[0\]
    Set Suite Variable    ${Email_Prefix}    ${email_prefix}
    Flow - Add Email To Snapmail    ${Email_Prefix}
    Seller Account - Sign In With Two Step Verification    ${None}     ${URL_MIK_SIGNIN}${Return_Url}
    ...    ${SELLER_ACT_EMAIL}    ${SELLER_PWD}    ${SELLER_ACT_NAME}

Test Seller Account - Open Or Close Two Step Verification
    [Documentation]   [MKP-6915], Seller Account - Open Or Close Two Step Verification
    [Tags]  mp    mp-ea    ea-s-account
    ${is_opened}    Seller Account - Check Two Step Verification Is Open
    IF    "${is_opened}"=="${False}"
        Page Should Contain    By leaving this additional security measure disabled,
        Seller Account - Open Two Step Verification      ${True}     1
    ELSE
        Page Should Contain    Your Michaels account Two Step Verification is enabled.
        Seller Account - Open Two Step Verification      ${False}    1
    END

Test Check Account Settings Page Fixed Element text
    [Documentation]   Check Account Settings page fixed element text
    [Tags]  mp    mp-ea    ea-s-account    ea-s-account-ele
    Store Left Menu - Account Settings
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerAccountSettings.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    productGroups

Test Update Password And Reset It
    [Documentation]    [MKP-6927],Update seller's password and reset it
    [Tags]    mp    mp-ea    ea-s-account
    Store Left Menu - Account Settings
    Update - Input Current Password    ${SELLER_PWD}
    Update - Input New Password    ${SELLER_PWD_NEW}
    Save - Click Change Password
    Update - Input Current Password    ${SELLER_PWD_NEW}
    Update - Input New Password    ${SELLER_PWD}
    Save - Click Change Password

Test Update Password With Error Current Password
    [Documentation]    [MKP-6927],Update Password With Error Current Password
    [Tags]    mp    mp-ea    ea-s-account
    Store Left Menu - Account Settings
    Update - Input Current Password    123123123
    Update - Input New Password    ${SELLER_PWD_NEW}
    Click Element    //div[text()="CHANGE PASSWORD"]/parent::button
    Wait Until Page Contains    Sorry, this does not match our records. Check your spelling and try again.



