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
${Quote_ID}
${User_Quotes_Detail}
${Michaels_Quotes_Detail}

*** Keywords ***
Set Initial Data - B2B - Quotes
    Initial Env Data     configB2B.ini
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST
    Set Suite Variable    ${Cur_PWD}    ${PWD}
    B2B User Sign In - POST    ${ENT_EMAIL_ADMIN}
    B2B Get User Organization List - GET

Get Quotes List By Michaels - GET
    ${data}   Get Quotes List Body
    ${res}    Send Get Request     ${URL-B2B}   ${QUOTES}     ${data}    ${Headers_Michaels_Post}

Get Quotes List By User - GET
    ${data}   Get Quotes List Body
    ${res}    Send Get Request     ${URL-B2B}   ${QUOTES}     ${data}    ${Headers_User_Post}

Create Quotes With Items - POST
    Get Single Or Multi Item's Sku Number   0    1
    Get Product Sku Info By Sku Number - GET
    ${data}   Get Create Quotes Items Body     ${B2B_User_Id}   ${B2B_User_Org_Id}    ${Pro_Sku_Info}
    ${res}    Send Post Request   ${URL-B2B}    ${QUOTES-AND-ITEMS}   ${data}     ${Headers_Michaels_Post}   201
    ${quote_id}    Get Json Value   ${res.json()}   quoteId
    Set Suite Variable    ${Quote_ID}    ${quote_id}

Create Approve Request - POST
    Send Post Request   ${URL-B2B}    ${QUOTES}/${Quote_ID}${APPROVAL-REQUEST}  ${null}   ${Headers_Michaels_Post}   201

Get Quotes Items Details By Michaels - GET
    ${path}   Set Variable  /organizations/${B2B_User_Org_Id}/users/${B2B_User_Id}${QUOTES}/${Quote_ID}${QUOTE-ITEMS}
    ${res}    Send Get Request     ${URL-B2B}   ${path}     ${null}    ${Headers_Michaels_Get}
    Set Suite Variable    ${Michaels_Quotes_Detail}    ${res.json()}

Get Quotes Items Details By User - GET
    ${path}   Set Variable  /organizations/${B2B_User_Org_Id}/users/${B2B_User_Id}${QUOTES}/${Quote_ID}${QUOTE-ITEMS}
    ${res}    Send Get Request     ${URL-B2B}   ${path}     ${null}    ${Headers_User_Get}
    Set Suite Variable    ${User_Quotes_Detail}    ${res.json()}

Update Quotes With Items - PATCH
    ${body}   Get Update Quotes Items Body  ${b2b_user_id}   ${B2B_User_Org_Id}  ${Michaels_Quotes_Detail}
    Send Patch Request   ${URL-B2B}    ${QUOTES}/${Quote_ID}${UPDATE-QUOTES-ITMES}  ${body}  ${Headers_Michaels_Get}

Approve Quotes - PATCH
    Send Patch Request    ${URL-B2B}   ${QUOTES}/${Quote_ID}${APPROVE}   ${null}   ${Headers_Michaels_Post}    200

Quotes Order Reject By Michaels
    Send Patch Request    ${URL-B2B}    ${QUOTES}/${Quote_ID}${REJECT}    ${null}   ${Headers_Michaels_Post}    204

Quotes Items Reject By Michaels
    ${body}    Create Dictionary    comment=rejected
    Send Patch Request    ${URL-B2B}    ${QUOTES}/${Quote_ID}${UPDATE-QUOTES-ITMES}  ${body}  ${Headers_Michaels_Post}

Quotes Order Cancel By User
    ${body}    Create Dictionary    status=CANCELLED
    ${path}   Set Variable  /organizations/${B2B_User_Org_Id}/users/${B2B_User_Id}${QUOTES}/${Quote_ID}
    Send Patch Request    ${URL-B2B}    ${path}    ${body}    ${Headers_User_Post}

Check Quotes Status
    [Documentation]    INITIATED, SUBMITTED,PRICED,CUSTOMER_ACCEPTED,CUSTOMER_REJECTED,CANCELLED,PAYMENT_NEEDED,COMPLETED,
                       ...		PENDING_MICHAELS_ADMIN_APPROVAL,MICHAELS_ADMIN_REJECTED,IN_PROGRESS,EXPIRED
    [Arguments]    ${status}
    ${body}   Get Quotes List Body    ${Quote_ID}
    ${res}    Send Get Request     ${URL-B2B}    ${QUOTES}    ${body}    ${Headers_Michaels_Post}
    ${now_status}    Get Json Value    ${res.json()}    status
    Run Keyword And Ignore Error    Should Be Equal As Strings    ${status}    ${now_status}
