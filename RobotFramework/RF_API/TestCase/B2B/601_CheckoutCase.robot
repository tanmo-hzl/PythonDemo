*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/CheckoutKeywords.robot
Resource            ../../Keywords/B2B/ProductKeywords.robot
Resource            ../../Keywords/B2B/ShippingCartKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Checkout
Suite Teardown       Delete All Sessions

*** Variables ***
${B2B_Single_Sku_Items}
${B2B_Multi_Sku_Items}

*** Test Cases ***
Test Checkout Single Sku Items By Admin
    [Tags]    b2b    b2b-checkout    b2b-checkout-admin
    Get CK Shipping Address - GET
    Get CK Payment Detail - GET
    Get CK Budgets Info - GET
    Get CK Tax Exempt Info- GET
    Get Single Or Multi Item's Sku Number    0    1
    Get Product Sku Info By Sku Number - GET
    Get User Shipping Cart Info - GET
    Get Shipping Cart Items - GET
    Remove All Items From Shipping Cart - DELETE
    Add Items To Shipping Carts By SkuNumber- POST
    Get Shipping Cart Items - GET
    Get CK Tax Quotation Info - POST    ${Pro_Sku_Info}    ${Shipping_Cart_Items}    ${CK_Address_Info}
    Create Order - Post    ${Shipping_Cart_Items}
    [Teardown]    B2B User Sign Out - POST

Test Checkout Single Sku Items By Buyer
    [Tags]    b2b    b2b-checkout    b2b-checkout-buyer
    Permission Level Sign In By Role Email    ${ENT_EMAIL_BUYER}
    Get CK Shipping Address - GET
    Get CK Payment Detail - GET
    Get CK Budgets Info - GET
    Get CK Tax Exempt Info- GET
    Get Single Or Multi Item's Sku Number    0    1
    Get Product Sku Info By Sku Number - GET
    Get User Shipping Cart Info - GET
    Get Shipping Cart Items - GET
    Remove All Items From Shipping Cart - DELETE
    Add Items To Shipping Carts By SkuNumber- POST
    Get Shipping Cart Items - GET
    Get CK Tax Quotation Info - POST    ${Pro_Sku_Info}    ${Shipping_Cart_Items}    ${CK_Address_Info}
    Create Order - Post    ${Shipping_Cart_Items}
    [Teardown]    B2B User Sign Out - POST

Test Checkout Single Sku Items By User
    [Tags]    b2b    b2b-checkout   b2b-checkout-user
    Permission Level Sign In By Role Email    ${ENT_EMAIL_USER}
    Get CK Shipping Address - GET
    Get CK Payment Detail - GET
    Get CK Budgets Info - GET
    Get CK Tax Exempt Info- GET
    Get Single Or Multi Item's Sku Number    0    1
    Get Product Sku Info By Sku Number - GET
    Get User Shipping Cart Info - GET
    Get Shipping Cart Items - GET
    Remove All Items From Shipping Cart - DELETE
    Add Items To Shipping Carts By SkuNumber- POST
    Get Shipping Cart Items - GET
    Get CK Tax Quotation Info - POST    ${Pro_Sku_Info}    ${Shipping_Cart_Items}    ${CK_Address_Info}
    Create Order Requests By User - Post    ${Shipping_Cart_Items}
    [Teardown]    B2B User Sign Out - POST

