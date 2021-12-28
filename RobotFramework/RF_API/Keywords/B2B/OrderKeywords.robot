*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyOrder.py
Resource            ../../TestData/B2B/PathOrder.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${Michaels_User_Info}
${Headers_Michaels_Get}
${Headers_Michaels_Post}
${Past_Order_Number}
${Pending_Order_Request_Id}
${Pending_Order_Number}


*** Keywords ***
Set Initial Data - B2B - Order
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}

Get Past Order List - POST
    ${body}    Get Order List Body
    ${res}    Send Post Request    ${URL-B2B}    ${ORDERS}    ${body}    ${Headers_User_Post}
    ${Past_Order_Number}    Get Json Value    ${res.json()}    parentOrderNumber
    Set Suite Variable    ${Past_Order_Number}    ${Past_Order_Number}

Search Past Order By Query - POST
    ${body}    Get Search Past Order Body
    ${res}    Send Post Request    ${URL-B2B}    ${ORDERS_SEARCH}    ${body}    ${Headers_User_Post}
    ${Past_Order_Number}    Get Json Value    ${res.json()}    parentOrderNumber
    Set Suite Variable    ${Past_Order_Number}    ${Past_Order_Number}

Get Past Order Detail - GET
    ${res}    Send Get Request    ${URL-B2B}    ${ORDERS}/${Past_Order_Number}    ${null}    ${Headers_User_Get}

Search Pending Order By Query - POST
    ${status}    Create List    PENDING_FOR_APPROVAL
    ${body}    Get Search Pending Order Body    status=${status}
    ${res}    Send Post Request    ${URL-B2B}    ${PENDING_ORDER_SEARCH}    ${body}    ${Headers_User_Post}
    ${Pending_Order_Number}    Get Json Value    ${res.json()}    parentOrderNumber
    Set Suite Variable    ${Pending_Order_Number}    ${Pending_Order_Number}
    ${Pending_Order_Request_Id}    Get Json Value    ${res.json()}    orderRequestId
    Set Suite Variable    ${Pending_Order_Request_Id}    ${Pending_Order_Request_Id}

Get Pending Order Detail - GET
    ${res}    Send Get Request    ${URL-B2B}    ${PENDING_ORDERS}/${Pending_Order_Request_Id}    ${null}    ${Headers_User_Get}

Update Purchase Order Number For Pending Order - POST
    ${p_order_number}    Evaluate    'PurchaseOrder'+str(random.randint(10000,99999))
    ${body}    Create Dictionary    purchaseOrderNumber=${p_order_number}
    ${path}    Set Variable    ${PENDING_ORDERS}/${Pending_Order_Request_Id}${UPDATE_PURCHASE_ORDER_NUMBER}
    ${res}    Send Patch Request - Params   ${URL-B2B}    ${path}    ${body}    ${Headers_User_Post}

Reject Pending Order - PATCH
    ${path}    Set Variable    ${PENDING_ORDERS}/${Pending_Order_Request_Id}${REJECT}
    ${res}    Send Patch Request    ${URL-B2B}    ${path}    ${NULL}    ${Headers_User_Post}    204

Approve Pending Order - PATCH
    ${path}    Set Variable    ${PENDING_ORDERS}/${Pending_Order_Request_Id}${APPROVE}
    ${res}    Send Patch Request    ${URL-B2B}    ${path}    ${NULL}    ${Headers_User_Post}

Cancel Past Order - POST
    ${body}    Create Dictionary    parentOrderNumber=${Past_Order_Number}
    ${res}    Send Post Request    ${URL-B2B}    ${CANCEL_ORDER}    ${body}    ${Headers_User_Post}    204
