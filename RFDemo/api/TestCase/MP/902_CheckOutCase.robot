*** Settings ***
Resource            ../../Keywords/MP/OrderFlowKeywords.robot
Suite Setup          Run Keywords    Initial Env Data
...                                  AND    Set Initial Data - Order
Suite Teardown       Delete All Sessions

*** Variables ***


*** Test Cases ***
Test place order
    [Documentation]  byer random place order
    [Tags]  mp-ea
    Get Store Listing List - GET  False
    ${sku_number}   get from dictionary   ${active_listing[0]}   sku
    ${product_detail}  Get Product Detail By Sku - POST  ${sku_number}
    ${store_id}  Get Json Value  ${product_detail}    data  listing   sellerStoreId
    ${price}  Get Json Value  ${product_detail}    data   listing    price
    ${quantity}   EVALUATE  random.choice(range(1, 5))
    Get Buyer Shipping Cart Id - GET
    ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}   ${null}   ${quantity}
#    ${quantity}  Update Item Quantity On Shipping Cart - PUT   ${cart_item_id}  quantity=1
    ${product_ifno}  Create Dictionary  sku=${sku_number}  price=${price}  quantity=${quantity}   shoppingItemId=${cart_item_id}   StoreId=${store_id}
    ${product_info_list}  Create List
    Append To List  ${product_info_list}  ${product_ifno}
    Get Wallet Bankcard - GET
    Get User Default Address - GET
    Pre-initiate - POST   ${product_info_list}
    Split Order And Initiate
    Submit Order - POST


Test place order with variation
    [Documentation]  buyre place order with variant product
    [Tags]  mp-ea
    Get Store Listing List - GET   True
    ${sku_number}   get from dictionary   ${active_listing[0]}   sku
    ${product_detail}  Get Product Detail By Sku - POST  ${sku_number}
    ${store_id}  Get Json Value  ${product_detail}    data  listing   sellerStoreId
    ${price}  Get Json Value  ${product_detail}    data   subListings    price
    ${sub_sku_number}  Get Json Value  ${product_detail}    data   subListings    skuNumber
    Get Buyer Shipping Cart Id - GET
    ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}    ${sub_sku_number}  1
    ${quantity}  Update Item Quantity On Shipping Cart - PUT   ${cart_item_id}  quantity=2
    ${product_ifno}  Create Dictionary  sku=${sub_sku_number}  price=${price}  quantity=${quantity}   shoppingItemId=${cart_item_id}   StoreId=${store_id}
    ${product_info_list}  Create List
    Append To List  ${product_info_list}  ${product_ifno}
    Get Wallet Bankcard - GET
    Get User Default Address - GET
    Pre-initiate - POST   ${product_info_list}
    Split Order And Initiate
    Submit Order - POST


Test place order with multi product
    [Documentation]  buyre place order with variant and no variant product
    [Tags]  mp-ea
    Get Buyer Shipping Cart Id - GET
    Get Store Listing List - GET   ${null}
    ${product_info_list}  Create List
    ${index}   set variable    0
    FOR   ${item}  IN   @{active_listing}
        ${sku_number}   get from dictionary   ${item}   sku
        ${product_detail}  Get Product Detail By Sku - POST  ${sku_number}
        ${store_id}  Get Json Value  ${product_detail}    data  listing   sellerStoreId
        ${sub_price}  Get Json Value  ${product_detail}    data   subListings    price
        ${mast_price}  Get Json Value  ${product_detail}    data   listing    price
        ${sub_sku_number}  Get Json Value  ${product_detail}    data   subListings    skuNumber
        ${quantity}   EVALUATE  random.choice(range(1, 5))
        ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}  ${sub_sku_number}  ${quantity}
        ${sku}  Evaluate  (${sub_sku_number} if ${sub_sku_number} else ${sku_number})
        ${price}  Evaluate  (${mast_price} if ${mast_price} else ${sub_price})
        ${product_ifno}  Create Dictionary  sku=${sku}  price=${price}  quantity=${quantity}   shoppingItemId=${cart_item_id}   StoreId=${store_id}
        Append To List  ${product_info_list}  ${product_ifno}
        ${index}    evaluate    ${index}+1
        EXIT FOR LOOP IF   ${index}==2
    END
    Get Wallet Bankcard - GET
    Get User Default Address - GET
    Pre-initiate - POST   ${product_info_list}
    Split Order And Initiate
    Submit Order - POST


Test place order by sku
    [Tags]  place_order_by_sku
    Get Buyer Shipping Cart Id - GET
    # qa  6129192281591316480
    ${sku_number_list}  create list    6129207434235551744  6129220559655608320   6129236021538258944  6215103172383014912
#    ${sku_number_list}  create list    6215103172383014912
    # stg
#    ${sku_number_list}  create list     6108693983235063808  6108711163104247808  6108733840531562496  6108691440614424576
    # aps
#    ${sku_number_list}  create list  6140928777943425024   5980974334595825664   5980984848675766272  5980998352052600832
    ${product_info_list}  Create List
    FOR   ${sku_number}  IN   @{sku_number_list}
        ${product_detail}  Get Product Detail By Sku - POST  ${sku_number}
        ${store_id}  Get Json Value  ${product_detail}    data  listing   sellerStoreId
        ${sub_price}  Get Json Value  ${product_detail}    data   subListings    price
        ${mast_price}  Get Json Value  ${product_detail}    data   listing    price
        ${sub_sku_number}  Get Json Value  ${product_detail}    data   subListings    skuNumber
        ${quantity}   EVALUATE  random.choice(range(1, 5))
        ${cart_item_id}  Add Items To Buyer Shipping Cart - POST   ${sku_number}  ${sub_sku_number}  ${quantity}
        ${sku}  Evaluate  (${sub_sku_number} if ${sub_sku_number} else ${sku_number})
        ${price}  Evaluate  (${mast_price} if ${mast_price} else ${sub_price})
        ${product_ifno}  Create Dictionary  sku=${sku}  price=${price}  quantity=${quantity}   shoppingItemId=${cart_item_id}   StoreId=${store_id}
        Append To List  ${product_info_list}  ${product_ifno}
    END
    Get Wallet Bankcard - GET
    Get User Default Address - GET
    log  ${product_info_list}
    Pre-initiate - POST   ${product_info_list}
    Split Order And Initiate
    Submit Order - POST


Test for loop
    [Tags]  test_for_loop
    FOR  ${index}  IN RANGE  10
        Test place order by sku
    END