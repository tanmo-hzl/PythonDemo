*** Settings ***
Library      ../../Libraries/MPE/GetBodyAndverifyData.py
Resource    ../CommonRequestsKeywords.robot
Resource    ../../TestData/MPE/MPEPath.robot
Resource  ../../TestData/EnvData.robot

*** Variables ***
&{default_headers}    Content-Type=application/json
...                   accept=*/*
...                   User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36 Edg/96.0.1054.43

*** Keywords ***
apply verify data
    [Arguments]         ${apply_resp}     ${expect}
    LOG     ${apply_resp}
    ${index}    Set Variable   ${0}
    FOR         ${sub order}       IN    @{apply_resp["data"]["subOrder"]}
        ${index}     Evaluate   ${index}+ ${1}
        LOG     ${sub order}
        Should Be Equal As Strings     ${sub order}[benefit][fixedAmount]     ${expect}[order${index}]
        Log    ${sub order}[benefit]
        ${not_expect_item_prices}         verify_item_prices      ${sub order["item"]}
        Log     ${not_expect_item_prices}
        verify_item_count_prices        ${not_expect_item_prices}
        FOR     ${item}     IN     @{sub order["item"]}

#                Should Be Equal As Strings      ${item}[adjustedAmount]      ${expect}[${item}[sku]]
                ${a}     str_sum      ${item}[adjustedAmount]
                ${b}     str_sum    ${expect}[${item}[sku]]         0.01       -
                ${c}     str_sum    ${expect}[${item}[sku]]       0.01
                IF    ${a}<${b}
                    Error_log          ${item}[adjustedAmount] != ${expect}[${item}[sku]]
                END
                IF   ${a}>${c}
                    Error_log         ${item}[adjustedAmount] != ${expect}[${item}[sku]]
                END
#                IF    ${a} >=  ${c}
#                    Fatal Error          ${item}[adjustedAmount] != ${expect}[${item}[sku]]
#                END
        END
    END


Post matchApply Response
    [Arguments]     ${apply_body}   ${res_code}=200
    ${resp}     Send Post Request   ${url-mpe}     ${mpe_match_apply}     ${apply_body}       ${default_headers}     ${res_code}
    [Return]    ${resp}

Post matchApply Response1
    [Arguments]     ${apply_body}
    ${resp}     Send Post Request   ${url-mpe}     ${mpe_apply_coupon}     ${apply_body}     ${default_headers}

    [Return]    ${resp}


Post add promotion Response
    [Arguments]     ${promotion_body}
    ${resp}     Send Post Request   ${url-mpe}     ${mpe_promotion_add}     ${promotion_body}     ${default_headers}
    [Return]    ${resp}

Post add bundle promotion Response
    [Arguments]     ${promotion_body}
    ${resp}     Send Post Request   ${url-mpe}     ${mpe_promotion_bundle}     ${promotion_body}    ${default_headers}
    [Return]    ${resp}


Add promotion Case keyword
    [Arguments]     ${promotion_name}
    ${promotio_body}     get_add_promotion_body      ${promotion_name}
    ${match_apply_resp}     Post add promotion Response        ${promotio_body}
    IF   ${match_apply_resp.status_code}!=200
         error_log    status != 200
    ELSE
         log  success
    END

Add bundle promotion Case keyword
    [Arguments]     ${promotion_name}     ${yaml_file}=./CaseData/MPE/bundle_promotion_add.yaml         ${json_file}=./TestData/MPE/bundle_add_promotion.json
    ${promotio_body}     get_add_promotion_body      ${promotion_name}      ${yaml_file}       ${json_file}
    ${match_apply_resp}     Post add bundle promotion Response        ${promotio_body}


Verify Apply case keyword
    [Arguments]      ${case_name}      ${yaml_file}=./CaseData/MPE/apply_case_data_v2.yaml
    ${expect}       get_yaml_data       ${case_name}      ${yaml_file}
    ${match_apply_body}     get_apply_body     ${case_name}    ${yaml_file}
    Log     ${match_apply_body}
    ${match_apply_resp}     Post matchApply Response        ${match_apply_body}
#    save_two_api_json   ${case_name}         ${match_apply_resp}
#    ${match_apply_resp1}     Post matchApply Response1      ${match_apply_body}
#    save_two_api_json   ${case_name}      ${match_apply_resp1}
    apply verify data       ${match_apply_resp.json()}      ${expect}

Verify Apply case keyword1
    [Arguments]      ${case_name}      ${yaml_file}=./CaseData/MPE/apply_case_data_v2.yaml
    ${expect}       get_yaml_data       ${case_name}      ${yaml_file}
    ${match_apply_body}     get_apply_body     ${case_name}    ${yaml_file}
    ${match_apply_resp1}     Post matchApply Response1      ${match_apply_body}
    save_two_api_json   ${case_name}      ${match_apply_resp1}
    ${match_apply_resp}     Post matchApply Response      ${match_apply_body}
    save_two_api_json   ${case_name}         ${match_apply_resp}
    apply verify data       ${match_apply_resp1.json()}      ${expect}


verify apply multiple promotion
    [Arguments]      ${case_name}      ${yaml_file}=./CaseData/MPE/apply_case_data_v2.yaml
    ${expect}       get_yaml_data       ${case_name}      ${yaml_file}
    ${match_apply_body}     get_apply_body     ${case_name}    ${yaml_file}
    ${match_apply_resp}     Post matchApply Response1        ${match_apply_body}