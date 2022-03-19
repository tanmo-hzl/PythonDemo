*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/CartKeywords.robot
Suite Setup      Run Keywords    Set Initial Data - MIK - User
Suite Teardown   Delete All Sessions
Library             ../../TestData/CPM/ProductsInfo.py

*** Test Cases ***
Test single MIK goods shipped by ISPU
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test single MIK goods shipped by ISPU
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by ISPU
    CPM Order process    ${items}

Test single MIK goods shipped by GROUND_STANDARD
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test single MIK goods shipped by GROUND_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order process    ${items}

Test single MIK goods shipped by GROUND_SECONDDAY
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test single MIK goods shipped by GROUND_SECONDDAY
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_SECONDDAY
    CPM Order process    ${items}

Test single MIK goods shipped by GROUND_OVERNIGHT
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test single MIK goods shipped by GROUND_OVERNIGHT
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_OVERNIGHT
    CPM Order process    ${items}

Test single MIK goods shipped by SAMEDAYDELIVERY
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test single MIK goods shipped by SAMEDAYDELIVERY
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by SAMEDAYDELIVERY
    CPM Order process    ${items}

Test the modes of multiple transports ISPU + GROUND_STANDARD
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the modes of multiple transports ISPU + GROUND_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the modes of multiple transports ISPU and GROUND_STANDARD
    CPM Order process    ${items}

Test the modes of multiple transports ISPU + GROUND_OVERNIGHT
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the modes of multiple transports ISPU + GROUND_OVERNIGHT
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the modes of multiple transports ISPU and GROUND_OVERNIGHT
    CPM Order process    ${items}

Test the same skuNumber different subSkuNumber
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the same skuNumber different subSkuNumber
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the same skuNumber different subSkuNumber
    CPM Order process    ${items}

Test Submit Order Including :FGM, THP, MIK
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Submit Order Including :FGM, THP, MIK
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Submit Order Including :FGM, THP, MIK
    CPM Order process    ${items}

Test single MIK ARR goods shipped by DIGITAL
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test single MIK ARR goods shipped by DIGITAL
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK ARR goods shipped by DIGITAL
    CPM Order process    ${items}

Test the modes of multiple transports ISPU + DIGITAL+ GROUND_SECONDDAY + SAMEDAYDELIVERY
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the modes of multiple transports ISPU + DIGITAL+ GROUND_SECONDDAY + SAMEDAYDELIVERY
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the modes of multiple transports ISPU + DIGITAL+ GROUND_SECONDDAY + SAMEDAYDELIVERY
    CPM Order process    ${items}

Test Submit Order Including :ARR , MIK, FGM, THP, Subscription, Bundle
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Submit Order Including :ARR , MIK, FGM, THP, Subscription, Bundle
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Submit Order Including :ARR , MIK, FGM, THP, Subscription, Bundle
    CPM Order process    ${items}

Test same sku Scription + buy
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test same sku Scription + buy
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test same sku Scription + buy
    CPM Order process    ${items}

Pick up the same goods from different stores
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Pick up the same goods from different stores
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Pick up the same goods from different stores
    CPM Order process    ${items}

Ship to me the same goods from different stores
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Ship to me the same goods from different stores
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Ship to me the same goods from different stores
    CPM Order process    ${items}

SSD the same goods from different stores
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    SSD the same goods from different stores
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    SSD the same goods from different stores
    CPM Order process    ${items}

Pick up and SSD the same sku from different stores
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Pick up and SSD the same sku from different stores
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Pick up and SSD the same sku from different stores
    CPM Order process    ${items}

SSD and ship to me the same sku from different stores
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    SSD and ship to me the same sku from different stores
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    SSD and ship to me the same sku from different stores
    CPM Order process    ${items}

Pick up and ship to me the same sku from different stores
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Pick up and ship to me the same sku from different stores
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Pick up and ship to me the same sku from different stores
    CPM Order process    ${items}

Pick up and SSD and ship to me the same sku from different stores
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Pick up and SSD and ship to me the same sku from different stores
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Pick up and SSD and ship to me the same sku from different stores
    CPM Order process    ${items}

Test Submit Order For Single Bundle
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Submit Order For Single Bundle
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Submit Order For Single Bundle
    CPM Order process    ${items}

Test same sku different options
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test same sku different options
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test same sku different options
    CPM Order process    ${items}

Test same sku different options and options sku is error
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test same sku different options and options sku is error
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test same sku different options and options sku is error
    set suite variable    ${cartstatus}    404
    set suite variable    ${status}    400
    CPM Order process Negative    ${items}    ${null}    ${status}    400    ${cartstatus}

Test Weekly Subscription Orders
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Weekly Subscription Orders
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Weekly Subscription Orders
    CPM Order process    ${items}    ${null}    ${null}    ${null}

Test Monthly Subscription Orders
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Monthly Subscription Orders
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Monthly Subscription Orders
    CPM Order process    ${items}

Test Subscription Pay with a gift card
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Subscription Pay with a gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card
    ${items}    get from dictionary    ${skus}    Test Subscription Pay with a gift card
    CPM Order process    ${items}    ${order_payment}

Test payment by credit card Id
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by credit card Id
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test payment by credit card Id
    CPM Order process    ${items}

Test using a gift card with an insufficient balance
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test using a gift card with an insufficient balance
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    insufficient_gift_card
    log to console    ${order_payment}
    ${items}    get from dictionary    ${skus}    Test using a gift card with an insufficient balance
    CPM Order process    ${items}    ${order_payment}    200    40926

Test payment by credit card
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by credit card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    credit_id
    ${items}    get from dictionary    ${skus}    Test payment by credit card
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card + gift card enough to pay
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card enough to pay
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card enough to pay
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card + gift card Not enough to pay
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card Not enough to pay
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card_insufficient
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card Not enough to pay
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card(balance 0) + gift card
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card(balance 0) + gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card_zero
    ${items}    get from dictionary    ${skus}    Test payment by gift card(balance 0) + gift card
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card(enough payment) + credit card id
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card(enough payment) + credit card id
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card_enough
    ${items}    get from dictionary    ${skus}    Test payment by gift card(enough payment) + credit card id
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card + gift card +credit card
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card +credit card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card_credit_card_id
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card +credit card
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card + credit card id
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + credit card id
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card_credit_card_id
    ${items}    get from dictionary    ${skus}    Test payment by gift card + credit card id
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card + credit card
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + credit card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card_credit_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card + credit card
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card + gift card id
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card id
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card_gift_card_id
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card id
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card + gift card
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card + gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    multi_gift_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card + gift card
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card Id
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card Id
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    enough_gift_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card Id
    CPM Order process    ${items}    ${order_payment}

Test payment by gift card
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test payment by gift card
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card
    ${items}    get from dictionary    ${skus}    Test payment by gift card
    CPM Order process    ${items}    ${order_payment}

Test user did not bind the gift card payment
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test user did not bind the gift card payment
    ${skus}    get skus
    ${payments}    get_payment
    ${order_payment}    get from dictionary    ${payments}    gift_card
    ${items}    get from dictionary    ${skus}    Test user did not bind the gift card payment
    CPM Order process    ${items}    ${order_payment}

Test ARR for several different channels
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test ARR for several different channels
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test ARR for several different channels
    CPM Order process    ${items}

Test the mode of transportation for single THP goods is Expected
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is Expected
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is Expected
    CPM Order process    ${items}

Test the mode of transportation for single THP goods is THP_STANDARD
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is THP_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is THP_STANDARD
    CPM Order process    ${items}

Test the mode of transportation for single THP goods is Freight
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is Freight
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is Freight
    CPM Order process    ${items}

Test the mode of transportation for single THP goods is Free
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single THP goods is Free
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is Free
    CPM Order process    ${items}

Test the mode of transportation for single FGM goods is FGM_STANDARD
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single FGM goods is FGM_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single FGM goods is FGM_STANDARD
    CPM Order process    ${items}

Test the mode of transportation for single FGM goods is FGM_SECOND_DAY_AIR
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single FGM goods is FGM_SECOND_DAY_AIR
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single FGM goods is FGM_SECOND_DAY_AIR
    CPM Order process    ${items}

Test FGM Same store, same mode of delivery FGM_SECOND_DAY_AIR
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test FGM Same store, same mode of delivery FGM_SECOND_DAY_AIR
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test FGM Same store, same mode of delivery FGM_SECOND_DAY_AIR
    CPM Order process    ${items}

Test the mode of transportation for single FGM ARR goods is DIGITAL
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test the mode of transportation for single FGM ARR goods is DIGITAL
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single FGM ARR goods is DIGITAL
    CPM Order process    ${items}

Test Same store, different mode of delivery
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Same store, different mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Same store, different mode of delivery
    CPM Order process    ${items}

Test Different store,different mode of delivery
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Different store,different mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Different store,different mode of delivery
    CPM Order process    ${items}

Test Different store,same mode of delivery FGM_THREE_DAY_SELECT
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Different store,same mode of delivery FGM_THREE_DAY_SELECT
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Different store,same mode of delivery FGM_THREE_DAY_SELECT
    CPM Order process    ${items}

Test Different store,mix mode of delivery
    [Tags]    CPM-Checkout    cpm-Smoke
    [Documentation]    Test Different store,mix mode of delivery
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Different store,mix mode of delivery
    CPM Order process    ${items}

