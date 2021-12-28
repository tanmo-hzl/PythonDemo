*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/CommonRSA.py
Library             ../../Libraries/B2B/RequestBodyUser.py
Resource            ../../TestData/B2B/PathUser.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot

*** Variables ***
${Public_Data_Info}
${Email_Password}
${Headers_Michaels_Get}
${Headers_Michaels_Post}
${Michaels_User_Info}
${Michaels_User_Profile}
${New_Phone}
${Cur_PWD}
${Headers_User_Get}
${Headers_User_Post}
${B2B_User_Info}
${B2B_User_Id}
${B2B_User_Org_Id}
${B2B_User_Org_Info}



*** Keywords ***
Set Initial Data - B2B - User
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${PWD}

Michaels User Get Public Key - GET
    [Documentation]  Get sign in publick key
    ${res}    Send Get Request Without Token   ${URL-MAP}    ${MICHAELS_GET_PUBLIC_KEY}     ${null}
    ${Public_Data_Info}    Get Json Value    ${res.json()}    data
    Set Suite Variable     ${Public_Data_Info}    ${Public_Data_Info}

Michaels User Sign In Secure - POST
    [Documentation]  Sign in michaels user
    Michaels User Get Public Key - GET
    ${public_key}    Get Json Value    ${Public_Data_Info}    publicKey
    ${server_time}    Get Json Value    ${Public_Data_Info}    serverTime
    ${user_data}    Create Dictionary    email=${MICHAELS_EMAIL}    password=${Cur_PWD}    serverTime=${server_time}
    ${Email_Password}    Rsa Encrypt Sha256 Msg By Key    ${public_key}    ${user_data}
    ${body}    Create Dictionary    emailPassword=${Email_Password}
    ${res}    Send Post Request Without Token    ${URL-MAP}    ${MICHAELS_SIGN_IN_SECURE}    ${body}
    ${data}    Get Json Value    ${res.json()}    data
    ${token}    Get Json Value    ${data}    token
    Save File    michaels-user-info-sign     ${data}
    Save File    token-michaels    ${token}
    ${Headers_Michaels_Get}     Set Get Headers - B2B - Michaels
    ${Headers_Michaels_Post}     Set Post Headers - B2B - Michaels
    Set Suite Variable    ${Michaels_User_Info}    ${data}
    Set Suite Variable    ${Headers_Michaels_Get}    ${Headers_Michaels_Get}
    Set Suite Variable    ${Headers_Michaels_Post}    ${Headers_Michaels_Post}

Get Michaels User Roles - GET
    ${headers}    Set Variable    ${Headers_Michaels_Post}
    ${headers}    Add Admin Token To Headers - B2B - Michaels    ${headers}
    ${res}     Send Post Request    ${URL-MAP}    ${GET_USER_ROLE}    ${NULL}    ${headers}

Get Michaels User Profile - GET
    ${headers}    Set Variable    ${Headers_Michaels_Get}
    ${headers}    Add Admin Token To Headers - B2B - Michaels    ${headers}
    ${res}     Send Get Request    ${URL-MAP}    ${GET_USER_PROFILE}    ${NULL}    ${headers}
    ${Michaels_User_Profile}    Get Json Value    ${res.json()}    data
    Set Suite Variable     ${Michaels_User_Profile}    ${Michaels_User_Profile}

Change Michaels User Profile - PATCH
    ${headers}    Set Variable    ${Headers_Michaels_Post}
    ${headers}    Add Admin Token To Headers - B2B - Michaels    ${headers}
    ${New_Phone}    Evaluate    '1873647'+str(random.randint(100,999))
    ${body}    Create Dictionary    phone=${New_Phone}
    ${res}     Send Patch Request    ${URL-MAP}    ${GET_USER_PROFILE}    ${body}    ${headers}
    ${Michaels_User_Profile}    Get Json Value    ${res.json()}    data
    ${phone}     Get Json Value    ${Michaels_User_Profile}    michaelsUser    phone
    Should Be Equal As Strings    ${phone}    ${New_Phone}

Update Michaels User Password - PATCH
    [Arguments]    ${old_pwd}    ${cur_new_pwd}
    ${headers}    Set Variable    ${Headers_Michaels_Post}
    ${headers}    Add Admin Token To Headers - B2B - Michaels    ${headers}
    ${body}    Create Dictionary    password=${old_pwd}      newPassword=${cur_new_pwd}
    ${res}     Send Patch Request    ${URL-MAP}    ${UPDATE_USER_PWD}    ${body}    ${headers}

Michaels User Sign Out - POST
    ${headers}    Set Variable    ${Headers_Michaels_Post}
    ${headers}    Add Admin Token To Headers - B2B - Michaels    ${headers}
    ${res}     Send Post Request    ${URL-MAP}    ${MICHAELS_USER_SIGN_OUT}    ${NULL}    ${headers}

Get User User Approval Permissions - GET
    ${res}     Send Get Request    ${URL-MAP}    ${USER_APPROVAL_PERMISSIONS}    ${NULL}    ${Headers_Michaels_Get}

B2B User Get Public Key - GET
    [Documentation]  Get sign in publick key
    ${res}    Send Get Request Without Token   ${URL-USR}    ${USER_GET_PUBLIC_KEY}     ${null}
    ${Public_Data_Info}    Get Json Value    ${res.json()}    data
    Set Suite Variable     ${Public_Data_Info}    ${Public_Data_Info}

B2B User Sign In - POST
    [Documentation]  Sign in - user
    [Arguments]    ${email}
    B2B User Get Public Key - GET
    ${public_key}    Get Json Value    ${Public_Data_Info}    publicKey
    ${server_time}    Get Json Value    ${Public_Data_Info}    serverTime
    ${user_data}    Create Dictionary    email=${email}    password=${Cur_PWD}    serverTime=${server_time}
    ${email_password}    Rsa Encrypt Sha256 Msg By Key    ${public_key}    ${user_data}
#    ${email_password}    Str To Url Encode    ${email_password}
    ${body}    Get User Sign In Body    ${email}
    Set To Dictionary    ${body}    emailPassword=${Email_Password}
    ${res}    Send Post Request Without Token    ${URL-B2B}    ${USER_SIGN_IN}    ${body}
    ${data}    Set Variable    ${res.json()}
    ${token}    Get Json Value    ${data}    token
    ${B2B_User_Id}    Get Json Value    ${data}    user    id
    Save File    b2b-user-info-sign     ${data}
    Set Suite Variable    ${B2B_User_Info}    ${data}
    Set Suite Variable    ${B2B_User_Id}    ${B2B_User_Id}
    Set B2B User Header    ${token}

Set B2B User Header
    [Arguments]    ${token}
    Save File    token-b2b-user    Bearer ${token}
    ${Headers_User_Get}     Set Get Headers - B2B - User
    ${Headers_User_Post}     Set Post Headers - B2B - User
    Set Suite Variable    ${Headers_User_Get}    ${Headers_User_Get}
    Set Suite Variable    ${Headers_User_Post}    ${Headers_User_Post}

B2B User Refresh Token - POST
    ${sessionId}    Get Json Value    ${B2B_User_Info}    sessionId
    ${body}    Create Dictionary    sessionId=${sessionId}
    ${res}    Send Post Request    ${URL-USR}    ${USER_REFRESH_TOKEN}    ${body}    ${Headers_User_Post}
    ${token}    Get Json Value    ${res.json()}    data    token
    Set B2B User Header    ${token}

B2B Get User Info - GET
    ${res}    Send Get Request    ${URL-USR}    ${USER}    ${NULL}    ${Headers_User_Get}

B2B Get User Organization List - GET
    ${res}    Send Get Request    ${URL-B2B}    ${USERS}/${B2B_User_Id}${USER_ORG_HIERARCHY}    ${null}    ${Headers_User_Get}
    Save File    b2b-user-org-list     ${res.json()}
    Set Suite Variable    ${B2B_User_Org_Info}    ${res.json()}
    ${B2B_User_Org_Id}    Get Json Value    ${B2B_User_Org_Info}    organization    organizationId
    Set Suite Variable    ${B2B_User_Org_Id}    ${B2B_User_Org_Id}

B2B User Sign Out - POST
    ${body}    Create Dictionary
    ${res}    Send Post Request    ${URL-USR}    ${USER_SIGN_OUT}    ${body}    ${Headers_User_Post}



