*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/OrderKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Order
Suite Teardown       Delete All Sessions

*** Variables ***
${Is_skip}

*** Test Cases ***
Test Get Past Order List
    [Tags]    b2b    b2b-order
    Get Past Order List - POST

Test Search Past Order List By Query
    [Tags]    b2b    b2b-order
    Search Past Order By Query - POST

Test Get Past Order Detail
    [Tags]    b2b    b2b-order
    Get Past Order Detail - GET

Test Cancel Order
    [Tags]    b2b    b2b-order
    Cancel Past Order - POST

Test Get Pending Order List By Query
    [Tags]    b2b    b2b-order
    Search Pending Order By Query - POST

Test Get Pending Order Detail
    [Tags]    b2b    b2b-order
    Get Pending Order Detail - GET

Test Update Purchase Order Number For Pending Order
    [Tags]    b2b    b2b-order
    Update Purchase Order Number For Pending Order - POST

Test Reject Pending Order
    [Tags]    b2b    b2b-order
    ${is_skip}    Evaluate    random.randint(0,10)
    Set Suite Variable    ${Is_skip}    ${Is_skip}
    Skip If    ${Is_skip}>5
    Reject Pending Order - PATCH

Test Approve Pending Order
    [Tags]    b2b    b2b-order
    Skip If    ${Is_skip}<=5
    Search Pending Order By Query - POST
    Approve Pending Order - PATCH
