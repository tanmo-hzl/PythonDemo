*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Suite Setup          Run Keywords    Initial Env Data - API-Portal


*** Test Cases ***
#Test Exceed frequency get taxonomy list
#    [Tags]   get_exceed_frequency_taxonomy_list     MKP-3795
#    ${status}    get_exceed_request    ${base_url}   ${get_taxonomy_list}    ${api_key}     20
#    should be equal as integers         ${status}       429
#
#Test Get taxonomy specific attributes
#    [Tags]   get_exceed_frequency_taxonomy_attr    MKP-3795
#    ${data}=    tools.get_taxonomy_path
#    ${status}    get_exceed_request   ${base_url}    ${get_taxonomy_attr}     ${api_key}   60   ${data}
#    should be equal as integers         ${status}       429
#
#Test Create exceed frequency listing
#    [Tags]   create_exceed_frequency_listing      MKP-3795
#    ${status}    get_exceed_create_listing      ${base_url}   ${create_listing}  ${api_key}   10
#    should be equal as integers         ${status}       429
##
#Test Update exceed frequency listing
#    [Tags]   update_exceed_frequency_listing     MKP-3795
#    ${data}=    get_primary_sku_num
#    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
#    ${url}=        merge_urls    ${update_listing}     ${sku_num}
#    ${data}=    get_update_listing_data
#    ${status}    put_exceed_request  ${base_url}   ${url}  ${api_key}   20    ${data}
#    should be equal as integers         ${status}       429
#
#Test Update exceed frequency price by seller SKU numbers
#    [Tags]   update_exceed_frequency_price_by_sellerSKU    MKP-3795
#    ${data}    get_seller_sku_update_price
#    ${status}    post_exceed_request     ${base_url}   ${update_price_by_sellerSKU}     ${api_key}   10  ${data}
#    should be equal as integers         ${status}       429
#
#Test Update exceed frequency inventory by seller SKU numbers
#    [Tags]   update_exceed_frequency_inventory_by_sellerSKU    MKP-3795
#    ${data}=    get_seller_sku_update_invenroty
#    ${status}    post_exceed_request     ${base_url}   ${update_inventory_by_sellerSKU}   ${api_key}   10  ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency one listing
#    [Tags]   get_exceed_frequency_listing     MKP-3795
#    ${data}=    get_primary_sku_num
#    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
#    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
#    ${status}    get_exceed_request     ${base_url}     ${url}        ${api_key}   100
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency bantch listing
#    [Tags]   get_exceed_frequency_bantch_listing      MKP-3795
#    ${data}=    get_bantch_listing_data
#    ${status}    post_exceed_request  ${base_url}   ${get_bantch_lisiting}    ${api_key}   60    ${data}
#    should be equal as integers         ${status}       429
#
#Test Export exceed frequency listings
#    [Tags]   export_exceed_frequency_template_listing     MKP-3795
#    ${data}=    get_export_listing_data
#    ${status}    post exceed request     ${base_url}   ${export_template_listing}     ${api_key}   60  /  ${data}
#    should be equal as integers         ${status}       429
#
#Test Query exceed frequency listings
#    [Tags]   query_exceed_frequency_listing     MKP-3795
#    ${data}=    get_query_listing_data
#    ${status}    get exceed request     ${base_url}       ${query_listing}      ${api_key}      60     ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency listings by seller SKU numbers
#    [Tags]   get_exceed_frequency_listing_by_seller_sku     MKP-3795
#    ${seller_sku_data}=      tools.Get Seller Sku
#    ${data}=    get from dictionary         ${seller_sku_data}      sellerSkuNumbers
#    ${status}    post exceed request  ${base_url}   ${get_lisiting_by_seller_sku}       ${api_key}      60      ${data}
#    should be equal as integers         ${status}       429
#
#Test Activate exceed frequency listings
#    [Tags]   activate_exceed_frequency_listing      MKP-3795
#    ${data}=    get_activate_listing_data
#    ${status}    post exceed request      ${base_url}   ${activate_listing}     ${api_key}      120    ${data}
#    should be equal as integers         ${status}       429
#
#Test Deactivate exceed frequency listings
#    [Tags]   deactivate_exceed_frequency_listing     MKP-3795
#    ${data}=    get_deactivate_listing_data
#    ${status}    post exceed request      ${base_url}   ${deactivate_listing}     ${api_key}      120   ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency Inventory By SKU
#    [Tags]   get_exceed_frequency_sku_invenroty     MKP-3795
#    ${url}    merge_urls    ${base_url}     ${get_sku_inventory}
#    ${data}=     get_primary_sku_num
#    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
#    ${status}    get exceed request     ${url}      ${sku_num}     ${api_key}      120
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency inventories in batch by SKU numbers
#    [Tags]   get_exceed_frequency_batch_inventory    MKP-3795
#    ${data}=    get_batch_sku
#    ${status}    post exceed request    ${base_url}   ${get_batch_inventory}    ${api_key}      20      ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency inventories in batch by seller SKU numbers
#    [Tags]   get_exceed_frequency_inventory_by_sellerSKU    MKP-3795
#    ${data}=    tools.get_seller_sku
#    ${status}    post exceed request      ${base_url}   ${get_inventory_by_sellerSKU}     ${api_key}   60  ${data}
#    should be equal as integers         ${status}       429
#
#Test Update exceed frequency Inventory
#    [Tags]   update_exceed_frequency_invenroty      MKP-3795
#    ${data}=    get_update_inventory_data
#    ${status}    post exceed request     ${base_url}    ${update_inventory}    ${api_key}   20  ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency price by SKU number
#    [Tags]   get_exceed_frequency_sku_price     MKP-3795
#    ${url}    merge_urls    ${base_url}     ${get_sku_price}
#    ${data}=     get_primary_sku_num
#    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
#    ${status}    get exceed request     ${url}      ${sku_num}      ${api_key}   60
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency price in batch by SKU numbers
#    [Tags]   get_exceed_frequency_batch_price      MKP-3795
#    ${data_dict}=    get_batch_sku
#    ${sku_list}=       get from dictionary      ${data_dict}         skuNumbers
#    ${data}=        create dictionary       skuNumbers=${sku_list}
#    ${status}    post exceed request    ${base_url}    ${get_batch_price}     ${api_key}   20  ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency price by seller SKU numbers
#    [Tags]   get_exceed_frequency_price_by_sellerSKU    MKP-3795
#    ${data}=    tools.get_seller_sku
#    ${sku_list}     get from dictionary     ${data}     sellerSkuNumbers
#    ${sku_list_length}      get length     ${sku_list}
#    ${status}    post_exceed_request      ${base_url}   ${get_price_by_sellerSKU}   ${api_key}   60   ${data}
#    should be equal as integers         ${status}       429
#
#Test Update exceed frequency SKU price
#    [Tags]   update_exceed_frequency_sku_price    MKP-3795
#    ${data}=    get_update_price
#    ${status}    post exceed request      ${base_url}   ${update_sku_price}      ${api_key}   10  ${data}
#    should be equal as integers         ${status}       429
#
#Test Upload exceed frequency Media
#    [Tags]   upload_exceed_frequency_media    MKP-3795
#    ${status}    post_exceed_media    ${base_url}   ${upload_media}    ${api_key}     20
#    should be equal as integers         ${status}       429
#
#Test Query exceed frequency orders
#    [Tags]   query_exceed_frequency_order     MKP-3795
#    ${data}=    get_query_order_data
#    ${status}    get exceed request      ${base_url}         ${query_order}    ${api_key}     60    ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency order by order number
#    [Tags]   get_exceed_frequency_order      MKP-3795
#    ${order_num}=    get_order_num
#    ${url}=     merge urls  ${base_url}    ${get_order}
#    ${status}       get exceed request     ${url}   ${order_num}        ${api_key}     60
#    should be equal as integers         ${status}       429
#
#Test Ready exceed frequency ship an order
#    [Tags]   ready_exceed_frequency_order      MKP-3795
#    ${data}=    get_ready_order
#    ${order_num_list}=      get from dictionary     ${data}     orderNumbers
#    ${status}     post exceed request    ${base_url}    ${ready_order}      ${api_key}     120   ${data}
#    should be equal as integers         ${status}       429
#
#Test Add exceed frequency shipment to order items
#    [Tags]   add_exceed_frequency_shipment_item      MKP-3795
#    ${data}=    get_shipment_item
#    ${order_num}=      get from dictionary     ${data}     orderNumber
#    ${status}   post exceed request    ${base_url}    ${add_shipment_item}      ${api_key}     120    ${data}
#    should be equal as integers         ${status}       429
#
#Test Cancel exceed frequency order
#    [Tags]   cancel_exceed_frequency_order      MKP-3795
#    ${data}=    get_cancel_order
#    ${order_num}=      get from dictionary     ${data}     orderNumber
#    ${status}      post exceed request    ${base_url}    ${cancel_order}      ${api_key}     60   ${data}
#    should be equal as integers         ${status}       429
#
#Test Query exceed frequency return requests
#    [Tags]   query_exceed_frequency_return      MKP-3795
#    ${data}=    get_query_return
#    ${status}    get exceed request    ${base_url}    ${query_return}    ${api_key}     30     ${data}
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency by return number
#    [Tags]   get_exceed_frequency_by_return_num       MKP-3795
#    ${return_order_num}=    get_return_order_num
#    ${url}=     merge urls      ${base_url}        ${get_retun_by_return_num}
#    ${status}   get exceed request         ${url}      ${return_order_num}      ${api_key}     120
#    should be equal as integers         ${status}       429
#
#Test Get exceed frequency by order number
#    [Tags]   get_exceed_frequency_by_order_num      MKP-3795
#    ${return_order_num}=    get_return_by_order_num
#    ${url}=     merge urls      ${base_url}        ${get_retun_by_order_num}
#    ${status}   get exceed request       ${url}      ${return_order_num}       ${api_key}     120
#    should be equal as integers         ${status}       429
#
#Test Approve exceed frequency to refund
#    [Tags]   approve_exceed_frequency_refund      MKP-3795
#    ${data}=    get_approve_refund
##    ${return_order_num}=    get from dictionary     ${data}     returnOrderNumber
#    ${return_order_num}=    get from dictionary     ${data}     returnNumber
#    ${status}    post exceed request   ${base_url}    ${approve_refund}     ${api_key}     60   ${data}
#    should be equal as integers         ${status}       429
#
#Test Reject exceed frequency to refund
#    [Tags]   reject_exceed_frequency_refund           MKP-3795
#    ${data}=    get_reject_refund
##    ${return_order_num}=    get from dictionary     ${data}     returnOrderNumber
#    ${return_order_num}=    get from dictionary     ${data}     returnNumber
#    ${status}      post exceed request    ${base_url}    ${reject_refund}   ${api_key}    60     ${data}
#    should be equal as integers         ${status}       429


Test Create listings by upload exceed template file
    [Tags]   create_exceed_template_listing
    ${status}    post_exceed_template    ${base_url}   ${create_template_listing}    ${api_key}   6
