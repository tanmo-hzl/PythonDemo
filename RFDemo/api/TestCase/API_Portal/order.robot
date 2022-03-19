*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Library             ../../Libraries/API_Portal/order_and_return_data.py
Suite Setup          Run Keywords    Initial Env Data - API-Portal



*** Test Cases ***
Test Query orders
    [Tags]   query_order     smoke      success_order_flow
    [Documentation]     query a pending confirm order and prepare to confirm
    ${data}=    get_query_order_data
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}

Test Query random orders
    [Tags]   query_random_order     smoke
    [Documentation]     use a random parameter accroding to document to query order
    ${data}=    get_random_query_order_data
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}

Test Query exceed page number orders
    [Tags]   query_exceed_page_number_order
    [Documentation]     query order with page number which exceed max limitation
    ${data}=    get_random_query_order_data
    ${data}=    set to dictionary       ${data}     pageNumber=999999999
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${code}     get from dictionary         ${response.json()}        code
    should be equal as strings          ${code}                 MCU_API_BAD_REQUEST

Test Query error time orders
    [Tags]   query_error_time_order
    [Documentation]     query order with invalid start time and end time
    ${data}=    get_random_query_order_data
    ${data}=    set to dictionary       ${data}     startTime=2
    ${data}=    set to dictionary       ${data}     endTime=1
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${code}     get from dictionary         ${response.json()}        code
    should be equal as strings          ${code}                 MCU_API_BAD_REQUEST


Test Get order by order number
    [Tags]   get_order      smoke       success_order_flow
    [Documentation]     search order with exist order number
    ${order_num}=    get_order_num
    ${url}=     merge urls  ${base_url}    ${get_order}
    run keyword if      '${order_num}' != ''      Send Get Request    ${url}   ${order_num}
#    comment     ${response}    Send Get Request    ${url}   ${order_num}
#    comment     ${status_code}     get_status_code    ${response.json()}
#    comment     should be equal as integers     ${status_code}      200


Test Ready to ship an order
    [Tags]   ready_order      smoke     success_order_flow
    [Documentation]     update numbers of orders' status to ready to ship by exist order number
    ${data}=    get_ready_order
    ${order_num_list}=      get from dictionary     ${data}     orderNumbers
    ${order_num}        get from list       ${order_num_list}       0
    run keyword if      '${order_num}' != ''    Send Post Request    ${base_url}    ${ready_order}   ${data}


Test Add an shipment to order items
    [Tags]   add_shipment_item      smoke       success_order_flow
    [Documentation]     update some order items‘ status from ready to ship to fullfilled
    ${data}=    get_shipment_item
    ${order_num}=      get from dictionary     ${data}     orderNumber
    run keyword if      '${order_num}' != ''    Send Post Request    ${base_url}    ${add_shipment_item}  ${data}


#Test Query orders
#    [Tags]   query_order     smoke      success_order_flow      reject_order_flow
#    ${data}=    get_query_order_data
#    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
#    ${status_code}     get_status_code    ${response.json()}
#    record_order   ${response.json()}
#    should be equal as integers     ${status_code}      200

Test Cancel order
    [Tags]   cancel_order      smoke        reject_order_flow
    [Documentation]     query an order that can be cancelled and cancel this order
    ${data}=    get_query_order_data
    set to dictionary   ${data}     orderStatusList         PENDING_CONFIRMATION,READY_TO_SHIP
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_order   ${response.json()}
    ${data}=    get_cancel_order
    ${order_num}=      get from dictionary     ${data}     orderNumber
    run keyword if      '${order_num}' != ''      Send Post Request    ${base_url}    ${cancel_order}   ${data}


Test Query orders error
    [Tags]   query_order_error
    [Documentation]     test if query order api has handled all parameter error situations
    ${data}=    get_query_order_data
    set to dictionary   ${data}     startTime       abcd
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     endTime       abcd
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     startTime       9999999999999999       endTime       9999999999999999999
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}    orderStatusList=    orderNumberList=THP9352027721583671-1,THP9335750651040750-1,THP8283359792278329-1,THP9664798194348841-1
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    ${data}=    get_query_order_data
    set to dictionary   ${data}     orderStatusList     	pENDING_CONFIRMATION
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     isAsc     	1111
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     pageNumber     	100000
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     pageNumber     	0
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     pageNumber     	3.33
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     pageSize     	201
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     pageSize     	0
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     pageSize     	3.33
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     pageSize     	3.33
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400
    ${data}=    get_query_order_data
    set to dictionary   ${data}     simpleMode     	abc
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}     expected_status=400


Test Get order by order number error
    [Tags]   get_order_error_order_num
    [Documentation]     test if search order api has handled all parameter error situations
    ${response}     Send Get Request    ${base_url}   ${get_order}       expected_status=404
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_ORDER_NOT_FOUND
    ${order_num}=   set variable  abc000
    ${url}=     merge urls  ${base_url}    ${get_order}
    ${response}     Send Get Request    ${url}   ${order_num}       expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_ORDER_NOT_FOUND
#    ${order_num}=   set variable  ^&$%^$%^$^#$^@$#@$
#    ${url}=     merge urls  ${base_url}    ${get_order}
#    ${response}     Send Get Request    ${url}   ${order_num}       expected_status=404
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_ORDER_NOT_FOUND

Test Ready to ship error order
    [Tags]   ready_error_order
    [Documentation]     test if confirm order api has handled all parameter error situations
    ${data}=    create dictionary
    ${response}   Send Post Request    ${base_url}    ${ready_order}   ${data}        expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST

    ${data}=    get_ready_order
    ${order_num_list}=      get from dictionary     ${data}     orderNumbers
    append to list    ${order_num_list}       ^&$%^$%^$^#$^@$#@$
    ${data}     create dictionary      orderNumbers=${order_num_list}
    ${response}   Send Post Request    ${base_url}    ${ready_order}   ${data}        expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_ORDER_NOT_FOUND

Test Add an shipment to order items error
    [Tags]   add_shipment_item_error_para
    [Documentation]     test if ship order item api has handled all parameter error situations
    ${data}=    get_shipment_item
    set to dictionary   ${data}  orderNumber     abc000
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_ORDER_NOT_FOUND
    ${list}     create list
    set to dictionary   ${data}  shipmentsList     ${list}
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_shipment_item
    ${data}     set_invalid_track_number        ${data}         01234567890123456789012345678901234567890123456789012345678901234
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_shipment_item
    ${data}     set_invalid_carrier        ${data}         abc
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_shipment_item
    ${data}     delete_ship_key        ${data}         trackingNumber
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_shipment_item
    ${data}     delete_ship_key        ${data}         carrier
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
#    ${data}=    get_shipment_item
#    ${data}     delete_ship_key        ${data}         carrierTrackingUrl
#    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_shipment_item
    ${data}     delete_ship_key        ${data}         shipmentItemList
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_shipment_item
    ${data}     delete_ship_key        ${data}         shipmentItemList     quantity
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_shipment_item
    ${data}     delete_ship_key        ${data}         shipmentItemList     orderItemId
    ${response}   Send Post Request    ${base_url}    ${add_shipment_item}  ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST

Test Cancel order error
    [Tags]   cancel_order_para_error
    [Documentation]     test if cancel order api has handled all parameter error situations
    ${data}=    get_query_order_data
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     orderNumber
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     cancelOrderLines
    set to dictionary   ${data}     cancelReason=abc123
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     cancelOrderLines        orderItemId
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     cancelOrderLines        orderItemCancelReason
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_cancel_order
    set to dictionary   ${data}     orderNumber=abc123
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_ORDER_NOT_FOUND
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     cancelOrderLines
    ${data}     delete_cancel_key       ${data}     cancelReason
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          			MCU_API_BAD_REQUEST
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     cancelOrderLines
    ${data}     get_exceed_cancel_reason    ${data}
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     cancelReason
    ${data}     add_order_item      ${data}        123
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_cancel_order
    ${data}     delete_cancel_key       ${data}     cancelReason
    ${data}     add_order_item      ${data}        Out of Stock
    ${response}     Send Post Request    ${base_url}    ${cancel_order}   ${data}       expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_ORDER_ITEM_NOT_FOUND



