*** Settings ***
Documentation    Buyer Inventory Controller
...    1.POST/inventory/buyer/reservation
...    2.DELETE/inventory/buyer/reservation
...    3.POST/inventory/buyer/subscribe
Resource    _common.robot
Suite Setup    User and Admin Sign In

Library     OperatingSystem
Library     ../../Libraries/INV/Buyer_Inventory.py
Library     ../../Libraries/INV/SnowflakeId.py
Library     Collections
#Library     RedisLibrary
Library     ../../Libraries/INV/STRTOJSON.py
Variables    ../../Libraries/INV/SKU.py
Resource    ../../INVconfig.robot

*** Variables ***
${sku_number}    10553707
${sku_number02}     5726454538274791424
${order_number}     370585518159052
${sku_number_overdue}     5726454538274791424
${sku_number03}     invtest1
${sku_number04}     10550603
${sku_number_channer23_01}    invtest1
${sku_number_channer23_02}    invtest3
${sku_number_channer23_03}    5240026367898386432
${sku_number_channer14_01}    10554846
${sku_number_channer14_02}    10619990
${sku_number_1056}    10597168
${sku_number_notinmongdb}    3964500072730624

*** Test Cases ***
#Test Get Cache From Redis
#    Get Or Delete Inventroy Cache From Redis    admin1    omni    10651730    del    -1
#    Get Or Delete Inventroy Cache From Redis    admin1    mik    invtest1    del    -1
#    Get Or Delete Price Cache From Redis    admin1    invtest1    del    -1
#    Get Or Delete Price Cache From Redis    admin1    10619995    del    -1

#POST/inventory/buyer/reservation
#Test buyer reservation inventory when placing order Positive
#      [Documentation]   Different channel validation, one and more SKU numbers at a time
#      [Setup]   Generate Bulk Order Number      4
#      Book inventory check inventory    buyer    1   ${sku_number}     1   ${order_number_list}[0]
#      Book inventory check inventory    buyer    2   ${sku_number02}     1   ${order_number_list}[1]
#      Book inventory check inventory    buyer    3   ${sku_number03}     1   ${order_number_list}[2]
#      Book inventory check inventory    buyer    4   ${sku_number04}     1   ${order_number_list}[3]

Test Buyer Reservation Channel 2/3
    [Documentation]  1.reservaiton one skunumber,inventory is enough
    ...    2.reservation multiple skunumbers,inventory is both enough
    ...    3.reservaiton one skunumber,inventory is not enough
    ...    4.reservation multiple skunumbers,part of the skunumbers inventory is not enough
    [Setup]   Generate Bulk Order Number      4
    [Template]    Buyer Reservation Channel 2/3
    200    buyer    111111    ${order_number_list}[0]    2|-1|${SKUS.channel2}[0]|10
    200    buyer    111111    ${order_number_list}[1]    2|-1|${SKUS.channel2}[0]|10    3|-1|${SKUS.channel3}[0]|5
    400    buyer    111111    ${order_number_list}[2]    2|-1|${SKUS.channel2}[0]|10000    code=MCU_12000    message=Inventory does not enough
    400    buyer    111111    ${order_number_list}[3]    2|-1|${SKUS.channel2}[0]|10    3|-1|${SKUS.channel3}[0]|10000000
    ...    code=MCU_12000    message=Inventory does not enough

Test Buyer Reservation
    [Documentation]  1.reservaiton one skunumber,inventory is enough
    ...    2.reservation multiple skunumbers,inventory is both enough
    ...    3.reservaiton one skunumber,inventory is not enough
    ...    4.reservation multiple skunumbers,part of the skunumbers inventory is not enough
    [Setup]   Generate Bulk Order Number      12
    [Template]    Template Buyer Reservation
    200    buyer    111111    ${order_number_list}[0]    2|-1|${SKUS.channel2}[0]|10
    200    buyer    111111    ${order_number_list}[1]    3|-1|${SKUS.channel3}[0]|10
    200    buyer    111111    ${order_number_list}[2]    2|-1|${SKUS.channel2}[0]|10    3|-1|${SKUS.channel3}[0]|10
    200    buyer    111111    ${order_number_list}[3]    1|-1|${SKUS.mahattan}[0]|10
    200    buyer    111111    ${order_number_list}[4]    4|-1|${SKUS.mahattan}[1]|10
    200    buyer    111111    ${order_number_list}[5]    1|-1|${SKUS.mahattan}[0]|10    1|-1|${SKUS.mahattan}[1]|10
    200    buyer    111111    ${order_number_list}[6]    2|-1|${SKUS.channel2}[0]|10    3|-1|${SKUS.channel3}[0]|10    1|-1|${SKUS.mahattan}[0]|10
    400    buyer    111111    ${order_number_list}[7]    2|-1|${SKUS.channel2}[0]|10    3|-1|${SKUS.channel3}[0]|10000000    code=MCU_12000    message=Inventory does not enough
    400    buyer    111111    ${order_number_list}[8]    2|-1|${SKUS.channel2}[0]|10000000    3|-1|${SKUS.channel3}[0]|10   code=MCU_12000    message=Inventory does not enough
#    400    buyer    111111    ${order_number_list}[9]    1|-1|${SKUS.mahattan}[0]|10    1|-1|${SKUS.mahattan}[1]|10000000    code=MCU_12000    message=Inventory does not enough
#    400    buyer    111111    ${order_number_list}[10]    2|-1|${SKUS.channel2}[0]|10000000     3|-1|${SKUS.channel3}[0]|10    1|-1|${SKUS.mahattan}[0]|10
#    ...    code=MCU_12000    message=Inventory does not enough
#    400    buyer    111111    ${order_number_list}[11]    2|-1|${SKUS.channel2}[0]|10    3|-1|${SKUS.channel3}[0]|10    1|-1|${SKUS.mahattan}[0]|10000000
#    ...    code=MCU_12000    message=Inventory does not enough


#Test Buyer Reservation Channel 1/4
#    [Documentation]  1.reservaiton one skunumber,inventory is enough
#    ...    2.reservation multiple skunumbers,inventory is both enough
#    ...    3.reservaiton one skunumber,inventory is not enough
#    ...    4.reservation multiple skunumbers,part of the skunumbers inventory is not enough
#    [Setup]   Generate Bulk Order Number      4
#    [Template]    Buyer Reservation Channel 1/4
#    200    buyer    111111    ${order_number_list}[0]    1|-1|${SKUS.mahattan}[0]|1
#    200    buyer    111111    ${order_number_list}[1]    1|-1|${SKUS.mahattan}[0]|1    4|-1|${SKUS.mahattan}[1]|1
#    400    buyer    111111    ${order_number_list}[2]    1|-1|${SKUS.mahattan}[0]|999999999   code=MCU_12000    message=Inventory does not enough
#    400    buyer    111111    ${order_number_list}[3]    1|-1|${SKUS.mahattan}[0]|1    4|-1|${SKUS.mahattan}[1]|999999999
#    ...    code=MCU_12000    message=Inventory does not enough

Test Buyer Reservation Channel 2/3 and 1/4 at one time
    [Documentation]  1.reservaiton Channel 2/3 and 1/4 skunumber at one time,both inventory is enough
    ...    2.reservaiton Channel 2/3 and 1/4 skunumber at one time,Channel 2/3 inventory is not enough
    ...    3.reservaiton Channel 2/3 and 1/4 skunumber at one time,Channel 1/4 inventory is not enough
    [Setup]   Generate Bulk Order Number      3
    [Template]    Buyer Reservation Channel 2/3 and 1/4 at one time
    200    buyer    111111    ${order_number_list}[0]    2|-1|${SKUS.channel2}[0]|1    1|-1|${SKUS.mahattan}[0]|1
    400    buyer    111111    ${order_number_list}[1]    2|-1|${SKUS.channel2}[0]|1    1|-1|${SKUS.mahattan}[0]|900000000
    ...    code=MCU_12000    message=Inventory does not enough
    400    buyer    111111    ${order_number_list}[2]    3|-1|${SKUS.channel3}[0]|900000000    4|-1|${SKUS.mahattan}[0]|1
    ...    code=MCU_12000    message=Inventory does not enough

Test buyer reservation inventory when placing order repeat booking
      [Documentation]   Multiple order verification for the same OrderNumber
      [Setup]   Generate Bulk Order Number      1
      [Template]  Template buyer reservation inventory when placing order repeat booking
      1     ${SKUS.mahattan}[0]      1     ${order_number_list}[0]     buyer     200
      1     ${SKUS.mahattan}[0]      1     ${order_number_list}[0]    buyer       400     code=MCU_12016


Test buyer reservation inventory out of stock
      [Documentation]   Inventory shortage check
      [Setup]   Generate Bulk Order Number      1
      Template buyer reservation inventory out of stock     1     ${sku_number}     ${order_number_list}[0]     buyer     400      code=MCU_12000

Test buyer reservation inventory check inventory
      [Documentation]   Place an order, reserve inventory, and check the remaining inventory quantity
      [Setup]   Generate Bulk Order Number      1
      ${get_inventory_start}     Get Inventory      2   ${sku_number02}
      ${data}     post_scheduled_inventory      2   ${sku_number02}   1       ${order_number_list}[0]
      ${resp}     Post On Session     buyer    ${path.inv.reservation}    ${data}
      ${get_inventory_end}      Get Inventory   2   ${sku_number02}
      ${add}    Set Variable    string=${${get_inventory_start}-1}
      Should Be Equal   ${add}    string=${get_inventory_end}


Test buyer reservation inventory Overdue add back to scheduled inventory
      [Documentation]   Overdue add back inventory
      [Setup]   Generate Bulk Order Number      1
      ${get_inventory_start}      Get Inventory     2   ${SKUS.channel2}[2]
      ${data}     post_scheduled_inventory      2   ${SKUS.channel2}[2]   1       ${order_number_list}[0]
      ${resp}     Post On Session     buyer    ${path.inv.reservation}    ${data}
      Should Be Equal    ${resp.json()["code"]}    200
      Sleep    4
      IF    "%{TEST_ENV}"=="tst"
          Call Scheduler    26
      ELSE
          Call Scheduler    32
      END
      Sleep    5
      ${get_inventory_end}      Get Inventory   2   ${SKUS.channel2}[2]
      Should Be Equal   ${get_inventory_start}    ${get_inventory_end}

#DELETE/inventory/buyer/reservation
Test buyer delete reservation inventory no reservation by this order
      [Documentation]   Order not scheduled - delete check
      [Setup]   Generate Bulk Order Number      1
      [Template]  Template buyer delete reservation inventory when placing order
      ${order_number_list}[0]    buyer     400      code=MCU_12025

Test Template Delete Buyer Reservation
    [Setup]   Generate Bulk Order Number      7
    [Template]  Template Delete Buyer Reservation
    200    buyer    111111    ${order_number_list}[0]    2|-1|${SKUS.channel2}[2]|10
    200    buyer    111111    ${order_number_list}[1]    3|-1|${SKUS.channel3}[0]|10
    200    buyer    111111    ${order_number_list}[2]    2|-1|${SKUS.channel2}[2]|10    3|-1|${SKUS.channel3}[0]|10
    200    buyer    111111    ${order_number_list}[3]    1|-1|${SKUS.mahattan}[0]|10
    200    buyer    111111    ${order_number_list}[4]    4|-1|${SKUS.mahattan}[1]|10
    200    buyer    111111    ${order_number_list}[5]    1|-1|${SKUS.mahattan}[0]|10    1|-1|${SKUS.mahattan}[1]|10
    200    buyer    111111    ${order_number_list}[6]    2|-1|${SKUS.channel2}[2]|10    3|-1|${SKUS.channel3}[0]|10    1|-1|${SKUS.mahattan}[0]|10

#Test buyer delete reservation inventory
#      [Documentation]   Scheduled to execute delete
#      ${start_inventory}      Get Inventory    2    ${sku_number02}
#      ${order_inventory}    Order Booking Inventory
#      Log    ${order_inventory}
#      ${data}  delete_scheduled_inventory    ${order_inventory}
#      ${url}  set variable    ${path.inv.reservation}
#      ${resp}  delete on session   buyer    ${url}    data=${data}      expected_status=200
#      sleep    2
#      ${end_inventory}      Get Inventory    2    ${sku_number02}
#      Should Be Equal    ${resp.json()["message"]}  success
#      Should Be Equal    ${start_inventory}  ${end_inventory}

Test buyer delete reservation inventory duplicate deletion
      [Documentation]   The same OrderNumber executes delete multiple times
      ${start_inventory}      Get Inventory    2    ${SKUS.channel2}[0]
      ${order_inventory}    Order Booking Inventory
      Log    ${order_inventory}
      ${data}  delete_scheduled_inventory    ${order_inventory}
      ${url}  set variable    ${path.inv.reservation}
      ${resp}  delete on session   buyer    ${url}    data=${data}      expected_status=200
      ${resp_repeat_delete}  delete on session   buyer    ${url}    data=${data}    expected_status=400
      ${end_inventory}      Get Inventory    2    ${SKUS.channel2}[0]
      Should Be Equal    ${resp_repeat_delete.json()["code"]}  MCU_12013
      Should Be Equal    ${start_inventory}  ${end_inventory}

Test buyer delete reservation inventory after expiration
      [Documentation]   Delete after expiration
      ${start_inventory}      Get Inventory    2    ${SKUS.channel2}[0]
      ${order_inventory}    Order Booking Inventory
      Log    ${order_inventory}
      ${data}  delete_scheduled_inventory    ${order_inventory}
      ${url}  set variable    ${path.inv.reservation}
      Sleep    5
      IF    "%{TEST_ENV}"=="tst"
          Call Scheduler    26
      ELSE
          Call Scheduler    32
      END
      Sleep  8
      ${resp}  delete on session   buyer    ${url}    data=${data}      expected_status=400
      Should Be Equal As Strings    ${resp.json()["code"]}    MCU_12013
      Should Be Equal As Strings    ${resp.json()["message"]}    Inventory reservation had deleted
      ${end_inventory}      Get Inventory    2    ${SKUS.channel2}[0]
      Should Be Equal    ${start_inventory}  ${end_inventory}

#POST/inventory/buyer/subscribe
Test Template Buyer Subscribe
    [Documentation]    1.Subscribe skuNumber of channel 1 or channel 4;
    ...    2.Subscribe skuNumber of channel 2 or channel 3;
    ...    3.Subscribe skuNumber of michaelsStoreId 1056;
    ...    4.Subscribe without access
    ...    5.Subscribe with non-existent skuNumber
    ...    6.Subscribe with skuNumber which not exist in online_product table in mongdb
    [Template]    Template Buyer Subscribe
    ${sku_number_channer14_02}    -1    buyer    200    code=200    message=success
    ${SKUS.channel3}[0]    -1    buyer    200    code=200    message=success
    ${sku_number_1056}    1056    buyer    200    code=200    message=success
    ${sku_number_channer14_02}    -1    unlogin    401
    bucunzaidesku    -1    buyer    400    code=MCU_12023    message=Sku Inventory no authoritity
    ${sku_number_notinmongdb}    -1    buyer    400    code=MCU_12023    message=Sku Inventory no authoritity

Test Template Buyer repeat Subscribe
    [Documentation]    1.repeat subscribe skuNumber of channel 1 or channel 4;
    ...    2.repeat subscribe skuNumber of channel 2 or channel 3;
    [Template]    Template Buyer repeat Subscribe
    ${sku_number_channer14_02}    -1    buyer    200    code=200    message=success
    ${SKUS.channel3}[0]    -1    buyer    200    code=200    message=success

*** Keywords ***
User and Admin Sign In
    ${BUYER_USER_ID}  ${_}  User Sign In  buyer  ${buyer_user}
    Set Suite Variable  ${BUYER_USER_ID}
    User Sign In  admin  ${admin_user}  admin
    Create Session  unlogin  ${host}  headers=${default_headers}

Get Inventory
    [Arguments]    ${channel}   ${sku_number}
    ${header}   Create Dictionary     json=${default_headers}
    ${data}     get_inventory_test      ${channel}    ${sku_number}
    Log     ${data}
    Create Session      ${host}     ${header}
    ${resp}    Post On Session     buyer    ${path.inv.list}  ${data}
    [Return]      ${resp.json()["data"][0]["availableQuantity"]}

Order Booking Inventory
    ${header}   Create Dictionary     json=${default_headers}
    ${order}     Generate Bulk Order Number     1
    ${order_number_check}    Set Variable    ${order_number_list}[0]
    Create Session      ${host}     ${header}
    ${data}     post_scheduled_inventory    2
    ...   ${SKUS.channel2}[0]   1     ${order_number_list}[0]
    ${resp}    Post On Session     buyer    ${path.inv.reservation}   ${data}
    ${order_number_check_variable}  Set Variable    ${order_number_check}
    [Return]    ${order_number_check}

Generate Bulk Order Number
    [Arguments]    ${num}
    @{order_number_list}    generate_bulk_id    ${num}
    Set Test Variable    ${order_number_list}

Generate Bulk Sku Number
    [Arguments]    ${num}
    @{sku_number_list}    generate_bulk_id    ${num}
    Set Test Variable    ${sku_number_list}

Book inventory check inventory
    [Arguments]  ${session}     ${channel}   ${sku_number}      ${quantity}   ${order_number}
    ${get_inventory_start}     Get Inventory      ${channel}   ${sku_number}
    ${data}     post_scheduled_inventory      ${channel}   ${sku_number}      ${quantity}       ${order_number}
    ${resp}     Post On Session   ${session}    ${path.inv.reservation}    ${data}
    ${get_inventory_end}      Get Inventory   ${channel}   ${sku_number}
    ${add}    Set Variable    string=${${get_inventory_start}-1}
    Should Be Equal   ${add}    string=${get_inventory_end}

Buyer Reservation
    [Arguments]    ${session}    ${cusromer_id}    ${order_num}    @{item}
    ${req_data}    buyer_reservation_req_data    ${cusromer_id}    ${order_num}    @{item}
    ${resp}     Post On Session   ${session}    ${path.inv.reservation}    ${req_data}
    [Return]   ${req_data}

Buyer Get Inventory
    [Arguments]    ${channel}   ${sku_number}
    ${header}   Create Dictionary     json=${default_headers}
    ${data}     get_inventory_test      ${channel}    ${sku_number}
    Log     ${data}
    Create Session      ${host}     ${header}
    ${resp}    Post On Session     buyer    ${path.inv.list}  ${data}
    [Return]      ${resp.json()["data"]}

Admin Edit Inventory
    [Arguments]    ${session}    ${masterSkuNumber}    ${channel}    ${sellerStoreId}=0    @{item}
    ${data}    edit_inventory    ${masterSkuNumber}    ${channel}    ${item}
    ${resp}    POST On Session    ${session}    ${path.inv_admin.store_invs.format(storeId=${sellerStoreId})}    json=${data}
    [Return]   ${resp.json()}

Buyer Reservation Channel 2/3
    [Arguments]    ${status}    ${session}    ${cusromer_id}    ${order_num}    @{item}    &{assert}
    ${req_data}    buyer_reservation_req_data    ${cusromer_id}    ${order_num}    ${item}
    @{inventory_before}    Create List
    @{inventory_after}    Create List
#    ${req_data_list}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")

    Comment    1.first step:Admin Edit Inventory ,add ten inventory for every skunmber
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        ${getinv_data}    Buyer Get Inventory     ${channel}    ${skuNumber}
        ${inventoryId}    Evaluate    ${getinv_data}[0].get("inventoryId")
        ${masterSkuNumber}    Evaluate    ${getinv_data}[0].get("masterSkuNumber")
        Admin Edit Inventory    admin    ${masterSkuNumber}    ${channel}    ${inventoryId}|10|1
    END

    Comment    2.step two:judge whether the inventory is enough
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${enough_flage}    Set Variable   ${True}
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        ${reservation_quantity}    Evaluate    ${item}.get("quantity")
        ${getinv_data_after_edit}    Buyer Get Inventory     ${channel}    ${skuNumber}
        ${availableQuantity}    Evaluate    ${getinv_data_after_edit}[0].get("availableQuantity")
        IF   ${availableQuantity}<${reservation_quantity}
            ${enough_flage}    Set Variable    ${False}
            Exit For Loop
        END
    END

    Comment    3.step three:get inventory before reservation and Append To List @{inventory_before}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${getinv_data_after_edit}    Buyer Get Inventory     ${channel}    ${skuNumber}
           ${availableQuantity}    Evaluate    ${getinv_data_after_edit}[0].get("availableQuantity")
           &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
           Append To List    ${inventory_before}    ${sku_availableQuantity}
    END

    Comment    4.step four:reservation
    ${resp}     Post On Session   ${session}    ${path.inv.reservation}    json=${req_data}    expected_status=${status}
    sleep    2

    Comment    5.step five:delete inventory cache from redis
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
#        ${redis_before_clear}    query    ${skuNumber}
#        clear_sku    ${skuNumber}
#        ${redis_after_clear}    query    ${skuNumber}
        Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
    END

    Comment    6.step six:get inventory after reservation and Append To List @{inventory_after}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${getinv_data_after_reservation}    Buyer Get Inventory     ${channel}    ${skuNumber}
           ${availableQuantity}    Evaluate    ${getinv_data_after_reservation}[0].get("availableQuantity")
           &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}    availableQuantity=${availableQuantity}
           Append To List    ${inventory_after}    ${sku_availableQuantity}
    END

    Comment    7.step seven:assert
    FOR    ${K}    ${V}    IN    &{assert}
        Should Be Equal As Strings    ${resp.json()}[${K}]    ${V}
    END
    ${length}    Get Length     ${inventory_after}
    IF    ${enough_flage}==${True}
        FOR    ${i}    IN RANGE   ${length}
            ${availableQuantity_before}    Evaluate    int(&{inventory_before}[${i}].get("availableQuantity"))
            ${inventory_expect}   Evaluate    ${availableQuantity_before}-${req_data}[buyerInventoryItemRoList][${i}][quantity]
            ${inventory_actual}    Evaluate    int(&{inventory_after}[${i}].get("availableQuantity"))
            Should Be Equal    ${inventory_expect}      ${inventory_actual}
        END
    ELSE
        FOR    ${i}    IN RANGE   ${length}
            ${inventory_expect}    Evaluate    int(&{inventory_before}[${i}].get("availableQuantity"))
            ${inventory_actual}    Evaluate    int(&{inventory_after}[${i}].get("availableQuantity"))
            Should Be Equal    ${inventory_expect}      ${inventory_actual}
        END
    END

Template Buyer Reservation
    [Arguments]    ${status}    ${session}    ${cusromer_id}    ${order_num}    @{item}    &{assert}
    ${req_data}    buyer_reservation_req_data    ${cusromer_id}    ${order_num}    ${item}
    @{inventory_before}    Create List
    @{inventory_after}    Create List
    @{redis_before}    Create List
    @{redis_after}    Create List
#    ${req_data_list}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")

    Comment    1.first step:Admin Edit Inventory ,add ten inventory for every skunmber
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${channel}    Evaluate     ${item}.get("channel")
        IF    "${channel}" == "2"
            ${skuNumber}    Evaluate    ${item}.get("skuNumber")
            ${getinv_data}    Buyer Get Inventory     ${channel}    ${skuNumber}
            ${sellerStoreId}    Evaluate      ${getinv_data}[0].get("sellerStoreId")
            ${inventoryId}    Evaluate    ${getinv_data}[0].get("inventoryId")
            ${masterSkuNumber}    Evaluate    ${getinv_data}[0].get("masterSkuNumber")
            Admin Edit Inventory    admin    ${masterSkuNumber}    ${channel}    ${sellerStoreId}    ${inventoryId}|10|1
        ELSE IF    "${channel}" == "3"
            ${skuNumber}    Evaluate    ${item}.get("skuNumber")
            ${getinv_data}    Buyer Get Inventory     ${channel}    ${skuNumber}
            ${sellerStoreId}    Evaluate      ${getinv_data}[0].get("sellerStoreId")
            ${inventoryId}    Evaluate    ${getinv_data}[0].get("inventoryId")
            ${masterSkuNumber}    Evaluate    ${getinv_data}[0].get("masterSkuNumber")
            Admin Edit Inventory    admin    ${masterSkuNumber}    ${channel}    ${sellerStoreId}    ${inventoryId}|10|1
        ELSE
            Continue For Loop
        END
    END

        Comment    5.step five:delete inventory cache from redis
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        IF    "${channel}"=="2"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="3"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="1"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        ELSE IF    "${channel}"=="4"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        END
    END

    Comment    2.step two:judge whether the inventory is enough
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${enough_flage}    Set Variable   ${True}
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        ${reservation_quantity}    Evaluate    ${item}.get("quantity")
        ${getinv_data_after_edit}    Buyer Get Inventory     ${channel}    ${skuNumber}
        ${availableQuantity}    Evaluate    ${getinv_data_after_edit}[0].get("availableQuantity")
        IF   ${availableQuantity}<${reservation_quantity}
            ${enough_flage}    Set Variable    ${False}
            Exit For Loop
        END
    END

    Comment    3.step three:get inventory before reservation and Append To List @{inventory_before}
    ...    and get redis before reservation and Append To List @{redis_before}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${reservation_quantity}    Evaluate    ${item}.get("quantity")
           ${getinv_data_after_edit}    Buyer Get Inventory     ${channel}    ${skuNumber}
           ${availableQuantity}    Evaluate    ${getinv_data_after_edit}[0].get("availableQuantity")
           &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
           Append To List    ${inventory_before}    ${sku_availableQuantity}
           IF    "${channel}"=="2"
#               ${getinv_data_after_edit}    Buyer Get Inventory     3    ${skuNumber}
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
#               ${redis_availableQuantity_after_reservation}    Evaluate    str(${resp}).split(",")[8].split(":")[1]
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               ...    reservation_quantity=${reservation_quantity}
               Append To List    ${redis_before}   ${sku_availableQuantity}
           ELSE IF    "${channel}"=="3"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate    ${resp}.get("content")
               Should Not Be Empty   ${redis_availableQuantity_after_reservation}
           ELSE IF    "${channel}"=="1"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}   get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               ...    reservation_quantity=${reservation_quantity}
               Append To List    ${redis_before}   ${sku_availableQuantity}
           ELSE IF    "${channel}"=="4"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               ...    reservation_quantity=${reservation_quantity}
               Append To List    ${redis_before}   ${sku_availableQuantity}
           END
    END

    Comment    4.step four:reservation
    ${resp_reservation}     Post On Session   ${session}    ${path.inv.reservation}    json=${req_data}    expected_status=${status}
    sleep    2

    Comment    5.get redis after reservation and Append To List @{redis_after}
    ...    redis assert:the reids quantity of channel 2 and mahattan is reduced correcttly ,the redis of channel 3 is cleared
    IF    ${enough_flage} == ${True}
        FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           IF    "${channel}"=="2"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               Append To List    ${redis_after}   ${sku_availableQuantity}
           ELSE IF    "${channel}"=="3"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis}    Evaluate    ${resp}.get("content")
               Should Be Equal As Strings    ${null}   ${redis}
           ELSE IF    "${channel}"=="1" or "${channel}"=="4"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               Append To List    ${redis_after}   ${sku_availableQuantity}
           END
        END
    ELSE
        FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           IF    "${channel}"=="2"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               Append To List    ${redis_after}   ${sku_availableQuantity}
           ELSE IF    "${channel}"=="3"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis}    Evaluate    ${resp}.get("content")
               Should Not Be Empty   ${redis}
           ELSE IF    "${channel}"=="1" or "${channel}"=="4"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               IF    "${redis_availableQuantity_after_reservation}" != "${NULL}"
                   ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
                   ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
                   &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
                   Append To List    ${redis_after}   ${sku_availableQuantity}
               END
           END
        END

    END
    ${len}    Get Length    ${redis_before}
    IF    ${enough_flage} == ${True}
        FOR    ${i}    IN RANGE    ${len}
           ${expected_redis_quantity}    Evaluate     int(${redis_before}[${i}][availableQuantity])-int(${redis_before}[${i}][reservation_quantity])
           ${acutal_redis_quantity}    Evaluate    int(${redis_after}[${i}][availableQuantity])
           Should Be Equal    ${expected_redis_quantity}    ${acutal_redis_quantity}
        END
    ELSE
        FOR    ${i}    IN RANGE    ${len}
           ${expected_redis_quantity}    Evaluate     int(${redis_before}[${i}][availableQuantity])
           ${acutal_redis_quantity}    Evaluate    int(${redis_after}[${i}][availableQuantity])
           Should Be Equal    ${expected_redis_quantity}    ${acutal_redis_quantity}
        END
    END

    Comment    5.step five:delete inventory cache from redis
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        IF    "${channel}"=="2"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="3"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="1"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        ELSE IF    "${channel}"=="4"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        END
    END

    Comment    6.step six:get inventory after reservation and Append To List @{inventory_after}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${getinv_data_after_reservation}    Buyer Get Inventory     ${channel}    ${skuNumber}
           ${availableQuantity}    Evaluate    ${getinv_data_after_reservation}[0].get("availableQuantity")
           &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}    availableQuantity=${availableQuantity}
           Append To List    ${inventory_after}    ${sku_availableQuantity}
    END

    Comment    7.step seven:assert
    FOR    ${K}    ${V}    IN    &{assert}
        Should Be Equal As Strings    ${resp_reservation.json()}[${K}]    ${V}
    END
    ${length}    Get Length     ${inventory_after}
    IF    ${enough_flage}==${True}
        FOR    ${i}    IN RANGE   ${length}
            ${availableQuantity_before}    Evaluate    int(&{inventory_before}[${i}].get("availableQuantity"))
            ${inventory_expect}   Evaluate    ${availableQuantity_before}-${req_data}[buyerInventoryItemRoList][${i}][quantity]
            ${inventory_actual}    Evaluate    int(&{inventory_after}[${i}].get("availableQuantity"))
            Should Be Equal    ${inventory_expect}      ${inventory_actual}
        END
    ELSE
        FOR    ${i}    IN RANGE   ${length}
            ${inventory_expect}    Evaluate    int(&{inventory_before}[${i}].get("availableQuantity"))
            ${inventory_actual}    Evaluate    int(&{inventory_after}[${i}].get("availableQuantity"))
            Should Be Equal    ${inventory_expect}      ${inventory_actual}
        END
    END

Buyer Reservation Channel 1/4
    [Arguments]    ${status}    ${session}    ${cusromer_id}    ${order_num}    @{item}    &{assert}
    ${req_data}    buyer_reservation_req_data    ${cusromer_id}    ${order_num}    ${item}
    @{inventory_before}    Create List
    @{inventory_after}    Create List
    @{inventory_before_cache}    Create List
    @{inventory_after_cache}    Create List
#    ${req_data_list}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")

#    Comment    1.first step:Clear omni Inventory cache
#    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
#        ${channel}    Evaluate     ${item}.get("channel")
#        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
#        query    ${skuNumber}
#        clear_sku    ${skuNumber}
#        query    ${skuNumber}
#    END

    Comment    1.first step:judge whether the inventory is enough
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${enough_flage}    Set Variable   ${True}
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        ${reservation_quantity}    Evaluate    ${item}.get("quantity")
        ${getinv_data_after_edit}    Buyer Get Inventory     ${channel}    ${skuNumber}
        ${availableQuantity}    Evaluate    ${getinv_data_after_edit}[0].get("availableQuantity")
        IF   ${availableQuantity}<${reservation_quantity}
            ${enough_flage}    Set Variable    ${False}
            Exit For Loop
        END
    END

    Comment    2.step two:get omni inventory before reservation and Append To List @{inventory_before}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${inv_from_omni}    Get Omni Online Inventory     omniuser    ${skuNumber}
           ${availableQuantity}    Evaluate    ${inv_from_omni}.get("data")[0].get("TotalQuantity")
           ${sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
           Append To List    ${inventory_before}    ${sku_availableQuantity}
    END

    Comment    3.step three:get cache inventory before reservation and Append To List @{inventory_before_cache}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    get
        ${availableQuantity_cache}    Evaluate    str(${resp}).split(",")[8].split(":")[1]
        ${availableQuantity_cache}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity_cache}
        Append To List    ${inventory_before_cache}    ${availableQuantity_cache}
    END

#    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
#        ${channel}    Evaluate     ${item}.get("channel")
#        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
#        ${cache_value}    query    ${skuNumber}
#    END
    Comment    4.step four:reservation
    ${resp_reservation}     Post On Session   ${session}    ${path.inv.reservation}    json=${req_data}    expected_status=${status}

    Comment    5.step five:get omni inventory after reservation and Append To List @{inventory_after}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${inv_from_omni}    Get Omni Online Inventory     omniuser    ${skuNumber}
           ${availableQuantity}    Evaluate    ${inv_from_omni}.get("data")[0].get("TotalQuantity")
           &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}    availableQuantity=${availableQuantity}
           Append To List    ${inventory_after}    ${sku_availableQuantity}
    END

    Comment    6.step six:get cache inventory after reservation and Append To List @{inventory_after_cache}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    get
        ${availableQuantity_cache}    Evaluate    str(${resp}).split(",")[8].split(":")[1]
        ${availableQuantity_cache}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity_cache}
        Append To List    ${inventory_after_cache}    ${availableQuantity_cache}
    END

    Comment    7.step seven:assert
    FOR    ${K}    ${V}    IN    &{assert}
        Should Be Equal As Strings    ${resp_reservation.json()}[${K}]    ${V}
    END
    ${length}    Get Length     ${inventory_after}
    IF    ${enough_flage}==${True}
        FOR    ${i}    IN RANGE   ${length}
            ${availableQuantity_omni_before}    Evaluate    int(&{inventory_before}[${i}].get("availableQuantity"))
            ${availableQuantity_cache_before}    Evaluate    int(&{inventory_before_cache}[${i}].get("availableQuantity"))
            ${inventory_omni_expect}   Evaluate    ${availableQuantity_omni_before}-${req_data}[buyerInventoryItemRoList][${i}][quantity]
            ${inventory_cache_expect}   Evaluate    ${availableQuantity_cache_before}-${req_data}[buyerInventoryItemRoList][${i}][quantity]
            ${inventory_omni_actual}    Evaluate    int(&{inventory_after}[${i}].get("availableQuantity"))
            ${inventory_cache_actual}    Evaluate    int(&{inventory_after_cache}[${i}].get("availableQuantity"))
            Should Be Equal    ${inventory_omni_expect}    ${inventory_omni_actual}
            Should Be Equal    ${inventory_cache_expect}    ${inventory_cache_actual}
        END
    ELSE
        FOR    ${i}    IN RANGE   ${length}
            ${inventory_omni_expect}    Evaluate    int(&{inventory_before}[${i}].get("availableQuantity"))
            ${inventory_omni_actual}    Evaluate    int(&{inventory_after}[${i}].get("availableQuantity"))
            ${inventory_cache_expect}    Evaluate    int(&{inventory_before_cache}[${i}].get("availableQuantity"))
            ${inventory_cache_actual}    Evaluate    int(&{inventory_after_cache}[${i}].get("availableQuantity"))
            Should Be Equal    ${inventory_omni_expect}      ${inventory_omni_actual}
            Should Be Equal    ${inventory_cache_expect}      ${inventory_cache_actual}
        END
    END

Buyer Reservation Channel 2/3 and 1/4 at one time
    [Arguments]    ${status}    ${session}    ${cusromer_id}    ${order_num}    @{item}    &{assert}
    ${req_data}    buyer_reservation_req_data    ${cusromer_id}    ${order_num}    ${item}
    @{inventory_before}    Create List
    @{inventory_after}    Create List
#    ${req_data_list}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")
#    @{skunumber_list}    Create List
    ${sku_channel23}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")[0].get("skuNumber")
    ${sku_channel14}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")[1].get("skuNumber")
    ${channel23}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")[0].get("channel")
    ${channel14}    Evaluate    ${req_data}.get("buyerInventoryItemRoList")[1].get("channel")
#    ${num}    Set Variable    0
#    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
#        ${sku_number{}.format(${num})}    Set Test Variable    ${item}[skuNumber]

#    Comment    1.first step:Admin Edit Inventory ,add ten inventory for every skunmber
#    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
#        ${channel}    Evaluate     ${item}.get("channel")
#        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
#        ${getinv_data}    Buyer Get Inventory     ${channel}    ${skuNumber}
#        ${inventoryId}    Evaluate    ${getinv_data}[0].get("inventoryId")
#        ${masterSkuNumber}    Evaluate    ${getinv_data}[0].get("masterSkuNumber")
#        Admin Edit Inventory    admin    ${masterSkuNumber}    ${inventoryId}|10|1
#    END

    Comment    1.first step:Admin Edit Inventory ,add ten inventory for skunmber in channel2/3
    ${getinv_data}    Buyer Get Inventory     ${channel23}    ${sku_channel23}
    ${inventoryId}    Evaluate    ${getinv_data}[0].get("inventoryId")
    ${masterSkuNumber}    Evaluate    ${getinv_data}[0].get("masterSkuNumber")
    Admin Edit Inventory    admin    ${masterSkuNumber}    ${channel23}    ${inventoryId}|10|1

    Comment    2.step two:judge whether the inventory is enough
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${enough_flage}    Set Variable   ${True}
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        ${reservation_quantity}    Evaluate    ${item}.get("quantity")
        ${getinv_data_after_edit}    Buyer Get Inventory     ${channel}    ${skuNumber}
        ${availableQuantity}    Evaluate    ${getinv_data_after_edit}[0].get("availableQuantity")
        IF   ${availableQuantity}<${reservation_quantity}
            ${enough_flage}    Set Variable    ${False}
            Exit For Loop
        END
    END

    Comment    3.step three:get inventory before reservation and Append To List @{inventory_before}
    ${channel23_getinv_bfore}    Buyer Get Inventory     ${channel23}    ${sku_channel23}
    ${channel23_availableQuantity_before}    Evaluate    ${channel23_getinv_bfore}[0].get("availableQuantity")
    ${channel14_getinv_bfore}    Buyer Get Inventory     ${channel14}    ${sku_channel14}
    ${channel14_availableQuantity_before}    Evaluate    ${channel14_getinv_bfore}[0].get("availableQuantity")

    Comment    4.step four:reservation
    ${resp}     Post On Session   ${session}    ${path.inv.reservation}    json=${req_data}    expected_status=${status}
    Sleep    2

    Comment    5.step five:delete inventory cache from redis
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
#        ${redis_before_clear}    query    ${skuNumber}
#        clear_sku    ${skuNumber}
#        ${redis_after_clear}    query    ${skuNumber}
        Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
    END

    Comment    6.step six:get inventory after reservation and Append To List @{inventory_after}
    ${channel23_getinv_after}    Buyer Get Inventory     ${channel23}    ${sku_channel23}
    ${channel23_availableQuantity_after}    Evaluate    ${channel23_getinv_after}[0].get("availableQuantity")
    ${channel14_getinv_after}    Buyer Get Inventory     ${channel14}    ${sku_channel14}
    ${channel14_availableQuantity_after}    Evaluate    ${channel14_getinv_after}[0].get("availableQuantity")

    Comment    7.step seven:assert
    FOR    ${K}    ${V}    IN    &{assert}
        Should Be Equal As Strings    ${resp.json()}[${K}]    ${V}
    END
    ${length}    Get Length     ${inventory_after}
    IF    ${enough_flage}==${True}
        FOR    ${i}    IN RANGE   ${length}
            ${channel23_availableQuantity_before}    Evaluate    int(${channel23_availableQuantity_before})
            ${channel14_availableQuantity_before}    Evaluate    int(${channel14_availableQuantity_before})
            ${channel23_inventory_expect}   Evaluate    ${channel23_availableQuantity_before}-${req_data}[buyerInventoryItemRoList][${i}][quantity]
            ${channel14_inventory_expect}   Evaluate    ${channel14_availableQuantity_before}-${req_data}[buyerInventoryItemRoList][${i}][quantity]
            ${channel23_inventory_actual}    Evaluate    int(${channel23_availableQuantity_after})
            ${channel14_inventory_actual}    Evaluate    int(${channel14_availableQuantity_after})
            Should Be Equal    ${channel23_inventory_expect}      ${channel23_inventory_actual}
            Should Be Equal    ${channel14_inventory_expect}      ${channel14_inventory_actual}
        END
    ELSE
        FOR    ${i}    IN RANGE   ${length}
#            ${channel23_inventory_expect}    Evaluate    int(${channel23_availableQuantity_before})
#            ${channel23_inventory_actual}    Evaluate    int(${channel23_availableQuantity_after})
#            ${channel14_inventory_expect}    Evaluate    int(${channel14_availableQuantity_before})
#            ${channel14_inventory_actual}    Evaluate    int(${channel14_availableQuantity_after})
            Should Be Equal    int(${channel23_availableQuantity_before})      int(${channel23_availableQuantity_after})
            Should Be Equal    int(${channel14_availableQuantity_before})      int(${channel14_availableQuantity_after})
        END
    END

Template buyer reservation inventory when placing order Positive
    [Arguments]    ${channel}    ${sku_number}      ${quantity}      ${order_number}    ${session}    ${status}    &{assert}
    ${resp}    Post Reservation Info    ${channel}     ${sku_number}   ${quantity}      ${order_number}   ${session}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template buyer reservation inventory when placing order repeat booking
    [Arguments]    ${channel}      ${sku_number}   ${quantity}      ${order_number}     ${session}    ${status}    &{assert}
    ${resp}    Post Reservation Info   ${channel}      ${sku_number}   ${quantity}    ${order_number}   ${session}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template buyer reservation inventory out of stock
    [Arguments]    ${channel}      ${sku_number}      ${order_number}     ${session}    ${status}    &{assert}
    ${start_inventory}    Get Inventory     ${channel}      ${sku_number}
    ${resp}    Post Reservation Info   ${channel}      ${sku_number}   ${${start_inventory}+1}    ${order_number}   ${session}    ${status}
    ${end_inventory}    Get Inventory    ${channel}      ${sku_number}
    Should Be Equal    ${start_inventory}    ${end_inventory}


Template buyer reservation inventory Overdue add back to scheduled inventory
    [Arguments]    ${channel}      ${sku_number}   ${quantity}      ${order_number}     ${session}    ${status}    &{assert}
    ${resp}    Post Reservation Info   ${channel}      ${sku_number}   ${quantity}    ${order_number}   ${session}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template buyer delete reservation inventory when placing order
    [Arguments]    ${order_number}   ${session}    ${status}    &{assert}
    ${resp}    Delete Reservation Info    ${order_number}   ${session}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template Delete Buyer Reservation
    [Arguments]    ${status}    ${session}    ${cusromer_id}    ${order_num}    @{item}    &{assert}
    ${req_data}    buyer_reservation_req_data    ${cusromer_id}    ${order_num}    ${item}
    @{inventory_before}    Create List
    @{inventory_after}    Create List
    @{redis_before}    Create List
    @{redis_after}    Create List

    Comment    1.first step:Admin Edit Inventory ,add ten inventory for every skunmber
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${channel}    Evaluate     ${item}.get("channel")
        IF    "${channel}" == "2"
            ${skuNumber}    Evaluate    ${item}.get("skuNumber")
            ${getinv_data}    Buyer Get Inventory     ${channel}    ${skuNumber}
            ${sellerStoreId}    Evaluate      ${getinv_data}[0].get("sellerStoreId")
            ${inventoryId}    Evaluate    ${getinv_data}[0].get("inventoryId")
            ${masterSkuNumber}    Evaluate    ${getinv_data}[0].get("masterSkuNumber")
            Admin Edit Inventory    admin    ${masterSkuNumber}    ${channel}    ${sellerStoreId}    ${inventoryId}|10|1
        ELSE IF    "${channel}" == "3"
            ${skuNumber}    Evaluate    ${item}.get("skuNumber")
            ${getinv_data}    Buyer Get Inventory     ${channel}    ${skuNumber}
            ${sellerStoreId}    Evaluate      ${getinv_data}[0].get("sellerStoreId")
            ${inventoryId}    Evaluate    ${getinv_data}[0].get("inventoryId")
            ${masterSkuNumber}    Evaluate    ${getinv_data}[0].get("masterSkuNumber")
            Admin Edit Inventory    admin    ${masterSkuNumber}    ${channel}    ${sellerStoreId}    ${inventoryId}|10|1
        ELSE
            Continue For Loop
        END
    END

        Comment    5.step five:delete inventory cache from redis
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        IF    "${channel}"=="2"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="3"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="1"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        ELSE IF    "${channel}"=="4"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        END
    END

    Comment    3.step three:get inventory before reservation and Append To List @{inventory_before}
    ...    and get redis before reservation and Append To List @{redis_before}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${reservation_quantity}    Evaluate    ${item}.get("quantity")
           ${getinv_data_after_edit}    Buyer Get Inventory     ${channel}    ${skuNumber}
           ${availableQuantity}    Evaluate    ${getinv_data_after_edit}[0].get("availableQuantity")
           &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
           Append To List    ${inventory_before}    ${sku_availableQuantity}
           IF    "${channel}"=="2"
#               ${getinv_data_after_edit}    Buyer Get Inventory     3    ${skuNumber}
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
#               ${redis_availableQuantity_after_reservation}    Evaluate    str(${resp}).split(",")[8].split(":")[1]
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               ...    reservation_quantity=${reservation_quantity}
               Append To List    ${redis_before}   ${sku_availableQuantity}
           ELSE IF    "${channel}"=="3"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate    ${resp}.get("content")
               Should Not Be Empty   ${redis_availableQuantity_after_reservation}
           ELSE IF    "${channel}"=="1"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}   get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               ...    reservation_quantity=${reservation_quantity}
               Append To List    ${redis_before}   ${sku_availableQuantity}
           ELSE IF    "${channel}"=="4"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               ...    reservation_quantity=${reservation_quantity}
               Append To List    ${redis_before}   ${sku_availableQuantity}
           END
    END

    Comment    4.step four:reservation
    ${resp_reservation}     Post On Session   ${session}    ${path.inv.reservation}    json=${req_data}    expected_status=${status}
    sleep    2
    ${delete_data}    delete_scheduled_inventory    ${order_num}    ${cusromer_id}
    ${resp}  delete on session   ${session}    ${path.inv.reservation}    data=${delete_data}      expected_status=200
    sleep    2

    Comment    5.get redis after reservation and Append To List @{redis_after}
    ...    redis assert:the reids quantity of channel 2 and mahattan is reduced correcttly ,the redis of channel 3 is cleared
    IF    "${status}" == "200"
        FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           IF    "${channel}"=="2"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               Append To List    ${redis_after}   ${sku_availableQuantity}
           ELSE IF    "${channel}"=="3"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    get
               ${redis}    Evaluate    ${resp}.get("content")
               Should Be Equal As Strings    ${null}   ${redis}
           ELSE IF    "${channel}"=="1" or "${channel}"=="4"
               ${resp}    Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    get
               ${redis_availableQuantity_after_reservation}    Evaluate   ${resp}.get("content")
               ${redis_availableQuantity_after_reservation}    str_to_json    ${redis_availableQuantity_after_reservation}
               ${availableQuantity}    Evaluate  &{redis_availableQuantity_after_reservation}.get("availableQuantity")
               &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}   availableQuantity=${availableQuantity}
               Append To List    ${redis_after}   ${sku_availableQuantity}
           END
        END
    END

    ${len}    Get Length    ${redis_before}
    IF    "${status}" == "200"
        FOR    ${i}    IN RANGE    ${len}
           ${expected_redis_quantity}    Evaluate     int(${redis_before}[${i}][availableQuantity])
           ${acutal_redis_quantity}    Evaluate    int(${redis_after}[${i}][availableQuantity])
           Should Be Equal    ${expected_redis_quantity}    ${acutal_redis_quantity}
        END
    END

    Comment    5.step five:delete inventory cache from redis
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
        ${channel}    Evaluate     ${item}.get("channel")
        ${skuNumber}    Evaluate    ${item}.get("skuNumber")
        IF    "${channel}"=="2"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="3"
            Get Or Delete Inventroy Cache From Redis    admin1    mik    ${skuNumber}    del
        ELSE IF    "${channel}"=="1"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        ELSE IF    "${channel}"=="4"
            Get Or Delete Inventroy Cache From Redis    admin1    omni    ${skuNumber}    del
        END
    END

    Comment    6.step six:get inventory after reservation and Append To List @{inventory_after}
    FOR    ${item}    IN    @{req_data}[buyerInventoryItemRoList]
           ${channel}    Evaluate     ${item}.get("channel")
           ${skuNumber}    Evaluate    ${item}.get("skuNumber")
           ${getinv_data_after_reservation}    Buyer Get Inventory     ${channel}    ${skuNumber}
           ${availableQuantity}    Evaluate    ${getinv_data_after_reservation}[0].get("availableQuantity")
           &{sku_availableQuantity}    Create Dictionary    skuNumber=${skuNumber}    availableQuantity=${availableQuantity}
           Append To List    ${inventory_after}    ${sku_availableQuantity}
    END

    Comment    7.step seven:assert
    FOR    ${K}    ${V}    IN    &{assert}
        Should Be Equal As Strings    ${resp_reservation.json()}[${K}]    ${V}
    END
    ${length}    Get Length     ${inventory_after}
    IF    "${status}" == "200"
        FOR    ${i}    IN RANGE   ${length}
            ${availableQuantity_before}    Evaluate    int(&{inventory_before}[${i}].get("availableQuantity"))
            ${inventory_expect}   Evaluate    int(${availableQuantity_before})
            ${inventory_actual}    Evaluate    int(&{inventory_after}[${i}].get("availableQuantity"))
            Should Be Equal    ${inventory_expect}      ${inventory_actual}
        END
    END

Buyer Inventory List
    [Arguments]  ${session}  ${expected_status}  @{data_list}
    ${req_data}    buyer_list_req_data     ${data_list}
    ${resp}  POST On Session  unlogin  ${path.inv.list}  json=${req_data}  expected_status=${expected_status}
    ${resp_data}  Set Variable  ${resp.json()}[data]
    Return From Keyword If  ${expected_status}!=200
    ${req_data}  Sort List By Key  ${req_data}  skuNumber
    ${resp_data}  Sort List By Key  ${resp_data}  skuNumber
    &{quantity_list}  Create Dictionary
    FOR  ${req_item}  ${resp_item}  IN ZIP  ${req_data}  ${resp_data}
      Should Be Equal As Strings  ${req_item}[skuNumber]  ${resp_item}[skuNumber]
      Should Be Equal As Strings  ${req_item}[michaelsStoreId]  ${resp_item}[michaelsStoreId]
#      Should Not Be Empty  ${resp_item}[inventoryId]
      Set To Dictionary  ${quantity_list}  ${resp_item}[skuNumber]=${resp_item.get("availableQuantity")}
    END
    [Return]  ${quantity_list}

Buyer Inventory Reservation With Inventory Check
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    log  ${data_list}
    &{quantity_original}  Buyer Inventory List  buyer  200  @{data_list}
    Buyer Inventory Reservation  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    Sleep    6
    &{quantity_modified}  Buyer Inventory List  buyer  200  @{data_list}
    FOR  ${item}  IN  @{data_list}
        log  ${item}
        ${_}  ${_}  ${sku}  ${num}  Evaluate  "${item}".split("|")
        ${quantity_expected}  Evaluate  ${quantity_original}[${sku}] - ${num}
        Should Be Equal As Integers  ${quantity_expected}  ${quantity_modified}[${sku}]
    END

Buyer Inventory Reservation
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    ${data}  buyer_reservation_req_data  ${user_id}  ${order_num}  ${data_list}
    ${resp}  post on session  ${session}  ${path.inv.reservation}  json=${data}  expected_status=${expected_status}
    [Return]  ${resp.json()}

Post Reservation Info
    [Arguments]    ${channel}      ${sku_number}   ${quantity}      ${order_number}    ${session}   ${status}
    ${data}  post_scheduled_inventory    ${channel}      ${sku_number}   ${quantity}     ${order_number}
    ${url}  set variable    ${path.inv.reservation}
    ${resp}  post on session  ${session}    ${url}    data=${data}      expected_status=${status}
    [Return]    ${resp.json()}

Single Booking Multiple Sku
    [Arguments]    ${channel}      ${sku_number1}      ${sku_number2}   ${quantity}      ${order_number}    ${session}   ${status}
    ${data}  post_scheduled_inventory    ${channel}      ${sku_number}   ${quantity}     ${order_number}
    ${url}  set variable    ${path.inv.reservation}
    ${resp}  post on session  ${session}    ${url}    data=${data}      expected_status=${status}
    [Return]    ${resp.json()}

Delete Reservation Info
    [Arguments]     ${order_number}    ${session}   ${status}
    ${data}  delete_scheduled_inventory    ${order_number}
    ${url}  set variable    ${path.inv.reservation}
    ${resp}  delete on session   ${session}    ${url}    data=${data}      expected_status=${status}
    [Return]    ${resp.json()}

#inventory/buyer/subscribe
Buyer Subscribe
    [Arguments]     ${sku_number}   ${michaels_store_id}     ${session}   ${status}
    ${data}  test_user_subscribe    ${sku_number}   ${michaels_store_id}
    ${url}  set variable    ${path.inv.subscribe}
    ${resp}  post on session   ${session}    ${url}    data=${data}      expected_status=${status}
    [Return]    ${resp.json()}

Template Buyer Subscribe
    [Arguments]     ${sku_number}   ${michaels_store_id}     ${session}   ${status}    &{assert}
    [Documentation]    1.excute SubscribeInventotyScheduler;2.Subscribe;3.excute SubscribeInventotyScheduler
    ${resp}    Buyer Subscribe    ${sku_number}   ${michaels_store_id}     ${session}   ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    IF    "%{TEST_ENV}"=="tst"
        Call Scheduler    31
    ELSE
        Call Scheduler    78
    END

Template Buyer repeat Subscribe
    [Arguments]     ${sku_number}   ${michaels_store_id}     ${session}   ${status}    &{assert}
    Buyer Subscribe    ${sku_number}   ${michaels_store_id}     ${session}   200
    ${resp}    Buyer Subscribe    ${sku_number}   ${michaels_store_id}     ${session}   ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END