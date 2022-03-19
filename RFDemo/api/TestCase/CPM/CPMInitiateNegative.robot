*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/CartKeywords.robot
Suite Setup      Run Keywords    Sign in ENV and Initial - MIK -User
Suite Teardown   Delete All Sessions
Library             ../../TestData/CPM/ProductsInfo.py

*** Test Cases ***
Test Invalid Are Code
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test Invalid Are Code
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate Code    ${items}    400    40502    ${null}    UUU
    CPM Order Initiate Code    ${items}    400    40502    ${null}    1111

Test Invalid Boolean Value
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test Invalid Boolean Value
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate status    ${items}    400    BAD_REQUEST    ${null}    ${null}    YES
    CPM Order Initiate status    ${items}    400    BAD_REQUEST    ${null}    ${null}    NO

Test Invalid Store ID
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test Invalid Store ID
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate Code    ${items}    400    30010    ${null}    ${null}    ${null}    aaaa
    CPM Order Initiate Code    ${items}    400    30010    ${null}    ${null}    ${null}    1111

Test Invalid Channel Type
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test Invalid Channel Type
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate Code    ${items}    400    30042    ${null}    ${null}    ${null}    ${null}    3

Test non-existent Channel Type
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test non-existent Channel Type
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate status    ${items}    400    BAD_REQUEST    ${null}    ${null}    ${null}    ${null}    ff

Test Invalid Shipping Method
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test Invalid Shipping Method
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate Code    ${items}    400    30042    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    THP_STANDARD

Test non-existent Shipping Method
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test non-existent Shipping Method
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate status    ${items}    400    BAD_REQUEST    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    fffff

Test Invalid Quantity
    [Tags]    CPM-Initiate-Negative    cpm-Smoke
    [Documentation]    Test Invalid Quantity
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    CPM Order Initiate Code    ${items}    400    30033    ${null}    ${null}    ${null}    ${null}    ${null}    1.1
    CPM Order Initiate Code    ${items}    400    30033    ${null}    ${null}    ${null}    ${null}    ${null}    0
    CPM Order Initiate Code    ${items}    400    40502    ${null}    ${null}    ${null}    ${null}    ${null}    -1