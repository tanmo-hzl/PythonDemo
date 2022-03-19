*** Settings ***
Resource    ../../Keywords/Checkout/Common.robot
Resource    ../../TestData/Checkout/config.robot
Variables     ../../TestData/Checkout/productInfo.py


*** Variables ***


*** Keywords ***

login
    [Arguments]    ${user}    ${password}    ${is_sign}=true
    Environ Browser Selection And Setting    ${ENV}    ${BROWSER}    ${Home URL}/signin
    Wait Until Element Is Visible    //p[text()="Sign In"]
    Wait Until Element Is Visible    //p[text()="Remember me"]
    Wait Until Element Is Enabled    //input[@id="email"]
    click element    //input[@id="email"]
#    AutoItLibrary.send    ${user}
    Sleep  1
    Press Keys  //input[@id="email"]   ${user}
#    Sleep  10
#    input text    //input[@id="email"]    ${user}
    Click Element    //input[@id="password"]
    Sleep  1
    Press Keys  //input[@id="password"]   ${password}
#    input text    //input[@id="password"]   ${password}
#    AutoItLibrary.send    ${password}

    Click Button   //div[text()="SIGN IN"]/parent::button
    Sleep    2
#    Wait Until Page Does Not Contain Element     //div[text()="SIGN IN"]/parent::button
    IF  "${is_sign}" == "true"
        Wait Until Page Contains Element    //p[text()="${account_info["first_name"]}"]     ${Long Waiting Time}
    END


initial env data
    Set Selenium Timeout   ${Time Initial}
    ${env_data}    read excel    BuyerData.xlsx    ${None}    ${ENV}
    FOR   ${product_group}   IN   @{env_data}
        ${value}   get_list_step_value    ${product_group}   1
        Set Suite Variable    ${${product_group[0]}}    ${value}
    END

Initial Env Data2
    Set Selenium Timeout      ${Time Initial}
    ${test_data}    Set Variable    ${test_data}[${ENV}]
    ${keys}    Get Dictionary Keys     ${test_data}
    FOR    ${key}    IN    @{keys}
        Set Suite Variable    ${${key}}    ${test_data}[${key}]
    END

Paypal Payment
    Wait Until Element Is Visible    //h3[text()="Order Summary"]
    Wait Until Page Contains Element     //div[@type="submit"]
    Wait Until Element Is Visible    //div[@type="submit"]
    Wait Until Page Contains Element     //div[@type="submit"]//iframe[@title="PayPal"]
    Wait Until Element Is Visible    //div[@type="submit"]//iframe[@title="PayPal"]
    Wait Until Element Is Enabled     //div[@type="submit"]//iframe[@title="PayPal"]
    sleep    3
    Click Element    //div[@type="submit"]//iframe[@title="PayPal"]
    ${handles}  Get Window Handles
    Switch Window    ${handles[1]}
    Maximize Browser Window
    sleep    3
    ${is_accept_button}    Get Element Count     //button[@id="acceptAllButton"]
    IF    ${is_accept_button} > 0
        Wait Until Page Contains Element     //button[@id="acceptAllButton"]
        Wait Until Element Is Visible    //button[@id="acceptAllButton"]
        Execute Javascript    document.querySelector("#acceptAllButton").click()
        login when paypal payment
    ELSE IF   ${is_accept_button} == 0
        login when paypal payment
    END
    sleep    3
    Wait Until Page Contains Element     //h2[text()="Pay with"]     ${Long Waiting Time}
    Wait Until Element Is Visible    //h2[text()="Pay with"]     ${Long Waiting Time}
    Wait Until Element Is Visible    //h2[text()="Pay later"]
    Execute Javascript    document.querySelector("#payment-submit-btn").click()
#    Wait Until Page Contains Element   //p[text()="Processing..."]
#    Wait Until Page Does Not Contain Element   //p[text()="Processing..."]
#    Switch Window   ${handles[0]}
    FOR   ${num}    IN RANGE    10
        ${handles}  Get Window Handles
        ${len}    Get Length     ${handles}
        Exit For Loop If    ${len} == 1
        sleep    3
    END
    Switch Window   ${handles[0]}
    sleep    1
    Wait Until Page Does Not Contain Element     //*[@stroke="transparent"]


login when paypal payment
    ${is_email}    Get Element Count     //input[@id="email"]
    IF   ${is_email} > 0
        Wait Until Element Is Visible    //input[@id="email"]
        Click Element   //input[@id="email"]
        Input Text    //input[@id="email"]   ${paypalInfo.email}
        ${is_next}    Get Element Count    //button[@id="btnNext"]
        IF   ${is_next} == 0
            Input Text    //input[@id="password"]    ${paypalInfo.password}
        ELSE
            Click Element    //button[@id="btnNext"]
            Wait Until Element Is Visible    //input[@id="password"]
            Input Text    //input[@id="password"]    ${paypalInfo.password}
        END
        Wait Until Element Is Visible    //button[@id="btnLogin"]
        Click Element    //button[@id="btnLogin"]
    END