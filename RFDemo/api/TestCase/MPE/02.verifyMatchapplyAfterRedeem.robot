*** Settings ***
Resource  ../../Keywords/MPE/OfferApiKeywords.robot
Resource  ../../Keywords/MPE/promotionKeywords.robot
Resource  ../../TestData/MPE/ItemData.robot
Resource  ../../Keywords/MPE/applyVerifyKeyWords.robot
Library   ../../Libraries/MPE/GetPromotionCouponBody.py


*** Test Cases ***
verify serialized coupon match apply apply redeem ,km status
    [Tags]  mpe
    ${serialized}      get serialized coupon list
    ${serialized_index}         Set Variable   0
    ${serialized_code}   Set Variable   ${serialized[${serialized_index}]["code"]}
    ${codes}        Create Dictionary   codes=${serialized_code}
    ${body}     get_match_apply_body   ${codes}
    ${match_apply_res}    Post matchApply Response   ${body}
    ${coupon_id}    Set Variable    ${match_apply_res.json()["data"]["promotionInfos"][0]["instanceId"]}
    ${coupon_res}    get coupon ids information    ${coupon_id}
    Log  ${coupon_res.json()}
    Should Be Equal As Numbers  ${coupon_res.json()["data"][0]["status"]}   1
    ${km_long_code_res}     get longcode km   ${serialized_code}
    IF  ${km_long_code_res.json()["code"]}==200
        ${km_long_code}   Set Variable   ${km_long_code_res.json()["data"]["associatedCodes"][0]["value"]}
        ${ams_res}        get lookup coupon ams   ${km_long_code}
        ${ams_data1}     get_lockup_coupon_kms_data  ${ams_res["data"]}
    END

    ${redeem_body}   Post redeem     ${match_apply_res.json()["data"]}
    ${coupon_res}    get coupon ids information    ${coupon_id}
    Log  ${coupon_res.json()}
    Should Be Equal As Numbers  ${coupon_res.json()["data"][0]["status"]}   4
    IF  ${km_long_code_res.json()["code"]}==200
        IF  ${ams_data1["status_code"]}!=0
            ${ams_res}       get lookup coupon ams   ${km_long_code}
            ${ams_data2}     get_lockup_coupon_kms_data  ${ams_res["data"]}
            ${ams_remaining_uses}   Set Variable   ${ams_data2["remaining_uses"]}
            ${ams_remaining_uses1}  Evaluate   ${ams_remaining_uses}+${1}
            Should Be Equal As Numbers   ${ams_remaining_uses1}     ${ams_data1["remaining_uses"]}
        END
    END
verify great buy item apply entire coupon matchapply
    [Tags]   mpe    test6
    item in coupon matchapply   codes=zyx2022666entire20    expect1=8.0

verify great buy item apply 22MADEBYYOU coupon matchapply
    [Tags]   mpe    test6
    item in coupon matchapply    expect1=8.0


verify great buy item apply ERPP coupon matchapply
    [Tags]   mpe    test6
    item in coupon matchapply     codes=zyx2022666erpp20    expect1=8.0

verify great buy item apply Aorpi coupon matchapply
    [Tags]   mpe    test6 
    item in coupon matchapply     codes=zyx2022666aorpi20    expect1=4.0

verify great buy item apply spend&get coupon matchapply
    [Tags]   mpe    test6  
    item in coupon matchapply     codes=zyx20211230S25g5    expect1=5.0

verify Non-discountable item matchapply Entire Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10000562    codes=zyx2022666entire20
    ...     expect=0.0   expect1=8.0

verify Non-discountable item matchapply 22MADEBYYOU Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10000562    codes=22MADEBYYOU    expect1=8.0

verify Non-discountable item matchapply ERPP Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10000562    codes=zyx2022666erpp20    expect1=8.0

verify Non-discountable item matchapply AORPI Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10000562    codes=zyx2022666aorpi20  expect1=4.0

verify Non-discountable item matchapply Spend&Get Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10000562    codes=zyx20211230S25g5    expect1=5.0

verify clearance item matchapply Spend&Get Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10676699    codes=zyx20211230S25g5
    ...    expect1=5.0   expect=20.0

verify clearance item matchapply AORPI Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10676699    codes=zyx2022666aorpi20
    ...    expect1=4.0   expect=20.0

verify clearance item matchapply ERPP Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10676699    codes=zyx2022666erpp20
    ...    expect1=8.0   expect=20.0

verify clearance item matchapply 22MADEBYYOU Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10676699    codes=22MADEBYYOU
    ...    expect1=8.0   expect=20.0


verify clearance item matchapply Entire Coupon
    [Tags]   mpe    test6
    Item In Coupon Matchapply   sku=10676699    codes=zyx2022666entire20
    ...    expect1=8.0   expect=20.0


*** Keywords ***
item in coupon matchapply
    [Arguments]   ${sku}=10574552   ${codes}=22MADEBYYOU    ${expect}=0.00   ${expect1}=8.0
    ${item}     Create Dictionary     sku=${sku}    piece=2
    ${item_list}    Create List   ${item}
    ${order}   Create Dictionary   item=${item_list}
    ${item1}    Create Dictionary     sku=zyx2323232323     piece=2
    ${item_list1}    Create List   ${item1}
    ${order1}   Create Dictionary   item=${item_list1}
    ${order_list}  Create List  ${order}    ${order1}
    ${sub_order}   Create Dictionary   order=${order_list}    codes=${codes}
    ${body}     get_match_apply_body  ${sub_order}
    ${match_apply_res}    Post matchApply Response   ${body}
    Should Be Equal As Numbers    ${expect}   ${match_apply_res.json()["data"]["subOrder"][0]["benefit"]["fixedAmount"]}
    Should Be Equal As Numbers    ${expect1}   ${match_apply_res.json()["data"]["subOrder"][1]["benefit"]["fixedAmount"]}