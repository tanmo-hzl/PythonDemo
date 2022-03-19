*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/CommonRSA.py
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Library             ../../Libraries/CPM/RequestBodyUser.py
Library             ../../Libraries/CPM/RequestBodyPayment.py
Library             ../../TestData/CPM/ProductsInfo.py

*** Variables ***
${User_Inof}
${Headers}
${EMAIL}
${PWD}
${initpayments}
${AdminHeaders}

*** Keywords ***
Set Initial Data - MIK - User
    Initial Env Data     configCPM.ini
    Set Suite Variable    ${EMAIL}    ${email}
    Set Suite Variable    ${PWD}    ${password}
    Set Initial Data - MAP - Admin
    ${resp}    Send Get Request Without Token    ${URL-USR}    /user/get-public-key     ${null}
    ${public_key}    Get Json Value    ${resp.json()}    data    publicKey
    ${server_time}    Get Json Value    ${resp.json()}    data    serverTime
    ${user_data}    Create Dictionary    email=${EMAIL}    password=${PWD}    serverTime=${server_time}
    ${email_password}    encrypt    ${user_data}    ${public_key}
    ${payload}    get buyer body    ${email_password}
    ${sign_resp}    Send Post Request Without Token    ${URL-USR}    /user/sign-in-secure    ${payload}
    ${user_info}    Get Json Value    ${sign_resp.json()}    data
    Set Suite Variable    ${User_Inof}    ${user_info}
    ${token}    Get Json Value    ${user_info}    token
    ${headers}   get headers   ${token}
    Set Suite Variable    ${Headers}    ${headers}
    ${user_id}    get json value    ${User_Inof}    user    id
    ${initpayments}    init_payment    ${URL-FIN}    ${user_id}    ${Headers}
    Set Suite Variable    ${initpayments}    ${initpayments}

Set Initial Data - MIK - Guest
    Set Initial Data - MAP - Admin
    ${payload}    create_guest_user
    ${guest_resp}    Send Post Request Without Token    ${URL-USR}    /user/v2/create-guest-user    ${payload}
    ${user_info}    Get Json Value    ${guest_resp.json()}    data
    Set Suite Variable    ${User_Inof}    ${user_info}
    ${token}    Get Json Value    ${user_info}    token
    ${headers}   get headers   ${token}
    Set Suite Variable    ${Headers}    ${headers}
    ${initpayments}    init_payment    ${URL-FIN}    ${null}    ${Headers}
    Set Suite Variable    ${initpayments}    ${initpayments}

Set Initial Data - MAP - Admin
    Initial Env Data     configCPM.ini
    Set Suite Variable    ${ADMINEMAIL}    ${adminemail}
    Set Suite Variable    ${ADMINPWD}    ${adminpassword}
    ${resp}    Send Get Request Without Token    ${URL-MAP}    /michaels-user/get-public-key     ${null}
    ${public_key}    Get Json Value    ${resp.json()}    data    publicKey
    ${server_time}    Get Json Value    ${resp.json()}    data    serverTime
    ${user_data}    Create Dictionary    email=${ADMINEMAIL}    password=${ADMINPWD}    serverTime=${server_time}
    ${email_password}    encrypt    ${user_data}    ${public_key}
    ${payload}    Create Dictionary    emailPassword=${email_password}
    ${sign_resp}    Send Post Request Without Token    ${URL-MAP}    /michaels-user/sign-in-secure    ${payload}
    ${user_info}    Get Json Value    ${sign_resp.json()}    data
    ${token}    Get Json Value    ${user_info}    token
    ${headers}   get_admin_headers   ${token}
    Set Suite Variable    ${AdminHeaders}    ${headers}
    ${skus}    get skus
    list_inventory    ${skus}    ${URL}    ${AdminHeaders}

Sign in - MIK - User
    ${signinfo}    create_email    ${URL-USR}
    ${email}    get from dictionary    ${signinfo}    email
    ${password}    get from dictionary    ${signinfo}    password
    Set Suite Variable    ${EMAIL}    ${email}
    Set Suite Variable    ${PWD}    ${password}
    ${resp}    Send Get Request Without Token    ${URL-USR}    /user/get-public-key     ${null}
    ${public_key}    Get Json Value    ${resp.json()}    data    publicKey
    ${server_time}    Get Json Value    ${resp.json()}    data    serverTime
    ${user_data}    Create Dictionary    email=${EMAIL}    password=${PWD}    serverTime=${server_time}
    ${email_password}    encrypt    ${user_data}    ${public_key}
    ${payload}    get buyer body    ${email_password}
    ${sign_resp}    Send Post Request Without Token    ${URL-USR}    /user/sign-in-secure    ${payload}
    ${user_info}    Get Json Value    ${sign_resp.json()}    data
    Set Suite Variable    ${User_Inof}    ${user_info}
    ${token}    Get Json Value    ${user_info}    token
    ${headers}   get headers   ${token}
    Set Suite Variable    ${Headers}    ${headers}
    ${user_id}    get json value    ${User_Inof}    user    id

Sign in ENV - MIK -User
    Initial Env Data     configCPM.ini
    Set Suite Variable    ${EMAIL}    ${email}
    Set Suite Variable    ${PWD}    ${password}
    ${resp}    Send Get Request Without Token    ${URL-USR}    /user/get-public-key     ${null}
    ${public_key}    Get Json Value    ${resp.json()}    data    publicKey
    ${server_time}    Get Json Value    ${resp.json()}    data    serverTime
    ${user_data}    Create Dictionary    email=${EMAIL}    password=${PWD}    serverTime=${server_time}
    ${email_password}    encrypt    ${user_data}    ${public_key}
    ${payload}    get buyer body    ${email_password}
    ${sign_resp}    Send Post Request Without Token    ${URL-USR}    /user/sign-in-secure    ${payload}
    ${user_info}    Get Json Value    ${sign_resp.json()}    data
    Set Suite Variable    ${User_Inof}    ${user_info}
    ${token}    Get Json Value    ${user_info}    token
    ${headers}   get headers   ${token}
    Set Suite Variable    ${Headers}    ${headers}

Sign in ENV and Initial - MIK -User
    Initial Env Data     configCPM.ini
    Set Suite Variable    ${EMAIL}    ${email}
    Set Suite Variable    ${PWD}    ${password}
    Set Initial Data - MAP - Admin
    ${resp}    Send Get Request Without Token    ${URL-USR}    /user/get-public-key     ${null}
    ${public_key}    Get Json Value    ${resp.json()}    data    publicKey
    ${server_time}    Get Json Value    ${resp.json()}    data    serverTime
    ${user_data}    Create Dictionary    email=${EMAIL}    password=${PWD}    serverTime=${server_time}
    ${email_password}    encrypt    ${user_data}    ${public_key}
    ${payload}    get buyer body    ${email_password}
    ${sign_resp}    Send Post Request Without Token    ${URL-USR}    /user/sign-in-secure    ${payload}
    ${user_info}    Get Json Value    ${sign_resp.json()}    data
    Set Suite Variable    ${User_Inof}    ${user_info}
    ${token}    Get Json Value    ${user_info}    token
    ${headers}   get headers   ${token}
    Set Suite Variable    ${Headers}    ${headers}


