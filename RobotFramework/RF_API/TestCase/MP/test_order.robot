*** Settings ***
Resource            ../../Keywords/MP/OrderFlowKeywords.robot
Suite Setup          Run Keywords    Initial Env Data
...                                  AND    Set Initial Data - Order
Suite Teardown       Delete All Sessions

*** Variables ***


*** Test Cases ***
Test place order
    [Tags]  test_order
    Get Buyer Shipping Cart Id - GET
    Get Store Listing List - GET  False
    ${sku_number}   get from dictionary   ${active_listing[0]}   sku
    ${quantity}   EVALUATE  random.choice(range(1, 5))
    ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}   ${null}   ${quantity}
#    ${quantity}  Update Item Quantity On Shipping Cart - PUT   ${cart_item_id}  quantity=1
    ${product_ifno}  Create Dictionary  sku=${sku_number}   quantity=${quantity}   shoppingItemId=${cart_item_id}
    ${product_info_list}  Create List
    Append To List  ${product_info_list}  ${product_ifno}
    Shipping Checkout Summary - POST   ${seller_store_id}   ${product_info_list}
    Listing Checkout Initiate - POST   ${shipping_method_res}
    Get Wallet Bankcard - GET
    Checkout Submit Order - POST


Test place order with variation
    [Tags]  test_order_with_varition
    Get Store Listing List - GET   True
    ${sku_number}   get from dictionary   ${active_listing[0]}   sku
    ${product_detail}  Get Product Detail By Sku - POST  ${sku_number}
    ${sub_sku_number}  Get Json Value  ${product_detail}    data   subListings    skuNumber
    Get Buyer Shipping Cart Id - GET
    ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}    ${sub_sku_number}  1
    ${quantity}  Update Item Quantity On Shipping Cart - PUT   ${cart_item_id}  quantity=2
    ${product_ifno}  Create Dictionary  sku=${sub_sku_number}   quantity=${quantity}   shoppingItemId=${cart_item_id}
    ${product_info_list}  Create List
    Append To List  ${product_info_list}  ${product_ifno}
    Shipping Checkout Summary - POST   ${seller_store_id}   ${product_info_list}
    Listing Checkout Initiate - POST   ${shipping_method_res}
    Get Wallet Bankcard - GET
    Checkout Submit Order - POST


Test place order with multi product
    [Tags]  test_order_with_multi_product
    Get Buyer Shipping Cart Id - GET
    Get Store Listing List - GET   ${null}
    ${product_info_list}  Create List
    ${index}   set variable    0
    FOR   ${item}  IN   @{active_listing}
        ${sku_number}   get from dictionary   ${item}   sku
        ${product_detail}  Get Product Detail By Sku - POST  ${sku_number}
        ${sub_sku_number}  Get Json Value  ${product_detail}    data   subListings    skuNumber
        ${quantity}   EVALUATE  random.choice(range(1, 5))
        ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}  ${sub_sku_number}  ${quantity}
        ${sku}  Evaluate  (${sub_sku_number} if ${sub_sku_number} else ${sku_number})
        ${product_ifno}  Create Dictionary  sku=${sku}   quantity=${quantity}   shoppingItemId=${cart_item_id}
        Append To List  ${product_info_list}  ${product_ifno}
        ${index}    evaluate    ${index}+1
        EXIT FOR LOOP IF   ${index}==3
    END
    Shipping Checkout Summary - POST   ${seller_store_id}   ${product_info_list}
    Listing Checkout Initiate - POST   ${shipping_method_res}
    Get Wallet Bankcard - GET
    Checkout Submit Order - POST


Test send retrun request
    [Tags]  send_return_request
    ${res}   Get Buyer Order Detail - GET   8149961643104893
    Buyer Return Order - POST   ${res}


Test place order by sku
    [Tags]  place_order_by_sku
    Get Buyer Shipping Cart Id - GET
    ${sku_number_list}  create list  6025924328444436480   6025948345901146112   6025963601625391110
    ${product_info_list}  Create List
    FOR   ${sku_number}  IN   @{sku_number_list}
        log  ${sku_number}
        ${product_detail}  Get Product Detail By Sku - POST  ${sku_number}
        ${sub_sku_number}  Get Json Value  ${product_detail}    data   subListings    skuNumber
        ${quantity}   EVALUATE  random.choice(range(1, 5))
        ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}  ${sub_sku_number}  ${quantity}
        ${sku}  Evaluate  (${sub_sku_number} if ${sub_sku_number} else ${sku_number})
        ${product_ifno}  Create Dictionary  sku=${sku}   quantity=${quantity}   shoppingItemId=${cart_item_id}
        Append To List  ${product_info_list}  ${product_ifno}
    END
    Shipping Checkout Summary - POST   ${seller_store_id}   ${product_info_list}
    Listing Checkout Initiate - POST   ${shipping_method_res}
    Get Wallet Bankcard - GET
    Checkout Submit Order - POST


Test for loop
    [Tags]  test_for_loop
    FOR  ${index}  IN RANGE  10
        log  ${index}
    END
