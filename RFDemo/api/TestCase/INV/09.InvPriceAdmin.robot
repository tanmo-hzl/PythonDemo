*** Settings ***
Documentation    Buyer Inventory Price Controller
...    1.POST/inv-price/get
Library    RequestsLibrary
Library     ../../Libraries/INV/Buyer_Inventory.py
Library    ../../Libraries/INV/deltatime.py
Library    ../../Libraries/INV/price.py
Resource    ../../INVconfig.robot
Resource    _common.robot
Library    ../../Libraries/INV/invAndPrice.py

Suite Setup  User and Admin Sign In


*** Variables ***
${sku_number_channel3}    5240026367898386432
${sku_number_channel1}    10619990

*** Test Cases ***
#POST/inv-price/get
Test Template Buyer Get Inv And Price
    [Documentation]    1.refer_type=1,price_rule.price<price.cur_price
    ...    2.refer_type!=1,price_rule.price<price.cur_price
    ...    3.refer_type=1,price_rule.price>price.cur_price
    ...    4.refer_type=1,price_rule.price=price.cur_price
    ...    5.skuNumber of channel 1
    ...    6.multiple skuNumbers
    ...    7.with buyer access
    [Template]    Template Buyer Get Inv And Price
    200    unlogin    1    13.14    3|${sku_number_channel3}|-1
    200    unlogin    2    13.14    3|${sku_number_channel3}|-1
    200    unlogin    1    90    3|${sku_number_channel3}|-1
    200    unlogin    2    80    3|${sku_number_channel3}|-1
    200    unlogin    1    13.14    1|${sku_number_channel1}|-1
    200    unlogin    1    13.14    3|${sku_number_channel3}|-1    1|${sku_number_channel1}|-1
    200    buyer    1    13.14    3|${sku_number_channel3}|-1

*** Keywords ***
User and Admin Sign In
    User Sign In    buyer    ${buyer_user}
    User Sign In    admin    ${admin_user}    admin
    create session    unlogin    ${host}     headers=${default_headers}     verify=True

Buyer Get Inventory
    [Arguments]    ${channel}   ${sku_number}
    ${header}   Create Dictionary     json=${default_headers}
    ${data}     get_inventory_test      ${channel}    ${sku_number}
    Log     ${data}
    Create Session      ${host}     ${header}
    ${resp}    Post On Session     buyer    ${path.inv.list}  ${data}
    [Return]      ${resp.json()["data"]}

Inner Batch SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}
    ${data}    inner_batch_sku_price    skuNumber=${sku_number}    masterSkuNumber=${master_sku_number}
    ...    currency=${currency}    originPrice=${origin_price}    price=${price}
    ${url}    set variable    ${path.price_admin.inner_batch_info.format(sellerStoreId=${seller_store_id})}
    ${resp}    post on session    ${session}    ${url}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Ininitialize SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}
    ${resp}    Inner Batch SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    ${origin_price}    ${price}    200

Add Price Rule
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${price}    ${start_time}    ${end_time}    ${refer_type}
    ...    ${refer_id}    ${status}    ${michaels_store_id}=-1
    ${test_time}    deltatime.get_delta_timestamp
    ${start_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${start_time}
    ${end_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${end_time}
    &{item}    Create Dictionary    sku_number=${sku_number}    price=${price}    start_time=${start_time}
    ...    end_time= ${end_time}    refer_type=${refer_type}    refer_id=${refer_id}    michaels_store_id=${michaels_store_id}
    ${data}    sku_price_rule_data    ${item}
    ${resp}    POST On Session    ${session}    ${price_rule_admin.price_rule.format(sellerStoreId=${seller_store_id})}
    ...    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Get Price Sku
    [Arguments]    ${status}    ${session}    @{skuNumber}
    ${params}    price_sku    ${skuNumber}
    ${resp}    GET On Session    ${session}    ${path.price.sku}    params=${params}    expected_status=${status}
    [Return]    ${resp.json()}

Buyer Get Inv And Price
    [Arguments]    ${status}    ${session}    @{item}
    ${data}    inv_price_req_data    @{item}
    ${resp}    POST On Session    ${session}    ${inv_price_admin.inv_price}    json=${data}   expected_status=${status}
    [Return]    ${resp.json()}

Template Buyer Get Inv And Price
    [Arguments]    ${status}    ${session}    ${referType}    ${price}    @{item}    &{assert}
    ${resp}    Buyer Get Inv And Price    ${status}    ${session}    ${item}
    ${data}    inv_price_req_data    ${item}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    ${num}    Get Length  ${resp}[data]
    FOR    ${i}    IN RANGE    ${num}
        ${skuNumber}    Set Variable    ${data}[${i}][skuNumber]
        ${channel}    Set Variable    ${data}[${i}][channel]
        ${michaelsStoreId}    Set Variable    ${data}[${i}][michaelsStoreId]
        ${inv_resp}   Buyer Get Inventory    ${channel}    ${skuNumber}
#        Should Be Equal As Strings    ${resp}[data][${skuNumber}][buyerInventoryResponse][availableQuantity]    ${inv_resp}[availableQuantity]
#        Should Be Equal As Strings    ${resp}[data][${skuNumber}][buyerInventoryResponse][inStock]    ${inv_resp}[inStock]
        Should Be Equal As Strings    ${resp}[data][${i}][buyerInventoryResponse]    ${inv_resp}[0]
        ${sellerStoreId}    Set Variable    ${inv_resp}[0][sellerStoreId]
        Ininitialize SKU Price Info    admin    ${sellerStoreId}    ${skuNumber}    ${skuNumber}    USD   100    80    200
        Add Price Rule    admin    ${inv_resp}[0][sellerStoreId]    ${skuNumber}    ${price}    3    9    ${referType}    3    200
        ${price_resp_before_start_time}    Get Price Sku    200    buyer    ${skuNumber}
        ${inv_price_resp_before_start_time}    Buyer Get Inv And Price    ${status}    ${session}    ${item}
#        Should Be Equal As Strings    ${price_resp_before_start_time}[0][promoPrice]    ${resp}[data][${skuNumber}][buyerPriceInfoVo][promoPrice]
#        Should Be Equal As Strings    ${price_resp_before_start_time}[0][originPrice]    ${resp}[data][${skuNumber}][buyerPriceInfoVo][originPrice]
        Should Be Equal As Strings    ${price_resp_before_start_time}[0]    ${inv_price_resp_before_start_time}[data][${i}][buyerPriceInfoVo]
        sleep    4
        ${inv_price_resp_after_start_time}    Buyer Get Inv And Price    ${status}    ${session}    ${item}
        ${price_resp_after_start_time}    Get Price Sku    200    buyer    ${skuNumber}
        Should Be Equal As Strings    ${price_resp_after_start_time}[0]    ${inv_price_resp_after_start_time}[data][${i}][buyerPriceInfoVo]
        sleep    5
        ${inv_price_resp_after_end_time}    Buyer Get Inv And Price    ${status}    ${session}    ${item}
        ${price_resp_after_end_time}    Get Price Sku    200    buyer    ${skuNumber}
        Should Be Equal As Strings    ${price_resp_after_end_time}[0]    ${inv_price_resp_after_end_time}[data][${i}][buyerPriceInfoVo]
        END