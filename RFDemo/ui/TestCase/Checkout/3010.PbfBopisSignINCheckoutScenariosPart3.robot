*** Settings ***
#Resource  ../../TestData/Checkout/config.robot
Resource   ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Suite Setup    Run Keyword   initial env data2
Test Setup   Run Keyword     Initial Test case
Test Teardown  Run Keywords   clear cart   AND   Close Browser



*** Variables ***
${delivering_zipCode_shipping}      98008
&{login_slide_user}       email=autoCpmUi7@xxxhi.cc               password=Password123
&{guest_billing_address}            firstName=MO
...                                 lastName=DD
...                                 addressLine1=136 NE 10th St
...                                 city=Bellevue
...                                 state=WA
...                                 zipCode=98008
...                                 phoneNumber=469-779-6009

*** Test Cases ***
1.PBF-Checkout-2store,2item-BOPIS-login-paper bag fee is $0.16
    [Documentation]  [CP-5680]Checkout - BOPIS - Sign in - Add 2 different item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    Pbf-BOPIS-SignIn-checkout   PIS  2   2|1

2.PBF-Checkout-2store,1item,qty:2-BOPIS-login-paper bag fee is $0.16
    [Documentation]  [CP-5679]Checkout - BOPIS - Sign in - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    Pbf-BOPIS-SignIn-checkout  PIS   2    1|1

3.PBF-Checkout-1store,2item,qty:2-BOPIS-login-paper bag fee is $0.08
    [Documentation]  [CP-5678]Checkout - BOPIS - Sign in - Add 2 different item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    Pbf-BOPIS-SignIn-checkout  PIS   1    2|1

4.PBF-Checkout-1store,1item,qty:2-BOPIS-login-paper bag fee is $0.08
    [Documentation]  [CP-5677]Checkout - BOPIS - Sign in - Add 2 same item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    Pbf-BOPIS-SignIn-checkout  PIS   1    1|2

5.PBF-Checkout-1store,1item,qty:1-BOPIS-login-paper bag fee is $0.08
    [Documentation]  [CP-5676] Checkout - BOPIS - Sign in - Add 1 PUIS item to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    Pbf-BOPIS-SignIn-checkout  PIS   1    1|1

6.PBF-Checkout-1store,1item,qty:1-SDD-login-paper bag fee is $0.08
    [Documentation]  [CP-5675]Cart - SDD - Guest->Sign in - Add 1 SDD item to cart and store address is in WA,click [PROCEED TO CHECKOUT]-->[Sign in],paper bag fee is displayed in order summary
    [Tags]  full-run    yitest1
    [Setup]   Run Keyword     Initial Test case     ${False}
    Pbf-BOPIS-SignIn-checkout  SDD   1    1|1



7.PBF-Checkout-2store,2item-BOPIS-Guest->login-paper bag fee is $0.16
    [Documentation]  [CP-5705] Checkout - BOPIS - Guest->Sign in - Add 2 different item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] -->[Sign in] button,paper bag fee is $0.16 on checkout page
    [Tags]  full-run    yitest
    [Setup]   Run Keyword     Initial Test case     ${False}
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user1}      Create Dictionary      email=autoCpmUi6@xxxhi.cc               password=Password123
    Set Test Variable   ${login_slide_user}      ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...      MIK|listing|${PIS[1]}|1|ATC|PIS|98034_1_SEA-KIRKLAND
    ...      Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

17.PBF-Checkout-2stroe,1item qty:2-BOPIS-guest-->Sgin in-paper bag fee is $0.16
    [Documentation]  [CP-5689]Checkout - BOPIS - Guest->Sign in - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT]-->[Sign in] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keyword     Initial Test case     ${False}
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...    MIK|listing|${PIS[0]}|1|ATC|PIS|98034_1_SEA-KIRKLAND      Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

18.PBF-Checkout-1stroe,2item qty:2-BOPIS-guest-->Sgin in-paper bag fee is $0.08
    [Documentation]  [CP-5688]Checkout - BOPIS - Guest->Sign in - Add 2 different item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT]-->[Sign in] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keyword     Initial Test case     ${False}
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...    MIK|listing|${PIS[1]}|1|ATC|PIS|98008_1_Crossroads Bellevue      Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

19.PBF-Checkout-1stroe,1item qty:2-BOPIS-guest-->Sgin in-paper bag fee is $0.08
    [Documentation]  [CP-5687]Checkout - BOPIS - Guest->Sign in - Add 2 different item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT]-->[Sign in] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keyword     Initial Test case     ${False}
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_2_Crossroads Bellevue
    ...     Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

20.PBF-Checkout-1stroe,1item qty:1-BOPIS-guest-->Sgin in-paper bag fee is $0.08
    [Documentation]  [CP-5685]Checkout - BOPIS - Guest->Sign in - Add 1 PUIS item to checkout and store address is in WA,click [PROCEED TO CHECKOUT]-->Sign in -  button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keyword     Initial Test case     ${False}
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...     Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08



*** Keywords ***
Initial Test case
    [Arguments]  ${if sign}=${true}
    IF  ${if sign}
        Set Test Variable  ${account_info["first_name"]}      autoui
        login   ${login_slide_user["email"]}    ${login_slide_user["password"]}
        Clear Cart
    ELSE
        Open Browser   ${Home URL}      ${BROWSER}
        Maximize Browser Window
    END


Pbf-BOPIS-SignIn-checkout
    [Arguments]    ${shipping}=PIS    ${store_number}=1    ${item_number}=1|2
    ${product_list}    Create List
    ${item_list}    split_parameter   ${item_number}   |
    IF  "${shipping}"=="PIS"
        ${store_list}   Create List   98008_${item_list[1]}_Crossroads Bellevue     98034_${item_list[1]}_SEA-KIRKLAND
        Set Test Variable   ${delivering_zipCode_shipping}   ${empty}
    ELSE IF  "${shipping}"=="SDD"
        ${store_list}   Create List   Crossroads Bellevue,98008       SEA-KIRKLAND,98034
        Set Test Variable   ${delivering_zipCode_shipping}   98008
    END
    IF  "${store_number}"=="2" or "${item_list[0]}"=="2"
        ${loop_number}  Set Variable   ${2}
    ELSE
        ${loop_number}  Set Variable   ${1}
    END

    FOR  ${i}  IN RANGE  ${loop_number}
        IF  "${item_list[0]}"=="1"
            ${item_str}   Set Variable    ${${shipping}}[0]
        ELSE IF   "${item_list[0]}"=="2"
            ${item_str}   Set Variable    ${${shipping}}[${i}]
        END
        Log  ${item_str}
        IF  "${store_number}"=="1"
            ${store_str}   Set Variable    ${store_list[0]}
        ELSE IF   "${store_number}"=="2"
            ${store_str}   Set Variable    ${store_list[${i}]}
        END
        Log  ${store_str}
        Append To List   ${product_list}     MIK|listing|${item_str}|1|ATC|${shipping}|${store_str}
    END
    Append To List   ${product_list}    Add To Cart     Credit Card
    Log  ${product_list}
    ${Expect_Value}  Evaluate    ${store_number} * ${0.08}

    PBF-Guest-Sign in-checkout  @{product_list}   payment_order=false   Expect_Value=${Expect_Value}
