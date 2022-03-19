*** Variables ***

@{qa_regular_item}       10537277       10180752
@{stg_regular_item}       10537277       10180752
@{tst_regular_item}       10537277       10180752
@{qa_great_buy_item}      10574552      10131568
@{stg_great_buy_item}     10574552      10131568
@{tst_great_buy_item}     10574552      10131568
@{qa_clearance_item}     10676699
@{stg_clearance_item}     10676699
@{tst_clearance_item}     10676699





*** Keywords ***
get env item
    [Arguments]   ${env}    ${item_name}=regular_item

    ${env_item}     Set Variable   ${${env}_${item_name}}
    [Return]   ${env_item}
