*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
#Resource            ../../Keywords/CPM/UserKeywords.robot
*** Keywords ***
Mik Get Wallet Bank Card - GET
    [Arguments]  ${user_id}
#    log to console    ${Headers}
    ${resp}    Send Get Request    ${URL-FIN}    /wallet/bankcard/${user_id}    ${null}    ${Headers}
