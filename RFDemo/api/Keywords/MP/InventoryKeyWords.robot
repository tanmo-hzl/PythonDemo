*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/MP/RequestBodyInventory.py
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${map_headers}
${buyer_get_headers}
${buyer_post_headers}
${inventory_id_list}
${buyer_user_id}
${gift_card_info}

*** Keywords ***
Set Initial Data - Inventory
    Map Manager Sign In - POST
    ${map_headers}    Set Post Headers - Admin
    Set Suite Variable    ${map_headers}    ${map_headers}
    Mik Buyer Sign In Scuse - POST
    ${buyer_get_headers}    Set Get Headers - Buyer
    Set Suite Variable    ${buyer_get_headers}    ${buyer_get_headers}
    ${buyer_post_headers}    Set Post Headers - Buyer
    Set Suite Variable    ${buyer_post_headers}    ${buyer_post_headers}

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
    ${res}  Send Get Request  ${URL-MIK}  /fin/wallet/gift-card/${buyer_user_id}  ${null}  ${buyer_get_headers}
    [Return]   ${res.json()}

Add User Gift Card - POST
    [Arguments]  ${gift_card_info}
    ${body}   get_add_gift_card_body  ${buyer_user_id}  ${gift_card_info}
    Send Post Request - Params And Json  ${URL-MIK}  /fin/wallet/gift-card/add  ${null}  ${body}  ${buyer_post_headers}


Delete User Gift Card - DELETE
    [Arguments]   ${gift_card_id}
    ${body}  get_delete_gift_card_body   ${gift_card_id}  ${buyer_user_id}
    Send Delete Request  ${URL-MIK}   /fin/wallet/gift-card/delete  ${null}  ${body}  ${buyer_post_headers}
