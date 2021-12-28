*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot


*** Test Cases ***
Test Get Inventory By SKU
    [Tags]   get_sku_invenroty     smoke
    ${url}    merge_urls    ${base_url}     ${get_sku_inventory}
    ${data}=     get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${response}    Send Get Request     ${url}    ${sku_num}
    ${status_code}     get_status_code    ${response.json()}
    should be equal as integers     ${status_code}      200

Test Get Inventory By ERROR SKU
    [Tags]   get_error_sku_invenroty
    ${url}    merge_urls    ${base_url}     ${get_sku_inventory}
    ${sku_num}=   set variable    abc
    ${response}    Send Get Request     ${url}    ${sku_num}
    ${res}      get from dictionary     ${response.json()}        data
    ${inventory}        get from dictionary     ${res}         skuInventories
    should be empty     ${inventory}

Test Get Inventory Sub SKU
    [Tags]   get_sub_sku_invenroty
    ${url}    merge_urls    ${base_url}     ${get_sku_inventory}
    ${sub_sku_num}=   get_variation_sub_sku
    ${response}    Send Get Request     ${url}    ${sub_sku_num}
    ${res}      get from dictionary     ${response.json()}        data
    ${inventory}        get from dictionary     ${res}         skuInventories
    should be empty     ${inventory}



Test Update Inventory
    [Tags]   update_invenroty      smoke
    ${data}=    get_update_inventory_data
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal as integers     ${status_code}      200

Test Update Inventory By Master SKU
    [Tags]   update_invenroty_by_master_sku
    ${data}=    get_update_inventory_data_by_master_sku
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}       expected_status=400

Test Update Inventory By ERROR SKU
    [Tags]   update_invenroty_by_error_sku
    ${data_dict}=    create dictionary       skuNumber=123      availableQuantity=100
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}    expected_status=400

Test Update Inventory By ERROR Inventory
    [Tags]   update_invenroty_by_error_inventory
    ${data}=    get_update_inventory_data
    ${data0}    get from list       ${data}         0
    ${sku}      get from dictionary     ${data0}    skuNumber
    ${data_dict}=    create dictionary       skuNumber=${sku}      availableQuantity=abc
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}    expected_status=400

Test Update Inventory By -1 Inventory
    [Tags]   update_invenroty_by_-1_inventory
    ${data}=    get_update_inventory_data
    ${data0}    get from list       ${data}         0
    ${sku}      get from dictionary     ${data0}    skuNumber
    ${data_dict}=    create dictionary       skuNumber=${sku}      availableQuantity=-1
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}        expected_status=400

Test Update Inventory By Exceed Inventory
    [Tags]   update_invenroty_by_exceed_inventory
    ${data}=    get_update_inventory_data
    ${data0}    get from list       ${data}         0
    ${sku}      get from dictionary     ${data0}    skuNumber
    ${data_dict}=    create dictionary       skuNumber=${sku}      availableQuantity=999999999999999
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}        expected_status=400



Test Get store inventories in batch by SKU numbers
    [Tags]   get_batch_inventory    smoke
    ${data}=    get_batch_sku
    ${response}    Send Post Request      ${base_url}   ${get_batch_inventory}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Get store inventories in batch by Master SKU numbers
    [Tags]   get_batch_inventory_by_master_sku
    ${master_sku_list}=    get_bantch_master_sku
    ${data}         create dictionary       skuNumbers=${master_sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_batch_inventory}  ${data}
    ${inventory_list}=     get from dictionary      ${response.json()}      data
    should be empty     ${inventory_list}

Test Get store inventories in batch by Error SKU numbers
    [Tags]   get_error_batch_inventory
    ${sku_list}=      create list       123     456     789
    ${data}=    create dictionary       skuNumbers=${sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_batch_inventory}  ${data}
    ${inventory_list}=     get from dictionary      ${response.json()}      data
    should be empty     ${inventory_list}



Test Get store inventories in batch by seller SKU numbers
    [Tags]   get_inventory_by_sellerSKU    smoke
    ${data}=    tools.get_seller_sku
    ${seller_sku_list}      get from dictionary        ${data}          sellerSkuNumbers
    ${seller_sku_list_len}      get length      ${seller_sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_inventory_by_sellerSKU}  ${data}
    ${data_list}    get from dictionary     ${response.json()}      data
    ${data_list_len}      get length        ${data_list}
    should be equal as integers         ${seller_sku_list_len}      ${data_list_len}

Test Get store inventories in batch by Error seller SKU numbers
    [Tags]   get_inventory_by_error_sellerSKU
    ${data}=    tools.get_seller_sku
    ${seller_sku_list}      get from dictionary        ${data}          sellerSkuNumbers
    ${seller_sku_list_len}      get length      ${seller_sku_list}
    append to list          ${seller_sku_list}      abcd
    append to list          ${seller_sku_list}      0000
    ${data}=        create dictionary       sellerSkuNumbers=${seller_sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_inventory_by_sellerSKU}  ${data}
    ${data_list}    get from dictionary     ${response.json()}      data
    ${data_list_len}      get length        ${data_list}
    should be equal as integers         ${seller_sku_list_len}      ${data_list_len}



Test Update inventory by seller SKU numbers
    [Tags]   update_inventory_by_sellerSKU    smoke
    ${data}=    get_seller_sku_update_invenroty
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Update inventory by Error seller SKU numbers
    [Tags]   update_inventory_by_error_sellerSKU
    ${data_dict}=    create dictionary       sellerSkuNumber=123      availableQuantity=100
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400

Test Update Exceed inventory by seller SKU numbers
    [Tags]   update_exceed_inventory_by_sellerSKU
    ${data}=    get_seller_sku_update_invenroty
    ${data0}    get from list       ${data}         0
    ${seller_sku}      get from dictionary     ${data0}    sellerSkuNumber
    ${data_dict}=    create dictionary       sellerSkuNumber=${seller_sku}      availableQuantity=999999999999999
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400

Test Update -1 inventory by seller SKU numbers
    [Tags]   update_-1_inventory_by_sellerSKU
    ${data}=    get_seller_sku_update_invenroty
    ${data0}    get from list       ${data}         0
    ${seller_sku}      get from dictionary     ${data0}    sellerSkuNumber
    ${data_dict}=    create dictionary       sellerSkuNumber=${seller_sku}      availableQuantity=-1
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400

Test Update Error inventory by seller SKU numbers
    [Tags]   update_error_inventory_by_sellerSKU
    ${data}=    get_seller_sku_update_invenroty
    ${data0}    get from list       ${data}         0
    ${seller_sku}      get from dictionary     ${data0}    sellerSkuNumber
    ${data_dict}=    create dictionary       sellerSkuNumber=${seller_sku}      availableQuantity=abc
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400

