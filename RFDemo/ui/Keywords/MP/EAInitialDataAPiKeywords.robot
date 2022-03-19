*** Settings ***
Library           ../../Libraries/MP/EARequestBodyLib.py
Resource          ../../Keywords/Common/CommonApiKeywords.robot
Resource          ../../Keywords/Common/CommonKeywords.robot


*** Variables ***
${Headers_Get}
${Headers_Post}
${Seller_Store_Id}
${item}
${Path_Order_List}     /moh/search/order/seller/list/page

*** Keywords ***
API - Seller Sign In And Get Order Info
    Initial Env Data
    ${data}    Mik - User Sign In By Secure - POST     ${SELLER_EMAIL}    ${SELLER_PWD}
    Mik - Set Seller Suite Variables    ${data}

API - Get And Save Seller Order Number By Status
    [Arguments]    ${status}=Shipped    ${file_name}=orders_shipped
    ${body}     Get Seller Order List Body     1     ${status}
    ${res}    Send Get Request    ${API_HOST_MIK}    ${Path_Order_List}    ${body}    ${Headers_Get}
    ${content}    Get Json Value    ${res.json()}     data    content
    ${order_list}    Create List
    FOR     ${item}    IN    @{content}
        IF  "${item}[customerEmail]"=="${BUYER_EMAIL}"
            Append To List    ${order_list}    ${item}[orderNumber]
        END
    END
    Save File    ${file_name}    ${order_list}    MP    ${ENV}

API - Get Seller Order Info By Status And Customer Email
    [Arguments]    ${status}    ${date_range}=${None}
    ${body}     Get Seller Order List Body     1     ${status}    ${date_range}
    ${res}    Send Get Request    ${API_HOST_MIK}    ${Path_Order_List}    ${body}    ${Headers_Get}
    ${content}    Get Json Value    ${res.json()}     data    content
    ${order_list}    Create List
    FOR    ${item}    IN    @{content}
        IF  "${item}[customerEmail]"=="${BUYER_EMAIL}"
            Append To List    ${order_list}    ${item}
        END
    END
    ${order_length}    Get Length    ${order_list}
    IF    ${order_length}>0
        ${order_info}    Evaluate    random.choice(${order_list})
    ELSE
        Skip    There are no order ${status} and belong ${BUYER_EMAIL}.
    END
    [Return]    ${order_info}

API - Get And Save Seller Return Order Info By Status
    [Arguments]    ${status}=${None}    ${file_name}=orders_seller_returns
    ${body}     Get Seller Order List Body     2     ${status}
    ${res}    Send Get Request    ${API_HOST_MIK}    ${Path_Order_List}    ${body}    ${Headers_Get}
    ${content}    Get Json Value    ${res.json()}     data    content
    ${order_list}    Create List
    FOR     ${item}    IN    @{content}
        IF  "${item}[customerEmail]"=="${BUYER_EMAIL}"
            ${order_info}    Create Dictionary    returnId=${item}[returnOrderNumber]   orderNumber=${item}[orderNumber]
            ...    status=${item}[status]    parentOrderNumber=${item}[parentOrderNumber]
            Append To List    ${order_list}    ${order_info}
        END
    END
    Save File    ${file_name}    ${order_list}    MP    ${ENV}

API - Get And Save Seller Dispute Order Info By Status
    [Arguments]    ${status}=${None}    ${file_name}=orders_seller_disputes
    ${body}     Get Seller Order List Body     3     ${status}
    ${res}    Send Get Request    ${API_HOST_MIK}    ${Path_Order_List}    ${body}    ${Headers_Get}
    ${content}    Get Json Value    ${res.json()}     data    content
    ${order_list}    Create List
    FOR     ${item}    IN    @{content}
        IF  "${item}[customerEmail]"=="${BUYER_EMAIL}"
            ${order_info}    Create Dictionary    disputeId=${item}[id]    orderNumber=${item}[orderNumber]
            ...    parentOrderNumber=${item}[parentOrderNumber]    returnOrderNumber=${item}[returnOrderNumber]
            ...    status=${item}[status]
            Append To List    ${order_list}    ${order_info}
        END
    END
    Save File    ${file_name}    ${order_list}    MP    ${ENV}

API - Get Listing Info By Status And Variants
    [Arguments]    ${status}    ${have_variants}=${False}
    ${res}    Send Get Request    ${API_HOST_MIK}    /mda/store/${Seller_Store_Id}/listings    ${Null}    ${Headers_Get}
    ${filter_listing_info}    Get Listing Info By Status And Variants    ${res.json()}[listings]    ${status}    ${have_variants}
    [Return]     ${filter_listing_info}

API - Get Listing Url By Quantity Status And Variants
    [Arguments]    ${quantity}=1    ${status}=Active    ${have_variants}=${None}
    ${res}    Send Get Request    ${API_HOST_MIK}    /mda/store/${Seller_Store_Id}/listings    ${Null}    ${Headers_Get}
    ${listing_urls}    Get Listing Url By Quantity Status And Variants     ${res.json()}[listings]    ${quantity}    ${status}    ${have_variants}
    [Return]     ${listing_urls}

API - Get Listing Detail By Sku Number
    [Arguments]    ${sku_number}
    ${res}    Send Get Request    ${API_HOST_MIK}    /mda/store/${Seller_Store_Id}/listingInfo/${sku_number}    ${Null}    ${Headers_Get}
    ${listing_detail}    Get Json Value    ${res.json()}    data
    [Return]    ${listing_detail}
