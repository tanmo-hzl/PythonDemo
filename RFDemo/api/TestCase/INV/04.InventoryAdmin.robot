*** Settings ***
Documentation    Inventory Admin Controller
...    1.GET/inventory/store/inventorys
...    2.POST/inventory/store/{storeId}/list
...    3.POST/inventory/store/{storeId}/inventorys
...    4.POST/inventory/omni/store/inventorys
Resource    _common.robot
Resource  ../../INVconfig.robot
Library    ../../Libraries/INV/inventory.py
Library    ../../Libraries/INV/SnowflakeId.py
Library    Collections
Suite Setup    User and Admin Sign In

*** Variables ***
${store_Id}    0
${master_Sku_Number}    invtest
${master_Sku_Number2}    10596850
${omni_Sku_Number1}    MP314583
${omni_Sku_Number2}    10442631
${omni_Sku_Number_1056}    10597168

*** Test Cases ***
#GET/inventory/store/inventorys
Test Get Inventory Info Positive
    [Template]    Template Get Inventory Info Positive
    ${store_Id}    ${master_Sku_Number}    sellerStoreId=${store_Id}    masterSkuNumber=${master_Sku_Number}

Test Get Inventory Info Nagitive
    [Template]    Template Get Inventory Info Negitive
    admin      ${store_Id}     0                        200    data=[]
    unlogin    ${store_Id}     ${master_Sku_Number}     401
    admin      ${None}         ${master_Sku_Number}     400    message=org.springframework.web.method.annotation.MethodArgumentTypeMismatchException: Failed to convert value of type 'java.lang.String' to required type 'java.lang.Long'; nested exception is java.lang.NumberFormatException: For input string: \"None\"

#POST/inventory/store/{storeId}/list
Test Get Inventory List Positive
    [Template]    Template Get Inventory List Positive
    ${store_Id}    ${master_Sku_Number}    sellerStoreId=${store_Id}    masterSkuNumber=${master_Sku_Number}

Test Get Inventory List Negitive
    [Template]    Template Get Inventory List Negitive
    admin    ${store_Id}     200    0                        data=[]
    unlogin  ${store_Id}     401    ${master_Sku_Number}
    admin    ${None}         400    ${master_Sku_Number}     message=org.springframework.web.method.annotation.MethodArgumentTypeMismatchException: Failed to convert value of type 'java.lang.String' to required type 'java.lang.Long'; nested exception is java.lang.NumberFormatException: For input string: \"None\"

#POST/inventory/store/{storeId}/inventorys
Test Add Inventory When Input editInventoryItemRos Is Null
    [Documentation]    1.add inventory of one skuNumber when sellerStoreId=0
    ...    2.add inventory of one skuNumber when sellerStoreId!=0
    ...    3.add inventory of multiple skuNumbers
    [Template]    Add Inventory When Input editInventoryItemRos Is Null
    admin    0    addinv    2    99
    admin    10    addinv    3    99
    admin    10    addinv    2    99    88

Test Edit Inventory When Input addInventoryItemRos Is Null
    [Documentation]    1.adjustType=1,increase the inventory for one skuNumber
    ...    2.adjustType=2,reduce the inventory for one skuNumber when availableQuantity<adjustAvailableQuantity
    ...    3.adjustType=2,reduce the inventory for one skuNumber when availableQuantity=adjustAvailableQuantity
    ...    4.adjustType=2,reduce the inventory for one skuNumber when availableQuantity>adjustAvailableQuantity
    ...    5.adjust multiple skuNumbers
    ...    6.adjust nultiple skuNumbers when inventory of one skuNumber is not enough
    [Template]    Edit Inventory When Input addInventoryItemRos Is Null
    200    admin    0    editinv    2    1|1
    200    admin    10    editinv2    3    1|2
    200    admin    0    editinv3    3    10|2
    400    admin    10    editinv4    2    11|2    code=MCU_12000    message=Inventory does not enough
    200    admin    10    editinv5    2    5|1    5|2
    400    admin    10    editinv6    3    2|1    5|2    15|2    code=MCU_12000    message=Inventory does not enough

Test Edit Store Inventorys Positive
    [Documentation]    1.channel2:add and edit inventory at the same time,adjustType=1(increase)
    ...    2.channel3:add and edit inventory at the same time,adjustType=1(increase)
    ...    3.channel2:add and edit inventory at the same time,adjustType=2(reduce)
    ...    4.channel3:add and edit inventory at the same time,adjustType=2(reduce)
    [Template]    Template Edit Store Inventorys Positive
    0    eiditinv    2    10    5    1
    0    eiditinv    3    10    5    1
    0    eiditinv2    2    10    5    2
    0    eiditinv2    3    10    5    2

Test Edit Store Inventorys Negitive
    [Documentation]    1.Autority of channel2
    ...    2.Autority of channel3
    ...    3.storeId is None
    ...    4.create Inventory failed of channel2: sku existed
    ...    5.create Inventory failed of channel3: sku existed
    [Template]    Template Edit Store Inventorys Negitive
    unlogin  0  10621948  2    1062194823466  2  5071721546055196682  9960  1  401
    unlogin  0  10621948  3    1062194823466  2  5071721546055196682  9960  1  401
    admin    ${None}    2    10621948  1062194823766  2  5071721546055196682  9960  1  400   message=org.springframework.web.method.annotation.MethodArgumentTypeMismatchException: Failed to convert value of type 'java.lang.String' to required type 'java.lang.Long'; nested exception is java.lang.NumberFormatException: For input string: \"None\"
    admin    0   10621948   2    10621948236669   2   5071721546055196682   9960   1  400  code=MCU_12021    message=Inventory sku existed
    admin    0   10621948   3    10621948236669   2   5071721546055196682   9960   1  400  code=MCU_12021    message=Inventory sku existed

#POST/inventory/omni/store/inventorys
Test Template Admin Get Omni Inventorys
    [Template]    Template Admin Get Omni Inventorys
    admin    -1    ${omni_Sku_Number1}    code=200    message=success
    admin    -1    ${omni_Sku_Number1}    ${omni_Sku_Number2}    code=200    message=success
    admin    1056    ${omni_Sku_Number_1056}    code=200    message=success


*** Keywords ***
User and Admin Sign In
    User Sign In    buyer    ${buyer_user}
    User Sign In    admin    ${admin_user}    admin
    Create Session    unlogin    ${host}   headers=${default_headers}


Get Inventory Info
    [Arguments]    ${session}    ${store_Id}    ${master_Sku_Number}    ${status}
    ${url}    set variable    ${path.inv_admin.invs}
    &{params}    create dictionary    storeId=${store_Id}    masterSkuNumber=${master_Sku_Number}
    ${resp}    get on session    ${session}    ${url}    params=${params}   expected_status=${status}
    [Return]    ${resp.json()}

Template Get Inventory Info Positive
    [Arguments]    ${store_Id}    ${master_Sku_Number}    &{assert}
    ${resp}    Get Inventory Info    admin    ${store_Id}    ${master_Sku_Number}    200
    FOR    ${key}    ${value}    IN    &{assert}
        FOR    ${item}    IN    @{resp}[data]
                should be equal as strings    ${item}[${Key}]   ${value}
        END
    END


Template Get Inventory Info Negitive
    [Arguments]    ${session}    ${store_Id}    ${master_Sku_Number}    ${status}    &{assert}
    ${resp}    Get Inventory Info    ${session}    ${store_Id}    ${master_Sku_Number}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Get Inventory List
    [Arguments]    ${session}    ${store_Id}    ${status}    @{master_Sku_Number}
    ${url}  set variable    ${path.inv_admin.list.format(storeId=${store_Id})}
    ${resp}  post on session    ${session}    ${url}    json=${master_Sku_Number}   expected_status=${status}
    [Return]    ${resp.json()}

Template Get Inventory List Positive
    [Arguments]    ${store_Id}    @{master_Sku_Number}    &{assert}
    ${resp}    Get Inventory List    admin    ${store_Id}    200    ${master_Sku_Number}
    FOR    ${j}    IN    @{resp}[data]
        FOR    ${key}    ${value}    IN    &{assert}
            FOR    ${item}    IN    ${j}
                    should be equal as strings    ${item}[${Key}]   ${value}
            END
        END
    END


Template Get Inventory List Negitive
    [Arguments]    ${session}    ${store_Id}    ${status}    @{master_Sku_Number}    &{assert}
    ${resp}    Get Inventory List    ${session}    ${store_Id}       ${status}    ${master_Sku_Number}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Add Inventory
    [Arguments]    ${session}    ${seller_store_id}    ${master_Sku_Number}    ${channel}    @{sku_and_quantity}
    ${data}    inventory_add_req_data    ${master_Sku_Number}    ${channel}    ${sku_and_quantity}
    ${resp}    POST On Session    ${session}    ${path.inv_admin.store_invs.format(storeId=${seller_store_id})}    json=${data}
    [Return]    ${resp.json()}

Edit Inventory
    [Arguments]    ${status}    ${session}    ${seller_store_id}    ${data}
    ${resp}    POST On Session    ${session}    ${path.inv_admin.store_invs.format(storeId=${seller_store_id})}    json=${data}
    ...    expected_status=${status}
    [Return]    ${resp.json()}

Buyer Get Inventory
    [Arguments]    ${expected_status}    ${channel}    ${michael_store_id}    ${sku}
    ${req_data}  Create Dictionary  channel=${channel}  skuNumber=${sku}  michaelsStoreId=${michael_store_id}
    ${resp}  Get On Session  unlogin  ${path.inv.buyer}  params=${req_data}  expected_status=${expected_status}
    [Return]  ${resp.json()}

Add Inventory When Input editInventoryItemRos Is Null
    [Arguments]    ${session}    ${seller_store_id}    ${master_Sku_Number}    ${channel}    @{quantity}
    ${num}    Get Length    ${quantity}
    @{sku_and_quantity}    Create List
    FOR    ${i}    IN RANGE    ${num}
        ${sku_number}    Generate Id
        Append To List    ${sku_and_quantity}     ${sku_number}|${quantity}[${i}]
    END
    Log Many    @{sku_and_quantity}
    ${data}    inventory_add_req_data    ${master_Sku_Number}    ${channel}    ${sku_and_quantity}
    Add Inventory    ${session}    ${seller_store_id}    ${master_Sku_Number}    ${channel}    @{sku_and_quantity}
    FOR    ${item}    IN    @{data}[addInventoryItemRos]
        ${inv_resp}    Buyer Get Inventory    200    2    -1    ${item}[skuNumber]
        Should Be Equal As Strings    ${inv_resp}[data][masterSkuNumber]    ${master_Sku_Number}
        Should Be Equal As Strings    ${inv_resp}[data][skuNumber]    ${item}[skuNumber]
        Should Be Equal As Strings    ${inv_resp}[data][availableQuantity]    ${item}[availableQuantity]
    END

Edit Inventory When Input addInventoryItemRos Is Null
    [Arguments]    ${status}    ${session}    ${seller_store_id}    ${master_Sku_Number}    ${channel}    @{quantity_adjusttype}
    ...    &{assert}
    Set Test Documentation    1.creat two lists for following test
    ${num}    Get Length    ${quantity_adjusttype}
    @{sku_and_quantity}    Create List
    @{inventory_quantity_adjusttype}    Create List

    Set Test Documentation    2.append items to @{sku_and_quantity}
    FOR    ${i}    IN RANGE    ${num}
        ${sku_number}    Generate Id
        Append To List    ${sku_and_quantity}     ${sku_number}|10
    END

    Set Test Documentation    3.add inventory before edit
    ${data}    inventory_add_req_data    ${master_Sku_Number}    ${channel}    ${sku_and_quantity}
    Add Inventory    ${session}    ${seller_store_id}    ${master_Sku_Number}    ${channel}    @{sku_and_quantity}

    Set Test Documentation    4.append items to @{inventory_quantity_adjusttype}
    FOR    ${i}    IN RANGE    ${num}
        ${inv_resp}    Buyer Get Inventory    200    2    -1    ${data}[addInventoryItemRos][${i}][skuNumber]
        ${inventoryId}    Set Variable    ${inv_resp}[data][inventoryId]
        ${availableQuantity}    Set Variable    ${inv_resp}[data][availableQuantity]
        Append To List    ${inventory_quantity_adjusttype}    ${inventoryId}|${quantity_adjusttype}[${i}]
    END

    Set Test Documentation    5.edit inventory
    ${edit_data}    inventory_edit_req_data    ${master_Sku_Number}    ${channel}    ${inventory_quantity_adjusttype}
    ${edit_resp}    Edit Inventory    ${status}    ${session}    ${seller_store_id}    ${edit_data}

    Set Test Documentation    6.judge whether the inventory is enough when reduce inventory
    FOR    ${i}    IN RANGE    ${num}
        ${enough_flag}    Set Variable    ${True}
        ${edit_quantity}    Evaluate    int(${edit_data}[editInventoryItemRos][${i}][adjustAvailableQuantity])
        ${inventory_quantity}    Evaluate    int(10)
        IF    ${edit_data}[editInventoryItemRos][${i}][adjustType]==2 and ${edit_quantity}>${inventory_quantity}
            ${enough_flag}    Set Variable    ${False}
            Exit For Loop
        END
    END

    Set Test Documentation    7.assert
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${edit_resp}[${k}]    ${v}
    END
    IF    ${enough_flag}==${True}
        FOR    ${i}    IN RANGE    ${num}
            ${inv_resp_after_eidt}    Buyer Get Inventory    200    2    -1    ${data}[addInventoryItemRos][${i}][skuNumber]
            IF    ${edit_data}[editInventoryItemRos][${i}][adjustType]==1
                ${expect_quantity}    Evaluate    int(${edit_data}[editInventoryItemRos][${i}][adjustAvailableQuantity])+int(10)
                ${acutal_quantity}    Evaluate    int(${inv_resp_after_eidt}[data][availableQuantity])
                Should Be Equal As Strings    ${expect_quantity}    ${acutal_quantity}
            ELSE
                ${expect_quantity}    Evaluate    int(10)-int(${edit_data}[editInventoryItemRos][${i}][adjustAvailableQuantity])
                ${acutal_quantity}    Evaluate    int(${inv_resp_after_eidt}[data][availableQuantity])
                Should Be Equal As Strings    ${expect_quantity}    ${acutal_quantity}
            END
        END
    ELSE
        FOR    ${i}    IN RANGE    ${num}
            ${inv_resp_after_eidt}    Buyer Get Inventory    200    2    -1    ${data}[addInventoryItemRos][${i}][skuNumber]
            ${expect_quantity}    Evaluate    int(10)
            ${actual_quantity}    Evaluate    int(${inv_resp_after_eidt}[data][availableQuantity])
            Should Be Equal As Strings    ${expect_quantity}    ${actual_quantity}
        END
    END

Edit Store Inventorys
    [Arguments]    ${session}    ${store_Id}    ${master_Sku_Number}    ${channel}    ${sku_Number}    ${available_Quantity}
    ...            ${inventory_Id}    ${adjust_Available_Quantity}    ${adjust_Type}    ${status}
    ${data}    store inventorys    ${master_Sku_Number}    ${channel}    ${sku_Number}    ${available_Quantity}    ${inventory_Id}
    ...        ${adjust_Available_Quantity}     ${adjust_Type}
    ${url}     Set Variable    ${path.inv_admin.store_invs.format(storeId=${store_Id})}
    ${resp}    post on session    ${session}    ${url}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Template Edit Store Inventorys Positive
    [Arguments]    ${seller_store_id}    ${master_Sku_Number}    ${channel}    ${available_Quantity}    ${adjust_Available_Quantity}
    ...    ${adjust_Type}    &{assert}
    ${skuNumber_add}    Generate Id
    ${skuNumber_edit}    Generate Id
    Log Many    ${skuNumber_edit}|${available_Quantity}
    Add Inventory    admin    ${seller_store_id}    ${master_Sku_Number}    ${channel}    ${skuNumber_edit}|${available_Quantity}
    ${inv_resp_before_edit}    Buyer Get Inventory    200    2    -1    ${skuNumber_edit}
    ${inventory_Id}    Set Variable    ${inv_resp_before_edit}[data][inventoryId]
    ${resp}    Edit Store Inventorys    admin    ${seller_store_id}    ${master_Sku_Number}    ${channel}    ${skuNumber_add}    ${available_Quantity}
    ...            ${inventory_Id}    ${adjust_Available_Quantity}    ${adjust_Type}    200
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END
    ${inv_resp_add}    Buyer Get Inventory    200    2    -1    ${skuNumber_add}
    ${inv_resp_after_edit}    Buyer Get Inventory    200    2    -1    ${skuNumber_edit}
    Should Be Equal As Strings    ${available_Quantity}    ${inv_resp_add}[data][availableQuantity]
    IF    ${adjust_Type}==1
        ${expect_quantity_after_edit}    Evaluate    int(${available_Quantity})+int(${adjust_Available_Quantity})
        ${acutal_quantity_after_edit}    Evaluate    int(${inv_resp_after_edit}[data][availableQuantity])
        Should Be Equal    ${expect_quantity_after_edit}    ${acutal_quantity_after_edit}
    ELSE
        ${expect_quantity_after_edit}    Evaluate    int(${available_Quantity})-int(${adjust_Available_Quantity})
        ${acutal_quantity_after_edit}    Evaluate    int(${inv_resp_after_edit}[data][availableQuantity])
        Should Be Equal    ${expect_quantity_after_edit}    ${acutal_quantity_after_edit}
    END


Template Edit Store Inventorys Negitive
    [Arguments]    ${session}    ${store_Id}    ${master_Sku_Number}    ${channel}    ${sku_Number}    ${available_Quantity}
    ...            ${inventory_Id}    ${adjust_Available_Quantity}    ${adjust_Type}    ${status}    &{assert}
    ${resp}    Edit Store Inventorys    ${session}    ${store_Id}    ${master_Sku_Number}    ${channel}    ${sku_Number}    ${available_Quantity}
    ...            ${inventory_Id}    ${adjust_Available_Quantity}    ${adjust_Type}    ${status}
     FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Admin Get Omni Inventorys
    [Arguments]    ${session}    ${michaels_store_id}    @{skunumbers}
    ${data}    omni_inventory_req_data    ${michaels_store_id}     @{skunumbers}
    ${resp}    POST On Session    ${session}    ${omni_inventory_admin.inventory}    json=${data}
    [Return]    ${resp.json()}

Template Admin Get Omni Inventorys
    [Arguments]    ${session}    ${michaels_store_id}    @{skunumbers}    &{assert}
    ${resp}    Admin Get Omni Inventorys    ${session}    ${michaels_store_id}    ${skunumbers}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]   ${assert}[${k}]
    END
    ${num}    Get Length    ${resp}[data]
    FOR    ${i}    IN RANGE    ${num}
        Should Contain    ${skunumbers}    ${resp}[data][${i}][skuNumber]
    END
    ${req_length}    Evaluate    len(@{skunumbers})
    Should Be Equal As Strings    ${num}     ${req_length}