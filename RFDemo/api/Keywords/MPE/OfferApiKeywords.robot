*** Settings ***
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../TestData/MPE/MPEPath.robot

*** Variables ***


*** Keywords ***
get offer skus
    [Arguments]  ${sku}   ${res_code}=200
    ${res}    send get request    ${URL-MPE}    ${mpe_offer_skus}${sku}     ${null}     ${default_headers}    ${res_code}
    [Return]  ${res}

Post redeem
    [Arguments]    ${body}   ${res_code}=200
    ${res}      Send Post Request   ${url-mpe}      ${mpe_redeem}       ${body}     ${default_headers}   ${res_code}
    [Return]  ${res}

post promotion top
    [Arguments]     ${channel}=michaels.com     ${store}=1056     ${email}=yixian@michaels.com
    ...             ${res_code}=200
    ${body}     Create Dictionary   channel=${channel}    store=${store}
    ...         email=${email}
    ${res}   Send Post Request   ${url-mpe}  ${mpe_promotion_top}   ${body}     ${default_headers}    ${res_code}
    [Return]   ${res.json()}

get longcode km
    [Arguments]  ${code}    ${res_code}=200
    ${param}    set variable     code=${code}
    ${res}   Send Get Request  ${url-mpe}    ${mpe_getlongcodekm}    ${param}     ${default_headers}     ${res_code}
    [Return]  ${res}

get lookup coupon ams
    [Arguments]   ${code}    ${res_code}=200
    ${param}    Set Variable    code=${code}
    ${res}   Send Get Request   ${url-mpe}   ${mpe_lookup_coupon_ams}   ${param}    ${default_headers}     ${res_code}
    [Return]  ${res.json()}

get group id information
    [Arguments]  ${group_id}   ${res_code}=200
    ${res}    send get request    ${URL-MPE}    ${mpe_get_group}${group_id}     ${null}     ${default_headers}    ${res_code}
    [Return]  ${res}


get promotion id information
    [Arguments]  ${promotion_id}=1001       ${res_code}=200
    ${res}      Send Get Request  ${url-mpe}   ${mpe_get_promotion}${promotion_id}
    ...         ${null}     ${default_headers}    ${res_code}
    [Return]    ${res}


get coupon ids information
    [Arguments]  ${coupon_ids}       ${res_code}=200
    ${res}      Send Get Request  ${url-mpe}   ${mpe_get_coupon_list}${coupon_ids}
    ...         ${null}     ${default_headers}    ${res_code}
    [Return]    ${res}



Verify Offer_sku Not Contain 22MADEBYYOU
    [Arguments]     ${sku_offer_res}       ${sku_list_str}      ${expect}=0
    @{req_sku_list}     Set Variable     ${sku_list_str.split(",")}
    ${offer_sku_list}   Set Variable    ${sku_offer_res.json()["data"]}
    FOR  ${offer_sku}   IN  @{offer_sku_list}
        Log  ${offer_sku}
        Should Contain Any  ${req_sku_list}   ${offer_sku["sku"]}
        ${sku_offer_number}     Get Length     ${offer_sku["offer"]}
        IF  ${sku_offer_number}>=2
            FOR   ${offer}  IN   @{offer_sku["offer"]}
                   Log  ${offer}
                   Should Not Be Equal As Strings   ${offer["autoApply"]}    Non-Serialized Coupon
                   Should Not Be Equal As Strings   ${offer["calloutMessage"]}    Save 20% with code 22MADEBYYOU
            END
        ELSE IF  ${expect}==1
            Should Not Be Equal As Strings   ${offer_sku["offer"][0]["autoApply"]}    Non-Serialized Coupon
            Should Not Be Equal As Strings   ${offer_sku["offer"][0]["calloutMessage"]}    Save 20% with code 22MADEBYYOU
        END
    END

Verify Offer_sku in Contain 22MADEBYYOU
    [Arguments]     ${sku_offer_res}       ${sku_list_str}
    @{req_sku_list}     Set Variable     ${sku_list_str.split(",")}
    ${offer_sku_list}   Set Variable    ${sku_offer_res.json()["data"]}
    FOR  ${offer_sku}   IN  @{offer_sku_list}
        Log  ${offer_sku}
        ${sku_offer_number}     Get Length     ${offer_sku["offer"]}
        Should Be Equal As Numbers    ${sku_offer_number}   1
        FOR   ${offer}  IN   @{offer_sku["offer"]}
                   Log  ${offer}
                   Should Be Equal As Strings   ${offer["autoApply"]}    Non-Serialized Coupon
                   Should Be Equal As Strings   ${offer["calloutMessage"]}    Save 20% with code 22MADEBYYOU
        END
    END

Verify Offer_sku offer is null
    [Arguments]     ${sku_offer_res}       ${sku_list_str}
    @{req_sku_list}     Set Variable     ${sku_list_str.split(",")}
    ${offer_sku_list}   Set Variable    ${sku_offer_res.json()["data"]}
    FOR  ${offer_sku}   IN  @{offer_sku_list}
        Log  ${offer_sku}
        ${sku_offer_number}     Get Length     ${offer_sku["offer"]}
        Should Be Equal As Numbers    ${sku_offer_number}   0
#        FOR   ${offer}  IN   @{offer_sku["offer"]}
#                   Log  ${offer}
#                   Should Be Equal As Strings   ${offer["autoApply"]}    Non-Serialized Coupon
#                   Should Be Equal As Strings   ${offer["calloutMessage"]}    Save 20% with code 22MADEBYYOU
#        END
    END

Verify Offer_sku sku number
    [Arguments]     ${sku_offer_res}       ${sku_list_str}
    @{req_sku_list}     Set Variable     ${sku_list_str.split(",")}
    ${offer_sku_list}   Set Variable    ${sku_offer_res.json()["data"]}
    ${offer_sku_number}     Get Length     ${offer_sku_list}
    ${req_sku_number}       Get Length     ${req_sku_list}
    Should Be Equal As Numbers      ${req_sku_number}    ${offer_sku_number}
    FOR  ${offer_sku}   IN  @{offer_sku_list}
        Log  ${offer_sku}
        Should Contain Any  ${req_sku_list}   ${offer_sku["sku"]}
    END

get sku be Get Group
    [Arguments]     ${group_id}=55820
    ${sku_group_res}   get group id information    ${group_id}
    ${sku_list}     Set Variable  ${sku_group_res.json()["data"]["item"]}
    [Return]    ${sku_list}


