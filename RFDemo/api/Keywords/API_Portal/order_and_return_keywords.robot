*** Settings ***
Resource            ../CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot
Library             ../../Libraries/API_Portal/order_and_return_data.py


*** Variables ***
${seller-account}
${api-key}
${headers}


*** Keywords ***


Set Initial Data - Order And Return
    Mik Buyer Sign In Scuse - POST
    ${buyer_headers}    Set Get Headers - Buyer
    Set Suite Variable    ${buyer_headers}    ${buyer_headers}
    ${buyer_headers_post}    Set Post Headers - Buyer
    Set Suite Variable    ${buyer_headers_post}    ${buyer_headers_post}

    Mik Seller Sign In Scuse Of Order - POST  ${seller-account}

    ${headers}    Create Dictionary     Content-Type=application/json;charset=utf-8     User-Agent=Custom    Api-Key=${api-key}
    Set Suite Variable    ${headers}    ${headers}


Query Orders
    [Arguments]   ${query_params}   ${status}=200
    ${param}     get_query_orders_param    ${query_params}
    ${res}      Send Get Request    ${URL-MIK-MDA}    /developer/api/order/query    ${param}    ${headers}   ${status}
    [Return]    ${res.json()}


Get Order By Order Number
    [Arguments]   ${order_number}
    ${res}      Send Get Request    ${URL-MIK-MDA}    /developer/api/order/${order_number}   ${null}  ${headers}
    [Return]    ${res.json()}


Confirm Orders
    [Arguments]   @{order_number}
    ${body}    get_confirm_orders_body   @{order_number}
    ${res}     Send Post Request     ${URL-MIK-MDA}    /developer/api/order/confirm   ${body}  ${headers}
    [Return]    ${res.json()}


Add An Shipment To Order Items
    [Arguments]   ${order_number}   ${carrier}   ${shipment_item_list}
    ${body}     get_shipment_order_items_body   ${order_number}   ${carrier}   ${shipment_item_list}
    ${res}      Send Post Request     ${URL-MIK-MDA}    /developer/api/order/shipped   ${body}  ${headers}
    [Return]    ${res.json()}


Cancel Order
    [Arguments]   ${order_number}   ${order_items}   ${cancel_reason}="Out of Stock"   ${status}=200
    ${body}    get_cancel_order_body  ${order_number}   ${order_items}   ${cancel_reason}
    ${res}     Send Post Request     ${URL-MIK-MDA}    /developer/api/order/cancel-order   ${body}  ${headers}  ${status}
    [Return]    ${res.json()}


Get Return By Return Number
    [Arguments]  ${return_number}
    ${res}      Send Get Request    ${URL-MIK-MDA}    /developer/api/v1/order/returns/return-number/${return_number}  ${null}   ${headers}
    [Return]    ${res.json()}


Get Retrun By Order Number
    [Arguments]  ${order_number}
    ${res}      Send Get Request    ${URL-MIK-MDA}    /developer/api/v1/order/returns/order-number/${order_number}  ${null}   ${headers}
    [Return]    ${res.json()}


Query Returns
    [Arguments]    ${query_params}  ${status}=200
    ${param}    get_query_returns_param    ${query_params}
    ${res}      Send Get Request    ${URL-MIK-MDA}    /developer/api/v1/order/returns/list   ${param}   ${headers}  ${status}
    [Return]    ${res.json()}


Approve To Refund
    [Arguments]   ${return_Number}   ${return_item_ids}
    ${body}    get_approve_refund_body   ${return_Number}  ${return_item_ids}
    ${res}     Send Post Request     ${URL-MIK-MDA}    /developer/api/v1/order/returns/approve-refund  ${body}  ${headers}
    [Return]    ${res.json()}


Reject To Return
    [Arguments]   ${return_number}   ${return_items}
    ${body}    get_reject_refund_body   ${return_number}   ${return_items}
    ${res}     Send Post Request     ${URL-MIK-MDA}    /developer/api/v1/order/returns/reject-refund   ${body}  ${headers}
    [Return]    ${res.json()}


Process a Return
    [Arguments]   ${return_number}   ${item_ids}
    ${body}    get_process_a_return  ${return_number}   ${item_ids}
    ${res}     Send Post Request     ${URL-MIK-MDA}    /developer/api/v1/order/returns/process-refund   ${body}  ${headers}
    [Return]    ${res.json()}

