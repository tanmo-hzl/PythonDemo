*** Settings ***
Library        SeleniumLibrary
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/CustomSeleniumKeywords.py    run_on_failure=Capture Screenshot and embed it into the report
Resource       ../../TestData/EnvData.robot
Resource       ../../TestData/MP/EACommonPageData.robot

*** Variables ***
${Cur_Case_Status}      ${True}
${Par_Case_Status}      PASS
${Fail_Skip}            ${True}
${Custom_Chrome_Download_Path}

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

Open And Reset Downloads Directory For Chrome
    [Documentation]  reset chromewebdriver  download.default_directory
    [Arguments]    ${url}    ${dir_name}
    ${custom_chrome_download_path}    Create Custom Downloads Directory    ${dir_name}
    Set Suite Variable    ${Custom_Chrome_Download_Path}    ${custom_chrome_download_path}
    ${prefs}    Create Dictionary    download.default_directory=${custom_chrome_download_path}
    ${chrome_options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    Create Webdriver    ${BROWSER}    chrome_options=${chrome_options}
    Go To    ${url}
    Maximize Browser Window

Remove Created Custom Downloads Directory
    Remove Custom Downloads Directory    ${Custom_Chrome_Download_Path}

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
    Wait Until Page Contains Elements Ignore Ad    //p[text()='${Cur_User_Name}']    30

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
    ${month}    Evaluate    int('${times[1]}')-1
    Wait Until Element Is Visible    ${base_ele}//td\[@data-value="${day}"\]
    Click Element    ${base_ele}//td\[@data-value="${day}" and @data-month="${month}"\]
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
            IF    ${status_fixed_ele}!=${None}
                Common - Check Page Contain Fixed Element    ${status_fixed_ele}
            END
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

Common - Page Turning
    [Documentation]    to_page: Previous,Next,First,Last,1,2,3,...
    [Arguments]    ${to_page}=Next
    Wait Until Page Contains Element    //*[@aria-label="Previous Page"]
    Scroll Element Into View    //*[@aria-label="Previous Page"]
    IF    "${to_page}"=="Next"
        Click Element    //*[@aria-label="Next Page"]
    ELSE IF  "${to_page}"=="Previous"
        Click Element    //*[@aria-label="Previous Page"]
    ELSE IF      "${to_page}"=="First"
        ${page_count}    Get Element Count    //*[@id="page-1"]
        IF    ${page_count}>0
            Click Element    //*[@id="page-1"]
        END
    ELSE IF      "${to_page}"=="Last"
        ${page_count}    Get Element Count    //*[starts-with(@id,"page-")]
        IF    ${page_count}>0
            Click Element    //*[starts-with(@id,"page-")]\[${page_count}\]
        END
    ELSE
        ${count}    Get Element Count    //*[@id="page-${to_page}"]
        IF    ${count}>0
            Click Element    //*[@id="page-${to_page}"]
        END
    END
    Wait Loading Hidden
    Sleep    1

Common - Filter Select Date Range
    [Arguments]    ${ele}    ${date_range}    ${close_btn}=${True}
    Click Element    ${ele}
    Wait Until Element Is Visible    //*[text()="Sun"]
    ${now_date}    Get Current Date     result_format=%Y-%m-%d
    ${now}    Evaluate    "${now_date}".split("-")
    Click Element    //div[contains(@class,"rmdp-day-picker")]//span[text()="${now}[2]"]
    ${startDate}    Add Time To Date     ${now_date}    ${date_range[0]} days
    ${start}    Evaluate    '${startDate}'\[:10\].split("-")
    ${endDate}    Add Time To Date     ${now_date}    ${date_range[1]} days
    ${end}    Evaluate    '${endDate}'\[:10\].split("-")
    ${s_month}      Get En Month    ${start}[1]
    ${e_month}      Get En Month    ${end}[1]
    ${s_day}    Evaluate    int("${start}[2]")
    ${e_day}    Evaluate    int("${end}[2]")
    Private - Selected Year Month And Day    ${start[0]}    ${s_month}    ${s_day}
    Private - Selected Year Month And Day    ${end[0]}      ${e_month}    ${e_day}
    IF    "${close_btn}"=="${True}"
        Click Element    //*[contains(@class,"rmdp-container")]//button
    END
    ${filter_date_range}    Create List    ${startDate}    ${endDate}
    [Return]    ${filter_date_range}

Private - Selected Year Month And Day
    [Arguments]    ${year}    ${month}    ${day}
    Click Element    //*[@class="rmdp-header-values"]/span[1]
    Wait Until Element Is Visible    //div[@class="rmdp-month-picker"]//span[text()="${month}"]
    Sleep    0.5
    Click Element    //div[@class="rmdp-month-picker"]//span[text()="${month}"]
    Click Element    //*[@class="rmdp-header-values"]/span[2]
    Wait Until Element Is Visible    //div[@class="rmdp-year-picker"]//span[text()="${year}"]
    Sleep    0.5
    Click Element    //div[@class="rmdp-year-picker"]//span[text()="${year}"]
    Sleep    0.5
    Click Element    //div[contains(@class,"rmdp-day-picker")]//span[text()="${day}"]

Common - Scroll Down Until Page Contains Elements
    [Arguments]    ${ele_xpath}    ${scroll_times}=5    ${sleep_time}=0.5
    ${w}    ${h}    Get Window Size
    FOR    ${index}    IN RANGE    1    ${${scroll_times}+1}
        ${scorll_top}     Evaluate    ${h}*${index}
        Execute Javascript    document.body.scrollTop=${scorll_top}
        Sleep    ${sleep_time}
        ${count}    Get Element Count    ${ele_xpath}
        Exit For Loop If    ${count}==1
    END
    IF    ${count}==0
        Fail    Page Not Contans Elements ${ele_xpath}
    END

Common - Click Table Header Text To Sort Data
    [Arguments]    ${text}    ${first_click}=${True}    ${icon_following_sibling}=${True}
    ${text_ele}    Set Variable    //table/thead//th//*[text()="${text}"]
    Click Element    ${text_ele}
    Wait Loading Hidden
    Sleep    1
    IF    "${icon_following_sibling}"=="${True}"
        ${base_ele}    Set Variable    ${text_ele}/following-sibling::*
    ELSE
        ${base_ele}    Set Variable    ${text_ele}/following-sibling::*/*
    END
    IF    "${first_click}"=="${True}"
        Wait Until Element Is Visible    ${base_ele}\[contains(@class,"icon-tabler-chevron-down")\]
        ${sort_down}    Set Variable    ${False}
    ELSE
        Wait Until Element Is Visible    ${base_ele}\[contains(@class,"icon-tabler-chevron-up")\]
        ${sort_down}    Set Variable    ${True}
    END
    [Return]    ${sort_down}

Common - Check Sort Data After Click Table Header Text
    [Arguments]    ${text}    ${first_click}    ${icon_following_sibling}    ${th_index}    ${date_type}
    Common - Page Turning    First
    ${first_click}    Set Variable If    "${first_click}"=="firstClick"    ${True}    ${False}
    ${icon_following_sibling}    Set Variable If    "${icon_following_sibling}"=="iconFollow"    ${True}    ${False}
    ${sort_down}    Common - Click Table Header Text To Sort Data     ${text}    ${first_click}    ${icon_following_sibling}
    ${tr_data_first}     Get Text    //table//tbody/tr[1]//td[${th_index}]
    Common - Page Turning    Last
    ${tr_count}    Get Element Count    //table//tbody/tr
    ${tr_date_last}    Get Text     //table//tbody/tr[${tr_count}]//td[${th_index}]
    Compare Sort Data    ${sort_down}    ${tr_data_first}    ${tr_date_last}    ${date_type}    ${text}