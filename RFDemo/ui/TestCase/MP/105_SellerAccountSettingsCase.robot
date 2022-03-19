*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerAccountSettingsKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/account-settings


*** Test Cases ***
Test Check Account Settings Page Fixed Element text
    [Documentation]   Check Account Settings page fixed element text
    [Tags]  mp    mp-ea    ea-s-account    ea-s-account-ele
    Store Left Menu - Account Settings
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerAccountSettings.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    productGroups

Test Update Password And Rest It
    [Documentation]    Update seller's password and reset it
    [Tags]    mp    mp-ea    ea-s-account
    Store Left Menu - Account Settings
    Update - Input Current Password    ${SELLER_PWD}
    Update - Input New Password    ${SELLER_PWD_NEW}
    Save - Click Change Password
    Update - Input Current Password    ${SELLER_PWD_NEW}
    Update - Input New Password    ${SELLER_PWD}
    Save - Click Change Password

