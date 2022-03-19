*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyMarketing.py
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot


*** Variables ***
${seller-account}
${seller_headers}
${seller_headers_post}
${seller_store_id}

*** Keywords ***
Set Initial Data - Marketing
    Mik Seller Sign In Scuse Of Order - POST    ${seller-account}
    ${seller_headers}    Set Get Headers - Seller
    Set Suite Variable    ${seller_headers}    ${seller_headers}
    ${seller_headers_post}    Set Post Headers - Seller
    Set Suite Variable    ${seller_headers_post}    ${seller_headers_post}
    ${seller_info_sign}    Set Variable     ${null}
    ${seller_info_sign}    Run Keyword If    '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
    Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}
    ${seller_store_id}    Get Json Value    ${seller_info_sign}    sellerStoreProfile    sellerStoreId
    Set Suite Variable    ${seller_store_id}    ${seller_store_id}

Get Seller Promotion Listing - GET
    ${param}  get_seller_promotion_param
    ${res}  Send Get Request  ${URL-MIK}  /mda/listings/${seller_store_id}/promotion   ${param}  ${seller_headers}
    [Return]   ${res.json()["data"]["listAll"]}

Create Promotion - Spend & Get - % Off - POST
    [Arguments]  ${skus}  ${status}
    ${body}  get_promotion_spend_get_off_body  ${skus}   ${status}
    Send Post Request - Params And Json   ${URL-MIK}   /mda/promotion/add   ${null}  ${body}  ${seller_headers_post}

Create Promotion - Spend & Get - % Amount Off - POST
    [Arguments]  ${skus}   ${status}
    ${body}  get_promotion_spend_get_amount_off_body  ${skus}   ${status}
    Send Post Request - Params And Json   ${URL-MIK}   /mda/promotion/add   ${null}  ${body}  ${seller_headers_post}

Create Promotion - Buy & Get - % Off - POST
    [Arguments]  ${skus}  ${status}
    ${body}  get_promotion_buy_get_off_body  ${skus}  ${status}
    Send Post Request - Params And Json   ${URL-MIK}   /mda/promotion/add   ${null}  ${body}  ${seller_headers_post}

Create Promotion - Buy A Get B Free - POST
    [Arguments]  ${skus}  ${status}
    ${body}  get_promotion_buy_A_get_B_free_body  ${skus}  ${status}
    Send Post Request - Params And Json   ${URL-MIK}   /mda/promotion/add   ${null}  ${body}  ${seller_headers_post}

Create Promotion - Percent Off - POST
    [Arguments]  ${skus}  ${status}
    ${body}  get_promotion_percent_off_body  ${skus}  ${status}
    Send Post Request - Params And Json   ${URL-MIK}   /mda/promotion/add   ${null}  ${body}  ${seller_headers_post}

Create Promotion - BMSM Off - POST
    [Arguments]  ${skus}  ${status}
    ${body}  get_promotion_BMSM_off_body  ${skus}  ${status}
    Send Post Request - Params And Json   ${URL-MIK}   /mda/promotion/add   ${null}  ${body}  ${seller_headers_post}

Get Promotion List - POST
    [Arguments]  ${filter_condition}
    ${body}  get_promotion_list_body  ${filter_condition}
    ${res}    Send Post Request - Params And Json  ${URL-MIK}   /mda/promotion/list   ${null}  ${body}  ${seller_headers_post}
    [Return]  ${res.json()["data"]["content"]}

Seller Stop Promotion - POST
    [Arguments]  ${promotion_id}
    Send Post Request  ${URL-MIK}   /mda/promotion/stop/${promotion_id}  ${null}  ${seller_headers_post}

Seller Delete Promotion - DELETE
    [Arguments]  ${promotion_id}
    Send Delete Request  ${URL-MIK}   /mda/promotion/delete/${promotion_id}  ${null}  ${seller_headers_post}

Seller Publish Promotion - PUT
    [Arguments]   ${body}
    Send Put Request  ${URL-MIK}   /mda/promotion/update    ${body}   ${seller_headers_post}
