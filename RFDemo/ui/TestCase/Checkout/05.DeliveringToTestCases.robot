*** Settings ***
Documentation     Test Suite For smoke Checkout Tests Flow
Resource          ../../TestData/Checkout/config.robot
Resource          ../../Keywords/Checkout/Common.robot
Resource          ../../Keywords/Checkout/ShoppingCartPageKeywords.robot
Library           OperatingSystem
Library           ../../TestData/Checkout/GuestGenerateAddress.py

Suite Setup      Initial Custom Selenium Keywords
Test Setup       Environ Browser Selection And Setting   ${ENV}   Firefox
Test Teardown    Finalization Processment
*** Variables ***
${TEST ENV}     ${ENV}

*** Test Cases ***
Guest - Delivering To ZipCode Chck
    [Template]   Delivering To In Shopping Cart Page
    [Tags]   practice
    MIK    1    1    20

*** Keywords ***
Delivering To In Shopping Cart Page
    [Arguments]    ${Channel Mode}   ${Items}   ${Qty}    ${Check Count}
    ${Address Collection}   Create List
    ${Qty Processed}        Qty Process     ${Qty}
    ${Items Count}          Calculate Items Count       ${Items}

    ${Product Channel Info}         Items Channel Dictionary Creation         ${Channel Mode}   ${Items}   ${TEST ENV}
    ${Sku List}   ${Partial Urls}   Split Skus From Partial Url               ${Product Channel Info}
    ${Shipping Info}   ${Class Set Qty}   ${Multiple Store Address}    Add Products To Cart Process
    ...   ${Product Channel Info}    ${Qty Processed}

    ${Handle AD Pop}   Run Keyword And Warn On Failure    Click Element    //div[text()='View My Cart']
    IF  '${Handle AD Pop}[0]' == 'FAIL'
        Go To   ${Home URL}/cart
    END

    # Shopping Cart Page
    # Wait until the loading sign disappears
    Wait Until Element Is Not Visible    //div[@class="css-1qbjk8g"]           ${Long Waiting Time}
    Wait Until Element Is Visible        //*[text()='Shopping Cart']
    Wait Until Element Is Enabled        //div[text()='PROCEED TO CHECKOUT']

    ${Cart Valid Error}   Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()="Sorry, a problem has occurred."]   3
    IF  '${Cart Valid Error}[0]' == 'PASS'
        Wait Until Element Is Enabled   //div[text()="CLOSE"]
        Click Element                   //div[text()="CLOSE"]
    END

    ${Deliver to Element}   Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()="Delivering to "]    5
    IF  '${Deliver to Element}[0]' == 'PASS'
        ${Zip List}        Random Getting Zipcode    ${Check Count}
        FOR   ${code}   IN   @{Zip List}
            ${ZipCode Updated}   Change ZipCode Adjust Different ZipCode    ${code}
            Wait Until Element Is Not Visible    //div[@class="css-1qbjk8g"]    5
            ${Capture}   Run Keyword And Warn On Failure    Wait Until Element Is Not Visible    //p[text()="Sorry, a problem has occurred."]    4
            IF  '${Capture}[0]' == 'FAIL'
                Log To Console   ${code}
                Wait Until Element Is Visible    //div[text()="CLOSE"]
                Click Element                    //div[text()="CLOSE"]
            END
        END
    END