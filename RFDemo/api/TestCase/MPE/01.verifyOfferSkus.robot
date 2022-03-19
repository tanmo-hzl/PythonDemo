*** Settings ***
Resource  ../../Keywords/MPE/OfferApiKeywords.robot
Resource  ../../Keywords/MPE/promotionKeywords.robot
Resource  ../../TestData/MPE/ItemData.robot
#Resource  ../../Keywords/MPE/applyVerifyKeyWords.robot
Resource  ../../Keywords/MPE/Ppakeywords.robot
Library   ../../Libraries/MPE/GetPromotionCouponBody.py


*** Variables ***


*** Test Cases ***
verify offer sku interface
    [Documentation]     Verify that the promotion item cannot exist 22madebyyou
    [Tags]  mpe
    ${sku_list_str}     set variable    10556685,10595703,10595704
    ${sku_offer_res}    get offer skus      ${sku_list_str}
    Should Be Equal As Strings      200     ${sku_offer_res.status_code}
    Verify Offer_sku sku number     ${sku_offer_res}    ${sku_list_str}
    Verify Offer_sku Not Contain 22MADEBYYOU    ${sku_offer_res}    ${sku_list_str}

verify regular item offer sku
    [Documentation]
    [Tags]  mpe
    ${regular_item}    get env item     ${ENV}
    ${sku_offer_res}    get offer skus      ${regular_item[0]}
    Verify Offer_sku sku number     ${sku_offer_res}    ${regular_item[0]}
    Verify Offer_sku in Contain 22MADEBYYOU     ${sku_offer_res}    ${regular_item[0]}

verify great buy item offer sku
    [Documentation]
    [Tags]  mpe
    ${great_buy_item}    get env item     ${ENV}    great_buy_item
    ${sku_offer_res}    get offer skus      ${great_buy_item[0]}
    Verify Offer_sku sku number     ${sku_offer_res}    ${great_buy_item[0]}
    Verify Offer_sku offer is null     ${sku_offer_res}    ${great_buy_item[0]}

verify clearance item offer sku
    [Documentation]
    [Tags]  mpe
    ${clearance_item}    get env item     ${ENV}    clearance_item
    ${sku_offer_res}    get offer skus      ${clearance_item[0]}
    Verify Offer_sku sku number     ${sku_offer_res}    ${clearance_item[0]}
    Verify Offer_sku Not Contain 22MADEBYYOU     ${sku_offer_res}    ${clearance_item[0]}    1


verify promotion item offer sku
    [Tags]  mpe
    ${prduct_group_list}  get product group be get promotion List
    FOR  ${prduct_group_id}   IN   @{prduct_group_list}
        ${sku_list}    get sku be Get Group    ${prduct_group_id}
        ${sku_number}   Get Length  ${sku_list}
        IF  ${sku_number}>0
            Exit For Loop
        END
    END
    ${sku_offer_res}    get offer skus      ${sku_list[0]}
    Verify Offer_sku sku number     ${sku_offer_res}    ${sku_list[0]}
    Verify Offer_sku Not Contain 22MADEBYYOU    ${sku_offer_res}    ${sku_list[0]}

verify non_discount item offer sku
    [Tags]  mpe
    ${sku_index}    Set Variable   13
    ${promotion_res}    get promotion id information
    ${product_group_id}     Set Variable   ${promotion_res.json()["data"]["productRestriction"][0]["value"]}
    ${sku_list}       get sku be Get Group    ${product_group_id}
    ${sku_offer_res}    get offer skus      ${sku_list[${sku_index}]}
    Verify Offer_sku sku number     ${sku_offer_res}    ${sku_list[${sku_index}]}
    Verify Offer_sku offer is null     ${sku_offer_res}    ${sku_list[${sku_index}]}

verify post promotion top
    [Tags]  mpe
    ${top_res}   post promotion top
    IF  "${top_res['message']}"!="operation success!"
        Fail   ${top_res["data"]}
    ELSE
        Log  ${top_res["data"]}
    END

verify save group maapping is product group
    [Tags]
    ${product_group_id}     Set Variable    1111111
    ${product_group_body}   get_group_mapping_body   items=1234,3456    product_group_id=${product_group_id}
    ${product_group_res}    post save group mapping     ${product_group_body}
    ${get_group_res}    get group id information   ${product_group_id}
    Should Be Equal As Numbers    ${get_group_res.json()["data"]["entityGroupId"]}    ${product_group_id}

verify save group maapping is product group
    [Tags]   mpe
    ${store_group_id}     Set Variable    1111112
    ${store_group_body}   get_group_mapping_body   stores=1234,3456    store_group_id=${store_group_id}
    ${store_group_res}    post save group mapping     ${store_group_body}
    ${get_group_res}    get group id information   ${store_group_id}
    Should Be Equal As Numbers    ${get_group_res.json()["data"]["entityGroupId"]}    ${store_group_id}







