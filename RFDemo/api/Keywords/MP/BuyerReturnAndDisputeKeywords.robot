*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyBuyerReturn.py
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot
Resource            ../../Keywords/MP/UploadFileKeywords.robot

*** Variables ***
${buyer_headers}
${buyer_headers_post}
${buyer_info_sign}

*** Keywords ***
Set Initial Data - BuyerReturn
    Mik Buyer Sign In Scuse - POST
    ${buyer_headers}    Set Get Headers - Buyer
    Set Suite Variable    ${buyer_headers}    ${buyer_headers}
    ${buyer_headers_post}    Set Post Headers - Buyer
    Set Suite Variable    ${buyer_headers_post}    ${buyer_headers_post}
    ${buyer_info_sign}    Set Variable     ${null}
    ${buyer_info_sign}    Run Keyword If    '${buyer_info_sign}'=='None'    Read File    buyer-info-sign     ELSE    Set Variable    ${buyer_info_sign}
    Set Suite Variable    ${buyer_info_sign}    ${buyer_info_sign}
    ${buyer_id}    Get Json Value    ${buyer_info_sign}    user    id
    Set Suite Variable    ${buyer_id}    ${buyer_id}
    ${first_name}    Get Json Value    ${buyer_info_sign}    user    firstName
    ${last_name}    Get Json Value    ${buyer_info_sign}    user    lastName
    Set Suite Variable    ${buyer_name}    ${first_name} ${last_name}


Get Buyer Order History - GET
    [Arguments]   ${param}
    ${res}  Send Get Request  ${URL-MIK}  /moh/search/order/buyer/list/page  ${param}  ${buyer_headers}
    [Return]   ${res.json()["data"]["content"]}

Get Buyer Order Detail - GET
    [Arguments]   ${parent_order_number}
    ${param}    Set Variable    parentOrderNumber=${parent_order_number}
    ${res}    Send Get Request    ${URL-MIK}  /moh/order/v5.1/buyer/parentOrderList/single     ${param}    ${buyer_headers}
    [Return]    ${res.json()}

Buyer After Salers Chckorder
    [Arguments]   ${order_number}
    [Documentation]   order_number is buyer's ordernumber
    ${param}    Create Dictionary    isCheckCancel=false  isCheckReturn=true  isCheckValid=true
    ${res}      Send Get Request    ${URL-MIK}    /moh/afterSales/order/v2/checkOrder/${order_number}    ${param}    ${buyer_headers}
    ${check_order_list}  Get Json Value  ${res.json()}   data   checkOrderVoList
    ${subOrderNumber}  Create List
    FOR  ${check_order}  IN  @{check_order_list}
        IF  '${check_order["isReturn"]}'=='${True}'
            Append To List  ${subOrderNumber}   ${check_order["suborderNumber"]}

        END
    END
    [Return]   ${subOrderNumber}

Buyer Create Return Order - POST
    [Arguments]  ${buyer_order_detail}   ${can_return_order}
    ${res}  Upload Image Files
    ${img_url}  Get Json Value  ${res}  data  uploadedFiles  url
    ${body}    get_buyer_return_body    ${buyer_order_detail}   ${can_return_order}   ${img_url}
    Send Post Request   ${URL-MIK}   /moh/returns/buyer/create    ${body}    ${buyer_headers_post}


Buyer Get Return And Dispute List - GET
    ${param}  Create Dictionary  channels=1,2,3,4  pageNum=1  pageSize=10
    ${res}  Send Get Request  ${URL-MIK}  /moh/afterSales/return/buyer/list/page  ${param}  ${buyer_headers}
    [Return]  ${res.json()["data"]["afterSalesRspVoList"]}

Buyer Get Return Order Number Detail - GET
    [Arguments]  ${return_order_number}
    Send Get Request  ${URL-MIK}  /moh/afterSales/return/buyer/single/getByReturnOrderNumber/${return_order_number}  ${null}  ${buyer_headers}

Buyer Create Dispute - POST
    [Arguments]  ${order_number}  ${return_order_number}  ${dispute_items}
    ${body}  get_create_dispute_body  ${order_number}  ${return_order_number}  ${dispute_items}
    ${res}  Send Post Request - Params And Json   ${URL-MIK}  /rsc/v2/disputes/create  ${null}  ${body}  ${buyer_headers_post}
    [Return]   ${res.json()}

Buyer View Dispute Details - GET
    [Arguments]  ${dispute_id}
    Send Get Request  ${URL-MIK}  /rsc/v2/disputes/${dispute_id}  ${null}   ${buyer_headers}

Buyer Cancel Dispute - POST
    [Arguments]  ${dispute_id}
    ${body}  get_buyer_cancel_dispute_body
    Send Post Request - Params And Json   ${URL-MIK}   /rsc/v2/disputes/${dispute_id}/cancel  ${null}   ${body}  ${buyer_headers_post}


Buyer Get Return And Dispute List And Create Dispute
    ${afterSalesRspVoList}  Buyer Get Return And Dispute List - GET
    ${dispute_items}  Create List
    FOR  ${sale_rep}  IN  @{afterSalesRspVoList}
        ${return_order_line}  Set Variable  ${sale_rep["returnOrderLines"]}
        ${return_order_number}  Set Variable  ${null}
        FOR  ${return_line}  IN  @{return_order_line}
            IF  ${return_line["disputeId"]}!=None
                Exit For Loop
            ELSE IF  ${return_line["status"]}==19100
                ${return_order_number}  Get Json Value  ${sale_rep}  returnOrderNumber
                ${order_number}  Set Variable  ${sale_rep["orderNumber"]}
                ${dispute_dict}  Create Dictionary  orderAfterSalesItemId=${return_line["orderAfterSalesItemId"]}  quantity=${return_line["quantity"]}
                Append To List  ${dispute_items}  ${dispute_dict}
                Exit For Loop
            END
        END
        Run Keyword If  "${return_order_number}"!="None"  Exit For Loop
    END
    IF  "${return_order_number}"=="None"
        Skip  There don't have can dispute order
    END
    Buyer Get Return Order Number Detail - GET  ${return_order_number}
    ${res}  Buyer Create Dispute - POST  ${order_number}  ${return_order_number}  ${dispute_items}
    [Return]  ${res}

Buyer Create Return Order
    ${contents}  Get Buyer Order History - GET  pageSize=50
    ${return_length}  Set Variable  ${null}
    FOR  ${content}  IN  @{contents}
        ${parent_order_number}  Get Json Value  ${content}  parentOrderNumber
        ${buyer_order_detail}  Get Buyer Order Detail - GET   ${parent_order_number}
        ${can_return_order}  Buyer After Salers Chckorder  ${parent_order_number}
        ${return_length}  Get Length  ${can_return_order}
        IF  "${return_length}">"0"
            Buyer Create Return Order - POST   ${buyer_order_detail}   ${can_return_order}
            Exit For Loop
         END
    END
    Run Keyword If   "${return_length}"=="0"   Skip   There don't have order can return