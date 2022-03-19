*** Settings ***
Resource            ../../Keywords/API_Portal/order_and_return_keywords.robot
Resource            ../../Keywords/MP/OrderFlowKeywords.robot
Suite Setup          Run Keywords    Initial Env Data
...                                  Set Initial Data - Order And Return


*** Variables ***
#${order_number_list}
${buyer_user_id}

*** Test Cases ***
#
#
#Test Success Order Flow + Approve Return
#    [Tags]    order_and_approve_return   OAR
#    ${query_params}  Create Dictionary   orderStatusList=PENDING_CONFIRMATION   pageSize=100
#    ${res}   Query Orders   ${query_params}
#    ${order_number}  get_order_number_by_user_id_refundable  ${res}   ${buyer_user_id}
#    ${res}  Get Order By Order Number  ${order_number}
#    ${order_lines}  Get Json Value  ${res}   data   orderLines
#    ${shipment_item_list}  Create List
#    FOR  ${order_line}  IN  @{order_lines}
#        ${items}  Create Dictionary   orderItemId=${order_line["orderItemId"]}  quantity=${order_line["quantity"]}
#        Append To List  ${shipment_item_list}  ${items}
#    END
#    ${order_number_list}  Create List  ${order_number}
#    Confirm Orders  ${order_number_list}
#    ${carrier}    Evaluate  random.choice(["UPS", "USPS", "FEDEX", "DHL"])
#    Add An Shipment To Order Items   ${order_number}   ${carrier}   ${shipment_item_list}
#
#    ${res}   Get Buyer Order Detail - GET   ${order_number[3:-2]}
#    ${can_return_order}  Buyer After Salers Chckorder  ${order_number[3:-2]}
#    Buyer Return Order - POST   ${res}   ${can_return_order}
#
#    ${res}  Get Retrun By Order Number   ${order_number}
#    ${return_Number}   Get Json Value   ${res}   data   returnNumber
#    ${returnlines}     Get Json Value   ${res}   data   returnLines
#    ${approve_item_ids}   Create List
#    FOR  ${returnline}  IN   @{returnlines}
#         IF  '${returnline['status']}'=='PENDING_RETURN'
#            Append To List  ${approve_item_ids}   ${returnline["returnItemId"]}
#         END
#    END
#    ${item_ids}  Create Dictionary   approve_item_ids=${approve_item_ids}
#    Process a Return   ${return_Number}   ${item_ids}
#
#

Ttest Seller Ship Item And Buyer Create Return
    [Tags]  ship_item_and_return
    ${query_params}  Create Dictionary   orderStatusList=PENDING_CONFIRMATION   pageSize=100
    ${res}   Query Orders   ${query_params}
    ${order_number}  get_order_number_by_user_id_refundable  ${res}   ${buyer_user_id}
    ${res}  Get Order By Order Number  ${order_number}
    ${order_lines}  Get Json Value  ${res}   data   orderLines
    ${shipment_item_list}  Create List
    FOR  ${order_line}  IN  @{order_lines}
        ${items}  Create Dictionary   orderItemId=${order_line["orderItemId"]}  quantity=${order_line["quantity"]}
        Append To List  ${shipment_item_list}  ${items}
    END
    ${order_number_list}  Create List  ${order_number}
    Confirm Orders  ${order_number_list}
    ${carrier}    Evaluate  random.choice(["UPS", "USPS", "FEDEX", "DHL"])
    Add An Shipment To Order Items   ${order_number}   ${carrier}   ${shipment_item_list}

    ${res}   Get Buyer Order Detail - GET   ${order_number[3:-2]}
    ${can_return_order}  Buyer After Salers Chckorder  ${order_number[3:-2]}
    Buyer Return Order - POST   ${res}  ${can_return_order}


Test Success Order Flow + Reject Return
    [Tags]     order_and_reject_return  OAR
    ${query_params}  Create Dictionary   orderStatusList=PENDING_CONFIRMATION   pageSize=100
    ${res}   Query Orders   ${query_params}
    ${order_number}  get_order_number_by_user_id_refundable  ${res}   ${buyer_user_id}
    ${res}  Get Order By Order Number  ${order_number}
    ${order_lines}  Get Json Value  ${res}   data   orderLines
    ${shipment_item_list}  Create List
    FOR  ${order_line}  IN  @{order_lines}
        ${items}  Create Dictionary   orderItemId=${order_line["orderItemId"]}  quantity=${order_line["quantity"]}
        Append To List  ${shipment_item_list}  ${items}
    END
    ${order_number_list}  Create List  ${order_number}
    Confirm Orders  ${order_number_list}
    ${carrier}    Evaluate  random.choice(["UPS", "USPS", "FEDEX", "DHL"])
    Add An Shipment To Order Items   ${order_number}   ${carrier}   ${shipment_item_list}

    ${res}   Get Buyer Order Detail - GET   ${order_number[3:-2]}
    ${can_return_order}  Buyer After Salers Chckorder  ${order_number[3:-2]}
    Buyer Return Order - POST   ${res}  ${can_return_order}

    ${res}  Get Retrun By Order Number   ${order_number}
    ${return_Number}   Get Json Value   ${res}   data   returnNumber
    ${returnlines}     Get Json Value   ${res}   data   returnLines
    ${reject_item_ids}   Create List
    FOR  ${returnline}  IN   @{returnlines}
         IF  '${returnline['status']}'=='PENDING_RETURN'
            Append To List  ${reject_item_ids}    ${returnline["returnItemId"]}
         END
    END
    ${item_ids}  Create Dictionary   reject_item_ids=${reject_item_ids}
    Process a Return   ${return_Number}   ${item_ids}


#Test Approve + Reject return
#    [Tags]   approve_and_reject_return  OAR
#    ${query_params}  Create Dictionary   orderStatusList=PENDING_CONFIRMATION   pageSize=100
#    ${res}   Query Orders   ${query_params}
#    ${order_number}  get_order_number_by_user_id_refundable  ${res}   ${buyer_user_id}
#    ${res}  Get Order By Order Number  ${order_number}
#    ${order_lines}  Get Json Value  ${res}   data   orderLines
#    ${shipment_item_list}  Create List
#    FOR  ${order_line}  IN  @{order_lines}
#        ${items}  Create Dictionary   orderItemId=${order_line["orderItemId"]}  quantity=${order_line["quantity"]}
#        Append To List  ${shipment_item_list}  ${items}
#    END
#    ${order_number_list}  Create List  ${order_number}
#    Confirm Orders  ${order_number_list}
#    ${carrier}    Evaluate  random.choice(["UPS", "USPS", "FEDEX", "DHL"])
#    Add An Shipment To Order Items   ${order_number}   ${carrier}   ${shipment_item_list}
#
#    ${res}   Get Buyer Order Detail - GET   ${order_number[3:-2]}
#    ${can_return_order}  Buyer After Salers Chckorder  ${order_number[3:-2]}
#    Buyer Return Order - POST   ${res}  ${can_return_order}
#
#    ${res}  Get Retrun By Order Number   ${order_number}
#    ${return_Number}   Get Json Value   ${res}   data   returnNumber
#    ${returnlines}     Get Json Value   ${res}   data   returnLines
#    ${item_ids}   Create List
#    FOR  ${returnline}  IN   @{returnlines}
#         IF  '${returnline['status']}'=='PENDING_RETURN'
#            Append To List  ${item_ids}   ${returnline["returnItemId"]}
#         END
#    END
#    ${item_length}   Get Length  ${item_ids}
#    IF  ${item_length}>=2
#        ${item_ids}  Create Dictionary   reject_item_ids=${item_ids[:1]}  approve_item_ids=${item_ids[1:]}
#        Process a Return   ${return_Number}   ${item_ids}
#    ELSE
#        Fail  "make sure ordernumer have lest more than 2 items"
#    END
#
#Test Seller Partial Ship Item
#    [Tags]  partial_ship
#    ${query_params}  Create Dictionary   orderStatusList=PENDING_CONFIRMATION   pageSize=10
#    ${res}   Query Orders   ${query_params}
#    ${page_data}   Set Variable  ${res["data"]["pageData"]}
#    FOR   ${data}  IN  @{page_data}
#        ${data_length}  Get Length  ${data["orderLines"]}
#        IF  ${data_length}>=2
#            TODO
#        END
#    END
#
#Test Cancel Order Flow
#    [Tags]   cancel_order_flow  OAR
#    ${query_params}  Create Dictionary   orderStatusList=PENDING_CONFIRMATION    pageSize=100
#    ${res}   Query Orders   ${query_params}
#    ${order_number}  get_order_number_by_user_id  ${res}   ${buyer_user_id}
#    ${res}  Get Order By Order Number  ${order_number}
#    ${order_lines}  Get Json Value  ${res}   data   orderLines
#    ${order_items}  Create List
#    FOR  ${order_line}  IN  @{order_lines}
#        Append To List  ${order_items}  ${order_line["orderItemId"]}
#    END
#    Cancel Order  ${order_number}   ${order_items}
#
#
#Test Query Orders By time
#    [Tags]  query_orders
#    ${start_time}  get time  format=epoch   time_=NOW - 5 day
#    ${query_params}  Create Dictionary   startTime=${start_time}000
#    Query Orders   ${query_params}
#
#
#Test Query orders By Error Time
#    [Tags]   query_order_by_error_time
#    [Documentation]     Wrong time format
#    ${query_params}  Create Dictionary   startTime=1638460800000.000
#    Query Orders   ${query_params}   400
#
#
#Test Query orders By End_time is Earlier Than Start_time
#    [Tags]   query_order_by_error_time1
#    [Documentation]     end_time is earlier than start_time
#    ${query_params}  Create Dictionary   endTime=1638460800000
#    Query Orders   ${query_params}   400
#
#
#Test Query Orders By Largest Page Size
#    [Tags]   query_order_by_largest_page_size
#    [Documentation]     1 <= page_size <= 200
#    ${query_params}  Create Dictionary   pageSize=201
#    Query Orders   ${query_params}   400
#
#
#Test Query orders By Order_status_list
#    [Tags]   query_order_by_order_status_list
#    ${order_status_list}   get_order_status_list  num=3
#    ${order_status_str}    EVALUATE    ','.join(@{order_status_list})
#    ${query_params}  Create Dictionary   orderStatusList=${order_status_str}
#    ${res}  Query Orders   ${query_params}
#    ${order_status_res_list}  get_result_data  ${res}  status
#    list should contain sub list  ${order_status_list}   ${order_status_res_list}
#
#
#Test Cancel Order With Long_cancel_reason
#    [Tags]   cancel_order_with_long_cancel_reason
#    ${query_params}  Create Dictionary   orderStatusList=PENDING_CONFIRMATION    pageSize=100
#    ${res}   Query Orders   ${query_params}
#    ${order_number}  get_order_number_by_user_id  ${res}   ${buyer_user_id}
#    ${res}  Get Order By Order Number  ${order_number}
#    ${order_lines}  Get Json Value  ${res}   data   orderLines
#    ${order_items}  Create List
#    FOR  ${order_line}  IN  @{order_lines}
#        Append To List  ${order_items}  ${order_line["orderItemId"]}
#    END
#    ${cancel_reason}  get_random_stings  257
#    Cancel Order  ${order_number}   ${order_items}  ${cancel_reason}  400
#
#
#Test Query Return With error_time
#    [Tags]   query_return_with_error_time
#    ${start_time}  get time  format=epoch   time_=NOW - 2 day
#    ${end_time}  get time  format=epoch   time_=NOW - 5 day
#    ${query_params}  Create Dictionary   startTime=${start_time}000  endTime=${end_time}000
#    ${res}   Query Returns   ${query_params}  400
#
#
#Test Query Return With Largest_page_size
#    [Tags]   query_return_with_largest_page_size
#    [Documentation]     1 <= page_size <= 200
#    ${query_params}  Create Dictionary   pageSize=201
#    ${res}  Query Returns   ${query_params}  400
#
#
#Test Query Return With return_status_list
#    [Tags]   query_return_with_return_status_list
#    ${return_status_list}   get_return_status_list  num=3
#    ${return_status_str}    EVALUATE    ','.join(@{return_status_list})
#    ${query_params}  Create Dictionary   returnStatusList=${return_status_str}
#    ${res}  Query Returns   ${query_params}
#    ${return_res_list}  get_result_data  ${res}  status
#    list should contain sub list  ${return_status_list}   ${return_res_list}
#
