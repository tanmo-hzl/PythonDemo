*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Library             ../../Libraries/API_Portal/order_and_return_data.py



*** Test Cases ***
Test Query orders
    [Tags]   query_order     smoke      success_order_flow
    ${data}=    get_query_order_data
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_order   ${response.json()}
    should be equal as integers     ${status_code}      200


Test Get order by order number
    [Tags]   get_order      smoke       success_order_flow
    ${order_num}=    get_order_num
    ${url}=     merge urls  ${base_url}    ${get_order}
    run keyword if      '${order_num}' != ''      Send Get Request    ${url}   ${order_num}
#    comment     ${response}    Send Get Request    ${url}   ${order_num}
#    comment     ${status_code}     get_status_code    ${response.json()}
#    comment     should be equal as integers     ${status_code}      200


Test Ready to ship an order
    [Tags]   ready_order      smoke     success_order_flow
    ${data}=    get_ready_order
    ${order_num_list}=      get from dictionary     ${data}     orderNumbers
    ${order_num}        get from list       ${order_num_list}       0
    run keyword if      '${order_num}' != ''    Send Post Request    ${base_url}    ${ready_order}   ${data}


Test Add an shipment to order items
    [Tags]   add_shipment_item      smoke       success_order_flow
    ${data}=    get_shipment_item
    ${order_num}=      get from dictionary     ${data}     orderNumber
    run keyword if      '${order_num}' != ''    Send Post Request    ${base_url}    ${add_shipment_item}  ${data}


Test Query orders
    [Tags]   query_order     smoke      success_order_flow      reject_order_flow
    ${data}=    get_query_order_data
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_order   ${response.json()}
    should be equal as integers     ${status_code}      200

Test Cancel order
    [Tags]   cancel_order      smoke        reject_order_flow
    ${data}=    get_cancel_order
    ${order_num}=      get from dictionary     ${data}     orderNumber
    run keyword if      '${order_num}' != ''      Send Post Request    ${base_url}    ${cancel_order}   ${data}

Test Query orders
    [Tags]   query_order_by_time
    ${start_time}  get time  format=epoch   time_=NOW - 5 day
    ${data}    get_query_orders_param    start_time=${start_time}000
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal as integers     ${status_code}      200

Test Query orders
    [Tags]   query_order_by_error_time
    [Documentation]     Wrong time format
    ${data}    get_query_orders_param    start_time=1638460800000.000
    ${response}    Send Get Request         ${base_url}     ${query_order}     ${data}   expected_status=400

Test Query orders
    [Tags]   query_order_by_error_time
    [Documentation]     end_time is earlier than start_time
    ${data}    get_query_orders_param    end_time=1638460800000
    ${response}    Send Get Request         ${base_url}      ${query_order}     ${data}   expected_status=400

Test Query orders
    [Tags]   query_order_by_largest_page_size
    [Documentation]     1 <= page_size <= 200
    ${data}    get_query_orders_param    page_size=201
    ${response}    Send Get Request         ${base_url}      ${query_order}     ${data}   expected_status=400

Test Query orders
    [Tags]   query_order_by_order_status_ist
    ${order_status_list}   get_order_status_list  num=3
    ${order_status_str}    EVALUATE    ','.join(@{order_status_list})
    ${data}    get_query_orders_param    order_status_list=${order_status_str}   simple_mode=true  page_size=50
    ${response}    Send Get Request         ${base_url}      ${query_order}     ${data}
    ${order_status_res_list}  get_result_data  ${response.json()}  status
    list should contain sub list  ${order_status_list}   ${order_status_res_list}

Test Cancel order
    [Tags]   cancel_order_with_long_cancel_reason
    ${start_time}  get time  format=epoch   time_=NOW - 5 day
    ${end_time}    get time  format=epoch   time_=NOW - 3 day
    ${order_data}  get_query_orders_param  start_time=${start_time}000  end_time=${end_time}000
    ...            page_size=1   order_status_list=PENDING_CONFIRMATION
    ${response}    Send Get Request  ${base_url}  ${query_order}  ${order_data}
    ${order_item_id}  get_result_data   ${response.json()}  orderItemId
    ${order_number}  get_result_data   ${response.json()}  orderNumber
    ${cancel_reason}  get_random_stings  257
    ${cancel_data}    get_cancel_order_param  order_number=${order_number}[0]  order_item_id=${order_item_id}[0]
    ...               cancel_reason=${cancel_reason}
    ${cancel_response}  Send Post Request   ${base_url}    ${cancel_order}   ${cancel_data}  expected_status=400

