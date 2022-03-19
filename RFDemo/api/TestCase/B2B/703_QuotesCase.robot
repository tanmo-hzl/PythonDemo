*** Settings ***
Resource            ../../Keywords/B2B/QuotesKeywords.robot
Resource            ../../Keywords/B2B/CheckoutKeywords.robot
Resource            ../../Keywords/B2B/ProductKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Quotes
Suite Teardown       Delete All Sessions


*** Variables ***
${Quote_ID}

*** Test Cases ***
Test Get Quotes List
    [Tags]    b2b    b2b-quotes
    Get Quotes List By Michaels - GET

Test Create Quotes For Organization
    [Tags]    b2b    b2b-quotes    b2b-quotes-create
    Create Quotes With Items - POST

Test Create Approve Request
    [Tags]    b2b    b2b-quotes    b2b-quotes-create
    Create Approve Request - POST
    Check Quotes Status    PENDING_MICHAELS_ADMIN_APPROVAL

Test Get Quotes Items Detail By Michaels
    [Tags]    b2b    b2b-quotes
    Get Quotes Items Details By Michaels - GET

Test Update Quotes
    [Tags]    b2b    b2b-quotes
    Update Quotes with items - PATCH

Test Approve Quotes
    [Tags]    b2b    b2b-quotes
    Approve Quotes - PATCH
    Check Quotes Status    PRICED

Test Get Quotes Details By User
    [Tags]    b2b    b2b-quotes
    Get Quotes Items Details By User - GET

Test Checkout Quotes Order
    [Tags]    b2b    b2b-quotes
    ${Shipping_Cart_Items}    Get Quotes Shipping Cart Items    ${User_Quotes_Detail}
    Get CK Shipping Address - GET
    Get Product Sku Info By Sku Number - GET
    Get Checkout Quotes Order Tax Quotation Info - POST       ${Shipping_Cart_Items}
    Get CK Payment Detail - GET
    Create Quotes Order - Post   ${Shipping_Cart_Items}
    Check Quotes Status    COMPLETED

Test Quotes Rejected By Michaels
    [Tags]    b2b    b2b-quotes    b2b-quotes-reject
    Create Quotes With Items - POST
    Create Approve Request - POST
    Quotes Items Reject By Michaels
    Quotes Order Reject By Michaels
    Check Quotes Status    MICHAELS_ADMIN_REJECTED

Test Quotes Cancel By User
    [Tags]    b2b    b2b-quotes    b2b-quotes-cancel
    Create Quotes With Items - POST
    Create Approve Request - POST
    Quotes Order Cancel By User
    Check Quotes Status    ${None}


