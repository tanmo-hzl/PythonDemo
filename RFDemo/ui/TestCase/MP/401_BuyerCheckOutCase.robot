*** Settings ***
Resource            ../../Keywords/Mp/BuyerCheckoutKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerOrderHistoryKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
...                             AND    API - Seller Sign In And Get Order Info
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}    ?returnUrl=/cart
${User_Type}    cart
${Page_Name}    crt

*** Test Cases ***
Test Checkout By Different Listing and Quantity - Do Many Times
    [Documentation]    Buyer search lisitng and checkout, do many times
    [Tags]    mp    mp-buyer-ck    mp-rsc
    [Template]     Buyer Chekcout - Flow - Select Listing From Seller Store Front Then Checkout
    2    3
    2    5
    2    6
    3    5
    3    4
    3    6
    [Teardown]    Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}

Test Checkout Many Times By Template
    [Documentation]    Buyer search lisitng and checkout,do many time
    [Tags]    mp    mp-ea    mp-buyer-ck
    [Template]      Buyer Chekcout - Flow - Select Listing From Seller Store Front Then Checkout
    2    2
    2    3
    2    4
    3    2
    3    3
    3    4
    [Teardown]    Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}

Test Search And Save Order Number On First Page
    [Documentation]    Buyer search order and save it
    [Tags]    mp    mp-buyer-ck    mp-rsc
    Main Menu - Orders Page
    Buyer Left Menu - Orders & Purchases - Order History
    Buyer Order - Save Order Number On First Page    orders_buyer
    [Teardown]    Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}


