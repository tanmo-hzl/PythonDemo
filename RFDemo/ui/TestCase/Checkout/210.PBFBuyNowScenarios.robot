*** Settings ***
#Resource  ../../TestData/Checkout/config.robot
Resource   ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot

Suite Setup    Run Keywords   initial env data2
Test Teardown  Run Keywords   clear cart   AND   Close Browser



*** Variables ***
${zipCode}      98008
&{buyer}       user=neivi131@snapmail.cc             password=Aa123456
&{buyer14}       user=neivi131@snapmail.cc             password=Aa123456
&{store1_info}    store_name=Crossroads Bellevue      zipcode=98008

*** Test Cases ***
01-PBF-Guest->SignIn-SDD_BY
    [Documentation]  [CP-5638][PBF] - SDD - Guest-->Sign in - Buy now 1 item to place order and store address is in WA, you can place order successed
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[zipcode]
    @{product_list}    Create List     MIK|listing|${SDD[1]}|1|BY|SDD|${EMPTY}    Add To Cart   ${EMPTY}
    Select Products and Select Purchase Type   ${product_list}
    login in slide page    ${buyer14['user']}    ${buyer14['password']}
    Click Book Class Only Button
    Buy Now Class - Input All Guest Info    ${ONE_PRODUCT_INFO}[product_type]
    Book Class Only Process
    log    ${ORDER_NO}



02-PBF-SignIn-SDD_BY
    [Documentation]  [CP-5630][PBF] - SDD - Sign in - Buy now 1 item to place order and store address is in WA, you can place order successed
    [Tags]     full-run   PBF
    [Setup]   Run Keywords    Login    ${buyer14['user']}    ${buyer14['password']}     AND     clear cart
    [Template]   Buyer Checkout Work Flow
    MIK|listing|${SDD[0]}|1|BY|SDD|${EMPTY}    Buy Now    Credit Card


03-PBF-SignIn-SDD_BY
    [Documentation]  [CP-5628][PBF] - SDD - Sign in - Buy now 3 item and store address is in WA, paper bag fee is $0.08 in order summary moudle
    [Tags]     full-run   PBF
    [Setup]   Run Keywords    Login    ${buyer14['user']}    ${buyer14['password']}     AND     clear cart
    [Template]   PBF-SignIn-BuyNow
    $0.08    MIK|listing|${SDD[0]}|3|BY|SDD|${EMPTY}    Buy Now    ${EMPTY}


04-PBF-SignIn-SDD_BY
    [Documentation]  [CP-5627][PBF] - SDD - Sign in - Buy now 1 item and store address is in WA, paper bag fee is $0.08 in order summary moudle
    [Tags]     full-run    PBF
    [Setup]   Run Keywords    Login    ${buyer14['user']}    ${buyer14['password']}     AND     clear cart
    [Template]   PBF-SignIn-BuyNow
    $0.08    MIK|listing|${SDD[0]}|1|BY|SDD|${EMPTY}    Buy Now    ${EMPTY}


05-PBF-Guest->SignIn-PIS_BY
    [Documentation]  [CP-5624][PBF] - BOPIS - Guest -->Sign in - Buy now 3 item and store address is in WA,click Sign in button,paper bag fee should be displayed in order summary on slide panel on the right and paper bag fee is $0.08
    [Tags]    full-run    PBF
    [Setup]   Run Keywords    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}     AND    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[zipcode]
    [Template]    PBF-Guest->SignIn-BuyNow
    $0.08    MIK|listing|${PIS[0]}|3|BY|PIS|${EMPTY}    Buy Now    ${EMPTY}


06-PBF-Guest->SignIn-PIS_BY
    [Documentation]  [CP-5623][PBF] - BOPIS - Guest -->Sign in - Buy now 1 item and store address is in WA,click Sign in button,paper bag fee should be displayed in order summary on slide panel on the right and paper bag fee is $0.08
    [Tags]    full-run    PBF
    [Setup]   Run Keywords    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}    AND    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[zipcode]
    [Template]    PBF-Guest->SignIn-BuyNow
    $0.08    MIK|listing|${PIS[0]}|1|BY|PIS|${EMPTY}    Buy Now    ${EMPTY}


07-PBF-Guest->SignIn-PIS_BY
    # to do
    [Documentation]  [CP-5622][PBF] - BOPIS - Guest -->Sign in - Buy now 1 item to place order and store address is in WA, you can place order successed
    [Tags]    PBF
    [Setup]   Run Keywords    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}    AND    Change Store From Home Page    ${store1_info}[store_name]     ${store1_info}[zipcode]
    @{product_list}    Create List     MIK|listing|${PIS[0]}|1|BY|PIS|${EMPTY}    Buy Now    ${EMPTY}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Check Paper Bag Fees In Order Summary    $0.08
    Buy Now Process


08-PBF-Guest->SignIn-PIS_BY
    [Documentation]  [CP-5621][PBF] - BOPIS - Guest -->Sign in - Buy now 1 item and store address is not in WA, not display paper bag fee in order summary moudle
    [Tags]    PBF
    [Setup]   Run Keywords    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}    AND    Change Store From Home Page    Glade Parks    76039
    @{product_list}    Create List     MIK|listing|${PIS[0]}|1|BY|PIS|${EMPTY}    Buy Now    ${EMPTY}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
#    Login In Slide Page     ${buyer14['user']}    ${buyer14['password']}
    Check Paper Bag Fees Not In Order Summary


09-PBF-Guest-PIS_BY
    [Documentation]  [CP-5620][PBF] - BOPIS - Guest - Buy now 5 item and store address is in WA,click [CONTINUE AS GUEST] button,paper bag fee should be displayed on Getting your Order page and paper bag fee is $0.08
    [Tags]    PBF
    [Setup]   Run Keywords    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}    AND    Change Store From Home Page    Crossroads Bellevue    98008
    [Template]      PBF-Guest-BuyNow
    $0.08    MIK|listing|${PIS[0]}|5|BY|PIS|${EMPTY}    Buy Now    ${EMPTY}


10-PBF-Guest-PIS_BY
    [Documentation]  [CP-5619][PBF] - BOPIS - Guest - Buy now 1 item and store address is in WA,click [CONTINUE AS GUEST] button,paper bag fee should be displayed on Getting your Order page and paper bag fee is $0.08
    [Tags]    PBF
    [Setup]   Run Keywords    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}    AND    Change Store From Home Page    Crossroads Bellevue    98008
    [Template]      PBF-Guest-BuyNow
    $0.08    MIK|listing|${PIS[0]}|1|BY|PIS|${EMPTY}    Buy Now    ${EMPTY}


11-PBF-Guest->SignIn-PIS_BY
    [Documentation]  [CP-5618][PBF] - BOPIS - Guest -->Sign in - Buy now 1 item and store address is not in WA, not display paper bag fee in order summary moudle
    [Tags]    PBF
    [Setup]   Run Keywords    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}    AND    Change Store From Home Page    Glade Parks    76039
    @{product_list}    Create List     MIK|listing|${PIS[0]}|1|BY|PIS|${EMPTY}    Buy Now    ${EMPTY}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Login In Slide Page     ${buyer14['user']}    ${buyer14['password']}
    Check Paper Bag Fees Not In Order Summary



*** Keywords ***
#PBF-Guest-BuyNow
#    [Arguments]    ${E_pbf}    @{product_list}
#    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
#    Check Paper Bag Fees In Order Summary     ${E_pbf}


PBF-SignIn-BuyNow
    [Arguments]    ${E_pbf}    @{product_list}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${True}
    Check Paper Bag Fees In Order Summary    ${E_pbf}


PBF-Guest->SignIn-BuyNow
    [Arguments]    ${E_pbf}    @{product_list}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Check Paper Bag Fees In Order Summary    ${E_pbf}


PBF-Guest-BuyNow
    [Arguments]    ${E_pbf}    @{product_list}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Click Continue As Guest Button
    Check Paper Bag Fees In Order Summary    ${E_pbf}
