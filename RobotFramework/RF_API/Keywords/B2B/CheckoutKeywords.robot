*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyCheckout.py
Resource            ../../TestData/B2B/PathCheckout.robot
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
${CK_Address_Info}
${CK_Payment_Info}
${CK_Tax_Exempt_Info}
${CK_Tax_Quotation_Info}
${CK_Budgets_Info}
${CK_Order_Info}


*** Keywords ***
Set Initial Data - B2B - Checkout
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}
    B2B Get User Organization List - GET

Permission Level Sign In By Role Email
    [Arguments]    ${email}
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${email}
    B2B Get User Organization List - GET

Get CK Shipping Address - GET
    ${res}    Send Get Request    ${URL-B2B}    ${CK_ORG}/${B2B_User_Org_Id}${CK_SHIPPING_ADDRESS}    ${NUll}    ${Headers_User_Get}
    ${len}    Get Length    ${res.json()}
    ${index}    Evaluate    random.randint(0,${len}-1)
    Set Suite Variable    ${CK_Address_Info}    ${res.json()[${index}]}

Get CK Payment Detail - GET
    ${body}    Get CK Payment Detail Body    ${B2B_User_Org_Id}    ${B2B_User_Id}
    ${res}    Send Get Request    ${URL-B2B}    ${CK_PAYMENT_DETAIL}    ${body}    ${Headers_User_Get}
    Set Suite Variable    ${CK_Payment_Info}    ${res.json()}

Get CK Tax Exempt Info- GET
    ${res}    Send Get Request    ${URL-B2B}    ${CK_ORG}/${B2B_User_Org_Id}${CK_TAX_EXEMPT}    ${NUll}    ${Headers_User_Get}
    Set Suite Variable    ${CK_Tax_Exempt_Info}    ${res.json()}

Get CK Budgets Info - GET
    ${res}    Send Get Request    ${URL-B2B}    ${CK_ORG}/${B2B_User_Org_Id}${CK_BUDGETS}    ${null}    ${Headers_User_Get}
    Set Suite Variable    ${CK_Budgets_Info}    ${res.json()}

Get CK Tax Quotation Info - POST
    [Arguments]    ${pro_info}    ${cart_pro_list}    ${address_info}
    ${body}    Get CK Tax Quotation Body    ${pro_info}    ${cart_pro_list}    ${address_info}
    ${res}    Send Post Request    ${URL-FIN}    ${CK_TAX_QUOTATION}    ${body}    ${Headers_User_Post}
    Set Suite Variable    ${CK_Tax_Quotation_Info}    ${res.json()}

Create Order - Post
    [Arguments]    ${cart_pro_list}
    ${body}    Get CK Order Body    ${CK_Tax_Quotation_Info}    ${cart_pro_list}    ${CK_Address_Info}    ${CK_Payment_Info}
    ${res}    Send Post Request    ${URL-B2B}    ${CK_ORG}/${B2B_User_Org_Id}${CK_ORDER}    ${body}    ${Headers_User_Post}
    Set Suite Variable    ${CK_Order_Info}    ${res.json()}

Create Order Requests By User - Post
    [Arguments]    ${cart_pro_list}
    ${body}    Get CK Order Requests Body    ${CK_Tax_Quotation_Info}    ${cart_pro_list}    ${CK_Address_Info}    ${CK_Payment_Info}
    ${res}    Send Post Request    ${URL-B2B}    ${CK_ORG}/${B2B_User_Org_Id}${CK_ORDER_REQUESTS}    ${body}    ${Headers_User_Post}
    Set Suite Variable    ${CK_Order_Info}    ${res.json()}


