*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/ShippingCartKeywords.robot
Resource            ../../Keywords/B2B/ProductKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Shipping Cart
Suite Teardown       Delete All Sessions

*** Test Cases ***
Test Get User Shipping Cart Id
    [Tags]    b2b    b2b-cart
    Get User Shipping Cart Info - GET

Test Add Item To Shipping Cart
    [Tags]    b2b    b2b-cart
    Get Single Or Multi Item's Sku Number
    Add Items To Shipping Carts By SkuNumber- POST

Test Get Shipping Cart Items
    [Tags]    b2b    b2b-cart
    Get Shipping Cart Items - GET

Test Update Item's Quantity On Shipping Cart
    [Tags]    b2b    b2b-cart
    Update Shpping Cart Item's Quantity - PUT

Test Remove Item From Shipping Cart By Id
    [Tags]    b2b    b2b-cart
    Remove Items From Shipping Cart By Id- DELETE

Test Remove All Items From Shipping Cart
    [Tags]    b2b    b2b-cart
    Get Single Or Multi Item's Sku Number    1    2
    Get Product Sku Info By Sku Number - GET
    Add Items To Shipping Carts By Product List - POST
    Get Shipping Cart Items - GET
    Remove All Items From Shipping Cart - DELETE

