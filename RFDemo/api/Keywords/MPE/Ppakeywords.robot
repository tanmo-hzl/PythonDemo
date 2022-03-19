*** Settings ***
Resource  ../../TestData/MPE/MPEPath.robot
Resource  ../../Keywords/CommonRequestsKeywords.robot


*** Keywords ***
post save group mapping
    [Arguments]   ${body}       ${res_code}=200
    ${res}      Send Post Request   ${url-mpe}    ${mpe_save_GroupMapping}    ${body}
    ...           ${default_headers}    ${res_code}
    [Return]   ${res.json()}