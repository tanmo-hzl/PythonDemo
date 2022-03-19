*** Settings ***
Documentation     Test Suite For smoke Checkout Tests Flow
Resource          ../../Keywords/Checkout/Common.robot
Resource           ../../TestData/EnvData.robot
Resource          ../../Keywords/Checkout/VerifyCartKeywords.robot
Resource          ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Library           OperatingSystem
Library           ../../TestData/Checkout/GuestGenerateAddress.py
#Resource    ../../Keywords/Checkout/CommonKeywords.robot
#Suite Setup     set selenium timeout    ${TIME_OUT}
Suite Setup     Run Keywords   initial env data2

Test Teardown    Finalization Processment

*** Variables ***
${TEST ENV}     ${ENV}
${Initial Store Name}       Glade Parks
${Multiple Store}           Multiple pickup location are selected in this order:
${Range}                    200
${Store Name Set}           Not Set
${Multiple Store Address}   Not Set
${Paypay Amount}            Intital Paypal Amount Setting
&{buyer1}    user=autoCpmUi1@xxxhi.cc    password=Password123
@{product_list}         product/elmers-foam-board-white-10110205
...                     product/impeccable-solid-yarn-by-loops-threads-10108918
...                     product/4-glue-sticks-by-artminds-10203512
...                     product/candle-warmer-by-ashland-basic-elements-10313465
...                     product/gildan-short-sleeve-adult-tshirt-10532374




*** Test Cases ***
Buyer - Buyer cart remove item
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later   remove
    
Buyer - Buyer cart item remove to save for later
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later

Buyer - Buyer cart is save for later remove item
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later
    Save for Later Verify Remove and Move to cart   remove
      
Buyer - Buyer cart save for later item to cart
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later
    Save for Later Verify Remove and Move to cart

Buyer - Buyer cart remove all items
    [Documentation]    The user logs in, verifies the user's shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
    Login    ${buyer1.user}     ${buyer1.password}
    Add 4 items to shopping cart
    Remove all Items

Guest - Guest cart remove item
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later   remove

Guest - Guest cart item Remove and Save for Later
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later

Guest - Guest cart Save for Later item remove
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later
    Save for Later Verify Remove and Move to cart   remove

Guest - Guest cart Save for Later item remove to cart
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later
    Save for Later Verify Remove and Move to cart

Guest - Guest cart remove all items
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Remove all Items

[EA] - Remove item from shopping cart successfully
    [Documentation]   EA] - Remove - Remove item from shopping cart successfully,
    ...         and pop out a alert message for XXX was removed from Shopping Cart.
    [Tags]  full-run    yitest
    Open Browser   ${URL_MIK}    chrome
    Maximize Browser Window
    ${product_list}     Create List      MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    cread card        info
    Select Products and Purchase Type       ${product_list}
    Click View My Cart Button
    Cart Verify Remove and Save for Later   remove

[EA] - Clicking 'save for later' EA item will remove from cart
    [Documentation]   [EA] - Save for later - Clicking 'save for later EA item will remove from cart,
    ...               and pop out the message window
    [Tags]   full-run    yitest
    Open Browser   ${URL_MIK}    chrome
    Maximize Browser Window
    ${product_list}     Create List      MKP|listing|${MKP[1]}|1|ATC||${EMPTY}    cread card        info
    Select Products and Purchase Type       ${product_list}
    Click View My Cart Button
    Cart Verify Remove and Save for Later

[EA] - Remove item from save for later successfully?
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
    Cart Verify Remove and Save for Later
    Save for Later Verify Remove and Move to cart    remove

[EA] - ShoppingCart - Click '+' button ordersummary info is correct
    [Documentation]   [EA] - ShoppingCart - Click '+' or '-' button,
    ...     EA item's quatity should  +1 or -1 in the shopping cart page,
    ...                 and the ordersummary info is correct
    [Tags]     full-run     yitest
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

[EA] - ShoppingCart - Click '-' button ordersummary info is correct
    [Documentation]   [EA] - ShoppingCart - Click  '-' button,
    ...     EA item's quatity should  -1 in the shopping cart page,
    ...                 and the ordersummary info is correct
    [Tags]     fun-run      yitest1
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
Add 4 items to shopping cart
    [Arguments]     ${product_list}=${product_list}     ${number}=4
#    Reload Page
    Maximize Browser Window
    go to   ${URL_MIK}/${product_list[${0}]}
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    Sleep  1
    AD Exception Handle-element visible  //div[text()="ADD TO CART"]
    AD Exception Handle   //div[text()="ADD TO CART"]
    Sleep  1
    AD Exception Handle-element visible  //div[text()="View My Cart"]
    AD Exception Handle   //div[text()="View My Cart"]
    Remove all Items
    FOR  ${i}  IN RANGE  ${number}
        Sleep  1
        go to   ${URL_MIK}/${product_list[${i}]}
        Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
        Sleep  1
        AD Exception Handle-element visible  //div[text()="ADD TO CART"]
        AD Exception Handle   //div[text()="ADD TO CART"]
        Sleep  1
        AD Exception Handle-element visible  //div[text()="View My Cart"]
    END
    AD Exception Handle-element visible  //div[text()="View My Cart"]
    Sleep  1
    AD Exception Handle   //div[text()="View My Cart"]
    initial save for later list remove all item



#    [Arguments]    ${Channel Mode}   ${Items}   ${Qty}   ${Payment}    ${Store Amount}=1
#    ${Address Collection}   Create List
#    ${Qty Processed}        Qty Process     ${Qty}
#    ${IF PIS}               If Pick Only    ${Channel Mode}
#    ${IF MKR}               If Mkr Only     ${Channel Mode}
#    ${Items Count}          Calculate Items Count       ${Items}
##    ${Store Selection Needed}    Select Store Process   ${Channel Mode}
##
##    ${Store Address}   Select Store If Needed
##    ${Refined Store Address}        Convert Store Address To Regular Space     ${Store Address}
#    ${Product Channel Info}         Items Channel Dictionary Creation          ${Channel Mode}   ${Items}   ${TEST ENV}
#    ${Sku List}   ${Partial Urls}   Split Skus From Partial Url                ${Product Channel Info}
#
#    ${Shipping Info}   ${Class Set Qty}   ${Multiple Store Address}    Add Products To Cart Process
#    ...   ${Product Channel Info}    ${Qty Processed}    ${Store Amount}
#
#    ${Handle AD Pop}   Run Keyword And Warn On Failure     AD Exception Handle      //div[text()='View My Cart']
#    sleep   1

login
    [Arguments]    ${user}    ${password}
    Open Browser   ${url_mik}    ${browser}
    Maximize Browser Window
#    Reload Page
    Go To   ${URL_MIK_SIGNIN}
    AD Exception Handle-element visible   //p[text()="Sign In"]
    AD Exception Handle-element visible   //p[text()="Remember me"]
    Wait Until Element Is Enabled    //input[@id="email"]
    AD Exception Handle    //input[@id="email"]
    input text    //input[@id="email"]    ${user}
    AD Exception Handle    //input[@id="password"]
    input text    //input[@id="password"]   ${password}
    AD Exception Handle   //div[text()="SIGN IN"]/parent::button
    Sleep    2
#    Wait Until Page Does Not Contain Element     //div[text()="SIGN IN"]/parent::button
#    Wait Until Page Contains Element    //p[text()="${account_info["first_name"]}"]     ${Long Waiting Time}