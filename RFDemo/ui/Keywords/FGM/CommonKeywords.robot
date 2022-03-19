*** Settings ***
Library    ../../Libraries/FGM/CommonLib.py


*** Variables ***
${ENV}                         qa    # tst03 ==> qa    tst02 ==> stg
${URL_MIK}                     https://mik.${env}.platform.michaels.com
${Waiting_Time}                20
${Snapmail.cc}                 https://www.snapmail.cc/#/
${URL_SIGN_IN}                 ${URL_MIK}/signin?returnUrl=/
${URL_FGM_SELL}                ${URL_MIK}/fgm/sell
${URL_DASHBOARD}               ${URL_MIK}/fgm/sellertools/dashboard


*** Keywords ***
User Sign In
    [Arguments]    ${email}    ${pwd}    ${name}
    Go To       ${URL_DASHBOARD}
    Wait Until Element Is Visible    //input[@id="email"]
    Input Text    //input[@id="email"]        ${email}
    Sleep   1
    Input Text    //input[@id="password"]     ${pwd}
    Sleep   1
    Click Element  //div[text()="SIGN IN"]/parent::button[@type="submit"]
    Wait Until Element Is Visible    //p[text()='${name}']    30


Environ Browser Selection And Setting
    [Arguments]   ${ENV}   ${BROWSER}   ${URL}=${URL_MIK}
    IF   "${BROWSER}" == "Chrome"
        Open Browser    ${URL}    ${BROWSER}
    ELSE IF  "${BROWSER}" == "Firefox"
        ${Firefox Profile}   Create Profile
        ${Cap Profile}       Desired Capabilities Setting
        Open Browser    ${URL}    ${BROWSER}    desired_capabilities=${Cap Profile}   ff_profile_dir=${Firefox Profile}
    END
    Maximize Browser Window