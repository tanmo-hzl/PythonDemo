*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyUser.py
Library             ../../Libraries/CommonRSA.py
Resource            ../../TestData/MP/PathUser.robot
#Resource            ../../TestData/MP/UserInfo.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot

*** Variables ***
${random_id}
${seller_info_create}
${seller_info_sign}
${application_id}
${seller_user_id}
${seller_store_id}
${seller_session_id}
${buyer_session_id}
${index}
${ipv4}
${map_public_data}
${map_email_password}
${mik_public_data}
${mik_email_password}
${seller_info}
${BUY_EMAIL}
${BUY_PASSWORD}
${pwd}  Password123
${MAP_EMAIL}
${MAP_PASSWORD}

*** Keywords ***
Get IPv4
#    ${res}   Run Keyword And Ignore Error    Send Get Request Without Token   ${url-ipv4}    ${null}    ${null}
#    Run Keyword If    '${res}'!='None'     Set Suite Variable    ${ipv4}    ${res.text}
#    Run Keyword If    '${res}'!='None'     Set Suite Variable    ${ipv4}    ${null}
    Set Suite Variable    ${ipv4}    ${null}

Save Token By User Type
    [Arguments]     ${user_type}    ${token}
    run keyword if    '${user_type}'=='buyer'    Save File    token-buyer     ${token}
    run keyword if    '${user_type}'=='seller'    Save File    token-seller     ${token}
    run keyword if    '${user_type}'=='admin'    Save File    token-admin     ${token}

Save Success Seller Info
    [Arguments]     ${seller_info}
    Save File    seller-info    ${seller_info}

Map Public Key - GET
    [Documentation]  Get map sign in publick key
    ${res}    Send Get Request Without Token   ${url-map}    ${map-get-public-key}     ${null}
    ${map_public_data}    Get Json Value    ${res.json()}    data
    ${public_key}    Get Json Value    ${map_public_data}    publicKey
    ${server_time}    Get Json Value    ${map_public_data}    serverTime
    ${map_info}   create dictionary  email=${MAP_EMAIL}  password=${MAP_PASSWORD}
    Set To Dictionary    ${map_info}      serverTime    ${server_time}
    ${map_email_password}    Rsa Encrypt Sha256 Msg By Key    ${public_key}    ${map_info}
    Set suite Variable     ${map_email_password}    ${map_email_password}

Map Manager Sign In - POST
    [Documentation]  Sign in member system (map) to approve the seller application
    Map Public Key - GET
    ${body}    Create Dictionary    emailPassword=${map_email_password}
    Log    ${body}
    ${res}    Send Post Request Without Token    ${url-map}    ${map-sign-in-secure}    ${body}
    Log    ${res.json()}
    ${data}    Get Json Value    ${res.json()}    data
    ${token}    Get Json Value    ${data}    token
    Save File    map-user-info-sign     ${data}
    Save Token By User Type    admin    ${token}

Map User Refresh Token - POST
    [Documentation]   Update the token to skip login process
    ${map_user_info_sign}    Read File    map-user-info-sign
    Set Suite Variable    ${map_user_info_sign}    ${map_user_info_sign}
    ${map_session_id}    Get Json Value     ${map_user_info_sign}     sessionId
    Set Suite Variable    ${map_session_id}    ${map_session_id}
    ${body}    create dictionary     sessionId=${map_session_id}
    ${headers}    Set Post Headers - Admin
    ${res}    Send Post Request    ${url-map}    ${map-refresh-token}    ${body}    ${headers}
    Log    ${res.json()}
    ${data}     Get Json Value    ${res.json()}     data
    ${token}    Get Json Value    ${data}    token
#    Set Global Variable    ${map-token}    ${token}
    Run Keyword If    ${res.status_code==200}    Save Token By User Type    admin    ${token}

Mik Public Key - GET
    [Arguments]    ${user}
    [Documentation]  Get mik sign in publick key
    ${res}    Send Get Request Without Token   ${url-mik}    ${mik-get-public-key}     ${null}
    ${mik_public_data}    Get Json Value    ${res.json()}    data
    ${public_key}    Get Json Value    ${mik_public_data}    publicKey
    ${server_time}    Get Json Value    ${mik_public_data}    serverTime
    Set To Dictionary    ${user}      serverTime    ${server_time}
    ${mik_email_password}    Rsa Encrypt Sha256 Msg By Key    ${public_key}    ${user}
    ${mik_email_password}    Str To Url Encode    ${mik_email_password}
    Set Suite Variable    ${mik_email_password}    ${mik_email_password}

Mik Buyer Sign In - POST
    Get IPv4
    ${body}    get mik sign in body    ${seller_info}    ${ipv4}
    ${res}    Send Post Request Without Token    ${url-mik}    ${mik-sign-in}    ${body}
    Mik Save Buyer Sign In Info    ${res}

Mik Buyer Sign In Scuse - POST
    [Documentation]   Sign in by buyer email and password
    ${seller_info}    Create Dictionary   email=${BUY_EMAIL}   password=${BUY_PASSWORD}
    set suite variable  ${seller_info}  ${seller_info}
    Mik Public Key - GET    ${seller_info}
    Get IPv4
    ${body}    get mik sign in secure body    ${mik_email_password}    ${ipv4}
    ${res}    Send Post Request Without Token    ${url-mik}    ${mik-sign-in-secure}    ${body}
    Mik Save Buyer Sign In Info    ${res}

Mik Save Buyer Sign In Info
    [Arguments]    ${res}
    Log    ${res.json()}
    ${data}     Get Json Value    ${res.json()}     data
    ${token}    get json value    ${data}    token
    ${buyer_session_id}    Get Json Value    ${data}    sessionId
    Run Keyword If    ${res.status_code==200}    Save Token By User Type    buyer    Bearer ${token}
    Save File    buyer-info-sign    ${data}
    ${buyer_user_id}     Get Json Value    ${data}     user    id
    Set Suite Variable    ${buyer_user_id}    ${buyer_user_id}
    Set Suite Variable    ${buyer_session-id}    ${buyer_session_id}

Mik Buyer Refresh Token - POST
    [Documentation]   Update the token to skip login process
    ${body}    create dictionary     sessionId=${buyer_session_id}
    ${headers}    Set Post Headers - Buyer
    ${res}    Send Post Request    ${url-mik}    ${mik-user-refresh-token}    ${body}    ${headers}
    Mik Save Buyer Sign In Info       ${res}

Mik Seller Sign In - POST
    Get IPv4
    ${email}     Get Json Value    ${seller_info_create}     email
    ${user-seller}    Create Dictionary    email=${email}    password=${pwd}
    ${body}    get mik sign in body   ${user-seller}    ${ipv4}
    ${res}    Send Post Request Without Token   ${url-mik}    ${mik-sign-in}    ${body}
    Mik Save Seller Sign In Info   ${res}

Mik Seller Sign In Scuse - POST
    [Documentation]   Sign in by seller email and password
    Get IPv4
    ${email}     Get Json Value    ${seller_info_create}     email
    ${user-seller}    Create Dictionary    email=${email}    password=${pwd}
    Mik Public Key - GET    ${user-seller}
    ${body}    get mik sign in secure body   ${mik_email_password}    ${ipv4}
    ${res}    Send Post Request Without Token   ${url-mik}    ${mik-sign-in-secure}    ${body}
    Mik Save Seller Sign In Info    ${res}

Mik Seller Sign In Scuse Of Order - POST
    [Arguments]    ${email}
    [Documentation]   Sign in by seller email and password
    Get IPv4
    ${user-seller}    Create Dictionary    email=${email}    password=${pwd}
    Mik Public Key - GET    ${user-seller}
    ${body}    get mik sign in secure body   ${mik_email_password}    ${ipv4}
    ${res}    Send Post Request Without Token   ${url-mik}    ${mik-sign-in-secure}    ${body}
    Mik Save Seller Sign In Info    ${res}

Mik Save Seller Sign In Info
    [Arguments]    ${res}
    Log    ${res.json()}
    ${data}     Get Json Value    ${res.json()}     data
    ${token}    Get Json Value    ${data}    token
    ${seller_session_id}    Get Json Value    ${data}    sessionId
    Save Token By User Type    seller    Bearer ${token}
    Save File    seller-info-sign    ${data}
    ${seller_user_id}     Get Json Value    ${data}     user    id
    Set Suite Variable    ${seller_info_sign}    ${data}
    Set Suite Variable    ${seller_user_id}    ${seller_user_id}
    Set Suite Variable    ${seller_session_id}    ${seller_session_id}

Mik Seller Refresh Token - POST
    [Documentation]   Update the token to skip login process
    ${seller_info_sign}    Read File    seller-info-sign
    Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}
    ${seller_session_id}    Get Json Value     ${seller_info_sign}     sessionId
    Set Suite Variable    ${seller_session_id}    ${seller_session_id}
    ${body}    create dictionary     sessionId=${seller_session_id}
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}    ${mik-user-refresh-token}    ${body}    ${headers}
    Mik Save Seller Sign In Info     ${res}

