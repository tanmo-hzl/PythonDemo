*** Settings ***
Library           ../../Libraries/MP/EARequestBodyLib.py
Library           ../../Libraries/MP/SellerReturnLib.py
Resource          ../../Keywords/Common/CommonApiKeywords.robot
Resource          ../../Keywords/Common/CommonKeywords.robot


*** Variables ***
${Headers_Get_Seller}
${Headers_Post_Seller}
${Seller_Store_Id}
${item}

*** Keywords ***
API - Seller Sign In
    [Arguments]    ${email}=${None}    ${pwd}=${None}
    IF    "${email}"=="${None}"
        ${data}    Mik - User Sign In By Secure - POST     ${SELLER_EMAIL}    ${SELLER_PWD}
    ELSE
        ${data}    Mik - User Sign In By Secure - POST     ${email}     ${pwd}
    END
    Mik - Set Seller Suite Variables    ${data}

API - Get EA Taxomomy Info
    ${path}    Set Variable    /mda/ea/taxonomy
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${null}    ${Headers_Get_Seller}
    [Return]    ${res.json()}

API - Check Listing Category is Normal
    [Arguments]    ${category}
    ${body}    Create Dictionary    taxonomyPath=${category}
    ${path}    Set Variable    /mda/ea/taxonomy/get-taxonomy-attributes
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Seller}    anything
    ${status}    Set Variable    ${res.status_code}
    [Return]    ${status}

Api - Download Excel Template - POST
    [Arguments]    ${category_list}
    ${path}    Set Variable    /mda/listings/management/download-excel-template
    ${res}  Send Post Request   ${API_HOST_MIK}    ${path}    ${category_list}   ${Headers_Post_Seller}
    [Return]    ${res}

API - Seller Order - Get Order list - GET
    [Arguments]    ${body}
    ${path}    Set Variable    /moh/search/order/seller/list/page
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Seller}
    ${content}    Get Json Value    ${res.json()}     data    content
    [Return]    ${content}

API - Seller Order - Get Rsc Order list - GET
    [Arguments]    ${body}
    ${path}    Set Variable    /moh-rsc/afterSales/search/return/seller/list/page
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Seller}
    ${content}    Get Json Value    ${res.json()}     data    content
    [Return]    ${content}

API - Get And Save Seller Order Number By Status
    [Arguments]    ${status}=Shipped    ${file_name}=orders_shipped
    ${body}     Get Seller Order List Body     1     status=${status}
    ${content}    API - Seller Order - Get Order List - GET    ${body}
    ${order_list}    Create List
    Set Log Level    WARN
    FOR     ${item}    IN    @{content}
        IF  "${item}[customerEmail]"=="${BUYER_EMAIL}"
            Append To List    ${order_list}    ${item}[orderNumber]
        END
    END
    Set Log Level    INFO
    Save File    ${file_name}    ${order_list}    MP    ${ENV}

API - Get Seller Order Info By Status And Customer Email
    [Arguments]    ${status}    ${date_range}=${None}    ${quantity}=1
    &{kwargs}    Create Dictionary    status=${status}    dateRange=${date_range}
    ${body}     Get Seller Order List Body     1     &{kwargs}
    ${content}    API - Seller Order - Get Order List - GET    ${body}
    ${order_list}    Create List
    Set Log Level    WARN
    FOR    ${item}    IN    @{content}
        IF  "${item}[customerEmail]"=="${BUYER_EMAIL}"
            Append To List    ${order_list}    ${item}
        END
    END
    Set Log Level    INFO
    ${order_length}    Get Length    ${order_list}
    IF    ${order_length}>0
        IF    "${quantity}"=="1"
            ${orders_info}    Evaluate    random.choice(${order_list})
        ELSE
            IF    ${quantity}>${order_length}
                ${orders_info}    Evaluate    random.sample(${order_list},${order_length})
            ELSE
                ${orders_info}    Evaluate    random.sample(${order_list},${quantity})
            END
        END
    ELSE
        Skip    There are no order ${status} and belong ${BUYER_EMAIL}.
    END
    [Return]    ${orders_info}

API - Get Seller Return Order List By Kwargs
    [Arguments]    &{kwargs}
    ${body}     Get Seller Order List Body     2     &{kwargs}
    ${content}    API - Seller Order - Get Rsc Order List - GET    ${body}
    [Return]    ${content}

API - Get Seller Dispute Order List By Kwargs
    [Arguments]    &{kwargs}
    ${body}     Get Seller Order List Body     3     &{kwargs}
    ${content}    API - Seller Order - Get Rsc Order List - GET    ${body}
    [Return]    ${content}

API - Get Listing Info By Status And Variants
    [Arguments]    ${status}    ${have_variants}=${False}    ${location}=4
    ${res}    Send Get Request    ${API_HOST_MIK}    /mda/store/${Seller_Store_Id}/listings    ${Null}    ${Headers_Get_Seller}
    ${filter_listing_info}    Get Listing Info By Status And Variants    ${res.json()}[listings]    ${status}    ${have_variants}    ${location}
    [Return]     ${filter_listing_info}

API - Get Listing Url By Quantity Status And Variants
    [Arguments]    ${quantity}=1    ${status}=Active    ${have_variants}=${None}
    ${res}    Send Get Request    ${API_HOST_MIK}    /mda/store/${Seller_Store_Id}/listings    ${Null}    ${Headers_Get_Seller}
    ${listing_urls}    Get Listing Url By Quantity Status And Variants     ${res.json()}[listings]    ${quantity}    ${status}    ${have_variants}
    [Return]     ${listing_urls}

API - Get Listing Detail By Sku Number
    [Arguments]    ${sku_number}
    ${res}    Send Get Request    ${API_HOST_MIK}    /mda/store/${Seller_Store_Id}/listingInfo/${sku_number}    ${Null}    ${Headers_Get_Seller}
    ${listing_detail}    Get Json Value    ${res.json()}    data
    [Return]    ${listing_detail}

API - Seller Get Order Detail By Order Number
    [Arguments]    ${order_number}
    ${body}    Create Dictionary    orderNumber=${order_number}    simpleMode=${False}
    ${path}    Set Variable    /moh/order/v5/seller/single
    ${res}    Send Get Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Get_Seller}
    [Return]    ${res.json()}[data]

API - Seller Confirm Order By Order Numbers
    [Arguments]    ${order_info}
    ${order_numbers}    Create List
    FOR    ${item}    IN    @{order_info}
        Append To List    ${order_numbers}    ${item}[orderNumber]
    END
    ${body}    Create Dictionary    orderNumbers=${order_numbers}
    ${path}    Set Variable    /moh/order/v5/seller/ReadyToShip/ByOrderNumber
    ${res}    Send Post Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Post_Seller}

API - Flow - Ship Item
    [Arguments]    ${status}    ${all_item_ship}=${True}    ${all_quantity_ship}=${True}
    ${order}    API - Get Seller Order Info By Status And Customer Email    ${status}
    API - Seller Ship Item By Order Number    ${order}[orderNumber]    ${all_item_ship}    ${all_quantity_ship}

API - Seller Ship Item By Order Number
    [Arguments]    ${order_number}    ${all_item_ship}=${True}    ${all_quantity_ship}=${True}
    ${order_detail}    API - Seller Get Order Detail By Order Number    ${order_number}
    ${body}    Get Ship Item Body    ${order_detail}    ${all_item_ship}    ${all_quantity_ship}
    ${path}    Set Variable    /moh/order/v3/seller/shipments/add
    ${res}    Send Post Request    ${API_HOST_MIK}    ${path}    ${body}    ${Headers_Post_Seller}

API - Export All Listings - POST
    [Arguments]   ${export_list}
    ${path}    Set Variable    /mda/store/${Seller_Store_Id}/export-all-listings
    ${res}  Send Post Request   ${API_HOST_MIK}    ${path}    ${export_list}   ${Headers_Post_Seller}
    [Return]    ${res}

API - Get Return Order Detail By Return Id
    [Arguments]    ${return_id}
    ${path}    Set Variable    /moh/afterSales/return/seller/single/getByReturnOrderNumber/${return_id}
    ${res}  Send Get Request   ${API_HOST_MIK}    ${path}    ${null}   ${Headers_Get_Seller}
    [Return]    ${res.json()}[data]

API - Get Promotion List
    [Arguments]    ${page}=1    ${statusQ}=Active    ${size}=50
    ${body}    Create Dictionary    page=${page}    size=${size}    statusQ=Active
    ${path}    Set Variable    /mda/promotion/list
    ${res}  Send Post Request   ${API_HOST_MIK}    ${path}    ${body}   ${Headers_Post_Seller}
    ${content}    Get Json Value    ${res.json()}    data    content
    ${total_page}    Get Json Value    ${res.json()}    data    totalPages
    [Return]    ${total_page}    ${content}

API - Seller Submit Refund Decision
    [Arguments]    ${return_id}    ${decision}
    ${return_detail}    API - Get Return Order Detail By Return Id    ${return_id}
    ${body}    Get Submit Refund Decision Body    ${return_detail}    ${decision}
    ${path}    Set Variable    /moh/afterSales/return/seller/processRefund
    ${res}  Send Post Request   ${API_HOST_MIK}    ${path}    ${body}   ${Headers_Post_Seller}

