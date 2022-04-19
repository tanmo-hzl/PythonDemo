*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/CommonLibrary.py
Library             ../../Libraries/CommonRSA.py
Resource            ../../TestData/EnvData.robot

*** Variables ***
${Rsa_Email_Pwd}
${Headers_Get_Seller}
${Headers_Post_Seller}
${Headers_Get_Buyer}
${Headers_Post_Buyer}

*** Keywords ***
Set Post Headers
    [Arguments]    ${token}=${None}
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	IF    "${token}"!="${None}"
	    Set To Dictionary    ${headers}     Authorization   Bearer ${token}
	END
	[Return]    ${headers}

Set Get Headers
    [Arguments]    ${token}=${None}
    ${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
	IF    "${token}"!="${None}"
	    Set To Dictionary    ${headers}     Authorization   Bearer ${token}
	END
    [Return]    ${headers}

Send Get Request
    [Arguments]     ${url}      ${path}      ${data}=${null}    ${headers}=${None}    ${status}=200
    IF    "${headers}"=="${None}"
        ${headers}    Set Get Headers    ${None}
    END
    Create Session      alias       url=${url}      headers=${headers}      verify=${True}    timeout=${timeout}
    ${response}     GET On Session    alias     ${path}     params=${data}    verify=${False}    expected_status=${status}
    Should Not Be Empty    ${response.text}
	[Return]    ${response}

Send Post Request
	[Arguments]     ${url}      ${path}      ${data}    ${headers}=${None}    ${status}=200
    IF    "${headers}"=="${None}"
        ${headers}    Set Post Headers    ${None}
    END
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    POST On Session    alias     ${path}    json=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Delete Request
	[Arguments]     ${url}      ${path}      ${data}    ${headers}=${None}    ${status}=200
    IF    "${headers}"=="${None}"
        ${headers}    Set Post Headers    ${None}
    END
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}     Delete On Session    alias     ${path}    json=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}


Mik - Get Public Key And Encrypt Account Info
    [Arguments]    ${user}
    ${res}    Send Get Request   ${API_HOST_MIK}    /usr/user/get-public-key
    ${mik_public_data}    Get Json Value    ${res.json()}    data
    ${public_key}    Get Json Value    ${mik_public_data}    publicKey
    ${server_time}    Get Json Value    ${mik_public_data}    serverTime
    Set To Dictionary    ${user}      serverTime    ${server_time}
    ${rsa_email_pwd}    Rsa Encrypt Sha256 Msg By Key    ${public_key}    ${user}
    ${rsa_email_pwd}    Str To Url Encode    ${rsa_email_pwd}
    Set Suite Variable    ${Rsa_Email_Pwd}    ${rsa_email_pwd}

Mik - User Sign In By Secure - POST
    [Arguments]    ${email}    ${pwd}
    ${user_account}    Create Dictionary    email=${email}    password=${pwd}
    Mik - Get Public Key And Encrypt Account Info    ${user_account}
    ${body}    Create Dictionary   emailPassword=${rsa_email_pwd}    deviceUuid="79185788-882b-47db-b355-91a0a2ed9339"
    ...    deviceType=0    deviceName="Chrome"    loginAddress="172.105.37.5"
    ${res}    Send Post Request   ${API_HOST_MIK}    /usr/user/sign-in-secure    ${body}
    ${data}     Get Json Value    ${res.json()}     data
    [Return]    ${data}

Mik - Set Seller Suite Variables
    [Arguments]    ${data}
    ${token}    Get Json Value    ${data}    token
    ${Headers_Get_Seller}     Set Get Headers    ${token}
    ${Headers_Post_Seller}    Set Post Headers    ${token}
    ${Seller_Store_Id}     Get Json Value     ${data}    sellerStoreProfile    sellerStoreId
    Set Suite Variable    ${Headers_Get_Seller}    ${Headers_Get_Seller}
    Set Suite Variable    ${Headers_Post_Seller}    ${Headers_Post_Seller}
    Set Suite Variable    ${Seller_Store_Id}    ${Seller_Store_Id}
    Set Suite Variable    ${Seller_Info}    ${data}

Mik - Set Buyer Suite Variables
    [Arguments]    ${data}
    ${token}    Get Json Value    ${data}    token
    ${Headers_Get_Buyer}     Set Get Headers    ${token}
    ${Headers_Post_Buyer}    Set Post Headers    ${token}
    ${Buyer_Id}     Get Json Value     ${data}    user    id
    Set Suite Variable    ${Headers_Get_Buyer}    ${Headers_Get_Buyer}
    Set Suite Variable    ${Headers_Post_Buyer}    ${Headers_Post_Buyer}
    Set Suite Variable    ${Buyer_Id}    ${Buyer_Id}
    Set Suite Variable    ${Buyer_Info}    ${data}