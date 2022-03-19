*** Settings ***
Documentation       This is to Return Dispute
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/ReturnDispute.robot
Test Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK_SIGNIN}   mikLandingUrl
Test Teardown      Close All Browsers

*** Test Cases ***
Test ReturnDispute - Seller Buyer All Rejected
    [Documentation]   ReturnDispute - Seller Buyer All Rejected
    [Tags]  mik  mik-ReturnDispute  mik-AllRejected
    Open Browser With URL  ${URL_MIK_SIGNIN}  miksellerUrl
    Sign in  ${seller_email}  ${seller_pwd}
    Seller Goods shelves
    Switch Browser  mikLandingUrl
    Check Out FGM And Go To Order  1
    Go To Seller Order And Shipments
    Go To Buyer Order And Return  0  8
    Seller First Time Handle Disputes   Reject Refund
    Buyer First Time Handle Disputes    2  test
    Seller second time Handle Disputes  Reject Refund  test  1
    Buyer second time Handle Disputes   Reject
    Seller third time Handle Disputes   test  test
    Buyer third time Handle Disputes    True  Other  test
    Buyer Confirms Status of Disputes   Return Declined

Test ReturnDispute - Seller Approve Partial Refund
    [Documentation]   ReturnDispute - Seller Approve Partial Refund
    [Tags]  mik  mik-ReturnDispute  mik-ApprovePartialRefund
    Open Browser With URL  ${URL_MIK_SIGNIN}  miksellerUrl
    Sign in  ${seller_email}  ${seller_pwd}
    Seller Goods shelves
    Switch Browser  mikLandingUrl
    Check Out FGM And Go To Order  2
    Go To Seller Order And Shipments
    Go To Buyer Order And Return  0  8
    Seller First Time Handle Disputes   Approve Partial Refund  test  1
    Buyer Confirms Status of Disputes   Return Completed

Test ReturnDispute - Seller Approve Full Refund
    [Documentation]   ReturnDispute - Seller Approve Full Refund
    [Tags]  mik  mik-ReturnDispute  mik-ApproveFullRefund
    Open Browser With URL  ${URL_MIK_SIGNIN}  miksellerUrl
    Sign in  ${seller_email}  ${seller_pwd}
    Seller Goods shelves
    Switch Browser  mikLandingUrl
    Check Out FGM And Go To Order  3
    Go To Seller Order And Shipments
    Go To Buyer Order And Return  0  8
    Seller First Time Handle Disputes   Approve Full Refund
    Buyer Confirms Status of Disputes   Return Completed

Test ReturnDispute - Seller Rejected - Seller second Offer Full Refund
    [Documentation]   ReturnDispute - Seller Buyer All Rejected
    [Tags]  mik  mik-ReturnDispute  mik-OfferFullRefund
    Open Browser With URL  ${URL_MIK_SIGNIN}  miksellerUrl
    Sign in  ${seller_email}  ${seller_pwd}
    Seller Goods shelves
    Switch Browser  mikLandingUrl
    Check Out FGM And Go To Order  4
    Go To Seller Order And Shipments
    Go To Buyer Order And Return  0  8
    Seller First Time Handle Disputes   Reject Refund
    Buyer First Time Handle Disputes    2  test
    Seller second time Handle Disputes  Offer Full Refund  test  1
    Buyer Confirms Status of Disputes   Return Declined

