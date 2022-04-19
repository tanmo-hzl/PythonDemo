*** Settings ***
#Resource  ../../TestData/Checkout/config.robot
Resource   ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Suite Setup    Run Keywords   initial env data2
Test Teardown  Run Keywords   clear cart   AND   Close Browser



*** Variables ***
${zipCode}      98008
&{buyer13}       user=neivi130@snapmail.cc         password=Aa123456

*** Test Cases ***

01-PBF-Guest->SignIn
    [Documentation]  [CP-5654][PBF] - Cart - BOPIS - Guest-->Sign in - Add 1 PUIS item to cart and store address is in WA when sign-in cart is empty,click [Sign in] button in the header,paper bag fee is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    @{product_list}    Create List     MIK|listing|${PIS[1]}|1|ATC|PIS|98008_1_Crossroads Bellevue    Add To Cart   ${EMPTY}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Click View My Cart Button
    Login In Header       ${buyer13['user']}    ${buyer13['password']}
    Check Paper Bag Fees In Order Summary     $0.08


02-PBF-Guest-PIS
    [Documentation]  [CP-5651][PBF] - Cart - BOPIS - Guest - Add 2 PUIS item from the different store to cart and store address is in WA, save for late 1 item-> move the item to cart,paper bag is $0.16 -> $0.08 in order summary moudle
    [Tags]    full-run    PBF
#    [Setup]   Run Keywords    Login    ${buyer9['user']}    ${buyer9['password']}     AND     clear cart
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    @{product_list}    Create List     MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue    MIK|listing|${PIS[1]}|1|ATC|PIS|98034_1_SEA-KIRKLAND    Add To Cart   ${EMPTY}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Click View My Cart Button
    Check Paper Bag Fees In Order Summary     $0.16
    Click Save For Later Button By Index      1
    Check Paper Bag Fees In Order Summary     $0.08
    Click Move to Cart Button By Index        1
    Check Paper Bag Fees In Order Summary     $0.16


03-PBF-SignIn-PIS
    #to do
    [Documentation]   [CP-5650][PBF] - Cart - BOPIS - Guest - Add 2 PUIS item from the different store to cart and store address is in WA,click [change store],change different store into same store,paper bag is $0.16 -> $0.08 in order summary moudle
    [Tags]    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    @{product_list}    Create List     MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_SEA-KIRKLAND    MIK|listing|${PIS[1]}|1|ATC|PIS|98034_1_SEA-KIRKLAND    Add To Cart   ${EMPTY}
    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
    Click View My Cart Button
#    Change Store From Cart
    Check Paper Bag Fees In Order Summary     $0.16


04-PBF-Guest-PIS
    [Documentation]  [CP-5647][PBF] - Cart - BOPIS - Guest - Add 2 different item from the different store to cart and store address is in WA, paper bag is $0.16 in order summary moudle
    [Tags]    full-run   PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     PBF-Guest-Cart
    $0.16    MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue    MIK|listing|${PIS[1]}|1|ATC|PIS|98034_1_SEA-KIRKLAND    Add To Cart   ${EMPTY}


05-PBF-Guest-PIS
    [Documentation]  [CP-5646][PBF] - Cart - BOPIS - Guest - Add 2 same item from the different store to cart and store address is in WA, paper bag is $0.16 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keyword    Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
    [Template]     PBF-Guest-Cart
    $0.16    MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue    MIK|listing|${PIS[0]}|1|ATC|PIS|98034_1_SEA-KIRKLAND    Add To Cart   ${EMPTY}


06-PBF-SignIn-PIS
    [Documentation]  [CP-5645][PBF] - Cart - BOPIS - Sign in/Guest - Add 2 different item from the same store to cart and store address is in WA, paper bag is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keywords    Login    ${buyer13['user']}    ${buyer13['password']}     AND     clear cart
    [Template]     PBF-SignIn-Cart
    $0.08    MIK|listing|${PIS[0]}|1|ATC|PIS|0    MIK|listing|${PIS[1]}|1|ATC|PIS|0    Add To Cart   ${EMPTY}


07-PBF-SignIn-PIS
    [Documentation]  [CP-5644][PBF] - Cart - BOPIS - Sign in - Add 2 same item from the same store to cart and store address is in WA, paper bag is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keywords    Login    ${buyer13['user']}    ${buyer13['password']}     AND     clear cart
    [Template]     PBF-SignIn-Cart
    $0.08    MIK|listing|${PIS[0]}|2|ATC|PIS|0    Add To Cart   ${EMPTY}


08-PBF-SignIn-PIS
    [Documentation]  [CP-5643][PBF] - Cart - BOPIS - Sign in/Guest - Add 1 PUIS item to cart and store address is in WA,paper bag fee is $0.08 in order summary moudle
    [Tags]    full-run    PBF
    [Setup]   Run Keywords    Login    ${buyer13['user']}    ${buyer13['password']}     AND     clear cart
    [Template]     PBF-SignIn-Cart
    $0.08    MIK|listing|${PIS[0]}|1|ATC|PIS|0    Add To Cart   ${EMPTY}




#13-PBF-SignIn-PIS
#    [Documentation]  [CP-5651][PBF] - Cart - BOPIS - Sign in/Guest - Add 2 PUIS item from the different store to cart and store address is in WA, save for late 1 item-> move the item to cart,paper bag is $0.16 -> $0.08 in order summary moudle
#    [Tags]    full-run    PBF
#    [Setup]   Run Keywords    Login    ${buyer9['user']}    ${buyer9['password']}     AND     clear cart
#    @{product_list}    Create List     MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1    MIK|listing|${PIS[1]}|1|ATC|PIS|98034_1    Add To Cart   ${EMPTY}
#    Select Products and Purchase Type-v2    ${product_list}     ${True}     ${False}
#    Click View My Cart Button
#    Check Paper Bag Fees In Order Summary     $0.16






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


#Click Save For Later Button By Index
#    [Arguments]     ${index}
#    Wait Until Page Contains Element     (//div[text()="Save for Later"])\[${index}\]
#    Wait Until Element Is Visible     (//div[text()="Save for Later"])\[${index}\]
#    Click Element     (//div[text()="Save for Later"])\[${index}\]
#
#
#Click Move to Cart Button By Index
#    [Arguments]     ${index}
#    Wait Until Page Contains Element     (//div[text()="Move to Cart"])\[${index}\]
#    Wait Until Element Is Visible     (//div[text()="Move to Cart"])\[${index}\]
#    Click Element     (//div[text()="Move to Cart"])\[${index}\]
#
#
#Check Paper Bag Fees In Order Summary
#    [Arguments]    ${E_pbf}
#    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
#    Wait Until Element Is Visible    //h3[text()="Order Summary"]
#    Wait Until Element Is Visible    //*[text()="Total:"]/following-sibling::h4
#    Wait Until Element Is Visible    //p[text()="Other Fees"]
#    Click Element     //p[text()="Other Fees"]
#    Wait Until Element Is Visible     //p[text()="Paper Bag Fees"]/../following-sibling::p
#    ${pbf}   Get Text    //p[text()="Paper Bag Fees"]/../following-sibling::p
#    Should Be Equal As Strings     ${pbf}    ${E_pbf}     Paper Bag Fees are wrong
#
#Click SignIn in michaels rewards moudle
#    Wait Until Page Contains Element     //div[text()="Sign In"]/..
#    Wait Until Element Is Visible     //div[text()="Sign In"]/..
#    Click Element    //div[text()="Sign In"]/..