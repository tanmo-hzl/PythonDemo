*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyNotifications.py
Resource            ../../TestData/B2B/PathNotifications.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${Michaels_User_Info}
${Headers_Michaels_Get}
${Headers_Michaels_Post}
${Notification_Info}

*** Keywords ***
Set Initial Data - B2B - Notifications
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST

Get User Notifications List - GET
    ${user_id}    Get Json Value    ${Michaels_User_Info}    michaelsUser    id
    ${body}    Get Notifications Body    ${user_id}
    ${res}    Send Get Request    ${URL-B2B}    ${GET_USER_NOTIFICATIONS}    ${body}    ${Headers_Michaels_Get}
    ${len}    Get Length    ${res.json()}
    Set Suite Variable    ${Notification_Info}    ${res.json()[${len}-1]}


Del User Notifications - PATCH
    ${user_id}    Get Json Value    ${Michaels_User_Info}    michaelsUser    id
    ${notification_id}    Get Json Value    ${Notification_Info}    notificationId
    ${body}    Create Dictionary    notificationStatus    INACTIVE
    ${data}    Create Dictionary    userId    ${user_id}
    ${res}    Send Patch Request - Params And Json    ${URL-B2B}    ${DEL_USER_NOTIFICATIONS}/${notification_id}    ${data}    ${body}    ${Headers_Michaels_Post}    204

