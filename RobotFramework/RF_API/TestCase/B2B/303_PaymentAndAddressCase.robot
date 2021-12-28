*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/PaymentAndAddressKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Payment And Address
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Get User Payment Methods List
    [Tags]   b2b    b2b-payment
    Get User Payment Methods List - GET

Test Add User Payment Methods
    [Documentation]    TODO,
    [Tags]   b2b    b2b-payment
#    Add User Payment Options - POST
    Log   TODO
    Skip

Test Get User Payment Methods Detail
    [Tags]   b2b    b2b-payment
    Get Payment Methods Detail - GET

Test Update User Payment Methods
    [Tags]   b2b    b2b-payment
    Update Payment Option - PATCH

Test Delete User Payment Method
    [Tags]   b2b    b2b-payment
#    Get User Payment Methods List - GET
    Log   ToDo, because there are no payment methods add
    Skip

Test Get User Address List
    [Tags]   b2b    b2b-address
    Get User Shipping Address List - GET

Test Add New Address
    [Tags]   b2b    b2b-address
    Add New Address - POST

Test Get Address Detail
    [Tags]   b2b    b2b-address
    Get Address Detail - GET

Test Update User Address
    [Tags]   b2b    b2b-address
    Update Address - PATCH

Test Delete User Shipping Address
    [Tags]   b2b    b2b-address    b2b-address1
    Get User Shipping Address List - GET    20
    ${address_len}    Get Length    ${User_Address_List}
    Skip If    ${address_len}<20
    Set Log Level    WARN
    Loop Delete User Shipping Address - DELETE    5
