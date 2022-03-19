*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/CartKeywords.robot
Suite Setup      Run Keywords    Sign in ENV and Initial - MIK -User
Suite Teardown   Delete All Sessions
Library             ../../TestData/CPM/ProductsInfo.py

*** Test Cases ***
Test Single FGM ARR
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Single FGM ARR
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Single FGM ARR
    CPM Order Initiate    ${items}

Test Single MIK Goods
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Single MIK Goods
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate    ${items}

Test Single MIK Goods
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Single MIK Goods
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single THP goods is THP_STANDARD
    CPM Order Initiate    ${items}

Test Single FGM Goods
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Single FGM Goods
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test the mode of transportation for single FGM goods is FGM_STANDARD
    CPM Order Initiate    ${items}

Test Single Bundle
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Single Bundle
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Submit Order For Single Bundle
    CPM Order Initiate    ${items}

Test ISPU For A MIK Single Good
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test ISPU For A MIK Single Good
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by ISPU
    CPM Order Initiate    ${items}

Test DIGITAL For A MIK Single Good
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test DIGITAL For A MIK Single Good
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK ARR goods shipped by DIGITAL
    CPM Order Initiate    ${items}

Test GROUND_STANDARD For A MIK Single Good
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test GROUND_STANDARD For A MIK Single Good
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate    ${items}

Test GROUND_SECONDDAY For A MIK Single Good
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test GROUND_STANDARD For A MIK Single Good
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_SECONDDAY
    CPM Order Initiate    ${items}

Test GROUND_OVERNIGHT For A MIK Single Good
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test GROUND_OVERNIGHT For A MIK Single Good
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_OVERNIGHT
    CPM Order Initiate    ${items}

Test SAMEDAYDELIVERY For A MIK Single Good
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test SAMEDAYDELIVERY For A MIK Single Good
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by SAMEDAYDELIVERY
    CPM Order Initiate    ${items}

Test Single Product By Subscription weekly
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Single Product By Subscription weekly
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Weekly Subscription Orders
    CPM Order Initiate    ${items}

Test Single Product By Subscription monthly
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Single Product By Subscription monthly
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Monthly Subscription Orders
    CPM Order Initiate    ${items}

Test items in different stores For THP
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test items in different stores For THP
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test items in different stores For THP
    CPM Order Initiate    ${items}

Test items in different stores For FGM
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test items in different stores For FGM
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test items in different stores For FGM
    CPM Order Initiate    ${items}

Test Goods With The Same SKU For FGM Arr
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Goods With The Same SKU For FGM Arr
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Goods With The Same SKU For FGM Arr
    CPM Order Initiate    ${items}

Test Goods With The Same SKU For THP
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Goods With The Same SKU For THP
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Goods With The Same SKU For THP
    CPM Order Initiate    ${items}

Test Goods With The Same SKU For MIK
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Goods With The Same SKU For MIK
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Goods With The Same SKU For MIK
    CPM Order Initiate    ${items}

Test Goods With The Same SKU For Bundles
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Goods With The Same SKU For Bundles
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Goods With The Same SKU For MIK
    CPM Order Initiate    ${items}

Test Goods With The Same SKU For FGM
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Goods With The Same SKU For FGM
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Goods With The Same SKU For MIK
    CPM Order Initiate    ${items}

Different modes of transportation from the same store SSD + GROUND_STANDARD
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Different modes of transportation from the same store SSD + GROUND_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    SSD and ship to me the same sku from different stores
    CPM Order Initiate    ${items}

Different modes of transportation from the same store ISPU + GROUND_STANDARD
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Different modes of transportation from the same store ISPU + GROUND_STANDARD
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Pick up and ship to me the same sku from different stores
    CPM Order Initiate    ${items}

Different modes of transportation in different shops For FGM
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Different modes of transportation in different shops For FGM
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Different store,different mode of delivery
    CPM Order Initiate    ${items}

Test different modes of transportation for multiple Bundles
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test different modes of transportation for multiple Bundles
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test different modes of transportation for multiple Bundles
    CPM Order Initiate    ${items}

Test Bundle And MIK Goods By Different Shipping Method
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Bundle And MIK Goods By Different Shipping Method
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Bundle And MIK Goods By Different Shipping Method
    CPM Order Initiate    ${items}

Test Bundle And FGM Goods
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Bundle And FGM Goods
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Bundle And FGM Goods
    CPM Order Initiate    ${items}

Test Bundle And THP Goods
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Bundle And THP Goods
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Bundle And THP Goods
    CPM Order Initiate    ${items}

Test Bundle And Other Goods
    [Tags]    CPM-Initiate    cpm-Smoke
    [Documentation]    Test Bundle And Other Goods
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test Bundle And Other Goods
    CPM Order Initiate    ${items}