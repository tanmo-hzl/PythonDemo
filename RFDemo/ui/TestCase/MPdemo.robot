*** Settings ***
Resource            ../Keywords/Common/CommonKeywords.robot
Resource            ../Keywords/Common/MenuKeywords.robot
Resource            ../Keywords/Common/ProductKeywords.robot
Resource            ../Keywords/Common/CartsKeywords.robot
Resource            ../TestData/MP/SellerData.robot
Resource            ../TestData/MP/BuyerData.robot
Suite Setup         Run Keywords    Open Browser - MP    buyer
...                                 AND   Open Browser - MP    seller
Suite Teardown      Close All Browsers

*** Variables ***
${Cur_User_Name}

*** Test Cases ***
Test Buyer Sign In
    [Tags]    mp-demo
    Switch Browser    buyer
    Set Suite Variable    ${Cur_User_Name}    ${BUYER_NAME}
    User Sign In - MP    ${BUYER}    ${PWD}    ${Cur_User_Name}

Test Clear Shipping Cart
    [Tags]    mp-demo
    Enter Buyer Cart Page On Home Page
    Remove All Items From Cart If Existed

Test Search Product By Sku
    [Tags]    mp-demo
    Product - Search Product By Sku    ${PRODUCT_SKU}    ${PRODUCT_NAME}
    Product - Enter PDP     ${PRODUCT_NAME}

Test Add Item To Shipping Cart
    [Tags]    mp-demo
    Product - Quantity Increate On PDP    2
    Product - Quantity Reduce On PDP    1
    Product - Quantity Update On PDP    5
    Product - Add Item To Cart On PDP
    Product - Eneter Cart Page After Add Item To Cart
    User Sign Out

Test Seller Sign In
    [Tags]    mp-demo
    Switch Browser    seller
    Set Suite Variable    ${Cur_User_Name}    ${SELLER_NAME}
    User Sign In - MP    ${SELLER_EMAIL}    ${PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    User Sign Out
