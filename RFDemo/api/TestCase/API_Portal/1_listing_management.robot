*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Suite Setup          Run Keywords    Initial Env Data - API-Portal


*** Test Cases ***
Test Check authentication
    [Tags]   test_authentication   smoke
    [Documentation]     check api-key validation in config file
    ${response}    Send Get Request  ${base_url}   ${test_authentication}

Test Upload Media
    [Tags]   upload_media    smoke
    [Documentation]     random choose a file in test-photo and upload to get a michaels image URL
    ${response}    post_media    ${base_url}   ${upload_media}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${mediaId}=     get from list   ${response}             1
    ${thumbnailUrl}=     get from list   ${response}        2
    should be equal as integers     ${status_code}     200      ${thumbnailUrl}
    should not be empty         ${mediaId}
    should not be empty         ${thumbnailUrl}

Test Upload Error Media
    [Tags]   upload_error_media
    [Documentation]     use non-img file to get img URL
    ${response}    post_error_media    ${base_url}   ${upload_media}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${result}=         get from list   ${response}         1
    should be equal as integers     ${status_code}     400

Test Upload Empty Media
    [Tags]   upload_empty_media
    [Documentation]     get img URL without upload file
    ${response}    post_empty_media    ${base_url}   ${upload_media}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${result}=         get from list   ${response}         1
    should be equal as integers     ${status_code}     400

Test Create a new listing without variant
    [Tags]   create_listing_without_variant      smoke
    [Documentation]     random generate non-variants listing data according to document and create listing
    ${data}=    get_listing_data       isis_variant=0
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}

Test Create a new listing
    [Tags]   create_listing      smoke
    [Documentation]     random generate variants listing data according to document and create listing
    ${data}=    get_listing_data
    ${response}    Send Post Request  ${base_url}   ${create_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    record_listing      ${response.json()}

Test Update a listing
    [Tags]   update_listing     smoke
    [Documentation]     update listing by master sku, using the same data
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${update_listing}     ${sku_num}
    ${data}=    get_update_listing_data
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Update a listing by sellersku
    [Tags]   update_listing_by_seller_sku  smoke
    [Documentation]     update listing by seller sku, using the same data
    ${data}=    get_primary_seller_sku
    ${sellersku_num}=     get from dictionary     ${data}     sellerSkuNumbers
#    ${sellersku_num}=     set variable    aaa
    ${url}=        merge_urls    ${update_listing_by_sellerslu}     ${sellersku_num}
    ${data}=    get_update_listing_data
    ${response}    Send Put Request  ${base_url}   ${url}   ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Get one listing
    [Tags]   get_a_listing     smoke       read
    [Documentation]     search listing data by master sku
    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}
    ${data_content}     get from dictionary     ${response.json()}      data
    should not be empty     ${data_content}

Test Get one listing By SUB SKU
    [Tags]   get_a_listing_by_sub_sku         read
    [Documentation]     search listing data by sub sku
    ${sku_num}=     get_variation_sub_sku
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}
    ${data_content}     get from dictionary     ${response.json()}      data
    should not be empty     ${data_content}


Test Get bantch listing
    [Tags]   get_bantch_listing      smoke     read
    [Documentation]     search numbers of listings data by master sku
    ${data}=    get_bantch_listing_data
    ${data_length}      get length         ${data}
    ${response}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}
    ${data_list}       get from dictionary    ${response.json()}        data
    ${data_list_length}      get length         ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}

Test Get bantch listing Contain Error Value
    [Tags]   get_bantch_listing_contain_error_value       read
    [Documentation]     search numbers of listing data by master sku list which contain inavlid sku
    ${data}=    get_bantch_listing_data
    ${data_length}      get length         ${data}
    append to list      ${data}     abcd
    ${response}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}
    ${data_list}       get from dictionary    ${response.json()}        data
    ${data_list_length}      get length         ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}

Test Get bantch listing By SUB SKU
    [Tags]   get_bantch_listing_by_sub_sku        read
    [Documentation]     search numbers of listings data by sub sku
    ${data}=    get_sub_sku_list
    ${data}   Set Variable   ${data[:50]}
    ${data_length}      get length         ${data}
    ${response}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}
    ${data_list}       get from dictionary    ${response.json()}        data
    ${data_list_length}      get length         ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}

Test Query listings With 60 SKU
    [Tags]   query_60_listing          read
    [Documentation]     query 101 listings at once and prepare to search
    ${data}=    get_query_sixty_listing_data
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}
    record_sku_num      ${response.json()}

Test Get bantch listing By Exceed SKU
    [Tags]   get_bantch_lisiting_by_exceed_sku         read
    [Documentation]     search 101 listings data by master sku
    ${data}=    get_exceed_sub_sku_list
    ${response1}    Send Post Request  ${base_url}   ${get_bantch_lisiting}  ${data}     expected_status=400


Test Get listings in batch by seller SKU numbers
    [Tags]   get_listing_by_seller_sku     smoke     read
    [Documentation]     search numbers of listings data by seller sku
    ${seller_sku_data}=      tools.Get Seller Sku
    ${data}=    get from dictionary         ${seller_sku_data}      sellerSkuNumbers
    ${response}    Send Post Request  ${base_url}   ${get_lisiting_by_seller_sku}   ${data[:50]}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Get listings in batch by Error seller SKU numbers
    [Tags]   get_listing_by_error_seller_sku         read
    [Documentation]     search numbers of listing data by seller sku list which contain inavlid sku
    ${seller_sku_data}=      tools.Get Seller Sku
    ${data}=    get from dictionary         ${seller_sku_data}      sellerSkuNumbers
    ${data}    Set Variable   ${data[:49]}
    ${data_length}=     get length      ${data}
    append to list     ${data}      abcd
    ${response}    Send Post Request  ${base_url}   ${get_lisiting_by_seller_sku}   ${data}
    ${data_list}        get from dictionary         ${response.json()}         data
    ${data_list_length}     get length          ${data_list}
    should be equal as integers         ${data_length}          ${data_list_length}

Test Get exceed listings in batch by seller SKU numbers
    [Tags]   get_exceed_listing_by_seller_sku     smoke     read
    [Documentation]     search 101 listings data by seller sku
    ${data}=      get_exceed_seller_sku_list
    ${response}    Send Post Request  ${base_url}   ${get_lisiting_by_seller_sku}   ${data}     expected_status=400


Test Query listings
    [Tags]   query_listing      smoke       read
    [Documentation]     query listing with random parameter according the document
    ${data}=    get_query_listing_data
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}
    should be equal     ${status_code}    200

Test Query Exceed Size listings
    [Tags]   query_exceed_listing           read
    [Documentation]     query listing with pagesize = 101
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      pageSize=101
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Zero Size listings
    [Tags]   query_zero_size_listing           read
    [Documentation]     query listing with pagesize = 0
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      pageSize=0
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Exceed Page Number listings
    [Tags]   query_exceed_page_num_listing          read
    [Documentation]     query listing with exceed pageNumber
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      pageSize=1     pageNumber=999999999999999999999999
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Invalid Status listings
    [Tags]   query_invalid_status_listing          read
    [Documentation]     query listing with ivalid status value
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      status=invalidStatus
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Invalid sortBy listings
    [Tags]   query_invalid_sort_listing           read
    [Documentation]     query listing with ivalid sortBy value
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      sortBy=invalidSort
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400

Test Query Invalid ascending listings
    [Tags]   query_invalid_ascending_listing           read
    [Documentation]     query listing with ivalid ascending value
    ${data}=    get_query_listing_data
    set to dictionary      ${data}      ascending=invalidascending
    ${response}    Send Get Request      ${base_url}   ${query_listing}  ${data}        expected_status=400



Test Activate listings earlier than today
    [Tags]   activate_listing_earlier_than_today
    [Documentation]     activate a listing and set start date and end date earlier than today
    ${data}=    get_deactivate_listing_data
    ${response}    Send Post Request      ${base_url}   ${deactivate_listing}  ${data}

    ${data}=    get_activate_listing_data
    ${data}         set to dictionary        ${data}         availableFrom=2020-01-01
    ${data}         set to dictionary        ${data}         availableTo=2020-02-01
    ${response}    Send Post Request      ${base_url}   ${activate_listing}  ${data}        expected_status=400

    ${data}=    get_primary_sku_num
    ${sku_num}=     get from dictionary     ${data}     primarySkuNumber
    ${url}=        merge_urls    ${get_one_lisiting}     ${sku_num}
    ${response}    Send Get Request     ${base_url}     ${url}
    ${data_dict}        get from dictionary         ${response.json()}      data
    ${status}        get from dictionary         ${data_dict}      status
    should be equal as strings      ${status}       INACTIVE

Test Activate listings
    [Tags]   activate_listing      smoke
    [Documentation]     activate a listing and make listing status to active
    ${data}=    get_activate_listing_data
    ${response}    Send Post Request      ${base_url}   ${activate_listing}  ${data}
    ${status_code}     get_status_code    ${response.json()}

Test Activate listings by error date
    [Tags]   activate_listing_by_error_date
    [Documentation]     activate a listing, set start date later than end date
    ${data}=    get_activate_listing_data
    ${data}         set to dictionary        ${data}         availableFrom=2020-03-01
    ${data}         set to dictionary        ${data}         availableTo=2020-02-01
    ${response}    Send Post Request      ${base_url}   ${activate_listing}  ${data}        expected_status=400

Test Activate listings by invalid date
    [Tags]   activate_listing_by_invalid_date
    [Documentation]     activate a listing, set invalid datetime
    ${data}=    get_activate_listing_data
    ${data}         set to dictionary        ${data}         availableFrom=2020-03-01
    ${data}         set to dictionary        ${data}         availableTo=2020-03-32
    ${response}    Send Post Request      ${base_url}   ${activate_listing}  ${data}        expected_status=400

Test Activate 100 listings
    [Tags]   activate_100_listing
    [Documentation]     test if active amount limit is good work
    ${data}=    get_query_sixty_listing_data
    ${data}=    set to dictionary       ${data}       pageSize=100
    ${data}=    set to dictionary       ${data}       status=ACTIVE
    ${response1}    Send Get Request      ${base_url}   ${query_listing}  ${data}
    ${data}=    set to dictionary       ${data}       status=INACTIVE
    ${response2}    Send Get Request      ${base_url}   ${query_listing}  ${data}
    ${content}=    get_hundred_activate_listing_data          ${response2.json()}      ${response1.json()}
    ${data}=    get from list  ${content}   0
    ${expected_status}      get from list   ${content}      1
    ${response3}    Send Post Request      ${base_url}   ${activate_listing}  ${data}    expected_status=${expected_status}
    ${sku_list}     get from dictionary    ${data}      primarySkuNumbers
    ${deactivate_data}    create dictionary    primarySkuNumbers=${sku_list}
    ${response4}    Send Post Request      ${base_url}   ${deactivate_listing}  ${deactivate_data}   expected_status=${expected_status}
    remove from list    ${sku_list}     0
    ${response5}    Send Post Request      ${base_url}   ${activate_listing}  ${data}   expected_status=any
    ${deactivate_data}    create dictionary    primarySkuNumbers=${sku_list}
    ${response6}    Send Post Request      ${base_url}   ${deactivate_listing}  ${deactivate_data}   expected_status=any
    run keyword if  '${expected_status}'=='200'    should be equal as strings      ${response4.json()}         ${response6.json()}
    ...     ELSE        should not be equal as strings      ${response4.json()}         ${response6.json()}

Test Deactivate listings
    [Tags]   deactivate_listing     smoke
    [Documentation]     deactive listing, change listing status from active to inactive
    ${data}=    get_deactivate_listing_data
    ${response}    Send Post Request      ${base_url}   ${deactivate_listing}  ${data}


Test Download template file
    [Tags]   download_template     smoke        read
    [Documentation]     random choose 2 catogeries and download the template
    ${data}=    get_download_template_data
    ${response}    Send Get Request      ${base_url}   ${download_template}    ${data}
    write_template      ${response.content}
    should be equal as integers     ${response.status_code}     200


Test Download template file by error taxonomyPath
    [Tags]   download_template_by_error_taxonomyPath        read
    [Documentation]     use invalid category to download template
    ${data}=    create dictionary       taxonomyPath=123
    ${response}    Send Get Request      ${base_url}   ${download_template}    ${data}      expected_status=400
    ${data}=    create dictionary
    ${response}    Send Get Request      ${base_url}   ${download_template}    ${data}      expected_status=400



Test Create listings by upload template file
    [Tags]   create_template_listing     smoke
    [Documentation]     use valid excel to create some listings
    ${response}    post_template    ${base_url}   ${create_template_listing}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${msg}=     get from list   ${response}         1
    should be equal as integers     ${status_code}     200          ${msg}


Test Export listings to excel template file
    [Tags]   export_template_listing     smoke      read
    [Documentation]     download listing data by a random parameter
    ${data}=    get_export_listing_data
    ${response}    Send Query Post Request     ${base_url}   ${export_template_listing}  ${data}
    write_expost_listing        ${response.content}
    should be equal as integers    ${response.status_code}    200


Test Asyn Create listings by upload template file
    [Tags]   asyn_create_template_listing     smoke
    [Documentation]     use valid excel to asyn create some listings
    ${response}    asyn_post_template    ${base_url}   ${asyn_create_template_listing}    ${api_key}
    ${status_code}=     get from list   ${response}         0
    ${task_id}=     get from list   ${response}         1
    ${data}=        create dictionary       taskId=${task_id}
    ${response}    Send Get Request      ${base_url}   ${get_upload_task}   ${data}


Test get upload task status
    [Tags]   get_upload_status      smoke
    [Documentation]     use valid taskid and task status to search task detail
    ${data}=        create dictionary
    ${response}    Send Get Request      ${base_url}   ${get_upload_task}   ${data}


Test Finacial API
    [Tags]   finacial_api  smoke
    [Documentation]     query seller trade data accroding to random parameter
    ${data}=        get_query_financy_data
    ${response}    Send Get Request      ${base_url}   ${query_financy}   ${data}

Test Update subsku status to inactive
    [Tags]   update_subsku_data_to_inactive     smoke
    [Documentation]     update sub sku status from active to inactive by subsku/sellersku
    ${data}=        get_inactive_subsku
    remove from list        ${data}     0
    ${length}      get length   ${data}
    run keyword if   ${length}>0    Send Post Request     ${base_url}   ${update_subsku_status}   ${data}

Test Update subsku status with invalid para
    [Tags]   update_subsku_status_with_invalid_data
    [Documentation]     test activate/deactive api parameter validation function
    ${data}=        get_inactive_subsku
    ${length}      get length   ${data}
    Send Post Request     ${base_url}   ${update_subsku_status}   ${data}       expected_status=400
    ${first_data}   get from list   ${data}     0
    set to dictionary      ${first_data}       skuNumber=000
    Send Post Request     ${base_url}   ${update_subsku_status}   ${data}       expected_status=400
    ${data}=        get_inactive_subsku
    ${first_data}   get from list   ${data}     0
    set to dictionary      ${first_data}       status=abc
    Send Post Request     ${base_url}   ${update_subsku_status}   ${data}       expected_status=400
    ${data}=        get_inactive_subsku
    ${first_data}   get from list   ${data}     0
    set to dictionary      ${first_data}       skuNumber=
    Send Post Request     ${base_url}   ${update_subsku_status}   ${data}       expected_status=400

Test Update subsku status to active
    [Tags]   update_subsku_data_to_active       smoke
    [Documentation]     update sub sku status from inactive to active by subsku/sellersku
    ${data}=        get_active_subsku
    ${length}      get length   ${data}
    Send Post Request      ${base_url}   ${update_subsku_status}   ${data}

Test Update mastersku status to inactive
    [Tags]   update_mastersku_data_to_inactive       smoke
    [Documentation]     update master sku status from active to inactive by mastersku/sellersku
    ${data}=        get_inactive_mastersku
    ${length}      get length   ${data}
    Send Post Request      ${base_url}   ${update_subsku_status}   ${data}

Test Update mastersku status to active
    [Tags]   update_mastersku_data_to_active       smoke
    [Documentation]     update master sku status from inactive to active by mastersku/sellersku
    ${data}=        get_active_masetrsku
    ${length}      get length   ${data}
    Send Post Request      ${base_url}   ${update_subsku_status}   ${data}



