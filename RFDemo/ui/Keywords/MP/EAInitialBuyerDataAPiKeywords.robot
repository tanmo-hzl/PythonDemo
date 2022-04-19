*** Settings ***
Library           ../../Libraries/MP/BuyerReturnLib.py
Library           ../../Libraries/MP/BuyerDisputeLib.py
Library           ../../Libraries/MP/EARequestBodyLib.py
Resource          ../../Keywords/Common/CommonApiKeywords.robot
Resource          ../../Keywords/Common/CommonKeywords.robot


*** Variables ***
${Headers_Get_Buyer}
${Headers_Post_Buyer}
${Buyer_Info}
${Buyer_Id}
${item}
${Buyer_Shipping_Cart_Id}
${Wallet_Bankcard}
${Address_Info}
${Pre_Initiate_Data}
${Initiate_Order_Data}

*** Keywords ***
API - Buyer Sign In
    Initial Env Data
    ${data}    Mik - User Sign In By Secure - POST     ${BUYER_EMAIL}    ${BUYER_PWD}
    Mik - Set Buyer Suite Variables    ${data}

API - Get Buyer Order Detail By Parent Order Number
    [Arguments]    ${parent_order_number}
    ${body}    Create Dictionary    parentOrderNumber=${parent_order_number}
    ${path}    Set Variable    /moh/order/v5.1/buyer/parentOrderList/single
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Buyer}
    [Return]    ${res.json()}[data]

API - Check Buyer Order Actionable By Parent Order Number
    [Arguments]    ${parent_order_number}    ${type}=cancel
    ${body}    Create Dictionary    isCheckCancel=${True}    isCheckReturn=${True}    isCheckValid=${True}
    ${path}    Set Variable    /moh/afterSales/order/v2/checkOrder/${parent_order_number}
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Buyer}
    ${data}    Set Variable    ${res.json()}[data]
    IF    "${type}"=="cancel"
        ${flag}    Set Variable    ${data}[isCancellable]
    END
    IF    "${type}"=="return"
        ${flag}    Set Variable    ${data}[isReturnlable]
    END
    [Return]    ${flag}

API - Buyer Create Return Order By Parent Order Number
    [Arguments]    ${parent_order_number}    ${partial_item_return}=${False}
    ...    ${partial_quantity_return}=${False}    ${buyer_reason}=${False}
    ${order_detail}    API - Get Buyer Order Detail By Parent Order Number    ${parent_order_number}
    ${body}    Get Create Return Order Body    ${order_detail}    ${partial_item_return}
    ...    ${partial_quantity_return}    ${buyer_reason}
    IF    "${body}"=="${None}"
        Fail    Fail to create Return order body, please fix code.
    END
    ${path}    Set Variable    /moh/returns/buyer/create
    ${res}    Send Post Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Post_Buyer}

API - Get Buyer Return Order Detail By Return Number
    [Arguments]    ${retrun_number}
    ${path}    Set Variable    /moh/afterSales/return/buyer/single/getByReturnOrderNumber/${retrun_number}
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${null}    ${Headers_Get_Buyer}
    [Return]    ${res.json()}[data]

API - Buyer Create Dispute Order By Return Number
    [Arguments]    ${retrun_number}
    ${order_detail}    API - Get Buyer Return Order Detail By Return Number    ${retrun_number}
    ${body}    Get Create Dispute Order Body     ${order_detail}
    ${path}    Set Variable    /rsc/v2/disputes/create
    ${res}    Send Post Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Post_Buyer}

API - Get Store Product List - POST
    ${body}    Create Dictionary    order=-1    pageNumber=1    pageSize=48    sortType=DATE
    ${path}    Set Variable    /mda/product/${Seller_Store_Id}/storeProduct
    ${res}    Send Post Request    ${API_HOST_MIK}    ${path}    ${body}    ${None}
    ${product_list}    Set Variable    ${res.json()}[productResponses]
    [Return]    ${product_list}

Api - Get Product Detial By Sku Number - GET
    [Arguments]    ${sku_number}
    ${body}    Create Dictionary    skuNumbers=${sku_number}    michaelsStoreId=1056    needPromotion=${True}
    ...    needPrice=${True}    needInventory=${True}    needVariantsSort=${True}    needAllStatusFlag=${True}
    ${path}    Set Variable    /product/skus
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${None}
    ${product_detail}    Set Variable    ${res.json()}[data]
    [Return]    ${product_detail}

API - Get Buyer Shipping Cart Id - GET
    ${body}    Create Dictionary    userId=${Buyer_Id}    channel=RETAIL
    ${res}    Send Get Request    ${API_HOST_MIK}    /cpm/carts    ${body}    ${Headers_Get_Buyer}
    ${buyer_shipping_cart_id}    Get Json Value    ${res.json()}    shoppingCartId
    Set Suite Variable    ${Buyer_Shipping_Cart_Id}    ${buyer_shipping_cart_id}

API - Remove All Items From Shipping Cart - DELETE
    ${path}    Set Variable    /cpm/carts/clearCart/${Buyer_Shipping_Cart_Id}
    ${res}    Send Delete Request    ${API_HOST_MIK}    ${path}    ${Null}    ${Headers_Post_Buyer}


API - Add Items To Buyer Shipping Cart - POST
    [Arguments]    ${product_detail}
    ${body}    Get Cart Random Items Add Body     ${buyer_id}     ${buyer_shipping_cart_id}    ${product_detail}
    ${path}    Set Variable     /cpm/carts/${buyer_shipping_cart_id}/cart-items
    ${res}    Send Post Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Post_Buyer}
    [Return]   ${res.json()}

API - Get Wallet Bankcard - GET
    ${path}    Set Variable    /fin/wallet/bankcard/${buyer_id}
    ${res}    Send Get Request    ${API_HOST_MIK}     ${path}    ${null}    ${Headers_Get_Buyer}
    Set Suite Variable    ${Wallet_Bankcard}    ${res.json()[0]}

API - Get Buyer Default Address - GET
    [Arguments]    &{kwargs}
    ${res}   Send Get Request    ${API_HOST_MIK}    /usr/user/address    ${null}    ${Headers_Get_Buyer}
    ${data}    Set Variable    ${res.json()["data"]}
    ${address_info}    Get Address With Free Tax    ${data}    &{kwargs}
#    ${address_info}    Evaluate    random.choice(${data})
    Set Suite Variable  ${Address_Info}   ${address_info}

API - Pre-initiate - POST
    [Arguments]   ${cart_item_info}
    ${body}   Get Pre Initiate Body   ${cart_item_info}   ${Address_info}
    ${path}    Set Variable    /cpm/v2/checkout/pre-initiate
    ${res}    Send Post Request    ${API_HOST_MIK}     ${path}     ${body}    ${Headers_Post_Buyer}
    Set suite Variable    ${Pre_Initiate_Data}   ${res.json()["preInitialSubOrderVoList"]}
    ${chosenAbleShippingMethodList}    Get Json Value    ${Pre_Initiate_Data}    chosenAbleShippingMethodList
    IF    "${chosenAbleShippingMethodList}"=="${null}"
        ${msg}    Get Json Value    ${Pre_Initiate_Data}    errorMsg
        Fail    Fail to Pre-initiate Order, ${product_info_list}, ${msg}
    END

API - Split Order And Initiate
     ${body}   Get Split Order And Initiate Body   ${Pre_Initiate_Data}   ${Address_info}   ${Buyer_Info}
     ${path}    Set Variable    /cpm/v2/checkout/split-order-and-initiate
     ${res}    Send Post Request    ${API_HOST_MIK}     ${path}     ${body}    ${Headers_Post_Buyer}
     Set suite Variable    ${Initiate_Order_Data}    ${res.json()}

API - Submit Order - POST
    ${body}   Get Submit Order Body   ${Initiate_Order_Data}   ${wallet_bankcard}   ${Address_info}    ${Buyer_Info}
    ${path}    Set Variable    /cpm/v2/checkout/submit-order
    ${res}    Send Post Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Post_Buyer}

API - Get Service Time - GET
    ${path}    Set Variable    /user/getServerTime
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${null}    ${Headers_Get_Buyer}
    ${service_date}    Evaluate    '${res.json()}[data]'\[:10\]
    [Return]  ${service_date}

Flow - API - Place Order By Item Type
    [Arguments]   ${index}    ${total_quantity}    &{kwargs}
    API - Get Buyer Shipping Cart Id - GET
    API - Remove All Items From Shipping Cart - DELETE
    ${product_list}    API - Get Store Product List - POST
    ${sku_number_list}    Get Listings Skus By Kwargs    ${product_list}    ${total_quantity}    &{kwargs}
    ${product_detail}    Api - Get Product Detial By Sku Number - GET    ${sku_number_list}
    ${cart_info}    API - Add Items To Buyer Shipping Cart - POST    ${product_detail}
    API - Get Wallet Bankcard - GET
    API - Get Buyer Default Address - GET    &{kwargs}
    API - Pre-initiate - POST   ${cart_info}
    API - Split Order And Initiate
    API - Submit Order - POST

API - Get Buyer After Sales Order List
    [Arguments]    ${pageNum}=1    ${pageSize}=20
    ${body}    Create Dictionary    channels=1,2,3,4    pageNum=${pageNum}    pageSize=${pageSize}
    ${path}    Set Variable    /moh/afterSales/return/buyer/list/page
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Buyer}
    ${after_sales_order_list}    Get Json Value    ${res.json()}    data    afterSalesRspVoList
    [Return]    ${after_sales_order_list}

API - Get Buyer Order List
    ${body}    Create Dictionary    sortField=createdTime    pageNum=1    pageSize=100
    ...    timeRange=customized    toAggregate=true    isAsc=${False}
    ${path}    Set Variable    /moh/search/order/buyer/list/page
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Buyer}
    ${order_list}    Get Json Value    ${res.json()}    data    content
    [Return]    ${order_list}
