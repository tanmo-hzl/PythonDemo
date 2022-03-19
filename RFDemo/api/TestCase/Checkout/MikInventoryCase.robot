*** Settings ***
Resource            ../../Keywords/MP/InventoryKeyWords.robot
Resource            CKKeywords.robot

Suite Setup          Run Keywords    Initial Env Data
...                                  AND    Set Initial Data - Inventory
...                                  AND    Initial Checkout Env Data

Suite Teardown       Delete All Sessions

*** Variables ***


*** Test Cases ***

Test Query Store Inventory Of Mahattan - POST
    [Tags]  query_mahattan_inventory
#    ${res}    Query Store Inventory Of Mahattan - POST     store_id=1026   sku_numbers=[10568330,10383433,10503417,10402435,10392856,10624017]
#    ${res}    Query Store Inventory Of Mahattan - POST     store_id=1056   sku_numbers=[10568330,10383433,10503417,10402435,10392856,10624017]

    ${res}    Query Store Inventory Of Mahattan - POST     store_id=1026   sku_numbers=["10524078"]


Test Check Whether Store Inventory Enough
    [Tags]    ck-data-preparation    mahattan_inventory
    ${offline_inventory_skus}    Combine Lists     ${PIS}    ${PISM}    ${SDD}     ${SDDH}
    ${online_inventory_skus}     Combine Lists     ${MIK}
    ${items}  Create List
    ${dict1}  Create Dictionary  store_id=1269  sku_numbers=${offline_inventory_skus}
    ${dict2}  Create Dictionary  store_id=1056  sku_numbers=${offline_inventory_skus}
    ${dict3}  Create Dictionary  store_id=-1  sku_numbers=${online_inventory_skus}
    Append To List  ${items}  ${dict1}  ${dict2}  ${dict3}
    FOR  ${item}  IN   @{items}
        ${res}  Query Store Inventory Of Mahattan - POST   store_id=${item["store_id"]}   sku_numbers=${item["sku_numbers"]}
        ${suk_number}  Create List
        FOR  ${data}  IN  @{res}
            IF  ${data["availableQuantity"]}<1000
                Append To List   ${suk_number}   ${data["skuNumber"]}
            END
        END
        ${length}  Get Length  ${suk_number}
        IF  ${length}>0
            Increase Store Inventory Of Mahattan - POST  quantity=10000  store_id=${item["store_id"]}   sku_numbers=${suk_number}
        END
    END
    ${res}    Query Store Inventory Of Mahattan - POST     store_id=1269   sku_numbers=${offline_inventory_skus}
    ${res}    Query Store Inventory Of Mahattan - POST     store_id=1056   sku_numbers=${offline_inventory_skus}
    ${res}    Query Store Inventory Of Mahattan - POST     store_id=-1     sku_numbers=${online_inventory_skus}


Test query Seller Store Inventorys - GET
    [Tags]  query_store_inventory
    query Seller Store Inventorys - GET  store_id=6102500606034460672   master_sku_number=6171138066075041792

Test Get And Edit Seller Store Inventorys
    [Tags]  store_inventory
    ${res}  Get And Edit Seller Store Inventorys - GET  store_id=6102500606034460672   master_sku_number=6171138066075041792  channel=2
    ${res}  Get And Edit Seller Store Inventorys - GET  store_id=6060911132037341184   master_sku_number=6066708581973032960  channel=2


Test Init User Gift Card
    [Tags]  init_gift_card
    ${res}  Get User Gift Card List - GET
    ${length}  Get Length   ${res}
    IF  ${length}>0
        FOR  ${gift_card}  IN  @{res}
            IF  ${gift_card["balance"]}<10
                ${gift_card_id}  Set Variable   ${gift_card["giftCardId"]}
                Delete User Gift Card - DELETE   ${gift_card_id}
            END
        END
        Get Init Gift Card Info
        Add User Gift Card - POST  ${gift_card_info}
    ELSE
        Get Init Gift Card Info
        Add User Gift Card - POST  ${gift_card_info}
    END


