*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyReporter.py
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot
Resource            ../../TestData/B2B/PathReport.robot


*** Variables ***
${Headers_User_Get}
${Headers_User_Post}
${user_ids}

*** Keywords ***
Set Initial Data - B2B - Reports
    Initial Env Data     configB2B.ini
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}
    B2B Get User Organization List - GET
    Search Organization Of Users


Search Organization Of Users
    [Documentation]  Search current users of an organization
    ${body}  search_users_of_organization_body
    ${res}  Send Post Request - Params And Json  ${URL-B2B}  /organizations/${B2B_User_Org_Id}/users/searches   ${null}   ${body}   ${Headers_User_Post}
    ${user_ids}   Create List
    FOR  ${usr_info}  IN  @{res.json()}
        Append To List  ${user_ids}  ${usr_info['userId']}
    END
    Set Suite Variable  ${user_ids}  ${user_ids}

Create Sales-summary - Post
    ${body}   get_sale_summary_report_body  ${user_ids}  ${B2B_User_Org_Id}
    ${res}    Send Post Request - Params And Json   ${URL-B2B}   ${SALES-SUMMARY}   ${NULL}   ${body}  ${Headers_User_Post}

Save Sales-summary Repoter - Post
    ${body}   get_save_report_body  ${user_ids}  ${B2B_User_Org_Id}
    ${res}    Send Post Request - Params And Json   ${URL-B2B}   ${REPORTER-CRITERIA}  ${NULL}   ${body}  ${Headers_User_Post}  201

Get Report Crieria Lists - Get
    ${res}  Send Get Request  ${URL-B2B}  ${REPORTER-CRITERIA}  ${NULL}  ${Headers_User_Get}

Create Spend Report - Post
    ${body}  get_sales_report_body  ${user_ids}  ${B2B_User_Org_Id}
    ${res}    Send Post Request - Params And Json   ${URL-B2B}   ${SALES-REPORT}   ${NULL}   ${body}  ${Headers_User_Post}