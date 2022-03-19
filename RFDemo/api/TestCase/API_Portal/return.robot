*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Library             ../../Libraries/API_Portal/order_and_return_data.py
Suite Setup          Run Keywords    Initial Env Data - API-Portal


*** Test Cases ***
Test Query return requests
    [Tags]   query_return      smoke      approve_refund_flow
    [Documentation]     query a pending return order and prepare to reject/approve it
    ${data}=    get_query_return
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_new_return      ${response.json()}
    should be equal as integers     ${status_code}      200

Test Query random return
    [Tags]   query_random_return    smoke
    [Documentation]     use some random parameters according to document to query return order
    ${data}=    get_random_query_return
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal as integers     ${status_code}      200


Test Get request requests by return order number
    [Tags]   get_retun_by_return_num     smoke      approve_refund_flow
    [Documentation]     search return order by an exist return number
    ${return_order_num}=    get_return_order_num
    ${url}=     merge urls      ${base_url}        ${get_retun_by_return_num}
    run keyword if      '${return_order_num}' != ''   Send Get Request         ${url}      ${return_order_num}


Test Get return requests by order number
    [Tags]   get_retun_by_order_num      smoke      approve_refund_flow
    [Documentation]     search return order by an exist order number
    ${return_order_num}=    get_return_by_order_num
    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
    run keyword if      '${return_order_num}' != ''   Send Get Request       ${url}      ${return_order_num}


#Test Approve to refund
#    [Tags]   approve_refund      smoke      approve_refund_flow
#    ${data}=    get_approve_refund
##    ${return_order_num}=    get from dictionary     ${data}     returnOrderNumber
#    ${return_order_num}=    get from dictionary     ${data}     returnNumber
#    run keyword if      '${return_order_num}' != ''   Send Post Request    ${base_url}    ${approve_refund}    ${data}

Test Process return
    [Tags]   process_refund      smoke
    [Documentation]     query a pending return order and appove/reject it
    ${data}=    get_query_return
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    record_new_return      ${response.json()}
    ${data}=    get_process_refund
    ${return_order_num}=    get from dictionary     ${data}     returnNumber
    run keyword if     '${return_order_num}' != ''       Send Post Request    ${base_url}    ${process_return}   ${data}


#Test Query return requests
#    [Tags]   query_return      smoke         reject_refund_flow
#    ${data}=    get_query_return
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    ${status_code}     get_status_code    ${response.json()}
#    record_new_return      ${response.json()}
#    should be equal as integers     ${status_code}      200


#Test Reject to refund
#    [Tags]   reject_refund      smoke       reject_refund_flow
#    ${data}=    get_reject_refund
##    ${return_order_num}=    get from dictionary     ${data}     returnOrderNumber
#    ${return_order_num}=    get from dictionary     ${data}     returnNumber
#    run keyword if     '${return_order_num}' != ''       Send Post Request    ${base_url}    ${reject_refund}   ${data}


Test Query return para error
    [Tags]   query_return_para_error
    [Documentation]     test if query return api has handled all parameter error situations
    ${data}=    get_query_return
    set to dictionary   ${data}     pageNumber=9999999999999999999999999999999999999
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     pageNumber=0
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     pageNumber=abc
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     pageNumber=10.1
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     pageSize=201
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     pageSize=10.1
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     pageSize=0
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     isAsc=123
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     returnStatusList=123
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     startTime=99999999999999999999999    endTime=999999999999999999999999
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     startTime=abc
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     endTime=abc
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_query_return
    set to dictionary   ${data}     orderNumber=123,456
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=200
    ${data}     get from dictionary       ${response.json()}    data
    ${num}      get from dictionary  ${data}   totalNum
    should be equal as integers          ${num}             0
    ${data}=    get_query_return
    set to dictionary   ${data}     returnNumber=123,456
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}     expected_status=200
    ${data}     get from dictionary       ${response.json()}    data
    ${num}      get from dictionary  ${data}   totalNum
    should be equal as integers          ${num}             0

Test Get return by return number error
    [Tags]   get_retun_by_return_num_error
    [Documentation]     test if search return by return number api has handled all parameter error situations
    ${return_order_num}=  set variable   abc000
    ${url}=     merge urls      ${base_url}        ${get_retun_by_return_num}
    ${response}   Send Get Request         ${url}      ${return_order_num}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_RETURN_NOT_FOUND
    ${return_order_num}=  set variable
    ${url}=     merge urls      ${base_url}        ${get_retun_by_return_num}
    ${response}   Send Get Request         ${url}      ${return_order_num}      expected_status=404
#    ${return_order_num}=  set variable   ^&$%^$%^$^#$^@$#@$
#    ${url}=     merge urls      ${base_url}        ${get_retun_by_return_num}
#    ${response}   Send Get Request         ${url}      ${return_order_num}      expected_status=404

Test Get return by order number error
    [Tags]   get_retun_by_order_num_error
    [Documentation]     test if search return by order number api has handled all parameter error situations
    ${return_order_num}=    set variable   abc000
    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
    ${response}   Send Get Request       ${url}      ${return_order_num}        expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_RETURN_NOT_FOUND
    ${return_order_num}=    set variable
    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
    ${response}   Send Get Request       ${url}      ${return_order_num}        expected_status=404
#    ${return_order_num}=    set variable   ^&$%^$%^$^#$^@$#@$
#    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
#    ${response}   Send Get Request       ${url}      ${return_order_num}        expected_status=404
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}             MCU_API_RETURN_NOT_FOUND
    ${return_order_num}=    set variable   abc000
    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
    ${response}   Send Post Request      ${url}      ${return_order_num}        expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST

Test Process return para error
    [Tags]   process_refund_para_error
    [Documentation]     test if process return api has handled all parameter error situations
    ${data}=    get_query_return
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    record_new_return      ${response.json()}
    ${data}=    get_process_refund
    ${data}=    get_error_process_refund_item        ${data}
    ${data}     set to dictionary   ${data}     returnNumber=abc000
    ${response}     Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_RETURN_NOT_FOUND
    ${data}=    get_process_refund
    ${data}     delete_return_key  ${data}     returnNumber
    ${response}     Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${data}     delete_return_key  ${data}     returnLines
    ${response}     Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${data}     set to dictionary   ${data}     returnLines=abc000
    ${response}     Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${return_order_num}=    get from dictionary     ${data}     returnNumber
    ${data}     delete_return_key  ${data}     returnLines      action
    ${response}     run keyword if     '${return_order_num}' != ''    Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${data}     delete_return_key  ${data}     returnLines      returnItemId
    ${response}   run keyword if     '${return_order_num}' != ''  Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${data}     delete_reject_reason   ${data}
    ${response}  run keyword if     '${return_order_num}' != ''   Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${data}     change_reject_data   ${data}    abc      123
    ${response}  run keyword if     '${return_order_num}' != ''   Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${data}     change_reject_data   ${data}    REJECT
    ${response}  run keyword if     '${return_order_num}' != ''   Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST
    ${data}=    get_process_refund
    ${data}     change_reject_data   ${data}    APPROVE
    ${response}  run keyword if     '${return_order_num}' != ''   Send Post Request    ${base_url}    ${process_return}   ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_BAD_REQUEST

