*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodySellerFinances.py
Resource            ../../TestData/MP/PathSellerFinances.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller_headers}
${seller_headers_post}
${seller_info_sign}
${seller_store_id}
${seller-account}
${variant_contents}
${seller_user_id}

*** Keywords ***
Set Initial Data - Finances
    Mik Seller Sign In Scuse Of Order - POST    ${seller-account}
        ${seller_headers}    Set Get Headers - Seller
        Set Suite Variable    ${seller_headers}    ${seller_headers}
        ${seller_headers_post}    Set Post Headers - Seller
        Set Suite Variable    ${seller_headers_post}    ${seller_headers_post}
        ${seller_info_sign}    Set Variable     ${null}
        ${seller_info_sign}    Run Keyword If    '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
        Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}
        ${seller_store_id}    Get Json Value    ${seller_info_sign}    sellerStoreProfile    sellerStoreId
        ${seller_user_id}     get json value    ${seller_info_sign}    user    id
        Set Suite Variable    ${seller_store_id}    ${seller_store_id}
        Set Suite Variable    ${seller_user_id}     ${seller_user_id}


Get StoreName And StoreId By useId - GET
    ${res}    send get request    ${url-mik}    ${mda-store}/${mda-storeName-storeId-by-userId}    ${NULL}   ${seller_headers}
    ${storeId}    get json value    ${res.json()}    storeId
    [Return]    ${storeId}

Get Finances Balance - Get
   ${res}    Send Get Request     ${url-mik}    ${mda-store}/${seller_store_id}/${finance-balance}    ${NULL}    ${seller_headers}

Get Finances Bank Account - Get
    ${res}    send get request    ${url-mik}    ${mda-store}/${seller_store_id}/${finance-bank-account}   ${NULL}   ${seller_headers}

Get Finances Order - Get
    ${body}    create dictionary    pageNumber=0    pageSize=5
    ${res}    send get request    ${url-mik}    ${mda-store}/${seller_store_id}/${finance-order}   ${body}    ${seller_headers}

Update Bank Account - Patch
    ${body}    update bank account body    ${seller_store_id}
    ${res}    send patch request    ${url-mik}    ${mda-store}/${seller_store_id}/${finance-update-bank-account}    ${body}   ${seller_headers_post}

Update Text ModerateForm - Post
    ${body}   update text moderateForm body
    ${res}    send post request    ${url-mik}    ${finance-text-moderateForm}    ${body}   ${seller_headers_post}

Verify Profile - Post
    ${body}   verify profile body
    ${res}    send post request    ${url-mik}     ${mda-store}/${finance-profile-verify}    ${body}   ${seller_headers_post}

Usr Usps Verify - Post
    ${body}   usr usps verify body
    ${res}    send post request    ${url-mik}    ${usr-usps-verify}    ${body}   ${seller_headers_post}

Get Finances Wallet - Get
    ${body}    create dictionary    userId=${seller_user_id}
    ${res}    send get request    ${url-mik}    ${mda-store}/${seller_store_id}/${finance-finance-wallet}   ${body}    ${seller_headers}
    [Return]  ${res.json()}

Finance Transaction Export - Get
    ${res}    send get request    ${url-mik}    ${mda-store}/${seller_store_id}/${finance-transaction-export}   ${NULL}    ${seller_headers}

Fin Pie - Get
    ${res}    send get request    ${url-mik}    ${fin-pie}   ${NULL}    ${seller_headers}

Fin Wallet Add - Post
    ${body}    fin Wallet add body    ${seller_user_id}
    ${res}    send post request    ${url-mik}    ${fin-wallet-add}   ${NULL}    ${seller_headers_post}

Get Report List SellerDispute - Get
    ${body}    create dictionary    targetId=10756323646930950
    ${res}    send get request    ${url-mik}    ${report-list-getSellerDispute}   ${body}    ${seller_headers}

Get Balance Transaction - Get
    [Arguments]  ${sellerTransactionId}
    ${body}    create dictionary    sellerTransactionId=${sellerTransactionId}
    ${res}    send get request    ${url-mik}    ${mda-store}/${seller_store_id}/${finance-balance-transaction}   ${body}    ${seller_headers}

Get Usr User Address - Get
    ${res}    send get request    ${url-mik}    ${usr-user-address}   ${NULL}    ${seller_headers}

Get Fin TaxStatement - Get
    ${body}    create dictionary    filePath=taxStatement1099K/    sellerStoreId=${seller_store_id}
    ${res}    send get request    ${url-mik}    ${fin-taxStatement}   ${body}    ${seller_headers}

Get Finance Order Detail - GET
    [Arguments]  ${start_data}=${null}   ${end_data}=${null}  ${status}=${null}  ${transaction_type}=${null}
    ${param}  get_finance_order_detail_param  ${start_data}   ${end_data}  ${status}  ${transaction_type}
    ${res}  Send Get Request  ${URL-MIK}  /mda/store/${seller_store_id}/finance/order/detail  ${param}   ${seller_headers}
    [Return]   ${res.json()["sellerBalanceOrderDetailsResponseList"]}

Add Credit Cards - POST
    [Arguments]   ${card_number}   ${cvv}  ${card_brand_type}
    ${body}    get_add_credit_card_body   ${card_number}   ${cvv}   ${card_brand_type}  ${seller_user_id}
    ${res}    Send Post Request   ${URL-MIK}    /fin/wallet/add   ${body}     ${seller_headers_post}

Delete Credit Card - DELETE
    [Arguments]  ${bank_card_id}
    ${param}  Create Dictionary   bankCardId=${bank_card_id}  userId=${seller_user_id}
    Send Delete Request - Params   ${URL-MIK}   /mda/store/${seller_store_id}/finance/wallet/delete   ${param}   ${seller_headers_post}

Edit Credit Card - POST
    [Arguments]  ${bank_card_id}
    ${body}  get_edit_credit_card_body  ${bank_card_id}  ${seller_user_id}
    Send Post Request  ${URL-MIK}  /fin/wallet/update  ${body}  ${seller_headers_post}

Export Transction To Csv File - GET
    ${param}  get_export_transaction_to_csv_param
    Send Get Request  ${URL-MIK}  /mda/store/${seller_store_id}/finance/transaction/export  ${param}  ${seller_headers}

