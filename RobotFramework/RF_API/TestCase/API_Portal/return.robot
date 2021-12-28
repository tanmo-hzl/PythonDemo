*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Library             ../../Libraries/API_Portal/order_and_return_data.py

*** Test Cases ***
Test Query return requests
    [Tags]   query_return      smoke      approve_refund_flow
    ${data}=    get_query_return
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_return      ${response.json()}
    should be equal as integers     ${status_code}      200


Test Get request requests by return order number
    [Tags]   get_retun_by_return_num     smoke      approve_refund_flow
    ${return_order_num}=    get_return_order_num
    ${url}=     merge urls      ${base_url}        ${get_retun_by_return_num}
    run keyword if      '${return_order_num}' != ''   Send Get Request         ${url}      ${return_order_num}


Test Get return requests by order number
    [Tags]   get_retun_by_order_num      smoke      approve_refund_flow
    ${return_order_num}=    get_return_by_order_num
    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
    run keyword if      '${return_order_num}' != ''   Send Get Request       ${url}      ${return_order_num}


Test Approve to refund
    [Tags]   approve_refund      smoke      approve_refund_flow
    ${data}=    get_approve_refund
    ${return_order_num}=    get from dictionary     ${data}     returnOrderNumber
    run keyword if      '${return_order_num}' != ''   Send Post Request    ${base_url}    ${approve_refund}    ${data}


Test Query return requests
    [Tags]   query_return      smoke         reject_refund_flow
    ${data}=    get_query_return
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_return      ${response.json()}
    should be equal as integers     ${status_code}      200


Test Reject to refund
    [Tags]   reject_refund      smoke       reject_refund_flow
    ${data}=    get_reject_refund
    ${return_order_num}=    get from dictionary     ${data}     returnOrderNumber
    run keyword if     '${return_order_num}' != ''       Send Post Request    ${base_url}    ${reject_refund}   ${data}


Test Query return requests
    [Tags]   query_return_by_time
    ${start_time}  get time  format=epoch   time_=NOW - 5 day
    ${end_time}  get time  format=epoch   time_=NOW - 2 day
    ${data}    get_query_return_param    start_time=${start_time}000  end_time=${end_time}000
    ${response}    Send Get Request         ${base_url}         ${query_return}      ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal as integers     ${status_code}      200


Test Query return requests
    [Tags]   query_return_by_error_time
    ${start_time}  get time  format=epoch   time_=NOW - 2 day
    ${end_time}  get time  format=epoch   time_=NOW - 5 day
    ${data}    get_query_return_param    start_time=${start_time}000  end_time=${end_time}000
    ${response}    Send Get Request         ${base_url}         ${query_return}      ${data}   expected_status=400


Test Query return requests
    [Tags]   query_return_by_return_order_status_list
    ${return_order_status_list}   get_return_order_status_list  num=3
    ${return_order_status_str}    EVALUATE    ','.join(@{return_order_status_list})
    ${data}    get_query_return_param    return_order_status_list=${return_order_status_str}    page_size=50
    ${response}    Send Get Request         ${base_url}      ${query_return}     ${data}
    log   ${response.json()}
    ${return_order_res_list}  get_result_data  ${response.json()}  status
    run keyword if  ${return_order_res_list}  list should contain sub list  ${return_order_status_list}   ${return_order_res_list}


Test Query return requests
    [Tags]   query_return_order_by_largest_page_size
    [Documentation]     1 <= page_size <= 200
    ${data}    get_query_return_param    page_size=201
    ${response}    Send Get Request         ${base_url}      ${query_return}     ${data}   expected_status=400