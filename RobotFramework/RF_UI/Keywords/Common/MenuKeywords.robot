*** Settings ***
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Cur_User_Name}

*** Keywords ***

Open User Menu List
    Mouse Over    //p[text()='${Cur_User_Name}']
    Sleep    1

User Sign Out
    CLick Element    //a[@aria-label="Logo Home"]
    Sleep    2
    Open User Menu List
    Click Element    //p[text()="Sign Out"]
    Wait Until Element Is Not Visible      //p[text()='${Cur_User_Name}']
    Wait Until Element Is Visible      //p[text()='Sign In']

Main Menu - Account Page
    Open User Menu List
    Click Element    //p[text()="Account"]
    Wait Until Element Is Visible    //span[starts-with(text(),"Welcome back")]

Main Menu - Orders Page
    Open User Menu List
    Click Element    //p[text()="Orders"]
    Wait Until Element Is Visible    //h2[text()="Order History"]
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

Store Left Meun - Order Management - Overview
    Wait Until Element Is Visible    //p[text()="Order Management"]/../..
    ${count}    Get Element Count    //p[text()="Order Management"]/../parent::button[@aria-expanded="false"]
    Run Keyword If    '${count}'=='1'    Click Element    //p[text()="Order Management"]/../..
    Wait Until Element Is Visible    //p[text()="Overview"]/parent::button
    Run Keyword If    '${count}'=='0'    Click Element    //p[text()="Overview"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Order Management"]
    Wait Until Element Is Visible    //p[text()="Customer Name"]

Store Left Meun - Order Management - Returns And Disputes
    Wait Until Element Is Visible    //p[text()="Order Management"]/../..
    ${count}    Get Element Count    //p[text()="Order Management"]/../parent::button[@aria-expanded="true"]
    Run Keyword If    '${count}'=='0'    Click Element    //p[text()="Order Management"]/../..
    Wait Until Element Is Visible    //p[text()="Returns & Disputes"]/parent::button
    Sleep   1
    Click Element    //p[text()="Returns & Disputes"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Return & Dispute"]
    Wait Until Element Is Visible    //p[starts-with(text(),"Filters")]/../parent::button

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
    Click Element    //p[text()="Dashboard"]/parent::button
    Wait Until Element Is Visible    //h1[starts-with(text(),"Welcome to your Dashboard")]
    Sleep   1

Store Left Menu - Messages
    Click Element    //p[text()="Messages"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Messages"]
    Sleep   1

Store Left Menu - Account Settings
    Click Element    //p[text()="Account Settings"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Account Settings"]
    Sleep   1

Store Left Menu - Marketing
    Wait Until Element Is Visible    //p[text()="Marketing"]
    ${count}    Get Element Count    //p[text()="Marketing"]/../parent::button[@aria-expanded="true"]
    Run Keyword If   '${count}'=='0'    Click Element    //p[text()="Marketing"]/../parent::button
    Run Keyword If   '${count}'=='1'    Click Element    //p[text()="Marketing Overview"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Marketing"]
    Wait Until Page Contains Element    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]
    Sleep    1

Store Left Menu - Open Finances
    Wait Until Element Is Visible    //p[text()="Finances"]
    ${count}    Get Element Count    //p[text()="Finances"]/../parent::button[@aria-expanded="true"]
    Run Keyword If   '${count}'=='0'    Click Element    //p[text()="Finances"]/../parent::button
    Sleep    1

Store Left Menu - Finances - Overview
    Store Left Menu - Open Finances
    Click Element    //p[text()="Finances"]/../parent::button
    Wait Until Element Is Visible    //h2[text()="Overview"]
    Sleep    1

Store Left Menu - Finances - Deposit Options
    Store Left Menu - Open Finances
    Click Element    //p[text()="Deposit Options"]/../parent::button
    Wait Until Element Is Visible    //h2[text()="Payments"]
    Sleep    1

Store Left Menu - Finances - Transactions
    Store Left Menu - Open Finances
    Click Element    //p[text()="Transactions"]/../parent::button
    Wait Until Element Is Visible    //h2[text()="Transactions"]
    Sleep    1

Store Left Menu - Finances - Tax Information
    Store Left Menu - Open Finances
    Click Element    //p[text()="Tax Information"]/../parent::button
    Wait Until Element Is Visible    //h2[text()="Tax Information"]
    Sleep    1

Buyer Left Menu - Open Orders & Purchases
    Wait Until Element Is Visible    //p[text()="Orders & Purchases"]/../parent::button
    ${count}    Get Element Count    //p[text()="Orders & Purchases"]/../parent::button[@aria-expanded="false"]
    Run Keyword If    '${count}'=='1'    Click Element    //p[text()="Orders & Purchases"]/../parent::button
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
    Wait Until Element Is Visible    //p[text()="Return and Dispute"]/../parent::button
    Click Element    //p[text()="Return and Dispute"]/../parent::button
    Wait Until Element Is Visible    //h2[text()="Return & Dispute"]
    Wait Until Element Is Visible    //p[text()="Filters"]



