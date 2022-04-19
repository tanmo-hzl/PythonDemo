*** Settings ***
#Resource  ../../TestData/Checkout/config.robot
Resource   ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Suite Setup    Run Keywords   initial env data2
Test Setup   Run Keywords  Open Browser   ${Home URL}      chrome
...           AND    Maximize Browser Window
Test Teardown  Run Keywords   clear cart   AND   Close Browser



*** Variables ***
${delivering_zipCode_shipping}      98008
&{login_slide_user}       email=Guest               password=Password123
&{guestInfo}                        firstName=MO
...                                 lastName=DD
...                                 addressLine1=136 NE 10th St
...                                 city=Bellevue
...                                 state=WA
...                                 zipCode=98008
...                                 email=autoCpmUi1@xxxhi.cc
...                                 phoneNumber=469-779-6009

&{guest_billing_address}            firstName=MO
...                                 lastName=DD
...                                 addressLine1=136 NE 10th St
...                                 city=Bellevue
...                                 state=WA
...                                 zipCode=98008
...                                 phoneNumber=469-779-6009

&{pickupInfo}                       firstName=Pickup
...                                 lastName=Info
...                                 email=autoCpmUi1@xxxhi.cc
...                                 phoneNumber=469-779-6009

*** Test Cases ***
1.PBF-Checkout-1item qty:1-Sdd-Guest-paper bag fee is $0.08
    [Documentation]  [CP-5709]Checkout - SDD - Guest - Add 1 SDD item to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user1}      Create Dictionary      email=Guest               password=Password123
    Set Test Variable   ${login_slide_user}    ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[1]}|1|ATC|SDD|Crossroads Bellevue,98008   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

8.PBF-Checkout-2store,2item-BOPIS-Guest-paper bag fee is $0.16
    [Documentation]  [CP-5704] Checkout - BOPIS - Guest->Sign in - Add 2 different item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] -->[Sign in] button,paper bag fee is $0.16 on checkout page
    [Tags]  full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user1}      Create Dictionary      email=Guest               password=Password123
    Set Test Variable   ${login_slide_user}        ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...      MIK|listing|${PIS[1]}|1|ATC|PIS|98034_1_SEA-KIRKLAND
    ...      Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

10.PBF-Checkout-2store,2item-SDD-Guest-paper bag fee is $0.16
    [Documentation]  [CP-5697]Checkout - SDD - Guest->Sign in - Add 2 different item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,click [Sign in] in michaels rewards moudle,paper bag fee is $0.16 on checkout page
    [Tags]  full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user1}      Create Dictionary      email=Guest               password=Password123
    Set Test Variable  ${login_slide_user}      ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[1]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

11.PBF-Checkout-2store,1item-SDD-Guest-paper bag fee is $0.16
    [Documentation]  [CP-5696]Checkout - SDD - Guest - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user1}      Create Dictionary      email=Guest               password=Password123
    Set Test Variable  ${login_slide_user}      ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[0]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

12.PBF-Checkout-1store,2item-SDD-Guest-paper bag fee is $0.08
    [Documentation]  [CP-5695]Checkout - SDD - Guest - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${login_slide_user1}      Create Dictionary      email=Guest               password=Password123
    Set Test Variable  ${login_slide_user}      ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[1]}|1|ATC|SDD|${empty}   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

13.PBF-Checkout-1store,1item qry:2-SDD-Guest-paper bag fee is $0.08
    [Documentation]  [CP-5694]Checkout - SDD - Guest - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${login_slide_user1}      Create Dictionary      email=Guest               password=Password123
    Set Test Variable  ${login_slide_user}      ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|2|ATC|SDD|Crossroads Bellevue,98008     Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

14.PBF-Checkout-2store,1item qry:2-BOPIs-Guest-paper bag fee is $0.16
    [Documentation]  [CP-5684]Checkout - BOPIS - Guest - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT]-->[CONTINUE AS Guest] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...   MIK|listing|${PIS[0]}|1|ATC|PIS|98034_1_SEA-KIRKLAND     Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

15.PBF-Checkout-1store,2item qry:2-BOPIs-Guest-paper bag fee is $0.08
    [Documentation]  [CP-5683] Checkout - BOPIS - Guest - Add 2 different item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT]-->[CONTINUE AS Guest] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...   MIK|listing|${PIS[1]}|1|ATC|PIS|98008_1_Crossroads Bellevue     Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

16.PBF-Checkout-1store,1item qry:2-BOPIs-Guest-paper bag fee is $0.08
    [Documentation]  [CP-5682]Checkout - BOPIS - Guest - Add 2 same item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT]-->[CONTINUE AS Guest] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_2_Crossroads Bellevue
    ...      Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

17.PBF-Checkout-1store,1item qry:1-BOPIs-Guest-paper bag fee is $0.08
    [Documentation]  [CP-5681]Add 1 PUIS item to checkout and store address is in WA,Click [PROCEED TO CHECKOUT]-->[CONTINUE AS Guest] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]  full-run    yitest
    PBF-Guest-Sign in-checkout   MIK|listing|${PIS[0]}|1|ATC|PIS|98008_1_Crossroads Bellevue
    ...      Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

