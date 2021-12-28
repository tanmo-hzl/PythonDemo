*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyPaymentAndAddress.py
Resource            ../../TestData/B2B/PathPaymentAndAddress.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${B2B_User_Info}
${B2B_User_Id}
${Headers_User_Get}
${Headers_User_Post}
${B2B_User_Org_Id}
${User_Payment_Info}
${Cur_Payment_Id}
${User_Address_List}
${Cur_Address_Info}
${Cur_Address_Id}


*** Keywords ***
Set Initial Data - B2B - Payment And Address
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}
    B2B Get User Organization List - GET

Get User Payment Methods List - GET
    ${body}    Get Payment Methods Body    ${B2B_User_Org_Id}    ${B2B_User_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${PAYMENT_METHODS}    ${body}    ${Headers_User_Get}
    Set Suite Variable    ${User_Payment_Info}    ${res.json()}
    Save File    bank-card-list    ${res.json()}

Get Fin Pie - GET
    ${res}    Send Get Request    ${URL-FIN}    ${FIN_PIE}    ${null}    ${Headers_User_Get}
    Log    ${res.text}

Add User Payment Options - POST
    [Documentation]   TODO
    ${body}    Get Create Payment Option Body
    Log   ${body}

Get Payment Methods Detail - GET
    ${org_bank_list}    Get json value    ${User_Payment_Info}    organizationPaymentMethodList
    ${len_bank}    Get Length    ${org_bank_list}
    ${org_bank_list_private}    Get json value    ${User_Payment_Info}    privatePaymentMethodList
    ${org_bank_list}    Set Variable IF    '${Len_bank}'=='0'    ${org_bank_list_private}
    ${payment_id}    Get Json value    ${org_bank_list[0]}   paymentMethodId
    Set Suite Variable    ${Cur_Payment_Id}    ${payment_id}
    ${org_id}    Get Json value    ${org_bank_list[0]}    organizationsList    organizationId
    ${path}    Set Variable    /organizations/${B2B_User_Org_Id}${BANK_CARDS}/${Cur_Payment_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${path}    ${null}    ${Headers_User_Get}
    Set Suite Variable    ${User_Payment_Info}    ${res.json()}

Update Payment Option - PATCH
    ${body}    Get Update Payment Option Body    ${User_Payment_Info}
    ${path}    Set Variable    /organizations/${B2B_User_Org_Id}${BANK_CARDS}/${Cur_Payment_Id}
    ${res}    Send Patch Request    ${URL-B2B}    ${path}    ${body}    ${Headers_User_Post}     204

Loop Delete User Payment Methods - DELETE
    [Arguments]    ${quantity}=1
    ${bank_list}    Read File    bank-card-list
    ${org_bank_list}    Get json value    ${bank_list}    organizationPaymentMethodList
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${quantity}
        ${expirationStatus}    Get Json value   ${org_bank_list[${index}]}    expirationStatus
        ${id}    Get Json value    ${org_bank_list[${index}]}   paymentMethodId
        ${org_id}    Get Json value    ${org_bank_list[${index}]}    organizationsList    organizationId
        run keyword if    '${expirationStatus}'=='ACTIVE'    Delete User Payment Methods - DELETE    ${org_id}    ${id}
    END

Delete User Payment Methods - DELETE
    [Arguments]    ${org_id}    ${id}
    ${path}    Set Variable    /organizations/${org_id}${BANK_CARDS}/${id}
    ${res}    Send Delete Request    ${URL-B2B}    ${path}    ${null}    ${Headers_User_Post}    204

Get User Shipping Address List - GET
    [Arguments]    ${quantity}=100
    ${body}    Create Dictionary    userId=${B2B_User_Id}    pageSize=${quantity}
    ${res}    Send Get Request    ${URL-B2B}    ${SHIPPING_ADDRESS}    ${body}    ${Headers_User_Get}
    Set Suite Variable    ${User_Address_List}    ${res.json()}

Add New Address - POST
    ${body}    Get Create Address Body    ${B2B_User_Org_Id}    ${B2B_User_Id}
    ${path}    Set Variable    /organizations/${B2B_User_Org_Id}${ADDRESS}
    ${res}    Send Post Request    ${URL-B2B}    ${path}    ${body}    ${Headers_User_Post}    201
    ${Cur_Address_Id}    Get Json Value    ${res.json()}    organizationAddressId
    Set Suite Variable    ${Cur_Address_Id}    ${Cur_Address_Id}

Get Address Detail - GET
    ${path}    Set Variable    /organizations/${B2B_User_Org_Id}${ADDRESS}/${Cur_Address_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${path}    ${null}    ${Headers_User_Post}
    Set Suite Variable    ${Cur_Address_Info}    ${res.json()}

Update Address - PATCH
    ${body}    Get Update Address Body    ${Cur_Address_Info}
    ${path}    Set Variable    /organizations/${B2B_User_Org_Id}${ADDRESS}/${Cur_Address_Id}
    ${res}    Send Patch Request    ${URL-B2B}    ${path}    ${body}    ${Headers_User_Post}

Loop Delete User Shipping Address - DELETE
    [Arguments]    ${quantity}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${quantity}
        ${id}    Get Json value    ${User_Address_List[${index}]}   organizationAddressId
        ${org_id}    Get Json value    ${User_Address_List[${index}]}    organizationId
        Delete User Shipping Address - DELETE    ${org_id}    ${id}
    END

Delete User Shipping Address - DELETE
    [Arguments]    ${org_id}    ${id}
    ${path}    Set Variable    /organizations/${org_id}${ADDRESS}/${id}
    ${res}    Send Delete Request    ${URL-B2B}    ${path}    ${null}    ${Headers_User_Post}    204