*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyOrderFlow.py
Resource            ../../TestData/MP/PathOrderFlow.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller_info_sign}
${buyer_info_sign}
${seller_store_id}
${seller_headers}
${seller_headers_post}
${buyer_headers}
${buyer_headers_post}
${active_listing}
${sku_number}
${buyer_id}
${buyer_name}
${buyer_shipping_cart_id}
${cart_item_id}
${wallet_bankcard}
${checkout_initiat_data}
${seller_order_detail}
${buyer_order_detail}
${parent_order_number}
${sub_order_number}
${order_item_id}
${quantity}
${keyword_order_numbers}
${seller_return_order}
${return_order_number}
${seller_return_order_detail}
${seller-account}


*** Keywords ***
Set Initial Data - Order
    Mik Seller Sign In Scuse Of Order - POST    ${seller-account}
    ${seller_headers}    Set Get Headers - Seller
    Set Suite Variable    ${seller_headers}    ${seller_headers}
    ${seller_headers_post}    Set Post Headers - Seller
    Set Suite Variable    ${seller_headers_post}    ${seller_headers_post}
    ${seller_info_sign}    Set Variable     ${null}
    ${seller_info_sign}    Run Keyword If    '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
    Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}
    ${seller_store_id}    Get Json Value    ${seller_info_sign}    sellerStoreProfile    sellerStoreId
    Set Suite Variable    ${seller_store_id}    ${seller_store_id}

    Mik Buyer Sign In Scuse - POST
    ${buyer_headers}    Set Get Headers - Buyer
    Set Suite Variable    ${buyer_headers}    ${buyer_headers}
    ${buyer_headers_post}    Set Post Headers - Buyer
    Set Suite Variable    ${buyer_headers_post}    ${buyer_headers_post}
    ${buyer_info_sign}    Set Variable     ${null}
    ${buyer_info_sign}    Run Keyword If    '${buyer_info_sign}'=='None'    Read File    buyer-info-sign     ELSE    Set Variable    ${buyer_info_sign}
    Set Suite Variable    ${buyer_info_sign}    ${buyer_info_sign}
    ${buyer_id}    Get Json Value    ${buyer_info_sign}    user    id
    Set Suite Variable    ${buyer_id}    ${buyer_id}
    ${first_name}    Get Json Value    ${buyer_info_sign}    user    firstName
    ${last_name}    Get Json Value    ${buyer_info_sign}    user    lastName
    Set Suite Variable    ${buyer_name}    ${first_name} ${last_name}

Get Store Listing List - GET
    [Arguments]  ${variation}
    ${res}    Send Get Request    ${url-mik}    /store/${seller_store_id}/listings    ${null}    ${seller_headers}
    ${listings}    Get Json Value    ${res.json()}    listings
    ${active_listing}    Get Active Listing    ${listings}   variation=${variation}
    Save File    active-listing    ${active_listing}
    Set Suite Variable    ${Active_Listing}    ${active_listing}

Get Product Detail By Sku - POST
#    ${sku_number}    Get Json Value    ${active_listing}    sku
#    Set Suite Variable    ${sku_number}    ${sku_number}
    [Arguments]   ${sku_number}
    ${body}    Get Product Detail Body    ${sku_number}
    ${res}    Send Get Request    ${url-mik}    /store/${seller_store_id}/listingInfo/${sku_number}   ${null}   ${seller_headers}
    [Return]  ${res.json()}

Get Buyer Shipping Cart Id - GET
    ${body}    Create Dictionary    userId=${buyer_id}    channel=RETAIL
    ${res}    Send Get Request    ${url-mik}    ${mik-user-cart}    ${body}    ${buyer_headers}
    ${buyer_shipping_cart_id}    Get Json Value    ${res.json()}    shoppingCartId
    Set Suite Variable    ${buyer_shipping_cart_id}    ${buyer_shipping_cart_id}

Get Buyer Shipping Cart Items List - GET
    ${res}    Send Get Request    ${url-mik}    ${mik-cart-items}/${buyer_shipping_cart_id}/cart-items    ${null}    ${buyer_headers}
    [Return]   ${res.json()}

Add Items To Buyer Shipping Cart - POST
    [Arguments]    ${sku_number}    ${sub_sku_number}   ${quantity}
    ${body}    Get Cart Items Add Body     ${buyer_id}     ${buyer_shipping_cart_id}    ${sku_number}    ${sub_sku_number}  ${quantity}
    ${res}    Send Post Request    ${url-mik}    ${mik-cart-items}/${buyer_shipping_cart_id}/cart-items    ${body}    ${buyer_headers_post}
    ${cart_item_id}    Get Json Value    ${res.json()}    shoppingItemId
    [Return]   ${cart_item_id}
#    Set Suite Variable    ${cart_item_id}    ${cart_item_id}

Update Item Quantity On Shipping Cart - PUT
    [Arguments]   ${cart_item_id}   ${quantity}
    ${body}    Get Change Cart item Quantity Body    ${buyer_shipping_cart_id}    ${cart_item_id}    quantity=${quantity}
    ${res}    Send Put Request    ${url-mik}    /cpm/carts/${buyer_shipping_cart_id}/cart-items/${cart_item_id}     ${body}    ${buyer_headers_post}
    [Return]   ${quantity}

Remove Item From Shipping Cart - DELETE
    ${res}    Send Delete Request    ${url-mik}    ${mik-cart-items}/${buyer_shipping_cart_id}/cart-items/${cart_item_id}    ${null}    ${buyer_headers_post}

Get User Address - GET
    ${res}     Send Get Request    ${url-mik}    ${mik-user-address}    ${null}    ${buyer_headers}
    [Return]   ${res.json()["data"]}

Address Usps Verify - POST
    ${body}    Get Usr Usps Verify Body
    ${res}     Send Post Request    ${url-mik}    ${mik-usps-verify}    ${body}    ${buyer_headers_post}

Shipping Checkout Summary - POST
    [Arguments]   ${seller_store_id}   @{product_info_list}
    ${body}    Get Shipping Checkout Summary Body    ${seller_store_id}   @{product_info_list}
    ${res}     Send Post Request     ${url-mik}    ${mik-shipping-checkout-summary}    ${body}    ${buyer_headers_post}
    Set Suite Variable  ${shipping_method_res}  ${res.json()}

#Listing Checkout Initiate - POST
#    [Arguments]   ${item_details}  ${shiping_method}
#    ${body}    Get Checkout Initiate Body    ${seller_store_id}   ${item_details}   ${shiping_method}
#    ${res}    Send Post Request    ${url-mik}    ${mik-checkout-initiate}    ${body}    ${buyer_headers_post}
#    Set Suite Variable    ${checkout_initiat_data}    ${res.json()}

Listing Checkout Initiate - POST
    [Arguments]   @{shipping_method_res}
    ${body}    Get Checkout Initiate Body    @{shipping_method_res}
    ${res}    Send Post Request    ${url-mik}    ${mik-checkout-initiate}    ${body}    ${buyer_headers_post}
    Set Suite Variable    ${checkout_initiat_data}    ${res.json()}

Get Wallet Bankcard - GET
    ${res}    Send Get Request    ${url-mik}    ${mik-fin-wallet-bankcard}/${buyer_id}    ${null}    ${buyer_headers}
    Log   ${res.json()}
    Set Suite Variable    ${wallet_bankcard}    ${res.json()[0]}

Add Wallet Bankcard - POST
    Log    waiting TODO

Checkout Submit Order - POST
    ${body}    Get Checkout Submit Order Body    ${buyer_info_sign}    ${checkout_initiat_data}    ${wallet_bankcard}
    Log    ${body}
    ${res}    Send Post Request    ${url-mik}    ${mik-checkout-submit-order}    ${body}    ${buyer_headers_post}
    ${parent_order_number}    Get Json Value    ${res.json()}    parentOrderNumber
    ${sub_order_number}    Get Json Value    ${res.json()}    subOrderNumbers
    Set Suite Variable    ${parent_order_number}    ${parent_order_number}
    Set Suite Variable    ${sub_order_number}    ${sub_order_number[0]}

Flow From Search Listing To Submit Order
    Get Store Listing List - GET
    Get Product Detail By Sku - POST
    Get Buyer Shipping Cart Id - GET
    Add Items To Buyer Shipping Cart - POST
    Get Buyer Shipping Cart Items List - GET
    Listing Checkout Initiate - POST
    Get Wallet Bankcard - GET
    Checkout Submit Order - POST

Get Seller Order Listing By Keywords - POST
    [Arguments]    ${statuses}
    ${body}    Get Seller Order Search Body    ${seller_store_id}    ${statuses}
    ${res}    Send Post Request    ${url-mik}    ${mik-seller-order-by-keywords}    ${body}    ${seller_headers_post}
    ${items}    Get Json Value    ${res.json()}    searchResults    items
    ${len}    Get Length    ${items}
    Run Keyword If    '${len}'=='0'    Fail    No Order status are ${statuses}
    ${keyword_order_numbers}    Get Buyer Order From List By Buyer Name    ${items}    ${buyer_name}
    Set Suite Variable   ${keyword_order_numbers}     ${keyword_order_numbers}

Get Buyer Order By Seller Order Listing Page - GET
    [Documentation]   Can't used to find the returnable order
    [Arguments]    ${statuses}
    Get Seller Order Listing By Keywords - POST    ${statuses}
    ${order_numbers}    Evaluate    ",".join(${keyword_order_numbers})
    ${body}    Get Seller Order List Page Body    ${order_numbers}
    ${res}    Send Get Request    ${url-mik}    ${mik-seller-order-list-page}    ${body}    ${seller_headers}
    ${sub_order_number}    Get Buyer Order Number From Response    ${res.json()}    ${buyer_id}
    Set Suite Variable    ${sub_order_number}    ${sub_order_number}

Get Buyer Order Which No After Sales Order By Order Numbers - GET
    [Documentation]  Used to find the returnable order
    [Arguments]    ${statuses}
    Get Seller Order Listing By Keywords - POST    ${statuses}
    ${item}    Set Variable    ${null}
#    @{keyword_order_numbers}    Evaluate     reversed(@{keyword_order_numbers})
    FOR    ${item}    IN    @{keyword_order_numbers}
        ${parent_order_number}     Evaluate    '${item}'.split("-")[0][3:]
        ${body}    Get Buyer After Order List Body    ${parent_order_number}
        ${res}    Send Get Request    ${url-mik}    ${mik-buyer-return-order-check}   ${body}    ${buyer_headers}
        ${total_number}     Get Json Value    ${res.json()}    data    totalNum
        Set Suite Variable    ${sub_order_number}     ${item}
        Exit For Loop If    '${total_number}'=='0'
    END

Get Seller Order Detail - GET
    [Arguments]  ${sub_order_number}
    ${body}    Create Dictionary    orderNumber=${sub_order_number}    simpleMode=${False}
    ${res}    Send Get Request    ${url-mik}    ${mik-seller-order-detail}    ${body}    ${seller_headers}
#    Save Seller Order Detail Info    ${res.json()}
    [Return]   ${res.json()}


Check Seller Order Status - GET
    [Arguments]    ${input_status}
    ${body}    Create Dictionary    orderNumber=${sub_order_number}    simpleMode=${False}
    ${res}    Send Get Request    ${url-mik}    ${mik-seller-order-detail}    ${body}    ${seller_headers}
    ${status}    Get Json Value    ${res.json()}    data    status
    Should Be Equal As Strings    ${status}    ${input_status}

Save Seller Order Detail Info
    [Arguments]    ${res}
    ${data}    Get Json Value    ${res.json()}    data
    Set Suite Variable    ${seller_order_detail}    ${data}
    ${parent_order_number}    Get Json Value    ${data}    parentOrderNumber
    ${sub_order_number}    Get Json Value    ${data}    orderNumber
    ${order_item_id}    Get Json Value    ${data}    orderLines    orderItemId
    ${quantity}    Get Json Value    ${data}    orderLines    quantity
    Set Suite Variable    ${parent_order_number}    ${parent_order_number}
    Set Suite Variable    ${sub_order_number}    ${sub_order_number}
    Set Suite Variable    ${order_item_id}    ${order_item_id}
    Set Suite Variable    ${quantity}    ${quantity}

Get Buyer Order Detail - GET
    [Arguments]   ${parent_order_number}
    ${param}    Create Dictionary    parentOrderNumber=${parent_order_number}
    ${res}    Send Get Request    ${url-mik}    ${mik-buyer-order-detail}    ${param}    ${buyer_headers}
    Save Buyer Order Detail Info    ${res}
    [Return]    ${res.json()}

Save Buyer Order Detail Info
    [Arguments]    ${res}
    ${data}    Get Json Value    ${res.json()}    data
    Set Suite Variable    ${buy_order_detail}    ${data}
    ${parent_order_number}    Get Json Value    ${data}    parentOrderNumber
    ${sub_order_number}    Get Json Value    ${data}    subOrders    orderNumber
    ${order_item_id}    Get Json Value    ${data}    subOrders    orderLines    orderItemId
    ${quantity}    Get Json Value    ${data}    subOrders    orderLines    quantity
    Set Suite Variable    ${parent_order_number}    ${parent_order_number}
    Set Suite Variable    ${sub_order_number}    ${sub_order_number}
    Set Suite Variable    ${order_item_id}    ${order_item_id}
    Set Suite Variable    ${quantity}    ${quantity}

Seller Cancel Order - POST
    ${body}    Get Seller Cancel Order Body    ${sub_order_number}
    ${res}    Send Post Request    ${url-mik}    ${mik-seller-cancel-order}    ${body}    ${seller_headers_post}

Buyer Cancel Order - POST
    ${body}    Get Buyer Cancel Order Body     ${parent_order_number}     ${sub_order_number}     ${order_item_id}    ${quantity}
    ${res}    Send Post Request    ${url-mik}    ${mik-buyer-cancel-order}    ${body}    ${buyer_headers_post}

Seller Confirm Order - POST
    ${sub_order_numbers}    Create List    ${sub_order_number}
    ${body}    Get Seller Confirm Order Body    ${sub_order_numbers}
    ${res}    Send Post Request    ${url-mik}    ${mik-seller-confirm-order}    ${body}    ${seller_headers_post}

Seller Shipment Items - POST
    ${body}    Get Seller Order Shipment Body    ${sub_order_number}    ${order_item_id}    ${quantity}
    ${res}    Send Post Request    ${url-mik}    ${mik-seller-order-shipment}    ${body}    ${seller_headers_post}

Buyer Return Order - POST
    [Arguments]  ${buyer_order_detail}
    ${body}    Get Buyer Return Order Body    ${buyer_order_detail}
    ${res}    Send Post Request    ${url-mik}    ${mik-buyer-return-order-create}    ${body}    ${buyer_headers_post}

Get Seller After Sales Order List - GET
    [Arguments]    ${statuses}=${null}
    ${body}    Get Seller After Sales Order List Body    ${statuses}
    ${res}    Send Get Request    ${url-mik}    ${mik-seller-after-sales-order-list}    ${body}    ${seller_headers}
    ${seller_return_order_list}    Get Json Value    ${res.json()}    data    orderReturnRspVoList
    ${len}    Get Length    ${seller_return_order_list}
    Set suite Variable    ${seller_return_order}    ${seller_return_order_list[0]}

Get Seller After Sales Order Detial - GET
    ${return_order_number}    Get Json Value    ${seller_return_order}    returnOrderNumber
    Set Suite Variable     ${return_order_number}    ${return_order_number}
    ${res}    Send Get Request    ${url-mik}    ${mik-seller-after-sales-order-detail}/${return_order_number}    ${null}    ${seller_headers}
    ${seller_return_order_detail}     Get Json Value    ${res.json()}    data
    Set suite Variable    ${seller_return_order_detail}    ${seller_return_order_detail}

Seller Approval After Sales Order - POST
    ${body}    Get Seller Approve After Sales Order Body    ${seller_return_order_detail}    ${True}
    ${res}    Send Post Request    ${url-mik}    ${mik-returns-order-processRefund}    ${body}    ${seller_headers_post}

Seller Reject After Sales Order - POST
    ${body}    Get Seller Approve After Sales Order Body    ${seller_return_order_detail}    ${False}
    ${res}    Send Post Request    ${url-mik}    ${mik-returns-order-processRefund}    ${body}    ${seller_headers_post}

Check After Sales Order Status - GET
    [Arguments]     ${status}
    Get Seller After Sales Order Detial - GET
    ${order_status}    Get Json Value    ${seller_return_order_detail}    status
    Should Be Equal AS Strings    ${order_status}    ${status}