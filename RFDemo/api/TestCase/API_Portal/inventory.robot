*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Suite Setup          Run Keywords    Initial Env Data - API-Portal

*** Test Cases ***
Test Get Inventory By SKU
    [Tags]   get_sku_invenroty     smoke
    [Documentation]     get a listing inventory info by master sku
    ${url}    merge_urls    ${base_url}     ${get_sku_inventory}
    ${data}=     get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${response}    Send Get Request     ${url}    ${sku_num}
    ${status_code}     get_status_code    ${response.json()}
    should be equal as integers     ${status_code}      200


Test Update Inventory
    [Tags]   update_invenroty      smoke
    [Documentation]     update listing inventory by sub sku
    ${data}=    get_update_inventory_data
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal as integers     ${status_code}      200

Test Update Inventory By ERROR Inventory
    [Tags]   update_invenroty_by_error_inventory
    [Documentation]     use valid sku and invalid quantity to update listing inventory
    ${data}=    get_update_inventory_data
    ${data0}    get from list       ${data}         0
    ${sku}      get from dictionary     ${data0}    skuNumber
    ${data_dict}=    create dictionary       skuNumber=${sku}      availableQuantity=abc
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}    expected_status=400

Test Update Inventory By -1 Inventory
    [Tags]   update_invenroty_by_-1_inventory
    [Documentation]     use valid sku and minus number to update listing inventory
    ${data}=    get_update_inventory_data
    ${data0}    get from list       ${data}         0
    ${sku}      get from dictionary     ${data0}    skuNumber
    ${data_dict}=    create dictionary       skuNumber=${sku}      availableQuantity=-1
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}        expected_status=400

Test Update Inventory By Exceed Inventory
    [Tags]   update_invenroty_by_exceed_inventory
    [Documentation]     use valid sku and exceed number to update listing inventory
    ${data}=    get_update_inventory_data
    ${data0}    get from list       ${data}         0
    ${sku}      get from dictionary     ${data0}    skuNumber
    ${data_dict}=    create dictionary       skuNumber=${sku}      availableQuantity=999999999999999
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request     ${base_url}    ${update_inventory}  ${data}        expected_status=400

Test Update 100 Inventory
    [Tags]   update_100_invenroty       MKP-4287
    [Documentation]     test if limit update 100 listings at once function
    ${data}=    get_hundred_update_inventory_data
    ${response1}    Send Post Request     ${base_url}    ${update_inventory}  ${data}        expected_status=400
    remove from list  ${data}   0
    ${response2}    Send Post Request     ${base_url}    ${update_inventory}  ${data}        expected_status=any
    should not be equal as strings          ${response1.json()}         ${response2.json()}



Test Get store inventories in batch by SKU numbers
    [Tags]   get_batch_inventory    smoke
    [Documentation]     get numbers of listings' inventory info by sub sku
    ${data}=    get_batch_sku
    ${response}    Send Post Request      ${base_url}   ${get_batch_inventory}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Get store inventories in batch by Master SKU numbers
    [Tags]   get_batch_inventory_by_master_sku
    [Documentation]     get numbers of listings' inventory info by master sku
    ${master_sku_list}=    get_bantch_master_sku
    ${sku_list_length}      get length      ${master_sku_list}
    ${data}         create dictionary       skuNumbers=${master_sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_batch_inventory}  ${data}
    ${data_list}       get from dictionary      ${response.json()}      data
    ${data_list_length}     get length      ${data_list}
    should be equal as integers     ${sku_list_length}      ${data_list_length}

Test Get store inventories in batch by Error SKU numbers
    [Tags]   get_error_batch_inventory
    [Documentation]     get numbers of listings' inventory info by error sku list
    ${sku_list}=      create list       123     456     789
    ${sku_list_length}      get length      ${sku_list}
    ${data}=    create dictionary       skuNumbers=${sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_batch_inventory}  ${data}
    ${data_list}       get from dictionary      ${response.json()}      data
    ${data_list_length}     get length      ${data_list}
    should be equal as integers     ${sku_list_length}      ${data_list_length}



Test Get store inventories in batch by seller SKU numbers
    [Tags]   get_inventory_by_sellerSKU    smoke
    [Documentation]     get numbers of listings' inventory info by seller sku
    ${data}=    tools.get_seller_sku
    ${seller_sku_list}      get from dictionary        ${data}          sellerSkuNumbers
    ${seller_sku_list_len}      get length      ${seller_sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_inventory_by_sellerSKU}  ${data}
    ${data_list}    get from dictionary     ${response.json()}      data
    ${data_list_len}      get length        ${data_list}
    should be equal as integers         ${seller_sku_list_len}      ${data_list_len}

Test Get store inventories in batch by Error seller SKU numbers
    [Tags]   get_inventory_by_error_sellerSKU
    [Documentation]     get numbers of listings' inventory info by invalid seller sku
    ${data}=    tools.get_seller_sku
    ${seller_sku_list}      get from dictionary        ${data}          sellerSkuNumbers
    append to list          ${seller_sku_list}      abcd
    append to list          ${seller_sku_list}      0000
    ${seller_sku_list_len}      get length      ${seller_sku_list}
    ${data}=        create dictionary       sellerSkuNumbers=${seller_sku_list}
    ${response}    Send Post Request      ${base_url}   ${get_inventory_by_sellerSKU}  ${data}
    ${data_list}    get from dictionary     ${response.json()}      data
    ${data_list_len}      get length        ${data_list}
    should be equal as integers         ${seller_sku_list_len}      ${data_list_len}

Test Get 100 SKU inventory by seller SKU numbers
    [Tags]   get_hundred_inventory_by_sellerSKU         MKP-4287
    [Documentation]     test if limitation of get inventory by seller sku work well
    ${data}=    get_hundred_seller_sku
    ${seller_sku_list}    get from dictionary     ${data}     sellerSkuNumbers
    ${seller_sku}       get from list   ${seller_sku_list}      0
    append to list      ${seller_sku_list}      ${seller_sku}
    ${data}     create dictionary       sellerSkuNumbers=${seller_sku_list}
    ${response1}    Send Post Request      ${base_url}   ${get_inventory_by_sellerSKU}  ${data}     expected_status=400
    remove from list   ${seller_sku_list}    0
    ${data}     create dictionary       sellerSkuNumbers=${seller_sku_list}
    ${response2}    Send Post Request      ${base_url}   ${get_inventory_by_sellerSKU}  ${data}     expected_status=any
    should not be equal as strings   ${response1.json()}      ${response2.json()}



Test Update inventory by seller SKU numbers
    [Tags]   update_inventory_by_sellerSKU    smoke
    [Documentation]     update inventory of listing by seller sku
    ${data}=    get_seller_sku_update_invenroty
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Update Exceed inventory by seller SKU numbers
    [Tags]   update_exceed_inventory_by_sellerSKU
    [Documentation]     use exceed number of quantity to update inventory of listing by seller sku
    ${data}=    get_seller_sku_update_invenroty
    ${data0}    get from list       ${data}         0
    ${seller_sku}      get from dictionary     ${data0}    sellerSkuNumber
    ${data_dict}=    create dictionary       sellerSkuNumber=${seller_sku}      availableQuantity=999999999999999
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400

Test Update -1 inventory by seller SKU numbers
    [Tags]   update_-1_inventory_by_sellerSKU
    [Documentation]     use minus number of quantity to update inventory of listing by seller sku
    ${data}=    get_seller_sku_update_invenroty
    ${data0}    get from list       ${data}         0
    ${seller_sku}      get from dictionary     ${data0}    sellerSkuNumber
    ${data_dict}=    create dictionary       sellerSkuNumber=${seller_sku}      availableQuantity=-1
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400

Test Update Error inventory by seller SKU numbers
    [Tags]   update_error_inventory_by_sellerSKU
    [Documentation]     use invalid number of quantity to update inventory of listing by seller sku
    ${data}=    get_seller_sku_update_invenroty
    ${data0}    get from list       ${data}         0
    ${seller_sku}      get from dictionary     ${data0}    sellerSkuNumber
    ${data_dict}=    create dictionary       sellerSkuNumber=${seller_sku}      availableQuantity=abc
    ${data}=        create list         ${data_dict}
    ${response}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400

Test Update 100 inventory by seller SKU numbers
    [Tags]   update_100_inventory_by_sellerSKU      MKP-4287
    [Documentation]     test if limitation of update invenroty by seller sku work well
    ${data}=    get_hunderd_seller_sku_update_invenroty
    ${response1}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=400
    remove from list  ${data}   0
    ${response2}    Send Post Request      ${base_url}   ${update_inventory_by_sellerSKU}  ${data}   expected_status=any
    should not be equal as strings          ${response1.json()}         ${response2.json()}

