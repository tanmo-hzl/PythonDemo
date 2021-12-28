*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Resource            ../../TestData/API_Portal/config.robot


*** Keywords ***

Send Get Request
    [Arguments]     ${url}     ${path}=    ${data}=     ${expected_status}=200
    ${headers}      Set Get Headers
    Create Session      alias       url=${url}      headers=${headers}      verify=${true}
    ${response}     GET On Session   alias     ${path}     params=${data}    verify=${True}     expected_status=${expected_status}
	[Return]    ${response}


Send Get Request By Read API
    [Arguments]     ${url}     ${path}=      ${data}=       ${expected_status}=200
    ${headers}      Set Read Headers
    Create Session      alias       url=${url}      headers=${headers}      verify=${true}
    ${response}     GET On Session   alias     ${path}     params=${data}    verify=${True}     expected_status=${expected_status}
	[Return]    ${response}


Set Get Headers
    ${headers}    Create Dictionary     Content-Type=application/json       User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0
    Set To Dictionary    ${headers}     Api-Key   ${api_key}
    [Return]    ${headers}


Set Read Headers
    ${headers}    Create Dictionary     Content-Type=application/json
    Set To Dictionary    ${headers}     Api-Key   ${read_api_key}
    [Return]    ${headers}


Send Post Request
	[Arguments]     ${url}      ${path}=      ${data}=      ${expected_status}=200
	${headers}      Set Get Headers
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}
	${response}    POST On Session    alias     ${path}     json=${data}    verify=${False}     expected_status=${expected_status}
	[Return]    ${response}


Send Post Request By Read API
	[Arguments]     ${url}      ${path}=      ${data}=      ${expected_status}=200
	${headers}      Set Read Headers
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}
	${response}    POST On Session    alias     ${path}     json=${data}    verify=${False}     expected_status=${expected_status}
	[Return]    ${response}

Send Query Post Request
	[Arguments]     ${url}      ${path}=      ${data}=      ${expected_status}=200
	${headers}      Set Get Headers
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}
	${response}    POST On Session    alias     ${path}     params=${data}    verify=${False}       expected_status=${expected_status}
	Log     ${response.text}
	[Return]    ${response}

Send Query Post Request By Read API
	[Arguments]     ${url}      ${path}=      ${data}=      ${expected_status}=200
	${headers}      Set Read Headers
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}
	${response}    POST On Session    alias     ${path}     params=${data}    verify=${False}       expected_status=${expected_status}
	[Return]    ${response}

Send Put Request
	[Arguments]     ${url}      ${path}=      ${data}=      ${expected_status}=200
	${headers}      Set Get Headers
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}
	${response}    PUT On Session   alias     ${path}     json=${data}    verify=${False}       expected_status=${expected_status}
	[Return]    ${response}

Send Put Request By Read API
	[Arguments]     ${url}      ${path}=      ${data}=      ${expected_status}=200
	${headers}      Set Read Headers
	Create Session      alias     url=${url}      headers=${headers}    verify=${True}
	${response}    PUT On Session   alias     ${path}     json=${data}    verify=${False}       expected_status=${expected_status}
	[Return]    ${response}


Send Upload Request
    [Arguments]     ${url}      ${path}=      ${data}=     ${contentype}=       ${expected_status}=200
    ${headers}    Create Dictionary     Api-Key=${api_key}      Content-Type=${contentype}
    Create Session      alias     url=${url}      headers=${headers}    verify=${True}
    ${response}    post on session    alias  ${url}   data=${data}      expected_status=${expected_status}
	[Return]    ${response}

Send Upload Request By Read API
    [Arguments]     ${url}      ${path}=      ${data}=     ${contentype}=       ${expected_status}=200
    ${headers}    Create Dictionary     Api-Key=${read_api_key}      Content-Type=${contentype}
    Create Session      alias     url=${url}      headers=${headers}    verify=${True}
    ${response}    post on session    alias  ${url}   data=${data}      expected_status=${expected_status}
	[Return]    ${response}