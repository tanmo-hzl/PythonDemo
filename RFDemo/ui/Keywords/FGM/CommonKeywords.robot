*** Settings ***
Library     ../../Libraries/FGM/CommonLib.py
Resource    ../../TestData/EnvData.robot
Resource    ../../TestData/FGM/FGMCommonPageData.robot


*** Variables ***
${ENV}                         qa    # tst03 ==> qa    tst02 ==> stg
${URL_MIK}                     https://mik.${env}.platform.michaels.com
${Waiting_Time}                30
${Snapmail.cc}                 https://www.snapmail.cc/#/
${URL_SIGN_IN}                 ${URL_MIK}/signin?returnUrl=/
${URL_FGM_SELL}                ${URL_MIK}/fgm/sell
${URL_DASHBOARD}               ${URL_MIK}/fgm/sellertools/dashboard


*** Keywords ***
User Sign In - FGM
    [Arguments]    ${email}    ${pwd}    ${name}
    Go To       ${URL_DASHBOARD}
    Wait Until Element Is Visible    //input[@id="email"]
    Input Text    //input[@id="email"]        ${email}
    Sleep   1
    Input Text    //input[@id="password"]     ${pwd}
    Sleep   1
    Click Element  //div[text()="SIGN IN"]/parent::button[@type="submit"]
    Wait Until Element Is Visible    //p[text()='${name}']


Environ Browser Selection And Setting
    [Arguments]   ${ENV}   ${BROWSER}   ${URL}=${URL_MIK}
    IF   "${BROWSER}" == "Chrome"
        Open Browser    ${URL}    ${BROWSER}
    ELSE IF  "${BROWSER}" == "Firefox"
        ${Firefox Profile}   Create Profile
        ${Cap Profile}       Desired Capabilities Setting
        Open Browser    ${URL}    ${BROWSER}    desired_capabilities=${Cap Profile}   ff_profile_dir=${Firefox Profile}
    END
    Set Selenium Timeout    ${Waiting_Time}
    Maximize Browser Window


Go To Expect Url Page
    [Arguments]    ${status}=DONE   ${type}=seller   ${key}=das
    ${now_url}   Get Location
    IF    '${status}'=='PASS'
        Log    ${now_url}
    ELSE
        ${path}    Set Variable
        IF    '${type}'=='seller'
            ${path}    Set Variable    ${SELLER_BASE_URL}${SELLER_URLS}[${key}]
#        ELSE IF  '${type}'=='buyer'
#            ${path}    Set Variable    ${BUYER_BASE_URL}${BUYER_URLS}[${key}]
        ELSE
            ${path}    Set Variable    /fgm/sellertools/my-product-listings
        END

        ${expect_url}    Set Variable    ${URL_MIK}${path}
        IF   '${status}'=='FAIL' or '${status}'=='SKIP'
            IF    '${now_url}'!='${expect_url}'
                Reload Page
                Go To    ${expect_url}
            ELSE
                Reload Page
            END
        ELSE IF   '${status}'=='DONE'
            Go To   ${expect_url}
        END
    END