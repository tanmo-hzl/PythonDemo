*** Settings ***
#Resource  ../../TestData/Checkout/config.robot
Resource   ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Suite Setup    Run Keywords   initial env data2
Test Teardown  Run Keywords   clear cart   AND   Close Browser



*** Variables ***
${zipCode}      98008
&{buyer9}       user=neivi126@snapmail.cc               password=Aa123456

*** Test Cases ***
01-PBF-SignIn-SDD
    [Documentation]  [CP-5663][PBF] - Cart - SDD - Sign in - Add 2 same item from the different store to cart and store address is in WA, paper bag is $0.16 in order summary moudle
    [Tags]    full-run   PBF
    [Setup]   Run Keywords    Login    ${buyer9['user']}    ${buyer9['password']}     AND     clear cart
    [Template]     PBF-SignIn-Cart
    $0.16    MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[0]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   ${EMPTY}


02-PBF-Guest-SDD
    [Documentation]  [CP-5663][PBF] - Cart - SDD - Guest - Add 2 same item from the different store to cart and store address is in WA, paper bag is $0.16 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     PBF-Guest-Cart
    $0.16    MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[0]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   ${EMPTY}


03-PBF-SignIn-SDD
    [Documentation]  [CP-5662][PBF] - Cart - SDD - Sign in - Add 2 different item from the same store to cart and store address is in WA, paper bag is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keywords    Login    ${buyer9['user']}    ${buyer9['password']}     AND     clear cart
    [Template]     PBF-Guest-Cart
    $0.08    MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[1]}|1|ATC|SDD|${EMPTY}   Add To Cart   ${EMPTY}


04-PBF-Guest-SDD
    [Documentation]  [CP-5662][PBF] - Cart - SDD - Guest - Add 2 different item from the same store to cart and store address is in WA, paper bag is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     PBF-Guest-Cart
    $0.08    MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[1]}|1|ATC|SDD|${EMPTY}   Add To Cart   ${EMPTY}


05-PBF-SignIn-SDD
    [Documentation]  [CP-5661][PBF] - Cart - SDD - Sign in - Add 2 same item from the same store to cart and store address is in WA, paper bag is $0.08 in order summary moudle
    [Setup]   Run Keywords    Login    ${buyer9['user']}    ${buyer9['password']}     AND     clear cart
    [Tags]    full-run   PBF
    [Template]     PBF-Guest-Cart
    $0.08    MIK|listing|${SDD[0]}|2|ATC|SDD|Crossroads Bellevue,98008    Add To Cart   ${EMPTY}


06-PBF-Guest-SDD
    [Documentation]  [CP-5661][PBF] - Cart - SDD - Guest - Add 2 same item from the same store to cart and store address is in WA, paper bag is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     PBF-Guest-Cart
    $0.08    MIK|listing|${SDD[0]}|2|ATC|SDD|Crossroads Bellevue,98008    Add To Cart   ${EMPTY}


07-PBF-SignIn-SDD
    [Documentation]  [CP-5660][PBF] - Cart - SDD - Sign in - Add 1 SDD item to cart and store address is in WA,paper bag fee is $0.08 in order summary moudle
    [Setup]   Run Keywords    Login    ${buyer9['user']}    ${buyer9['password']}     AND     clear cart
    [Tags]    full-run   PBF
    [Template]     PBF-Guest-Cart
    $0.08    MIK|listing|${SDD[1]}|1|ATC|SDD|Crossroads Bellevue,98008    Add To Cart   ${EMPTY}


08-PBF-Guest-SDD
    [Documentation]  [CP-5660][PBF] - Cart - SDD - Guest - Add 1 SDD item to cart and store address is in WA,paper bag fee is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     PBF-Guest-Cart
    $0.08    MIK|listing|${SDD[1]}|1|ATC|SDD|Crossroads Bellevue,98008    Add To Cart   ${EMPTY}


09-PBF-Guest->SignIn-PIS
    [Documentation]  [CP-5658][PBF] - Cart - BOPIS - Guest-->Sign in - Add 1 PUIS item to cart and store address is in WA,click [PROCEED TO CHECKOUT]-->[Sign in],paper bag fee is displayed in order summary
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     PBF-Guest->SignIn
    $0.08    MIK|listing|${PIS[1]}|1|ATC|PIS|98008_1_Crossroads Bellevue    Add To Cart   ${EMPTY}


10-PBF-Guest->SignIn
    [Documentation]  [CP-5656][PBF] - Cart - BOPIS - Guest-->Sign in - Add 1 PUIS item to cart and store address is in WA when sign-in cart is empty,click [Sign in] button in michaels rewards moudle,paper bag fee is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
#    [Template]     PBF-Guest->SignIn
#    0.08    MIK|listing|${PIS[1]}|1|ATC|PIS|Crossroads Bellevue,98008    Add To Cart   ${EMPTY}
    @{product_list}    Create List     MIK|listing|${PIS[1]}|1|ATC|PIS|98008_1_Crossroads Bellevue    Add To Cart   ${EMPTY}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Click View My Cart Button
    Click SignIn in michaels rewards moudle
    login without open browser     ${buyer9['user']}    ${buyer9['password']}
    Check Paper Bag Fees In Order Summary     $0.08



*** Keywords ***
PBF-Guest-Cart
    [Arguments]    ${E_pbf}    @{product_list}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Click View My Cart Button
    Check Paper Bag Fees In Order Summary     ${E_pbf}


PBF-SignIn-Cart
    [Arguments]    ${E_pbf}    @{product_list}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${True}
    Click View My Cart Button
    Check Paper Bag Fees In Order Summary    ${E_pbf}


PBF-Guest->SignIn
    [Arguments]    ${E_pbf}    @{product_list}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Click View My Cart Button
    Check Paper Bag Fees In Order Summary      ${E_pbf}
    Click Proceed To Checkout Button
    login in slide page      ${buyer9['user']}    ${buyer9['password']}
    Check Paper Bag Fees In Order Summary     ${E_pbf}
