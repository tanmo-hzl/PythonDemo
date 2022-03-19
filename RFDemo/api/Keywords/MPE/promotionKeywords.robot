*** Settings ***
Resource  ../../TestData/MPE/MPEPath.robot
Resource  ../../Keywords/CommonRequestsKeywords.robot

*** Keywords ***
post promotion list
    [Arguments]     ${channel}=michaels.com     ${autoApply}=Promotion     ${status}=1
    ...         ${page}=0    ${size}=10   ${res_code}=200
    ${body}     Create Dictionary   channel=${channel}    autoApply=${autoApply}
    ...         status=${status}    page=${page}    size=${size}
    ${res}   Send Post Request   ${url-mpe}  ${mpe_promotion_list}   ${body}     ${default_headers}    ${res_code}
    [Return]   ${res}

post promotion in coupon list
    #Status   enable,activity stop,expired,manual stop,draft
    [Arguments]     ${channel}=michaels.com    ${status}=enable   ${userId}=-1
    ...         ${page}=0    ${size}=10   ${res_code}=200
    ${body}     Create Dictionary   channel=${channel}    userId=${userId}
    ...         status=${status}    page=${page}    size=${size}
    ${res}   Send Post Request   ${url-mpe}  ${mpe_promotion_coupon_list}   ${body}     ${default_headers}    ${res_code}
    [Return]   ${res}



get product group be get promotion List
    [Arguments]     ${size}=20
    ${promotion_list_res}    post promotion list   size=${size}
    ${promotion_list}   Set Variable  ${promotion_list_res.json()["data"]["content"]}
    ${product_group_list}     Create List
    FOR  ${promotion}  IN  @{promotion_list}
        IF  "${promotion['type']}"=="PPA" and ${promotion['productRestriction']}!=[]
            IF  "${promotion['productRestriction'][0]['type']}"=="Group"
                ${product_group_id}     Set Variable   ${promotion['productRestriction'][0]['value']}
#            Exit For Loop
                Append To List      ${product_group_list}   ${product_group_id}
            END
        END
    END
    ${product_group_number}     Get Length   ${product_group_list}
    IF  ${product_group_number}==0
        Fail   product_group is not find
     END
    [Return]    ${product_group_list}

get serialized coupon list
    [Arguments]   ${size}=10
    ${promotion_coupon_list_res}   post promotion in coupon list    size=${size}
    ${serialized_coupon_list}   Create List
    FOR  ${promotion}  IN   @{promotion_coupon_list_res.json()["data"]["content"]}
        Log  ${promotion}
        IF  "${promotion['autoApply']}"=="Serialized Coupon" and ${promotion['coupons']}!=[]
            Log  ${promotion['coupons']}
            FOR  ${coupon}  IN  @{promotion["coupons"]}
                IF  ${coupon["status"]}==1
                    ${var_coupon}   Create Dictionary   coupon_id=${coupon["couponId"]}     code=${coupon["code"]}
                    Append To List      ${serialized_coupon_list}   ${var_coupon}
                END
            END
        END
    END
    [Return]    ${serialized_coupon_list}