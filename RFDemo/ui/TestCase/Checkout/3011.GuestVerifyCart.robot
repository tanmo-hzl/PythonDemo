*** Settings ***
Resource          ../../Keywords/Checkout/Common.robot
Resource           ../../TestData/EnvData.robot
Resource          ../../Keywords/Checkout/VerifyCartKeywords.robot
Resource          ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Library           OperatingSystem
Library           ../../TestData/Checkout/GuestGenerateAddress.py


Suite Setup     Run Keywords   initial env data2
#Test Setup      Set Test Variable     &{account_info}      first_name=autoui

Test Teardown    Finalization Processment






*** Test Cases ***
6.Guest - Guest cart remove item
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest1
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later   remove

7.Guest - Guest cart item Remove and Save for Later
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Cart Verify Remove and Save for Later

7.1.Guest - Guest cart item Remove To Save for Later in message
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    ${save_item_name}     Cart Item To Save for Later
    Cart item remove Save for Later Message        ${save_item_name}

8.Guest - Guest cart Save for Later item remove
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    Cart Item To Save for Later
    Reload Page
    Close Cart Initiate Error popup
    Save for Later Verify Remove and Move to cart   remove

9.Guest - Guest cart Save for Later item remove to cart
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Close Cart Initiate Error popup
    Cart Item To Save for Later
    Reload Page
    Close Cart Initiate Error popup
    Save for Later Verify Remove and Move to cart

10.Guest - Guest cart remove all items
    [Documentation]    verifies the guest shopping cart,
    ...                 removes goods, adds them to save for later,
    ...                 and other operation information
    [Tags]   full-run    yitest
#    Environ Browser Selection And Setting   ${ENV}   Chrome  url=${url_mik}
    Open Browser   ${url_mik}   Chrome
    Add 4 items to shopping cart
    Remove all Items