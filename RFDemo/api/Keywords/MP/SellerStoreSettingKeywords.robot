*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodySellerStoreSetting.py
Resource            ../../TestData/MP/PathSellerStoreSetting.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller_headers}
${seller_headers_post}
${seller_info_sign}
${seller_store_id}
${seller-account}
${variant_contents}
${categoryId}
${seller-account}

*** Keywords ***
Set Initial Data - Store Setting
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


Get StoreName And StoreId By useId - GET
    [Arguments]  ${seller_user_id}   ${status}
    ${res}    send get request    ${url-mik}    /mda/store/store-id/${seller_user_id}    ${NULL}   ${seller_headers}   ${status}

Get StoreInfo By StoreId - GET
    [Arguments]  ${seller_store_id}   ${status}
    ${res}    send get request    ${url-mik}    /mda/store/store-info/${seller_store_id}   ${NULL}   ${seller_headers}  ${status}
    [Return]  ${res.json()}

Update Store Name - PATCH
    [Arguments]    ${newName}  ${status}
    ${body}    create dictionary      newName=${newName}
    send patch request - Params   ${URL-MIK}   /mda/store/rename/${seller_store_id}/application    ${body}   ${seller_headers_post}  ${status}


Update Store Name without arguments - PATCH
    ${body}    create dictionary      newName=${NULL}
    send patch request - Params   ${URL-MIK}    /mda/store/rename/${seller_store_id}/application    ${body}   ${seller_headers_post}    400

Update Store Profile - POST
    [Arguments]  ${store_id}=${seller_store_id}  ${store_location}=New York,NY  ${zip_code}=10022   ${status}=200
    ${body}     update store profile body   ${store_id}   ${store_location}  ${zip_code}
    ${res}      send post request    ${URL-MIK}    /mda/store/profile-v2     ${body}     ${seller_headers_post}  ${status}


Update Customer Service - POST
    [Arguments]   ${seller-account}  ${seller_store_id}   ${status}
    ${body}    update customer service body     ${seller-account}   ${seller_store_id}
    send post request    ${URL-MIK}     /mda/store/new-customer-service    ${body}     ${seller_headers_post}   ${status}

Verify Store profile - POST
    ${body}  get store fulfillment body    ${seller_store_id}
    Send Post Request  ${URL-MIK}  /mda/store/profile/verify   ${body}   ${seller_headers_post}

Add Shipping Rate - POST
    ${body}    add shipping rate body
    send post request    ${URL-MIK}   /mda/shipping-rate/add  ${body}   ${seller_headers_post}

Update Store Fulfillment - POST
    ${body}    get store fulfillment body    ${seller_store_id}
    send post request    ${URL-MIK}    /mda/store/fulfillment  ${body}   ${seller_headers_post}

Update return Option - POST
    [Arguments]   ${store_info}   ${return_policy}
    ${body}    update return option body    ${store_info}  ${return_policy}
    ${res}    send post request   ${URL-MIK}     ${store-return-option}  ${body}   ${seller_headers_post}

Get Store Category Groups - GET
    ${res}  send get request   ${URL-MIK}   /mda/store-category/${seller_store_id}/groups   ${NULL}   ${seller_headers}
    Return From Keyword  ${res.json()}

Create Store Category - POST
    ${categoryName}    evaluate     "Group "+str(random.randint(1000000,9999999))
    ${body}   create_store_category_body    ${seller_store_id}    ${categoryName}    ${seller_user_id}
    ${res}  send post request    ${URL-MIK}   /mda/store-category/category  ${body}   ${seller_headers_post}
    [Return]  ${res.json()}

Create Store CategoryItems - POST
    [Arguments]    ${category_id}  ${suk_numbers}
    ${body}   create_store_category_items_body   ${category_id}  ${suk_numbers}   ${seller_store_id}    ${seller_user_id}
    send post request   ${URL-MIK}   /mda/store-category/categoryItems  ${body}   ${seller_headers_post}

Duplicate Product Groups - POST
    [Arguments]  ${category_id}  ${store_category_came}
    ${body}  duplicate_product_groups_body    ${seller_store_id}   ${seller_user_id}   ${store_category_came}
    send post request    ${URL-MIK}   /mda/store-category/${category_id}/duplicate-product-group    ${body}   ${seller_headers_post}

Delete Project Product - DELETE
    [Arguments]  ${category_id}
    send delete request   ${URL-MIK}   /mda/store-category/${category_id}  ${NULL}   ${seller_headers_post}

Get Store Groups Product - GET
    [Arguments]   ${key_words}
    ${res}  Send Get Request  ${URL-MIK}  /mda/product/${seller_store_id}/get-StoreGroups/${key_words}  ${NULL}   ${seller_headers}
    [Return]  ${res.json()}

Get ProductDetails - GET
    [Arguments]  ${category_id}
    ${res}  send get request   ${URL-MIK}   /mda/store-category/${category_id}/productDetails    ${NULL}   ${seller_headers}
    [Return]   ${res.json()}

Remove Group Product Items - POST
    [Arguments]  ${category_id}  ${item_id}
    ${body}  get_remove_group_item_body   ${category_id}  ${item_id}
    Send Post Request   ${URL-MIK}  /mda/store-category/categoryItem/remove  ${body}  ${seller_headers_post}

Set Product Group Visible\Invisible In Storefront - PATCH
    [Arguments]   ${product_groups}  ${is_visible}
    ${body}  get_set_product_group_visible_body  ${product_groups}  ${is_visible}
    Send Patch Request - Params And Json  ${URL-MIK}  /mda/store-category/${seller_store_id}/product-groups  ${null}  ${body}  ${seller_headers_post}

Open Product Groups - POST
    [Arguments]   ${category_id}
    ${body}    open product groups body    ${categoryId}
    ${res}    send post request    ${URL-MIK}    /mda/store-category/store/${seller_store_id}/grouped-listings  ${body}   ${seller_headers_post}

Get Shipping Rate By StoreId - GET
    ${body}    create dictionary      storeId=${seller_store_id}
    ${res}    send get request    ${url-mik}    ${shipping-rate-all}  ${body}   ${seller_headers}

Get Shipping Rate without StoreId - GET
    ${body}    create dictionary      storeId=${NULL}
    ${res}    send get request    ${url-mik}    ${shipping-rate-all}  ${body}   ${seller_headers}

Get Shipping Rate with error StoreId - GET
    ${store_id}    evaluate     random.randint(10000000,99999999)
    ${body}    create dictionary      storeId=${store_id}
    ${res}    send get request    ${url-mik}    ${shipping-rate-all}  ${body}   ${seller_headers}


Get Onboarding Verify - GET
    [Arguments]    ${flash}
    ${body}    create dictionary      isCreate=${flash}
    ${res}    send get request    ${url-mik}    ${onboarding-verify}/${seller_store_id}  ${body}   ${seller_headers}

Get Onboarding Verify without storeId - GET
    [Arguments]    ${flash}
    ${body}    create dictionary      isCreate=${flash}
    ${res}    send get request    ${url-mik}    ${onboarding-verify}/${NULL}  ${body}   ${seller_headers}    401

Get Onboarding Verify with error storeId - GET
    [Arguments]    ${flash}
    ${store_id}    evaluate     random.randint(10000000,99999999)
    ${body}    create dictionary      isCreate=${flash}
    ${res}    send get request    ${url-mik}    ${onboarding-verify}/${store_id}  ${body}   ${seller_headers}    401


Add Shipping Rate with error params - POST
    ${body}    add shipping rate with error params body
    ${res}    send post request    ${url-mik}    ${shipping-rate-add}  ${body}   ${seller_headers_post}


Update Product Groups - PATCH
    [Arguments]    ${isAtStorefront}
    ${categoryName}    evaluate     "Group "+str(random.randint(10000,99999))
    ${body}    update product groups categoryItems body    ${categoryId}  ${categoryName}    ${isAtStorefront}
    ${res}    send patch request    ${url-mik}    ${mda-store-category}/${seller_store_id}/product-groups    ${body}   ${seller_headers_post}

Update Store Category CategoryItems - POST
    ${seller_user_id}     get json value    ${seller_info_sign}    user    id
    ${body}   update store category categoryItems body    ${seller_store_id}    ${categoryId}    ${seller_user_id}
    ${res}    send post request    ${url-mik}    ${store-return-option}  ${body}   ${seller_headers_post}



Create Store Category without categoryName - POST
    ${body}   create store category body    ${seller_store_id}    ${NULL}    ${seller_user_id}
    ${res}    send post request    ${url-mik}    ${store-category}  ${body}   ${seller_headers_post}    401

Create Store Category with error StoreId - POST
    ${categoryName}    evaluate     "Group "+str(random.randint(1000000,9999999))
    ${store_id}    evaluate     random.randint(1000000,9999999)
    ${body}   create store category body    ${store_id}    ${categoryName}    ${seller_user_id}
    ${res}    send post request    ${url-mik}    ${store-category}  ${body}   ${seller_headers_post}    401

Create Store Category with error userId - POST
    ${categoryName}    evaluate     "Group "+str(random.randint(1000000,9999999))
    ${user_id}    evaluate     random.randint(1000000,9999999)
    ${body}   create store category body    ${seller_store_id}    ${categoryName}    ${user_id}
    ${res}    send post request    ${url-mik}    ${store-category}  ${body}   ${seller_headers_post}    401


Get Store SellerStoreInfo - GET
    ${body}   create dictionary    storeId=${seller_store_id}
    ${res}    send get request    ${url-mik}    ${store-getSellerStoreInfo}  ${body}   ${seller_headers}

Query Project Product - POST
    ${body}  query project product body
    ${res}    send post request    ${url-mik}    ${project-product-query}  ${body}   ${seller_headers_post}

Get Seller Email - GET
    ${res}    send get request    ${url-mik}    ${store-status}/${seller-account}}  ${NUll}   ${seller_headers}


Search StoreGroups - GET
    [Arguments]    ${context}
    ${res}    send get request    ${url-mik}    ${mda-product}/${seller_store_id}/get-StoreGroups/${context}  ${NULL}   ${seller_headers}