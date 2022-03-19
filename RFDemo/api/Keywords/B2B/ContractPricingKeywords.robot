*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyContractPricing.py
Resource            ../../TestData/B2B/PathContractPricing.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${Michaels_User_Info}
${Headers_Michaels_Get}
${Headers_Michaels_Post}
${Contract_Info}
${Contract_Id}
${Contract_Name}
${New_Contract_Name}
${Core_Item_Info}
${Pricing_Tiers_Info}
${Pricing_Tiers_Item_Info}
${Contract_Elements}
${Remove_Element_Info}

*** Keywords ***
Set Initial Data - B2B - Contract
    Initial Env Data     configB2B.ini
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST
    ${user_id}    Get Json Value    ${Michaels_User_Info}    michaelsUser    id
    Set Suite Variable    ${User_Id}    ${user_id}

Get Contract Pricing List - GET
    ${body}    Get Contract Pricing Catalogs Body
    Contract Pricing List    ${body}

Get Contract Pricing List By Name - GET
    [Arguments]   ${name}
    ${body}    Get Contract Pricing Catalogs Body    name=${name}
    Contract Pricing List    ${body}

Get Contract Pricing List By Status - GET
    [Arguments]   ${status}
    ${body}    Get Contract Pricing Catalogs Body    status=${status}
    Contract Pricing List    ${body}

Contract Pricing List
    [Arguments]    ${body}
    ${res}    Send Get Request    ${URL-B2B}     ${PRICING_CATALOGS}    ${body}    ${Headers_Michaels_Get}
    Set Suite Variable    ${Contract_Info}    ${res.json()[0]}
    ${Contract_Id}    Get Json Value    ${Contract_Info}    pricingCatalogId
    Set Suite Variable    ${Contract_Id}    ${Contract_Id}
    ${Contract_Name}    Get Json Value    ${Contract_Info}    name
    Set Suite Variable    ${Contract_Name}    ${Contract_Name}

Create Contract Pricing By Name - POST
    ${Contract_Name}    Get Contract Name
    Set Suite Variable    ${Contract_Name}     ${Contract_Name}
    ${body}    create dictionary    name=${Contract_Name}
    ${res}    Send Post Request    ${URL-B2B}     ${PRICING_CATALOGS}    ${body}    ${Headers_Michaels_Post}   201
    ${Contract_Id}    Get Json Value    ${res.json()}    pricingCatalogId
    Set Suite Variable    ${Contract_Id}    ${Contract_Id}

Update Contract Pricing Name - PATCH
    ${New_Contract_Name}    Get Contract Name
    Set Suite Variable    ${New_Contract_Name}    ${New_Contract_Name}
    ${body}    create dictionary    name=${New_Contract_Name}
    ${res}    Send Patch Request    ${URL-B2B}     ${PRICING_CATALOGS}/${Contract_Id}    ${body}    ${Headers_Michaels_Post}    204

Get Core Items - GET
    ${body}    Create Dictionary    pageNumber=0    pageSize=20
    ${res}    Send Get Request    ${URL-B2B}     ${GET_CORE_ITEMS}    ${body}    ${Headers_Michaels_Get}
    ${Core_Item_Info}    Evaluate    random.sample(${res.json()},1)[0]
    Set Suite Variable     ${Core_Item_Info}    ${Core_Item_Info}

Add Core Items To Contract - PATCH
    ${core_item_id}    Get Json Value    ${Core_Item_Info}    coreItemId
    ${core_items}    Create List    ${core_item_id}
    ${body}    Create Dictionary    newCoreItemIds=${core_items}
    ${res}    Send Patch Request    ${URL-B2B}     ${PRICING_CATALOGS}/${Contract_Id}     ${body}    ${Headers_Michaels_Post}    204

Get Pricing Tiers - GET
    ${body}    Create Dictionary    pageNumber=0    pageSize=20
    ${res}    Send Get Request    ${URL-B2B}     ${GET_PRICING_TIERS}    ${body}    ${Headers_Michaels_Get}
    ${Pricing_Tiers_Info}    Evaluate    random.sample(${res.json()},1)[0]
    Set Suite Variable     ${Pricing_Tiers_Info}    ${Pricing_Tiers_Info}

Get Pricing Tiers Items - POST
    ${body}    Get Tiers Items Body
    ${res}    Send Post Request    ${URL-B2B}     ${GET_TIERS_ITEMS}     ${body}    ${Headers_Michaels_Post}
    ${pricing_items}    Get Json Value    ${res.json()}    items
    ${Pricing_Tiers_Item_Info}    Evaluate    random.sample(${pricing_items},1)[0]
    Set Suite Variable     ${Pricing_Tiers_Item_Info}    ${Pricing_Tiers_Item_Info}

Add Pricing Tiers Items To Contract - PATCH
    ${body}    Get Pricing Tiers Items Body    ${Pricing_Tiers_Info}    ${Pricing_Tiers_Item_Info}
    ${res}    Send Patch Request    ${URL-B2B}     ${PRICING_CATALOGS}/${Contract_Id}     ${body}    ${Headers_Michaels_Post}    204

Get Contract Pricing Catalogs Elements - GET
    ${body}    Get Pricing Catalogs Elements Body
    ${res}    Send Get Request    ${URL-B2B}     ${PRICING_CATALOGS}/${Contract_Id}/${GET_CONTRACT_ELEMENTS}     ${body}    ${Headers_Michaels_Get}
    Set Suite Variable    ${Contract_Elements}     ${res.json()}

Remove Item From Elements - PATCH
    ${Remove_element_info}    Evaluate        random.sample(${Contract_Elements},1)[0]
    Set Suite Variable    ${Remove_element_info}    ${Remove_element_info}
    ${element_id}    Get Json Value    ${Remove_element_info}    elementId
    ${element_ids}    Create List    ${element_id}
    ${body}    Create Dictionary    catalogCoreItemAndProductIdsToRemove=${element_ids}
    ${res}    Send Patch Request    ${URL-B2B}     ${PRICING_CATALOGS}/${Contract_Id}     ${body}    ${Headers_Michaels_Post}    204

Check New Item In List
    [Arguments]    ${elements}    ${item}
    ${result}    Check Item In List    ${elements}    ${item}
    Should Be True    ${result}

Check Item Not In List
    [Arguments]    ${elements}    ${item}
    ${result}    Check Item In List    ${elements}    ${item}
    Should Not Be True    ${result}