*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot

*** Test Cases ***
Test Update a listing to 10 tags
    [Tags]   update_listing_10_tags
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
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_number       ${listing_data}      11
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}         expected_status=400

Test Update a listing to 10 tags
    [Tags]   update_listing_without_tag
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         remove_tag       ${listing_data}
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}         expected_status=400



Test Update a listing tag length to 20
    [Tags]   update_listing_tag_length_to_20
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
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_length       ${listing_data}      21
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}    expected_status=400

Test Update a listing tag length to 0
    [Tags]   update_listing_tag_length_to_0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         add_tag_length       ${listing_data}      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}    expected_status=400



Test Update a listing end date earlier
    [Tags]   update_listing_end_date_earlier
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_date      ${listing_data}      2021-01-01        2021-02-01
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${response_data}     get from dictionary        ${response.json()}       data
    ${listing_status}     get from dictionary        ${response_data}      status
    should be equal as strings      ${listing_status}         INACTIVE

Test Update a listing end date later
    [Tags]   update_listing_end_date_later
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_date      ${listing_data}      2000-01-01        2050-01-01
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}

Test Update a listing end date earlier than start date
    [Tags]   update_listing_end_date_earlier_than_start_date
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_date      ${listing_data}      2021-03-01        2021-02-01
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}         expected_status=400




Test Update a listing brand name 30
    [Tags]   update_listing_brand_name_30
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_brand_length     ${listing_data}    30
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}

Test Update a listing brand name 31
    [Tags]   update_listing_brand_name_31
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_brand_length     ${listing_data}    31
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing brand name 0
    [Tags]   update_listing_brand_name_0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_brand_length     ${listing_data}    0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400



Test Update a listing status to active
    [Tags]   update_listing_brand_to_active
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_status     ${listing_data}    ACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}

Test Update a listing status to draft
    [Tags]   update_listing_brand_to_draft
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_status     ${listing_data}    DRAFT
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing status to inactive
    [Tags]   update_listing_brand_to_inactive
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_status     ${listing_data}    INACTIVE
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}



Test Update a listing weight to 0
    [Tags]   update_listing_weight_to_0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     weight      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing width to 0
    [Tags]   update_listing_width_to_0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     width      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing length to 0
    [Tags]   update_listing_length_to_0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     length      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400

Test Update a listing height to 0
    [Tags]   update_listing_height_to_0
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${listing_data}=    get_update_listing_data
    ${data}         change_listing_shipment_item    ${listing_data}     height      0
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}     expected_status=400








