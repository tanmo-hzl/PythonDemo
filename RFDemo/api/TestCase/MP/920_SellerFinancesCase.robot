*** Settings ***
Resource            ../../Keywords/MP/SellerFinancesKeywords.robot

Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - Finances
Suite Teardown       Delete All Sessions

*** Variables ***


*** Test Cases ***
Test Update Store Profile
    [Tags]    ea    ea-demo2
#    Get Finances Balance - Get
#    Get Finances Bank Account - Get
#    Get Finances Order - Get
#    Update Bank Account - Patch
#    Update Text ModerateForm - Post
     Verify Profile - Post      #只能调一次
#     Finance Transaction Export - Get
#     Get StoreName And StoreId By useId - GET
#      Fin Pie - Get
#     Fin Wallet Add - Post
#     Usr Usps Verify - Post
#     Get Report List SellerDispute - Get
#     Get Balance Transaction - Get
#     Get Usr User Address - Get
#     Get Fin TaxStatement - Get
#     Update Bank Account - Patch

Test Get Finances Balance
    [Documentation]  query buyer finance balance
    [Tags]  mp-ea   ea-finance
    Get Finances Balance - Get

Test Get Finances Bank Account
    [Documentation]  query seller banck
    [Tags]  mp-ea  ea-finance
    Get Finances Bank Account - Get

Test Get Finance Wallet
    [Documentation]  query seller wallet
    [Tags]  mp-ea  ea-finance
    Get Finances Wallet - Get


Test Seller Add Credit Cards
    [Documentation]  seller add credit card
    [Tags]  mp-ea  ea-finance
    ${credit_cards}  Get Finances Wallet - Get
    FOR  ${credit_card}  IN  @{credit_cards}
        IF  ${credit_card["cardChannelType"]}==4
            ${bank_card_id}  Set Variable  ${credit_card["bankCardId"]}
            Delete Credit Card - DELETE  ${bank_card_id}
        END
    END
    Add Credit Cards - POST  card_number=6011016011016011     cvv=756   card_brand_type=DI

Test Seller Edit Credit Cards
    [Documentation]  seller edit credit card
    [Tags]  mp-ea  ea-finance
    ${credit_cards}  Get Finances Wallet - Get
    FOR  ${credit_card}  IN  @{credit_cards}
        ${bank_card_id}  Set Variable  ${credit_card["bankCardId"]}
        IF  ${bank_card_id}!=None
            Edit Credit Card - POST  ${bank_card_id}
            Exit For Loop
        ELSE
            Skip  Ther don't have credit card
        END
    END


Test Seller Delete Credit Card
    [Documentation]  sller delete credit card
    [Tags]  mp-ea  ea-finance
    ${credit_cards}  Get Finances Wallet - Get
    ${bank_card_id}  Get Json Value  ${credit_cards}  bankCardId
    IF  ${bank_card_id}!=None
        Delete Credit Card - DELETE  ${bank_card_id}
    ELSE
        Skip  There no credit card
    END


Test Get Finance Order Detail By Time
    [Documentation]  seller query order detail
    [Tags]  mp-ea  ea-finance
    Get Finance Order Detail - GET   start_data=2022-03-02   end_data=2022-03-11

Test Get Finance Order Detail By Status
    [Documentation]  seller query order detail
    [Tags]  mp-ea  ea-finance
    Get Finance Order Detail - GET   status=1,2,3

Test Get Finance Order Detail By Transaction Type
    [Documentation]  seller query order detail
    [Tags]  mp-ea  ea-finance
    Get Finance Order Detail - GET   transaction_type=3,1,2,6,5

#Test Get Finance Order Detail
#    [Tags]  mp-ea  ea-finance  kk
#    [Template]    Get Finance Order Detail - GET
#    start_data=2022-03-02   end_data=2022-03-11
#    status=1,2,3
#    transaction_type=3,1,2,6,5

Test Export Transction To Csv File
    [Documentation]  export transation to csv
    [Tags]  mp-ea  ea-finance
    Export Transction To Csv File - GET

Test Get User Address
    [Documentation]  query uer address
    [Tags]  mp-ea  ea-finance
    Get Usr User Address - Get

Test Get Balance Transaction
    [Documentation]  seller query balance transation
    [Tags]  mp-ea  ea-finance
    ${res_list}  Get Finance Order Detail - GET   status=1,2,3
    ${sellerTransactionId}  Get Json Value  ${res_list}  sellerTransactionId
    Get Balance Transaction - Get  ${sellerTransactionId}