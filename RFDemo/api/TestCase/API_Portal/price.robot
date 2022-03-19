*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Suite Setup          Run Keywords    Initial Env Data - API-Portal


*** Test Cases ***
Test Get SKU price by primary SKU number
    [Tags]   get_sku_price     smoke
    [Documentation]     get a listing price by master sku
    ${url}    merge_urls    ${base_url}     ${get_sku_price}
    ${data}=     get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${response}    Send Get Request     ${url}    ${sku_num}


Test Get SKU price in batch by SKU numbers
    [Tags]   get_batch_price      smoke
    [Documentation]     get numbers of listings' price by sub sku
    ${data_dict}=    get_batch_sku
    ${sku_list}=       get from dictionary      ${data_dict}         skuNumbers
    ${sku_length}=        get length      ${sku_list}
    ${data}=        create dictionary       skuNumbers=${sku_list}
    ${response}    Send Post Request     ${base_url}    ${get_batch_price}  ${data}
    ${data_list}    get from dictionary     ${response.json()}     data
    ${data_length}      get length          ${data_list}
    should be equal as integers         ${sku_length}           ${data_length}

Test Get SKU price in batch by Error SKU numbers
    [Tags]   get_error_batch_price
    [Documentation]     get numbers of listings' price by nonexistent sub sku
    ${data_dict}=    get_batch_sku
    ${sku_list}=       get from dictionary      ${data_dict}         skuNumbers
    insert into list     ${sku_list}     0       000
    ${sku_length}=        get length      ${sku_list}
    ${data}=        create dictionary       skuNumbers=${sku_list}
    ${response}    Send Post Request     ${base_url}    ${get_batch_price}  ${data}
    ${data_list}    get from dictionary     ${response.json()}     data
    ${data_length}      get length          ${data_list}
    should be equal as integers         ${sku_length}           ${data_length}

Test Get SKU price in batch by Master SKU numbers
    [Tags]   get_batch_master_sku_price
    [Documentation]     get numbers of listings' price by master sku
    ${master_sku_list}=    get_bantch_master_sku
    ${sku_list_length}      get length      ${master_sku_list}
    ${data}=        create dictionary       skuNumbers=${master_sku_list}
    ${response}    Send Post Request     ${base_url}    ${get_batch_price}  ${data}
    ${data_list}       get from dictionary      ${response.json()}      data
    ${data_list_length}     get length      ${data_list}
    should be equal as integers     ${sku_list_length}      ${data_list_length}

Test Get 100 SKU price in batch by SKU numbers
    [Tags]   get_100_batch_price            MKP-4287
    [Documentation]     test if limitation of get price by sub sku work well
    ${sku_list}=    get_hundred_sku
    ${data}=        create dictionary       skuNumbers=${sku_list}
    ${response1}    Send Post Request     ${base_url}    ${get_batch_price}  ${data}     expected_status=400
    remove from list        ${sku_list}     0
    ${data}=        create dictionary       skuNumbers=${sku_list}
    ${response2}    Send Post Request     ${base_url}    ${get_batch_price}  ${data}     expected_status=any
    should not be equal as strings      ${response1.json()}         ${response2.json()}

Test Update SKU price
    [Tags]   update_sku_price    smoke
    [Documentation]     update listing price by valid sub sku and price
    ${data}=    get_update_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}

Test Update SKU price 0
    [Tags]   update_sku_price_0
    [Documentation]     update listing price and set price to 0
    ${data}=    get_update_zero_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}         expected_status=400

Test Update Error SKU price
    [Tags]   update_error_sku_price
    [Documentation]     update listing price and set price to an invalid number
    ${data}=    get_update_error_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}         expected_status=400

Test Update Exceed SKU price
    [Tags]   update_exceed_sku_price
    [Documentation]     update listing price and set price to an exceed maximum limitation number
    ${data}=    get_update_exceed_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}         expected_status=400

Test Update 100 price by SKU numbers
    [Tags]   update_100_price_by_SKU        MKP-4287
    [Documentation]     test if limitation of update price by sub sku work well
    ${data}=    get_sku_hunderd_price
    ${response1}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}   expected_status=400
    remove from list    ${data}     0
    ${response2}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}   expected_status=any
    should not be equal as strings   ${response1.json()}      ${response2.json()}



Test Get SKU price in batch by seller SKU numbers
    [Tags]   get_price_by_sellerSKU    smoke
    [Documentation]     get numbers of listings' price by valid seller skus
    ${data}=    tools.get_seller_sku
    ${sku_list}     get from dictionary     ${data}     sellerSkuNumbers
    ${sku_list_length}      get length     ${sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_price_by_sellerSKU}  ${data}
    ${data_list}       get from dictionary      ${response.json()}      data
    ${data_list_length}     get length      ${data_list}
    should be equal as integers     ${sku_list_length}      ${data_list_length}

Test Get SKU price in batch by Error seller SKU numbers
    [Tags]   get_price_by_error_sellerSKU
    [Documentation]     get numbers of listings' price by seller skus list which contain nonexist sellersku
    ${data_dict}=    tools.get_seller_sku
    ${sku_list}     get from dictionary     ${data_dict}     sellerSkuNumbers
    insert into list     ${sku_list}     0       000
    ${sku_list_length}      get length      ${sku_list}
    ${data}=        create dictionary       sellerSkuNumbers=${sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_price_by_sellerSKU}  ${data}
    ${data_list}        get from dictionary         ${response.json()}        data
    ${data_list_length}         get length          ${data_list}
    should be equal as integers         ${sku_list_length}      ${data_list_length}

Test Get 100 SKU price by seller SKU numbers
    [Tags]   get_hundred_price_by_sellerSKU         MKP-4287
    [Documentation]     test if limitation of get price by seller sku work well
    ${data}=    get_hundred_seller_sku
    ${seller_sku_list}    get from dictionary     ${data}     sellerSkuNumbers
    ${seller_sku}       get from list   ${seller_sku_list}      0
    append to list      ${seller_sku_list}      ${seller_sku}
    ${data}     create dictionary       sellerSkuNumbers=${seller_sku_list}
    ${response1}    Send Post Request      ${base_url}   ${get_price_by_sellerSKU}  ${data}     expected_status=400
    remove from list   ${seller_sku_list}    0
    ${data}     create dictionary       sellerSkuNumbers=${seller_sku_list}
    ${response2}    Send Post Request      ${base_url}   ${get_price_by_sellerSKU}  ${data}     expected_status=any
    should not be equal as strings   ${response1.json()}      ${response2.json()}




Test Update SKU price by seller SKU numbers
    [Tags]   update_price_by_sellerSKU    smoke
    [Documentation]     update numbers of listings' price by seller sku by valid sku and price
    ${data}    get_seller_sku_update_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}

Test Update Minus SKU price by seller SKU numbers
    [Tags]   update_minus_price_by_sellerSKU
    [Documentation]     update numbers of listings' price by seller sku and set price to minus number
    ${data}=    get_seller_sku_update_minus_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400

Test Update Exceed SKU price by seller SKU numbers
    [Tags]   update_exceed_price_by_sellerSKU
    [Documentation]     update numbers of listings' price by seller sku and set price to exceed max limitation number
    ${data}=    get_seller_sku_update_exceed_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400

Test Update Invalid SKU price by seller SKU numbers
    [Tags]   update_invalid_price_by_sellerSKU
    [Documentation]     update numbers of listings' price by seller sku and set price to invalid number
    ${data}=    get_seller_sku_update_invalid_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400

Test Update 100 price by seller SKU numbers
    [Tags]   update_100_price_by_sellerSKU          MKP-4287
    [Documentation]     test if limitation of update price by seller sku work well
    ${data}=    get_sellersku_hunderd_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400
    remove from list    ${data}     0
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=any
#    should not be equal as integers    ${response.status_code}      400