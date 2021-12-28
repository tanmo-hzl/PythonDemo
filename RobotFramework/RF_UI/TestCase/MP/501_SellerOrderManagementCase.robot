*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerOrderManagementKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keyword    Initial Data And Open Browser   ${URL_MIK}
Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS

*** Test Cases ***
Test Seller Sign In And Enter Storefront
    [Documentation]    Seller Sign In and enter Storefront Page
    [Tags]    mp    mp-seller-order    mp-seller-order-confirm    mp-seller-order-ship
    Set Suite Variable    ${Cur_User_Name}    ${SELLER_NAME}
    User Sign In - MP    ${SELLER_EMAIL}    ${SELLER_PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Confirm Order Which Status Is Pending Confirmation
    [Documentation]    Search Pengding Confirmation order, then enter detail page and confirm it
    [Tags]   mp    mp-seller-order    mp-seller-order-confirm
    Store Left Meun - Order Management - Overview
    Filters - Clear All Filters
    Filters - Search Order By Status Single    Pending Confirmation
    Enter To Order Detail Page By Line Index
    Close Order Detail Page
    Search Order By Order Number    ${Cur_Order_Number}
    Clear Search Order Number
    Enter To Order Detail Page By Line Index
    Select All Item On Order Detail Page
    Confirm Order On Order Detail Page
    Back To Order List On Order Detail Page
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Close Order Detail Page

Test Ship Item After Confirm Order
    [Documentation]    Search Ready To Ship order, then enter detail page and confirm it
    [Tags]   mp    mp-seller-order      mp-seller-order-ship
    Store Left Meun - Order Management - Overview
    Filters - Clear All Filters
    Filters - Search Order By Status Single    Ready to Ship
    Enter To Order Detail Page By Line Index
    Select All Item On Order Detail Page
    Ship Item On Order Detail Page
    Back To Order List On Order Detail Page
    [Teardown]    Run Keyword If    '${TEST STATUS}'=='FAIL'    Close Order Detail Page
