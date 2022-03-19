*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource       ../../TestData/EnvData.robot

*** Variables ***
${MAP_EMAIL}
${MAP_PWD}

*** Keywords ***
Sign In Map With Admin Account
    Go To   ${URL_MAP}
    Wait Until Element Is Visible    //h2[text()="Member Login"]
    Input Text  //input[@type='text']    ${MAP_EMAIL}
    Input Text  //input[@type='password']    ${MAP_PWD}
    Click Element  xpath=//button[@type='submit']
    Wait Until Element Is Visible    //p[text()="Marketplace"]

Main Menu - To Michaels.com
    Click Element    //p[text()="Michaels.com"]/../parent::button
    Wait Until Element Is Visible    //div[@class="logo" and text()="MICHAELS.COM"]

Main Menu - To Marketplace
    Click Element    //p[text()="Marketplace"]/../parent::button
    Wait Until Element Is Visible    //div[@class="logo" and text()="MARKETPLACE"]

Main Menu - To Makerplace
    Click Element    //p[text()="Makerplace"]/../parent::button
    Wait Until Element Is Visible    //div[@class="logo" and text()="MAKERPLACE"]

Main Menu - To B2B
    Click Element    //p[text()="B2B"]/../parent::button
    Wait Until Element Is Visible    //h4[text()="My Account"]

Marketplace Left Menu - Vendor Management - Seller Applications
    Click Element    //span[text()="Vendor Management"]/../../../parent::li
    Wait Until Element Is Visible    //span[text()="Seller Applications"]/../../parent::li
    Click Element    //span[text()="Seller Applications"]/../../parent::li
    Wait Until Element Is Visible    //div[text()="Seller Applications"]
    Wait Until Element Is Visible    //table//tbody//tr/td

Marketplace Left Menu - Vendor Management - Store Management
    Click Element    //span[text()="Vendor Management"]/../../../parent::li
    Wait Until Element Is Visible    //span[text()="Seller Applications"]/../../parent::li
    Click Element    //span[text()="Store Management"]/../../parent::li
    Wait Until Element Is Visible    //div[text()="Store Management"]
    Wait Until Element Is Visible    //table//tbody//tr/td

Marketplace Left Menu - Lisitng Management
    Click Element    //span[text()="Listing Management"]/../../../parent::li
    Wait Until Element Is Visible    //span[text()="Listing Applications"]/../../parent::li
    Click Element    //span[text()="Listing Management"]/../../parent::li
    Wait Until Element Is Visible    //div[text()="Listing Management"]
    Wait Until Element Is Visible    //table//tbody//tr/td

Marketplace Left Menu - Open Resolution Center
    Wait Until Element Is Visible    //span[text()="Resolution Center"]
    ${count}    Get Element Count    //li[contains(@class,"ant-menu-submenu-open")]//span[text()="Resolution Center"]
    IF    "${count}"=="0"
        Click Element    //span[text()="Resolution Center"]/../..
        Wait Until Element Is Visible    //span[text()="Inappropriate Contents"]
    END

Marketplace Left Menu - Resolution Center - Return Disputes
    Marketplace Left Menu - Open Resolution Center
    Click Element    //span[text()="Return Disputes"]/parent::a
    Wait Until Element Is Visible    //h2[text()="Return Disputes"]





