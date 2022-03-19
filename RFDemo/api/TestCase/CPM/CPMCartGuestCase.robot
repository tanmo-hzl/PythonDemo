*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/CartKeywords.robot
Suite Setup      Run Keywords    Sign in ENV and Initial - MIK -User
Suite Teardown   Delete All Sessions
Library             ../../TestData/CPM/ProductsInfo.py

*** Test Cases ***
Test Get Guest Cart Items positive
    [Tags]    CPM-Cart    cpm-Smoke
    [Documentation]    Test Get Guest Cart Items positive
    ${skus}    get skus
    ${items}    get from dictionary    ${skus}    Test single MIK goods shipped by GROUND_STANDARD
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Create Carts by guest- POST    ${user_id}
    CPM Create Cart Items by Cart id Guest- POST    ${user_id}    ${items}
    ${cart_id}    get from dictionary    ${CartInof}    shoppingCartId
    CPM Create Carts Bind-POST    ${cart_id}    ${user_id}
    CPM Get Cart Items by guest- List