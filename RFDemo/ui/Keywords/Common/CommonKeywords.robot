*** Settings ***
Library        SeleniumLibrary
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/CustomSeleniumKeywords.py    run_on_failure=Capture Screenshot and embed it into the report    implicit_wait=0.2 seconds
Resource       ../../TestData/EnvData.robot
Resource       ../../TestData/MP/EACommonPageData.robot

*** Variables ***
${Cur_Case_Status}    ${True}
${Par_Case_Status}    PASS
${Fail_Skip}    ${True}

*** Keywords ***
Initial Env Data
    [Arguments]    ${config_name}=config.ini
    Set Library Search Order    CustomSeleniumKeywords
    Set Selenium Timeout     ${TIME_OUT}
    ${config}    Get Config Ini    ${ENV}    ${config_name}
    ${item}    Set Variable
    FOR    ${item}    IN    &{config}
        LOG    ${item[0]}
        Set Suite Variable    ${${item[0]}}    ${item[1]}
    END
    ${RETURN_OR_ENTER}    Return Or Enter Key
    Set Suite Variable    ${RETURN_OR_ENTER}   ${RETURN_OR_ENTER}
    ${CTRL_OR_COMMAND}    Ctrl Or Command Key
    Set Suite Variable    ${CTRL_OR_COMMAND}   ${CTRL_OR_COMMAND}

Initial Data And Open Browser
    [Arguments]    ${url}    ${brower_name}=buyer
    Initial Env Data
    Set Selenium Timeout     ${TIME_OUT}
    Open Browser    ${url}    ${BROWSER}    ${brower_name}
    Sleep   1
    Maximize Browser Window

Open Browser - MP
    [Arguments]    ${brower_name}=buyer
    Initial Env Data
    Set Selenium Timeout     ${TIME_OUT}
    Open Browser    ${URL_MIK}    ${BROWSER}    ${brower_name}
    Sleep   1
    Maximize Browser Window

User Sign In - MP
    [Arguments]    ${email}    ${pwd}    ${name}
    Sleep    3
    ${count}    Get Element Count    //p[text()='Sign In']
    IF    '${count}'=='1'
        Wait Until Element Is Visible    //p[text()='Sign In']
        Click Element  //*[text()='Sign In']
    END
    Wait Until Element Is Visible    //input[@id="email"]
    Input Text    //input[@id="email"]     ${email}
    Sleep   1
    Input Text    //input[@id="password"]     ${pwd}
    Sleep   1
    Click Element  //div[text()="SIGN IN"]/parent::button[@type="submit"]
    Set Suite Variable    ${Cur_User_Name}    ${name}
    Wait Until Page Contains Element    //p[text()='${Cur_User_Name}']    30
#    Reload Page

Clear Element Value
    [Arguments]    ${element}
    Click Element    ${element}
    Press Keys     None     ${CTRL_OR_COMMAND}+A
    Press Keys     None     DELETE

Open Browser With URL
    [Arguments]    ${URL}    ${URL_ALIAS}=alias
    Set Selenium Timeout     ${TIME_OUT}
    Open Browser    ${URL}    ${BROWSER}    ${URL_ALIAS}
    Maximize Browser Window

Scroll Last Button Into View
    Execute Javascript    var count = document.querySelectorAll("button[type=button]"); count[count.length-1].scrollIntoView();
    Sleep    0.5

Click Close Icon In Top Right-hand Corner
    Execute Javascript    document.querySelector("button[aria-label=close]").scrollIntoView()
    Sleep    0.5
    Execute Javascript    document.querySelector("button[aria-label=close]").click()

Wait Loading Hidden
    Sleep    0.5
    Wait Until Element Is Not Visible    //*[@id="stepcolors"]
    Sleep    0.5

Go To Expect Url Page
    [Arguments]    ${status}=DONE   ${type}=buyer   ${key}=das
    ${now_url}   Get Location
    IF    '${status}'=='PASS'
        Log    ${now_url}
    ELSE
        ${path}    Set Variable
        IF    '${type}'=='seller'
            ${path}    Set Variable    ${SELLER_BASE_URL}${SELLER_URLS}[${key}]
        ELSE IF  '${type}'=='buyer'
            ${path}    Set Variable    ${BUYER_BASE_URL}${BUYER_URLS}[${key}]
        ELSE
            ${path}    Set Variable    ${COMMON_URLS}[${key}]
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

Common - Select Date By Element
    [Documentation]    ele is element xpath path
    [Arguments]    ${date_time}    ${ele}
    ${times}    Evaluate    str('${date_time}').split("-")
    ${en_month}    Get En Month    ${times}[1]    ${True}
    Click Element    ${ele}
    ${base_ele}     Set Variable    ${ele}/following-sibling::div\[@class="rdtPicker"\]
    Wait Until Element Is Visible    ${base_ele}
    Double Click Element     ${base_ele}//th\[@class="rdtSwitch"\]
    Sleep    0.5
    Wait Until Element Is Visible    ${base_ele}//td\[@data-value="${times[0]}"\]
    Click Element    ${base_ele}//td\[@data-value="${times[0]}"\]
    Sleep    0.5
    Wait Until Element Is Visible    ${base_ele}//td\[text()="${en_month}"\]
    Click Element    ${base_ele}//td\[text()="${en_month}"\]
    Sleep    0.5
    ${day}    Evaluate    int('${times[2]}')
    Wait Until Element Is Visible    ${base_ele}//td\[@data-value="${day}"\]
    Click Element    ${base_ele}//td\[@data-value="${day}"\]
    Wait Until Element Is Not Visible    ${base_ele}


Close Dialog If Existed
    Wait Until Element Is Visible    //*[@id="attentive_creative"]
    Sleep    1
    Select Frame    //*[@id="attentive_creative"]
    ${count}    Get Element Count    //div[@role="dialog"]//span[text()="CONTINUE"]/../parent::button
    IF    ${count}>0
        Click Element    //div[@role="dialog"]//button[@id="closeIconContainer"]
    END
    Unselect Frame
    Sleep    1

Common - Check Page Contain Fixed Element
    [Arguments]    ${fixed_ele}    ${status}=${None}
    ${item}   Set Variable
    FOR    ${item}    IN    @{fixed_ele}
        ${item_ele}    Set Variable    ${fixed_ele}[${item}]
        ${ele}    Set Variable
        ${is_attrs}    Evaluate    '${item}'.startswith("@")
        ${is_status}    Evaluate    '${item}'.startswith("!status")
        IF    "${is_attrs}"=="${True}"
            FOR    ${ele}    IN    @{item_ele}
                Page Should Contain Element     //*\[${item}="${ele}"\]
            END
        ELSE IF  '${is_status}'=='${True}'
            ${status_fixed_ele}    Get Json Value    ${fixed_ele}    !status    ${status}
                Common - Check Page Contain Fixed Element    ${status_fixed_ele}
        ELSE IF  '${item}'=='!contains'
            FOR    ${ele}    IN    @{item_ele}
                Page Should Contain Element     //*[contains(text(),"${ele}")]
            END
        ELSE IF  '${item}'=='!remove'
            FOR    ${ele}    IN    @{item_ele}
                Page Should Not Contain Element     //*[contains(text(),"${ele}")]
            END
        ELSE
            FOR    ${ele}    IN    @{item_ele}
                Page Should Contain Element     //${item}\[text()="${ele}"\]
            END
        END
    END
