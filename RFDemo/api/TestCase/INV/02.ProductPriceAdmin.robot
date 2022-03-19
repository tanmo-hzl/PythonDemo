*** Settings ***
Documentation    admin control sku price
...    1.GET/price-admin/{sellerStoreId}/sku-price-info
...    2.POST/price-admin/{sellerStoreId}/sku-price-info
...    3.POST/price-admin/{sellerStoreId}/batch-sku-price-info
...    4.POST/price/manage/sku-price-info
...    5.POST/price/manage/price-trends-info
Library    RequestsLibrary
Resource    ../../INVconfig.robot
Resource    _common.robot
Library    ../../Libraries/INV/price.py
Library    ../../Libraries/INV/deltatime.py
Suite Setup  User and Admin Sign In

*** Variables ***
${seller_store_id}    5167290306466332672
${sku_number}    5170356191561129985
${sku_number1}    106199900001
${sku_number_channel3}    100037
${omni_Sku_Number2}    10442631
${omni_Sku_Number_1056}    10597168

*** Test Cases ***
#GET/price-admin/{sellerStoreId}/sku-price-info
Test Get sku price info possive
  [Template]  Template SKU Price Info Positive
  ${seller_store_id}    ${sku_number}    sellerStoreId=${seller_store_id}   skuNumber=${sku_number}
#  0    ${sku_number}    sellerStoreId=0   skuNumber=${sku_number}


Test Get sku price info Negitive
  [Template]  Template SKU Price Info Negitive
  admin    5167290306466332671    ${sku_number}   400   code=MCU_13000
  admin    ${seller_store_id}    121212121    400    code=MCU_13000
  unlogin  ${seller_store_id}    ${sku_number}    401

#Test Template SKU Price Info Can Only Get Online Sku Price
#    [Template]    Template SKU Price Info Can Only Get Online Sku Price
#    admin    0    priceinfo001
#    admin    10    priceinfo002

#POST/price-admin/{sellerStoreId}/sku-price-info
Test Template Add price info
    [Documentation]    1.add price info:input michealStoreId is null,price.micheals_store_id default value is -1
    ...    1.add price info:input michealStoreId not null
    [Template]    Template Add price info
    admin    0    ${EMPTY}    addprice    80    100    200
    admin    10    -1    addprice    80    100    200

Test Update price info positive
  [Documentation]    1|OriginPrice not preach,If price< database price, originPrice updates to the original database price
  ...        2|OriginPrice = database price, originPrice is not updated
  ...        3|OriginPrice not passed, parameter price>The database price, originPrice is updated to the price of the parameter passed
  ...        4|The ginseng originPrice<Passing price, passing price! = database price, originPrice, and price are updated to the price of the parameter passed
  ...        5|OriginPrice = originPrice, originPrice! = database price, originPrice, and price updates
  ...        6|Reference originprice > reference price, reference price= Database price, originprice and price update
  ...        7|Transfer parameter originprice > transfer parameter price, transfer parameter price = database price, originprice update
  ...        8|Transfer parameter originprice = transfer parameter price, transfer parameter price = database price, originprice update
  ...        9|Transfer parameter originprice < transfer parameter price, transfer parameter price = database price, originprice is not updated
  [Template]  Template Update price info positive
  4    ${null}  200
  5    ${null}  200
  8    ${null}  200
  8    6  400
  9    9  200
  8    9  200
  5    6  200
  5    5  200
  5    3  400

Test Update price info negitive
    [Template]  Template Update price info negitive
    buyer  ${sku_number}  2.5  2.5  400
    unlogin  ${sku_number}  2.5  2.5  401

#POST/price-admin/{sellerStoreId}/batch-sku-price-info
Test Batch Update price info positive
  [Documentation]    1|OriginPrice not preach,If price< database price, originPrice updates to the original database price
  ...        2|OriginPrice = database price, originPrice is not updated
  ...        3|OriginPrice not passed, parameter price>The database price, originPrice is updated to the price of the parameter passed
  ...        4|The ginseng originPrice<Passing price, passing price! = database price, originPrice, and price are updated to the price of the parameter passed
  ...        5|OriginPrice = originPrice, originPrice! = database price, originPrice, and price updates
  ...        6|Reference originprice > reference price, reference price= Database price, originprice and price update
  ...        7|Transfer parameter originprice > transfer parameter price, transfer parameter price = database price, originprice update
  ...        8|Transfer parameter originprice = transfer parameter price, transfer parameter price = database price, originprice update
  ...        9|Transfer parameter originprice < transfer parameter price, transfer parameter price = database price, originprice is not updated
  [Template]  Template Batch Update price info positive
  200  ${seller_store_id}  1|2|${EMPTY}|2    2|2|${EMPTY}|3
  200  ${seller_store_id}  1|2|${EMPTY}|5  2|2|${EMPTY}|6
  200  ${seller_store_id}  1|2|${EMPTY}|6.5   2|2|${EMPTY}|5
  400  ${seller_store_id}  1|2|1|1.5   2|2|1|2
  200  ${seller_store_id}  1|2|2.5|2.5    2|2|5|5
  200  ${seller_store_id}  1|2|3|1.5    2|2|4|1.5
  200  ${seller_store_id}  1|2|6|5    2|2|7|5
#  400  ${seller_store_id}  2|2|2|2.5    1|2|5|5
  400  ${seller_store_id}  1|2|1.3|5    2|2|2|5

Test Batch Update price info negitive
  [Template]  Template Batch Update price info negitive
  buyer  ${seller_store_id}  400  1|2|2.5|2.5  2|2|2.5|2.5
  admin  5167290306466332671  400  1|2|2.5|1.3  2|2|2.5|1.3  code=MCU_13002
  unlogin  ${seller_store_id}  401  1|2|2.5|2.5  2|2|2.5|2.5

#POST/price/manage/sku-price-info
#Test Template Admin Manage Sku Price Info When Sku Number Is Null
#    [Template]    Template Admin Manage Sku Price Info When Sku Number Is Null
#    200    admin    1    10    code=200   message=Succeeded
#    200    admin    2    5    code=200   message=Succeeded
#    401    unlogin    1    10

#Test Template Admin Manage Sku Price Info When Sku Number Is Not Null
#    [Template]    Template Admin Manage Sku Price Info When Sku Number Is Not Null
#    200    admin    1    10    ${sku_number_channel3}    code=200   message=Succeeded
#    200    admin    1    10    ${sku_number_channel3}    ${sku_number}    ${omni_Sku_Number_1056}    ${omni_Sku_Number2}
#    ...    code=200   message=Succeeded

#Test Template Admin Manage Sku Price Info Can Only Get Online Sku Price
#    [Template]    Template Admin Manage Sku Price Info Can Only Get Online Sku Price
#    admin    0    managesku001

#POST/price/manage/price-trends-info
Test Template Admin Manage Price Trends Info
    [Template]    Template Admin Manage Price Trends Info
    200    admin    D376178S    -1000    10    code=200
    401    unlogin    D376178S    -1000    10

Test Template Admin Manage Price Trends Info Which Price Log Is Null
    [Template]    Template Admin Manage Price Trends Info Which Price Log Is Null
    200    admin    D376178S    1    10    code=200

*** Keywords ***
User and Admin Sign In
    User Sign In    buyer    ${buyer_user}
    User Sign In    admin    ${admin_user}    admin
    Create Session    unlogin    ${host}   headers=${default_headers}

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
    [Arguments]    ${session}    ${sellerstore_id}    ${sku_num}    ${status}
    ${params}    create dictionary    skuNumber=${sku_num}
    ${url}    Set Variable  ${path.price_admin.single_info.format(sellerStoreId=${sellerstore_id})}
    ${resp}    get on session    ${session}    ${url}    params=${params}    expected_status=${status}
    [Return]    ${resp.json()}

Template SKU Price Info Can Only Get Online Sku Price
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD
    ...    100    80    200    -1
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD
    ...    111.11    88.88    200    2021001
    ${resp}    SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    200
    Should Be Equal As Strings    ${resp}[data][michaelsStoreId]    -1
    Should Be Equal As Strings    ${resp}[data][originPrice]    100
    Should Be Equal As Strings    ${resp}[data][price]    80

Get product price info
    [Arguments]  ${session}    ${sellerstore_id}    ${mastersku_num}
    ${params}    Create Dictionary  masterSkuNumber=${mastersku_num}
    ${url}    Set Variable  ${path.price_admin.info_by_store.format(sellerStoreId=${sellerstore_id})}
    ${resp}    GET On Session  ${session}    ${url}    params=${params}
    [Return]  ${resp.json()['data']}

Batch Update Price Info
    [Arguments]    ${session}   ${sellerstore_id}    ${status}    @{item_info}
    ${data}    batch_sku_price_info    ${item_info}
    Set Test Variable   ${data}
    ${url_batch}    Set Variable  ${path.price_admin.batch_info.format(sellerStoreId=${sellerstore_id})}
    ${resp}    post on session  ${session}    ${url_batch}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Init Batch Sku Price Info
     ${resp}  Batch Update Price Info  admin  ${seller_store_id}  200
     ...      1|2|100.0|20.0    2|2|40.0|30.0
     [Return]  ${resp}


Template Batch Update price info positive
    [Arguments]    ${status}    ${sellerstore_id}    @{item_info}
    Init Batch Sku Price Info

    ${master_sku}  Evaluate  list(map(lambda x: x.split("|"), ${item_info}))[0][1]

    ${data_old}    Get product price info    admin  ${sellerstore_id}    ${master_sku}

    ${resp}    Batch Update Price Info    admin    ${sellerstore_id}   ${status}  @{item_info}

    ${data_new}    Get product price info    admin  ${sellerstore_id}    ${master_sku}

    FOR   ${rec_item}    ${resp_item_new}  ${resp_item_old}  IN ZIP   ${data}
    ...       ${data_new}    ${data_old}

    ${originprice_null}    Evaluate    ${rec_item}[originPrice]==None
    ${pricenew_less_than_priceold}    Evaluate    ${rec_item}[price]<${resp_item_old}[price]
    ${pricenew_equal_priceold}    Evaluate    ${rec_item}[price]==${resp_item_old}[price]
    ${pricenew_grater_than_priceold}    Evaluate    ${rec_item}[price]<${resp_item_old}[price]
    ${price_not_equal_priceold}    Evaluate    ${rec_item}[price]!= ${resp_item_old}[price]
    # No origin_price
        IF  ${originprice_null}==True
            IF  ${pricenew_equal_priceold}==True
                Should Be Equal As Strings  ${resp_item_new}[originPrice]    ${resp_item_old}[originPrice]
                Should Be Equal As Strings  ${resp_item_new}[price]    ${resp_item_old}[price]
            ELSE
                Should Be Equal As Strings  ${resp_item_new}[originPrice]    ${rec_item}[price]
                Should Be Equal As Strings  ${resp_item_new}[price]    ${rec_item}[price]
            END
    # Having  origin_price and price value
        ELSE
            ${originprice_grater_than_price}    Evaluate    ${rec_item}[originPrice]>${rec_item}[price]
            ${originprice_less_than_price}    Evaluate    ${rec_item}[originPrice]<${rec_item}[price]
            ${originprice_equal_price}    Evaluate    ${rec_item}[originPrice]==${rec_item}[price]
            IF  ${originprice_less_than_price}==True
                Should Be Equal As Strings    ${resp_item_new}[price]    ${resp_item_old}[price]
                Should Be Equal As Strings    ${resp_item_new}[originPrice]    ${resp_item_old}[originPrice]
                Should Be Equal As Strings    ${resp['message']}    Sku Originprice not less than price
            ELSE IF  ${originprice_equal_price}==True
                IF  ${price_not_equal_priceold}==True
                    Should Be Equal As Strings    ${resp_item_new}[originPrice]    ${rec_item}[originPrice]
                    Should Be Equal As Strings    ${resp_item_new}[price]    ${rec_item}[price]
                ELSE
                    Should Be Equal As Strings    ${resp_item_new}[originPrice]    ${rec_item}[originPrice]
                END
#            ELSE IF  ${originprice_grater_than_price}==True
            ELSE
                IF  ${price_not_equal_priceold}==True
                    Should Be Equal As Strings    ${resp_item_new}[originPrice]   ${rec_item}[originPrice]
                    Should Be Equal As Strings    ${resp_item_new}[price]    ${rec_item}[price]
                ELSE
                    Should Be Equal As Strings    ${resp_item_new}[originPrice]    ${rec_item}[originPrice]
                END
#            ELSE
#                log  Fatal Error
            END
        END
    END

Template Batch Update price info negitive
    [Arguments]    ${session}    ${sellerstore_id}    ${status}    @{item_info}    &{assert}
    ${resp}    Batch Update Price Info    ${session}    ${sellerstore_id}    ${status}
    ...        @{item_info}
    FOR    ${k}    ${v}    IN    &{assert}
        log    ${resp}[${k}]
        should be equal as strings  ${resp}[${k}]  ${v}
    END

Add price info
    [Arguments]    ${session}   ${sellerstore_id}    ${michaels_store_id}    ${master_sku}    ${sku_number}
    ...    ${price}  ${Orgin_Price}    ${status}
    ${data}    add_sku_price_info    ${michaels_store_id}  ${master_sku}  ${sku_number}  ${price}  ${Orgin_Price}
    ${url}    Set Variable  ${path.price_admin.single_info.format(sellerStoreId=${sellerstore_id})}
    ${resp}    post on session  ${session}    ${url}    json=${data}    expected_status=${status}
    log  ${resp.json()}
    [Return]    ${resp.json()}

Template Add price info
    [Arguments]    ${session}   ${sellerstore_id}    ${michaels_store_id}    ${master_sku}
    ...    ${price}  ${Orgin_Price}    ${status}
    ${sku_number}    Generate Id
    Add Price Info  ${session}   ${sellerstore_id}    ${michaels_store_id}    ${master_sku}    ${sku_number}
    ...    ${price}  ${Orgin_Price}    ${status}
    ${resp}    SKU Price Info    admin    ${sellerstore_id}     ${sku_number}    200
    IF    "${michaels_store_id}"=="" or "${michaels_store_id}"=="-1"
        Should Be Equal As Strings    ${resp}[data][michaelsStoreId]    -1
        Should Be Equal As Strings    ${resp}[data][masterSkuNumber]    ${master_sku}
        Should Be Equal As Strings    ${resp}[data][skuNumber]    ${sku_number}
    ELSE
        Should Be Equal As Strings    ${resp}[data]    ${null}}
    END


Update price info
    [Arguments]    ${session}   ${sellerstore_id}    ${price}  ${Orgin_Price}    ${status}
    ${data}    update_sku_price_info    ${sku_number}  ${price}  ${Orgin_Price}
    ${url_update}    Set Variable  ${path.price_admin.single_info.format(sellerStoreId=${sellerstore_id})}
    ${resp}    post on session  ${session}    ${url_update}    json=${data}    expected_status=${status}
    log  ${resp.json()}
    [Return]    ${resp.json()}

Initial price info
    [Arguments]  ${sellerstore_id}
    ${data}    Update Price Info  admin  ${SellerStore_Id}  5.0  10.0  200
    [Return]  ${data}

Template Update price info positive
    [Arguments]  ${price}  ${origin_price}  ${status}
    Initial price info  ${seller_store_id}
    ${data_old}    SKU Price Info    admin   ${seller_store_id}    ${sku_number}  200
    ${origin_price_old}    Set Variable  ${data_old['data']['originPrice']}
    ${price_old}    Set Variable  ${data_old['data']['price']}

    ${resp}    Update Price Info    admin    ${seller_store_id}   ${price}
    ...    ${origin_price}   ${status}

    ${data_new}    SKU Price Info    admin  ${seller_store_id}    ${sku_number}  200
    ${origin_price_new}    Set Variable  ${data_new['data']['originPrice']}
    ${price_new}    Set Variable  ${data_new['data']['price']}

    ${originprice_null}    Evaluate    ${origin_price} == None
    ${pricenew_less_than_priceold}    Evaluate    ${price}<${price_old}
    ${pricenew_equal_priceold}    Evaluate    ${price}==${price_old}
    ${pricenew_grater_than_priceold}    Evaluate    ${price}>${price_old}
    ${price_not_equal_priceold}    Evaluate    ${price}!=${price_old}

# No origin_price
    IF  ${originprice_null}==True
        IF  ${pricenew_equal_priceold}==True
            Should Be Equal As Strings    ${price_new}    ${price_old}
            Should Be Equal As Strings    ${origin_price_new}    ${origin_price_old}
        ELSE
            Should Be Equal As Strings  ${origin_price_new}    ${price_new}
            Should Be Equal As Strings  ${price_new}    ${price}
        END

# Having  origin_price and price value
    ELSE
        ${originprice_less_than_price}    Evaluate    ${origin_price}<${price}
        ${originprice_equal_price}    Evaluate    ${origin_price}==${price}
        ${originprice_grater_than_price}    Evaluate    ${origin_price}>${price}
        IF  ${originprice_less_than_price}==True
            Should Be Equal As Strings    ${price_new}    ${price_old}
            Should Be Equal As Strings    ${origin_price_new}    ${origin_price_old}
            Should Be Equal As Strings    ${resp['message']}    Sku Originprice not less than price
        ELSE IF  ${originprice_equal_price}==True
            IF  ${price_not_equal_priceold}==True
                Should Be Equal As Strings    ${origin_price_new}    ${price_new}
                Should Be Equal As Strings    ${price_new}    ${price}
            ELSE
                Should Be Equal As Strings    ${origin_price_new}    ${origin_price_old}  #${origin_price}
                Should Be Equal As Strings    ${price_new}    ${price_old}
            END
        ELSE IF  ${originprice_grater_than_price}==True
            IF  ${price_not_equal_priceold}==True
                Should Be Equal As Strings    ${origin_price_new}   ${origin_price}
                Should Be Equal As Strings    ${price_new}    ${price}
            ELSE
                Should Be Equal As Strings    ${origin_price_new}    ${origin_price_old}    #${origin_price}
                Should Be Equal As Strings    ${price_new}    ${price_old}
            END
        ELSE
            Log  Fatal Error
        END
    END

Template Update price info negitive
    [Arguments]  ${session}  ${sku_number}  ${price}  ${order_price}  ${status}  &{assert}
    Initial price info  ${seller_store_id}
    ${resp}    Update Price Info  ${session}  ${sku_number}  ${price}  ${order_price}  ${status}
    FOR  ${k}  ${v}  IN  &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END


Admin Manage Sku Price Info
    [Arguments]    ${status}    ${session}    ${pageNum}    ${pageSize}    @{skuNumbers}
    ${params}    Create Dictionary    pageNum=${pageNum}    pageSize=${pageSize}
    ${data}    Set Variable    ${skuNumbers}
    ${resp}    POST On Session    ${session}    ${price_management.sku_price_info}    params=${params}    json=${data}
    ...    expected_status=${status}
    [Return]    ${resp.json()}

Template Admin Manage Sku Price Info When Sku Number Is Null
    [Arguments]    ${status}    ${session}    ${pageNum}    ${pageSize}    &{assert}
    ${resp}    Admin Manage Sku Price Info    ${status}    ${session}    ${pageNum}    ${pageSize}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    IF    ${status}==200
        ${count}    Evaluate    len(${resp}[data][list])
        Should Be Equal As Strings    ${count}    ${pageSize}
    END

Template Admin Manage Sku Price Info When Sku Number Is Not Null
    [Arguments]    ${status}    ${session}    ${pageNum}    ${pageSize}    @{skuNumbers}    &{assert}
    ${resp}    Admin Manage Sku Price Info    ${status}    ${session}    ${pageNum}    ${pageSize}    @{skuNumbers}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    IF    ${status}==200
        FOR    ${item}    IN    @{resp}[data][list]
            Should Contain    ${skuNumbers}    ${item}[skuNumber]
        END
    END

Template Admin Manage Sku Price Info Can Only Get Online Sku Price
    [Arguments]    ${session}    ${seller_store_id}    @{sku_number}
    FOR    ${sku}    IN    @{sku_number}
        Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku}    ${sku}    USD
        ...    100    80    200    -1
        Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku}    ${sku}    USD
        ...    111.11    88.88    200    2021001
    END
    ${resp}    Admin Manage Sku Price Info    200    ${session}    1    10    @{sku_number}
    FOR    ${item}    IN    @{resp}[data][list]
        Should Be Equal As Strings    ${item}[originPrice]    100
        Should Be Equal As Strings    ${item}[price]    80
    END

Admin Manage Price Trends Info
    [Arguments]    ${status}    ${session}    ${skuNumber}    @{timestamps}
    ${system_time}    get_delta_timestamp
    ${start_time}    get_delta_timestamp    ${system_time}    days=${timestamps}[0]
    ${end_time}    get_delta_timestamp    ${system_time}    days=${timestamps}[1]
    ${data}    Create Dictionary    skuNumber=${skuNumber}    startTime=${start_time}    endTime=${end_time}
    ${resp}    POST On Session    ${session}    ${price_management.price_trends_info}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Template Admin Manage Price Trends Info
    [Arguments]    ${status}    ${session}    ${skuNumber}    @{timestamps}    &{assert}
    ${resp}    Admin Manage Price Trends Info    ${status}    ${session}    ${skuNumber}    @{timestamps}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    IF    ${status}==200
        ${resp2}    SKU Price Info    ${session}    0    ${skuNumber}    200
        Should Be Equal As Strings    ${resp}[data][currentPrice]    ${resp2}[data][price]
        Should Be Equal As Strings    ${resp}[data][priceLogs][0][skuNumber]    ${skuNumber}
    END

Template Admin Manage Price Trends Info Which Price Log Is Null
    [Arguments]    ${status}    ${session}    ${skuNumber}    @{timestamps}    &{assert}
    ${resp}    Admin Manage Price Trends Info    ${status}    ${session}    ${skuNumber}    @{timestamps}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    IF    ${status}==200
        ${resp2}    SKU Price Info    ${session}    0    ${skuNumber}    200
        Should Be Equal As Strings    ${resp}[data][currentPrice]    ${resp2}[data][price]
        Should Be Equal As Strings    ${resp}[data][priceLogs]    []
    END
