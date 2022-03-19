*** Settings ***
Documentation  admin control sku price
...    1.GET/inventory/buyer
...    2.POST/inventory/buyer/list
...    3.POST/inventory/buyer/buy
...    4.POST/inventory/buyer/return
Resource    _common.robot
Library    ../../Libraries/INV/inventory.py
Library     ../../Libraries/INV/Buyer_Inventory.py
Library     ../../Libraries/INV/STRTOJSON.py
Library    Collections
Variables    ../../Libraries/INV/SKU.py
Suite Setup  User and Admin Sign In

*** Test Cases ***

#GET/inventory/buyer
Test Buyer
    [Documentation]
    [Template]  Buyer Inventory
    buyer  200  1  \  ${SKUS.mahattan}[0]
    buyer  200  2  -1  ${SKUS.channel2}[0]
    buyer  200  3  -1  ${SKUS.channel3}[0]

#POST/inventory/buyer/list
Test Buyer List
    [Documentation]
    [Template]  Buyer Inventory List
    buyer  200  1|-1|${SKUS.mahattan}[0]
#    buyer  200  2|\|10596850
    buyer  200  3|-1|${SKUS.channel3}[0] 4|-1|${SKUS.mahattan}[0]
#    unlogin  403  1|10596850|-1

#POST/inventory/buyer/buy
Test Buyer Buy
    [Documentation]  only for channel is 2/3s
    [Setup]  Generate Order Num For Test  5
    [Template]  Template Buyer Inventory Buy
    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[0]  2|-1|${SKUS.channel2}[0]|1
    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[1]  2|-1|${SKUS.channel2}[0]|2  3|-1|${SKUS.channel3}[0]|3

#POST/inventory/buyer/return
#Test Buyer Return After Reservation
#    [Documentation]  1.adjustReason=0,cancel
#    ...    2.adjustReason=1,return
#    ...    3.return quantity>reservation quantity
#    ...    4.return multiple skuNumbers:return quantity=reservation quantity
#    ...    5.return multiple skuNumbers:return quantity<reservation quantity
#    ...    6.return multiple skuNumbers:return quantiy>reservation quantity
#    [Setup]  Generate Order Num For Test  10
#    [Template]  Template Buyer Inventory Return After Reservation
#    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[0]  0  ${False}  2|-1|10596850|2
#    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[1]  1  ${False}  3|-1|10596850|2
##    buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[2]  1  ${True}  3|-1|invtest1|2  code=MCU_12013  message=Inventory reservation had deleted
#    buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[3]  0  ${False}  2|-1|10596850|10    code=MCU_12005
#    ...    message=Total return or cancel inventory can not more than place order inventory
#    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[4]  0  ${False}  2|-1|10596850|2    3|-1|invtest1|2
#    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[5]  0  ${False}  2|-1|10596850|2    3|-1|invtest1|1
#    buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[6]  0  ${False}  2|-1|10596850|2    3|-1|invtest1|3
#    ...    code=MCU_12005    message=Total return or cancel inventory can not more than place order inventory

Test Template Buyer Inventory Return After Buy
    [Documentation]  1.adjustReason=0,cancel
    ...    2.adjustReason=1,return
    ...    3.return quantity>reservation quantity
    ...    4.return multiple skuNumbers:return quantity=reservation quantity
    ...    5.return multiple skuNumbers:return quantity<reservation quantity
    ...    6.return multiple skuNumbers:return quantiy>reservation quantity
    [Setup]  Generate Order Num For Test  10
    [Template]    Template Buyer Inventory Return After Buy
    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[0]  0  ${False}  2|-1|${SKUS.channel2}[0]|2
    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[1]  1  ${False}  3|-1|${SKUS.channel3}[0]|2
#    buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[2]  1  ${True}  3|-1|invtest1|2  code=MCU_12013  message=Inventory reservation had deleted
    buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[3]  0  ${False}  2|-1|${SKUS.channel2}[0]|10    code=MCU_12005
    ...    message=Total return or cancel inventory can not more than place order inventory
    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[4]  0  ${False}  2|-1|${SKUS.channel2}[1]|2    3|-1|${SKUS.channel3}[1]|2
    buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[5]  0  ${False}  2|-1|${SKUS.channel2}[2]|2    3|-1|${SKUS.channel3}[2]|1
    buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[6]  0  ${False}  2|-1|${SKUS.channel2}[0]|2    3|-1|${SKUS.channel3}[0]|3
    ...    code=MCU_12005    message=Total return or cancel inventory can not more than place order inventory

Test Template Retrun Buyer Reservation
    [Setup]  Generate Order Num For Test  10
    [Template]  Template Retrun Buyer Reservation
    200    buyer    111111    ${ORDER_LIST}[0]    0    2|-1|${SKUS.channel2}[2]|2
    200    buyer    111111    ${ORDER_LIST}[1]    1    3|-1|${SKUS.channel3}[0]|2
    200    buyer    111111    ${ORDER_LIST}[2]    0    2|-1|${SKUS.channel2}[2]|2    3|-1|${SKUS.channel3}[0]|2
    200    buyer    111111    ${ORDER_LIST}[3]    0    2|-1|${SKUS.channel2}[2]|2    3|-1|${SKUS.channel3}[0]|2
    400    buyer    111111    ${ORDER_LIST}[4]    0    2|-1|${SKUS.channel2}[2]|3    code=MCU_12005    message=Total return or cancel inventory can not more than place order inventory

Test Buyer Return Without Reservation
    [Setup]  Generate Order Num For Test  1
    Buyer Inventory Return  buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[0]  0    2|-1|10596850|1

Test Buyer Return After Reservation Deleted
    [Setup]  Generate Order Num For Test  1
    Buyer Inventory Reservation With Inventory Check   buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[0]  2|-1|${SKUS.channel2}[0]|1
    Buyer Inventory Delete Reservation  buyer  200  ${BUYER_USER_ID}  ${ORDER_LIST}[0]
    Buyer Inventory Return  buyer  400  ${BUYER_USER_ID}  ${ORDER_LIST}[0]  0  2|-1|${SKUS.channel2}[0]|1

*** Keywords ***
User and Admin Sign In
    ${BUYER_USER_ID}  ${_}  User Sign In  buyer  ${buyer_user}
    Set Suite Variable  ${BUYER_USER_ID}
    User Sign In  admin  ${admin_user}  admin
    Create Session  unlogin  ${host}  headers=${default_headers}

Buyer Inventory
    [Arguments]  ${session}  ${expected_status}  ${channel}  ${michael_store_id}  ${sku}
    ${req_data}  Create Dictionary  channel=${channel}  skuNumber=${sku}  michaelsStoreId=${michael_store_id}
    ${resp}  Get On Session  unlogin  ${path.inv.buyer}  params=${req_data}  expected_status=${expected_status}
    Return From Keyword If  ${expected_status}!=200
    ${resp_data}  Set Variable  ${resp.json()}[data]
    Should Be Equal As Strings  ${req_data}[skuNumber]  ${resp_data}[skuNumber]
    ${michaels_store_id}  Set Variable If  "${req_data}[michaelsStoreId]"==""  -1  ${req_data}[michaelsStoreId]
    Should Be Equal As Strings  ${michaels_store_id}  ${resp_data}[michaelsStoreId]
    [Return]  ${resp_data.get("availableQuantity")}
#  Should Not Be Empty  ${resp_data}[inventoryId]

Admin Edit Inventory
    [Arguments]    ${session}    ${masterSkuNumber}    ${channel}    ${sellerStoreId}=0    @{item}
    ${data}    edit_inventory    ${masterSkuNumber}    ${channel}    ${item}
    ${resp}    POST On Session    ${session}    ${path.inv_admin.store_invs.format(storeId=${sellerStoreId})}    json=${data}
    [Return]   ${resp.json()}

Buyer Get Inventory
    [Arguments]    ${channel}   ${sku_number}
    ${header}   Create Dictionary     json=${default_headers}
    ${data}     get_inventory_test      ${channel}    ${sku_number}
    Log     ${data}
    Create Session      ${host}     ${header}
    ${resp}    Post On Session     buyer    ${path.inv.list}  ${data}
    [Return]      ${resp.json()["data"]}

Buyer Inventory List
    [Arguments]  ${session}  ${expected_status}  @{data_list}
    ${req_data}  buyer list req data  ${data_list}
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

Template Buyer Inventory Buy
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    Buyer Inventory Reservation  ${session}  200  ${user_id}  ${order_num}  @{data_list}
    Buyer Inventory Buy  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}

Template Buyer Inventory Return After Reservation
    [Arguments]    ${session}    ${expected_status}    ${user_id}    ${order_num}    ${adjust_reason}    ${expired}
    ...    @{data_list}    &{assert}
    ${quantity_before_return}    Buyer Inventory List    buyer    200    @{data_list}
    @{reservation_data_list}    Create List
    FOR    ${item}    IN    @{data_list}
        ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
        Append To List  ${reservation_data_list}  ${channel}|${michael_store_id}|${sku}|2
    END
    Buyer Inventory Reservation    ${session}    200    ${user_id}    ${order_num}    @{reservation_data_list}
    ${quantity_after_reservation}    Buyer Inventory List    buyer    200    @{data_list}
    IF    ${expired}==${True}
        Sleep  6
        Call Scheduler    32
        Sleep    5
    END
    ${resp}    Buyer Inventory Return    ${session}    ${expected_status}    ${user_id}    ${order_num}    ${adjust_reason}
    ...    @{data_list}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    ${quantity_after_return}    Buyer Inventory List    buyer    200    @{data_list}
    FOR    ${item}    IN    @{data_list}
        ${return_flag}    Set Variable    ${True}
        ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
        IF    ${quantity}>2
            ${return_flag}    Set Variable    ${False}
            Exit For Loop
        END
    END
    IF    ${return_flag}==${False}
        FOR    ${item}    IN    @{data_list}
        ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
        Should Be Equal As Strings    ${quantity_after_reservation}[${sku}]    ${quantity_after_return}[${sku}]
        END
    ELSE
        FOR    ${item}    IN    @{data_list}
            ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
            IF    ${expected_status}==200
                ${expect_quantity}    Evaluate    int(${quantity_after_reservation}[${sku}])+int(${quantity})
                ${actual_quantity}    Evaluate    int(${quantity_after_return}[${sku}])
                Should Be Equal    ${expect_quantity}    ${actual_quantity}
            ELSE IF    ${expected_status}==400 and ${expired}==${True}
                Should Be Equal As Strings    ${quantity_before_return}[${sku}]    ${quantity_after_return}[${sku}]
            ELSE
                Should Be Equal As Strings    ${quantity_after_reservation}[${sku}]    ${quantity_after_return}[${sku}]
            END
        END
    END
    Sleep  6
    Call Scheduler    32
    Sleep    1

Template Buyer Inventory Return After Buy
    [Arguments]    ${session}    ${expected_status}    ${user_id}    ${order_num}    ${adjust_reason}    ${expired}
    ...    @{data_list}    &{assert}
    ${quantity_before_return}    Buyer Inventory List    buyer    200    @{data_list}
    @{reservation_data_list}    Create List
    FOR    ${item}    IN    @{data_list}
        ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
        Append To List  ${reservation_data_list}  ${channel}|${michael_store_id}|${sku}|2
    END
    Buyer Inventory Reservation    ${session}    200    ${user_id}    ${order_num}    @{reservation_data_list}
    Sleep    2
    ${quantity_after_reservation}    Buyer Inventory List    buyer    200    @{data_list}
    Buyer Inventory Buy    buyer    200    ${user_id}    ${order_num}    @{reservation_data_list}
    IF    ${expired}==${True}
        Sleep  6
        IF    "%{TEST_ENV}"=="tst"
            Call Scheduler    7
        ELSE
            Call Scheduler    32
        END
        Sleep    5
    END
    ${resp}    Buyer Inventory Return    ${session}    ${expected_status}    ${user_id}    ${order_num}    ${adjust_reason}
    ...    @{data_list}
    sleep  2
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    ${quantity_after_return}    Buyer Inventory List    buyer    200    @{data_list}
    FOR    ${item}    IN    @{data_list}
        ${return_flag}    Set Variable    ${True}
        ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
        IF    ${quantity}>2
            ${return_flag}    Set Variable    ${False}
            Exit For Loop
        END
    END
    IF    ${return_flag}==${False}
        FOR    ${item}    IN    @{data_list}
        ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
        Should Be Equal As Strings    ${quantity_after_reservation}[${sku}]    ${quantity_after_return}[${sku}]
        END
    ELSE
        FOR    ${item}    IN    @{data_list}
            ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
            IF    ${expected_status}==200
                ${expect_quantity}    Evaluate    int(${quantity_after_reservation}[${sku}])+int(${quantity})
                ${actual_quantity}    Evaluate    int(${quantity_after_return}[${sku}])
                Should Be Equal    ${expect_quantity}    ${actual_quantity}
            ELSE IF    ${expected_status}==400 and ${expired}==${True}
                Should Be Equal As Strings    ${quantity_before_return}[${sku}]    ${quantity_after_return}[${sku}]
            ELSE
                Should Be Equal As Strings    ${quantity_after_reservation}[${sku}]    ${quantity_after_return}[${sku}]
            END
        END
    END
    Sleep  6
    Call Scheduler    32
    Sleep    1

Template Retrun Buyer Reservation
    [Arguments]    ${status}    ${session}    ${cusromer_id}    ${order_num}    ${adjust_reason}    @{sku_item}    &{assert}
    ${req_data}    buyer_reservation_req_data    ${cusromer_id}    ${order_num}    ${sku_item}
    @{inventory_before}    Create List
    @{inventory_after}    Create List
    @{redis_before}    Create List
    @{redis_after}    Create List
    @{reservation_data_list}    Create List

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
#    ${resp_reservation}     Post On Session   ${session}    ${path.inv.reservation}    json=${req_data}    expected_status=200
#    sleep    2

    FOR    ${item}    IN    @{sku_item}
        ${channel}    ${michael_store_id}    ${sku}    ${quantity}    Evaluate    "${item}".split("|")
        Append To List    ${reservation_data_list}    ${channel}|${michael_store_id}|${sku}|2
    END
    Buyer Inventory Reservation    ${session}    200    ${cusromer_id}    ${order_num}    @{reservation_data_list}
    sleep    2
    Buyer Inventory Buy    buyer    200    ${cusromer_id}    ${order_num}    @{reservation_data_list}
    ${resp}    Buyer Inventory Return    ${session}    ${status}    ${cusromer_id}    ${order_num}    ${adjust_reason}
    ...    @{sku_item}
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
        Should Be Equal As Strings    ${resp}[${K}]    ${V}
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

Buyer Inventory Buy
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    ${req_data}  buyer_buy_req_data  ${user_id}  ${order_num}  ${data_list}
    ${resp}  POST On Session  unlogin  ${path.inv.buy}  json=${req_data}  expected_status=${expected_status}
    ${resp_data}  Set Variable  ${resp.json()}[data]
    Return From Keyword If  ${expected_status}!=200
    [Return]  ${resp_data}

Buyer Inventory Reservation With Inventory Check
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    log  ${data_list}
    &{quantity_original}  Buyer Inventory List  buyer  200  @{data_list}
    Buyer Inventory Reservation  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    &{quantity_modified}  Buyer Inventory List  buyer  200  @{data_list}
    FOR  ${item}  IN  @{data_list}
        log  ${item}
        ${_}  ${_}  ${sku}  ${num}  Evaluate  "${item}".split("|")
        ${quantity_expected}  Evaluate  ${quantity_original}[${sku}] - ${num}
        Should Be Equal As Integers  ${quantity_expected}  ${quantity_modified}[${sku}]
    END

Buyer Inventory Reservation
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}  @{data_list}
    ${data}  buyer_reservation_request_data  ${user_id}  ${order_num}  ${data_list}
    ${resp}  post on session  ${session}  ${path.inv.reservation}  json=${data}  expected_status=${expected_status}
    [Return]  ${resp.json()}

Buyer Inventory Return
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}  ${adjust_reason}  @{data_list}
    ${data}  Buyer Return Req Data  ${user_id}  ${order_num}  ${adjust_reason}  ${data_list}
    ${resp}  post on session  ${session}  ${path.inv['return']}  json=${data}  expected_status=${expected_status}
    [Return]  ${resp.json()}

Buyer Inventory Delete Reservation
    [Arguments]  ${session}  ${expected_status}  ${user_id}  ${order_num}
    ${data}  Create Dictionary  customerId=${user_id}  orderNumber=${order_num}
    ${resp}  delete on session  ${session}  ${path.inv.reservation}  json=${data}  expected_status=${expected_status}
    [Return]  ${resp.json()}
