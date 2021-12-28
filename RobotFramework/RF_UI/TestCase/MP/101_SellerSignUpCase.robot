*** Settings ***
Documentation       This is a testsuite for sign up
Resource            ../../Keywords/MP/SellerSignUpKeywords.robot
Resource            ../../Keywords/Common/SnapmailKeywords.robot
Resource            ../../Keywords/MAP/MarketplaceSellerApplicationsKeywords.robot
Suite Setup         Run Keywords     Initial Env Data
...                             AND   Open Browser With URL   ${URL_MP_LANDING}  mpLandingUrl
Suite Teardown      Close All Browsers
Test Setup          Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'
*** Variables ***
${Par_Case_Status}    PASS
${Application_No}
${Seller_Account}

*** Test Cases ***
Test Add Email To Snapmail
    [Documentation]  Add email to snapmail
    [Tags]  mp  mp-signup   mp-signup-apply   mp-apply-email
    ${Random_Str}     Get_Random_Code   9
    Set Suite Variable    ${Seller_Account}    AutoUI${Random_Str}
    Open Snapmail Browser    email
    Switch Browser    email
    Add New Snapmail    ${Seller_Account}

Test Fill In The Company And Store Information
    [Documentation]  Fill in the company and store information
    [Tags]  mp  mp-signup   mp-signup-apply    mp-apply-email
    Switch Browser    mpLandingUrl
    Click START SELLING WITH MICHAELS Button
    Create - Input Company Legal Name
    Create - Input First And Last Name
    Create - Input Email And Confirm Email Address
    Create - Input Employer Identification Number(EIN)
    Create - Upload Photos
    Create - Click Sold And Shipped Lable Button
    Create - Select Categories You Sell In
    Create - Input Other Platforms Website
    Create - Select Many SKUs In Your Catalog
    Create - Select Approximate Annual ECommerce Revenue
    Create - Select Integration Source
    Create - Check Privacy Policy Checkbox
    Create - Click Submit Button
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Map SignIn And Approve Application
    [Documentation]  Map sign in and approve application
    [Tags]  mp  mp-signup  mp-signup-approve
    Sign In Map With Admin Account
    Main Menu - To Marketplace
    Marketplace Left Menu - Vendor Management - Seller Applications
    Search By Company Name    ${Seller_Account}
    Mouse Over To Application By Company Name    ${Seller_Account}
    Approve Application
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}


Test Create A Seller Account
    [Documentation]  Fill in Store Information And Payment Information ,And So On
    [Tags]  mp   mp-signup   mp-signup-store
    Create An Account and Account Password
    Read And Confirm Seller Agreement
    Fill In Store Information
    Fill In Payment Information
    Fill In Billing Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Store Profile
    [Documentation]  Fill In Store Profile
    [Tags]  mp   mp-signup   mp-signup-store
    Fill In Store Log Store Banner And Description
    Add Customer Service Datails
    Provide Fulfillment Infomation
    Fill In return Information

Test Check Email Is Existed
    [Documentation]  Check seller get the sign up email on snapmail
    [Tags]  mp  mp-signup   mp-signup-apply    mp-apply-email
    Switch Browser    email
    Enter Spanmail Page    ${Seller_Account}
    Refresh Email List

