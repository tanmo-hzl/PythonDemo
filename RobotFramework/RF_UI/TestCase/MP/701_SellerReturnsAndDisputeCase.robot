*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerReturnsAndDisputesKeywords.robot
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
    [Tags]    mp    mp-seller-return    mp-seller-dispute
    Set Suite Variable    ${Cur_User_Name}    ${SELLER_NAME}
    User Sign In - MP    ${SELLER_EMAIL}    ${SELLER_PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Approve Refund Return Order
    [Documentation]    Seller enter Returns&Disputes page and Approve Refund for Pending Return order
    [Tags]    mp    mp-seller-return
    Store Left Meun - Order Management - Returns And Disputes
    Filters - Clear All Filters
    Filters - Search Order By Status Single    Pending Return
    Get Order Number From First Line
    Search Order by Order Number    ${Order_Number}
    Clear Search Order Number
    Enter Order Detail Page By Line Index
    Approve Refund On Order Detail Page
    Back To Order List On Order Detail Page

Test Reject Refund Return Order
    [Documentation]    Seller enter Returns&Disputes page and Reject Refund for Pending Return order
    [Tags]    mp    mp-seller-return
    Store Left Meun - Order Management - Returns And Disputes
    Filters - Clear All Filters
    Filters - Search Order By Status Single    Pending Return
    Enter Order Detail Page By Line Index
    Reject Refund On Order Detail Page
    Back To Order List On Order Detail Page

Test View Dispute Info
    [Documentation]    Seller enter Returns&Disputes page and view dispute for Refund Rejected order
    [Tags]    mp    mp-seller-return    mp-seller-dispute
    Store Left Meun - Order Management - Returns And Disputes
    Select Order Which Have Disputes
    Enter Dispute Page
    Enter Dispute Summary Page
    Back To View Dispute On Dispute Summary Page
    Back To Order Detail On View Dispute Page

