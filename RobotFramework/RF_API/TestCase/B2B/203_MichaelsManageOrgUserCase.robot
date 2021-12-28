*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/OrganizationUserKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - OrganizationUser
Suite Teardown       Delete All Sessions

*** Test Cases ***
#Test Get Organizations List
#    [Tags]    b2b    b2b-m-user
#    Get Michaels Organizations List - GET

#Test Michaels Add New Organzition
#    [Tags]    b2b    b2b-m-user
#    Michaels Add New Organization - POST

Test Get Organizations Detail
    [Tags]    b2b    b2b-m-user
    Get Organization Detail - GET

Test Organizations User Invite
    [Tags]    b2b    b2b-m-user
    Organization User Invite - POST

Test Get Organizations Pending User List
    [Tags]    b2b    b2b-m-user
    Get Organization Pending User List - POST

Test Get Organizations Pending User Detail
    [Tags]    b2b    b2b-m-user
    Get Organzition Pending User Detail - GET

Test Organizations Pending User Activate
    [Tags]    b2b    b2b-m-user
    Organization Pending User Activate - POST

Test Get Organizations Active User List
    [Tags]    b2b    b2b-m-user
    Get Organization Active User List- POST

Test Get Organizations Active User Detail
    [Tags]    b2b    b2b-m-user
    Get Organzition Active User Detail - GET

Test Get Organization Approval Groups Info
    [Tags]    b2b    b2b-m-user
    Get Organization Approval Groups Info - GET

Test Set Org User Can Approval Order
    [Tags]    b2b    b2b-m-user
    Set Org User Approval Permission - PATCH    ${Approval_Group_Id}

Test Check Org User Have Approval Permission
    [Tags]    b2b    b2b-m-user
    Get Org User Approval Permission - GET
    Check Org User Approval Permission    1

Test Set Org User Can't Approval Order
    [Tags]    b2b    b2b-m-user
    Set Org User Can't Approval Order - PATCH

Test Check Org User Not Have Approval Permission
    [Tags]    b2b    b2b-m-user
    Get Org User Approval Permission - GET
    Check Org User Approval Permission    0

Test Change Organizations User Info
    [Tags]    b2b    b2b-m-user
    Change Organization User Info - PATCH

Test Update Organization User Status To Inactive
    [Tags]    b2b    b2b-m-user
    Update Organization User Status - PATCH     INACTIVE
    Get Organization Active User List By Name- POST
    Check Org User Status    INACTIVE

Test Update Organization User Status To Active
    [Tags]    b2b    b2b-m-user
    Update Organization User Status - PATCH     ACTIVE
    Get Organization Active User List By Name- POST
    Check Org User Status    ACTIVE

Test Update Organization User Status To Removed
    [Tags]    b2b    b2b-m-user
    Update Organization User Status - PATCH     REMOVED

Test Delete Organization Pending User
    [Tags]    b2b    b2b-m-user
    Organization User Invite - POST
    Get Organization Pending User List - POST
    Organization Pending User Delete - PATCH