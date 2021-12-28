*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/UserKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - User
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Michaeks User Get Public Key
    [Tags]   b2b    b2b-user
    Michaels User Get Public Key - GET

Test Michaels User Sign In
    [Tags]   b2b    b2b-user
    Michaels User Sign In Secure - POST

Test Get Michaels User Roles
    [Tags]  b2b    b2b-user
    Get Michaels User Roles - GET

Test Get Michaels User Profile
    [Tags]  b2b    b2b-user
    Get Michaels User Profile - GET

Test Change Michaels User Profile
    [Tags]  b2b    b2b-user
    Change Michaels User Profile - PATCH

Test Update Michaels User To New Password
    [Tags]  b2b    b2b-user
    Update Michaels User Password - PATCH    ${PWD}    ${NEW_PWD}

Test Michaels User Sign Out
    [Tags]  b2b    b2b-user
    Michaels User Sign Out - POST

Test Michaels User Sign In By New Password
    [Tags]  b2b    b2b-user
    Set Suite Variable    ${Cur_PWD}    ${NEW_PWD}
    Michaels User Sign In Secure - POST

Test Update Michaels User To Old Password
    [Tags]  b2b    b2b-user
    Update Michaels User Password - PATCH    ${NEW_PWD}    ${MICHAELS_PWD}

Test Michaels User Sign In By Old Password
    [Tags]  b2b    b2b-user
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST
    Michaels User Sign Out - POST




