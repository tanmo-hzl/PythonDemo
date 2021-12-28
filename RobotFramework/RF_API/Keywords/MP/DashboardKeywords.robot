*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/MP/DashboardLib.py
#Resource            ../../TestData/MP/PathOrderFlow.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller_headers}
${seller_headers_post}
${seller_info_sign}
${seller_store_id}
${business_actions_data}
${store_activities_sell_data}
${res_order_status_num}
${order_list_sell_data}
${store_data}


*** Keywords ***
Set Initial Data - Dashboard
    Mik Seller Sign In Scuse Of Order - POST    ${seller-account}
    ${seller_headers}           Set Get Headers - Seller
    Set Suite Variable          ${seller_headers}               ${seller_headers}
    ${seller_headers_post}      Set Post Headers - Seller
    Set Suite Variable          ${seller_headers_post}          ${seller_headers_post}
    ${seller_info_sign}         Set Variable                    ${null}
    ${seller_info_sign}         Run Keyword If      '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
    Set Suite Variable          ${seller_info_sign}             ${seller_info_sign}
    ${seller_store_id}          Get Json Value                  ${seller_info_sign}    sellerStoreProfile    sellerStoreId
    Set Suite Variable          ${seller_store_id}              ${seller_store_id}

Get Dashboard Business Actions Data - GET
    ${res}    Send Get Request      ${url-mik}       /dashboard/business-actions        ${null}    ${seller_headers}
    ${business_actions_data}        Get Json Value              ${res.json()}           data
    Set Suite Variable              ${business_actions_data}    ${business_actions_data}

Get Order List Data - GET
    ${url}       Set Variable           ${url-mik}/moh/order/v5/seller/orderList/page
    ${params}    Create Dictionary      currentPage=0    pageSize=400    simpleMode=true    channel=2
    ${res_order_status_num}             Get Order List Num      ${url}        ${seller_headers}    ${params}
    Set Suite Variable        ${res_order_status_num}           ${res_order_status_num}


Check Orders Pending Confirmation Data
    ${order_pending}                Get Json Value              ${business_actions_data}     orderPending
    ${order_pending_num}            Get Json Value              ${res_order_status_num}     orderPending
    Should Be Equal As Integers     ${order_pending_num}        ${order_pending}


Check Orders Awaiting Shipment Data
    ${shipments}                    Get Json Value          ${business_actions_data}     shipments
    ${shipments_num}                Get Json Value          ${res_order_status_num}     shipments
    Should Be Equal As Integers     ${shipments_num}        ${shipments}

Check Returns Awaiting Action Data
    ${returns}         Get Json Value         ${business_actions_data}      returns
    ${returns_num}     Get Json Value         ${res_order_status_num}       returns
    Should Be Equal As Integers               ${returns_num}                ${returns}

Check Disputes Awaiting Action Data
    ${disputes}         Get Json Value      ${business_actions_data}        disputes
    ${disputes_num}     Get Json Value      ${res_order_status_num}         disputes
    Should Be Equal As Integers             ${disputes_num}                 ${disputes}



Get Dashboard Store Activities Date By Date Flag- GET
    [Arguments]    ${dateFlag}
    ${data}     Create Dictionary       timeOption=${dateFlag}
    ${res}      Send Get Request        ${url-mik}    /dashboard/store-activities    ${data}    ${seller_headers}
    ${store_activities_sell_data}       Get Json Value    ${res.json()}    data
    Set Suite Variable                  ${store_activities_sell_data}    ${store_activities_sell_data}
    log      ${store_activities_sell_data}


Get Store Activities All Sell Data - GET
    ${params}    Create Dictionary      currentPage=0    pageSize=400    simpleMode=true    channel=2
    ${order_list_sell_data}             Get Order List Sell             ${url-mik}      ${seller_headers}    ${params}
    Set Suite Variable                  ${order_list_sell_data}         ${order_list_sell_data}
    log     ${order_list_sell_data}

Check Store Activities Sell Data
    [Arguments]    ${dateFlag}
    ${orders}           Get Json Value      ${store_activities_sell_data}     orders
    ${soldUnits}        Get Json Value      ${store_activities_sell_data}     soldUnits
    ${sales}            Get Json Value      ${store_activities_sell_data}     sales

    ${key_str}              Get Str By Flag     ${dateFlag}
    ${order_orders}         Get Json Value      ${order_list_sell_data}     ${key_str}      orders
    ${order_soldUnits}      Get Json Value      ${order_list_sell_data}     ${key_str}      soldUnits
    ${order_sales}          Get Json Value      ${order_list_sell_data}     ${key_str}      sales

    Should Be Equal As Numbers      ${orders}           ${order_orders}
    Should Be Equal As Numbers      ${soldUnits}        ${order_soldUnits}
    Should Be Equal As Numbers      ${sales}            ${order_sales}




Get Store Listings Status Data By StoreID - GET
    ${url}                  Set Variable                    ${url-mik}/store/${seller_store_id}/listings
    ${store_data}           Get Listings Status By ID       ${url}      ${seller_headers}
    Set Suite Variable      ${store_data}                   ${store_data}




Check Store Listings Status Data

    ${active_listings}              Get Json Value      ${store_activities_sell_data}       activeListings
    ${inactive_listings}            Get Json Value      ${store_activities_sell_data}       inactiveListings
    ${low_inventory_items}          Get Json Value      ${store_activities_sell_data}       lowInventoryItems

    ${active}                       Get Json Value      ${store_data}           active
    ${inactive}                     Get Json Value      ${store_data}           inactive
    ${lowInventory}                 Get Json Value      ${store_data}           lowInventory

    Should Be Equal As Integers     ${active_listings}          ${active}
    Should Be Equal As Integers     ${inactive_listings}        ${inactive}
    Should Be Equal As Integers     ${low_inventory_items}      ${lowInventory}

Check Store Available Balance Data
    ${url}                          Set Variable                    ${url-mik}/store/${seller_store_id}/finance/balance
    ${finance_balance}              GET Finance Balance Data        ${url}                               ${seller_headers}
    ${activities_balance}           Get Json Value                  ${store_activities_sell_data}        balance
    Should Be Equal As Numbers      ${finance_balance}              ${activities_balance}











