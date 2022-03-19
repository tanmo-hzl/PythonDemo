*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Suite Setup          Run Keywords    Initial Env Data - API-Portal



*** Test Cases ***
Test Query orders with invalid api key
    [Tags]   query_order_by_invalid_api_key     MUB-67
    [Documentation]     test invalid apikey response
    ${data}=    get_query_order_data
    ${response}    Send Get Request By Invalid API         ${base_url}       ${query_order}      ${data}     expected_status=401
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_API_INVALID_API_KEY

Test Update a listing with no permission key
    [Tags]   update_listing_by_no_permission     MUB-67
    [Documentation]     test apikey lack of permission peresponse
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${data}=    get_update_listing_data
    ${response}    Send Put Request By Read API  ${base_url}   ${url}   ${data}     expected_status=401
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}             MCU_DEVELOPER_API_DO_NOT_HAVE_PERMISSION

Test Update a listing by invalid sku
    [Tags]   update_listing_with_invalid_sku     MUB-67
    [Documentation]     update listing by an invalid sku
    ${data}=    get_primary_sku_num
    ${sku_num}=    set variable         abc000
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${data}=    get_update_listing_data
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Get one Nonexistent listing
    [Tags]   get_a_nonexistent_listing              MUB-67
    [Documentation]     search listing by an invalid sku
    ${sku_num}=     set variable        abcd
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Get others listing
    [Tags]   get_others_listing              MUB-67
    [Documentation]     search listing by an nonexist sku
    ${sku_num}=     set variable        6048862614900260864
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Activate invalid sku listings
    [Tags]   activate_invalid_sku_listing       MUB-67
    [Documentation]     activate listing by an invalid sku and empty sku list
    ${data}=    get_activate_listing_data
    ${sku_list}     get from dictionary         ${data}     primarySkuNumbers
    append to list     ${sku_list}        abc000
    ${data}         set to dictionary        ${data}         primarySkuNumbers=${sku_list}
    ${response}    Send Post Request      ${base_url}   ${activate_listing}  ${data}       expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND
    ${sku_list}     create list
    ${data}         set to dictionary        ${data}         primarySkuNumbers=${sku_list}
    ${response}    Send Post Request      ${base_url}   ${activate_listing}  ${data}       expected_status=400

Test Deactivate invalid sku listings
    [Tags]   deactivate_invalid_sku_listing     MUB-67
    [Documentation]     deactivate listing by an invalid sku and empty sku list
    ${data}=    get_deactivate_listing_data
    ${sku_list}     get from dictionary         ${data}     primarySkuNumbers
    append to list     ${sku_list}        abc000
    ${response}    Send Post Request      ${base_url}   ${deactivate_listing}  ${data}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND


Test Get Inventory By ERROR SKU
    [Tags]   get_error_sku_invenroty        MUB-67
    [Documentation]     get inventory by nonexist sku
    ${url}    merge_urls    ${base_url}     ${get_sku_inventory}
    ${sku_num}=   set variable    abc
    ${response}    Send Get Request     ${url}    ${sku_num}        expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Get Inventory Sub SKU
    [Tags]   get_sub_sku_invenroty      MUB-67
    [Documentation]     get inventory by sub sku
    ${url}    merge_urls    ${base_url}     ${get_sku_inventory}
    ${sub_sku_num}=   get_variation_sub_sku
    ${response}    Send Get Request     ${url}    ${sub_sku_num}        expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_BAD_REQUEST

Test Update Inventory By ERROR SKU
    [Tags]   update_invenroty_by_error_sku      MUB-67
    [Documentation]     update inventory by invalid sku
    ${data_dict}=    create dictionary       skuNumber=123      availableQuantity=100
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}    expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Update inventory by Error seller SKU numbers
    [Tags]   update_inventory_by_error_sellerSKU        MUB-67
    [Documentation]     update inventory by invalid seller sku
    ${data_dict}=    create dictionary       sellerSkuNumber=xyz000      availableQuantity=100
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Update Inventory By Master SKU
    [Tags]   update_invenroty_by_master_sku             MUB-67
    [Documentation]     update inventory by master sku
    ${data}=    get_update_inventory_data_by_master_sku
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}       expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_BAD_REQUEST


Test Get SKU price by Error primary SKU number
    [Tags]   get_error_sku_price        MUB-67
    [Documentation]     get price by nonexist master sku
    ${url}    merge_urls    ${base_url}     ${get_sku_price}
    ${sku_num}=  set variable    000
    ${response}    Send Get Request     ${url}    ${sku_num}        expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Get SKU price by SUB SKU number
    [Tags]   get_sub_sku_price          MUB-67
    [Documentation]     get price by sub sku
    ${url}    merge_urls    ${base_url}     ${get_sku_price}
    ${sku_num}=  get_variation_sub_sku
    ${response}    Send Get Request     ${url}    ${sku_num}        expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_BAD_REQUEST

Test Update SKU price By Error SKU
    [Tags]   update_sku_price_by_error_sku      MUB-67
    [Documentation]     update listing price by nonexist sku
    ${data}=    get_update_price_by_error_sku
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}        expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND

Test Update SKU price By Master SKU
    [Tags]   update_sku_price_by_master_sku     MUB-67
    [Documentation]     update listing price by master sku
    ${data}=    get_update_price_by_master_sku
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}        expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_BAD_REQUEST

Test Update SKU price by Error seller SKU numbers
    [Tags]   update_price_by_error_sellerSKU        MUB-67
    [Documentation]     update price by invalid seller sku
    ${data}=    get_error_seller_sku_update_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_LISTING_NOT_FOUND



Test Get order Error
    [Tags]   get_order_error      MUB-67
    [Documentation]     get a nonexist order info by order number
    ${order_num}=   set variable    1234
    ${url}=     merge urls  ${base_url}    ${get_order}
    ${response}    Send Get Request    ${url}   ${order_num}     expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_ORDER_NOT_FOUND

Test Ready to ship order error
    [Tags]   ready_order_error    MUB-67
    [Documentation]     test order releated error in ready to ship api
    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         READY_TO_SHIP
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_ready_order
    ${response}       Send Post Request    ${base_url}    ${ready_order}   ${data}      expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_ORDER_STATUS_ERROR
    ${data}=    get_error_ready_order
    ${response}       Send Post Request    ${base_url}    ${ready_order}   ${data}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_ORDER_NOT_FOUND


Test Ship order error
    [Tags]   ship_order_item_error     MUB-67
    [Documentation]     test order releated error in ship order item api

    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         FULFILLED
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_shipment_item
    ${data}=    get_shipment_error_order        ${data}
    ${response}      Send Post Request    ${base_url}    ${add_shipment_item}  ${data}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_ORDER_NOT_FOUND

    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         FULFILLED
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_shipment_item
    ${response}      Send Post Request    ${base_url}    ${add_shipment_item}  ${data}      expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_ORDER_STATUS_ERROR

    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         PARTIAL_FULFILLED
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_shipment_item
#    ${data}       get_error_item_status        ${data}
    ${response}      Send Post Request    ${base_url}    ${add_shipment_item}  ${data}      expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_ORDER_ITEM_STATUS_ERROR

    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         READY_TO_SHIP
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_shipment_item
    ${data}       get_error_item        ${data}
    ${response}      Send Post Request    ${base_url}    ${add_shipment_item}  ${data}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          MCU_API_ORDER_ITEM_NOT_FOUND


Test Cancel order error
    [Tags]   cancel_order_error     MUB-67
    [Documentation]     test order releated error in cancel order api
    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         FULFILLED
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_cancel_order
    ${data}=    get_cancel_error_order        ${data}
    ${response}      Send Post Request    ${base_url}    ${cancel_order}  ${data}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_ORDER_NOT_FOUND

    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         FULFILLED
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_cancel_order
    ${data}=    get_cancel_error_item        ${data}
    ${response}      Send Post Request    ${base_url}    ${cancel_order}  ${data}      expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_ORDER_STATUS_ERROR

    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         PARTIAL_FULFILLED
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_cancel_order
    ${data}=    get_cancel_error_item        ${data}
    ${response}      Send Post Request    ${base_url}    ${cancel_order}  ${data}      expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_ORDER_ITEM_NOT_FOUND

    ${data}=    get_query_order_data
    ${data}     set to dictionary    ${data}       orderStatusList         PARTIAL_FULFILLED
    ${response}    Send Get Request         ${base_url}         ${query_order}      ${data}
    record_order   ${response.json()}
    ${data}=    get_cancel_order
    ${response}      Send Post Request    ${base_url}    ${cancel_order}  ${data}      expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_ORDER_ITEM_STATUS_ERROR


Test Get error return
    [Tags]   get_error_return      MUB-67
    [Documentation]     test return releated error in search return api
    ${return_order_num}=        set variable          abc123
    ${url}=     merge urls      ${base_url}        ${get_retun_by_return_num}
    ${response}     Send Get Request         ${url}      ${return_order_num}        expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          	MCU_API_RETURN_NOT_FOUND
    ${return_order_num}=    set variable          abc123
    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
    ${response}   Send Get Request       ${url}      ${return_order_num}        expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          			MCU_API_RETURN_NOT_FOUND

#Test Approve return error
#    [Tags]   approve_return_error     MUB-67
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         REFUNDED
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_approve_refund
#    ${data}=    get_error_approve_refund        ${data}
#    ${response}        Send Post Request    ${base_url}    ${approve_refund}    ${data}     expected_status=404
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_NOT_FOUND
#
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         REFUNDED
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_approve_refund
#    ${response}        Send Post Request    ${base_url}    ${approve_refund}    ${data}     expected_status=400
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_STATUS_ERROR
#
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         PENDING_RETURN
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_approve_refund
#    ${data}=    get_error_approve_refund_item        ${data}
#    ${response}        Send Post Request    ${base_url}    ${approve_refund}    ${data}     expected_status=404
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_ITEM_NOT_FOUND
#
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         PARTIALLY_REFUNDED
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_approve_refund
#    ${response}        Send Post Request    ${base_url}    ${approve_refund}    ${data}     expected_status=400
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_ITEM_STATUS_ERROR
#
#
#Test Reject return error
#    [Tags]   reject_return_error     MUB-67
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         REFUNDED
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_reject_refund
#    ${data}=    get_error_reject_refund        ${data}
#    ${response}     Send Post Request    ${base_url}    ${reject_refund}    ${data}     expected_status=404
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_NOT_FOUND
#
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         REFUNDED
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_reject_refund
#    ${response}     Send Post Request    ${base_url}    ${reject_refund}    ${data}     expected_status=400
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_STATUS_ERROR
#
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         PENDING_RETURN
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_reject_refund
#    ${data}=    get_error_reject_refund_item        ${data}
#    ${response}     Send Post Request    ${base_url}    ${reject_refund}    ${data}     expected_status=404
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_ITEM_NOT_FOUND
#
#    ${data}=    get_query_return
#    ${data}     set to dictionary    ${data}       returnStatusList         PARTIALLY_REFUNDED
#    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
#    record_new_return      ${response.json()}
#    ${data}=    get_reject_refund
#    ${response}     Send Post Request    ${base_url}    ${reject_refund}    ${data}     expected_status=400
#    ${code}     get from dictionary       ${response.json()}    code
#    should be equal as strings          ${code}          		MCU_API_RETURN_ITEM_STATUS_ERROR


Test Process return
    [Tags]   process_refund_error
    [Documentation]     test return releated error in process return api
    ${data}=    get_query_return
    ${data}     set to dictionary    ${data}       returnStatusList         REFUNDED
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    record_new_return      ${response.json()}
    ${data}=    get_process_refund
    ${data}=    get_error_approve_refund        ${data}
    ${response}     Send Post Request    ${base_url}    ${process_return}    ${data}     expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_RETURN_NOT_FOUND

    ${data}=    get_query_return
    ${data}     set to dictionary    ${data}       returnStatusList         REFUNDED
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    record_new_return      ${response.json()}
    ${data}=    get_process_refund
    ${response}     Send Post Request    ${base_url}    ${process_return}    ${data}     expected_status=400
    ${code}     get from dictionary       ${response.json()}    code
    should be equal as strings          ${code}          		MCU_API_RETURN_STATUS_ERROR

    ${data}=    get_query_return
    ${data}     set to dictionary    ${data}       returnStatusList         PENDING_RETURN
    ${response}    Send Get Request    ${base_url}    ${query_return}   ${data}
    record_new_return      ${response.json()}
    ${data}=    get_process_refund
    ${data}=    get_error_process_refund_item        ${data}
    ${return_num}     get from dictionary   ${data}     returnNumber
    ${response}     Send Post Request    ${base_url}    ${process_return}    ${data}     expected_status=404
    ${code}     get from dictionary       ${response.json()}    code
    run keyword if     '${return_num}'=='000'       should be equal as strings    ${code}   MCU_API_RETURN_NOT_FOUND
    ...     ELSE        should be equal as strings    ${code}   MCU_API_RETURN_ITEM_NOT_FOUND
