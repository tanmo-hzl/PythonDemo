*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyDeveloper.py
Resource            ../../TestData/MP/PathDeveloper.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot


*** Variables ***
${post_headers}
${get_headers}
${order_list}
${return_order_list}


*** Keywords ***
Set Initial Data - Developer
    [Documentation]    Set Headers
    ${get_headers}    Set Get Headers - Developer
    Set Suite Variable    ${get_headers}    ${get_headers}
    ${post_headers}    Set Post Headers - Developer
    Set Suite Variable    ${post_headers}    ${post_headers}

Get Order List Query - GET
    [Arguments]    ${status}     #PENDING_CONFIRMATION
    ${body}    Get Order Query Body     ${status}
    ${res}    Send Get Request    ${url-mda}    ${dev-order-query}    ${body}    ${get_headers}
    ${page_data}    Get Json Value    ${res.json()}    data    pageData
    Set Suite Variable    ${order_list}    ${page_data}

Get Order Detail By Order Number - GET
    ${order_number}    Get Json Value    ${order_list[0]}    orderBillingAddresses     orderNumber
    ${body}    Get Order Detail Body    ${order_number}
    ${res}    Send Get Request    ${url-mda}    ${dev-order-detail}${order_number}   ${body}    ${get_headers}

Order Confirm - POST
    ${order_number}    Get Json Value    ${order_list[0]}    orderBillingAddresses     orderNumber
    ${order_number}    Create List    ${order_number}
    ${body}    Get Order Confirm Body    ${order_number}
    ${res}    Send Post Request    ${url-mda}    ${dev-order-confirm}   ${body}    ${post_headers}

Order Shipment - POST
    ${body}    Get Order Shipped Body    ${order_list[0]}
    ${res}    Send Post Request    ${url-mda}    ${dev-order-shpped}   ${body}    ${post_headers}

Order Cancel - POST
    ${body}    Get Order Cancel Body    ${order_list[0]}
    ${res}    Send Post Request    ${url-mda}    ${dev-order-cancel}   ${body}    ${post_headers}

Get Return Order Query - GET
    [Arguments]    ${status}=${null}
    ${body}    Get Return Order Query Body    ${status}
    ${res}    Send Get Request    ${url-mda}    ${dev-return-order-list}    ${body}    ${get_headers}
    ${page_data}    Get Json Value    ${res.json()}    data    pageData
    Set Suite Variable    ${return_order_list}    ${page_data}

Get Return Order Detail By Return Order Number
    ${return_order_id}    Get Json Value    ${return_order_list[0]}    retrurnOrderNumber
    ${res}    Send Get Request    ${url-mda}    ${dev-return-order-by-return-order-number}/${return_order_id}    ${null}    ${get_headers}

Get Return Order Detail By Order Number
    ${order_number}    Get Json Value    ${return_order_list[0]}    orderNumber
    ${res}    Send Get Request    ${url-mda}    ${dev-return-order-by-return-order-number}/${order_number}    ${null}    ${get_headers}

Return Order Approval
    ${body}    Get Return Order Approve Body    ${return_order_list[0]}
    ${res}    Send Post Request    ${url-mda}    ${dev-return-order-approval}    ${body}    ${post_headers}

Return Order Reject
    ${body}    Get Return Order Reject Body    ${return_order_list[0]}
    ${res}    Send Post Request    ${url-mda}    ${dev-return-order-reject}    ${body}    ${post_headers}







