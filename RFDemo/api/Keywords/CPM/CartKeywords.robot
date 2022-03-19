*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Library             ../../Libraries/CPM/RequestBodyCartCheckout.py
Resource            ../../TestData/CPM/PathCarts.robot
Library             ../../Libraries/CPM/RequestBodyPayment.py

*** Variables ***
${CartInof}

*** Keywords ***
CPM Get Carts by user id- Get
    [Arguments]  ${user_id}    ${channel}=RETAIL    ${cartType}=1
    ${payload}    get_carts    ${user_id}    ${channel}    ${cartType}
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTS}    ${payload}    ${Headers}
    ${CartInof}    get json value    ${resp.json()}
    set suite variable    ${CartInof}    ${CartInof}

CPM Create Carts by user id- POST
    [Arguments]  ${user_id}    ${channel}=RETAIL    ${subscriptionDefault}=${null}    ${cartType}=0
    ${payload}    create_carts    ${user_id}    ${channel}    ${subscriptionDefault}    ${cartType}
    ${resp}    Send Post Request    ${URL-CPM}    ${CARTS}    ${payload}    ${Headers}

CPM Create Carts Negative- POST
    [Arguments]  ${user_id}    ${channel}=RETAIL    ${subscriptionDefault}=${null}    ${cartType}=0    ${status}=200
    ${payload}    create_carts    ${user_id}    ${channel}    ${subscriptionDefault}    ${cartType}
    ${resp}    Send Post Request    ${URL-CPM}    ${CARTS}    ${payload}    ${Headers}    ${status}

CPM Create Carts by guest- POST
    [Arguments]  ${user_id}    ${channel}=RETAIL    ${subscriptionDefault}=${null}    ${cartType}=0
    ${payload}    create_carts    ${user_id}    ${channel}    ${subscriptionDefault}    ${cartType}
    ${resp}    Send Post Request    ${URL-CPM}    /carts/guestCreateCart    ${payload}    ${Headers}
    ${CartInof}    get json value    ${resp.json()}
    set suite variable    ${CartInof}    ${CartInof}

CPM Cleart Carts by cart id- DELETE
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Delete Request  ${URL-CPM}    ${CARTS}/clearCart/${cart_id}    ${null}  ${Headers}

CPM Get Cart by cart id- Get
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTS}/${cart_id}    ${null}    ${Headers}

CPM Update Cart by cart id- PUT
    [Arguments]    ${user_id}=${null}    ${currency}=${null}    ${cart_id}=${null}    ${status}=200
    ${payload}    create dictionary    userId=${user_id}    currency=${currency}
    ${resp}    Send Put Request    ${URL-CPM}    ${CARTS}/${cart_id}    ${payload}    ${Headers}    ${status}

CPM Get Cart Items by cart id- List
    [Arguments]    ${city}=null    ${state}=${null}    ${zip_code}=${null}    ${time_in_millis}=${null}    ${time_zone}=${null}    ${latitude}=0.0    ${longitude}=0.0
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${payload}    get cart items    city=${city}    state=${state}    zip_code=${zip_code}    time_in_millis=${time_in_millis}    time_zone=${time_zone}    latitude=${latitude}    longitude=${longitude}
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}    ${payload}    ${Headers}
    ${cart_items_info}    get json value    ${resp.json()}
    [Return]    ${cart_items_info}

CPM Get Cart Items by guest- List
    [Arguments]    ${city}=null    ${state}=${null}    ${zip_code}=${null}    ${time_in_millis}=${null}    ${time_zone}=${null}    ${latitude}=0.0    ${longitude}=0.0
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${payload}    get cart items    city=${city}    state=${state}    zip_code=${zip_code}    time_in_millis=${time_in_millis}    time_zone=${time_zone}    latitude=${latitude}    longitude=${longitude}
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTSV2}/${cart_id}/guest-cart-items    ${payload}    ${Headers}
    ${cart_items_info}    get json value    ${resp.json()}
    [Return]    ${cart_items_info}

CPM Create Cart Items by Cart id- POST
    [Arguments]    ${user_id}    ${items}    ${status}=200
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${payload}    create_cart_items    ${user_id}    ${items}    ${cart_id}    ${URL}    ${Headers}
    ${resp}    Send Post Request    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}    ${payload}    ${Headers}    ${status}

CPM Create Cart Items by Cart id Negative- POST
    [Arguments]    ${user_id}    ${items}    ${cart_id}    ${status}=200
    ${payload}    create_cart_items    ${user_id}    ${items}    ${cart_id}    ${URL}    ${Headers}
    ${resp}    Send Post Request    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}    ${payload}    ${Headers}    ${status}

CPM Create Cart Items by Cart id Guest- POST
    [Arguments]    ${user_id}    ${items}    ${status}=200
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${payload}    create_cart_items_guest    ${user_id}    ${items}    ${cart_id}    ${URL}    ${Headers}
    ${resp}    Send Post Request    ${URL-CPM}    ${CARTSV2}/guest-add-items    ${payload}    ${Headers}    ${status}

CPM Update Cart Items by Shipping item Id- PUT
    [Arguments]    ${shippingitemid}    ${item}    ${newitem}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${payload}    update_cart_item    ${item}    ${newitem}
    ${resp}    Send Put Request    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}/${shippingitemid}    ${payload}    ${Headers}

CPM Get Cart Items by Shipping item Id- Get
    [Arguments]    ${shippingitemid}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}/${shippingitemid}    ${null}    ${Headers}

CPM Get Cart Items Quantity by Shipping item Id- Get
    [Arguments]    ${shippingitemid}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}/${shippingitemid}/quantity    ${null}    ${Headers}

CPM Create migrate Cart Items- POST
    [Arguments]    ${cartId}    ${ToUserId}    ${itemIds}=${null}
    ${payload}    create_migrate    ${cartId}    ${ToUserId}    ${itemIds}
    ${resp}    Send Post Request - Params    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}/migrate    ${payload}    ${Headers}

CPM Create transfer Cart Items- POST
    [Arguments]    ${cartId}    ${toWishlistid}    ${itemIds}=${null}
    ${payload}    create_transfer    ${cartId}    ${toWishlistid}    ${itemIds}
    ${resp}    Send Post Request - Params    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}/transfer    ${payload}    ${Headers}

CPM Get Cart Distinct Items- Get
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTS}/${cart_id}/distinct-item-count    ${null}    ${Headers}

CPM Get Total Quantity Items- Get
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Get Request    ${URL-CPM}    ${CARTS}/${cart_id}/quantity    ${null}    ${Headers}

CPM Delete Cart Item by Shipping item Id- Delete
    [Arguments]    ${shippingitemid}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Delete Request - Params    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}/${shippingitemid}    ${null}    ${Headers}    204

CPM Delete Cart Item- Delete
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${resp}    Send Delete Request - Params    ${URL-CPM}    ${CARTS}/${cart_id}${CART_ITEMS}    ${null}    ${Headers}    204

CPM Create Pre Initiate- POST
    [Arguments]    ${initial_item_list}    ${shipping_address}=${null}    ${status}=200
    ${payload}    create_checkout_pre_initiate    ${initial_item_list}    ${shipping_address}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/pre-initiate   ${payload}    ${Headers}    ${status}
    ${preInitiate}    get json value    ${resp.json()}
    [Return]    ${preInitiate}

CPM Create Refresh Initiate-POST
    [Arguments]    ${preInitialSubOrderVoList}    ${items}=${null}    ${shipping_address}=${null}    ${status}=200
    ${payload}    create_refresh_initiate    ${preInitialSubOrderVoList}    ${items}    ${shipping_address}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/refresh-initiate    ${payload}    ${Headers}    ${status}
    ${RefreshInitiate}    get json value    ${resp.json()}
    [Return]    ${RefreshInitiate}

CPM Create Split Order Initiate-POST
    [Arguments]    ${preInitialSubOrderVoList}    ${items}=${null}    ${shipping_address}=${null}    ${user_id}=${null}    ${status}=200   ${couponCodes}=${null}
    ${payload}    create_split_order_initiate    ${preInitialSubOrderVoList}    ${items}    ${shipping_address}    ${user_id}    ${couponCodes}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/split-order-and-initiate    ${payload}    ${Headers}    ${status}
    ${RefreshInitiate}    get json value    ${resp.json()}
    [Return]    ${RefreshInitiate}

CPM Create Carts Bind-POST
    [Arguments]    ${cart_id}    ${user_id}    ${status}=200
    ${payload}    create_carts_bind    ${cart_id}    ${user_id}
    ${resp}    Send Post Request - Params    ${URL-CPM}    ${CARTS}/bind    ${payload}    ${Headers}    ${status}
    ${RefreshInitiate}    get json value    ${resp.json()}
    [Return]    ${RefreshInitiate}

CPM Create Submit Order- POST
    [Arguments]    ${refresh_initiate}    ${payments}=${null}    ${status}=200    ${code}=200
    ${payload}    create_submit_order    ${refresh_initiate}    ${initpayments}    ${payments}    ${null}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/submit-order    ${payload}    ${Headers}    ${status}
    ${orderinfo}    get json value    ${resp.json()}
    ${body_code}    get from dictionary    ${orderinfo}    code
    run keyword if    "${status}"=="200"
    ...    should be equal as integers    ${body_code}    ${code}

CPM Create Guest Submit Order- POST
    [Arguments]    ${refresh_initiate}    ${user_id}    ${payments}=${null}    ${status}=200    ${code}=200
    ${payload}    create_submit_order    ${refresh_initiate}    ${initpayments}    ${payments}    ${user_id}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/guest-submit-order    ${payload}    ${Headers}    ${status}
    ${orderinfo}    get json value    ${resp.json()}
    ${body_code}    get from dictionary    ${orderinfo}    code
    run keyword if    "${status}"=="200"
    ...    should be equal as integers    ${body_code}    ${code}


CPM Clear Carts item- DELETE
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    Send Delete Request    ${URL-CPM}    ${CARTS}/clearCart/${cart_id}    ${null}    ${Headers}

CPM Get Shipping Options- GET
    [Arguments]    ${items}
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Clear Carts item- DELETE
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}
    ${resp}    Send Get Request    ${URL-CPM}    /checkout/shipping-options    ${null}    ${Headers}
    ${option}    get json value    ${resp.json()}

CPM Get Order Number- GET
    ${resp}    Send Get Request    ${URL-CPM}    /checkout/order-number    ${null}    ${Headers}

CPM Create Email Subscription Confirmation- POST
    [Arguments]    ${quantity}=1    ${email}=buyerAT0006@michaels.com    ${firstName}=buyerAT
    ${params}    create dictionary    email=${email}    firstName=${firstName}
    ${payload}    create_email_subscription_confirmation    ${quantity}
    ${resp}    Send Post Request - Params And Json    ${URL-CPM}    /checkout/email-subscription-confirmation    ${params}    ${payload}    ${Headers}

CPM Order Initiate
    [Arguments]    ${items}=${null}    ${shipping_address}=${null}    ${user_id}=${null}    ${status}=200
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Clear Carts item- DELETE
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}
    ${CartItemsInfo}    CPM Get Cart Items by cart id- List
    ${preInitiate}    CPM Create Pre Initiate- POST    ${CartItemsInfo}
    ${preInitialSubOrderVoList}    get from dictionary    ${preInitiate}    preInitialSubOrderVoList
#    log to console    ${items}
#    log to console    ${preInitialSubOrderVoList}
    ${payload}    create_split_order_initiate    ${preInitialSubOrderVoList}    ${items}    ${shipping_address}    ${null}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/split-order-and-initiate    ${payload}    ${Headers}    ${status}

CPM Order Initiate Code
    [Arguments]    ${items}    ${status}=200    ${code}=${null}    ${order_source}=${null}    ${area_code}=${null}    ${ack_tax_exempt}=${null}    ${store_Id}=${null}    ${channelType}=${null}    ${quantity}=${null}    ${ShippingMethod}=${null}
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Clear Carts item- DELETE
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}
    ${CartItemsInfo}    CPM Get Cart Items by cart id- List
    ${preInitiate}    CPM Create Pre Initiate- POST    ${CartItemsInfo}
    ${preInitialSubOrderVoList}    get from dictionary    ${preInitiate}    preInitialSubOrderVoList
    ${payload}    create_initiate    ${preInitialSubOrderVoList}    ${items}    ${null}    ${null}    ${order_source}    ${area_code}    ${ack_tax_exempt}    ${store_Id}    ${channelType}    ${quantity}    ${ShippingMethod}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/split-order-and-initiate    ${payload}    ${Headers}    ${status}
    ${RefreshInitiate}    get json value    ${resp.json()}
    ${body_code}    get from dictionary    ${RefreshInitiate}    code
    run keyword if    "${status}"!="200"
    ...    should be equal as integers    ${body_code}    ${code}


CPM Order Initiate status
    [Arguments]    ${items}    ${status}=200    ${code}=${null}    ${order_source}=${null}    ${area_code}=${null}    ${ack_tax_exempt}=${null}    ${store_Id}=${null}    ${channelType}=${null}    ${quantity}=${null}    ${ShippingMethod}=${null}
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Clear Carts item- DELETE
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}
    ${CartItemsInfo}    CPM Get Cart Items by cart id- List
    ${preInitiate}    CPM Create Pre Initiate- POST    ${CartItemsInfo}
    ${preInitialSubOrderVoList}    get from dictionary    ${preInitiate}    preInitialSubOrderVoList
    ${payload}    create_initiate    ${preInitialSubOrderVoList}    ${items}    ${null}    ${null}    ${order_source}    ${area_code}    ${ack_tax_exempt}    ${store_Id}    ${channelType}    ${quantity}    ${ShippingMethod}
    ${resp}    Send Post Request    ${URL-CPM}    ${CHECKOUT}/split-order-and-initiate    ${payload}    ${Headers}    ${status}
    ${RefreshInitiate}    get json value    ${resp.json()}
    ${body_code}    get from dictionary    ${RefreshInitiate}    status
    run keyword if    "${status}"!="200"
    ...    should be equal as strings    "${body_code}"    "${code}"
    [Return]    ${RefreshInitiate}


CPM Order process
    [Arguments]    ${items}    ${payments}=${null}    ${status}=200    ${code}=200    ${couponCodes}=${null}
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Clear Carts item- DELETE
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}    ${status}
    ${CartItemsInfo}    CPM Get Cart Items by cart id- List
    ${preInitiate}    CPM Create Pre Initiate- POST    ${CartItemsInfo}
    ${preInitialSubOrderVoList}    get from dictionary    ${preInitiate}    preInitialSubOrderVoList
    ${RefreshInitiate}    CPM Create Split Order Initiate-POST    ${preInitialSubOrderVoList}    ${null}    ${null}    ${null}    ${status}    ${couponCodes}
    CPM Create Submit Order- POST    ${RefreshInitiate}    ${payments}    ${status}    ${code}

CPM Order process Negative
    [Arguments]    ${items}    ${payments}=${null}    ${status}=200    ${code}=200    ${cartstatus}=200
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Clear Carts item- DELETE
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}    ${cartstatus}
    ${CartItemsInfo}    CPM Get Cart Items by cart id- List
    ${preInitiate}    CPM Create Pre Initiate- POST    ${CartItemsInfo}
    ${preInitialSubOrderVoList}    get from dictionary    ${preInitiate}    preInitialSubOrderVoList
    ${RefreshInitiate}    CPM Create Split Order Initiate-POST    ${preInitialSubOrderVoList}    ${null}    ${null}    ${null}    ${status}
    CPM Create Submit Order- POST    ${RefreshInitiate}    ${payments}    ${status}    ${code}

CPM Guest Order process
    [Arguments]    ${items}    ${payments}=${null}    ${status}=200    ${code}=200
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Create Carts by guest- POST    ${user_id}
    CPM Create Cart Items by Cart id Guest- POST    ${user_id}    ${items}    ${status}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    CPM Create Carts Bind-POST    ${cart_id}    ${user_id}
    ${CartItemsInfo}    CPM Get Cart Items by guest- List
    ${preInitiate}    CPM Create Pre Initiate- POST    ${CartItemsInfo}
    ${preInitialSubOrderVoList}    get from dictionary    ${preInitiate}    preInitialSubOrderVoList
    ${RefreshInitiate}    CPM Create Split Order Initiate-POST    ${preInitialSubOrderVoList}    ${null}    ${null}    ${user_id}    ${status}
    CPM Create Guest Submit Order- POST    ${RefreshInitiate}    ${user_id}    ${payments}    ${status}    ${code}
    



    