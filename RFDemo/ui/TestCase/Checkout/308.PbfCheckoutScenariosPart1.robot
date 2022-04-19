*** Settings ***
#Resource  ../../TestData/Checkout/config.robot
Resource   ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Suite Setup    Run Keywords   initial env data2
Test Teardown  Run Keywords   clear cart   AND   Close Browser



*** Variables ***
${delivering_zipCode_shipping}      98008
&{login_slide_user}       email=autoCpmUi4@xxxhi.cc               password=Password123
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
1.PBF-Checkout-2store,2item-SDD-Guest->login-paper bag fee is $0.16
    [Documentation]  [CP-5713]Checkout - SDD - Guest->Sign in - Add 2 different item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,click [Sign in] in michaels rewards moudle,paper bag fee is $0.16 on checkout page
    [Tags]  full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user}      Create Dictionary      email=autoCpmUi4@xxxhi.cc               password=Password123
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[1]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

2.PBF-Checkout-2store,1item-SDD-Guest->login-paper bag fee is $0.16
    [Documentation]  [CP-5712]-Checkout - SDD - Guest->Sign in - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,click  [Sign in] in michaels rewards moudle,paper bag fee is $0.16 on checkout page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user}      Create Dictionary      email=autoCpmUi4@xxxhi.cc               password=Password123
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[0]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

3.PBF-Checkout-1store,2item-SDD-Guest->login-paper bag fee is $0.08
    [Documentation]  [CP-5711]Checkout- SDD - Guest->Sign in - Add 2 different item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,click  [Sign in] in michaels rewards moudle,paper bag fee is $0.08 on checkout page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${delivering_zipCode_shipping}  Set Variable  98008
    ${login_slide_user}      Create Dictionary      email=autoCpmUi4@xxxhi.cc               password=Password123
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008    MIK|listing|${SDD[1]}|1|ATC|SDD|${empty}   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08


4.PBF-Checkout-1store,1item qty:2-SDD-Guest->login-paper bag fee is $0.08
    [Documentation]  [CP-5710]Checkout- SDD - Guest->Sign in - Add 2 different item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,click  [Sign in] in michaels rewards moudle,paper bag fee is $0.08 on checkout page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    ${login_slide_user}      Create Dictionary      email=autoCpmUi4@xxxhi.cc               password=Password123
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|2|ATC|SDD|Crossroads Bellevue,98008   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

5.PBF-Checkout-1item qty:1-Sdd-Guest-->login-paper bag fee is $0.08
    [Documentation]  [CP-5698]Checkout - SDD - Guest-->login - Add 1 SDD item to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Open Browser   ${Home URL}      chrome
    ...         AND    Maximize Browser Window
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[1]}|1|ATC|SDD|Crossroads Bellevue,98008   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08




6.PBF-Checkout-1item qty:1-sdd-Sgin in-paper bag fee is $0.08
    [Documentation]  [CP-5706]Checkout - SDD - Sign in - Add 1 SDD item to checkout and store address is in WA,Click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Set Test Variable  ${account_info["first_name"]}     autoui
    ...         AND    Login   ${login_slide_user["email"]}   ${login_slide_user["password"]}
    ...         AND    Maximize Browser Window
    ...         AND    Clear Cart
#    ${delivering_zipCode_shipping}  Set Variable  98008
#    ${login_slide_user1}      Create Dictionary      email=Guest               password=Password123
#    Set Test Variable   ${login_slide_user}    ${login_slide_user1}
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[1]}|1|ATC|SDD|Crossroads Bellevue,98008   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

7.PBF-Checkout-2stroe,2item qty:2-sdd-Sgin in-paper bag fee is $0.16
    [Documentation]  [CP-5693]Checkout - SDD - Sign in - Add 2 different item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Set Test Variable  ${account_info["first_name"]}     autoui
    ...         AND    Login   ${login_slide_user["email"]}   ${login_slide_user["password"]}
    ...         AND    Maximize Browser Window
    ...         AND    Clear Cart
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008
    ...    MIK|listing|${SDD[1]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

8.PBF-Checkout-2stroe,1item qty:2-sdd-Sgin in-paper bag fee is $0.16
    [Documentation]  [CP-5692]Checkout - SDD - Sign in - Add 2 same item from the different store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.16 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Set Test Variable  ${account_info["first_name"]}     autoui
    ...         AND    Login   ${login_slide_user["email"]}   ${login_slide_user["password"]}
    ...         AND    Maximize Browser Window
    ...         AND    Clear Cart
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008
    ...    MIK|listing|${SDD[0]}|1|ATC|SDD|SEA-KIRKLAND,98034   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.16

9.PBF-Checkout-1stroe,2item qty:2-sdd-Sgin in-paper bag fee is $0.08
    [Documentation]  [CP-5691]Checkout - SDD - Sign in - Add 2 different item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Set Test Variable  ${account_info["first_name"]}     autoui
    ...         AND    Login   ${login_slide_user["email"]}   ${login_slide_user["password"]}
    ...         AND    Maximize Browser Window
    ...         AND    Clear Cart
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|1|ATC|SDD|Crossroads Bellevue,98008
    ...    MIK|listing|${SDD[1]}|1|ATC|SDD|${empty}   Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08

10.PBF-Checkout-sdd-1stroe,1item qty:2-sdd-Sgin in-paper bag fee is $0.08
    [Documentation]  [CP-5690]Checkout - SDD - Sign in - Add 2 same item from the same store to checkout and store address is in WA,click [PROCEED TO CHECKOUT] button,paper bag fee is $0.08 on Getting your Order page and Payment & Order Review page
    [Tags]    full-run    yitest
    [Setup]   Run Keywords  Set Test Variable  ${account_info["first_name"]}     autoui
    ...         AND    Login   ${login_slide_user["email"]}   ${login_slide_user["password"]}
    ...         AND    Maximize Browser Window
    ...         AND    Clear Cart
    PBF-Guest-Sign in-checkout   MIK|listing|${SDD[0]}|2|ATC|SDD|Crossroads Bellevue,98008
    ...    Add To Cart   Credit Card   payment_order=false   Expect_Value=0.08


*** Keywords ***
#PBF-Guest-Sign in-checkout
#    [Arguments]    @{product_list}    ${payment_order}=true   ${Verfiy Point}=checkout   ${Expect_Value}=0
#    Select Products and Purchase Type-v2    ${product_list}
#    Payment process-v2    ${product_list[-2]}    ${product_list[-1]}     ${PRODUCT_INFO_LIST}    ${payment_order}
#    IF  "${Verfiy Point}"=="checkout"
#        Should Be Equal As Strings  ${checkout_order_sunnary_data["Paper Bag Fees"]}      ${Expect_Value}
#        Should Be Equal As Strings  ${payment_order_sunnary_data["Paper Bag Fees"]}       ${Expect_Value}
#    END



