*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/Common/CartsKeywords.robot
Resource            ../../Keywords/Common/CheckoutKeywords.robot
Resource            ../../Keywords/MP/BuyerOrderHistoryKeywords.robot
Resource            ../../TestData/MP/ReturnData.robot
Suite Setup         Run Keyword   Initial Data And Open Browser   ${URL_MIK}    buyer
#...                                AND    Open Browser - MP    seller
Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS
${Repeat_Count}    2

*** Test Cases ***
Test Buyer Sign In
    [Documentation]    Buyer Sign In
    [Tags]    mp   mp-checkout  mp-save-id  mp-checkout-paypal
    Switch Browser    buyer
    Set Suite Variable    ${Cur_User_Name}    ${BUYER_NAME_RETURN}
    User Sign In - MP    ${BUYER_EMAIL_RETURN}    ${BUYER_PWD_RETURN}    ${Cur_User_Name}
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Clear Shipping Cart And Buy All Items By Order Number
    [Documentation]  Clear shipping cart, enter order detail page then Buy All Items
    [Tags]    mp   mp-checkout
    Enter Buyer Cart Page On Home Page
    Remove All Items From Cart If Existed
    Main Menu - Orders Page
    Buyer Order - Flow - Search Order And Buyer All Agian     ${BUYER_PARENT_ORDER_NUMBER}

Test Checkout Items On Shipping Cart
    [Documentation]    After add item to shipping cart, checkout all of the items
    [Tags]    mp   mp-checkout
    Enter Buyer Cart Page On Home Page
    Checkout - Flow - Proceed To Payment To Place

Test Checkout Items Repeatedly
    [Documentation]    After add item to shipping cart, checkout all of the items
    [Tags]    mp   mp-checkout
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${Repeat_Count}
        Enter Buyer Cart Page On Home Page
        Remove All Items From Cart If Existed
        Main Menu - Orders Page
        Buyer Order - Flow - Search Order And Buyer All Agian     ${BUYER_PARENT_ORDER_NUMBER}
        Enter Buyer Cart Page On Home Page
        Checkout - Flow - Proceed To Payment To Place
    END

Test Save Order Number On Order List
    [Documentation]    Save new order number which on list, quanity are Repeat_Count +1
    [Tags]    mp   mp-checkout      mp-save-id
    Main Menu - Orders Page
    ${id_list}    Create List
    ${new_count}    Evaluate    ${Repeat_Count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${new_count}
        ${order_id}    Get Text    (//button[starts-with(@class,"chakra-button")]/div/div[1]//p[text()="Order Number"]/following-sibling::p)[${index}]
        Append To List    ${id_list}    ${order_id}
    END
    Save File    return_order_ids    ${id_list}    MP

Test Checkout By Payment - PayPal
    [Documentation]    Buyer checkout by payment paypal
    [Tags]    mp-checkout-paypal
    Enter Buyer Cart Page On Home Page
    Checkout - Click Button - Proceed To Checkout
    Checkout - Click Button - Payment & Order Review
    Checkout - Selected Payment Method - Paypal
    Checkout - Click Button - PayPal
    Checkout - Switch To PayPal Browser