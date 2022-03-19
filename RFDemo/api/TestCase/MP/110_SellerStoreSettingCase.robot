*** Settings ***
Resource            ../../Keywords/MP/SellerStoreSettingKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - Store Setting
Suite Teardown       Delete All Sessions

*** Variables ***
${seller_store_id}


*** Test Cases ***
Test Get Store Profile
    [Documentation]  test store profile
    [Tags]   mp-ea   ea-seller-storeSetting
    [Template]   Get StoreName And StoreId By useId - GET
    ${seller_user_id}        200
    99999                    404


Test Gest Store Profile By Error Info
    [Documentation]  test store profile
    [Tags]   mp-ea   ea-seller-storeSetting
    [Template]  Get StoreInfo By StoreId - GET
    ${seller_store_id}       200
    99999                    404

Test Update Store Name with once more - PATCH
    [Documentation]  test store profile
    [Tags]   mp-ea   ea-seller-storeSetting
    [Template]   Update Store Name - PATCH
    new_store_name    400
    ${null}           400

Test Update Store Profile
    [Documentation]  Update Store Profile
    [Tags]    mp-ea   ea-seller-storeSetting
    [Template]  Update Store Profile - POST
    ${seller_store_id}   New York,NY   10022   200
    9999                 New York,NY   10022   401

Test Update Constomer Service
    [Documentation]  Update Constomer Service
    [Tags]    mp-ea   ea-seller-storeSetting
    [Template]  Update Customer Service - POST
    ${seller-account}   ${seller_store_id}   200
    ${null}              ${null}             400


Test Update Fulfillment Info
    [Documentation]  Update Fulfillment Info
    [Tags]    mp-ea   ea-seller-storeSetting
#    Get Onboarding Verify - GET    false
#    Get Shipping Rate By StoreId - GET
    Verify Store profile - POST
    Add Shipping Rate - POST
    Update Store Fulfillment - POST
#    Get Onboarding Verify without storeId - GET
#    Get Onboarding Verify with error storeId - GET
#    Get Shipping Rate without StoreId - GET
#    Get Shipping Rate with error StoreId - GET
#    Add Shipping Rate with error params - POST

Test Update Return Policy
    [Documentation]  Update Return Policy, [30_day, 60_day, no_reutn] received
    [Tags]    mp-ea   ea-seller-storeSetting
    ${store_info}  Get StoreInfo By StoreId - GET   ${seller_store_id}    200
    Update return Option - POST  ${store_info}     no_reutn
    Update return Option - POST  ${store_info}     60_day
    Update return Option - POST  ${store_info}     30_day

Test Query Product Groups
    [Documentation]  Query Product Groups
    [Tags]    mp-ea   ea-seller-storeSetting
    Get Store Category Groups - GET

#    Get Store SellerStoreInfo - GET
#    Query Project Product - POST
#    Get Seller Email - GET
#    Get Store SellerStoreInfo - GET
#    Get ProductDetails - GET

Test Create Product Group
    [Documentation]  create store category
    [Tags]    mp-ea   ea-seller-storeSetting
    ${res}  Create Store Category - POST
    ${category_id}  Get Json Value  ${res}  categoryId
    ${products}  Get Store Groups Product - GET  key_words=gg
    ${suk_numbers}  Create List
    FOR  ${data}  IN  @{products["productResponses"]}
        Append To List   ${suk_numbers}   ${data["skuNumber"]}
        ${sku_length}  Get Length   ${suk_numbers}
        IF  ${sku_length}>=3
            Exit For Loop
        END
    END
    Create Store CategoryItems - POST  ${category_id}  ${suk_numbers}


Test Update Product Groups
    [Documentation]  Update Product Groups
    [Tags]    mp-ea   ea-seller-storeSetting
    ${category_group}  Get Store Category Groups - GET
    ${category_id}  Get Json Value  ${category_group}  data  categoryId
    ${product_detail}   Get ProductDetails - GET  ${category_id}
    FOR  ${product}   IN   @{product_detail["productInfo"]}
        ${item_id}  Set Variable  ${product["storeCategoryItemId"]}
        Remove Group Product Items - POST   ${category_id}  ${item_id}
    END
    ${suk_numbers}  Create List
    Create Store CategoryItems - POST  ${category_id}  ${suk_numbers}


Test Duplicate Product Groups
    [Documentation]  Duplicate Product Groups
    [Tags]    mp-ea   ea-seller-storeSetting
    ${category_group}  Get Store Category Groups - GET
    ${store_category_came}  Get Json Value  ${category_group}  data  categoryName
    ${category_id}  Get Json Value  ${category_group}   data   categoryId
    Duplicate Product Groups - POST  ${category_id}  ${store_category_came}

Test Delete Product Groups
    [Documentation]  Delete Product Groups
    [Tags]    mp-ea   ea-seller-storeSetting
    ${res}  Get Store Category Groups - GET
    ${category_length}  Get Length  ${res["data"]}
    FOR   ${sub_data}  IN  @{res["data"]}
        ${category_id}  Set Variable  ${sub_data["categoryId"]}
        Delete Project Product - DELETE  ${category_id}
        ${category_length}  Set Variable  ${category_length}-1
        IF  ${category_length}<=5
            Exit For Loop
        END
    END

Test Set Product Group Visible\Invisible In Storefront
    [Documentation]  Set Product Group Visible In Storefront
    [Tags]   mp-ea   ea-seller-storeSetting  KK
    ${res}  Get Store Category Groups - GET
#    Set Product Group Visible\Invisible In Storefront - PATCH  ${res["data"]}  True
    Set Product Group Visible\Invisible In Storefront - PATCH  ${res["data"]}  False

Test Open Product Groups
    [Documentation]  Open Product Groups
    [Tags]   mp-ea   ea-seller-storeSetting
    ${res}  Get Store Category Groups - GET
    ${category_id}  Get Json Value  ${res}   data   categoryId
    Open Product Groups - POST  ${category_id}

