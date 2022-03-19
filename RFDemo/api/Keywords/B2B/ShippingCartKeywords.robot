*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyShippingCart.py
Resource            ../../TestData/B2B/PathShippingCart.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${B2B_User_Info}
${B2B_User_Id}
${Headers_User_Get}
${Headers_User_Post}
${User_Cart_Id}
${Shipping_Cart_Items}
${Shipping_Item_Id}
${Sku_Number}
${Sub_Sku_Number}      ${None}
${Sku_Quantity}       1
${Pro_Sku_Info}

*** Keywords ***
Set Initial Data - B2B - Shipping Cart
    Initial Env Data     configB2B.ini
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}

Get User Shipping Cart Info - GET
    ${body}    Get User Cart Info Body    ${B2B_User_Id}
    ${res}    Send Get Request     ${URL-B2B-CPM}    ${CARTS}    ${body}    ${Headers_User_Get}
    ${User_Cart_Id}    Get Json Value    ${res.json()}    shoppingCartId
    Set Suite Variable    ${User_Cart_Id}    ${User_Cart_Id}

Get Shipping Cart Items - GET
    ${res}    Send Get Request    ${URL-B2B-CPM}    ${CARTS}/${User_Cart_Id}${CART_ITEMS}    ${null}    ${Headers_User_Get}
    Set Suite Variable    ${Shipping_Cart_Items}    ${res.json()}
    ${Shipping_Item_Id}    Get Json Value    ${Shipping_Cart_Items}    shoppingItemId
    Set Suite Variable    ${Shipping_Item_Id}    ${Shipping_Item_Id}

Add Items To Shipping Carts By SkuNumber- POST
    ${body}    Get Add Item To Cart Body    ${B2B_User_Id}    ${User_Cart_Id}    ${Sku_Number}    ${Sub_Sku_Number}    ${Sku_Quantity}
    ${res}    Send Post Request    ${URL-B2B-CPM}    ${CARTS}/${User_Cart_Id}${CART_ITEMS}    ${body}    ${Headers_User_Post}
    Set Suite Variable    ${Shipping_Cart_Items}    ${res.json()}
    ${Shipping_Item_Id}    Get Json Value    ${Shipping_Cart_Items[0]}    shoppingItemId
    Set Suite Variable    ${Shipping_Item_Id}    ${Shipping_Item_Id}

Add Items To Shipping Carts By Product List - POST
    ${body}    Get Add Multi Items To Cart Body    ${B2B_User_Id}    ${User_Cart_Id}    ${Pro_Sku_Info}    ${Sku_Quantity}
    ${res}    Send Post Request    ${URL-B2B-CPM}    ${CARTS}/${User_Cart_Id}${CART_ITEMS}    ${body}    ${Headers_User_Post}
    Set Suite Variable    ${Shipping_Cart_Items}    ${res.json()}

Update Shpping Cart Item's Quantity - PUT
    ${body}    Create Dictionary    quantity=2
    ${path}    Set Variable    ${CARTS}/${User_Cart_Id}${CART_ITEMS}/${Shipping_Item_Id}
    ${res}    Send Put Request    ${URL-B2B-CPM}     ${path}   ${body}    ${Headers_User_Post}

Remove Items From Shipping Cart By Id- DELETE
    ${path}    Set Variable    ${CARTS}/${User_Cart_Id}${CART_ITEMS}/${Shipping_Item_Id}
    ${res}    Send Delete Request    ${URL-B2B-CPM}     ${path}   ${null}    ${Headers_User_Post}    204

Remove All Items From Shipping Cart - DELETE
    ${items}    Get All Items Id    ${Shipping_Cart_Items}
    Run Keyword If    '${items}'!='None'    Request Remove All Items Form Shipping Cart    ${items}

Request Remove All Items Form Shipping Cart
    [Arguments]    ${items}
    ${body}    Create Dictionary    itemIds=${items}
    ${path}    Set Variable    ${CARTS}/${User_Cart_Id}${CART_ITEMS}
    ${res}    Send Delete Request - Params    ${URL-B2B-CPM}     ${path}   ${body}    ${Headers_User_Get}    204
