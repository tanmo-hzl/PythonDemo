*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyOrganizations.py
Resource            ../../TestData/B2B/PathOrganizations.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${Michaels_User_Info}
${Headers_Michaels_Get}
${Headers_Michaels_Post}
${New_Org_Info}
${Org_Id}
${Pending_User_Token}
${Pending_User_Info}
${Active_User_Info}
${Pending_User_Id}
${Active_User_Id}
${Approval_Group_Id}
${Active_User_Org_Info}
${User_Approval_Permissions}
${Cur_Org_User_Info}

*** Keywords ***
Set Initial Data - B2B - OrganizationUser
    Initial Env Data     configB2B.ini
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST
    ${user_id}    Get Json Value    ${Michaels_User_Info}    michaelsUser    id
    Set Suite Variable    ${User_Id}    ${user_id}

Get Organization Detail - GET
    ${New_Org_Info}    Read File    new-org-info
    ${Org_Id}    Get Json Value     ${New_Org_Info}     organizationId
    Set Suite Variable    ${Org_Id}    ${Org_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${ORG}/${Org_Id}    ${null}     ${Headers_Michaels_Get}

Get Organization Active User List- POST
    ${body}    Get Org Active User Body
    Request Get Org Active User     ${body}

Get Organization Active User List By Name- POST
    ${name}    Get Json Value    ${Active_User_Info}    firstName
    ${body}    Get Org Active User Body    ${name}
    Request Get Org Active User     ${body}

Request Get Org Active User
    [Arguments]    ${body}
    ${params}    Get Org Active User Search Params
    ${res}    Send Post Request - Params And Json    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_ACTIVE_USER_LIST}    ${params}    ${body}    ${Headers_Michaels_Post}
    Set Suite Variable    ${Cur_Org_User_Info}     ${res.json()[0]}
    ${Active_User_Id}    Get Json Value    ${Cur_Org_User_Info}    userId
    Set Suite Variable    ${Active_User_Id}    ${Active_User_Id}

Check Org User Status
    [Arguments]    ${status}
    ${new_status}   Get Json Value    ${Cur_Org_User_Info}    status
    Should Be Equal As Strings    ${status}    ${new_status}

Get Organzition Active User Detail - GET
    ${res}    Send Get Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_USER}/${Active_User_Id}    ${null}    ${Headers_Michaels_Get}
    ${Active_User_Info}    Get Json Value     ${res.json()}    userProfile
    Set Suite Variable    ${Active_User_Info}    ${Active_User_Info}
    ${Active_User_Org_Info}    Get Json Value     ${res.json()}    parentOrganizationAccess
    Set Suite Variable    ${Active_User_Org_Info}    ${Active_User_Org_Info}
    ${Active_User_Id}    Get Json Value     ${Active_User_Info}    id
    Set Suite Variable    ${Active_User_Id}    ${Active_User_Id}

Get Organization Approval Groups Info - GET
    ${body}    Create Dictionary    organizationId=${Org_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${ORG_APPROVAL_GROUPS}    ${body}    ${Headers_Michaels_Get}
    ${Approval_Group_Id}    Get Json Value    ${res.json()}    approvalGroupId
    Set Suite Variable    ${Approval_Group_Id}    ${Approval_Group_Id}

Set Org User Approval Permission - PATCH
    [Arguments]    ${group_id}
    ${approval_groups}    Create List    ${group_id}
    ${body}    Create Dictionary    approvalGroups=${approval_groups}
    ${res}    Send Patch Request    ${URL-B2B}    ${ORG_USER_APPROVAL_GROUPS_SET}/${Active_User_Id}    ${body}    ${Headers_Michaels_Post}    204

Get Org User Approval Permission - GET
    ${body}    Create Dictionary    userId=${Active_User_Id}    organizationIds=${Org_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${ORG_USER_APPROVAL_PERMISSIONS}    ${body}    ${HEADERS_MICHAELS_GET}
    Set Suite Variable    ${User_Approval_Permissions}    ${res.json()[0]}

Check Org User Approval Permission
    [Arguments]    ${permission}
    ${approval_type}    Get Json Value    ${User_Approval_Permissions}    approvalObjectTypes
    ${len}    Get Length    ${approval_type}
    Should Be Equal As Strings    ${permission}    ${len}

Set Org User Can't Approval Order - PATCH
    ${approval_groups}    Create List
    ${body}    Create Dictionary    approvalGroups=${approval_groups}
    ${res}    Send Patch Request    ${URL-B2B}    ${ORG_USER_APPROVAL_GROUPS_SET}/${Active_User_Id}    ${body}    ${Headers_Michaels_Post}   204

Change Organization User Info - PATCH
    [Documentation]    role : VIEWER2, VIEWER, BUYER, ADMIN, SUB_ACCOUNT_ADMIN, SUB_ACCOUNT_BUYER, SUB_ACCOUNT_VIEWER, SUB_ACCOUNT_VIEWER2
    ${roles}    Create List    ADMIN    BUYER    VIEWER    VIEWER2
    ${role}    Evaluate    random.sample(${roles},1)[0]
    Set To Dictionary    ${Active_User_Org_Info}    role=${role}
    ${body}    Get Change Org User Body    ${Active_User_Info}    ${Active_User_Org_Info}    ${NULL}
    ${res}    Send Patch Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_USER}/${Active_User_Id}    ${body}    ${Headers_Michaels_Post}   204

Update Organization User Status - PATCH
    [Documentation]   INACTIVE/ACTIVE/REMOVED
    [Arguments]    ${status}=INACTIVE
    ${body}    Create Dictionary    status=${status}
    ${res}    Send Patch Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_USER}/${Active_User_Id}/status    ${body}    ${Headers_Michaels_Post}    204

Organization User Invite - POST
    [Documentation]    role list: ADMIN,BUYER,VIEWER,VIEWER2
    [Arguments]    ${role}=ADMIN
    ${body}    Get Invite User Body    ${Org_Id}    ${role}
    ${res}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_INVITED_USER}    ${body}    ${Headers_Michaels_Post}   201

Get Organization Pending User List - POST
    ${params}    Get Org Pending User Search Params
    ${body}    Get Org Pending User Body
    ${res}    Send Post Request - Params And Json    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_PENDING_USER_LIST}    ${params}    ${body}    ${Headers_Michaels_Post}
    ${Pending_User_Id}    Get Json Value    ${res.json()}    joinOrganizationRequestId
    Set Suite Variable    ${Pending_User_Id}    ${Pending_User_Id}

Get Organzition Pending User Detail - GET
    ${res}    Send Get Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_PENDING_USER_DETAIL}/${Pending_User_Id}    ${null}    ${Headers_Michaels_Get}
    ${Pending_User_Token}    Get Json Value     ${res.json()}    token
    ${Pending_User_Info}    Get Json Value     ${res.json()}    userProfile
    Set Suite Variable    ${Pending_User_Token}    ${Pending_User_Token}
    Set Suite Variable    ${Pending_User_Info}    ${Pending_User_Info}

Organization Pending User Activate - POST
    ${params}    Create Dictionary    token=${Pending_User_Token}
    ${body}    Get Org User Activate Body    ${Pending_User_Info}    ${PWD}
    ${res}    Send Post Request - Params And Json   ${URL-B2B}    ${ORG_USER}    ${params}    ${body}    ${Headers_Michaels_Post}   201

Organization Pending User Delete - PATCH
    ${body}    Create Dictionary    status=REMOVED
    ${res}    Send Patch Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_PENDING_USER_DETAIL}/${Pending_User_Id}    ${body}    ${Headers_Michaels_Post}    204







