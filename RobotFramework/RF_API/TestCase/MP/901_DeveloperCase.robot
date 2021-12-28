*** Settings ***
Resource            ../../Keywords/MP/DeveloperKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - Developer
Suite Teardown       Delete All Sessions


*** Test Cases ***

Test Get Order Query
    [Tags]    mp   dev
    Get Order List Query - GET    ${null}

Test Get Order Detail By Order Number
    [Tags]   mp   dev
    Get Order Detail By Order Number - GET

Test Order Confirm
    [Tags]   mp   dev
    Get Order List Query - GET    PENDING_CONFIRMATION
    Get Order Detail By Order Number - GET
    Order Confirm - POST

Test Order Shipment
    [Tags]   mp   dev
    Get Order List Query - GET    READY_TO_SHIP
    Get Order Detail By Order Number - GET
    Order Shipment - POST

Test Order Cancel
    [Tags]   mp   dev
    Get Order List Query - GET    PENDING_CONFIRMATION
    Get Order Detail By Order Number - GET
    Order Cancel - POST

Test Get Return Order Query
    [Tags]   mp   dev
    Get Return Order Query - GET

Test Get Return Order By Return Order Number
    [Tags]  mp   dev
    Get Return Order Detail By Return Order Number

Test Get Return Order By Order Number
    [Tags]  mp   dev
    Get Return Order Detail By Order Number

Test Return Order Approve
    [Tags]  mp   dev
    Get Return Order Query - GET
    Return Order Approval

Test Return Order Reject
    [Tags]  mp   dev
    Return Order Reject
