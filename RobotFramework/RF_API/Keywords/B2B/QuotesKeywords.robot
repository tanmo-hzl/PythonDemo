*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyQuotes.py
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../TestData/B2B/PathQuotes.robot
Resource            ../../Keywords/B2B/UserKeywords.robot
Resource            ../../Keywords/B2B/ProductKeywords.robot

*** Variables ***
${Michaels_User_Info}
${Headers_Michaels_Get}
${Headers_Michaels_Post}
#${Quote_id}

*** Keywords ***
Set Initial Data - B2B - Quotes
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}
    B2B Get User Organization List - GET

Get quotes List - GET
    ${data}   get_quotes_list_body
    ${res}    Send Get Request     ${URL-B2B}   ${QUOTES}     ${data}    ${Headers_Michaels_Post}


Create Quotes with items - POST
    Get Single Or Multi Item's Sku Number   0    2
    Get Product Sku Info By Sku Number - GET
    ${data}   get_create_quotes_items_body     ${b2b_user_id}   ${B2B_User_Org_Id}    ${Pro_Sku_Info}
    ${res}    Send Post Request   ${URL-B2B}    ${QUOTES-AND-ITEMS}   ${data}     ${Headers_Michaels_Post}   201
    ${quote_id}    get json value   ${res.json()}   quoteId
#    Set Suite Variable  ${Quote_id}   ${quote_id}
    Send Post Request   ${URL-B2B}    ${QUOTES}/${quote_id}${APPROVAL-REQUEST}  ${null}   ${Headers_Michaels_Post}   201
    [Return]   ${quote_id}

Get Quotes Items Details - GET
    [Arguments]   ${Quote_id}
    ${path}   set variable  /organizations/${B2B_User_Org_Id}/users/${B2B_User_Id}/quotes/${Quote_id}/quote-items
    ${res}    Send Get Request     ${URL-B2B}   ${path}     ${null}    ${Headers_Michaels_Get}
    [Return]   ${res.json()}


Update Quotes with items - PATCH
    [Arguments]  ${quotes_item_detail}
    ${body}  get_update_quotes_items_body  ${b2b_user_id}   ${B2B_User_Org_Id}  ${quotes_item_detail}
    ${Quote_id}  get json value  ${quotes_item_detail}  quoteId
    Send Patch Request   ${URL-B2B}  ${QUOTES}/${Quote_id}${UPDATE-QUOTES-ITMES}  ${body}  ${headers_michaels_post}


Create Approve Quotes - PATCH
    [Arguments]   ${Quote_id}
    Send Patch Request  ${URL-B2B}   /quotes/${Quote_id}${APPROVE}   ${null}   ${headers_michaels_post}