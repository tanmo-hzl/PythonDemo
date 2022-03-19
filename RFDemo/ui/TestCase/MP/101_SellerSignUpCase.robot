*** Settings ***
Library             ../../Libraries/MP/SignUpLib.py
Resource            ../../Keywords/MP/SellerSignUpKeywords.robot
Resource            ../../Keywords/Common/SnapmailKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MAP/MarketplaceSellerApplicationsKeywords.robot
Suite Setup         Run Keyword     Initial Env Data
Suite Teardown      Close All Browsers
*** Variables ***
${Par_Case_Status}    PASS
${Application_No}
${Seller_Info}

*** Test Cases ***
Test Fill In The Company And Store Information
    [Documentation]  Fill in the company and store information
    [Tags]  mp   mp-ea   ea-signup
    Initialize Seller Data
    Flow - Add Email To Snapmail    ${Seller_Info}[email_prefix]
    Flow - Seller Pre Application Submit
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Pre Application Email Received
    [Documentation]  Check pre application email received
    [Tags]  mp   mp-ea   ea-signup
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to submit pre application
    Check Email Has Been Received Contains Title   ${Seller_Info}[email_prefix]    Thank you for applying to sell on Michaels Marketplace

Test Map SignIn And Approve Application
    [Documentation]  Map sign in and approve application
    [Tags]  mp   mp-ea   ea-signup
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to submit pre application
    Switch Browser    mpApply
    Flow - Approve Or Reject Pre Application    ${True}    ${Seller_Info}[name]    ${Seller_Info}[manager]
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Application Approve Email Received
    [Documentation]  Check application approve email received
    [Tags]  mp   mp-ea   ea-signup
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to map approve application
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]    Congratulations, you’ve been approved to be a Seller at Michaels Marketplace!

Test Create A Seller Account
    [Documentation]  Fill in Store Information And Payment Information, and So On
    [Tags]  mp   mp-ea   ea-signup
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to map Approve Applicatin
    Switch Browser    mpApply
    Create An Account and Account Password
    Read And Confirm Seller Agreement
    Fill In Store Information
    Fill In Payment Information
    Fill In Billing Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Store Profile
    [Documentation]  Fill In Store Profile
    [Tags]  mp   mp-ea   ea-signup
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'   Fail to create seller account
    Fill In Store Log Store Banner And Description
    Add Customer Service Datails
    Provide Fulfillment Infomation
    Fill In Return Information

Test Update Store Name
    [Documentation]    Seller submit update store name application, only once change, so not run.
    [Tags]   mp   mp-ea   ea-signup
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'   Fail to create seller account
    Store Left Meun - Store Settings - Store Profile
    ${Store_Name}    Get Random Code    6
    Store Profile - Update Store Name    Store ${Store_Name}

Test Rejected Store Name Update Application
    [Documentation]    Michaels reject seller update store name application
    [Tags]   mp   mp-ea   ea-signup
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'   Fail to submit application for update store name
    Sign In Map With Admin Account
    Main Menu - To Marketplace
    Marketplace Left Menu - Vendor Management - Store Management
    Enter Tab - Store Rename Application
    Search By Company Name On Store Rename Application    ${Seller_Info}[store_name]
    Mouse Over To Application By Company Name    ${Seller_Info}[store_name]
    Reject Application
    [Teardown]    Close All Browsers

Test Seller Pre Application And Michaels Reject
    [Documentation]  Seller submit pre application then michaels reject, check emial received
    [Tags]  mp   mp-ea   ea-signup0
    Initialize Seller Data
    Flow - Add Email To Snapmail    ${Seller_Info}[email_prefix]
    Flow - Seller Pre Application Submit
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]   Thank you for applying to sell on Michaels Marketplace
    Switch Browser    mpApply
    Flow - Approve Or Reject Pre Application    ${False}    ${Seller_Info}[name]
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]   Sorry! We couldn't approve you
    [Teardown]    Close All Browsers

Test Buyer Sign Up And Confirm Email Then Sign In
    [Documentation]  Buyer sign up and confirm email
    [Tags]  mp   mp-ea   ea-signup1
    Initialize Seller Data
    Flow - Add Email To Snapmail    ${Seller_Info}[email_prefix]
    Flow - Buyer Sign Up
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]   please confirm your email address.
    Confirm Buyer Sign Up Email   please confirm your email address.
    ${name}    Evaluate    '${Seller_Info}[email_prefix]'.split("_")\[1\].upper()
    Run Keyword And Ignore Error    Close Dialog If Existed
    User Sign In - MP    ${Seller_Info}[email]    ${SELLER_PWD}    ${name}
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Buyer Pre Application - Buyer To Seller
    [Documentation]  Buyer sign in and submit pre application
    [Tags]  mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to create buyer and sign in
    Flow - Seller Pre Application Submit    ${False}
    Close Window
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Buyer Rewards Email Received - Buyer To Seller
    [Documentation]  Check buyer rewards email received
    [Tags]  mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to create buyer and sign in
    ${win_handles}    Get Window Handles
    Switch Window    ${win_handles[0]}
    Enter Spanmail Page    ${Seller_Info}[email_prefix]
    Refresh Email List To Check Title   ${Seller_Info}[email_prefix]    Welcome to Michaels Rewards!

Test Check Pre Application Email Received - Buyer To Seller
    [Documentation]  Check application approve email received
    [Tags]  mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to submit pre application after sign in
    Enter Spanmail Page    ${Seller_Info}[email_prefix]
    Refresh Email List To Check Title   ${Seller_Info}[email_prefix]    Thank you for applying to sell on Michaels Marketplace

Test Map SignIn And Approve Application - Buyer To Seller
    [Documentation]  Map sign in and approve application
    [Tags]  mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to submit pre application
    Switch Browser    mpApply
    Flow - Approve Or Reject Pre Application    ${True}    ${Seller_Info}[name]    ${Seller_Info}[manager]
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Application Approve Email Received - Buyer To Seller
    [Documentation]  Check application approve email received
    [Tags]  mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to map approve application
    Switch Browser    email
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]    Congratulations, you’ve been approved to be a Seller at Michaels Marketplace!
    Start Registration From Applicatin Approve Email Detail    Congratulations, you’ve been approved to be a Seller at Michaels Marketplace!
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill Store Info - Buyer To Seller
    [Documentation]  Fill in Store Information And Payment Information, and So On
    [Tags]  mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to map approve application
    ${win_handles}    Get Window Handles
    Switch Window    ${win_handles[1]}
    Fill In Store Information
    Fill In Payment Information
    Fill In Billing Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Store Profile - Buyer To Seller
    [Documentation]  Fill In Store Profile
    [Tags]  mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'    Fail to fill store info
    Fill In Store Log Store Banner And Description
    Add Customer Service Datails
    Provide Fulfillment Infomation
    Fill In Return Information

Test Update Store Name
    [Documentation]    Seller submit update store name application, only once change, so not run.
    [Tags]   mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'   Fail to create seller account
    Store Left Meun - Store Settings - Store Profile
    ${Store_Name}    Get Random Code    6
    Store Profile - Update Store Name    Store ${Store_Name}

Test Approve Store Name Update Application
    [Documentation]    Michaels reject seller update store name application
    [Tags]   mp   mp-ea   ea-signup1
    Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'   Fail to submit application for update store name
    Sign In Map With Admin Account
    Main Menu - To Marketplace
    Marketplace Left Menu - Vendor Management - Store Management
    Enter Tab - Store Rename Application
    Search By Company Name On Store Rename Application    ${Seller_Info}[store_name]
    Mouse Over To Application By Company Name    ${Seller_Info}[store_name]
    Approve Application