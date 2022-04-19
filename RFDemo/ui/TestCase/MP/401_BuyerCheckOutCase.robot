*** Settings ***
Resource            ../../Keywords/Mp/BuyerCheckoutKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerOrderHistoryKeywords.robot
Resource            ../../Keywords/MP/EAInitialBuyerDataAPiKeywords.robot
Resource            ../../Keywords/MP/EAInitialSellerDataAPiKeywords.robot
Resource            ../../Keywords/MP/SellerMarketingKeywords.robot
Resource            ../../TestData/MP/BuyerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}    buyer
...                             AND   User Sign In - MP   ${BUYER_EMAIL}    ${BUYER_PWD}    ${BUYER_NAME}
...                             AND    API - Buyer Sign In
...                             AND    API - Seller Sign In
Suite Teardown      Close All Browsers


*** Variables ***
${Return_Url}    ?returnUrl=/cart
${User_Type}    cart
${Page_Name}    crt

*** Test Cases ***
Test Checkout EA Items By Api - Do Many Times
    [Documentation]    Checkout by api
    [Tags]    mp    mp-ea    ea-init-data
    [Template]    Flow - API - Place Order By Item Type
    1       2    NoItems=2    freeTax=${True}
    2       2    NeedItems=1        NoItems=1
    3       3    NeedItems=2
    4       3    NeedItems=3
    5       3    freeTax=${True}
    6       3    NoReturn=1         NeedItems=1         NoItems=1
    7       2    NoReturn=1         NoItems=1
    8       3    OverrideRate=2
    9       3    DefaultRate=2
    10      3    freeTax=${True}
    11      3
    12      3
    13      3

Test Checkout EA Items - Have Variants
    [Documentation]    Checkout product have variants
    [Tags]    mp    mp-ea    mp-buyer-ck    mp-rsc
    [Template]     Buyer Chekcout - Flow - Add Items To Cart On PDP Page Then Checkout
    2    3    ${True}
    [Teardown]    Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}

Test Checkout EA Items - No Variants
    [Documentation]    Checkout product no variants
    [Tags]    mp    mp-ea    mp-buyer-ck    mp-rsc
    [Template]      Buyer Chekcout - Flow - Add Items To Cart On PDP Page Then Checkout
    2    4    ${False}
    [Teardown]    Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}

Test Checkout EA Items - Have Promotion - Type 1
    [Documentation]    Checkout product have Promotion type 1
    [Tags]    mp    mp-ea    mp-buyer-ck-demo   mp-rsc
    Shipping Cart - Remove All Items From Cart If Existed
    Seller Marketing - Find Active Promotion Info By Promotion Type    1
    Seller Marketing - Get Cur Promotion Items Variants
    Seller Marketing - Go To Promotion Items PLP or PDP Page    PDP
    Product - Change Selected Variant By Sku Info     ${Unique_Discount_Sku}
    Product - Quantity Update On PDP    3
    Product - Add Item To Cart On PDP
    Go To    ${URL_MIK}/cart
    Checkout - Flow - Proceed To Payment To Place


Test Search And Save Order Number On First Page
    [Documentation]    Buyer search order and save it
    [Tags]    mp    mp-buyer-ck    mp-rsc
    Main Menu - Orders Page
    Buyer Left Menu - Orders & Purchases - Order History
    Buyer Order - Save Order Number On First Page    orders_buyer
    [Teardown]    Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}

