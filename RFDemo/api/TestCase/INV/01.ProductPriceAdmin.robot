*** Settings ***
Documentation    admin control sku price
...    1.GET/price-admin/{sellerStoreId}/product-price-log
...    2.GET/price-admin/{sellerStoreId}/product-price-info
...    3.GET/price-admin/{sellerStoreId}/sku-price
...    4.GET/price-admin/preview-sku-price-rule
...    5.GET/price-admin/preview-mastersku-price-rule
...    6.POST/price-admin/{sellerStoreId}/inner-batch-sku-price-info
Library    Collections
Library    RequestsLibrary
Library    ../../Libraries/INV/deltatime.py
Library    ../../Libraries/INV/price.py
Resource    ../../INVconfig.robot
Resource    _common.robot
Suite Setup  User and Admin Sign In

*** Variables ***
${seller_store_id}    0
${sku_number}    invtest1
${master_sku_number}    invtest1
${sku_number1}    invtest2
${sku_number2}    invtest3
${sku_number3}    invtest4
${sku_number4}    invtest5
${sku_number5}    invtest6
${sku_number6}    invtest7
${sku_number7}    invtest8
${sku_number8}    invtest9
${sku_number9}    invtest10
${sku_number10}    invtest12
${sku_number11}    invtest13
${currency}    USD

*** Test Cases ***
#GET/price-admin/{sellerStoreId}/product-price-log
Test Template Get Product Price Log Positive
    [Template]    template get product price log positive
    [Documentation]    1.normal scene 2.page turning 3.max(pageNum)=1000 4.min(pageSize)=1 5.max(pageSize)=1000
    ...    6.default value of pageSize
    ${seller_store_id}    ${sku_number}    1    10    skuNumber=${sku_number}
    ${seller_store_id}    ${sku_number}    2    10    skuNumber=${sku_number}
    ${seller_store_id}    ${sku_number}    1000    10
    ${seller_store_id}    ${sku_number}    1    1    skuNumber=${sku_number}
    ${seller_store_id}    ${sku_number}    1    1000    skuNumber=${sku_number}
    ${seller_store_id}    ${sku_number}    1    ${empty}    skuNumber=${sku_number}

Test Template Get Product Price Log Negitive
    [Template]    Template Get Product Price Log Negitive
    [Documentation]    1.pageNum=0 2.pageNum=-1 3.pageNum=1001 4.pageSize=0 5.pageSize=1001 6.skuNumber is null
    ...    7.pageNum is null 8.No permissions
    admin    ${seller_store_id}    ${sku_number}    0    10    400
    admin    ${seller_store_id}    ${sku_number}    -1    10    400
    admin    ${seller_store_id}    ${sku_number}    1001    10    400
    admin    ${seller_store_id}    ${sku_number}    1    0    400
    admin    ${seller_store_id}    ${sku_number}    1    1001    400
    admin    ${seller_store_id}    ${empty}    1    10    400
    admin    ${seller_store_id}    ${sku_number}    ${empty}    10    400
    unlogin    ${seller_store_id}    ${sku_number}    1    10    401

#GET/price-admin/{sellerStoreId}/product-price-info
Test Template Get Product Price Info Positive
    [Template]    Template Get Product Price Info Positive
    ${seller_store_id}    ${master_sku_number}    masterSkuNumber=${master_sku_number}

Test Template Get Product Price Info Negitive
    [Template]    Template Get Product Price Info Negitive
    [Documentation]    1.masterSkuNumber is null 2.No permissions
    admin    ${seller_store_id}   ${empty}    400
    unlogin    ${seller_store_id}    ${master_sku_number}    401

#Test Template Get Product Price Info Can Only Get Online Sku Price
#    [Documentation]    can only query online product price which michaelstoreid=-1
#    [Template]    Template Get Product Price Info Can Only Get Online Sku Price
#    admin    0    productprice001
#    admin    10    productprice002

#GET/price-admin/{sellerStoreId}/sku-price
Test Template Admin Get SKU Price Positive
    [Template]    Template Admin Get SKU Price Positive
    ${seller_store_id}    ${sku_number}

Test Template Admin Get SKU Price Negitive
    [Template]    Template Admin Get SKU Price Negitive
    [Documentation]    1.skuNumber is null 2.skuNumber is not exist in price table 3.No permissions
    admin    ${seller_store_id}   ${empty}    400
    admin    ${seller_store_id}   bucunzaidesku    400    code=MCU_13000
    unlogin    ${seller_store_id}    ${sku_number}    401

#Test Template Admin Get SKU Price Can Only Get Online Sku Price
#    [Documentation]    can only get online sku price when michaelsstoreid=-1
#    [Template]    Template Admin Get SKU Price Can Only Get Online Sku Price
#    admin    0    skuprice001
#    admin    10    skuprice002

#GET/price-admin/preview-sku-price-rule
Test Template Preview SKU Price Rule Positive
    [Template]    Template Preview SKU Price Rule Positive
    admin    ${sku_number}    1234567890345    price=80
    unlogin    ${sku_number}    1234567890345    price=80

Test Template Preview SKU Price Rule Negitive
    [Template]    Template Preview SKU Price Rule Negitive
    [Documentation]    1.skuNumber is null
    admin    ${empty}    1234567890345    400

Test Template Preview SKU Price Rule
    [Documentation]    1.price_rule.start_time<startTime<price_rule.end_time,refer_type=1,price_rule.price<price.cur_price:
    ...    promoPrice=price_rule.price,originPrice=price.origin_price,price=price.cur_price
    ...    2.startTime=price_rule.start_time,refer_type=1,price_rule.price<price.cur_price:promoPrice=price_rule.price,
    ...    originPrice=price.origin_price,price=price.cur_price
    ...    3.startTime<price_rule.start_time,refer_type=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    4.startTime>price_rule.start_time,refer_type=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    5.price_rule.start_time<startTime<price_rule.end_time,refer_type!=1,price_rule.price<price.cur_price:
    ...    promoPrice=null,originPrice=price.cur_price,price=price_rule.price
    ...    6.startTime=price_rule.start_time,refer_type!=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.cur_price,price=price_rule.price
    ...    7.startTime<price_rule.start_time,refer_type!=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    8.startTime>price_rule.start_time,refer_type!=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    9.price_rule.start_time<startTime<price_rule.end_time,price_rule.price=price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    10.price_rule.start_time<startTime<price_rule.end_time,price_rule.price>price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    11.multiple skuNumbers
    [Template]    Template Preview SKU Price Rule
    200    admin     1    1    13.14    ${sku_number}
    200    admin     0    1    13.14    ${sku_number1}
    200    admin     -1    1    13.14    ${sku_number2}
    200    admin     10    1    13.14    ${sku_number3}
    200    admin     1    2    13.14    ${sku_number4}
    200    admin     0    2    13.14    ${sku_number5}
    200    admin     -1    2    13.14    ${sku_number6}
    200    admin     10    2    13.14    ${sku_number7}
    200    admin     1    2    80    ${sku_number8}
    200    admin     0    2    90    ${sku_number9}
    200    admin     -1    1    13.14    ${sku_number10}    ${sku_number11}

#Test Template Preview SKU Price Rule Only Can Query Online SKU Price
#    [Documentation]    can only preview online sku price which michaelsstoreid=-1
#    [Template]    Template Preview SKU Price Rule Only Can Query Online SKU Price
#    200    admin     1    1    13.14    previewsku

#GET/price-admin/preview-mastersku-price-rule
Test Template Preview Mastersku Price Rule Positive
    [Template]    Template Preview Mastersku Price Rule Positive
    ${MASTER_SKU_NUMBER}    1234567890345    masterSkuNumber=${MASTER_SKU_NUMBER}

Test Template Preview Mastersku Price Rule Negitive
    [Template]    Template Preview Mastersku Price Rule Negitive
    admin    ${empty}    1234567890345    400
    unlogin    ${MASTER_SKU_NUMBER}    1234567890345    200

Test Template Preview Mastersku Price Rule
    [Documentation]    1.price_rule.start_time<startTime<price_rule.end_time,refer_type=1,price_rule.price<price.cur_price:
    ...    promoPrice=price_rule.price,originPrice=price.origin_price,price=price.cur_price
    ...    2.startTime=price_rule.start_time,refer_type=1,price_rule.price<price.cur_price:promoPrice=price_rule.price,
    ...    originPrice=price.origin_price,price=price.cur_price
    ...    3.startTime<price_rule.start_time,refer_type=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    4.startTime>price_rule.start_time,refer_type=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    5.price_rule.start_time<startTime<price_rule.end_time,refer_type!=1,price_rule.price<price.cur_price:
    ...    promoPrice=null,originPrice=price.cur_price,price=price_rule.price
    ...    6.startTime=price_rule.start_time,refer_type!=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.cur_price,price=price_rule.price
    ...    7.startTime<price_rule.start_time,refer_type!=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    8.startTime>price_rule.start_time,refer_type!=1,price_rule.price<price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    9.price_rule.start_time<startTime<price_rule.end_time,price_rule.price=price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    10.price_rule.start_time<startTime<price_rule.end_time,price_rule.price>price.cur_price:promoPrice=null,originPrice=price.origin_price,
    ...    price=price.cur_price
    ...    11.multiple skuNumbers
    [Template]    Template Preview Mastersku Price Rule
    200    admin     1    1    13.14    ${sku_number}
    200    admin     0    1    13.14    ${sku_number1}
    200    admin     -1    1    13.14    ${sku_number2}
    200    admin     10    1    13.14    ${sku_number3}
    200    admin     1    2    13.14    ${sku_number4}
    200    admin     0    2    13.14    ${sku_number5}
    200    admin     -1    2    13.14    ${sku_number6}
    200    admin     10    2    13.14    ${sku_number7}
    200    admin     1    2    80    ${sku_number8}
    200    admin     0    2    90    ${sku_number9}
    200    admin     1    1    13.14    ${sku_number10}    ${sku_number11}

#Test Template Preview Mastersku Price Rule Only Can Query Online SKU Price
#    [Documentation]    can only get online sku price which michaelsstoreid=-1
#    [Template]    Template Preview Mastersku Price Rule Only Can Query Online SKU Price
#    200    admin     1    1    13.14    previewmastersku

#POST/price-admin/{sellerStoreId}/inner-batch-sku-price-info
Test Template Inner Batch SKU Price Info scenario origin is not empty
    [Template]    Template Inner Batch SKU Price Info scenario origin is not empty
    [Documentation]
    ...    4.input originPrice<input price，input price!=db price，originPrice and price update to input price
    ...    5.input originPrice=input price，input price!=db price，originPrice and price update
    ...    6.input originPrice>input price，input price!=db price，originPrice and price update
    ...    7.input originPrice>input price，input price=db price，originPrice not update
    ...    8.input originPrice=input price，input price=db price，originPrice not update
    ...    9.input originPrice<input price，input price=db price，originPrice not update
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=150.0
    ...    price=200.0    status=400    code=MCU_13004    message=Sku Originprice not less than price
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=200.5
    ...    price=200.5    status=200
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=250.5
    ...    price=200.5    status=200
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=200.5
    ...    price=80.0    status=200
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=80.0
    ...    price=80.0    status=200
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=50.0
    ...    price=80.0    status=400    code=MCU_13004    message=Sku Originprice not less than price

Test Template Inner Batch SKU Price Info scenario origin is empty
    [Template]    template inner batch sku price info scenario origin is empty
    [Documentation]
    ...    1.originPrice is empty，input price<db price，originPrice update to db price and db price update to input price
    ...    2.originPrice is empty，input price=db price，originPrice and price not update
    ...    3.originPrice is empty，input price>db price，originPrice and price update to input price
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=${empty}
    ...    price=50.5    status=200
#    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=${empty}
#    ...    price=80.0    status=200
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=${empty}
    ...    price=150.5    status=200

Test Template Inner Batch SKU Price Info
    [Template]    Template Inner Batch SKU Price Info
    [Documentation]    1.skuNumber is null 2.masterSkuNumber is null 3.currency is null 4.price is null 5.No permissions
    admin    ${seller_store_id}    ${empty}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=100
    ...    price=50.0    status=400
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${empty}    ${CURRENCY}    origin_price=100    price=50.0
    ...    status=400
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    currency=${empty}    origin_price=100
    ...    price=50.0    status=400
    admin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=100
    ...    price=${empty}    status=400
    unlogin    ${seller_store_id}    ${SKU_NUMBER}    ${MASTER_SKU_NUMBER}    ${CURRENCY}    origin_price=100
    ...    price=50.0    status=200

Test Template Inner Batch SKU Price Info scenario multiple skuNumbers
    [Documentation]    multiple skuNumbrs
    [Template]    Template Inner Batch SKU Price Info scenario multiple skuNumbers
    admin    ${seller_store_id}    invtest1|invtest1|USD|200.99|200.99    invtest2|invtest2|USD|250.99|200.99
    ...    invtest3|invtest3|USD|200.99|80.0    invtest4|invtest4|USD|80.0|80.0

*** Keywords ***
User and Admin Sign In
    User Sign In    buyer    ${buyer_user}
    User Sign In    admin    ${admin_user}    admin
    Create Session    unlogin    ${host}   headers=${default_headers}

Template SKU Price Info Positive
    [Arguments]   ${seller_store_id}    ${sku_num}    &{assert}
    ${resp}    SKU Price Info    admin    ${seller_store_id}    ${sku_num}    200
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[data][${k}]  ${v}
    END

Template SKU Price Info Negitive
    [Arguments]    ${session}    ${seller_store_id}    ${sku_num}    ${status}    &{assert}
    ${resp}    SKU Price Info    ${session}    ${seller_store_id}    ${sku_num}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_num}   ${status}
    ${params}  create dictionary    skuNumber=${sku_num}
    ${url}  set variable    ${path.price_admin.single_info.format(sellerStoreId=${seller_store_id})}
    ${resp}  get on session  ${session}    ${url}    params=${params}   expected_status=${status}
    [Return]    ${resp.json()}

#/price-admin/{sellerStoreId}/product-price-log
Template Get Product Price Log Positive
    [Arguments]   ${seller_store_id}    ${sku_num}    ${page_num}   ${page_size}    &{assert}
    ${resp}    Get Product Price Log    admin    ${seller_store_id}    ${sku_num}    ${page_num}   ${page_size}    200
    @{resp_list}    set variable    ${resp}[data][content]
    FOR    ${i}    IN    @{resp_list}
        FOR    ${k}    ${v}    IN    &{assert}
            should be equal as strings    ${i}[${k}]    ${v}
        END
    END

Template Get Product Price Log Negitive
    [Arguments]    ${session}    ${seller_store_id}    ${sku_num}    ${page_num}   ${page_size}
    ...    ${status}    &{assert}
    ${resp}    Get Product Price Log    ${session}    ${seller_store_id}    ${sku_num}    ${page_num}
    ...    ${page_size}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Get Product Price Log
    [Arguments]    ${session}    ${seller_store_id}    ${sku_num}   ${page_num}    ${page_size}    ${status}
    ${params}  create dictionary    skuNumber=${sku_num}    pageNum=${page_num}    pageSize=${page_size}
    ${url}  set variable    ${path.price_admin.log_by_store.format(sellerStoreId=${seller_store_id})}
    ${resp}  get on session  ${session}    ${url}    params=${params}   expected_status=${status}
    [Return]    ${resp.json()}

#/price-admin/{sellerStoreId}/product-price-info
Template Get Product Price Info Positive
    [Arguments]   ${seller_store_id}    ${master_sku_num}    &{assert}
    ${resp}    Get Product Price Info    admin    ${seller_store_id}    ${master_sku_num}    200
    @{resp_list}    set variable    ${resp}[data]
    FOR    ${i}    IN    @{resp_list}
        FOR    ${k}    ${v}    IN    &{assert}
            should be equal as strings    ${i}[${k}]    ${v}
        END
    END

Template Get Product Price Info Negitive
    [Arguments]    ${session}    ${seller_store_id}    ${master_sku_num}    ${status}    &{assert}
    ${resp}    Get Product Price Info    ${session}    ${seller_store_id}    ${master_sku_num}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template Get Product Price Info Can Only Get Online Sku Price
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD
    ...    100    80    200    -1
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD
    ...    111.11    88.88    200    2021001
    ${resp}    Get Product Price Info    ${session}    ${seller_store_id}    ${sku_number}    200
    FOR    ${item}    IN    @{resp}[data]
        Should Be Equal As Strings    ${item}[michaelsStoreId]    -1
        Should Be Equal As Strings    ${item}[originPrice]    100
        Should Be Equal As Strings    ${item}[price]    80
    END

Get Product Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${master_sku_num}   ${status}
    ${params}  create dictionary    masterSkuNumber=${master_sku_num}
    ${url}  set variable    ${path.price_admin.info_by_store.format(sellerStoreId=${seller_store_id})}
    ${resp}  get on session  ${session}    ${url}    params=${params}   expected_status=${status}
    [Return]    ${resp.json()}

#/price-admin/{sellerStoreId}/sku-price
Template Admin Get SKU Price Positive
    [Arguments]   ${seller_store_id}    ${sku_num}    &{assert}
    ${resp}    Admin Get SKU Price    admin    ${seller_store_id}    ${sku_num}    200
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[data][${k}]  ${v}
    END

Template Admin Get SKU Price Negitive
    [Arguments]    ${session}    ${seller_store_id}    ${sku_num}    ${status}    &{assert}
    ${resp}    Admin Get SKU Price    ${session}    ${seller_store_id}    ${sku_num}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template Admin Get SKU Price Can Only Get Online Sku Price
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD
    ...    100    80    200    -1
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD
    ...    111.11    88.88    200    2021001
    ${resp}    Admin Get SKU Price    ${session}    ${seller_store_id}    ${sku_number}    200
    Should Be Equal As Strings    ${resp}[data]    80

Admin Get SKU Price
    [Arguments]    ${session}    ${seller_store_id}    ${sku_num}   ${status}
    ${params}  create dictionary    skuNumber=${sku_num}
    ${url}  set variable    ${path.price_admin.price_by_store.format(sellerStoreId=${seller_store_id})}
    ${resp}  get on session  ${session}    ${url}    params=${params}   expected_status=${status}
    [Return]    ${resp.json()}

#/price-admin/preview-sku-price-rule
Preview SKU Price Rule
    [Arguments]    ${session}    ${sku_num}    ${start_time}   ${status}
    ${start_time}    deltatime.get_delta_timestamp    ${start_time}
    ${params}  create dictionary    skuNumber=${sku_num}    startTime=${start_time}
    ${url}  set variable    ${path.price_admin.preview_rule}
    ${resp}  get on session  ${session}    ${url}    params=${params}   expected_status=${status}
    [Return]    ${resp.json()}

Template Preview SKU Price Rule Positive
    [Arguments]   ${session}    ${sku_num}    ${start_time}    &{assert}
    Ininitialize SKU Price Info    ${session}    ${seller_store_id}    ${sku_num}    ${sku_num}    USD   100    80    200
    @{resp}    Preview SKU Price Rule    ${session}    ${sku_num}    ${start_time}    200
    IF    @{resp}!=[]
        FOR    ${i}    IN    @{resp}
            FOR    ${k}    ${v}    IN    &{assert}
                should be equal as strings    ${i}[${k}]    ${v}
            END
        END
    ELSE
        Fail    RESPONSE IS NULL
    END

Template Preview SKU Price Rule Negitive
    [Arguments]    ${session}    ${sku_num}    ${start_time}    ${status}    &{assert}
    ${resp}    Preview SKU Price Rule    ${session}    ${sku_num}    ${start_time}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template Preview SKU Price Rule
    [Arguments]    ${status}    ${session}    ${time_delta}   ${refer_type}    ${price_rule_price}    @{sku_num}
    FOR    ${sku}    IN    @{sku_num}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200
        ${start_time}    deltatime.get_delta_timestamp
        ${end_time}    deltatime.get_delta_timestamp    ${start_time}    seconds=4
        ${time}    deltatime.get_delta_timestamp    ${start_time}    seconds=${time_delta}
        Add Price Rule    admin    0      ${sku}    ${price_rule_price}    ${start_time}    ${end_time}    refer_type=${refer_type}    refer_id=1    status=200
        sleep    1
        ${resp}    Preview SKU Price Rule    ${session}    ${sku}    ${time}    ${status}
        IF    @{resp}!=[]
            ${origin_price_db}    Evaluate    float(100)
            ${price_db}    Evaluate    float(80)
            ${price_rule_db}    Evaluate    float(${price_rule_price})
            IF    ${time}<${start_time} or ${time}>${end_time}
                Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                Should Be Equal As Strings    ${resp}[0][originPrice]   80
                Should Be Equal As Strings    ${resp}[0][price]    80
            ELSE IF    ${time}==${start_time} or (${start_time}<${time} and ${time}<${end_time})
                IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${price_rule_price}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    80
                ELSE IF   ${refer_type}!=1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    ${price_rule_price}
                ELSE
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    80
                END
            END
        ELSE
            Fail    RESPONSE IS NULL
        END
    END

Template Preview SKU Price Rule Only Can Query Online SKU Price
    [Arguments]    ${status}    ${session}    ${time_delta}   ${refer_type}    ${price_rule_price}    @{sku_num}
    FOR    ${sku}    IN    @{sku_num}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200    -1
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   1000    800    200    1056
        ${start_time}    deltatime.get_delta_timestamp
        ${end_time}    deltatime.get_delta_timestamp    ${start_time}    seconds=4
        ${time}    deltatime.get_delta_timestamp    ${start_time}    seconds=${time_delta}
        Add Price Rule    admin    0      ${sku}    ${price_rule_price}    ${start_time}    ${end_time}    refer_type=${refer_type}
        ...    refer_id=1    status=200    michaels_store_id=-1
        Add Price Rule    admin    0      ${sku}    11.11    ${start_time}    ${end_time}    refer_type=${refer_type}
        ...    refer_id=1    status=200    michaels_store_id=1056
        Sleep    2
        ${resp}    Preview SKU Price Rule    ${session}    ${sku}    ${time}    ${status}
        IF    @{resp}!=[]
            ${origin_price_db}    Evaluate    float(100)
            ${price_db}    Evaluate    float(80)
            ${price_rule_db}    Evaluate    float(${price_rule_price})
            IF    ${time}<${start_time} or ${time}>${end_time}
                Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                Should Be Equal As Strings    ${resp}[0][originPrice]   100
                Should Be Equal As Strings    ${resp}[0][price]    80
                Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
            ELSE IF    ${time}==${start_time} or (${start_time}<${time} and ${time}<${end_time})
                IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${price_rule_price}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   100
                    Should Be Equal As Strings    ${resp}[0][price]    80
                    Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
                ELSE IF   ${refer_type}!=1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    ${price_rule_price}
                    Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
                ELSE
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   100
                    Should Be Equal As Strings    ${resp}[0][price]    80
                    Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
                END
            END
        ELSE
            Fail    RESPONSE IS NULL
        END
    END

#/price-admin/preview-mastersku-price-rule
Get Price Master Sku
    [Arguments]    ${status}    ${session}    @{master_skuNumber}
    ${params}    price_master_sku    ${master_skuNumber}
    ${resp}    GET On Session    ${session}    ${path.price.mastersku}    params=${params}    expected_status=${status}
    [Return]    ${resp.json()}

Preview Mastersku Price Rule
    [Arguments]    ${session}    ${master_sku_num}    ${start_time}   ${status}
    ${start_time}    deltatime.get_delta_timestamp    ${start_time}
    ${params}  create dictionary    masterSkuNumbers=${master_sku_num}    startTime=${start_time}
    ${url}  set variable    ${path.price_admin.preview_mastersku_rule}
    ${resp}  get on session  ${session}    ${url}    params=${params}   expected_status=${status}
    [Return]    ${resp.json()}

Template Preview Mastersku Price Rule Positive
    [Arguments]   ${master_sku_num}    ${start_time}    &{assert}
    @{resp}    Preview Mastersku Price Rule    admin    ${master_sku_num}    ${start_time}    200
    IF    @{resp}!=[]
        FOR    ${i}    IN    @{resp}
            FOR    ${k}    ${v}    IN    &{assert}
                should be equal as strings    ${i}[${k}]    ${v}
            END
        END
    ELSE
        Fail    RESPONSE IS NULL
    END

Template Preview Mastersku Price Rule Negitive
    [Arguments]    ${session}    ${master_sku_num}    ${start_time}    ${status}    &{assert}
    ${resp}    Preview Mastersku Price Rule    ${session}    ${master_sku_num}    ${start_time}    ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Template Preview Mastersku Price Rule
    [Arguments]    ${status}    ${session}    ${time_delta}   ${refer_type}    ${price_rule_price}    @{master_sku}
    ${resp_sku}    Get Price Master Sku    200    admin    @{master_sku}
    @{sku_num}    Create List
    FOR    ${item}    IN    @{resp_sku}
        log    ${item}[skuNumber]
        Append To List    ${sku_num}    ${item}[skuNumber]
    END
    FOR    ${sku}    IN    @{sku_num}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200
        ${start_time}    deltatime.get_delta_timestamp
        ${end_time}    deltatime.get_delta_timestamp    ${start_time}    seconds=4
        ${time}    deltatime.get_delta_timestamp    ${start_time}    seconds=${time_delta}
        Add Price Rule    admin    0      ${sku}    ${price_rule_price}    ${start_time}    ${end_time}    refer_type=${refer_type}    refer_id=1    status=200
        ${resp}    Preview Mastersku Price Rule    ${session}    ${sku}    ${time}    ${status}
        IF    @{resp}!=[]
            ${origin_price_db}    Evaluate    float(100)
            ${price_db}    Evaluate    float(80)
            ${price_rule_db}    Evaluate    float(${price_rule_price})
            IF    ${time}<${start_time} or ${time}>${end_time}
                Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                Should Be Equal As Strings    ${resp}[0][originPrice]   80
                Should Be Equal As Strings    ${resp}[0][price]    80
            ELSE IF    ${time}==${start_time} or (${start_time}<${time} and ${time}<${end_time})
                IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${price_rule_price}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    80
                ELSE IF   ${refer_type}!=1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    ${price_rule_price}
                ELSE
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    80
                END
            END
        ELSE
            Fail    RESPONSE IS NULL
        END
    END

Template Preview Mastersku Price Rule Only Can Query Online SKU Price
    [Arguments]    ${status}    ${session}    ${time_delta}   ${refer_type}    ${price_rule_price}    @{sku_num}
    FOR    ${sku}    IN    @{sku_num}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200    -1
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   1000    800    200    1056
        ${start_time}    deltatime.get_delta_timestamp
        ${end_time}    deltatime.get_delta_timestamp    ${start_time}    seconds=4
        ${time}    deltatime.get_delta_timestamp    ${start_time}    seconds=${time_delta}
        Add Price Rule    admin    0      ${sku}    ${price_rule_price}    ${start_time}    ${end_time}    refer_type=${refer_type}
        ...    refer_id=1    status=200    michaels_store_id=-1
        Add Price Rule    admin    0      ${sku}    11.11    ${start_time}    ${end_time}    refer_type=${refer_type}
        ...    refer_id=1    status=200    michaels_store_id=1056
        Sleep    2
        ${resp}    Preview Mastersku Price Rule    ${session}    ${sku}    ${time}    ${status}
        IF    @{resp}!=[]
            ${origin_price_db}    Evaluate    float(100)
            ${price_db}    Evaluate    float(80)
            ${price_rule_db}    Evaluate    float(${price_rule_price})
            IF    ${time}<${start_time} or ${time}>${end_time}
                Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                Should Be Equal As Strings    ${resp}[0][originPrice]   100
                Should Be Equal As Strings    ${resp}[0][price]    80
                Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
            ELSE IF    ${time}==${start_time} or (${start_time}<${time} and ${time}<${end_time})
                IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${price_rule_price}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   100
                    Should Be Equal As Strings    ${resp}[0][price]    80
                    Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
                ELSE IF   ${refer_type}!=1 and ${price_rule_db}<${price_db}
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   80
                    Should Be Equal As Strings    ${resp}[0][price]    ${price_rule_price}
                    Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
                ELSE
                    Should Be Equal As Strings    ${resp}[0][promoPrice]    ${null}
                    Should Be Equal As Strings    ${resp}[0][originPrice]   100
                    Should Be Equal As Strings    ${resp}[0][price]    80
                    Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
                END
            END
        ELSE
            Fail    RESPONSE IS NULL
        END
    END

#/price-admin/{sellerStoreId}/inner-batch-sku-price-info
#Inner Batch SKU Price Info
#    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
#    ...    ${origin_price}    ${price}    ${status}
#    ${data}    inner_batch_sku_price    skuNumber=${sku_number}    masterSkuNumber=${master_sku_number}
#    ...    currency=${currency}    originPrice=${origin_price}    price=${price}
#    ${url}    set variable    ${path.price_admin.inner_batch_info.format(sellerStoreId=${seller_store_id})}
#    ${resp}    post on session    ${session}    ${url}    json=${data}    expected_status=${status}
#    [Return]    ${resp.json()}
#
#Ininitialize SKU Price Info
#    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
#    ...    ${origin_price}    ${price}    ${status}
#    ${resp}    Inner Batch SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
#    ...    ${currency}    ${origin_price}    ${price}    200

Add Price Rule
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${price}    ${start_time}    ${end_time}    ${refer_type}
    ...    ${refer_id}    ${status}    ${michaels_store_id}=-1
#    ${test_time}    deltatime.get_delta_timestamp
#    ${start_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${start_time}
#    ${end_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${end_time}
    &{item}    Create Dictionary    sku_number=${sku_number}    price=${price}    start_time=${start_time}
    ...    end_time=${end_time}    refer_type=${refer_type}    refer_id=${refer_id}    michaels_store_id=${michaels_store_id}
    ${data}    sku_price_rule_data    ${item}
    ${resp}    POST On Session    ${session}    ${price_rule_admin.price_rule.format(sellerStoreId=${seller_store_id})}
    ...    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}


Inner Batch SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}    ${michaelsStoreId}=-1
    ${data}    inner_batch_sku_price    skuNumber=${sku_number}    masterSkuNumber=${master_sku_number}
    ...    currency=${currency}    michaelsStoreId=${michaelsStoreId}    originPrice=${origin_price}    price=${price}
    ${url}    set variable    ${path.price_admin.inner_batch_info.format(sellerStoreId=${seller_store_id})}
    ${resp}    post on session    ${session}    ${url}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Ininitialize SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}    ${michaels_store_id}=-1
    ${resp}    Inner Batch SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    ${origin_price}    ${price}    200        ${michaels_store_id}
#
#Add Price Rule
#    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${price}    ${start_time}    ${end_time}    ${refer_type}
#    ...    ${refer_id}    ${status}    ${michaels_store_id}=-1
#    ${test_time}    deltatime.get_delta_timestamp
#    ${start_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${start_time}
#    ${end_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${end_time}
#    &{item}    Create Dictionary    sku_number=${sku_number}    price=${price}    start_time=${start_time}
#    ...    end_time= ${end_time}    refer_type=${refer_type}    refer_id=${refer_id}    michaels_store_id=${michaels_store_id}
#    ${data}    sku_price_rule_data    ${item}
#    ${resp}    POST On Session    ${session}    ${price_rule_admin.price_rule.format(sellerStoreId=${seller_store_id})}
#    ...    json=${data}    expected_status=${status}
#    [Return]    ${resp.json()}

Template Inner Batch SKU Price Info scenario origin is not empty
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}    &{assert}
    Ininitialize SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    100    80    200
    ${resp_bfore}    SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    200
    ${resp}    Inner Batch SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    ${origin_price}     ${price}   ${status}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings    ${resp}[${k}]   ${v}
    END
    ${resp_after}    SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    200
    ${origin_price_old}    Evaluate    float("%.2f"%${resp_bfore["data"]["originPrice"]})
    ${origin_price_new}    Evaluate    float("%.2f"%${resp_after["data"]["originPrice"]})
    ${price_old}    Evaluate    float("%.2f"%${resp_bfore["data"]["price"]} )
    ${price_new}    Evaluate    float("%.2f"%${resp_after["data"]["price"]})
    ${origin_price}    Evaluate    float("%.2f"%${origin_price})
    ${price}    Evaluate    float("%.2f"%${price})
    run keyword if    ${origin_price}<${price} and ${price}!=${price_old}
    ...    Should Be Equal    ${origin_price_old}    ${origin_price_new}
    ...    Should Be Equal    ${price_old}    ${price_new}
    ...    ELSE IF    ${origin_price}>=${price} and ${price}!=${price_old}
    ...    Should Be Equal    ${origin_price}    ${origin_price_new}
    ...    Should Be Equal    ${price}    ${price_new}
    ...    ELSE IF    (${origin_price}>=${price} or ${origin_price}<${price}) and ${price}==${price_old}
    ...    Should Be Equal    ${origin_price_old}    ${origin_price_new}
    ...    Should Be Equal    ${price_old}    ${price_new}

Template Inner Batch SKU Price Info scenario origin is empty
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}    &{assert}
    Ininitialize SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    100    80    200
    ${resp_bfore}    SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    200
    ${resp}    Inner Batch SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    ${origin_price}    ${price}   ${status}    &{assert}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings    ${resp}[${k}]   ${v}
    END
    ${resp_after}    SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    200
    ${origin_price_old}    Evaluate    float("%.2f"%${resp_bfore["data"]["originPrice"]})
    ${origin_price_new}    Evaluate    float("%.2f"%${resp_after["data"]["originPrice"]})
    ${price_old}    Evaluate    float("%.2f"%${resp_bfore["data"]["price"]} )
    ${price_new}    Evaluate    float("%.2f"%${resp_after["data"]["price"]})
    ${price}    Evaluate    float("%.2f"%${price})
#    run keyword if    ${price}<${price_old}
#    ...    Should Be Equal    ${price_old}    ${origin_price_new}
#    ...    Should Be Equal    ${price}    ${price_new}
#    ...    ELSE IF    ${price}==${price_old}
#    ...    Should Be Equal    ${origin_price_old}    ${origin_price_new}
#    ...    Should Be Equal    ${price_old}    ${price_new}
#    ...    ELSE IF    ${price}>${price_old}
#    ...    Should Be Equal    ${price}    ${origin_price_new}
#    ...    Should Be Equal    ${price}    ${price_new}
    Should Be Equal    ${origin_price_new}    ${price}
    Should Be Equal    ${price_new}    ${price}

Template Inner Batch SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}    &{assert}
    ${resp}    Inner Batch SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    ${origin_price}    ${price}   ${status}    &{assert}
    FOR    ${k}    ${v}    IN    &{assert}
        should be equal as strings    ${resp}[${k}]   ${v}
    END

Template Inner Batch SKU Price Info scenario multiple skuNumbers
    [Arguments]  ${session}    ${seller_store_id}    @{item}
    @{input_data}    inner_batch_sku_price2    ${item}
    @{old_originprice_and_price}    Create List
    @{new_originprice_and_price}    Create List

    #Ininitialize skuprice and append old skuprcie to @{old_originprice_and_price}
    FOR    ${i}    IN    @{input_data}
        ${masterSkuNumber}    Evaluate    ${i}.get("masterSkuNumber")
        ${skuNumber}    Evaluate    ${i}.get("skuNumber")
        Ininitialize Inner Batch SKU Price Info Multiple SkuNumbers    ${session}    ${seller_store_id}
        ...      ${masterSkuNumber}|${skuNumber}|USD|100|80
        ${resp}    SKU Price Info    ${session}    ${seller_store_id}    ${skuNumber}    200
        ${old_originPrice}    Evaluate    ${resp}.get("data").get("originPrice")
        ${old_price}    Evaluate    ${resp}.get("data").get("price")
        &{old_price_dict}    Create Dictionary    masterSkuNumber=${masterSkuNumber}    skuNumber=${skuNumber}    originPrice=${old_originPrice}
        ...    price=${old_price}
        Append To List    ${old_originprice_and_price}    ${old_price_dict}
    END

    #update skuprice
    Inner Batch SKU Price Info multiple skuNumbers    ${session}    ${seller_store_id}    @{item}

    #get new skuprice and append new skuprcie to @{new_originprice_and_price}
    FOR    ${i}    IN    @{input_data}
        ${masterSkuNumber}    Evaluate    ${i}.get("masterSkuNumber")
        ${skuNumber}    Evaluate    ${i}.get("skuNumber")
        ${resp}    SKU Price Info    ${session}    ${seller_store_id}    ${skuNumber}    200
        ${new_originPrice}    Evaluate    ${resp}.get("data").get("originPrice")
        ${new_price}    Evaluate    ${resp}.get("data").get("price")
        &{new_price_dict}    Create Dictionary    masterSkuNumber=${masterSkuNumber}    skuNumber=${skuNumber}    originPrice=${new_originPrice}
        ...    price=${new_price}
        Append To List    ${new_originprice_and_price}    ${new_price_dict}
    END

    #assert
    ${num}    Get Length    ${input_data}
    FOR    ${i}    IN RANGE   ${num}
        ${input_originPrice}    Evaluate    float(&{input_data[${i}]}.get("originPrice"))
        ${input_price}    Evaluate    float(&{input_data}[${i}].get("price"))
        ${old_origin_price}    Evaluate    float(&{old_originprice_and_price}[${i}].get("originPrice"))
        ${old_price}    Evaluate    float(&{old_originprice_and_price}[${i}].get("price"))
        ${new_origin_price}    Evaluate    float(&{new_originprice_and_price}[${i}].get("originPrice"))
        ${new_price}    Evaluate    float(&{new_originprice_and_price}[${i}].get("price"))
        IF    ${input_originPrice}<${input_price} and ${input_price}!=${old_price}
            Should Be Equal    ${old_origin_price}    ${new_origin_price}
            Should Be Equal    ${old_price}    ${new_price}
        ELSE IF    ${input_originPrice}>=${input_price} and ${input_price}!=${old_price}
            Should Be Equal    ${input_originPrice}    ${new_origin_price}
            Should Be Equal    ${input_price}    ${new_price}
        ELSE IF    ${input_price}==${old_price}
            Should Be Equal    ${old_origin_price}    ${new_origin_price}
            Should Be Equal    ${old_price}    ${new_price}
        END
    END

Inner Batch SKU Price Info multiple skuNumbers
    [Arguments]    ${session}    ${seller_store_id}    @{item}
    ${data}    inner_batch_sku_price2    ${item}
    ${url}    set variable    ${path.price_admin.inner_batch_info.format(sellerStoreId=${seller_store_id})}
    ${resp}    POST On Session    ${session}    url=${url}    json=${data}
    [Return]    ${resp.json()}

Ininitialize Inner Batch SKU Price Info multiple skuNumbers
    [Arguments]  ${session}    ${seller_store_id}    @{item}
    Inner Batch SKU Price Info Multiple SkuNumbers    ${session}    ${seller_store_id}    @{item}
