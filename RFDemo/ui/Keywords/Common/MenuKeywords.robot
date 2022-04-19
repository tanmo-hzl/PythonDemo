*** Settings ***
Resource       ../../TestData/EnvData.robot


*** Variables ***
${Cur_User_Name}

*** Keywords ***

Open User Menu List
    Wait Until Element Is Visible    //p[text()='${Cur_User_Name}']
    Mouse Over    //p[text()='${Cur_User_Name}']
    Sleep    1

User Sign Out
    [Arguments]    ${to_home}=${False}
    IF    '${to_home}'=='${True}'
        CLick Element    //a[@aria-label="Logo Home"]
        Sleep    2
    END
    Open User Menu List
    Click Element    //*[@role="tooltip"]//p[text()="Sign Out"]
    Wait Until Element Is Not Visible      //p[text()='${Cur_User_Name}']
    Wait Until Page Contains Element      //p[text()='Sign In']

Main Menu - Account Page
    Open User Menu List
    Click Element    //p[text()="Account"]
    Wait Until Element Is Visible    //span[starts-with(text(),"Welcome Back")]

Main Menu - Orders Page
    Open User Menu List
    Click Element    //p[text()="Orders"]
    Wait Until Element Is Visible    //h2/div[text()="Order History"]
    Wait Until Element Is Visible    //button[starts-with(@class,"chakra-button")]

Main Menu - My Rewards Page
    Open User Menu List
    Click Element    //p[text()="My Rewards"]
    Wait Until Element Is Visible    //p[text()="MY ACCOUNT"]

Main Menu - My Favorites Page
    Open User Menu List
    Click Element    //p[text()="My Favorites"]
    Wait Until Element Is Visible    //h2[text()="My Lists"]

Main Menu - Storefront Page
    Open User Menu List
    Click Element    //p[text()="Storefront"]
    Wait Until Element Is Visible    //h1[starts-with(text(),"Welcome to your Dashboard")]

Main Menu - Create An Account
    Open User Menu List
    Click Element    //p[text()="Create an Account"]
    Wait Until Element Is Visible    //h2[text()="Let’s Start. Tell Us About You."]

Main Menu - Track An Order
    Open User Menu List
    Click Element    //p[text()="Track My Order"]
    Wait Until Element Is Visible    //h4[text()="Track Order on Account Dashboard"]

Store Left Menu - Listing Management
    Wait Until Element Is Visible    //p[text()="Listing Management"]/../..
    Click Element    //p[text()="Listing Management"]/../..
    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Store Left Menu - Open Order Management
    Wait Until Element Is Visible    //p[text()="Order Management"]/../..
    ${count}    Get Element Count    //p[text()="Order Management"]/../parent::button[@aria-expanded="false"]
    Run Keyword If    '${count}'=='1'    Click Element    //p[text()="Order Management"]/../..
    Run Keyword If    '${count}'=='1'    Wait Until Element Is Visible    //p[text()="Overview"]/parent::button

Store Left Menu - Order Management - Overview
    Store Left Menu - Open Order Management
    Click Element    //p[text()="Overview"]/parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //h2[contains(text(),"Order Management")]
    Wait Until Element Is Visible    ${Filter_Btn_Ele}

Store Left Menu - Order Management - Returns
    Store Left Menu - Open Order Management
    Wait Until Element Is Visible    //p[text()="Returns"]/parent::button
    Click Element    //p[text()="Returns"]/parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //*[@id="searchOrders"]
    Wait Until Element Is Visible    ${Filter_Btn_Ele}

Store Left Menu - Order Management - Disputes
    Store Left Menu - Open Order Management
    Wait Until Element Is Visible    //p[text()="Disputes"]/parent::button
    Click Element    //p[text()="Disputes"]/parent::button
    Wait Loading Hidden
    Wait Until Element Is Visible    //*[@id="searchOrders"]
    Wait Until Element Is Visible    ${Filter_Btn_Ele}

Store Left Menu - Open Store Settings
    Wait Until Element Is Visible    //p[text()="Store Settings"]/../parent::button
    ${count}    Get Element Count    //p[text()="Store Settings"]/../parent::button[@aria-expanded="false"]
    Run Keyword If    '${count}'=='1'    Click Element    //p[text()="Store Settings"]/../parent::button
    Wait Until Element Is Visible    //p[text()="Store Profile"]/parent::button
    Sleep    1

Store Left Meun - Store Settings - Store Profile
    Store Left Menu - Open Store Settings
    Click Element    //p[text()="Store Profile"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Store Profile"]
#    Wait Until Element Is Visible    //p[text()="Edit Store Name"]
    Sleep    1

Store Left Meun - Store Settings - Customer Service
    Store Left Menu - Open Store Settings
    Click Element    //p[text()="Customer Service"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Customer Service"]
    Sleep    1

Store Left Meun - Store Settings - Fulfillment Info
    Store Left Menu - Open Store Settings
    Click Element    //p[text()="Fulfillment Info"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Fulfillment"]
    Sleep    1

Store Left Meun - Store Settings - Return Policy
    Store Left Menu - Open Store Settings
    Click Element    //p[text()="Return Policy"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Return Policy"]
    Sleep    1

Store Left Meun - Store Settings - Product Groups
    Store Left Menu - Open Store Settings
    Click Element    //p[text()="Product Groups"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Product Groups"]
    Wait Until Element Is Visible    //div[contains(text(),"PRODUCT GROUP") and starts-with(text(),"CREATE")]/parent::button
    Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()="Visible on Storefront"]    5

Store Left Menu - Dashboard
    Wait Until Element Is Visible    //p[text()="Dashboard"]/parent::button
    Click Element    //p[text()="Dashboard"]/parent::button
    Wait Until Element Is Visible    //h2[starts-with(text(),"Welcome to your Dashboard")]
    Sleep   2

Store Left Menu - Messages
    Wait Until Element Is Visible    //p[text()="Messages"]/parent::button
    Click Element    //p[text()="Messages"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Messages"]
    Sleep   1

Store Left Menu - Account Settings
    Wait Until Element Is Visible    //p[text()="Account Settings"]/parent::button
    Click Element    //p[text()="Account Settings"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Account Settings"]
    Sleep   1

Store Left Menu - Marketing - Overview
    Wait Until Element Is Visible    //p[text()="Marketing"]
    ${count}    Get Element Count    //p[text()="Marketing"]/../parent::button[@aria-expanded="true"]
    Run Keyword If   '${count}'=='0'    Click Element    //p[text()="Marketing"]/../parent::button
    Run Keyword If   '${count}'=='1'    Click Element    //p[text()="Marketing"]/../../following-sibling::div//p[text()="Overview"]/parent::button
    Wait Until Element Is Visible     //*[text()="Create a customer Promotion"]
    Wait Until Page Contains Element    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]
    Sleep    1

Store Left Menu - Marketing - Advertisement
    Wait Until Element Is Visible    //p[text()="Marketing"]
    ${count}    Get Element Count    //p[text()="Marketing"]/../parent::button[@aria-expanded="true"]
    Run Keyword If   '${count}'=='0'    Click Element    //p[text()="Marketing"]/../parent::button
    Run Keyword If   '${count}'=='1'    Click Element    //p[text()="Marketing"]/../../following-sibling::div//p[text()="Advertisement"]/parent::button
    ${handles}    Get Window Handles
    Switch Window    ${handles[1]}
    Wait Until Element Is Visible     //p[text()="Management"]
    Sleep    1

Store Left Menu - Open Finances
    Wait Until Element Is Visible    //p[text()="Finances"]
    ${count}    Get Element Count    //p[text()="Finances"]/../parent::button[@aria-expanded="true"]
    Run Keyword If   '${count}'=='0'    Click Element    //p[text()="Finances"]/../parent::button
    Sleep    1

Store Left Menu - Finances - Overview
    Store Left Menu - Open Finances
    Click Element    //p[text()="Finances"]/../parent::button/following-sibling::div//button
    Wait Until Element Is Visible    //h2[text()="Overview"]
    Wait Until Element Is Visible    //div[text()="Change"]/parent::button
    Sleep    1

Store Left Menu - Finances - Deposit Options
    Store Left Menu - Open Finances
    Click Element    //p[text()="Deposit Options"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Payments"]
    Sleep    1

Store Left Menu - Finances - Transactions
    Store Left Menu - Open Finances
    Click Element    //p[text()="Transactions"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Transactions"]
    Sleep    1

Store Left Menu - Finances - Tax Information
    Store Left Menu - Open Finances
    Click Element    //p[text()="Tax Information"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Tax Information"]
    Sleep    1

Buyer Left Menu - Open Orders & Purchases
    ${base_ele}    Set Variable    (//p[text()="Orders & Purchases"])[2]
    Wait Until Page Contains Element    ${base_ele}/../parent::button
    ${count}    Get Element Count    ${base_ele}/../parent::button[@aria-expanded="false"]
    Run Keyword If    '${count}'=='1'    Click Element    ${base_ele}/../parent::button
    Wait Until Element Is Visible    //p[text()="Order History"]/parent::div
    Sleep    1

Buyer Left Menu - Orders & Purchases - Order History
    Buyer Left Menu - Open Orders & Purchases
    Click Element    //p[text()="Order History"]/parent::div
    Sleep    1
    Wait Until Element Is Visible    //p[text()="Purchased Date"]

Buyer Left Menu - Orders & Purchases - Subscription
    Buyer Left Menu - Open Orders & Purchases
    Click Element    //p[text()="Subscription"]/parent::div
    Sleep    1
    Wait Until Element Is Visible    //p[text()="Item Name"]

Buyer Left Menu - Return and Dispute
    Wait Until Page Contains Element    //p[text()="Return and Dispute"]/../parent::a
    Click Element    //p[text()="Return and Dispute"]/../parent::a
    Wait Until Element Is Visible    //h2[text()="Return & Dispute"]
    Wait Until Element Is Visible    //p[contains(text(),"Filter")]

Buyer Left Menu - Open Account Information
    Scroll Element Into View    (//p[text()="Account Information"]/parent::div)[2]
    Wait Until Page Contains Element    (//p[text()="Account Information"]/parent::div)[2]
    ${count}    Get Element Count    (//p[text()="Account Information"]/../parent::button[@aria-expanded="false"])[2]
    Run Keyword If    '${count}'=='1'    Click Element    (//p[text()="Account Information"]/parent::div)[2]
    Wait Until Page Contains Element    //p[text()="Profile"]/parent::div
    Sleep    1

Buyer Left Menu - Account Information - Account Settings
    Buyer Left Menu - Open Account Information
    Click Element    //p[text()="Account Settings"]/parent::div
    Wait Until Element Is Visible    //h2[text()="Account Settings"]
    Sleep    1

Buyer Left Menu - Account Information - Profile
    Buyer Left Menu - Open Account Information
    Click Element    //p[text()="Profile"]/parent::div
    Wait Until Page Contains Element    //h2[text()="My Profile"]
    Scroll Element Into View    //h2[text()="My Profile"]
    Sleep    1

Buyer Left Menu - Account Information - Wallet
    Buyer Left Menu - Open Account Information
    Click Element    //p[text()="Wallet"]/parent::div
    Wait Until Element Is Visible    //h2[text()="Wallet"]
    Sleep    1



