*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyProduct.py
Resource            ../../TestData/B2B/PathProduct.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${B2B_User_Info}
${B2B_User_Id}
${Headers_User_Get}
${Headers_User_Post}
${Sku_Number}               10415277
${Pro_Complete_Info}
${Pro_Sku_Info}
${B2B_Single_Sku_Items}
${B2B_Multi_Sku_Items}

*** Keywords ***
Set Initial Data - B2B - Product
    Initial Env Data     configB2B.ini
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}

Get Full Categories List - GET
    ${res}    Send Get Request    ${URL-MIK}    ${FULL_CATEGORIES}    ${NULL}    ${Headers_User_Get}

Get Product Trending Now List - GET
    ${body}    Get Products Trending Now Body
    ${res}    Send Get Request    ${URL-B2B}    ${PRO_TRENGDING_NOW}    ${Body}    ${Headers_User_Get}   404

Get Product Purchased Together Items - GET
    ${body}    Get Recommendation Items Body    ${Sku_Number}
    ${res}    Send Get Request    ${URL-B2B}    ${PRO_ENT_TOGETHER_ITEMS}   ${body}    ${Headers_User_Get}

Get Product Similar Items - GET
    ${body}    Get Recommendation Items Body    ${Sku_Number}
    ${res}    Send Get Request    ${URL-B2B}    ${PRO_ENT_SIMILAR_ITEMS}   ${body}    ${Headers_User_Get}

Get Product Simple - GET
    ${body}    Get Products Simple Body
    ${res}    Send Post Request    ${URL-B2B}    ${PRO_SIMPLE}    ${body}    ${Headers_User_Post}
    ${items}    Get Json Value    ${res.json()}    items
    ${Sku_Number}    Get Json Value    ${res.json()}    items    skuNumber
    Set Suite Variable    ${Item_Info}    ${items[0]}
    Set Suite Variable    ${Sku_Number}    ${Sku_Number}

Get User Recommended Items - GET
    ${body}    Create Dictionary    candidateCount=4
    Send Get Request    ${URL-B2B}    ${REC_USER}/${B2B_User_Id}${PRO_RECOMMENDED_ITEMS}    ${body}    ${Headers_User_Get}

Get User Buy It Again Items - GET
    ${body}    Create Dictionary    candidateCount=4
    Send Get Request    ${URL-B2B}    ${REC_USER}/${B2B_User_Id}${PRO_BUY_IT_AGAIN_ITEMS}    ${body}    ${Headers_User_Get}

Get Product Complete Info By Sku Number - GET
    ${res}    Send Get Request    ${URL-B2B}    ${PROS}/${Sku_Number}   ${null}    ${Headers_User_Get}
    Set Suite Variable    ${Pro_Complete_Info}    ${res.json()}

Get Product Sku Info By Sku Number - GET
    ${body}    Create Dictionary    skus=${Sku_Number}
    ${res}    Send Get Request    ${URL-B2B}    ${PROS}   ${body}    ${Headers_User_Get}
    Set Suite Variable    ${Pro_Sku_Info}    ${res.json()}

Get Single Or Multi Item's Sku Number
    [Documentation]    sku_type:0-single sku, 1-multi sku, 2-randmon sku
    [Arguments]    ${sku_type}=0    ${sku_quantity}=1
#    ${skus}    Set Variable If    '${sku_type}'=='${True}'    ${B2B_Single_Sku_Items}    ${B2B_Multi_Sku_Items}
    ${Sku_Number}    Get Random Sku Number    ${B2B_Single_Sku_Items}    ${B2B_Multi_Sku_Items}    ${sku_type}    ${sku_quantity}
    Set Suite Variable    ${Sku_Number}    ${Sku_Number}
