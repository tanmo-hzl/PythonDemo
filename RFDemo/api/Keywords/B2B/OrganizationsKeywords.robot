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
${Sub_Account_Count}
${B2B_File_Info}
${Sub_Account_Info}
${Sub_Account_Id}
${Cur_Org_State_Tax_Exempt_Info}
${Txmpt_Cert_Id}
${New_Tax_Id}
${New_Org_Name}

*** Keywords ***
Set Initial Data - B2B - Organizations
    Initial Env Data     configB2B.ini
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST
    ${user_id}    Get Json Value    ${Michaels_User_Info}    michaelsUser    id
    Set Suite Variable    ${User_Id}    ${user_id}
    ${B2B_File_Info}    Read File    b2b-file
    Set Suite Variable    ${B2B_File_Info}    ${B2B_File_Info}

Get Michaels Organizations List - GET
    ${body}    Get Cur And Pending Org Body
    ${res}     Send Get Request    ${URL-B2B}    ${GET_CUR_AND_PENDING_ORG}    ${body}    ${Headers_Michaels_Get}
    ${New_Org_Info}    Set Variable     ${res.json()[0]}
    Set Suite Variable    ${New_Org_Info}    ${New_Org_Info}
    ${Org_Id}    Get Json Value     ${New_Org_Info}     id
    Set Suite Variable    ${Org_Id}    ${Org_Id}

Get Michaels Organizations List By Org Name - GET
    [Arguments]    ${org_name}
    ${body}    Get Cur And Pending Org Body    ${org_name}
    ${res}     Send Get Request    ${URL-B2B}    ${GET_CUR_AND_PENDING_ORG}    ${body}    ${Headers_Michaels_Get}
    ${New_Org_Info}    Set Variable     ${res.json()[0]}
    Set Suite Variable    ${New_Org_Info}    ${New_Org_Info}
    ${Org_Id}    Get Json Value     ${New_Org_Info}     id
    Set Suite Variable    ${Org_Id}    ${Org_Id}

Get New Organizations Tax Id - GET
    ${index}    Set Variable    0
    FOR   ${index}    IN RANGE    10
        ${New_Tax_Id}    Get Org Tax Id Random
        ${body}    Get Org By Keywords Body    tax_id=${New_Tax_Id}
        ${res}    Send Get Request Without Token    ${URL-B2B}    ${GET_ORG_BY_KEYWORDS}    ${body}
        ${org_len}    Get Length    ${res.json()}
        Set Suite Variable    ${New_Tax_Id}    ${New_Tax_Id}
        Exit For Loop If    '${org_len}'=='0'
    END

Get New Organizations Name - GET
    ${index}    Set Variable    0
    FOR   ${index}    IN RANGE    10
        ${New_Org_Name}    Get Random Code    ${False}
        ${body}    Get Org By Keywords Body    org_name=Par Org ${New_Org_Name}
        ${res}    Send Get Request Without Token    ${URL-B2B}    ${GET_ORG_BY_KEYWORDS}    ${body}
        ${org_len}    Get Length    ${res.json()}
        Set Suite Variable    ${New_Org_Name}    ${New_Org_Name}
        Exit For Loop If    '${org_len}'=='0'
    END

Michaels Add New Organization - POST
    ${body}    Get Create Org And Account Body    ent    ${New_Org_Name}    ${New_Tax_Id}
    ${res}    Send Post Request    ${URL-B2B}    ${CREATE_ORG_AND_SUB_ACCOUNTS}    ${body}    ${Headers_Michaels_Post}    201
    Set Suite Variable    ${New_Org_Info}    ${res.json()}
    Save File    new-org-info    ${New_Org_Info}

Get Organization Detail - GET
    ${New_Org_Info}    Read File    new-org-info
    ${Org_Id}    Get Json Value     ${New_Org_Info}     organizationId
    Set Suite Variable    ${Org_Id}    ${Org_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${ORG}/${Org_Id}    ${null}     ${Headers_Michaels_Get}
    Set Suite Variable    ${New_Org_Info}    ${res.json()}
    Save File    new-org-info    ${New_Org_Info}

Organization Upload Pricing Catelog Contracts - POST
    ${contract_url}    Get Json Value    ${B2B_File_Info}    uploadedFiles    url
    ${pricing_catalog_id}    Set Variable    632697233015578624
    ${body}    Get Pricing Catalog Contracts Body    ${Org_Id}    ${contract_url}    ${pricing_catalog_id}
    ${res}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_PRICING_CATALOG_CONTRACTS}    ${body}    ${Headers_Michaels_Post}    201

Michaels Add Organization Tax Bussiness Info - POST
    ${body}    Get Tax Business Information Body     ${New_Org_Info}
    ${res}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_TAX_BUSINESS_INFO}    ${body}    ${Headers_Michaels_Post}   201

Michaels Add Organization Tax Signatory Information - POST
    ${body}    Get Tax Signatory Information Body
    ${res}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_TAX_SIGNATORY_INFO}    ${body}    ${Headers_Michaels_Post}    201

Michaels Submit Organization State Tax Exempt - POST
    ${cert_url}    Get Json Value    ${B2B_File_Info}    uploadedFiles    url
    ${body}    Get State Tax Exempt Body    ${cert_url}
    ${res}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_STATE_TAX_EXEMPT}    ${body}    ${Headers_Michaels_Post}    201
    ${res_1}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_TAX_EXEMPT_SUBMIT_ALL}    ${null}    ${Headers_Michaels_Post}    204

Get Organization Tax Exempt - GET
    ${res}    Send Get Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_TAX_EXEMPT}    ${null}    ${Headers_Michaels_Get}

Get Organization State Tax Exempt Infomation - GET
    ${res}    Send Get Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_STATE_TAX_EXEMPT_INFO}    ${null}    ${Headers_Michaels_Get}
    Set Suite Variable    ${Cur_Org_State_Tax_Exempt_Info}    ${res.json()[0]}
    ${Txmpt_Cert_Id}    Get Json Value    ${Cur_Org_State_Tax_Exempt_Info}    txmptCertId
    Set Suite Variable    ${Txmpt_Cert_Id}    ${Txmpt_Cert_Id}

Michaels Update Organization State Tax Exempt - PATCH
    ${cert_url}    Get Json Value    ${B2B_File_Info}    uploadedFiles    url
    ${body}    Get State Tax Exempt Body    ${cert_url}
    ${res}    Send Patch Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_STATE_TAX_EXEMPT}/${Txmpt_Cert_Id}    ${body}    ${Headers_Michaels_Post}    204
    ${res_1}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_STATE_TAX_EXEMPT}/${Txmpt_Cert_Id}    ${null}    ${Headers_Michaels_Post}    204

Michaels Delete Organization State Tax Exempt - DELETE
    ${res}    Send Delete Request    ${URL-B2B}    ${ORG}/${Org_Id}${ORG_STATE_TAX_EXEMPT}/${Txmpt_Cert_Id}    ${null}    ${Headers_Michaels_Post}    204

Get Sub Accounts List - GET
    ${body}    Get Sub Accounts List Body    ${Org_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${ORG_SUB_ACCOUNTS_LIST}    ${body}    ${Headers_Michaels_Get}
    ${Sub_Account_Count}    Get Length    ${res.json()}
    Set Suite Variable    ${Sub_Account_Count}    ${Sub_Account_Count}
    ${Sub_Account_Id}    Get Json Value    ${res.json()}    organizationId
    Set Suite Variable    ${Sub_Account_Id}    ${Sub_Account_Id}

Add New Sub Account - POST
    Get Organization Detail - GET
    ${body}    Get Add Sub Org Body    ${New_Org_Info}    ${Sub_Account_Count}
    ${res}    Send Post Request    ${URL-B2B}    ${ORG}/${Org_Id}${ADD_SUB_ORG}    ${body}    ${Headers_Michaels_Post}    201
    Set Suite Variable    ${Sub_Account_Info}    ${res.json()}
    ${Sub_Account_Id}    Get Json Value    ${res.json()}    organizationId
    Set Suite Variable    ${Sub_Account_Id}    ${Sub_Account_Id}

Get Sub Account Detail - GET
    ${res}    Send Get Request    ${URL-B2B}    ${ORG}/${Sub_Account_Id}    ${null}    ${Headers_Michaels_Get}
    Set Suite Variable    ${Sub_Account_Info}    ${res.json()}

Update Sub Account Info- PATCH
    ${body}    Get Update Sub Account Body    ${Sub_Account_Info}
    ${sub_org_name}    Get Json Value    ${body}    organizationName
    ${res}    Send Patch Request    ${URL-B2B}    ${ORG}/${Sub_Account_Id}    ${body}    ${Headers_Michaels_Post}
    ${new_sub_org_name}    Get Json Value    ${res.json()}    organizationName
    Should be Equal As Strings    ${sub_org_name}    ${new_sub_org_name}

Update Sub Account Status - PATCH
    [Documentation]    INACTIVE/ACTIVE
    [Arguments]    ${status}
    ${body}    Create Dictionary    status=${status}
    ${res}    Send Patch Request    ${URL-B2B}   ${ORG}/${Sub_Account_Id}${SUB_ORG_STATUS}    ${body}    ${Headers_Michaels_Post}    204

Check Sub Account Status
    [Arguments]    ${status}
    Get Sub Account Detail - GET
    ${new_status}    Get Json Value    ${Sub_Account_Info}    status
    Should Be Equal As Strings    ${new_status}    ${status}


