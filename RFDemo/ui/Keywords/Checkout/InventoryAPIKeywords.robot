*** Settings ***
Library             ../../Libraries/Checkout/RequestBodyInventory.py
Resource            ../Common/CommonApiKeywords.robot

*** Variables ***
${map_headers}
${Headers_Get_Buyer}
${Headers_Post_Buyer}
${inventory_id_list}
${buyer_user_id}
${gift_card_info}

*** Keywords ***

Increase Store Inventory Of Mahattan - POST
    [Arguments]  ${quantity}  ${store_id}  ${sku_numbers}
    ${body}  get_add_inventory_of_mahattan_body   ${quantity}   ${store_id}  ${sku_numbers}
    Send Post Request   ${URL-MIK}   /inv/inventory/omni/increase-inventories   ${body}   ${map_headers}

Query Store Inventory Of Mahattan - POST
    [Arguments]  ${store_id}  ${sku_numbers}
    ${body}  get_query_store_inventory_of_mahattan_body  ${store_id}  ${sku_numbers}
    ${res}  Send Post Request   ${URL-MIK}   /inv/inventory/omni/store/inventorys   ${body}  ${map_headers}
    [Return]   ${res.json()["data"]}

query Seller Store Inventorys - GET
    [Arguments]   ${store_id}  ${master_sku_number}
    ${param}  Set Variable  storeId=${store_id}&masterSkuNumber=${master_sku_number}
    ${res}  Send Get Request  ${URL-MIK}   /inv/inventory/store/inventorys   ${param}  ${map_headers}

Get And Edit Seller Store Inventorys - GET
    [Arguments]  ${store_id}  ${master_sku_number}  ${channel}
    ${param}  Set Variable  storeId=${store_id}&masterSkuNumber=${master_sku_number}
    ${res}  Send Get Request  ${URL-MIK}   /inv/inventory/store/inventorys   ${param}  ${map_headers}
    ${item_data}  Set Variable  ${res.json()["data"]}
    ${inventory_id_list}  Create List
    FOR   ${data}  IN  @{item_data}
        ${available_quantity}  Set Variable   ${data["availableQuantity"]}
        IF  ${available_quantity}<100
            Append To List  ${inventory_id_list}   ${data["inventoryId"]}
        END
    END
    Set Suite Variable   ${inventory_id_list}   ${inventory_id_list}
    ${length}  Get Length  ${inventory_id_list}
    IF  ${length}>0
        Edit Store Inventorys - Post   ${store_id}  ${master_sku_number}  ${channel}
    END

Edit Store Inventorys - Post
    [Arguments]  ${store_id}  ${master_sku_number}  ${channel}=2    ${quantity}=10000
    ${body}  get_edit_store_inventory_body  ${master_sku_number}  ${channel}   ${inventory_id_list}  ${quantity}
    Send Post Request - Params And Json   ${URL-MIK}   /inv/inventory/store/${store_id}/inventorys  ${null}  ${body}   ${map_headers}

Get Init Gift Card Info
    ${res}  Read File  gift_card_info
    IF  "${res}"=="None"
        ${gift_card_info}  Init Gift Card
        Save File   gift_card_info  ${gift_card_info}
        Set Suite Variable   ${gift_card_info}  ${gift_card_info}
    ELSE IF  ${res["balance"]}<1
        ${gift_card_info}  Init Gift Card
        Save File   gift_card_info  ${gift_card_info}
        Set Suite Variable   ${gift_card_info}  ${gift_card_info}
    ELSE
        Set Suite Variable   ${gift_card_info}  ${res}
    END


Get User Gift Card List - GET
    ${res}  Send Get Request  ${API_HOST_MIK}  /fin/wallet/gift-card/${Buyer_Id}  ${null}  ${Headers_Get_Buyer}
    [Return]   ${res.json()}

Add User Gift Card - POST
    [Arguments]  ${gift_card_info}
    ${body}   get_add_gift_card_body  ${Buyer_Id}  ${gift_card_info}
    Send Post Request  ${API_HOST_MIK}  /fin/wallet/gift-card/add    ${body}  ${Headers_Post_Buyer}

Delete User Gift Card - DELETE
    [Arguments]   ${gift_card_id}
    ${body}  get_delete_gift_card_body   ${gift_card_id}  ${Buyer_Id}
    Send Delete Request  ${API_HOST_MIK}   /fin/wallet/gift-card/delete    ${body}  ${Headers_Post_Buyer}

Init User Gift Card
    ${res}  Get User Gift Card List - GET
    ${length}  Get Length   ${res}
    IF  ${length}>0
        IF  ${res[0]}[balance]<10
            ${gift_card_id}  Set Variable   ${res[0]["giftCardId"]}
            Delete User Gift Card - DELETE   ${gift_card_id}
            Get Init Gift Card Info
            Add User Gift Card - POST  ${gift_card_info}
        END
    ELSE
        Get Init Gift Card Info
        Add User Gift Card - POST  ${gift_card_info}
    END
#        FOR  ${gift_card}  IN  @{res}
#            IF  ${gift_card["balance"]}<10
#                ${gift_card_id}  Set Variable   ${gift_card["giftCardId"]}
#                Delete User Gift Card - DELETE   ${gift_card_id}
#            END
#        END
#        Get Init Gift Card Info
#        Add User Gift Card - POST  ${gift_card_info}
#    ELSE
#        Get Init Gift Card Info
#        Add User Gift Card - POST  ${gift_card_info}
#    END


CK Buyer login
    [Arguments]     ${email}    ${pwd}
    ${data}    Mik - User Sign In By Secure - POST    ${email}    ${pwd}
    Mik - Set Buyer Suite Variables     ${data}

Add User Gift Card
    [Arguments]  ${gift_card_info}
    ${res}    Get User Gift Card List - GET
    ${giftCardTailNum}    Set Variable    ${gift_card_info["card_number"][-4]}
    IF    "${giftCardTailNum}" not in "${res}"
        Add User Gift Card - POST    ${gift_card_info}
    END


Delete Credit Card - DELETE
    [Arguments]   ${bank_card_id}
    ${body}  get_delete_credit_card_body   ${bank_card_id}  ${Buyer_Id}
    Send Delete Request  ${API_HOST_MIK}   /fin/wallet/delete    ${body}  ${Headers_Post_Buyer}


Get Credit Card - GET
    ${res}  Send Get Request  ${API_HOST_MIK}   /fin/wallet/bankcard/${Buyer_Id}  ${null}  ${Headers_Get_Buyer}
    [Return]   ${res.json()}


Delete User Address - DELETE
    [Arguments]   ${address_id}
    Send Delete Request  ${API_HOST_MIK}   /usr/user/address/${address_id}  ${Headers_Post_Buyer}


Get User Address - GET
    ${res}  Send Get Request   ${API_HOST_MIK}    /usr/user/address   ${null}  ${Headers_Get_Buyer}
    [Return]   ${res.json()}


Delete User Address
    ${res}     Get User Address - GET
    ${address}    Set Variable     ${res}[data]
    ${len}    Get Length    ${address}
    IF    ${len}>0
        FOR    ${one_address}    IN    @{address}
            Delete User Address - DELETE    ${one_address}[id]
        END
    END

