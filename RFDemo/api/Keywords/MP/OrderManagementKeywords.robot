*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyOrderManagement.py
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller-account}
${seller_headers}
${seller_headers_post}
${seller_info_sign}
${seller_store_id}


*** Keywords ***
Set Initial Data - OrderManagement
    Mik Seller Sign In Scuse Of Order - POST    ${seller-account}
    ${seller_headers}    Set Get Headers - Seller
    Set Suite Variable    ${seller_headers}    ${seller_headers}
    ${seller_headers_post}    Set Post Headers - Seller
    Set Suite Variable    ${seller_headers_post}    ${seller_headers_post}
    ${seller_info_sign}    Set Variable     ${null}
    ${seller_info_sign}    Run Keyword If    '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
    Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}
    ${seller_store_id}    Get Json Value    ${seller_info_sign}    sellerStoreProfile    sellerStoreId
    Set Suite Variable    ${seller_store_id}    ${seller_store_id}


Get Order Overview List - GET
    [Arguments]   ${statuses}
    ${param}  get_order_overview_param  statuses=${statuses}
    ${res}  Send Get Request  ${URL-MIK}   /moh/search/order/seller/list/page  ${param}   ${seller_headers}
    [Return]  ${res.json()["data"]["content"]}

Get Seller Order Detail - GET
    [Arguments]  ${order_number}
    ${param}   Set Variable   orderNumber=${order_number}&simpleMode=false
    ${res}  Send Get Request  ${URL-MIK}  /moh/order/v5/seller/single  ${param}  ${seller_headers}
    [Return]   ${res.json()}

Confirm pending Confirmation Order - POST
    [Arguments]  ${order_number}
    ${order_number_list}   Create List  ${order_number}
    ${body}  Create Dictionary  orderNumbers=${order_number_list}
    Send Post Request - Params And Json  ${URL-MIK}  /moh/order/v5/seller/ReadyToShip/ByOrderNumber  ${null}  ${body}  ${seller_headers_post}

Ship Item For Ready To Ship Order - POST
    [Arguments]  ${order_number}  ${order_lines}
    ${body}  get_add_shipment_item_body  ${order_number}  ${order_lines}
    Send Post Request - Params And Json   ${URL-MIK}  /moh/order/v3/seller/shipments/add   ${null}  ${body}  ${seller_headers_post}

Seller Cancel Item - POST
    [Arguments]  ${order_number}  ${order_lines}
    ${body}  get_cancel_item_body  ${order_number}  ${order_lines}
    Send Post Request - Params And Json   ${URL-MIK}  /moh/afterSales/order/seller/cancelOrder   ${null}  ${body}  ${seller_headers_post}

Seller Download Order Export - GET
    [Arguments]  ${status}
    ${param}  get_download_order_export_param   ${status}
    ${res}  Send Get Request  ${URL-MIK}   /moh/search/order/seller/list/page  ${param}   ${seller_headers}
    Delete File By Name If Exist  order_excel.xlsx
    save_excel_file  order_excel.xlsx  ${res}

Get Seller Return List - Get
    [Arguments]   ${statuses}
    ${param}  get_seller_return_param   statuses=${statuses}
    ${res}  Send Get Request   ${URL-MIK}  /moh/search/order/seller/list/page  ${param}   ${seller_headers}
    [Return]  ${res.json()["data"]["content"]}

Get Seller Return Order Detail - GET
    [Arguments]  ${return_number}
    ${res}  Send Get Request   ${URL-MIK}  /moh/afterSales/return/seller/single/getByReturnOrderNumber/${return_number}  ${null}  ${seller_headers}
    [Return]  ${res.json()}

Seller Process Refund - POST
    [Arguments]   ${return_order_number}  ${action_items}
    ${body}  get_seller_process_refund  ${return_order_number}   ${action_items}
    Send Post Request - Params And Json  ${URL-MIK}  /moh/afterSales/return/seller/processRefund  ${null}  ${body}   ${seller_headers_post}


Get Seller Dispute List - Get
    [Arguments]   ${statuses}
    ${param}  get_seller_dispute_param   statuses=${statuses}
    ${res}  Send Get Request   ${URL-MIK}  /moh/search/order/seller/list/page  ${param}   ${seller_headers}
    [Return]   ${res.json()["data"]["content"]}

Seller Get Dispute Detail - GET
    [Arguments]  ${dispute_id}
    ${res}  Send Get Request  ${URL-MIK}  /rsc/v2/disputes/${dispute_id}  ${null}   ${seller_headers_post}
    [Return]  ${res.json()["data"]}

Seller View Dispute Status Is Open - POST
    [Arguments]  ${dispute_id}
    ${body}  Create Dictionary  disputeId=${dispute_id}
    Send Post Request - Params And Json  ${URL-MIK}  /rsc/v2/disputes/${dispute_id}/in-progress  ${null}  ${body}   ${seller_headers_post}

Seller Make Decision For Dispute - POST
    [Arguments]  ${dispute_id}   ${order_item_id}  ${offer_type}
    ${body}  get_seller_make_decision_body  ${order_item_id}  ${offer_type}
    Send Post Request - Params And Json  ${URL-MIK}  /rsc/v2/disputes/${dispute_id}//make-offer  ${null}  ${body}  ${seller_headers_post}

Test Seller View Dispute Status Is Open
    ${content}  Get Seller Dispute List - Get   statuses=30000
    ${dispute_id}  Get Json Value  ${content}   id
    IF  ${dispute_id}==None
        ${res}  Buyer Get Return And Dispute List And Create Dispute
        ${dispute_id}  Get Json Value  ${res}  data   disputeId
    END
    Set Suite Variable   ${dispute_id}   ${dispute_id}
    Seller View Dispute Status Is Open - POST  ${dispute_id}