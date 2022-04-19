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
Test Fill In The Company And Store Information
    [Documentation]  [MKP-6123,MKP-6142],Fill in the company and store information
    [Tags]  mp   mp-ea   ea-signup
    Initialize Seller Data
    Flow - Add Email To Snapmail    ${Seller_Info}[email_prefix]
    Flow - Seller Pre Application Submit
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Check Pre Application Email Received
    [Documentation]  [MKP-6123,MKP-6150],Check pre application email received
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application
    ${title}    Set Variable     Thank you for applying to sell on Michaels Marketplace
    Check Email Has Been Received Contains Title   ${Seller_Info}[email_prefix]    ${title}
    Check Submit Pre Application Email Detail   ${title}

Test Map SignIn And Approve Application
    [Documentation]  [MKP-6123,MKP-6308],Map sign in and approve application
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application
    Switch Browser    mpApply
    Flow - Approve Or Reject Pre Application    ${True}    ${Seller_Info}[name]    ${Seller_Info}[manager]
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Resend Approve Application Email
    [Documentation]  [MKP-6148],Map resend approve applicaiton email
    [Tags]  mp   mp-ea   ea-signup
    Resend Email By Company Name    ${Seller_Info}[name]

Test Check Application Approve Email Received
    [Documentation]  [MKP-6123,MKP-6146],Check application approve email received
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip    Fail to map approve application
    ${title}   Set Variable    Congratulations, you’ve been approved to be a Seller at Michaels Marketplace!
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]    ${title}    2
    Check Seller Approved Email Detail    ${title}    ${False}

Test Register - Create Seller Account
    [Documentation]  [MKP-6123,MKP-6160],Input seller account info
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip    Fail to map Approve Applicatin
    Switch Browser    mpApply
    Create An Account and Account Password
    Read And Confirm Seller Agreement
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register - Fill In Store Information
    [Documentation]  [MKP-6123,MKP-6317,MKP-6168],Fill in Store Information
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip    Fail to Create Seller Account
    Fill In Store Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register - Fill In Payment Information
    [Documentation]  [MKP-6123,MKP-6355,MKP-6188],Fill In Payment Information
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip    Fail to Fill In Store Information
    Fill In Payment Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register - Fill In Billing Information
    [Documentation]  [MKP-6123,MKP-6357],Fill In Billing Information
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip    Fail to Fill In Payment Information
    Fill In Billing Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register - Fill In Store Log Store Banner And Description
    [Documentation]  [MKP-6123,MKP-6365],Fill In Store Log Store Banner And Description
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Billing Information
    Fill In Store Log Store Banner And Description
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register - Fill In Customer Service Details
    [Documentation]  [MKP-6123,MKP-6380],Fill In Customer Service Details
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Store Log Store Banner And Description
    Add Customer Service Datails
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register - Fill In Provide Fulfillment Information
    [Documentation]  [MKP-6123,MKP-6410],Fill In Provide Fulfillment Information
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Customer Service Datails
    Provide Fulfillment Infomation
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register - Fill In Return Information
    [Documentation]  [MKP-6123,MKP-6424],Fill In Return Information
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to Fill In Provide Fulfillment Infomation
    Fill In Return Information
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Register Seller AS A Buyer
    [Documentation]  Register Seller AS A Buyer
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to seller Register
    Register Seller AS A Buyer

Test Seller Sign In Then Check START SELLING WITH MICHAELS Is Hidden
    [Documentation]  Check START SELLING WITH MICHAELS Is Hidden
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to seller Register
    Check START SELLING WITH MICHAELS Button Existed    ${False}
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Seller Sign Out Then Check START SELLING WITH MICHAELS Is Display
    [Documentation]  Check START SELLING WITH MICHAELS Is Hidden
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to seller Register
    ${Cur_User_Name}    Evaluate    '${Seller_Info}[first_name]'.upper()
    Set Suite Variable    ${Cur_User_Name}    ${Cur_User_Name}
    User Sign Out
    Check START SELLING WITH MICHAELS Button Existed    ${True}
    [Teardown]    Close All Browsers

Test Seller Pre Application And Michaels Reject
    [Documentation]  [MKP-6147],Seller submit pre application then michaels reject, check emial received
    [Tags]  mp   mp-ea   ea-signup
    Initialize Seller Data
    Flow - Add Email To Snapmail    ${Seller_Info}[email_prefix]
    Flow - Seller Pre Application Submit
#    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]   Thank you for applying to sell on Michaels Marketplace
    Switch Browser    mpApply
    Flow - Approve Or Reject Pre Application    ${False}    ${Seller_Info}[name]
    [Teardown]   Set Suite Variable    ${Par_Case_Status}    ${TEST STATUS}

Test Resend Reject Application Email
    [Documentation]  [MKP-6510,MKP-6508],Map resend reject applicaiton email
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to Map rejected application
    Resend Email By Company Name    ${Seller_Info}[name]

Test Rejected Email Received
    [Documentation]  [MKP-6147,MKP-6146],Check rejected email received
    [Tags]  mp   mp-ea   ea-signup
    Skip Case If Parent Case Fail Or Skip   Fail to Map rejected application
    ${title}    Set Variable    Sorry! We couldn't approve you
    Check Email Has Been Received Contains Title    ${Seller_Info}[email_prefix]   ${title}    2

Test Check Submit Pre Application By Existed Company Name Email and EIN
    [Documentation]  [MKP-6143],Check Submit Pre Application By Existed Company Name Email and EIN
    [Tags]  mp   mp-ea   ea-signup2
    Initialize Seller Data
    Flow - Add Email To Snapmail    ${Seller_Info}[email_prefix]
    Flow - Seller Pre Application Submit
    Flow - Seller Pre Application Submit    ${False}    ${False}
    Check Submit Pre Application By Existed Info    NMI

Test Check Submit Pre Application By Existed Company Name AND EIN
    [Documentation]  [MKP-6144],Check Submit Pre Application By Existed EIN
    [Tags]  mp   mp-ea   ea-signup2
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application
    Set To Dictionary    ${Seller_Info}    email=a_${Seller_Info}[email]
    Create - Input Email And Confirm Email Address
    Check Submit Pre Application By Existed Info    NI

Test Check Submit Pre Application By Existed EIN
    [Documentation]  [MKP-6144],Check Submit Pre Application By Existed EIN
    [Tags]  mp   mp-ea   ea-signup2
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application
    Set To Dictionary    ${Seller_Info}    name=NEW ${Seller_Info}[name]
    Create - Input Company Legal Name
    Check Submit Pre Application By Existed Info    I

Test Check Submit Pre Application By Existed Email
    [Documentation]  [MKP-6144],Check Submit Pre Application By Existed EIN
    [Tags]  mp   mp-ea   ea-signup2
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application
    ${email}    Evaluate    "${Seller_Info}[email_prefix]"+"@snapmail.cc"
    Set To Dictionary    ${Seller_Info}    email=${email}
    ${new_ein}     Evaluate    '${Seller_Info}[ein]'\[3:\]+"000"
    Set To Dictionary    ${Seller_Info}    ein=${new_ein}
    Create - Input Company Legal Name
    Create - Input Email And Confirm Email Address
    Create - Input Employer Identification Number(EIN)
    Check Submit Pre Application By Existed Info    M

Test Check Submit Pre Application By Existed Seller Email
    [Documentation]  [MKP-6144],Check Submit Pre Application By Existed EIN
    [Tags]  mp   mp-ea   ea-signup2
    Skip Case If Parent Case Fail Or Skip    Fail to submit pre application
    Set To Dictionary    ${Seller_Info}    email=${SELLER_EMAIL}
    Create - Input Email And Confirm Email Address
    Check Submit Pre Application By Existed Info    ES

