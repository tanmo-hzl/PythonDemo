*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerOrderManagementKeywords.robot
Resource            ../../Keywords/MP/SellerMessageKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
...                             AND    API - Seller Sign In And Get Order Info
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Order Management - Overview
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    seller    ovr

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/overview
${BUYER_NAME}
${Action_Index}
@{Orders_Status}       Pending Confirmation    Ready to Ship    Partially Shipped
...                    Shipped    Partially Delivered    Delivered    Cancelled    Completed

*** Test Cases ***
Test Check Overview Page Fixed Element text
    [Documentation]   Check overview page fixed element text
    [Tags]  mp    mp-ea    ea-s-order    ea-s-order-ele
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerOrderManagement.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    overview

Test Seller Confirm Pending Confirmation Order - Do Many Times
    [Documentation]    Search Pengding Confirmation order, enter detail page then confirm order,do many times
    [Tags]   mp    mp-ea    ea-s-order    ea-s-order-confirm    mp-rsc
    [Template]    Flow - Seller Order - Search Pending Confirm Order And Confirm It
    1
    2
    3
    4

Test Seller Ship All Items For Ready To Ship Order
    [Documentation]    Search Ready To Ship order, enter detail page and shipped all items
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-ship    mp-rsc
    ${date_range}    Create List     -60    -7
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[1]}    ${date_range}
    Seller Order - Select All Item On Order Detail Page
    Seller Order - Ship Item On Order Detail Page
    Seller Order - Back To Order List On Order Detail Page

Test Seller Ship One Item For Ready To Ship Order - Do Many Times
    [Documentation]    Search Ready To Ship order, enter detail page then shipped,do many times
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-ship    mp-rsc
    [Template]    Flow - Seller Order - Ship One Item For Ready To Ship Order
    -7    0    1
    -7    0    2
    -7    0    3

Test Seller Select All Items To Ship Partial For Ready To Ship Order
    [Documentation]    Search Ready To Ship order, enter detail page and shipped partial items
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-ship    mp-rsc
    ${date_range}    Create List     -7    0
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[1]}    ${date_range}
    Seller Order - Select All Item On Order Detail Page
    Seller Order - Click Button Ship Item
    Seller Order - Reduce Shipped Items Quantity    1
    Seller Order - Select Carrier And Input Tracking Number
    Page Should Contain    ${Orders_Status[2]}
    Seller Order - Select One Item On Order Detail Page
    Seller Order - Click Button Ship Item
    Seller Order - Select Carrier And Input Tracking Number
    Page Should Contain    ${Orders_Status[3]}
    Seller Order - Back To Order List On Order Detail Page

Test Seller Select One item To Ship Partial For Ready To Ship Order
    [Documentation]    Search Ready To Ship order, enter detail page then shipped partial items
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-ship
    ${date_range}    Create List     -7    0
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[1]}    ${date_range}
    Seller Order - Select One Item On Order Detail Page
    Seller Order - Click Button Ship Item
    Seller Order - Reduce Shipped Items Quantity    1
    Seller Order - Select Carrier And Input Tracking Number
    Page Should Contain    ${Orders_Status[2]}
    Seller Order - Select One Item On Order Detail Page
    Seller Order - Click Button Ship Item
    Seller Order - Select Carrier And Input Tracking Number    ${False}
    Seller Order - Back To Order List On Order Detail Page

Test Seller Select All item To Shipped For Partially Shipped Order
    [Documentation]    Search Partially Shipped order, enter detail page then shipped partial items
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-ship
    ${date_range}    Create List     -7    0
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[2]}    ${date_range}
    Seller Order - Select All Item On Order Detail Page
    Seller Order - Click Button Ship Item
    Seller Order - Select Carrier And Input Tracking Number
    Seller Order - Back To Order List On Order Detail Page

Test Seller Ship One Items For Partially Shipped Order
    [Documentation]    Search Partially Shipped order, then enter detail page by line 1 and select one item shipped
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-ship
    ${date_range}    Create List     -7    0
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[2]}    ${date_range}
    Seller Order - Ship One Item For Partially Shipped Order
    Seller Order - Back To Order List On Order Detail Page

Test Seller Cancel All Items - Pending Confirmation
    [Documentation]    Search Pending or readly to ship order, then cancel it
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-cancel
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[0]}
    Seller Order - Select All Item On Order Detail Page
    Seller Order - Cancel Order On Order Detail Page
    Seller Order - Check Result After Cancel Order    ${True}    ${Orders_Status[0]}
    Seller Order - Back To Order List On Order Detail Page

Test Seller Cancel One Items - Ready To Ship
    [Documentation]    Search Pending or readly to ship order, then cancel it
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-cancel
    ${date_range}    Create List     -60    -3
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[1]}    ${date_range}
    ${is_all_handled}    Seller Order - Select One Item On Order Detail Page
    Seller Order - Cancel Order On Order Detail Page
    Seller Order - Check Result After Cancel Order    ${is_all_handled}    ${Orders_Status[1]}
    Seller Order - Back To Order List On Order Detail Page

Test Seller Cancel One Items - Partially Shipped
    [Documentation]    Search Pending or readly to ship order, then cancel it
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-cancel
    ${date_range}    Create List     -60    -2
    Seller Order - Go To Order Detail Page By Status    ${Orders_Status[2]}    ${date_range}
    ${is_all_handled}    Seller Order - Select One Item On Order Detail Page
    Seller Order - Cancel One Item For Partially Shipped Order
    Seller Order - Check Result After Cancel Order    ${is_all_handled}    ${Orders_Status[2]}
    Seller Order - Back To Order List On Order Detail Page

Test Seller Filter Order By Status And Check Result
    [Documentation]    Seller Filter Order by Status and check total order quantity
    [Tags]   mp    mp-ea    ea-s-order     ea-s-order-filter
    [Template]    Seller Order - Filter - Check Filter Results By Selected Status Quantity
    1
    2
    3
    4
    5
    6
    7

Test Seller Filter Order By Purchased Within And Check Result
    [Documentation]    Seller Filter Order by Purchased within and check total order quantity
    [Tags]   mp    mp-ea    ea-s-order   ea-s-order-filter
    [Template]    Seller Order - Filter - Search Order By Purchased Within And Check Result
    All Time
    Today
    Yesterday
    Past 7 Days
    Past 30 Days
    Past 6 Months
    Past Year

Test Seller Export Order By Status Then Check Order Info
    [Documentation]    Seller Download Export Order By Status Then Check Order Info
    [Tags]    mp    mp-ea    ea-s-order-download
    [Template]    Seller Order - Export Order By Status And Check Results
    1
    1
    2
    2
    3
    5
    8

Test Seller Export All Order Then Check Order Info
    [Documentation]    Seller Download Export Order By Status Then Check Order Info
    [Tags]    mp    mp-ea    ea-s-order-download
    Seller Order - Filter - Clear All Filter
    Seller Order - Get Results Total Number
    Seller Order - Export All Order
    Seller Order - Export File Manually And Check    All Orders

Test Seller Actions - See Order Detail
    [Documentation]    Seller see order detail by actions option
    [Tags]    mp    mp-ea    ea-s-order-actions
    ${count}    Get Element Count    //table//tbody/tr
    ${Action_Index}    Evaluate    random.randint(1,${count})
    Set Suite Variable    ${Action_Index}    ${Action_Index}
    Seller Order - Get Order Information By Line Index    ${Action_Index}
    Seller Order - Actions - See Order Details By Index    ${Action_Index}
    Seller Order - Get Order Items Info
    Seller Order - Back To Order List On Order Detail Page

Test Seller Actions - Export Order And Check Results
    [Documentation]    Seller export single order then check order info
    [Tags]    mp    mp-ea    ea-s-order-actions
    Seller Order - Actions - Export Order Info By Index     ${Action_Index}
    Seller Order - Actions - Check Export Order Info By Index      ${Action_Index}

Test Seller Actions - See Invoice
    [Documentation]    Seller see order detail by actions option
    [Tags]    mp    mp-ea    ea-s-order-actions
    Seller Order - Actions - See Invoice By Index     ${Action_Index}
    Seller Order - Actions - Check Export Info If Export Success On Invoice Windows
    Seller Order - Actions - Check Order Items Info On Invoice Windows
    Seller Order - Actions - Close Invoice Windows

Test Search Order By Values And Check Results
    [Documentation]    Seller seach order by value and check results
    [Tags]    mp    mp-ea    ea-s-order-search
    [Template]    Seller Order - Search Order And Check Results
    ${Cur_Order_Information}[orderNumber]           ${True}     Search by order number
    ${Cur_Order_Information}[customerName]          ${True}     Search by full customer name
    ${Cur_Order_Information}[parentNumber]          ${True}     Search by parent order number
    ${Cur_Order_Information}[firstName]             ${True}     Search by first name
    ${Order_Item_One}[name]                         ${False}    Search by item name
    ${Order_Item_One}[sku]                          ${False}    Search by item sku

Test Seller Search Order By Null Result
    [Documentation]    Search order by random code and get null result
    [Tags]   mp    mp-ea    ea-s-order    ea-s-order-search
    ${ran_code}    Get Uuid Split
    Seller Order - Search Order By Search Value     ${ran_code}
    Seller Order - Get Results Total Number
    Should Be Equal As Strings    ${Cur_Order_Total}    0
    Seller Order - Clear Search Value

Test Check Order Detail Page Fixed Element
    [Documentation]    Check fixed element on order detail page
    [Tags]    mp    mp-ea   ea-s-order   ea-s-order-ele
    Seller Order - Filter - Clear All Filter
    ${count}    Get Element Count    //table//tbody/tr
    ${Action_Index}    Evaluate    random.randint(1,${count})
    Seller Order - Get Order Information By Line Index    ${Action_Index}
    Seller Order - Enter To Order Detail Page By Line Index    ${Action_Index}
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerOrderDetail.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    ${Cur_Order_Information}[status]
    Seller Order - Back To Order List On Order Detail Page

Test Contact Buyer On Order Detail Page
    [Documentation]    Contact buyer on order detail page
    [Tags]    mp    mp-ea   ea-s-order   ea-s-order-msg
    Seller Order - Get Order Information By Line Index
    Seller Message - Contact Buyer - Click Button Contact Buyer
    Seller Message - Contact Buyer - Input Send Message    ${False}
    Seller Message - Contact Buyer - Click Button Send
    Seller Message - Contact Buyer - Input Send Message
    Seller Message - Contact Buyer - Add Attach File
    Seller Message - Contact Buyer - Click Button Send



