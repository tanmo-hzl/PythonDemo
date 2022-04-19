*** Settings ***
Library             ../../Libraries/MP/SignUpLib.py
Resource            ../../Keywords/MP/SellerSignUpKeywords.robot
Resource            ../../Keywords/MP/SellerStoreSettingsKeywords.robot
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
Test Buyer Sign Up
    [Documentation]  [MKP-6274],Buyer sign up
    [Tags]  mp   mp-ea   ea-signup1
    Initialize Seller Data
    Flow - Add Email To Snapmail    ${Seller_Info}[email_prefix]
    Flow - Buyer Sign Up
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Buyer Sign Up Email And Confirm it
    [Documentation]  [MKP-6274,MKP-6312],Check Buyer Sign Up Email And Confirm it
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to Buyer Sign Up
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]   please confirm your email address.
    Confirm Buyer Sign Up Email   please confirm your email address.
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Buyer Sign In After Confirm Email
    [Documentation]  [MKP-6274,MKP-6312],Buyer Sign In After Confirm Email
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to Check Buyer Sign Up Email And Confirm it
    ${name}    Evaluate    '${Seller_Info}[email_prefix]'.split("_")\[1\].upper()
    Run Keyword And Ignore Error    Close Dialog If Existed
    User Sign In - MP    ${Seller_Info}[email]    ${SELLER_PWD}    ${name}
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Buyer Pre Application - Buyer To Seller
    [Documentation]  [MKP-6274,MKP-6142],Buyer sign in and submit pre application
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to Buyer Sign In After Confirm Email
    Flow - Seller Pre Application Submit    ${False}
    Close Window
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Buyer Rewards Email Received - Buyer To Seller
    [Documentation]  [MKP-6274,MKP-6312],Check buyer rewards email received
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to create buyer and sign in
    ${win_handles}    Get Window Handles
    Switch Window    ${win_handles[0]}
    Enter Spanmail Page    ${Seller_Info}[email_prefix]
    Refresh Email List To Check Title   ${Seller_Info}[email_prefix]    Welcome to Michaels Rewards!

Test Check Pre Application Email Received - Buyer To Seller
    [Documentation]  [MKP-6274,MKP-6312],Check application approve email received
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application after sign in
    Enter Spanmail Page    ${Seller_Info}[email_prefix]
    Refresh Email List To Check Title   ${Seller_Info}[email_prefix]    Thank you for applying to sell on Michaels Marketplace

Test Map SignIn And Approve Application - Buyer To Seller
    [Documentation]  [MKP-6274,MKP-6308],Map sign in and approve application
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application
    Switch Browser    mpApply
    Flow - Approve Or Reject Pre Application    ${True}    ${Seller_Info}[name]    ${Seller_Info}[manager]
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Application Approve Email Received - Buyer To Seller
    [Documentation]  [MKP-6274,MKP-6312],Check application approve email received
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to map approve application
    Switch Browser    email
    ${title}   Set Variable    Congratulations, you’ve been approved to be a Seller at Michaels Marketplace!
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]    ${title}
    Check Seller Approved Email Detail    ${title}    ${True}
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Store Information - Buyer To Seller
    [Documentation]  [MKP-6123,MKP-6317,MKP-6168],Fill in Store Information
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to Create Seller Account
    Fill In Store Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Payment Information - Buyer To Seller
    [Documentation]  [MKP-6123,MKP-6355,MKP-6188],Fill In Payment Information
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to Fill In Store Information
    Fill In Payment Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Billing Information - Buyer To Seller
    [Documentation]  [MKP-6123,MKP-6358],Fill In Billing Information
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip    Fail to Fill In Payment Information
    Fill In Billing Information    ${False}
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Store Log Store Banner And Description - Buyer To Seller
    [Documentation]  [MKP-6123,MKP-6365],Fill In Store Log Store Banner And Description
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Billing Information
    Fill In Store Log Store Banner And Description
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Customer Service Details - Buyer To Seller
    [Documentation]  [MKP-6123,MKP-6380],Fill In Customer Service Details
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Store Log Store Banner And Description
    Add Customer Service Datails
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Fill In Provide Fulfillment Information - Buyer To Seller
    [Documentation]  [MKP-6123,MKP-6410],Fill In Provide Fulfillment Information
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Customer Service Datails
    Provide Fulfillment Infomation
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}
#MKP-6422, 失败场景
Test Fill In Return Information - Buyer To Seller
    [Documentation]  [MKP-6123,MKP-6424],Fill In Return Information
    [Tags]  mp   mp-ea   ea-signup1
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Provide Fulfillment Infomation
    Fill In Return Information

    #6275 登录后，使用不同邮件注册


