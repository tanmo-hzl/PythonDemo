*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/Common/CartsKeywords.robot
Resource            ../../Keywords/Common/CheckoutKeywords.robot
Resource            ../../Keywords/MP/BuyerOrderHistoryKeywords.robot
Resource            ../../TestData/MP/ReturnData.robot
Suite Setup         Run Keywords   Initial Env Data    configReturn.ini
...                                AND    Open Browser With URL     ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL_RETURN}    ${BUYER_PWD_RETURN}    ${BUYER_NAME_RETURN}
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}    ?returnUrl=/cart
${Cur_User_Name}
${Login_Status}    PASS
${Repeat_Count}    9

*** Test Cases ***
Test Clear Shipping Cart And Buy All Items By Order Number
    [Documentation]  Clear shipping cart, enter order detail page then Buy All Items
    [Tags]    mp-ck-ea
    Shipping Cart - Remove All Items From Cart If Existed
    Main Menu - Orders Page
    Buyer Order - Flow - Search Order And Buyer All Agian     ${BUYER_PARENT_ORDER_NUMBER}

Test Checkout Items On Shipping Cart
    [Documentation]    After add item to shipping cart, checkout all of the items
    [Tags]    mp-ck-ea
    Shipping Cart - Enter Buyer Cart Page On Home Page
    Checkout - Flow - Proceed To Payment To Place

Test Checkout Items Repeatedly
    [Documentation]    After add item to shipping cart, checkout all of the items
    [Tags]    mp-ck-ea
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${Repeat_Count}
        Shipping Cart - Remove All Items From Cart If Existed
        Main Menu - Orders Page
        Buyer Order - Flow - Search Order And Buyer All Agian     ${BUYER_PARENT_ORDER_NUMBER}
        Shipping Cart - Enter Buyer Cart Page On Home Page
        Checkout - Flow - Proceed To Payment To Place
    END

Test Save Order Number On Order List
    [Documentation]    Save new order number which on list, quanity are Repeat_Count +1
    [Tags]    mp-ck-ea      mp-save-id
    Main Menu - Orders Page
    Buyer Order - Save Order Number On First Page    orders_buyer_re_ea