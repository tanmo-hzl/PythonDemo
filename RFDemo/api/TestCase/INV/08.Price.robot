*** Settings ***
Documentation    Price Controller
...    1.GET/price/sku
...    2.GET/price/master-sku
...    3.POST/price/sku-michaelsStoreId
Library    RequestsLibrary
Resource    ../../INVconfig.robot
Resource    _common.robot
Library    ../../Libraries/INV/price.py
Library    ../../Libraries/INV/deltatime.py
Variables    ../../Libraries/INV/SKU.py
#Library    ../Data/data_buyer.py
Suite Setup  User and Admin Sign In

*** Variables ***
${sku_number0}    invtest1
${sku_number1}    10553707
${sku_number2}    glauto001
${sku_number3}    106199900001
${master_sku_number0}    glauto003
${master_sku_number1}    glauto004
${master_sku_number2}    glauto004

*** Test Cases ***
#GET/price/sku
Test Template Get Price Sku
    [Documentation]    1.one sku 2.multiple skus 3.unlogin get price success
    [Template]    Template Get Price Sku Positive
    200    buyer    ${sku_number0}    skuNumber0=${sku_number0}
    200    buyer    ${sku_number3}    skuNumber0=${sku_number3}
    200    buyer    ${sku_number0}    ${sku_number1}    skuNumber0=${sku_number0}    skuNumber1=${sku_number1}
    200    unlogin    ${sku_number0}    skuNumber0=${sku_number0}

Test Template Get Price Sku From Price Table
    [Documentation]  1.channel 2 sku 2.channel 3 sku 3.multiple sku 4.sku not exist in mongdb online_product table
    [Template]  Template Get Price Sku From Price Table
    200    buyer    ${SKUS.channel2}[0]
    200    buyer    ${SKUS.channel3}[0]
    200    buyer    ${SKUS.mahattan}[0]
    200    buyer    ${SKUS.channel2}[0]   ${SKUS.mahattan}[0]
    200    buyer    ${sku_number0}

Test Template Get Price Sku From Price Rule Table
    [Documentation]    1.one sku:when refer_type=1 and prcierule.price<price.cur_price,as the result,promoprice=prcierule.price,
    ...    price=price.cur_price,originprice=price.origin_price
    ...    2.multiple skus:when refer_type=1 and prcierule.price<price.cur_price,as the result,promoprice=prcierule.price,
    ...    price=price.cur_price,originprice=price.origin_price
    ...    3.one sku:when refer_type!=1 and prcierule.price<price.cur_price,as the result,promoprice=null,price=prcierule.price,
    ...    originprice=price.cur_price
    ...    4.multiple skus:when refer_type!=1 and prcierule.price<price.cur_price,as the result,promoprice=null,price=prcierule.price,
    ...    originprice=price.cur_price
    ...    5.one sku:when prcierule.price=price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    ...    6.multiple skus:when prcierule.price=price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    ...    7.one sku:when prcierule.price>price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    ...    8.multiple skus:when prcierule.price>price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    [Template]    Template Get Price Sku From Price Rule Table
    200    buyer    1    13.14    ${master_sku_number0}
    200    buyer    1    13.14    ${master_sku_number0}    ${master_sku_number2}
    200    buyer    0    13.14    ${master_sku_number0}
    200    buyer    0    13.14    ${master_sku_number0}    ${master_sku_number2}
    200    buyer    0    80    ${master_sku_number0}
    200    buyer    1    80   ${master_sku_number0}    ${master_sku_number2}
    200    buyer    1    90    ${master_sku_number0}
    200    buyer    0    90    ${master_sku_number0}    ${master_sku_number2}

#GET/price/master-sku
Test Template Get Price Master Sku
    [Documentation]    1.one mastersku 2.multiple masterskus 3.unlogin get price success
    [Template]    Template Get Price Master Sku Positive
    200    buyer    ${master_sku_number0}    skuNumber0=${master_sku_number0}
    200    buyer    ${master_sku_number0}    ${master_sku_number1}    skuNumber0=${master_sku_number0}   skuNumber1=${master_sku_number1}
    200    unlogin    ${master_sku_number0}    skuNumber0=${master_sku_number0}

Test Template Get Price Master Sku From Price Table
    [Documentation]    1.one mastersku get price form price table
    ...    2.multiple masterskus get sku from price table
    [Template]    Template Get Price Master Sku From Price Table
    200    buyer    ${master_sku_number0}
    200    buyer    ${master_sku_number0}    ${master_sku_number2}

Test Template Get Price Master Sku From Price Rule Table
    [Documentation]    1.one sku:when refer_type=1 and prcierule.price<price.cur_price,as the result,promoprice=prcierule.price,
    ...    price=price.cur_price,originprice=price.origin_price
    ...    2.multiple skus:when refer_type=1 and prcierule.price<price.cur_price,as the result,promoprice=prcierule.price,
    ...    price=price.cur_price,originprice=price.origin_price
    ...    3.one sku:when refer_type!=1 and prcierule.price<price.cur_price,as the result,promoprice=null,price=prcierule.price,
    ...    originprice=price.cur_price
    ...    4.multiple skus:when refer_type!=1 and prcierule.price<price.cur_price,as the result,promoprice=null,price=prcierule.price,
    ...    originprice=price.cur_price
    ...    5.one sku:when prcierule.price=price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    ...    6.multiple skus:when prcierule.price=price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    ...    7.one sku:when prcierule.price>price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    ...    8.multiple skus:when prcierule.price>price.cur_price,as the result,promoprice=null,price=price.cur_price,originprice=price.origin_price
    [Template]    Template Get Price Master Sku From Price Rule Table
    200    buyer    1    13.14    ${master_sku_number0}
    200    buyer    1    13.14    ${master_sku_number0}    ${master_sku_number2}
    200    buyer    0    13.14    ${master_sku_number0}
    200    buyer    0    13.14    ${master_sku_number0}    ${master_sku_number2}
    200    buyer    0    80    ${master_sku_number0}
    200    buyer    1    80   ${master_sku_number0}    ${master_sku_number2}
    200    buyer    1    90    ${master_sku_number0}
    200    buyer    0    90    ${master_sku_number0}    ${master_sku_number2}

#POST/price/sku-michaelsStoreId
Test Template Get Price Sku MichaelsStoreId Positive
    [Template]    Template Get Price Sku MichaelsStoreId Positive
    200    unlogin    6711    10162808    code=200    message=success


Test Template Get Price Sku MichaelsStoreId From Price Table
    [Template]    Template Get Price Sku MichaelsStoreId From Price Table
    200    unlogin    -1    testms001
#    200    unlogin    2021001    testms001

#Test Template Get Price Sku MichaelsStoreId Different Michaelsstoreid Have Different Redis Key For The Same Sku
#    [Template]    Template Get Price Sku MichaelsStoreId Different Michaelsstoreid Have Different Redis Key For The Same Sku
#    200    unlogin    testrk001
#    200    unlogin    testrk002    testrk003

#Test Template Get Price Sku MichaelsStoreId From Price Rule Table When Sku Have Only One MichaelsStoreId
#    [Template]    Template Get Price Sku MichaelsStoreId From Price Rule Table When Sku Have Only One MichaelsStoreId
#    200    unlogin    1    13.14    2021001    testms002
#    200    unlogin    1    13.14    -1    testms003
#    200    unlogin    1    80    2021001    testms004
#    200    unlogin    1    80    -1    testms005
#    200    unlogin    1    90    2021001    testms006
#    200    unlogin    1    90    -1    testms007
#    200    unlogin    0    13.14    2021001    testms008
#    200    unlogin    0    13.14    -1    testms009
#    200    unlogin    0    80    2021001    testms010
#    200    unlogin    0    80    -1    testms011
#    200    unlogin    0    80.5    2021001    testms012
#    200    unlogin    0    80.5    -1    testms013
#    200    buyer   1    13.14    2021001    testms014

#Test Template Get Price Sku MichaelsStoreId From Price Rule Table When Sku Have Multiple MichaelsStoreIds
#    [Setup]    User and Admin Sign In
#    [Template]    Template Get Price Sku MichaelsStoreId From Price Rule Table When Sku Have Multiple MichaelsStoreIds
#    200    unlogin    1    13.14    131.4    2021001    gltestms001
#    200    unlogin    1    13.14    131.4    -1    gltestms002
#    200    unlogin    1    80    800    2021001    gltestms003
#    200    unlogin    1    80    800    -1    gltestms004
#    200    unlogin    1    90    900    2021001    gltestms005
#    200    unlogin    1    90    900    -1    gltestms006
#    200    unlogin    0    13.14    131.4    2021001    gltestms007
#    200    unlogin    0    13.14    131.4    -1    gltestms008
#    200    unlogin    0    80    800    2021001    gltestms009
#    200    unlogin    0    80    800    -1    gltestms010
#    200    unlogin    0    90    900    2021001    gltestms011
#    200    unlogin    0    90    900    -1    gltestms012
#    200    unlogin    1    13.14    131.4    2021001    gltestms013    gltestms014
#    200    unlogin    1    13.14    131.4    -1    gltestms015    gltestms016
#    200    buyer    1    13.14    131.4    2021001    gltestms017

#Test Template Get Price Sku MichaelsStoreId When Michaelsstoreid Is Null
#    [Template]    Template Get Price Sku MichaelsStoreId From Price Rule Table When Sku Have Multiple MichaelsStoreIds
#    200    unlogin    1    13.14    131.4    ${empty}    gltestms018
#    200    unlogin    1    13.14    131.4    ${empty}    gltestms019    gltestms020

*** Keywords ***
User and Admin Sign In
    User Sign In    buyer    ${buyer_user}
    User Sign In    admin    ${admin_user}    admin
    create session    unlogin    ${host}     headers=${default_headers}     verify=True

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

Template Get Price Sku Positive
    [Arguments]    ${status}    ${session}    @{skuNumber}    &{assert}
    ${resp}    Get Price Sku    ${status}    ${session}    @{skuNumber}
    ${num}    Get Length    ${resp}
    IF    @{resp}!=[]
        FOR    ${i}    IN RANGE    ${num}
            Log Many    ${resp}[${i}][skuNumber]    ${assert}[skuNumber${i}]
            Should Be Equal As Strings    ${resp}[${i}][skuNumber]    ${assert}[skuNumber${i}]
        END
    ELSE
        Fail    Response Is Null
    END

Template Get Price Sku From Price Table
    [Arguments]    ${status}    ${session}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        ${resp}    Get Price Sku    ${status}    ${session}    ${sku}
        IF    ${resp} != []
            ${sellerStoreId}    Evaluate    ${resp}[0].get("sellerStoreId")
            Ininitialize SKU Price Info    ${session}    ${sellerStoreId}    ${sku}    ${sku}    USD   100    80    200
        ELSE
            Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200
        END
    END
    ${resp}    Get Price Sku    ${status}    ${session}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        IF    ${i}[sellerStoreId]==0
            ${price}    Evaluate    float(${i}[price])
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price_db}    Evaluate    float(80)
            ${originPrice_db}    Evaluate    float(100)
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${originPrice}    ${originPrice_db}
        ELSE
           ${price}    Evaluate    float(${i}[price])
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price_db}    Evaluate    float(80)
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${originPrice}    ${price_db}
        END
    END

Template Get Price Sku From Price Rule Table
    [Arguments]    ${status}    ${session}    ${refer_type}    ${price_rule_price}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        ${resp}    Get Price Sku    ${status}    ${session}    ${sku}
        IF    ${resp} != []
            ${sellerStoreId}    Evaluate    ${resp}[0].get("sellerStoreId")
            Ininitialize SKU Price Info    ${session}    ${sellerStoreId}    ${sku}    ${sku}    USD   100    80    200
            Add Price Rule    admin    ${sellerStoreId}      ${sku}    ${price_rule_price}    10    30    refer_type=${refer_type}    refer_id=1    status=200
        ELSE
            Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200
            Add Price Rule    admin    0      ${sku}    ${price_rule_price}    10    30    refer_type=${refer_type}    refer_id=1    status=200
        END
    END
    ${resp}    Get Price Sku   ${status}    ${session}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        ${originPrice}    Evaluate    float(${i}[originPrice])
        ${price}    Evaluate    float(${i}[price])
        ${origin_price_db}    Evaluate    float(100)
        ${price_db}    Evaluate    float(80)
        ${price_rule_db}    Evaluate    float(${price_rule_price})
    END
    FOR    ${i}    IN    @{resp}
        IF    ${i}[sellerStoreId]==0
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        ELSE
            Should Be Equal    ${originPrice}    ${price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    END
    sleep    15
    ${resp}    Get Price Sku    ${status}    ${session}    @{skuNumber}
    IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
        FOR    ${i}    IN    @{resp}
            IF    ${i}[sellerStoreId]==0
                ${originPrice}    Evaluate    float(${i}[originPrice])
                ${price}    Evaluate    float(${i}[price])
                Should Be Equal    ${originPrice}    ${origin_price_db}
                Should Be Equal    ${price}    ${price_db}
                ${promoPrice}    Evaluate    float(${i}[promoPrice])
                Should Be Equal    ${promoPrice}    ${price_rule_db}
            ELSE
                ${originPrice}    Evaluate    float(${i}[originPrice])
                ${price}    Evaluate    float(${i}[price])
                Should Be Equal    ${originPrice}    ${price_db}
                Should Be Equal    ${price}    ${price_db}
                ${promoPrice}    Evaluate    float(${i}[promoPrice])
                Should Be Equal    ${promoPrice}    ${price_rule_db}
            END
        END
    ELSE IF    ${refer_type}!=1 and ${price_rule_db}<${price_db}
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${price_db}
            Should Be Equal    ${price}    ${price_rule_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    ELSE
        FOR    ${i}    IN    @{resp}
            IF    ${i}[sellerStoreId]==0
                Should Be Equal    ${originPrice}    ${origin_price_db}
                Should Be Equal    ${price}    ${price_db}
                Should Be Equal    ${i}[promoPrice]    ${null}
            ELSE
                Should Be Equal    ${originPrice}    ${price_db}
                Should Be Equal    ${price}    ${price_db}
                Should Be Equal    ${i}[promoPrice]    ${null}
            END
        END
    END
    sleep    20
    ${resp}    Get Price Sku    ${status}    ${session}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        IF    ${i}[sellerStoreId]==0
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        ELSE
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    END

Get Price Master Sku
    [Arguments]    ${status}    ${session}    @{master_skuNumber}
    ${params}    price_master_sku    ${master_skuNumber}
    ${resp}    GET On Session    ${session}    ${path.price.mastersku}    params=${params}    expected_status=${status}
    [Return]    ${resp.json()}

Template Get Price Master Sku Positive
    [Arguments]    ${status}    ${session}    @{skuNumber}    &{assert}
    ${resp}    Get Price Master Sku    ${status}    ${session}    @{skuNumber}
    ${num}    Get Length    ${resp}
    IF    @{resp}!=[]
        FOR    ${i}    IN RANGE    ${num}
            Log Many    ${resp}[${i}][skuNumber]    ${assert}[skuNumber${i}]
            Should Be Equal As Strings    ${resp}[${i}][skuNumber]    ${assert}[skuNumber${i}]
        END
    ELSE
        Fail    Response Is Null
    END

Template Get Price Master Sku From Price Table
    [Arguments]    ${status}    ${session}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        ${resp}    Get Price Sku    ${status}    ${session}    ${sku}
        IF    ${resp} != []
            ${sellerStoreId}    Evaluate    ${resp}[0].get("sellerStoreId")
            Ininitialize SKU Price Info    ${session}    ${sellerStoreId}    ${sku}    ${sku}    USD   100    80    200
        ELSE
            Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200
        END
    END
    ${resp}    Get Price Master Sku    ${status}    ${session}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        IF    ${i}[sellerStoreId]==0
            ${price}    Evaluate    float(${i}[price])
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price_db}    Evaluate    float(80)
            ${originPrice_db}    Evaluate    float(100)
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${originPrice}    ${originPrice_db}
        ELSE
           ${price}    Evaluate    float(${i}[price])
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price_db}    Evaluate    float(80)
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${originPrice}    ${price_db}
        END
    END

Template Get Price Master Sku From Price Rule Table
    [Arguments]    ${status}    ${session}    ${refer_type}    ${price_rule_price}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        ${resp}    Get Price Sku    ${status}    ${session}    ${sku}
        IF    ${resp} != []
            ${sellerStoreId}    Evaluate    ${resp}[0].get("sellerStoreId")
            Ininitialize SKU Price Info    ${session}    ${sellerStoreId}    ${sku}    ${sku}    USD   100    80    200
            Add Price Rule    admin    ${sellerStoreId}      ${sku}    ${price_rule_price}    10    30    refer_type=${refer_type}    refer_id=1    status=200
        ELSE
            Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200
            Add Price Rule    admin    0      ${sku}    ${price_rule_price}    10    30    refer_type=${refer_type}    refer_id=1    status=200
        END
    END
    ${resp}    Get Price Master Sku    ${status}    ${session}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        ${originPrice}    Evaluate    float(${i}[originPrice])
        ${price}    Evaluate    float(${i}[price])
        ${origin_price_db}    Evaluate    float(100)
        ${price_db}    Evaluate    float(80)
        ${price_rule_db}    Evaluate    float(${price_rule_price})
    END
    FOR    ${i}    IN    @{resp}
        IF    ${i}[sellerStoreId]==0
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        ELSE
            Should Be Equal    ${originPrice}    ${price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    END
    sleep    15
    ${resp}    Get Price Master Sku    ${status}    ${session}    @{skuNumber}
    IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
        FOR    ${i}    IN    @{resp}
            IF    ${i}[sellerStoreId]==0
                ${originPrice}    Evaluate    float(${i}[originPrice])
                ${price}    Evaluate    float(${i}[price])
                Should Be Equal    ${originPrice}    ${origin_price_db}
                Should Be Equal    ${price}    ${price_db}
                ${promoPrice}    Evaluate    float(${i}[promoPrice])
                Should Be Equal    ${promoPrice}    ${price_rule_db}
            ELSE
                ${originPrice}    Evaluate    float(${i}[originPrice])
                ${price}    Evaluate    float(${i}[price])
                Should Be Equal    ${originPrice}    ${price_db}
                Should Be Equal    ${price}    ${price_db}
                ${promoPrice}    Evaluate    float(${i}[promoPrice])
                Should Be Equal    ${promoPrice}    ${price_rule_db}
            END
        END
    ELSE IF    ${refer_type}!=1 and ${price_rule_db}<${price_db}
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${price_db}
            Should Be Equal    ${price}    ${price_rule_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    ELSE
        FOR    ${i}    IN    @{resp}
            IF    ${i}[sellerStoreId]==0
                Should Be Equal    ${originPrice}    ${origin_price_db}
                Should Be Equal    ${price}    ${price_db}
                Should Be Equal    ${i}[promoPrice]    ${null}
            ELSE
                Should Be Equal    ${originPrice}    ${price_db}
                Should Be Equal    ${price}    ${price_db}
                Should Be Equal    ${i}[promoPrice]    ${null}
            END
        END
    END
    sleep    20
    ${resp}    Get Price Master Sku    ${status}    ${session}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        IF    ${i}[sellerStoreId]==0
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        ELSE
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    END

#POST/price/sku-michaelsStoreId
Get Price Sku MichaelsStoreId
    [Arguments]    ${status}    ${session}    ${michaelsStoreId}    @{skuNumber}
    ${data}    price_sku_michaelsstoreid    ${michaelsStoreId}    ${skuNumber}
    ${resp}    POST On Session    ${session}    ${price.sku_michaelsstoreid}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Template Get Price Sku MichaelsStoreId Positive
    [Arguments]    ${status}    ${session}    ${michaelsStoreId}    @{skuNumber}    &{assert}
    ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaelsStoreId}    @{skuNumber}
    ${num}    Get Length    ${resp}
    IF    @{resp}!=[]
        FOR    ${i}    IN RANGE    ${num}
            Should Contain    ${skuNumber}    ${resp}[${i}][skuNumber]
        END
    ELSE
        Fail    Response Is Null
    END

Template Get Price Sku MichaelsStoreId From Price Table
    [Arguments]    ${status}    ${session}    ${michaelsStoreId}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200    ${michaelsStoreId}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   90    70    200    -1
    END
    ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaelsStoreId}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        ${price}    Evaluate    float(${i}[price])
        ${price_db_80}    Evaluate    float(80)
        ${price_db_70}    Evaluate    float(70)
        IF    ${michaelsStoreId}==-1
            Should Be Equal    ${price}    ${price_db_70}
        ELSE
            Should Be Equal    ${price}    ${price_db_80}
        END
    END

Template Get Price Sku MichaelsStoreId Different Michaelsstoreid Have Different Redis Key For The Same Sku
    [Arguments]    ${status}    ${session}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200    2021001
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   90    70    200    -1
        ${resp_redis_before}    Get Or Delete Price Cache From Redis    admin1      ${sku}    get    -1
        ${resp_redis_2021001_before}    Get Or Delete Price Cache From Redis    admin1      ${sku}    get    2021001
        Should Be Equal As Strings    ${resp_redis_before}[content]    ${None}
        Should Be Equal As Strings    ${resp_redis_2021001_before}[content]    ${None}
    END
        ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    -1    @{skuNumber}
        ${resp_2021001}    Get Price Sku MichaelsStoreId    ${status}    ${session}    2021001    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        ${resp_redis}    Get Or Delete Price Cache From Redis    admin1      ${sku}    get    -1
        ${resp_redis_2021001}    Get Or Delete Price Cache From Redis    admin1      ${sku}    get    2021001
        Should Be Equal As Strings    ${resp_redis}[content][price]    70
        Should Be Equal As Strings    ${resp_redis_2021001}[content][price]    80
    END
    ${resp_sku}    Get Price Sku    200    unlogin    @{skuNumber}
    ${num}    Get Length    ${resp_sku}
    FOR    ${i}    IN RANGE    ${num}
        Should Be Equal As Strings    ${resp_sku}[${i}][price]    70
    END


Template Get Price Sku MichaelsStoreId From Price Rule Table When Sku Have Only One MichaelsStoreId
    [Arguments]    ${status}    ${session}    ${refer_type}    ${price_rule_price}    ${michaels_store_id}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200    ${michaelsStoreId}
        Add Price Rule    admin    0      ${sku}    ${price_rule_price}    5    12    refer_type=${refer_type}    refer_id=1
        ...    status=200    michaels_store_id=${michaels_store_id}
    END
    ${resp}    Get Price Sku MichaelsStoreId   ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        ${originPrice}    Evaluate    float(${i}[originPrice])
        ${price}    Evaluate    float(${i}[price])
        ${origin_price_db}    Evaluate    float(100)
        ${price_db}    Evaluate    float(80)
        ${price_rule_db}    Evaluate    float(${price_rule_price})
    END
    FOR    ${i}    IN    @{resp}
        Should Be Equal    ${originPrice}    ${origin_price_db}
        Should Be Equal    ${price}    ${price_db}
        Should Be Equal    ${i}[promoPrice]    ${null}
    END
    sleep    6
    ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
    IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            ${promoPrice}    Evaluate    float(${i}[promoPrice])
            Should Be Equal    ${promoPrice}    ${price_rule_db}
        END
    ELSE IF    ${refer_type}!=1 and ${price_rule_db}<${price_db}
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${price_db}
            Should Be Equal    ${price}    ${price_rule_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    ELSE
        FOR    ${i}    IN    @{resp}
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    END
    sleep    6
    ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
    FOR    ${i}    IN    @{resp}
        ${originPrice}    Evaluate    float(${i}[originPrice])
        ${price}    Evaluate    float(${i}[price])
        Should Be Equal    ${originPrice}    ${origin_price_db}
        Should Be Equal    ${price}    ${price_db}
        Should Be Equal    ${i}[promoPrice]    ${null}
    END

Template Get Price Sku MichaelsStoreId From Price Rule Table When Sku Have Multiple MichaelsStoreIds
    [Arguments]    ${status}    ${session}    ${refer_type}    ${price_rule_price_2021001}    ${price_rule_price}
    ...    ${michaels_store_id}    @{skuNumber}
    FOR    ${sku}    IN    @{skuNumber}
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   100    80    200    2021001
        Ininitialize SKU Price Info    ${session}    0    ${sku}    ${sku}    USD   1000    800    200    -1
        Add Price Rule    admin    0      ${sku}    ${price_rule_price_2021001}    15    30    refer_type=${refer_type}    refer_id=1
        ...    status=200    michaels_store_id=2021001
        Add Price Rule    admin    0      ${sku}    ${price_rule_price}    15    30    refer_type=${refer_type}    refer_id=1
        ...    status=200    michaels_store_id=-1
    END
    ${resp}    Get Price Sku MichaelsStoreId   ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
    IF    "${michaels_store_id}"=="-1" or "${michaels_store_id}"==""
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            ${origin_price_db}    Evaluate    float(1000)
            ${price_db}    Evaluate    float(800)
            ${price_rule_db}    Evaluate    float(${price_rule_price})
        END
        FOR    ${i}    IN    @{resp}
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
        sleep    15
        ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
        IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
            FOR    ${i}    IN    @{resp}
                    ${originPrice}    Evaluate    float(${i}[originPrice])
                    ${price}    Evaluate    float(${i}[price])
                    Should Be Equal    ${originPrice}    ${origin_price_db}
                    Should Be Equal    ${price}    ${price_db}
                    ${promoPrice}    Evaluate    float(${i}[promoPrice])
                    Should Be Equal    ${promoPrice}    ${price_rule_db}
             END
        ELSE IF    ${refer_type}!=1 and ${price_rule_db}<${price_db}
                FOR    ${i}    IN    @{resp}
                    ${originPrice}    Evaluate    float(${i}[originPrice])
                    ${price}    Evaluate    float(${i}[price])
                    Should Be Equal    ${originPrice}    ${price_db}
                    Should Be Equal    ${price}    ${price_rule_db}
                    Should Be Equal    ${i}[promoPrice]    ${null}
                END
        ELSE
                FOR    ${i}    IN    @{resp}
                    Should Be Equal    ${originPrice}    ${origin_price_db}
                    Should Be Equal    ${price}    ${price_db}
                    Should Be Equal    ${i}[promoPrice]    ${null}
                END
        END
        sleep    15
        ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    ELSE
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            ${origin_price_db}    Evaluate    float(100)
            ${price_db}    Evaluate    float(80)
            ${price_rule_db}    Evaluate    float(${price_rule_price_2021001})
        END
        FOR    ${i}    IN    @{resp}
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
        sleep    15
        ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
        IF    ${refer_type}==1 and ${price_rule_db}<${price_db}
            FOR    ${i}    IN    @{resp}
                ${originPrice}    Evaluate    float(${i}[originPrice])
                ${price}    Evaluate    float(${i}[price])
                Should Be Equal    ${originPrice}    ${origin_price_db}
                Should Be Equal    ${price}    ${price_db}
                ${promoPrice}    Evaluate    float(${i}[promoPrice])
                Should Be Equal    ${promoPrice}    ${price_rule_db}
            END
        ELSE IF    ${refer_type}!=1 and ${price_rule_db}<${price_db}
            FOR    ${i}    IN    @{resp}
                ${originPrice}    Evaluate    float(${i}[originPrice])
                ${price}    Evaluate    float(${i}[price])
                Should Be Equal    ${originPrice}    ${price_db}
                Should Be Equal    ${price}    ${price_rule_db}
                Should Be Equal    ${i}[promoPrice]    ${null}
            END
        ELSE
            FOR    ${i}    IN    @{resp}
                Should Be Equal    ${originPrice}    ${origin_price_db}
                Should Be Equal    ${price}    ${price_db}
                Should Be Equal    ${i}[promoPrice]    ${null}
            END
        END
        sleep    15
        ${resp}    Get Price Sku MichaelsStoreId    ${status}    ${session}    ${michaels_store_id}    @{skuNumber}
        FOR    ${i}    IN    @{resp}
            ${originPrice}    Evaluate    float(${i}[originPrice])
            ${price}    Evaluate    float(${i}[price])
            Should Be Equal    ${originPrice}    ${origin_price_db}
            Should Be Equal    ${price}    ${price_db}
            Should Be Equal    ${i}[promoPrice]    ${null}
        END
    END
