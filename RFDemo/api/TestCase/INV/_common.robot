*** Settings ***
Library    RequestsLibrary
Library    ../../Libraries/INV/SnowflakeId.py
Library    DateTime
Library    ../../Libraries/INV/common.py
Resource    ../../INVconfig.robot

*** Keywords ***
User Sign In
    [Arguments]    ${session}    ${user}=${buyer_user}    ${type}=user
    log  ${domain.format('${server}[${type}]')}
    create session    login    ${domain.format('${server}[${type}]')}    headers=${default_headers}    verify=True
    ${resp}    post on session    login    ${sign_in_path}[${type}]    json=${user}
    ${token}    set variable    ${resp.json()}[data][token]
    ${user_info}    Set Variable    ${resp.json()['data'].get('user')}
    ${user_id}   Set Variable IF    "${user_info}"=="${NONE}"    ${NONE}    ${user_info.get('id')}
    create session    ${session}    ${host}    headers=${default_headers}    verify=True
    ${token_type}    Set Variable if    "${type}"=="admin"    admin    Bearer
    update authory session    ${session}    ${token}    ${token_type}      # should append ${type}
    [Return]    ${user_id}    ${resp.json()}[data][token]

Update Authory Session
    [Arguments]    ${session}    ${token}    ${type}
    ${k}    set variable if    "admin" in "${type}"     Admin-Authorization    Authorization
    ${v}    set variable if    "bearer" in "${type}"    Bearer ${token}    ${token}
    &{data}    create dictionary   ${k}=${v}
    update session    ${session}    ${data}

Generate Order Num For Test
    [Arguments]    ${num}
    @{order_list}    generate bulk id    ${num}
    Set Test Variable    ${order_list}

Sort List By Key
    [Arguments]    ${input_list}   ${key}
    ${sorted}    Evaluate     sorted(${input_list}, key=lambda x: x["${key}"])
    [Return]    ${sorted}

Get Or Delete Inventroy Cache From Redis
    [Arguments]    ${session}    ${cache_type}    ${sku_number}    ${operate_type}    ${michaels_store_id}=-1
    Create Session    ${session}    ${domain.format("${server.admin}")}    headers=${default_headers}    verify=True
    ${resp}   POST On Session    ${session}    ${sign_in_path.admin}     json=&{scheduler}
    ${token}    Set Variable    ${resp.json()}[data][token]
    ${token}    Create Dictionary      admin-authorization=${token}
    Update Session    ${session}    ${token}
    log    ${cache_type}
    ${data}    inventory_cache    ${cache_type}    ${sku_number}    ${operate_type}    ${michaels_store_id}
    ${resp}    POST On Session    ${session}    ${redis.getredis}   json=${data}
    [Return]    ${resp.json()}

Get Or Delete Price Cache From Redis
    [Arguments]    ${session}    ${sku_number}    ${operate_type}    ${michaels_store_id}=-1
    Create Session    ${session}    ${domain.format("${server.admin}")}    headers=${default_headers}    verify=True
    ${resp}   POST On Session    ${session}    ${sign_in_path.admin}     json=&{scheduler}
    ${token}    Set Variable    ${resp.json()}[data][token]
    ${token}    Create Dictionary      admin-authorization=${token}
    Update Session    ${session}    ${token}
    ${data}    price_cache    ${sku_number}    ${operate_type}    ${michaels_store_id}
    ${resp}    POST On Session    ${session}    ${redis.getredis}   json=${data}
    [Return]    ${resp.json()}



Omni Sign In
    [Arguments]    ${session}    ${user_info}
    Create Session    ${session}    ${omni_sign_in_host}    ${default_headers}    verify=True
    ${header_update}    Create Dictionary    Authorization=Basic b21uaWNvbXBvbmVudC4xLjAuMDpiNHM4cmdUeWc1NVhZTnVu
    Update Session    ${session}    ${header_update}
    ${params}    omni_user_info    ${user_info}
    ${resp}    POST On Session    ${session}    ${omni_sign_in_path}    params=${params}
    [Return]    ${resp.json()}[access_token]

Get Omni Online Inventory
    [Arguments]    ${session}    @{skunumber}
    ${access_token}    Omni Sign In    omniuser    ${omni_user}
    Create Session   ${session}    ${omni_host}     ${default_headers}    verify=True
    ${header_update}    Create Dictionary    Authorization=Bearer ${access_token}
    Update Session    ${session}    ${header_update}
    ${data}    omni_online    ${skunumber}
    ${resp}    POST On Session    ${session}    ${omni_inventory.online_inventory}    json=${data}
    [Return]    ${resp.json()}

Call Scheduler
    [Documentation]    1.id=32:DeleteReservationScheduler
    [Arguments]    ${id}
    ${deviation}  Set Variable  ${4}
    Create Session  scheduler  ${domain.format('${server}[admin]')}  headers=${default_headers}    verify=True
    ${resp}    post on session    scheduler    ${sign_in_path}[admin]    json=${scheduler}
    ${token}    set variable    ${resp.json()}[data][token]
    ${headers}  Create Dictionary   Admin-Authorization=${token}
    update session  scheduler  headers=${headers}
    ${id}  Evaluate  int(${id})
    ${data}  Create Dictionary  id=${id}    executorParam=${EMPTY}
    ${utc}  DateTime.Get Current Date  UTC
    ${ts_start}  Convert Date  ${utc}  epoch
    POST On Session  scheduler  /dtsadmin/jobinfo/trigger  json=${data}  expected_status=200
    ${data}  Create Dictionary  jobId=${id}  length=10
    ${ts_latest}  Set Variable  0
    FOR  ${i}  IN RANGE  2
        ${result}  Set Variable  ${False}
        ${resp}  Get on Session  scheduler  /dtsadmin/joblog/pageList  params=${data}
        FOR  ${item}  IN  @{resp.json()}[content][data]
            ${dt}  Set Variable  ${item}[triggerTime]
            ${ts_resp}  Convert Date  ${dt[:-6].replace("T", " ")}  epoch
            ${ts_latest}  Evaluate  max(${ts_resp}, ${ts_latest})
            IF  ${ts_resp}>${ts_start} and ${item}[handleCode]==200
                ${result}  Set Variable  ${True}
                Exit For Loop
            END
        END
        Return From Keyword If  ${result}==${True}
        Sleep  1
    END
    log  ${ts_start}
    log  ${ts_latest}
    Return From Keyword If  ${ts_start}-${ts_latest}<${deviation}
#    Fail  Scheduler Not Executed

