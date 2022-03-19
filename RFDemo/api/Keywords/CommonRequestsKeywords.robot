*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../Libraries/Common.py
Resource            ../TestData/EnvData.robot

*** Variables ***
${timeout}    100

*** Keywords ***
Initial Env Data
    [Arguments]    ${config_name}=config.ini
    ${config}    Get Config Ini    ${ENV.lower()}    ${config_name}
    ${item}    Set Variable
    FOR    ${item}    IN    &{config}
        LOG    ${item[0]}
        Set Suite Variable    ${${item[0]}}    ${item[1]}
    END

Set Post Headers - B2B - Michaels
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	${token}   Read File    token-michaels
	Set To Dictionary    ${headers}     Authorization   Bearer ${token}
	[Return]    ${headers}

Set Get Headers - B2B - Michaels
	${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
	${token}   Read File    token-michaels
	Set To Dictionary    ${headers}     Authorization   Bearer ${token}
	[Return]    ${headers}

Add Admin Token To Headers - B2B - Michaels
    [Arguments]    ${headers}
    ${token}   Read File    token-michaels
	Set To Dictionary    ${headers}     Admin-Authorization    ${token}
	[Return]    ${headers}


Set Post Headers - Developer
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	Set To Dictionary    ${headers}     Api-Key   ${api-key}
	[Return]    ${headers}

Set Get Headers - Developer
    ${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
    Set To Dictionary    ${headers}     Api-Key   ${api-key}
    [Return]    ${headers}

Set Post Headers
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	[Return]    ${headers}

Set Post Headers - Admin
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	${token}   Read File    token-admin
	Set To Dictionary    ${headers}     Admin-Authorization   ${token}
	[Return]    ${headers}

Set Post Headers - Buyer
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	${token}   Read File    token-buyer
	Set To Dictionary    ${headers}     authorization   ${token}
	[Return]    ${headers}

Set Post Headers - B2B - User
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	${token}   Read File    token-b2b-user
	Set To Dictionary    ${headers}     authorization   ${token}
	[Return]    ${headers}

Set Post Headers - Seller
	${headers}    Create Dictionary     Content-Type=application/json;charset=UTF-8     User-Agent=Custom
	${token}   Read File    token-seller
	Set To Dictionary    ${headers}     authorization   ${token}
	[Return]    ${headers}

Set Get Headers
    ${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
    [Return]    ${headers}

Set Get Headers - Admin
    ${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
	${token}   Read File    token-admin
    Set To Dictionary    ${headers}     Admin-Authorization   ${token}
    [Return]    ${headers}

Set Get Headers - Buyer
    ${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
	${token}   Read File    token-buyer
    Set To Dictionary    ${headers}     Authorization   ${token}
    [Return]    ${headers}

Set Get Headers - B2B - User
    ${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
	${token}   Read File    token-b2b-user
    Set To Dictionary    ${headers}     Authorization   ${token}
    [Return]    ${headers}

Set Get Headers - Seller
    ${headers}    Create Dictionary     Content-Type=text/html;charset=utf-8     User-Agent=Custom
	${token}   Read File    token-seller
    Set To Dictionary    ${headers}     Authorization   ${token}
    [Return]    ${headers}

Send Delete Request
	[Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    Delete On Session    alias     ${path}     json=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Delete Request - Params
	[Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    Delete On Session    alias     ${path}     params=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Put Request
	[Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    Put On Session    alias     ${path}     json=${data}    verify=${False}        expected_status=${status}
	[Return]    ${response}

Send Patch Request
	[Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    PATCH On Session    alias     ${path}     json=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Patch Request - Params
	[Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    PATCH On Session    alias     ${path}     params=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Patch Request - Params And Json
	[Arguments]     ${url}      ${path}      ${params}    ${json}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    PATCH On Session    alias     ${path}     params=${params}    json=${json}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Post Request
	[Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    POST On Session    alias     ${path}    json=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Post Request - Params
	[Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    POST On Session    alias     ${path}    params=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Post Request - Params And Json
	[Arguments]     ${url}      ${path}      ${params}    ${json}    ${headers}    ${status}=200
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
    ${response}    POST On Session    alias     ${path}    params=${params}    json=${json}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Post Request Without Token
	[Arguments]     ${url}      ${path}    ${data}    ${status}=200
	${headers}    Set Post Headers
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}    timeout=${timeout}
	${response}    POST On Session    alias     ${path}     json=${data}    verify=${False}    expected_status=${status}
	[Return]    ${response}

Send Get Request
    [Arguments]     ${url}      ${path}      ${data}    ${headers}    ${status}=200
    Create Session      alias       url=${url}      headers=${headers}      verify=${True}    timeout=${timeout}
    ${response}     GET On Session    alias     ${path}     params=${data}    verify=${False}    expected_status=${status}
    Should Not Be Empty    ${response.text}
	[Return]    ${response}

Send Get Request Without Token
    [Arguments]     ${url}      ${path}      ${data}    ${status}=200
    ${headers}      Set Get Headers
    Create Session      alias       url=${url}      headers=${headers}      verify=${True}    timeout=${timeout}
    ${response}     GET On Session    alias     ${path}     params=${data}    verify=${False}    expected_status=${status}
    Should Not Be Empty    ${response.text}
	[Return]    ${response}

Send Request Http
    [Arguments]    ${method}     ${url}      ${path}    ${json}    ${params}    ${headers}    ${status}=200
    ${request_method}    Create Dictionary    GET=GET    POST=POST On Session    DELETE=DELETE On Session    PUT=PUT On Session    PATCH=PATCH On Session
    ${request_keywords}    get from dictionary    ${request_method}    ${method}
    ${headers}      Set Get Headers
    Create Session      alias       url=${url}      headers=${headers}      verify=${True}    timeout=${timeout}
    ${response}    ${method} On Session    alias    url=${path}     params=${params}    json=${json}    verify=${False}    expected_status=${status}
    Should Not Be Empty    ${response.text}
	[Return]    ${response}
