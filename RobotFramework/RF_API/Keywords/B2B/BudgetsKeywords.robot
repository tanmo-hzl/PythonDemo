*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyBudgets.py
Resource            ../../TestData/B2B/PathBudgets.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${Headers_User_Get}
${Headers_User_Post}
${B2B_User_Info}
${B2B_User_Id}
${B2B_User_Org_Id}
${Budget_Id}


*** Keywords ***
Set Initial Data - B2B - Budgets
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}

Get User Budget List - GET
    ${body}    Get User Budgets Body    ${B2B_User_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${BUDGETS}    ${body}    ${Headers_User_Get}

Add Budget To Parent Organization - POST
    B2B Get User Organization List - GET
    ${body}    Get Add Org Budget Body    org_id=${B2B_User_Org_Id}
    ${path}    Set Variable     ${ADD_BUDGETS}/${B2B_User_Org_Id}${BUDGETS}
    ${res}    Send Post Request    ${URL-B2B}    ${path}    ${body}    ${Headers_User_Post}    201
    ${Budget_Id}    Get Json Value    ${res.json()}    budgetId
    Set Suite Variable    ${Budget_Id}    ${Budget_Id}

Get Budget Detail - GET
    ${path}    Set Variable     ${ADD_BUDGETS}/${B2B_User_Org_Id}${BUDGETS}/${Budget_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${path}    ${null}    ${Headers_User_Get}

Update Budget To Sub Accout - PATCH
    ${sub_accounts}    Get Json Value    ${B2B_User_Org_Info}     subAccountList
    ${body}    Get Add Org Budget Body    sub_account_info=${sub_accounts[0]}
    ${path}    Set Variable    ${ADD_BUDGETS}/${B2B_User_Org_Id}${BUDGETS}/${Budget_Id}
    ${res}    Send Patch Request    ${URL-B2B}    ${path}    ${body}    ${Headers_User_Post}

Delete Budget - DELETE
    ${path}    Set Variable    ${ADD_BUDGETS}/${B2B_User_Org_Id}${BUDGETS}/${Budget_Id}
    ${res}    Send Delete Request    ${URL-B2B}    ${path}    ${null}    ${Headers_User_Post}    204




