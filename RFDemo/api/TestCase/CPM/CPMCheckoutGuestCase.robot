*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/CartKeywords.robot
Suite Setup      Run Keywords    Set Initial Data - MIK - Guest
Suite Teardown   Delete All Sessions
Library             ../../TestData/CPM/ProductsInfo.py

*** Test Cases ***
Test the mode of transportation for single MIK goods By ISPU
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single MIK goods By ISPU
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by ISPU
    CPM Guest Order process    ${items}

Test the mode of transportation for single ARR goods By DIGITAL
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single ARR goods By DIGITAL
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK ARR goods shipped by DIGITAL
    CPM Guest Order process    ${items}

Test the mode of transportation for single MIK goods By GROUND_STANDARD
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single MIK goods By GROUND_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Guest Order process    ${items}

Test the mode of transportation for single MIK goods By GROUND_SECONDDAY
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single MIK goods By GROUND_SECONDDAY
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_SECONDDAY
    CPM Guest Order process    ${items}

Test the mode of transportation for single MIK goods By GROUND_OVERNIGHT
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single MIK goods By GROUND_OVERNIGHT
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_OVERNIGHT
    CPM Guest Order process    ${items}

Test the mode of transportation for single MIK goods By SAMEDAYDELIVERY
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single MIK goods By SAMEDAYDELIVERY
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by SAMEDAYDELIVERY
    CPM Guest Order process    ${items}

Test the modes of multiple transports ISPU + GROUND_STANDARD
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the modes of multiple transports ISPU + GROUND_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the modes of multiple transports ISPU and GROUND_STANDARD
    CPM Guest Order process    ${items}

Test the modes of multiple transports ISPU + GROUND_OVERNIGHT
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the modes of multiple transports ISPU + GROUND_OVERNIGHT
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the modes of multiple transports ISPU and GROUND_OVERNIGHT
    CPM Guest Order process    ${items}

Test the modes of multiple transports ISPU + DIGITAL+ GROUND_SECONDDAY + SAMEDAYDELIVERY
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the modes of multiple transports ISPU + DIGITAL+ GROUND_SECONDDAY + SAMEDAYDELIVERY
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the modes of multiple transports ISPU + DIGITAL+ GROUND_SECONDDAY + SAMEDAYDELIVERY
    CPM Guest Order process    ${items}

Test the same skuNumber different subSkuNumber
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the same skuNumber different subSkuNumber
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the same skuNumber different subSkuNumber
    CPM Guest Order process    ${items}

Test the mode of transportation for single FGM ARR goods is DIGITAL
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single FGM ARR goods is DIGITAL
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single FGM ARR goods is DIGITAL
    CPM Guest Order process    ${items}

Test the mode of transportation for single FGM goods is FGM_STANDARD
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single FGM goods is FGM_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single FGM goods is FGM_STANDARD
    CPM Guest Order process    ${items}

Test the mode of transportation for single FGM goods is FGM_SECOND_DAY_AIR
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single FGM goods is FGM_SECOND_DAY_AIR
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single FGM goods is FGM_SECOND_DAY_AIR
    CPM Guest Order process    ${items}

Test Same store, same mode of delivery
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Same store, same mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test FGM Same store, same mode of delivery FGM_SECOND_DAY_AIR
    CPM Guest Order process    ${items}

Test Same store, different mode of delivery
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Same store, different mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Same store, different mode of delivery
    CPM Guest Order process    ${items}

Test Different store,same mode of delivery
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Different store,same mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Different store,same mode of delivery FGM_THREE_DAY_SELECT
    CPM Guest Order process    ${items}

Test Different store,different mode of delivery
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Different store,different mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Different store,different mode of delivery
    CPM Guest Order process    ${items}

Test Different store,mix mode of delivery
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Different store,mix mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Different store,mix mode of delivery
    CPM Guest Order process    ${items}

Test the mode of transportation for single THP goods is Expected
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is Expected
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is Expected
    CPM Guest Order process    ${items}

Test the mode of transportation for single THP goods is THP_STANDARD
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is THP_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is THP_STANDARD
    CPM Guest Order process    ${items}

Test the mode of transportation for single THP goods is Free
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is Free
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is Free
    CPM Guest Order process    ${items}

Test the mode of transportation for single THP goods is Freight
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is Freight
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is Freight
    CPM Guest Order process    ${items}

Test ARR for several different channels
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test ARR for several different channels
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test ARR for several different channels
    CPM Guest Order process    ${items}

Test Submit Order For Single Bundle
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Submit Order For Single Bundle
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Submit Order For Single Bundle
    CPM Guest Order process    ${items}

Test Subscription Pay with a gift card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Subscription Pay with a gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card
    ${items}    get from dictionary    ${skus}    Test Subscription Pay with a gift card
    CPM Guest Order process    ${items}    ${order_payment}

Test Monthly Subscription Orders
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Monthly Subscription Orders
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Monthly Subscription Orders
    CPM Guest Order process    ${items}

Test Weekly Subscription Orders
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test Weekly Subscription Orders
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Weekly Subscription Orders
    CPM Guest Order process    ${items}

Test payment by credit card Id
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by credit card Id
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    credit_id
    ${items}    get from dictionary    ${skus}    Test payment by credit card Id
    CPM Guest Order process    ${items}    ${order_payment}    200    40926

Test payment by credit card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by credit card
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test payment by credit card
    CPM Guest Order process    ${items}

Test payment by User binding gift card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by User binding gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card_id
    ${items}    get from dictionary    ${skus}    Test payment by gift card
    CPM Guest Order process    ${items}    ${order_payment}    200    40926

Test payment by gift card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card
    CPM Guest Order process    ${items}    ${order_payment}

Test payment by gift card + gift card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card_number
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card
    CPM Guest Order process    ${items}    ${order_payment}

Test payment by gift card + credit card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + credit card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    guest_gift_card_credit_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card + credit card
    CPM Guest Order process    ${items}    ${order_payment}

Test payment by gift card + gift card +credit card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card +credit card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    guest_multi_gift_card_credit_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card +credit card
    CPM Guest Order process    ${items}    ${order_payment}

Test payment by gift card(balance 0) + gift card
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card(balance 0) + gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    guest_multi_gift_card_zero
    ${items}    get from dictionary    ${skus}    Test payment by gift card(balance 0) + gift card
    CPM Guest Order process    ${items}    ${order_payment}

Test payment by gift card + gift card Not enough to pay
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card Not enough to pay
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    guest_multi_gift_card_insufficient
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card Not enough to pay
    CPM Guest Order process    ${items}    ${order_payment}

Test payment by gift card + gift card enough to pay
    [Tags]    CPM-Guest-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card enough to pay
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card_number
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card enough to pay
    CPM Guest Order process    ${items}    ${order_payment}