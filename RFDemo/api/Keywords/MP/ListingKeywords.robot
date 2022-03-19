*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyListing.py
Library             ../../Libraries/RwXlsxFile.py
Resource            ../../TestData/MP/PathListing.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller_headers}
${seller_headers_post}
${seller_info_sign}
${seller_store_id}
${seller-account}
${sku}
${variant_contents}
${quantity}

*** Keywords ***
Set Initial Data - Listing
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

Upload Listing JPEG - POST
    ${seller_info_sign}    Read File    seller-info-sign
    ${token}    Get Json Value    ${seller_info_sign}     token
    ${res}    upload_img_to_cms    ${URL-MIK}    ${cms-v2-uploadFilesToGcs}
    [Return]   ${res.json()}

Get Seller Listings List - GET
    ${res}    Send Get Request    ${URL-MIK-MDA}    ${mik-store-path}${seller_store_id}${mik-store-listings}    ${null}    ${seller_headers}
    ${length}  Get Length  ${res.json()["listings"]}
    Run Keyword If  ${length}==0  Skip  there don't have listing
    Set Suite Variable  ${sku}   ${res.json()["listings"][0]["sku"]}
    [Return]   ${res.json()["listings"]}

Get Seller Listing Detail
    [Arguments]   ${sku}
    ${res}    Send Get Request    ${URL-MIK-MDA}    ${mik-store-path}${seller_store_id}/listingInfo/${sku}   ${null}   ${seller_headers}
    [Return]   ${res.json()}

Get Category Path
    ${res}    Send Get Request    ${URL-MIK}    ${mik-sch-category}    ${null}    ${seller_headers}
    Set Suite Variable  ${items}   ${res.json()["searchResults"]["items"][:100]}

Get Attribute Get Variants
    [Arguments]   ${taxonomy_path}
    ${body}  Create Dictionary   channel=2   taxonomyPath=${taxonomy_path}
    ${res}   Send Post Request - Params And Json   ${URL-MIK-MDA}   ${get-attribute-variants}   ${null}   ${body}

Create Listing Flow Add Listing Detail - 1
    Get Category Path
    ${body}    get_create_listing_detail_body   ${items}
    ${res}     Send Patch Request - Params And Json   ${URL-MIK-MDA}   ${mik-store-path}${seller_store_id}${mik-listing-detail}   ${null}   ${body}   ${seller_headers_post}
    ${sku}     Get Json Value   ${res.json()}   data   masterSkuNumber
    Set Suite Variable   ${sku}   ${sku}

Create Listing Flow Add Inventory And Pricing - 2
    [Arguments]   ${quantity}=${null}
    ${res}  Upload Listing JPEG - POST
    ${uploaded_files}  Get Json Value   ${res}   data  uploadedFiles
    ${body}    get_inventory_and_pricing_body  ${uploaded_files}   ${sku}   ${quantity}
    Send Patch Request - Params And Json   ${URL-MIK-MDA}   ${add-inventory-and-pricing}   ${null}   ${body}   ${seller_headers_post}

Create Listing Flow Add Inventory And Pricing With Variant - 2
    ${res}   get_with_variant_inventory_and_pricing_body  ${URL-MIK}   ${cms-v2-uploadFilesToGcs}   ${sku}
    Send Patch Request - Params And Json   ${URL-MIK-MDA}   ${add-inventory-and-pricing}   ${null}   ${res[0]}   ${seller_headers_post}
    Set Suite Variable    ${variant_contents}   ${res[1]}

Create Listing Flow Shipping And Return - 3
    ${body}    get_shipping_and_return_body
    Send Patch Request - Params And Json  ${URL-MIK-MDA}   /store/${seller_store_id}/listing/${sku}/shipping   ${null}   ${body}   ${seller_headers_post}

Create Listing Flow Shipping With Variant - 3
    ${body}    get_shipping_with_variant_body   ${variant_contents}
    Send Patch Request - Params And Json  ${URL-MIK-MDA}  /store/${seller_store_id}/listing/${sku}/shipping   ${null}   ${body}   ${seller_headers_post}

Create Listing Flow Publish - 4
    Send Patch Request   ${URL-MIK-MDA}    /store/${seller_store_id}/listing/activate/${sku}   ${null}   ${seller_headers_post}

Create Listing Without Variant
    Create Listing Flow Add Listing Detail - 1
    Create Listing Flow Add Inventory And Pricing - 2
    Create Listing Flow Shipping And Return - 3
    Create Listing Flow Publish - 4


Search Listing By Ttitle or Sku - GET
    [Arguments]    ${key_word}
    ${param}  Create Dictionary  keyword=${key_word}
    Send Get Request   ${URL-MIK-MDA}   /store/${seller_store_id}/search-listings   ${param}  ${seller_headers}

Export All Listings - POST
    [Arguments]   ${export_list}
    ${res}  Send Post Request - Params And Json   ${URL-MIK-MDA}  /store/${seller_store_id}/export-all-listings  ${null}   ${export_list}  ${seller_headers_post}
    Save Excel File  All_listings_${seller_store_id}.xlsx   ${res}

Import Excel Data
    [Arguments]  ${file_name}
    ${token}   Read File    token-seller
    import_listing_excel  ${URL-MIK-MDA}   ${token}   ${file_name}


Create New Listing - Save Draft On step1
    Get Category Path
    ${body}  get_create_listing_step1_body   ${items}
    ${res}  Send Post Request - Params And Json  ${URL-MIK-MDA}  /ea/online/product/save  ${null}  ${body}  ${seller_headers_post}
    ${sku}     Get Json Value   ${res.json()}   data   masterSkuNumber
    Set Suite Variable   ${sku}   ${sku}

Create new Listing - No Variants - Save Draft On Step 2
    ${res}  Upload Listing JPEG - POST
    ${uploaded_files}  Get Json Value   ${res}   data  uploadedFiles
    ${body}  get_create_listing_step2_no_variants_body  ${sku}  ${uploaded_files}
    Send Post Request - Params And Json  ${URL-MIK-MDA}  /ea/online/product/save  ${null}  ${body}  ${seller_headers_post}

Create New Listing - Have Variants - Save Draft On Step 2
    ${res}  Upload Listing JPEG - POST
    ${uploaded_files}  Get Json Value   ${res}   data  uploadedFiles
    ${body}  get_create_listing_step2_have_variants_body  ${sku}  ${uploaded_files}
    Send Post Request - Params And Json  ${URL-MIK-MDA}  /ea/online/product/save  ${null}  ${body}  ${seller_headers_post}

Create New Listing - No Variants - Save Draft On Step 3
    ${body}  get_create_listing_step3_no_variants_body   ${sku}
    Send Post Request - Params And Json  ${URL-MIK-MDA}  /ea/online/product/save  ${null}  ${body}  ${seller_headers_post}

Create New Listing - Have Variants - Save Draft On Step 3
    ${body}  get_create_listing_step3_have_variants_body  ${sku}  ${variant_contents}
    Send Post Request - Params And Json  ${URL-MIK-MDA}  /ea/online/product/save  ${null}  ${body}  ${seller_headers_post}

Create Listing - No Variants - Save Changes
    [Arguments]   ${now_sku}   ${media}
    ${body}   get_publish_or_update_no_variants_body  ${now_sku}    ${media}
    Send Post Request - Params And Json  ${URL-MIK-MDA}   /ea/online/product/save  ${null}  ${body}  ${seller_headers_post}

Create Listing - No variants - Publish
    [Arguments]   ${now_sku}   ${media}
    ${body}   get_publish_or_update_no_variants_body  ${now_sku}   ${media}
    Send Put Request   ${URL-MIK-MDA}   /ea/online/product/edit   ${body}   ${seller_headers_post}

Create Listing - Have Variants - Save Changes
    [Arguments]   ${now_sku}  ${data}
    ${body}   get_publish_or_update_have_variants_body  ${now_sku}   ${data}
    Send Post Request - Params And Json  ${URL-MIK-MDA}   /ea/online/product/save  ${null}  ${body}  ${seller_headers_post}

Create Listing - Have Variants - Publish
    [Arguments]   ${now_sku}  ${data}
    ${body}   get_publish_or_update_have_variants_body  ${now_sku}   ${data}
    Send Put Request  ${URL-MIK-MDA}   /ea/online/product/edit   ${body}   ${seller_headers_post}

Delete XX Listing Status
    [Arguments]  ${sku}
    Send Patch Request   ${URL-MIK-MDA}   /store/${seller_store_id}/listing/delete/${sku}  ${null}   ${seller_headers_post}

Recover Archived Listing to Draft/Inactive
    [Arguments]  ${sku}
    Send Patch Request   ${URL-MIK-MDA}   /store/${seller_store_id}/listing/recover/${sku}  ${null}   ${seller_headers_post}

Relist Inactivate Listing to Active
    [Arguments]  ${now_sku}
    ${body}   get_relist_inactivate_to_active_body  ${now_sku}
    Send Patch Request - Params And Json  ${URL-MIK-MDA}  /store/listing/relist  ${null}  ${body}   ${seller_headers_post}

Change Activate Listing to Inactive
    [Arguments]  ${now_sku}
    Send Patch Request   ${URL-MIK-MDA}   /store/${seller_store_id}/listing/deactivate/${now_sku}   ${null}  ${seller_headers_post}
