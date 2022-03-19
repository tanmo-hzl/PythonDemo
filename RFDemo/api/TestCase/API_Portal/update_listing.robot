*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Suite Setup          Run Keywords    Initial Env Data - API-Portal


*** Test Cases ***

Test Update a listing to 10 tags
    [Tags]   update_listing_10_tags
    [Documentation]     update listing and set tag amount to 10
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_number       ${listing_data}      10
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Update a listing to 10 tags
    [Tags]   update_listing_11_tags
    [Documentation]     update listing and set tag amount to 11
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_number       ${listing_data}      11
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}         expected_status=400

Test Update a listing without tag
    [Tags]   update_listing_without_tag
    [Documentation]     update listing and delete all tag
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         remove_tag       ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}         expected_status=400


Test Update a listing tag length to 20
    [Tags]   update_listing_tag_length_to_20
    [Documentation]     update listing and set a tag which length is 20 characters
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_length       ${listing_data}      20
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Update a listing tag length to 21
    [Tags]   update_listing_tag_length_to_21
    [Documentation]     update listing and set a tag which length is 21 characters
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_length       ${listing_data}      30
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}    expected_status=400

Test Update a listing tag length to 0
    [Tags]   update_listing_tag_length_to_0
    [Documentation]     update listing and set a tag which is null
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_length       ${listing_data}      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}    expected_status=400



Test Update a listing end date earlier
    [Tags]   update_listing_end_date_earlier
    [Documentation]     update listing and set start date and end date all earlier than now
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_date      ${listing_data}      2021-01-01        2021-02-01
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${response_data}     get from dictionary        ${response.json()}       data
    ${listing_status}     get from dictionary        ${response_data}      status
    should be equal as strings      ${listing_status}         EXPIRED

Test Update a listing end date later
    [Tags]   update_listing_end_date_later
    [Documentation]     update listing and set end date is later than now and start date earlier than now
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_date      ${listing_data}      2000-01-01        2050-01-01
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}

Test Update a listing end date earlier than start date
    [Tags]   update_listing_end_date_earlier_than_start_date
    [Documentation]     update listing and set start date earlier than end date
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_date      ${listing_data}      2021-03-01        2021-02-01
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}         expected_status=400




Test Update a listing brand name 30
    [Tags]   update_listing_brand_name_30
    [Documentation]     update listing and set a brand name which length is 30 characters
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_brand_length     ${listing_data}    30
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}

Test Update a listing brand name 31
    [Tags]   update_listing_brand_name_31
    [Documentation]     update listing and set a brand name which length is 31 characters
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_brand_length     ${listing_data}    40
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing brand name 0
    [Tags]   update_listing_brand_name_0
    [Documentation]     update listing and set a brand name which is null
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_brand_length     ${listing_data}    0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400



Test Update a listing status from active to inactive
    [Tags]   update_listing_status_between_active_and_inactive        change_status_test
    [Documentation]     test listing status change flow between active and inactive
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${status_list}=     create list         PENDING_REVIEW      ACTIVE
    ${data}         change_listing_status     ${listing_data}    ACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should contain      ${status_list}      ${listing_status}
    ${data}         change_listing_status     ${listing_data}    INACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should be equal as strings      ${listing_status}       INACTIVE
    ${data}         change_listing_status     ${listing_data}    ACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should contain      ${status_list}      ${listing_status}

Test Update a listing status from active to draft
    [Tags]   update_listing_status_from_active_to_draft         change_status_test
    [Documentation]     test listing status change flow between active and draft
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${status_list}=     create list         PENDING_REVIEW      ACTIVE
    ${data}         change_listing_status     ${listing_data}    ACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should contain      ${status_list}      ${listing_status}
    ${data}         change_listing_status     ${listing_data}    DRAFT
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing status from inactive to draft
    [Tags]   update_listing_status_from_inactive_to_draft       change_status_test
    [Documentation]     test listing status change flow between inactive and draft
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${status_list}=     create list         PENDING_REVIEW      ACTIVE
    ${data}         change_listing_status     ${listing_data}    ACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should contain      ${status_list}      ${listing_status}
    ${data}         change_listing_status     ${listing_data}    INACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should be equal as strings      ${listing_status}       INACTIVE
    ${data}         change_listing_status     ${listing_data}    DRAFT
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}         expected_status=400

Test Create a draft listing 1
    [Tags]   create_draft_listing_1       change_status_test
    [Documentation]     create a draft status listing
    ${listing_data}=    get_listing_data        is_variant=0
    ${data}=    change_listing_status     ${listing_data}    DRAFT
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}

Test Update a listing status from draft to inactive
    [Tags]   update_listing_status_from_draft_to_inactive       change_status_test
    [Documentation]     test listing status change flow between draft and inactive
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_status     ${listing_data}    INACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should be equal as strings      ${listing_status}       INACTIVE

Test Create a draft listing 2
    [Tags]   create_draft_listing_2       change_status_test
    [Documentation]     create a draft status listing
    ${listing_data}=    get_listing_data        is_variant=0
    ${data}=    change_listing_status     ${listing_data}    DRAFT
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}

Test Update a listing status from draft to active
    [Tags]   update_listing_status_from_draft_to_active       change_status_test
    [Documentation]     test listing status change flow between draft and active
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${status_list}=     create list         PENDING_REVIEW      ACTIVE
    ${data}         change_listing_status     ${listing_data}    ACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${listing_status}       get_listing_status      ${response.json()}
    should contain      ${status_list}      ${listing_status}




Test Update a listing weight to 0
    [Tags]   update_listing_weight_to_0
    [Documentation]     update listing and set sku weight to 0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     weight      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing width to 0
    [Tags]   update_listing_width_to_0
    [Documentation]     update listing and set sku width to 0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     width      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing length to 0
    [Tags]   update_listing_length_to_0
    [Documentation]     update listing and set sku length to 0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     length      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing height to 0
    [Tags]   update_listing_height_to_0
    [Documentation]     update listing and set sku height to 0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     height      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

#Test Update a listing invalid percent off
#    [Tags]   update_listing_invalid_percent
#    ${data}=    get_primary_sku_num
#    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
#    ${url}=        merge_urls    ${update_listing}     ${sku_num}
#    ${listing_data}=    get_update_listing_data
#    ${data}         change_listing_percent_off    ${listing_data}     34.4444444444444
#    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400


Test Update Inactive listing
    [Tags]   update_inactive_listing      change_status_test
    [Documentation]     update a inactive status listing
    ${listing_data}=    get_listing_data        is_variant=0
    ${listing_data}=    change_listing_status     ${listing_data}    ACTIVE
    ${data}         change_date      ${listing_data}      2021-01-01        2021-02-01
    ${response}    Send Post Request  ${base_url}   ${create_listing}    ${data}
    ${response_data}     get from dictionary        ${response.json()}       data
    ${listing_status}     get from dictionary        ${response_data}      status
    should be equal as strings      ${listing_status}         EXPIRED
    record_listing      ${response.json()}

    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${data}=    get_update_listing_data
    ${data}=    change_listing_name         ${data}         update_inactive_test
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}


Test Update GTIN
    [Tags]   update_GTIN
    [Documentation]     update a listing and change GTIN
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_gtin_type     ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}        expected_status=400


Test Update invalid item name
    [Tags]   update_invalid_item_name
    [Documentation]     update a listing and set a invalid item name
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_invalid_item_name     ${listing_data}        0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}        expected_status=400
    ${data}         change_invalid_item_name     ${listing_data}        1
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}        expected_status=400

Test Update invalid color family
    [Tags]   update_invalid_color_family
    [Documentation]     update a listing and set a invalid color family
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_invalid_color_family     ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}        expected_status=400

Test Update invalid color name
    [Tags]   update_invalid_color_name
    [Documentation]     update a listing and set a invalid color name
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_invalid_color_name     ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}        expected_status=400

Test Update invalid vendor name
    [Tags]   update_invalid_vendor_name
    [Documentation]     update a listing and set a invalid vendor name
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_invalid_vendor_name     ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}        expected_status=400

Test Update invalid manufacture name
    [Tags]   update_invalid_manufacture_name
    [Documentation]     update a listing and set a invalid manufacture name
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_invalid_manufacture_name     ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}        expected_status=400

Test Update a listing itemname
    [Tags]   update_listing_itemname
    [Documentation]     update a listing and set item name with some special characters
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_item_name       ${listing_data}      *&^*%$@$11◆★▶◑▁™◪¶♯♀◁ΟΘκÇÐÖÉÆÐρしにせソЩИуо╋╦╱┞║┪┹┠╀
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${data}         change_item_name       ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
    ${data}         change_exceed_item_name       ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test lack base key
    [Tags]   lack_base_key
    [Documentation]     test if api will return error when lack requeired key in document to crate listing without variation
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    FOR    ${key}      IN      @{base_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_base_key      ${listing_data}     ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{detail_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_base_key      ${listing_data}   details   ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{shipping_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_base_key      ${listing_data}   shippingAndRegulation   ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{price_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_base_key      ${listing_data}   priceAndInventory   ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    ${listing_data}=    get_update_listing_data
    ${data}         delete_base_key      ${listing_data}   media   medias
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
    ${code}     get from dictionary      ${response.json()}     code
    should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    ${listing_data}=    get_update_listing_data
    ${data}         delete_mediaId      ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
    ${code}     get from dictionary      ${response.json()}     code
    should be equal as strings           ${code}    MCU_API_BAD_REQUEST

Test create least field for master listing
    [Tags]   create_least_field_listing
    [Documentation]     only use requeired key in document to create a listing without variation
    ${data}=    get_least_detail_data
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}

Test variation lack base key
    [Tags]   variation_lack_base_key
    [Documentation]     test if api will return error when lack requeired key in document to crate variation listing

    ${data}=    get_listing_data
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}

    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    FOR    ${key}      IN      @{variationDetails_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_variation_key      ${listing_data}   ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{variation_detail_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_variation_key      ${listing_data}   details     ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{variat_detail_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_base_key      ${listing_data}   details     ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{variation_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_base_key      ${listing_data}   variation     ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{variation_price_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_variation_key      ${listing_data}   priceAndInventory     ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{variation_shipping_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_variation_key      ${listing_data}   shippingAndRegulation     ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    FOR    ${key}      IN      @{variants_key}
        ${listing_data}=    get_update_listing_data
        ${data}         delete_variats_key      ${listing_data}  ${key}
        ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
        ${code}     get from dictionary      ${response.json()}     code
        should be equal as strings           ${code}    MCU_API_BAD_REQUEST
    END
    ${listing_data}=    get_update_listing_data
    ${data}         delete_variation_media_key      ${listing_data}   mediaUrl
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
    ${code}     get from dictionary      ${response.json()}     code
    should be equal as strings           ${code}    MCU_API_BAD_REQUEST
#    ${listing_data}=    get_update_listing_data
#    ${data}         delete_variation_key      ${listing_data}   media  medias
#    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
#    ${code}     get from dictionary      ${response.json()}     code
#    should be equal as strings           ${code}    MCU_API_BAD_REQUEST
#    ${listing_data}=    get_update_listing_data
#    ${data}         delete_variantOptions_key      ${listing_data}   swatchMedia  mediaUrl
#    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400
#    ${code}     get from dictionary      ${response.json()}     code
#    should be equal as strings           ${code}    MCU_API_BAD_REQUEST

Test create least field for variation listing
    [Tags]   create_least_field_variation_listing
    [Documentation]     only use requeired key in document to create a variation listing
    ${data}=    get_least_listing_data
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}