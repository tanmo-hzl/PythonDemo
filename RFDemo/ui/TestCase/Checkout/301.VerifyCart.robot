*** Settings ***
Resource          ../../Keywords/Checkout/Common.robot
Resource           ../../TestData/EnvData.robot
Resource          ../../Keywords/Checkout/VerifyCartKeywords.robot
Resource          ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Library           OperatingSystem
Library           ../../TestData/Checkout/GuestGenerateAddress.py


Suite Setup     Run Keywords   initial env data2
Test Setup      Set Test Variable     &{account_info}      first_name=autoui

Test Teardown    Finalization Processment

*** Variables ***
${TEST ENV}     ${ENV}
${Initial Store Name}       Glade Parks
${Multiple Store}           Multiple pickup location are selected in this order:
${Range}                    200
${Store Name Set}           Not Set
${Multiple Store Address}   Not Set
${Paypay Amount}            Intital Paypal Amount Setting
&{buyer1}    user=autoCpmUi2@xxxhi.cc    password=Password123
@{product_list}         product/elmers-foam-board-white-10110205
...                     product/impeccable-solid-yarn-by-loops-threads-10108918
...                     product/4-glue-sticks-by-artminds-10203512
...                     product/candle-warmer-by-ashland-basic-elements-10313465
...                     product/gildan-short-sleeve-adult-tshirt-10532374




*** Test Cases ***
1.Buyer - Buyer cart remove item
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest     multi-user
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    Cart Verify Remove and Save for Later   remove
    
2.Buyer - Buyer cart item remove to save for later
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later

2.1 Buyer - Buyer cart item remove To save for later in message
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    ${save_item_name}  Cart Item To Save for Later
    Cart item remove Save for Later Message   ${save_item_name}

3.Buyer - Buyer cart is save for later remove item
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    Cart Item To Save for Later
    Reload Page
    Close Cart Initiate Error popup
    Save for Later Verify Remove and Move to cart   remove
      
4.Buyer - Buyer cart save for later item to cart
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    Cart Item To Save for Later
    Reload Page
    Close Cart Initiate Error popup
    Save for Later Verify Remove and Move to cart

5.Buyer - Buyer cart remove all items
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    Remove all Items

11.[EA] - Remove item from shopping cart successfully
    [Documentation]   EA] - Remove - Remove item from shopping cart successfully,
    ...         and pop out a alert message for XXX was removed from Shopping Cart.
    [Tags]  full-run    yitest
    Open Browser   ${URL_MIK}    chrome
    Maximize Browser Window
    ${product_list}     Create List      MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    cread card        info
    Select Products and Purchase Type       ${product_list}
    Click View My Cart Button
    Cart Verify Remove and Save for Later   remove

12.[EA] - Clicking 'save for later' EA item will remove from cart
    [Documentation]   [EA] - Save for later - Clicking 'save for later EA item will remove from cart,
    ...               and pop out the message window
    [Tags]   full-run    yitest
    Open Browser   ${URL_MIK}    chrome
    Maximize Browser Window
    ${product_list}     Create List      MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    cread card        info
    Select Products and Purchase Type       ${product_list}
    Click View My Cart Button
    ${save_item_name}    Cart Verify Remove and Save for Later
    Cart item remove Save for Later Message    ${save_item_name}

13.[EA] - Remove item from save for later successfully?
    [Documentation]    [EA] - Remove - Remove item from save for later successfully,
    ...          and pop out a alert message for XXX was removed from Shopping Cart.
    [Tags]   full-run    yitest
    Open Browser   ${URL_MIK}    chrome
    Login    ${buyer1.user}     ${buyer1.password}
    Maximize Browser Window
    Clear Cart
    initial save for later list remove all item
    ${product_list}     Create List      MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    Add To Cart    Credit Card
    Select Products and Purchase Type       ${product_list}
    Click View My Cart Button
    Close Cart Initiate Error popup
    Cart Item To Save for Later
    Reload Page
    Close Cart Initiate Error popup
    Save for Later Verify Remove and Move to cart    remove

14.[EA] - ShoppingCart - Click '+' button ordersummary info is correct
    [Documentation]   [EA] - ShoppingCart - Click '+' or '-' button,
    ...     EA item's quatity should  +1 or -1 in the shopping cart page,
    ...                 and the ordersummary info is correct
    [Tags]     full-run     yitest1
    Open Browser   ${URL_MIK}    chrome
    Login    ${buyer1.user}     ${buyer1.password}
    Clear Cart
#    initial save for later list remove all item
    ${product_list}     Create List      MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    Add To Cart    Credit Card
    Select Products and Purchase Type       ${product_list}
    Click View My Cart Button
    ${update_quatity_item_name}  Set Variable    ${PRODUCT_INFO_LIST[0]["product_name"]}
    ${before_value}    cart page input number update item quatity   ${update_quatity_item_name}
    ${data2}    get order summary data
    cart page click + update item quatity   ${update_quatity_item_name}
    ${after_value}    cart page input number update item quatity   ${update_quatity_item_name}
    ${after_value}  Evaluate   ${after_value}-${1}
    Should Be Equal As Numbers   ${before_value}    ${after_value}
    ${data3}    get order summary data
    ${count_item}  Evaluate   ${data3["item_count"]}-${1}
    Should Be Equal As Numbers    ${count_item}     ${data2["item_count"]}

15.[EA] - ShoppingCart - Click '-' button ordersummary info is correct
    [Documentation]   [EA] - ShoppingCart - Click  '-' button,
    ...     EA item's quatity should  -1 in the shopping cart page,
    ...                 and the ordersummary info is correct
    [Tags]     full-run      yitest
    Open Browser   ${URL_MIK}    chrome
    Login    ${buyer1.user}     ${buyer1.password}
    Clear Cart
#    initial save for later list remove all item
    ${product_list}     Create List      MKP|listing|${MKP[1]}|2|ATC||${EMPTY}    Add To Cart    Credit Card
    Select Products and Purchase Type       ${product_list}
    Click View My Cart Button
    ${update_quatity_item_name}  Set Variable    ${PRODUCT_INFO_LIST[0]["product_name"]}
    ${before_value}    cart page input number update item quatity   ${update_quatity_item_name}
    ${data2}    get order summary data
    cart page click - update item quatity   ${update_quatity_item_name}
    ${after_value}    cart page input number update item quatity   ${update_quatity_item_name}
    ${after_value}  Evaluate   ${after_value}+${1}
    Should Be Equal As Numbers   ${before_value}    ${after_value}
    ${data3}    get order summary data
    ${count_item}  Evaluate   ${data3["item_count"]}+${1}
    Should Be Equal As Numbers    ${count_item}     ${data2["item_count"]}


*** Keywords ***
