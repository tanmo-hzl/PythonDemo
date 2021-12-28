*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot

*** Test Cases ***
Test Upload Media
    [Tags]   upload_media    smoke
    ${response}    post_media    ${base_url}   ${upload_media}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${mediaId}=     get from list   ${response}             1
    ${thumbnailUrl}=     get from list   ${response}        2
    should be equal as integers     ${status_code}     200
    should not be empty         ${mediaId}
    should not be empty         ${thumbnailUrl}

Test Upload Error Media
    [Tags]   upload_error_media
    ${response}    post_error_media    ${base_url}   ${upload_media}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${result}=         get from list   ${response}         1
    should be equal as integers     ${status_code}     400

Test Upload Empty Media
    [Tags]   upload_empty_media
    ${response}    post_error_media    ${base_url}   ${upload_media}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${result}=         get from list   ${response}         1
    should be equal as integers     ${status_code}     400

Test Create a new listing
    [Tags]   create_listing      smoke
    ${data}=    get_listing_data
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}
    should be equal     ${status_code}    200


Test Update a listing
    [Tags]   update_listing     smoke
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${data}=    get_update_listing_data
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200


Test Get one listing
    [Tags]   get_a_lisiting     smoke       read
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}
    ${data_content}     get from dictionary     ${response.json()}      data
    should not be empty     ${data_content}

Test Get one listing By SUB SKU
    [Tags]   get_a_lisiting_by_sub_sku         read
    ${sku_num}=     get_variation_sub_sku
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}
    ${data_content}     get from dictionary     ${response.json()}      data
    should not be empty     ${data_content}

Test Get one Nonexistent listing
    [Tags]   get_a_nonexistent_lisiting         read
    ${sku_num}=     set variable        abcd
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}      expected_status=404


Test Get bantch listing
    [Tags]   get_bantch_lisiting      smoke     read
    ${data}=    get_bantch_listing_data
    ${data_length}      get length         ${data}
    ${response}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}
    ${data_list}       get from dictionary    ${response.json()}        data
    ${data_list_length}      get length         ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}

Test Get bantch listing Contain Error Value
    [Tags]   get_bantch_lisiting_contain_error_value       read
    ${data}=    get_bantch_listing_data
    ${data_length}      get length         ${data}
    append to list      ${data}     abcd
    ${response}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}
    ${data_list}       get from dictionary    ${response.json()}        data
    ${data_list_length}      get length         ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}

Test Get bantch listing By SUB SKU
    [Tags]   get_bantch_lisiting_by_sub_sku        read
    ${data}=    get_sub_sku_list
    ${data_length}      get length         ${data}
    ${response}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}
    ${data_list}       get from dictionary    ${response.json()}        data
    ${data_list_length}      get length         ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}

Test Query listings With 60 SKU
    [Tags]   query_60_listing          read
    ${data}=    get_query_sixty_listing_data
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}
    record_sku_num      ${response.json()}

Test Get bantch listing By Exceed SKU
    [Tags]   get_bantch_lisiting_by_exceed_sku         read
    ${data}=    get_exceed_sub_sku_list
    ${response}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}     expected_status=400




Test Get listings in batch by seller SKU numbers
    [Tags]   get_listing_by_seller_sku     smoke     read
    ${seller_sku_data}=      tools.Get Seller Sku
    ${data}=    get from dictionary         ${seller_sku_data}      sellerSkuNumbers
    ${response}    Send Post Request  ${base_url}   ${get_lisiting_by_seller_sku}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Get listings in batch by Error seller SKU numbers
    [Tags]   get_listing_by_error_seller_sku         read
    ${seller_sku_data}=      tools.Get Seller Sku
    ${data}=    get from dictionary         ${seller_sku_data}      sellerSkuNumbers
    ${data_length}=     get length      ${data}
    append to list     ${data}      abcd
    ${response}    Send Post Request  ${base_url}   ${get_lisiting_by_seller_sku}   ${data}
    ${data_list}        get from dictionary         ${response.json()}         data
    ${data_list_length}     get length          ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}



Test Query listings
    [Tags]   query_listing      smoke       read
    ${data}=    get_query_listing_data
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Query Exceed Size listings
    [Tags]   query_exceed_listing           read
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      pageSize=101
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Zero Size listings
    [Tags]   query_zero_size_listing           read
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      pageSize=0
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Exceed Page Number listings
    [Tags]   query_exceed_page_num_listing          read
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      pageSize=1     pageNumber=999999999999999999999999
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400
#    ${data_dict}    get from dictionary     ${response.json()}      data
#    ${listings_list}        get from dictionary         ${data_dict}        listings
#    should be empty     ${listings_list}

Test Query Invalid Status listings
    [Tags]   query_invalid_status_listing          read
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      status=invalidStatus
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Invalid sortBy listings
    [Tags]   query_invalid_sort_listing           read
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      sortBy=invalidSort
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Invalid ascending listings
    [Tags]   query_invalid_ascending_listing           read
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      ascending=invalidascending
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400






Test Activate listings
    [Tags]   activate_listing      smoke
    ${data}=    get_activate_listing_data
    ${response}    Send Post Request      ${base_url}   ${activate_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    sleep   1s
    should be equal     ${status_code}    200

Test Deactivate listings
    [Tags]   deactivate_listing     smoke
    ${data}=    get_deactivate_listing_data
    ${response}    Send Post Request      ${base_url}   ${deactivate_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200


Test Download template file
    [Tags]   download_template     smoke        read
    ${data}=    get_download_template_data
    ${response}    Send Get Request      ${base_url}   ${download_template}    ${data}
    write_template      ${response.content}
    should be equal as integers     ${response.status_code}     200


Test Create listings by upload template file
    [Tags]   create_template_listing     smoke
    ${response}    post_template    ${base_url}   ${create_template_listing}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${msg}=     get from list   ${response}         1
    should be equal as integers     ${status_code}     200


Test Export listings to excel template file
    [Tags]   export_template_listing     smoke      read
    ${data}=    get_export_listing_data
    ${response}    Send Query Post Request     ${base_url}   ${export_template_listing}  ${data}
    write_expost_listing        ${response.content}
    should be equal as integers    ${response.status_code}    200







