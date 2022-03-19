*** Settings ***
Documentation    price rule admin controller
...    1.GET/price-rule-admin/{sellerStoreId}/sku-price-rule
...    2.POST/price-rule-admin/{sellerStoreId}/sku-price-rule
...    3.POST/price-rule-admin/{sellerStoreId}/batch-sku-price-rule
...    4.POST/price-rule-admin/{sellerStoreId}/inner-batch-sku-price-rule
...    5.POST/price-rule-manage/sku-price-rule
Library  RequestsLibrary
Library    Collections
Library  ../../Libraries/INV/price.py
Library    ../../Libraries/INV/SnowflakeId.py
Library    ../../Libraries/INV/deltatime.py
Resource    _common.robot
#Resource  ../config.robot


Suite Setup    User and Admin Sign In


*** Variables ***
${A_sku_number}    5170356191561129985
${seller_store_id}    5167290306466332672
${A_master_sku_number}    5171007411682418688
${SKU_NUMBER}    0
${TEST_TIME}    0


*** Test Cases ***
#GET/price-rule-admin/{sellerStoreId}/sku-price-rule
Test get sku price rule info positive
    [Template]    template get sku price rule info positive
    ${seller_store_id}    ${A_sku_number}    skuNumber=${A_sku_number}    sellerStoreId=${seller_store_id}    currency=USD

Test get sku price rule info negitive
    [Template]    template get sku price rule info negitive
    400    admin    ${seller_store_id}    9999999    code=MCU_13001    message=Sku Price rule does not exist
    400    admin    ${seller_store_id}    ${EMPTY}    code=MCU_ARGUMENT_NOT_VALID    message=getPriceRuleInfo.skuNumber: must not be blank
    401    unlogin      ${seller_store_id}    ${A_sku_number}

#Test template get sku price rule info only get online price rule
#    [Template]    template get sku price rule info only get online price rule
#    200    admin    0    1    testgetpr001
#    200    admin    10    1    testgetpr002

#Test template get sku price rule info when price rule table have no michaelsstoreid with -1
#    [Template]    template get sku price rule info when price rule table have no michaelsstoreid with -1
#    400    admin    0    1    testgetpr003

#POST/price-rule-admin/{sellerStoreId}/sku-price-rule
Test add sku price rule info positive
    [Documentation]
    ...    1. according to skuNumber+masterSkuNumber can't query data, add data success
    ...    2 or 3. according to skuNumber+masterSkuNumber+referType+referId can't query data,and and skuNumber+masterSkuNumber can query data
    ...    and time period does not conflict, add data success (boundary value)
    ...    4. according to skuNumber+masterSkuNumber+referType+referId can't query data,and and skuNumber+masterSkuNumber can query data
    ...    and time period does not conflict, add data success
    ...    5.according to skuNumber+masterSkuNumber+referType+referId can't query data,and and skuNumber+masterSkuNumber can query data
    ...    and time period conflict, add data fail
    [Template]    add sku price rule info
    200    0    2.5    0    0    days=5    days=10
    200    ${SKU_NUMBER}    3.5    0    1   days=4    days=5
    200    ${SKU_NUMBER}    4.6    0    2   days=10    days=13
    200    ${SKU_NUMBER}    6.5    0    4   days=15    days=17
#    400    ${SKU_NUMBER}    7.8    0    5   days=3    days=8

Test add sku price rule info negitive
    [Documentation]    1.don't login    2.sku_number is null    3.price is null    4.refer_id is null    5.start_time > end_time
    ...    6.end_time = current time
    [Template]    add sku price rule info negitive
    401    unlogin    0    2.5    0    0    days=5    days=10
    400    admin    ${EMPTY}    2.5    0    1    days=5    days=10
    400    admin    0    ${EMPTY}    0    2    days=5    days=10
    400    admin    ${SKU_NUMBER}    2.5    0    ${EMPTY}    days=5    days=10

Test add sku price rule info negitive2
    [Documentation]    1.don't login    2.sku_number is null    3.price is null    4.refer_id is null    5.start_time > end_time
    ...    6.end_time = current time
    [Template]    add sku price rule info negitive2
    400    admin    0    2.5    0    0    days=5    days=1
    400    admin    0    2.5    0    0    days=5    ${EMPTY}

#Test add sku price rule info with different michaelsstoreid
#    [Template]    add sku price rule info with different michaelsstoreid
#    200    admin    0    1    testaddpr001
#    200    admin    0    0    testaddpr002

Test Template Add Price Rule When Michaelsstoreid Is Null
    [Template]    Template Add Price Rule When Michaelsstoreid Is Null
    0    addprmnull

Test update sku price rule info positive
    [Documentation]    firstly add two datas
    ...    200    0    2.6    1    days=5    days=10
    ...    200    ${SKU_NUMBER}    2.7    2    days=11    days=15
    ...    1.update first data price
    ...    2.update first data date
    ...    3.The updated data is the same as the original data, don't update
    ...    4.Update data conflicts with other data,update fail
    [Template]    template update sku price rule info
    200    3.8    0    1    days=5    days=10
    200    2.6    0    1    days=16    days=18
    200    2.6    0    1    days=5    days=10
#    400    3.8    0    1    days=8    days=16

#Test template update sku price rule info with different michaelsstoreid
#    [Template]    template update sku price rule info with different michaelsstoreid
#    200    admin    0    1    testupdatepr001
#    200    admin    0    0    testupdatepr002

Test template update sku price rule data when sku is price rule table only one data
    [Template]    template update sku price rule data when sku is price rule table only one data
    200    3.8    0    1    days=5    days=10

Test add sku price rule be overdue
    [Documentation]    Find out the data according to skunumber+masterskunumber+refertype+referid,
    ...    but the time of data has expired. Add a new data
    [Setup]    add sku price rule info by seconds    0    2.7    0    0    200    seconds=1    seconds=2
    [Template]    add sku price rule info by seconds
    ${sku_number}    2.8    0    0    200    seconds=30    seconds=60

#POST/price-rule-admin/{sellerStoreId}/batch-sku-price-rule
Test batch add one sku price rule info
    [Documentation]
    ...    1.if skuNumber+masterSkuNumber can't query data, add data success
    ...    2.if skuNumber+masterSkuNumber+referType+referId can't query data in database, and skuNumber+masterSkuNumber can query data in database,
    ...    and time period does not conflict, add data success
    ...    3.if skuNumber+masterSkuNumber+referType+referId can't query data in database, and skuNumber+masterSkuNumber can query data in database,
    ...    and time period conflict, add data fail
    [Setup]    create sku_numbers    1
    [Template]    template batch add one sku price rule info
    200    ${sku_lists}[0]|${sku_lists}[0]|12.2|1|days=5|days=10
    200    ${sku_lists}[0]|${sku_lists}[0]|16.5|2|days=15|days=17
#    400    ${sku_lists}[0]|${sku_lists}[0]|17.8|3|days=3|days=8

Test batch add one sku price rule info negitive
    [Documentation]    1.don't login    2.sku_number is null    3.price is null    4.refer_id is null    5.start_time > end_time
    ...    6.end_time = current time
    [Setup]    create sku_numbers    1
    [Template]    batch add one sku price rule info negitive
    401    unlogin    ${sku_lists}[0]|${sku_lists}[0]|12.2|1|days=5|days=10
    400    admin      |${sku_lists}[0]|12.2|2|days=5|days=10
    400    admin      ${sku_lists}[0]|${sku_lists}[0]||1|days=5|days=10
    400    admin      ${sku_lists}[0]|${sku_lists}[0]|12.3||days=5|days=10
#    400    admin      ${sku_lists}[0]|${sku_lists}[0]|12.3|3|days=5|days=1
#    400    admin      ${sku_lists}[0]|${sku_lists}[0]|12.3|3|days=5|days=0

Test template batch add price rule info
    [Template]    template batch add price rule info
    200    admin    -1|testbatchpr|tbatchpr001|13.14|seconds=0|seconds=30|1|1
    200    admin    -1|testbatch001|tbatch001|13.14|seconds=0|seconds=30|1|1
    200    admin    -1|testbatchpr|tbatchpr002|13.14|seconds=0|seconds=30|1|1    -1|testbatchpr|tbatchpr020|15.1|seconds=0|seconds=30|1|1
    200    admin    -1|testbatchpr|tbatchpr003|13.14|seconds=0|seconds=30|1|1    -1|testbatchpr|tbatchpr030|15.1|seconds=0|seconds=30|1|1
    ...    -1|testbatchpr|tbatchpr300|11.14|seconds=0|seconds=30|1|1

Test template batch update price rule info
    [Template]    template batch update price rule info
    200    admin    -1|updatebatchpr|updbatchpr001|13.14|seconds=0|seconds=30|1|1
    200    admin    -1|updatebatchpr|updbatchpr002|13.14|seconds=0|seconds=30|1|1    -1|updbatchpr|updatebatchprr020|15.1|seconds=0|seconds=30|1|1

Test batch update one sku price rule info
    [Documentation]    Initialize new data, same sku has two data, price:12.2,refer_id:1,days=5,days=10 ; price:15.2,refer_id:2,days=12,days=15
    ...    1.if according to skuNumber+masterSkuNumber+referType+referId can query data,and time period does not conflict, update data success
    ...    2.if according to skuNumber+masterSkuNumber+referType+referId can query data,and time period conflict, update data fail
    ...    3.if according to skuNumber+masterSkuNumber+referType+referId can query data,and there is no field update,do not update
    [Setup]    generate batch price rule info    3
    [Template]    template batch update one sku price rule info
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=1|days=3
#    400    ${sku_lists}[1]|${sku_lists}[1]|12.2|1|days=13|days=15
    200    ${sku_lists}[2]|${sku_lists}[2]|12.2|1|days=5|days=10

Test template batch update one sku price rule info when sku is price rule table only one data
    [Setup]    Create Sku_numbers    1
    [Template]    template batch update one sku price rule info when sku is price rule table only one data
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=1|days=3

Test batch two skus price rule info
    [Documentation]
    ...    1.batch add two different SKUs that do not exist in database
    ...    2.if skuNumber+masterSkuNumber+referType+referId can't query data in database, and skuNumber+masterSkuNumber can query data in database,
    ...    and time period does not conflict, add data success
    ...    3.if according to skuNumber+masterSkuNumber+referType+referId can query data,and time period conflict, update data fail
    [Setup]    create sku_numbers    2
    [Template]    template batch two skus price rule info
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=5|days=8    ${sku_lists}[1]|${sku_lists}[1]|15.9|1|days=9|days=12
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|2|days=9|days=11    ${sku_lists}[1]|${sku_lists}[1]|15.9|2|days=13|days=15
#    400    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=6|days=10    ${sku_lists}[1]|${sku_lists}[1]|15.9|2|days=8|days=14

#POST/price-rule-admin/{sellerStoreId}/inner-batch-sku-price-rule
Test template inner batch add price rule info
    [Template]    template inner batch add price rule info
    200    admin    -1|testinnerbatchpr|testinnerbatchp001|13.14|seconds=0|seconds=30|1|1
    200    admin    -1|testinnerbatch001|testinnerbatchp001|13.14|seconds=0|seconds=30|1|1
    200    admin    -1|testinnerbatchpr|testinnerbatchp002|13.14|seconds=0|seconds=30|1|1    -1|testinnerbatchpr|testinnerbatchp020|15.1|seconds=0|seconds=30|1|1
    200    admin    -1|testinnerbatchpr|testinnerbatchp003|13.14|seconds=0|seconds=30|1|1    -1|testinnerbatchpr|testinnerbatchp030|15.1|seconds=0|seconds=30|1|1
    ...    -1|testinnerbatchpr|testinnerbatchp300|11.14|seconds=0|seconds=30|1|1

Test template inner batch update price rule info
    [Template]    template inner batch update price rule info
    200    admin    -1|innerbatchupdatepr|innerbatchupdpr001|13.14|seconds=0|seconds=30|1|1
    200    admin    -1|innerbatchupdatepr|innerbatchupdpr002|13.14|seconds=0|seconds=30|1|1    -1|innerbatchupdatepr|innerbatchupdpr020|15.1|seconds=0|seconds=30|1|1

Test template inner batch add promotion and promotion conflict price rule
    [Template]    template inner batch add promotion and promotion conflict price rule
    200    admin    -1|testconflictpr|testflictpr001|13.14|seconds=15|seconds=35|1|1
    200    admin    -1|testconflictpr|testflictpr001|28.88|seconds=15|seconds=35|1|1


Test inner batch add one sku price rule info
    [Documentation]
    ...    1.if skuNumber+masterSkuNumber can't query data, add data success
    ...    2.if skuNumber+masterSkuNumber+referType+referId can't query data in database, and skuNumber+masterSkuNumber can query data in database,
    ...    and time period does not conflict, add data success
    ...    3.if skuNumber+masterSkuNumber+referType+referId can't query data in database, and skuNumber+masterSkuNumber can query data in database,
    ...    and time period conflict, add data fail
    [Setup]    create sku_numbers    1
    [Template]    template inner batch add one sku price rule info
    200    ${sku_lists}[0]|${sku_lists}[0]|12.2|1|days=5|days=10
    200    ${sku_lists}[0]|${sku_lists}[0]|16.5|2|days=15|days=17
#    400    ${sku_lists}[0]|${sku_lists}[0]|17.8|3|days=3|days=8

Test template inner batch add one sku price rule info negitive
    [Documentation]    1.sku_number is null    2.price is null    3.refer_id is null    4.start_time > end_time
    ...    5.end_time = current time
    [Setup]    create sku_numbers    1
    [Template]    template inner batch add one sku price rule info negitive
    400    |${sku_lists}[0]|12.2|2|days=5|days=10
    400    ${sku_lists}[0]|${sku_lists}[0]||1|days=5|days=10
    400    ${sku_lists}[0]|${sku_lists}[0]|12.3||days=5|days=10
#    400    ${sku_lists}[0]|${sku_lists}[0]|12.3|3|days=5|days=1
#    400    ${sku_lists}[0]|${sku_lists}[0]|12.3|3|days=5|days=0

Test inner batch update one sku price rule info
    [Documentation]    Initialize new data, same sku has two data, price:12.2,refer_id:1,days=5,days=10 ; price:15.2,refer_id:2,days=12,days=15
    ...    1.if according to skuNumber+masterSkuNumber+referType+referId can query data,and time period does not conflict, update data success
    ...    2.if according to skuNumber+masterSkuNumber+referType+referId can query data,and time period conflict, update data fail
    ...    3.if according to skuNumber+masterSkuNumber+referType+referId can query data,and there is no field update,do not update
    [Setup]    generate inner batch price rule info    3
    [Template]    template inner batch update one sku price rule info
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=1|days=3
#    400    ${sku_lists}[1]|${sku_lists}[1]|12.2|1|days=13|days=15
    200    ${sku_lists}[2]|${sku_lists}[2]|12.2|1|days=5|days=10

Test template inner batch update one sku price rule info when sku is price rule table only one data
    [Setup]    Create Sku_numbers    1
    [Template]    template inner batch update one sku price rule info when sku is price rule table only one data
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=1|days=3

Test inner batch two skus price rule info
    [Documentation]
    ...    1.batch add two different SKUs that do not exist in database
    ...    2.if skuNumber+masterSkuNumber+referType+referId can't query data in database, and skuNumber+masterSkuNumber can query data in database,
    ...    and time period does not conflict, add data success
    ...    3.if according to skuNumber+masterSkuNumber+referType+referId can query data,and time period conflict, update data fail
    [Setup]    create sku_numbers    2
    [Template]    template inner batch two skus price rule info
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=5|days=8    ${sku_lists}[1]|${sku_lists}[1]|15.9|1|days=9|days=12
    200    ${sku_lists}[0]|${sku_lists}[0]|15.9|2|days=9|days=11    ${sku_lists}[1]|${sku_lists}[1]|15.9|2|days=13|days=15
#    400    ${sku_lists}[0]|${sku_lists}[0]|15.9|1|days=6|days=10    ${sku_lists}[1]|${sku_lists}[1]|15.9|2|days=8|days=14

#POST/price-rule-manage/sku-price-rule
Test Template Admin Manage Sku Price Rule Positive
    [Template]    Template Admin Manage Sku Price Rule Positive
    200    admin    1    10    invtest1    code=200    message=Succeeded
    200    admin    1    10    invtest1    D376178S    code=200    message=Succeeded

Test Template Admin Manage Sku Price Rule Negitive
    [Template]    Template Admin Manage Sku Price Rule Negitive
    401    unlogin    1    10    invtest1
    200    admin    1    10    5540164764216598529
    200    admin    1    10    bucunzaidesku

#Test Template Admin Manage Sku Price Rule Can Only Get Online Sku Price
#    [Template]    Template Admin Manage Sku Price Rule Can Only Get Online Sku Price
#    admin    0    managepr001
#    admin    10    managepr002
#    admin    0    managepr003    managepr004

*** Keywords ***
User and Admin Sign In
    User Sign In    buyer      ${buyer_user}
    User Sign In    admin      ${admin_user}       admin
    create session    unlogin    ${host}     headers=${default_headers}     verify=True

Inner Batch SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}    ${michaelsStoreId}=-1
    ${store_id}    Set Variable If    "${michaelsStoreId}"==""    ${EMPTY}    ${michaelsStoreId}
    ${data}    inner_batch_sku_price    skuNumber=${sku_number}    masterSkuNumber=${master_sku_number}
    ...    currency=${currency}    michaelsStoreId=${store_id}    originPrice=${origin_price}    price=${price}
    ${url}    set variable    ${path.price_admin.inner_batch_info.format(sellerStoreId=${seller_store_id})}
    ${resp}    post on session    ${session}    ${url}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

Ininitialize SKU Price Info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}    ${currency}
    ...    ${origin_price}    ${price}    ${status}    ${michaels_store_id}=-1
    log     ${michaels_store_id}
    ${store_id}    Set Variable If    "${michaels_store_id}"==""    ${EMPTY}    ${michaels_store_id}
    ${resp}    Inner Batch SKU Price Info    ${session}    ${seller_store_id}    ${sku_number}    ${master_sku_number}
    ...    ${currency}    ${origin_price}    ${price}    200        ${store_id}

Get Price Sku
    [Arguments]    ${status}    ${session}    @{skuNumber}
    ${params}    price_sku    ${skuNumber}
    ${resp}    GET On Session    ${session}    ${path.price.sku}    params=${params}    expected_status=${status}
    [Return]    ${resp.json()}

Add Price Rule
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${price}    ${start_time}    ${end_time}    ${refer_type}
    ...    ${refer_id}    ${status}    ${michaels_store_id}=-1
    log     ${michaels_store_id}
    ${store_id}    Set Variable If    "${michaels_store_id}"==""    ${EMPTY}    ${michaels_store_id}
    ${test_time}    deltatime.get_delta_timestamp
    ${start_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${start_time}
    ${end_time}    deltatime.get_delta_timestamp    timestamp=${test_time}    seconds=${end_time}
    &{item}    Create Dictionary    sku_number=${sku_number}    price=${price}    start_time=${start_time}
    ...    end_time= ${end_time}    refer_type=${refer_type}    refer_id=${refer_id}    michaels_store_id=${store_id}
    ${data}    sku_price_rule_data    ${item}
    ${resp}    POST On Session    ${session}    ${price_rule_admin.price_rule.format(sellerStoreId=${seller_store_id})}
    ...    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

get sku price rule info
    [Arguments]    ${session}    ${seller_store_id}    ${sku_number}    ${expected_status}    ${valid}=1
    ${params}    create dictionary     skuNumber=${sku_number}    valid=${valid}
    ${urlPath}    set variable    ${path.price_rule.price_rule.format(sellerStoreId=${seller_store_id})}
    ${response}    get on session     ${session}     ${urlPath}     params=${params}    expected_status=${expected_status}
    [Return]    ${response.json()}


template get sku price rule info positive
    [Arguments]    ${seller_store_id}    ${sku_number}    &{asserts}
    ${response}    get sku price rule info    admin    ${seller_store_id}    ${sku_number}    200    0
    @{response_data}    set variable    ${response}[data]
    FOR    ${key}    ${value}    IN    &{asserts}
        FOR    ${item}    IN    @{response_data}
                should be equal as strings    ${item}[${Key}]   ${value}
        END
    END


template get sku price rule info negitive
    [Arguments]     ${expected_status}    ${session}    ${seller_store_id}    ${sku_number}    &{asserts}
    ${response}    get sku price rule info    ${session}    ${seller_store_id}    ${sku_number}    ${expected_status}
    IF    '${expected_status}'!='500'
        FOR    ${key}    ${value}    IN    &{asserts}
            should be equal as strings    ${response}[${Key}]   ${value}
        END
    END

template get sku price rule info only get online price rule
    [Arguments]    ${status}    ${session}    ${seller_store_id}    ${refer_type}    ${sku_number}
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    100    80    200    2021001
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    1000    800    200    -1
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}   13.14    5    10    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=2021001
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}    131.4    5    10    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=-1
    ${resp_redis}    Get Or Delete Price Cache From Redis   admin1    ${sku_number}    get    -1
    ${resp_redis_2021001}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    2021001
    Should Be Equal As Strings    ${resp_redis}[content]    ${None}
    Should Be Equal As Strings    ${resp_redis_2021001}[content]    ${None}
    ${resp}    get sku price rule info    ${session}    ${seller_store_id}    ${sku_number}    200
    Should Be Equal As Strings    ${resp}[data][0][price]    131.4
    Should Be Equal As Strings    ${resp}[data][0][michaelsStoreId]    -1

template get sku price rule info when price rule table have no michaelsstoreid with -1
    [Arguments]    ${status}    ${session}    ${seller_store_id}    ${refer_type}    ${sku_number}
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    100    80    200    2021001
#    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    1000    800    200    -1
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}   13.14    5    10    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=2021001
    ${resp_redis}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    -1
    ${resp_redis_2021001}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    2021001
    Should Be Equal As Strings    ${resp_redis}[content]    ${None}
    Should Be Equal As Strings    ${resp_redis_2021001}[content]    ${None}
    ${resp}    get sku price rule info    ${session}    ${seller_store_id}    ${sku_number}    ${status}
    Should Be Equal As Strings    ${resp}[code]    MCU_13001
    Should Be Equal As Strings    ${resp}[message]    Sku Price rule does not exist
    Should Be Equal As Strings    ${resp_redis}[content]    ${None}
    Should Be Equal As Strings    ${resp_redis_2021001}[content]    ${None}

post sku price rule info
    [Arguments]    ${session}    ${request_data}    ${expected_status}
    set test variable    ${request_data}
    ${urlPath}    set variable    ${path.price_rule.price_rule.format(sellerStoreId=${seller_store_id})}
    ${response}    post on session    ${session}    ${urlPath}    json=${request_data}    expected_status=${expected_status}
    [Return]    ${response.json()}


check sku price rule info
    [Arguments]    ${seller_store_id}    ${sku_number}
    ${response}    get sku price rule info    admin    ${seller_store_id}    ${sku_number}    200
    @{response_datas}    set variable    ${response}[data]
    @{query_items}    create list
    FOR    ${response_data}    IN    @{response_datas}
        ${sku_number}    set variable    ${response_data}[skuNumber]
        ${master_sku_number}    set variable    ${response_data}[masterSkuNumber]
        ${michaels_store_id}    set variable    ${response_data}[michaelsStoreId]
        ${currency}    set variable    ${response_data}[currency]
        ${price}    set variable    ${response_data}[price]
        ${bundle_price_rule}    set variable    ${response_data}[bundlePriceRule]
        ${start_time}    set variable    ${response_data}[startTime]
        ${end_time}    set variable    ${response_data}[endTime]
        ${remark}    set variable    ${response_data}[remark]
        ${refer_type}    set variable    ${response_data}[referType]
        ${refer_id}    set variable    ${response_data}[referId]
        ${item}    create dictionary    skuNumber=${sku_number}    masterSkuNumber=${master_sku_number}  michaelsStoreId=${michaels_store_id}
        ...    currency=${currency}    price=${price}    bundlePriceRule=${bundle_price_rule}    startTime=${start_time}    endTime=${end_time}
        ...    remark=${remark}    referType=${refer_type}    referId=${refer_id}
    append to list    ${query_items}    ${item}
    END
    [Return]    ${query_items}


get_one_item_data
    [Arguments]    ${sku_number}    ${price}    ${refer_type}    ${refer_id}    @{timestamps}
    IF    '${sku_number}'=='0'
        ${test_time}    deltatime.Get Delta Timestamp
        set test variable    ${TEST_TIME}
        ${sku_number}    generate_id
        ${sku_number}    evaluate    str(${sku_number})
        set test variable    ${SKU_NUMBER}
    END
    &{d}    evaluate    dict(${timestamps[0]})
    ${start_time}    deltatime.Get Delta Timestamp    ${test_time}     &{d}
    &{d}    evaluate    dict(${timestamps[1]})
    ${end_time}    deltatime.Get Delta Timestamp    ${test_time}     &{d}
    ${item}    create dictionary    sku_number=${sku_number}    master_sku_number=${sku_number}    price=${price}
    ...    start_time=${start_time}    end_time=${end_time}    refer_type=${refer_type}    refer_id=${refer_id}
    ...    michaels_store_id=-1
    set test variable    ${item}
    [Return]    ${item}


add sku price rule info
    [Arguments]    ${expected_status}    ${sku_number}    ${price}    ${refer_type}    ${refer_id}    @{timestamps}
    ${item}    get_one_item_data    ${sku_number}    ${price}    ${refer_type}    ${refer_id}    @{timestamps}
    ${request_data}    sku price rule data    ${item}
    ${response}    post sku price rule info    admin    ${request_data}   ${expected_status}
    ${query_items}    check sku price rule info    ${seller_store_id}    ${sku_number}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        should contain    ${query_items}    ${request_data}
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END


add sku price rule info negitive
    [Arguments]    ${expected_status}    ${session}    ${sku_number}    ${price}    ${refer_id}    @{timestamps}
    ${item}    get_one_item_data    ${sku_number}    ${price}    ${refer_id}    @{timestamps}
    ${request_data}    sku price rule data    ${item}
    ${response}    post sku price rule info    ${session}    ${request_data}    ${expected_status}
    IF    '${expected_status}'=='401'
        should contain    ${response}[code]    401
    ELSE
        should contain    ${response}[code]     MCU_ARGUMENT_NOT_VALID
    END

add sku price rule info negitive2
    [Arguments]    ${expected_status}    ${session}    ${sku_number}    ${price}    ${refer_id}    @{timestamps}
    ${item}    get_one_item_data    ${sku_number}    ${price}    ${refer_id}    @{timestamps}
    ${request_data}    sku price rule data    ${item}
    ${response}    post sku price rule info    ${session}    ${request_data}    ${expected_status}
    IF    '${expected_status}'=='401'
        should contain    ${response}[code]    401
    ELSE
        should contain    ${response}[code]     MCU_13003
    END

Get Price Sku MichaelsStoreId
    [Arguments]    ${status}    ${session}    ${michaelsStoreId}    @{skuNumber}
    ${data}    price_sku_michaelsstoreid    ${michaelsStoreId}    ${skuNumber}
    ${resp}    POST On Session    ${session}    ${price.sku_michaelsstoreid}    json=${data}    expected_status=${status}
    [Return]    ${resp.json()}

add sku price rule info with different michaelsstoreid
    [Arguments]    ${status}    ${session}    ${seller_store_id}    ${refer_type}    ${sku_number}
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    100    80    200    2021001
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    1000    800    200    -1
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}   13.14    0    20    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=2021001
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}    131.4    0    20    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=-1
    ${resp_redis}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    -1
    ${resp_redis_2021001}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    2021001
    Should Be Equal As Strings    ${resp_redis}[content]    ${None}
    Should Be Equal As Strings    ${resp_redis_2021001}[content]    ${None}
    ${resp_2021001}    Get Price Sku MichaelsStoreId    200    ${session}    2021001    ${sku_number}
    ${resp}    Get Price Sku MichaelsStoreId    200    ${session}    -1    ${sku_number}
    ${resp_redis_2021001}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    2021001
    ${resp_redis}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    -1
    IF    ${refer_type}==1
        Should Be Equal As Strings    ${resp}[0][promoPrice]    131.4
        Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
        Should Be Equal As Strings    ${resp_2021001}[0][promoPrice]    13.14
        Should Be Equal As Strings    ${resp_2021001}[0][michaelsStoreId]    2021001
        Should Be Equal As Strings    ${resp_redis_2021001}[content][price]    80
        Should Be Equal As Strings    ${resp_redis}[content][price]    800
    ELSE
        Should Be Equal As Strings    ${resp_2021001}[0][price]    13.14
        Should Be Equal As Strings    ${resp_2021001}[0][michaelsStoreId]    2021001
        Should Be Equal As Strings    ${resp}[0][price]    131.4
        Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
        Should Be Equal As Strings    ${resp_redis_2021001}[content][price]    13.14
        Should Be Equal As Strings    ${resp_redis}[content][price]    131.4
    END

Template Add Price Rule When Michaelsstoreid Is Null
    [Arguments]    ${seller_store_id}    ${master_sku_number}
    ${sku_number}    Generate Id
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${master_sku_number}    USD
    ...    100    80    200    ${EMPTY}
    Add Price Rule    admin    ${seller_store_id}    ${sku_number}    13.14    0    10    1    1    200    ${EMPTY}
    ${resp}    Get Sku Price Rule Info    admin    ${seller_store_id}    ${sku_number}    200
    Should Be Equal As Strings    ${resp}[data][0][michaelsStoreId]    -1

template update sku price rule info
    [Arguments]    ${expected_status}    ${price}    ${refer_id}    @{timestamps}
    add sku price rule info    200    0    2.6    0    1    days=5    days=10
    add sku price rule info    200    ${SKU_NUMBER}    2.7    0    2    days=11    days=15
    ${item}    get_one_item_data     ${SKU_NUMBER}    ${price}    ${refer_id}    @{timestamps}
    ${request_data}    sku price rule data    ${item}
    ${response}    post sku price rule info    admin    ${request_data}   ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        ${query_items}    check sku price rule info    ${seller_store_id}    ${sku_number}
        should contain    ${query_items}    ${request_data}
        ${len}    Get Length    ${query_items}
        Should Be Equal    int(${len})    int(2)
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

template update sku price rule info with different michaelsstoreid
    [Arguments]    ${status}    ${session}    ${seller_store_id}    ${refer_type}    ${sku_number}
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    100    80    200    2021001
    Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku_number}    ${sku_number}    USD    1000    800    200    -1
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}   13.14    0    20    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=2021001
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}    131.4    0    20    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=-1
    Add Price Rule      admin    ${seller_store_id}    ${sku_number}   64    0    20    refer_type=${refer_type}    refer_id=1
    ...    status=200    michaels_store_id=2021001
    ${resp_redis}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    -1
    ${resp_redis_2021001}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    2021001
    Should Be Equal As Strings    ${resp_redis}[content]    ${None}
    Should Be Equal As Strings    ${resp_redis_2021001}[content]    ${None}
    ${resp_2021001}    Get Price Sku MichaelsStoreId    200    ${session}    2021001    ${sku_number}
    ${resp}    Get Price Sku MichaelsStoreId    200    ${session}    -1    ${sku_number}
    ${resp_redis_2021001}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    2021001
    ${resp_redis}    Get Or Delete Price Cache From Redis    admin1    ${sku_number}    get    -1
    IF    ${refer_type}==1
        Should Be Equal As Strings    ${resp}[0][promoPrice]    131.4
        Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
        Should Be Equal As Strings    ${resp_2021001}[0][promoPrice]    64
        Should Be Equal As Strings    ${resp_2021001}[0][michaelsStoreId]    2021001
        Should Be Equal As Strings    ${resp_redis_2021001}[content][price]    80
        Should Be Equal As Strings    ${resp_redis}[content][price]    800
    ELSE
        Should Be Equal As Strings    ${resp_2021001}[0][price]    64
        Should Be Equal As Strings    ${resp_2021001}[0][michaelsStoreId]    2021001
        Should Be Equal As Strings    ${resp}[0][price]    131.4
        Should Be Equal As Strings    ${resp}[0][michaelsStoreId]    -1
        Should Be Equal As Strings    ${resp_redis_2021001}[content][price]    64
        Should Be Equal As Strings    ${resp_redis}[content][price]    131.4
    END

template update sku price rule data when sku is price rule table only one data
    [Arguments]    ${expected_status}    ${price}    ${refer_type}    ${refer_id}    @{timestamps}
    add sku price rule info    200    0    2.6    ${refer_type}    1    days=5    days=10
    ${item}    get_one_item_data     ${SKU_NUMBER}    ${price}    ${refer_type}    ${refer_id}    @{timestamps}
    ${request_data}    sku price rule data    ${item}
    ${response}    post sku price rule info    admin    ${request_data}   ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        ${query_items}    check sku price rule info    ${seller_store_id}    ${sku_number}
        should contain    ${query_items}    ${request_data}
        ${len}    Get Length    ${query_items}
        Should Be Equal    int(${len})    int(1)
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

add sku price rule info by seconds
    [Arguments]    ${sku_number}    ${price}    ${refer_type}    ${refer_id}    ${expected_status}    @{timestamps}
    ${item}    get_one_item_data    ${sku_number}    ${price}    ${refer_type}    ${refer_id}    @{timestamps}
    ${request_data}    sku price rule data    ${item}
    ${response}    post sku price rule info    admin    ${request_data}   ${expected_status}
    ${query_items}    check sku price rule info    ${seller_store_id}    ${sku_number}
    should be equal as strings    ${response}[message]    Succeeded
    should contain    ${query_items}    ${request_data}
    sleep    3


post batch sku price rule info
    [Arguments]    ${session}    ${request_data}    ${expected_status}    ${seller_store_id}=0
    set test variable    ${request_data}
    ${urlPath}    set variable    ${path.price_rule.batch_price_rule.format(sellerStoreId=${seller_store_id})}
    ${response}    post on session    ${session}    ${urlPath}    json=${request_data}    expected_status=${expected_status}
    [Return]    ${response.json()}



create sku_numbers
    [Arguments]    ${nums}
    @{sku_lists}    create list
    FOR    ${i}    IN RANGE    ${nums}
        ${sku_number}    generate_id
        append to list    ${sku_lists}    ${sku_number}
    END
    set test variable    ${sku_lists}
    [Return]    ${sku_lists}


template batch add one sku price rule info
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    batch sku price rule data    ${item_infos}
    ${response}    post batch sku price rule info    admin    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${request_data}[0]
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END


batch add one sku price rule info negitive
    [Arguments]    ${expected_status}    ${session}    @{item_infos}
    ${item_infos}    batch sku price rule data    ${item_infos}
    ${response}    post batch sku price rule info    ${session}    ${item_infos}     ${expected_status}
    IF    '${expected_status}'=='401'
        should contain    ${response}[code]    401
    ELSE IF    '${expected_status}'=='400'
        should contain    ${response}[code]     MCU_ARGUMENT_NOT_VALID
    END

template batch add price rule info
    [Arguments]    ${status}    ${session}    @{item_info}
    ${data}    sku_price_rule_query_data    ${item_info}
    ${num}    Get Length      ${data}
    FOR    ${i}    IN RANGE    ${num}
        Ininitialize SKU Price Info    admin    0    ${data}[${i}][skuNumber]    ${data}[${i}][masterSkuNumber]    USD
        ...    100    80    200    ${data}[${i}][michaelsStoreId]
    END
    ${data}    sku_price_rule_query_data    ${item_info}
    post batch sku price rule info    ${session}    ${data}   ${status}    0
    Sleep    10
    FOR    ${i}    IN RANGE    ${num}
#        ${resp}    Get Price Sku MichaelsStoreId    200    admin    ${data}[${i}][michaelsStoreId]    ${data}[${i}][skuNumber]
        ${resp}    Get Price Sku    200    buyer    ${data}[${i}][skuNumber]
        IF    ${data}[${i}][referType]==1
            Should Be Equal As Strings    ${data}[${i}][price]    ${resp}[0][promoPrice]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        ELSE
            Should Be Equal As Strings    ${data}[${i}][price]    ${resp}[0][price]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        END
    END

template batch update price rule info
    [Arguments]    ${status}    ${session}    @{item_info}
    ${data}    sku_price_rule_query_data    ${item_info}
    ${num}    Get Length      ${data}
    FOR    ${i}    IN RANGE    ${num}
        Ininitialize SKU Price Info    admin    0    ${data}[${i}][skuNumber]    ${data}[${i}][masterSkuNumber]    USD
        ...    100    80    200    ${data}[${i}][michaelsStoreId]
    END
    ${data}    sku_price_rule_query_data    ${item_info}
    post batch sku price rule info    ${session}    ${data}   ${status}
    @{update_data}    Create List
    FOR    ${i}    IN RANGE    ${num}
        ${michaelsStoreId}    Set Variable    ${data}[${i}][michaelsStoreId]
        ${masterSkuNumber}    Set Variable    ${data}[${i}][masterSkuNumber]
        ${skuNumber}    Set Variable    ${data}[${i}][skuNumber]
        ${referType}    Set Variable    ${data}[${i}][referType]
        ${referId}    Set Variable    ${data}[${i}][referId]
        Append To List    ${update_data}    ${michaelsStoreId}|${masterSkuNumber}|${skuNumber}|1.1|seconds=0|seconds=30|${referType}|${referId}
    END
    ${update_data}    sku_price_rule_query_data    ${update_data}
    post batch sku price rule info    ${session}    ${update_data}   ${status}
    Sleep    10
    FOR    ${i}    IN RANGE    ${num}
#        ${resp}    Get Price Sku MichaelsStoreId    200    admin    ${data}[${i}][michaelsStoreId]    ${data}[${i}][skuNumber]
        ${resp}    Get Price Sku    200    buyer    ${data}[${i}][skuNumber]
        IF    ${data}[${i}][referType]==1
            Should Be Equal As Strings    1.1    ${resp}[0][promoPrice]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        ELSE
            Should Be Equal As Strings    1.1    ${resp}[0][price]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        END
    END

generate batch price rule info
    [Arguments]    ${num}
    ${sku_lists}    create sku_numbers    ${num}
    FOR    ${sku}    IN    @{sku_lists}
        ${A_infos}    create list    ${sku}|${sku}|12.2|1|days=5|days=10
        ${A_infos}    batch sku price rule data    ${A_infos}
        ${response}    post batch sku price rule info    admin    ${A_infos}     200
        ${B_infos}    create list    ${sku}|${sku}|15.2|2|days=12|days=15
        ${B_infos}    batch sku price rule data    ${B_infos}
        ${response}    post batch sku price rule info    admin    ${B_infos}     200
    END
    set test variable    ${sku_lists}


generate inner batch price rule info
    [Arguments]    ${num}
    ${sku_lists}    create sku_numbers    ${num}
    FOR    ${sku}    IN    @{sku_lists}
        ${A_infos}    create list    ${sku}|${sku}|12.2|1|days=5|days=10
        ${A_infos}    inner batch sku price rule data    ${A_infos}
        ${response}    post inner batch sku price rule info    ${A_infos}     200
        ${B_infos}    create list    ${sku}|${sku}|15.2|2|days=12|days=15
        ${B_infos}    inner batch sku price rule data    ${B_infos}
        ${response}    post inner batch sku price rule info    ${B_infos}     200
    END
    set test variable    ${sku_lists}



template batch update one sku price rule info
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    batch sku price rule data    ${item_infos}
    ${response}    post batch sku price rule info    admin    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${request_data}[0]
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

template batch update one sku price rule info when sku is price rule table only one data
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    batch sku price rule data    ${item_infos}
    ${skuNumber}    Evaluate    ${request_data}[0].get("skuNumber")
    ${masterSkuNumber}    Evaluate    ${request_data}[0].get("masterSkuNumber")
    ${init_list}    Create List    ${skuNumber}|${masterSkuNumber}|10.0|1|days=2|days=4
    ${init_request_data}    batch sku price rule data    ${init_list}
    post batch sku price rule info    admin    ${init_request_data}     ${expected_status}
    ${request_data}    batch sku price rule data    ${item_infos}
    ${response}    post batch sku price rule info    admin    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${request_data}[0]
            ${num}    Get Length    ${query_items}
            ${len}    Evaluate    int(1)
            Should Be Equal    ${num}     ${len}
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

template batch two skus price rule info
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    batch sku price rule data    ${item_infos}
    ${response}    post batch sku price rule info    admin    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${item}
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

post inner batch sku price rule info
    [Arguments]    ${request_data}    ${expected_status}    ${seller_store_id}=0
    set test variable    ${request_data}
    ${urlPath}    set variable    ${path.price_rule.inner_batch_price_rule.format(sellerStoreId=${seller_store_id})}
    ${response}    post on session    unlogin    ${urlPath}    json=${request_data}    expected_status=${expected_status}
    [Return]    ${response.json()}

template inner batch add price rule info
    [Arguments]    ${status}    ${session}    @{item_info}
    ${data}    sku_price_rule_query_data    ${item_info}
    ${num}    Get Length      ${data}
    FOR    ${i}    IN RANGE    ${num}
        Ininitialize SKU Price Info    admin    0    ${data}[${i}][skuNumber]    ${data}[${i}][masterSkuNumber]    USD
        ...    100    80    200    ${data}[${i}][michaelsStoreId]
    END
    ${data}    sku_price_rule_query_data    ${item_info}
    post inner batch sku price rule info    ${data}   ${status}
    Sleep    10
    FOR    ${i}    IN RANGE    ${num}
#        ${resp}    Get Price Sku MichaelsStoreId    200    admin    ${data}[${i}][michaelsStoreId]    ${data}[${i}][skuNumber]
        ${resp}    Get Price Sku    200   buyer    ${data}[${i}][skuNumber]
        IF    ${data}[${i}][referType]==1
            Should Be Equal As Strings    ${data}[${i}][price]    ${resp}[0][promoPrice]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        ELSE
            Should Be Equal As Strings    ${data}[${i}][price]    ${resp}[0][price]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        END
    END

template inner batch add promotion and promotion conflict price rule
    [Arguments]    ${status}    ${session}    @{item_info}
    ${ini_price_rule_data}    Create List
    ${data}    sku_price_rule_query_data    ${item_info}
    ${num}    Get Length      ${data}
    FOR    ${i}    IN RANGE    ${num}
        Ininitialize SKU Price Info    admin    0    ${data}[${i}][skuNumber]    ${data}[${i}][masterSkuNumber]    USD
        ...    100    80    200    ${data}[${i}][michaelsStoreId]
    END
    FOR    ${i}    IN RANGE    ${num}
        ${skuNumber}    Set Variable  ${data}[${i}][skuNumber]
        ${masterSkuNumber}    Set Variable    ${data}[${i}][masterSkuNumber]
        Append To List    ${ini_price_rule_data}    -1|${masterSkuNumber}|${skuNumber}|19.99|seconds=5|seconds=25|1|123
    END
    ${ini_price_rule_data}    sku_price_rule_query_data    ${ini_price_rule_data}
    ${data}    sku_price_rule_query_data    ${item_info}
    post inner batch sku price rule info    ${ini_price_rule_data}   ${status}
    post inner batch sku price rule info    ${data}   ${status}
#    Sleep    2
    FOR    ${i}    IN RANGE    ${num}
        ${resp}    Get Price Sku    200   buyer    ${data}[${i}][skuNumber]
        Should Be Equal As Strings    ${null}    ${resp}[0][promoPrice]
        Should Be Equal As Strings    80   ${resp}[0][price]
        Should Be Equal As Strings    100   ${resp}[0][originPrice]
        Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
    END
    Sleep    7
    FOR    ${i}    IN RANGE    ${num}
        ${resp}    Get Price Sku    200   buyer    ${data}[${i}][skuNumber]
        Should Be Equal As Strings    19.99    ${resp}[0][promoPrice]
        Should Be Equal As Strings    80   ${resp}[0][price]
        Should Be Equal As Strings    100   ${resp}[0][originPrice]
        Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
    END
    Sleep    10
    FOR    ${i}    IN RANGE    ${num}
        ${resp}    Get Price Sku    200   buyer    ${data}[${i}][skuNumber]
        IF    ${data}[${i}][price]<19.9
            Should Be Equal As Strings    ${data}[${i}][price]    ${resp}[0][promoPrice]
            Should Be Equal As Strings    80   ${resp}[0][price]
            Should Be Equal As Strings    100   ${resp}[0][originPrice]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        ELSE
            Should Be Equal As Strings    19.99    ${resp}[0][promoPrice]
            Should Be Equal As Strings    80   ${resp}[0][price]
            Should Be Equal As Strings    100   ${resp}[0][originPrice]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        END
    END
    Sleep    10
    FOR    ${i}    IN RANGE    ${num}
        ${resp}    Get Price Sku    200   buyer    ${data}[${i}][skuNumber]
        Should Be Equal As Strings    ${data}[${i}][price]    ${resp}[0][promoPrice]
        Should Be Equal As Strings    80   ${resp}[0][price]
        Should Be Equal As Strings    100   ${resp}[0][originPrice]
        Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
    END
    Sleep    10
    FOR    ${i}    IN RANGE    ${num}
        ${resp}    Get Price Sku    200   buyer    ${data}[${i}][skuNumber]
        Should Be Equal As Strings    ${null}    ${resp}[0][promoPrice]
        Should Be Equal As Strings    80   ${resp}[0][price]
        Should Be Equal As Strings    100   ${resp}[0][originPrice]
        Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
    END



template inner batch update price rule info
    [Arguments]    ${status}    ${session}    @{item_info}
    ${data}    sku_price_rule_query_data    ${item_info}
    ${num}    Get Length      ${data}
    FOR    ${i}    IN RANGE    ${num}
        Ininitialize SKU Price Info    admin    0    ${data}[${i}][skuNumber]    ${data}[${i}][masterSkuNumber]    USD
        ...    100    80    200    ${data}[${i}][michaelsStoreId]
    END
    ${data}    sku_price_rule_query_data    ${item_info}
    post inner batch sku price rule info    ${data}   ${status}
    @{update_data}    Create List
    FOR    ${i}    IN RANGE    ${num}
        ${michaelsStoreId}    Set Variable    ${data}[${i}][michaelsStoreId]
        ${masterSkuNumber}    Set Variable    ${data}[${i}][masterSkuNumber]
        ${skuNumber}    Set Variable    ${data}[${i}][skuNumber]
        ${referType}    Set Variable    ${data}[${i}][referType]
        ${referId}    Set Variable    ${data}[${i}][referId]
        Append To List    ${update_data}    ${michaelsStoreId}|${masterSkuNumber}|${skuNumber}|1.1|seconds=0|seconds=30|${referType}|${referId}
    END
    ${update_data}    sku_price_rule_query_data    ${update_data}
    post inner batch sku price rule info    ${update_data}   ${status}
    Sleep    10
    FOR    ${i}    IN RANGE    ${num}
#        ${resp}    Get Price Sku MichaelsStoreId    200    admin    ${data}[${i}][michaelsStoreId]    ${data}[${i}][skuNumber]
        ${resp}    Get Price Sku    200    buyer    ${data}[${i}][skuNumber]
        IF    ${data}[${i}][referType]==1
            Should Be Equal As Strings    1.1    ${resp}[0][promoPrice]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        ELSE
            Should Be Equal As Strings    1.1    ${resp}[0][price]
            Should Be Equal As Strings    ${data}[${i}][michaelsStoreId]    ${resp}[0][michaelsStoreId]
        END
    END

template inner batch add one sku price rule info
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    inner_batch_sku_price_rule_data    ${item_infos}
    ${response}    post inner batch sku price rule info    ${request_data}    ${expected_status}
#    ${query_items}    check sku price rule info    ${seller_store_id}    ${sku_number}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${request_data}[0]
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END


template inner batch add one sku price rule info negitive
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    inner_batch_sku_price_rule_data    ${item_infos}
    ${response}    post inner batch sku price rule info    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='400'
        should contain    ${response}[code]     MCU_ARGUMENT_NOT_VALID
    END


template inner batch update one sku price rule info
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    inner batch sku price rule data    ${item_infos}
    ${response}    post inner batch sku price rule info    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${request_data}[0]
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

template inner batch update one sku price rule info when sku is price rule table only one data
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    inner batch sku price rule data    ${item_infos}
    ${skuNumber}    Evaluate    ${request_data}[0].get("skuNumber")
    ${masterSkuNumber}    Evaluate    ${request_data}[0].get("masterSkuNumber")
    ${init_list}    Create List    ${skuNumber}|${masterSkuNumber}|10.0|1|days=2|days=4
    ${init_request_data}    inner batch sku price rule data    ${init_list}
    post inner batch sku price rule info    ${init_request_data}     ${expected_status}
    ${request_data}    inner batch sku price rule data    ${item_infos}
    ${response}    post inner batch sku price rule info    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${request_data}[0]
            ${num}    Get Length    ${query_items}
            ${len}    Evaluate    int(1)
            Should Be Equal    ${num}     ${len}
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

template inner batch two skus price rule info
    [Arguments]    ${expected_status}    @{item_infos}
    ${request_data}    inner batch sku price rule data    ${item_infos}
    ${response}    post inner batch sku price rule info    ${request_data}     ${expected_status}
    IF    '${expected_status}'=='200'
        should be equal as strings    ${response}[message]    Succeeded
        FOR    ${item}    IN    @{request_data}
            ${query_items}    check sku price rule info    0    ${item}[skuNumber]
            should contain    ${query_items}    ${item}
        END
    ELSE
        should be equal as strings    ${response}[code]    MCU_13003
        should contain    ${response}[message]    Sku Price Rule price conflicted
    END

Admin Manage Sku Price Rule
    [Arguments]    ${status}    ${session}    ${pageNum}    ${pageSize}    @{skuNumbers}
    ${params}    Create Dictionary    pageNum=${pageNum}    pageSize=${pageSize}
    ${resp}    POST On Session    ${session}    ${price_rule_management.sku_price_rule}    params=${params}
    ...    json=${skuNumbers}    expected_status=${status}
    [Return]    ${resp.json()}

Template Admin Manage Sku Price Rule Positive
    [Arguments]    ${status}    ${session}    ${pageNum}    ${pageSize}    @{skuNumbers}    &{assert}
    ${resp}    Admin Manage Sku Price Rule    ${status}    ${session}    ${pageNum}    ${pageSize}    ${skuNumbers}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    FOR    ${item}    IN    @{resp}[data][list]
        Should Contain    ${skuNumbers}    ${item}[skuNumber]
    END

Template Admin Manage Sku Price Rule Negitive
    [Arguments]    ${status}    ${session}    ${pageNum}    ${pageSize}    @{skuNumbers}    &{assert}
    ${resp}    Admin Manage Sku Price Rule    ${status}    ${session}    ${pageNum}    ${pageSize}    ${skuNumbers}
    FOR    ${k}    ${v}    IN    &{assert}
        Should Be Equal As Strings    ${resp}[${k}]    ${v}
    END
    IF    ${status}==200
       Should Be Equal As Strings    ${resp}[data][list]    ${null}
    END

Template Admin Manage Sku Price Rule Can Only Get Online Sku Price
    [Arguments]    ${session}    ${seller_store_id}    @{sku_number}
    FOR    ${sku}    IN    @{sku_number}
        Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku}    ${sku}    USD
        ...    100    80    200    -1
        Ininitialize SKU Price Info    admin    ${seller_store_id}    ${sku}    ${sku}    USD
        ...    111.11    88.88    200    2021001
        Add Price Rule    admin    ${seller_store_id}    ${sku}    13.14    0    15    1    1    200    -1
        Add Price Rule    admin    ${seller_store_id}    ${sku}    13.14    0    15    1    1    200    2021001
    END
    ${resp}    Admin Manage Sku Price Rule    200    ${session}    1    10    @{sku_number}
    FOR    ${item}    IN    @{resp}[data][list]
        Should Be Equal As Strings    ${item}[price]    13.14
    END