*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot


*** Test Cases ***
Test Get SKU price by primary SKU number
    [Tags]   get_sku_price     smoke
    ${url}    merge_urls    ${base_url}     ${get_sku_price}
    ${data}=     get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${response}    Send Get Request     ${url}    ${sku_num}

Test Get SKU price by Error primary SKU number
    [Tags]   get_error_sku_price
    ${url}    merge_urls    ${base_url}     ${get_sku_price}
    ${sku_num}=  set variable    000
    ${response}    Send Get Request     ${url}    ${sku_num}
    ${data_dict}    get from dictionary     ${response.json()}     data
    ${price_list}   get from dictionary     ${data_dict}        skuPrices
    should be empty     ${price_list}

Test Get SKU price by SUB SKU number
    [Tags]   get_sub_sku_price
    ${url}    merge_urls    ${base_url}     ${get_sku_price}
    ${sku_num}=  get_variation_sub_sku
    ${response}    Send Get Request     ${url}    ${sku_num}
    ${data_dict}    get from dictionary     ${response.json()}     data
    ${price_list}   get from dictionary     ${data_dict}        skuPrices
    should be empty     ${price_list}



Test Get SKU price in batch by SKU numbers
    [Tags]   get_batch_price      smoke
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
    ${data_dict}=    get_batch_sku
    ${sku_list}=       get from dictionary      ${data_dict}         skuNumbers
    ${sku_length}=        get length      ${sku_list}
    insert into list     ${sku_list}     0       000
    ${data}=        create dictionary       skuNumbers=${sku_list}
    ${response}    Send Post Request     ${base_url}    ${get_batch_price}  ${data}
    ${data_list}    get from dictionary     ${response.json()}     data
    ${data_length}      get length          ${data_list}
    should be equal as integers         ${sku_length}           ${data_length}

Test Get SKU price in batch by Master SKU numbers
    [Tags]   get_batch_master_sku_price
    ${master_sku_list}=    get_bantch_master_sku
    ${data}=        create dictionary       skuNumbers=${master_sku_list}
    ${response}    Send Post Request     ${base_url}    ${get_batch_price}  ${data}
    ${data_list}    get from dictionary     ${response.json()}     data
    should be empty      ${data_list}



Test Update SKU price
    [Tags]   update_sku_price    smoke
    ${data}=    get_update_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}

Test Update SKU price By Error SKU
    [Tags]   update_sku_price_by_error_sku
    ${data}=    get_update_price_by_error_sku
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}        expected_status=400

Test Update SKU price By Master SKU
    [Tags]   update_sku_price_by_master_sku
    ${data}=    get_update_price_by_master_sku
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}        expected_status=400

Test Update SKU price 0
    [Tags]   update_sku_price_0
    ${data}=    get_update_zero_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}         expected_status=400

Test Update Error SKU price
    [Tags]   update_error_sku_price
    ${data}=    get_update_error_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}         expected_status=400

Test Update Exceed SKU price
    [Tags]   update_exceed_sku_price
    ${data}=    get_update_exceed_price
    ${response}    Send Post Request      ${base_url}   ${update_sku_price}  ${data}         expected_status=400



Test Get SKU price in batch by seller SKU numbers
    [Tags]   get_price_by_sellerSKU    smoke
    ${data}=    tools.get_seller_sku
    ${sku_list}     get from dictionary     ${data}     sellerSkuNumbers
    ${sku_list_length}      get length     ${sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_price_by_sellerSKU}  ${data}
    ${data_list}       get from dictionary      ${response.json()}      data
    ${data_list_length}     get length      ${data_list}
    should be equal as integers     ${sku_list_length}      ${data_list_length}

Test Get SKU price in batch by Error seller SKU numbers
    [Tags]   get_price_by_error_sellerSKU
    ${data_dict}=    tools.get_seller_sku
    ${sku_list}     get from dictionary     ${data_dict}     sellerSkuNumbers
    ${sku_list_length}      get length      ${sku_list}
    insert into list     ${sku_list}     0       000
    ${data}=        create dictionary       sellerSkuNumbers=${sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_price_by_sellerSKU}  ${data}
    ${data_list}        get from dictionary         ${response.json()}        data
    ${data_list_length}         get length          ${data_list}
    should be equal as integers         ${sku_list_length}      ${data_list_length}



Test Update SKU price by seller SKU numbers
    [Tags]   update_price_by_sellerSKU    smoke
    ${data}    get_seller_sku_update_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}

Test Update SKU price by Error seller SKU numbers
    [Tags]   update_price_by_error_sellerSKU
    ${data}=    get_error_seller_sku_update_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400

Test Update Minus SKU price by seller SKU numbers
    [Tags]   update_minus_price_by_sellerSKU
    ${data}=    get_seller_sku_update_minus_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400

Test Update Exceed SKU price by seller SKU numbers
    [Tags]   update_exceed_price_by_sellerSKU
    ${data}=    get_seller_sku_update_exceed_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400

Test Update Invalid SKU price by seller SKU numbers
    [Tags]   update_invalid_price_by_sellerSKU
    ${data}=    get_seller_sku_update_invalid_price
    ${response}    Send Post Request      ${base_url}   ${update_price_by_sellerSKU}  ${data}   expected_status=400

