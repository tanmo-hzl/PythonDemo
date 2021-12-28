*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerAccountSettingsKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keyword    Initial Data And Open Browser   ${URL_MIK}
Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS

*** Test Cases ***
Test Seller Sign In And Enter Storefront
    [Documentation]    Seller Sign In and enter Storefront Page
    [Tags]    mp    mp-seller-account
    Set Suite Variable    ${Cur_User_Name}    ${SELLER_NAME}
    User Sign In - MP    ${SELLER_EMAIL}    ${SELLER_PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Update Password
    [Documentation]    Update seller's password
    [Tags]    mp    mp-seller-account
    Store Left Menu - Account Settings
    update - Input Current Password    ${SELLER_PWD}
    update - Input New Password    ${SELLER_PWD_NEW}
    Save - Click Change Password


Test Check Password Is Changed And Reset Password
    [Documentation]    Check password is changed and reset password
    [Tags]    mp    mp-seller-account
    update - Input Current Password    ${SELLER_PWD_NEW}
    update - Input New Password    ${SELLER_PWD}
    Save - Click Change Password

