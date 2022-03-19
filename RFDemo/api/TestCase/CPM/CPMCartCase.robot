*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/CartKeywords.robot
Suite Setup      Run Keywords    Sign in ENV and Initial - MIK -User
Suite Teardown   Delete All Sessions
Library             ../../TestData/CPM/ProductsInfo.py

*** Test Cases ***
Test Create Cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Create Cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Create Carts by user id- POST    ${user_id}

Test Create Cart Negative
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Create Cart Negative
#  ${session}  ${user_id}  ${channel}  ${currency}   ${code}  &{assert}
#${user_id}    ${channel}=RETAIL    ${subscriptionDefault}=${null}    ${cartType}=0
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Create Carts Negative- POST   ${user_id}   AAAAAAA    ${null}     0    400
    CPM Create Carts Negative- POST   0000000100000000   RETAIL     ${null}     0    403
    CPM Create Carts Negative- POST   ${user_id}   AAAAAAA    ${null}     400   400

Test Get cart by user ID
    [Documentation]    Test Get cart by user ID
    [Tags]    CPM-Cart    cpm-Smoke
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}

Test Get the requested cart
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Get the requested cart
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Get Cart by cart id- Get

Test Update cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Update cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    CPM Update Cart by cart id- PUT    ${user_id}    USD    ${cart_id}

Test Update cart Negative
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Update cart Negative
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Update Cart by cart id- PUT    ${user_id}    USD    1111111111111111111111    400
    CPM Update Cart by cart id- PUT    ${user_id}    USD    1111111111111111111    404

Test add single item to cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test add single item to cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${mikitems}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    ${fgmitems}    get from dictionary    ${skus}    Test the mode of transportation for single FGM goods is FGM_STANDARD
    ${thpitems}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is Expected
    ${arritems}    get from dictionary    ${skus}    Test single MIK ARR goods shipped by DIGITAL
    ${bundleitems}    get from dictionary    ${skus}    Test Submit Order For Single Bundle
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${mikitems}
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${fgmitems}
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${thpitems}
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${arritems}
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${bundleitems}

Test add Multiple MIK items to cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test add Multiple MIK items to cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test add Multiple MIK items to cart Positive
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}

Test add Multiple FGM items to cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test add Multiple FGM items to cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test items in different stores For FGM
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}

Test add Multiple THP items to cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test add Multiple THP items to cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test items in different stores For THP
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}

Test add the same sku items to cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test add the same sku items to cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${thpitems}    get from dictionary    ${skus}    Test Goods With The Same SKU For THP
    ${mikitems}    get from dictionary    ${skus}    Test Goods With The Same SKU For MIK
    ${fgmitems}    get from dictionary    ${skus}    Test Goods With The Same SKU For FGM
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${thpitems}
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${mikitems}
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${fgmitems}

Test add the same bundle sku different options to cart Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test add the same bundle sku different options to cart Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test same sku different options
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${items}

Test add items to cart Negative
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test add items to cart Negative
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD

    CPM Create Cart Items by Cart id Negative- POST    ${user_id}    ${items}    5505215240939126784    404

    CPM Create Cart Items by Cart id Negative- POST    4612645892195611111    ${items}    ${cart_id}    404

    ${items}    get from dictionary    ${skus}    Non-existent sku
    CPM Create Cart Items by Cart id Negative- POST    ${user_id}    ${items}    ${cart_id}    400

    ${items}    get from dictionary    ${skus}    The quantity of goods is 0
    CPM Create Cart Items by Cart id Negative- POST    ${user_id}    ${items}    ${cart_id}    400
#2022-03-16
Test get all items Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test get all items Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Get Cart Items by guest- List

Test get cart item Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test get cart item Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${shippingitems}    CPM Get Cart Items by guest- List
    ${shippingitem}    get from list    ${shippingitems}    0
    ${shippingitemid}    get from dictionary    ${shippingitem}    shoppingItemId
    CPM Get Cart Items by Shipping item Id- Get   ${shippingitemid}

Test update card items Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test update card items Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${shippingitems}    CPM Get Cart Items by guest- List
    ${shippingitem}    get from list    ${shippingitems}    0
    ${shippingitemid}    get from dictionary    ${shippingitem}    shoppingItemId
    ${newitem}    create dictionary    quantity=3
    CPM Update Cart Items by Shipping item Id- PUT    ${shippingitemid}    ${shippingitem}    ${newitem}

Test get cart item quantity Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test get cart item quantity Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${shippingitems}    CPM Get Cart Items by guest- List
    ${shippingitem}    get from list    ${shippingitems}    0
    ${shippingitemid}    get from dictionary    ${shippingitem}    shoppingItemId
    CPM Get Cart Items Quantity by Shipping item Id- Get    ${shippingitemid}

Test migrate cart item Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test migrate cart item Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    CPM Create migrate Cart Items- POST    ${cart_id}    2306802882933618709

Test transfer card items positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test transfer card items positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    CPM Create transfer Cart Items- POST    ${cart_id}    6049359937754226688

Test Get number of distinct items positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Get number of distinct items positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Get Cart Distinct Items- Get

Test Get total quantity positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Get total quantity positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    CPM Get Total Quantity Items- Get

Test delete cart item Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test delete cart item Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${mikitems}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${mikitems}
    ${shippingitems}    CPM Get Cart Items by guest- List
    ${shippingitem}    get from list    ${shippingitems}    0
    ${shippingitemid}    get from dictionary    ${shippingitem}    shoppingItemId
    CPM Delete Cart Item by Shipping item Id- Delete    ${shippingitemid}

Test delete cart item Positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test delete cart item Positive
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Carts by user id- Get    ${user_id}
    ${skus}    get skus
    ${mikitems}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Create Cart Items by Cart id- POST    ${user_id}    ${mikitems}
    CPM Delete Cart Item- Delete