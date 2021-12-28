*** Settings ***
#Resource            ../../Keywords/MP/UserKeywords.robot
Resource            ../../Keywords/MP/OrderFlowKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - Order
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Store Listing List
    [Tags]   mp   order    order-create
    Get Store Listing List - GET

Test Get Product Detail By Sku
    [Tags]   mp   order    order-create
    Get Product Detail By Sku - POST

Test Get Buyer Shipping Cart Id
    [Tags]   mp   order    order-create
    Get Buyer Shipping Cart Id - GET

Test Add Item To Buer Shipping Cart
    [Tags]   mp   order    order-create
    Add Items To Buyer Shipping Cart - POST

Test Get Buyer Shipping Cart Items List
    [Tags]   mp   order    order-create
    Get Buyer Shipping Cart Items List - GET

Test Remove Item From Shipping Cart
    [Tags]   mp   order    order-create
    Remove Item From Shipping Cart - DELETE

Test Shipping Checkout Summary
    [Tags]   mp   order    order-create
    Add Items To Buyer Shipping Cart - POST
    Get Buyer Shipping Cart Items List - GET
    Shipping Checkout Summary - POST

Test Shipping Cart Listing Checkout Initiate
    [Tags]   mp   order    order-create
    Listing Checkout Initiate - POST

Test Get Buyer Wallet Bankcard
    [Tags]   mp   order    order-create
    Get Wallet Bankcard - GET

Test Checkout Submit Order
    [Tags]   mp   order    order-create
    Checkout Submit Order - POST

Test Create Order Then Cancel Order By Buyer When Open
    [Tags]   mp   order    order-cancel
    Flow From Search Listing To Submit Order
    Get Buyer Order Detail - GET
    Buyer Cancel Order - POST

Test Create Order Then Cancel Order By Seller When Open
    [Tags]   mp   order    order-cancel
    Flow From Search Listing To Submit Order
    Get Seller Order Detail - GET
    Seller Cancel Order - POST

Test Cancel Order By Buyer When Pending Confirmation
    [Tags]   mp   order    order-cancel
    Flow From Search Listing To Submit Order
    ${statuses}    Create List    1000
    Get Seller Order Listing By Keywords - POST    ${statuses}
    Get Seller Order Detail - GET
    Buyer Cancel Order - POST

Test Cancel Order By Seller When Pending Confirmation
    [Tags]   mp   order    order-cancel
    Flow From Search Listing To Submit Order
    ${statuses}    Create List    1000
    Get Buyer Order By Seller Order Listing Page - GET    ${statuses}
    Get Seller Order Detail - GET
    Seller Cancel Order - POST

Test Get Seller Order Then Confirm
    [Tags]   mp   order    order-confirm
    ${statuses}    Create List    3000
    Get Buyer Order By Seller Order Listing Page - GET    ${statuses}
    Get Seller Order Detail - GET
    Seller Confirm Order - POST

Test Check Confirm Order Status
    [Tags]   mp   order    order-confirm
    Check Seller Order Status - GET    3500

Test Get Seller Order Then Ship Items
    [Tags]   mp   order    order-shipment
    ${statuses}    Create List    3500
    Get Buyer Order By Seller Order Listing Page - GET    ${statuses}
    Get Seller Order Detail - GET
    Seller Shipment Items - POST

Test Check Shipped Order Status
    [Tags]   mp   order    order-shipment
    Check Seller Order Status - GET    7000

Test Get Buyer Order Then Return It
    [Tags]    mp   order    order-return
    ${statuses}    Create List    7000
    Get Buyer Order Which No After Sales Order By Order Numbers - GET    ${statuses}
    Get Seller Order Detail - GET
    Buyer Return Order - POST

Test Get Seller After Sales Order List
    [Tags]    mp   order    order-return
    ${statuses}    Create List
    Get Seller After Sales Order List - GET    ${statuses}

Test Get Seller After Sales Order Detail
    [Tags]    mp   order    order-return
    Get Seller After Sales Order Detial - GET

Test Seller Approval After Sales Order
    [Tags]    mp   order    order-return
    ${statuses}    Create List    10500    11000
    Get Seller After Sales Order List - GET    ${statuses}
    Get Seller After Sales Order Detial - GET
    Seller Approval After Sales Order - POST

Test Check Approved After Sales Order Status
    [Tags]    mp   order    order-return
    Check After Sales Order Status - GET    18000

Test Seller Reject After Sales Order
    [Tags]    mp   order    order-return
    ${statuses}    Create List    10500    11000
    Get Seller After Sales Order List - GET    ${statuses}
    Get Seller After Sales Order Detial - GET
    Seller Reject After Sales Order - POST

Test Check Rejected After Sales Order Status
    [Tags]    mp   order    order-return
    Check After Sales Order Status - GET    19100
