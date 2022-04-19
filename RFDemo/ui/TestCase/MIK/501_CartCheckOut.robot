*** Settings ***
Documentation       This is to Add Shopping Cart
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../Keywords/Common/MikCommonKeywords.robot
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/CartAndOrder.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK_SIGNIN}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Variables ***
${item_len}

*** Test Cases ***
Test Remove All Shopping Cart
    [Documentation]   Remove All Shopping Cart
    [Tags]  mik  mik-CartCheckOut  mik-RemoveAllShoppingCart  mik-dev
    Sign in  ${checkout_email}  ${checkout_pwd}
    Remove All Shopping Cart

Test Add Shopping Cart
    [Documentation]   Add Shopping Cart
    [Tags]  mik  mik-CartCheckOut  mik-AddCart  mik-dev
    ${Add_cart_item}  Create Dictionary  ${search_result}=1
    ${item_len}       Get Length  ${Add_cart_item}
    Set Suite Variable  ${item_len}
    FOR  ${item}  ${num}  IN  &{Add_cart_item}
        Search Project       ${item}
        Verify PLP          ${item}
        Add Shopping Cart   ${num}
    END

Test Verify Shopping Cart
    [Documentation]   Verify Shopping Cart
    [Tags]  mik  mik-CartCheckOut  mik-VerifyCart  mik-dev
    Verify Shopping Cart info  ${item_len}

Test Verify Save for Later
    [Documentation]   Verify Save for Later
    [Tags]  mik  mik-CartCheckOut  mik-SaveforLater  mik-dev
    Save for Later

Test Check Out
    [Documentation]    Check Out
    [Tags]  mik  mik-CartCheckOut  mik-CheckOut  mik-dev
    Check Out

Test Verify Order History
    [Documentation]   Verify Order History
    [Tags]  mik  mik-CartCheckOut  mik-VerifyOrderHistory  mik-dev
    Go To personal information  Orders  summer
    ${order_history}  Get Element Count  //h3[contains(text(),'There are no orders to display')]
    IF  '${order_history}'=='0'
        Verify Order History
        Order History screening condition  20220221  20220222  All Time  Date - Most Recent to Oldest
        Order History View Details
    ELSE
        Log  Not Order History
    END