*** Settings ***
Resource            ../../Keywords/MP/DashboardKeywords.robot
Suite Setup          Run Keywords    Initial Env Data
...                   AND    Set Initial Data - Dashboard

Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Check Dashboard Business Actions Data
    [Documentation]  check dashbord business action data
    [Tags]    mp-ea
    Get Dashboard Business Actions Data - GET
    Get Order List Data - GET
    Check Orders Pending Confirmation Data
    Check Orders Awaiting Shipment Data
#    Check Returns Awaiting Action Data
#    Check Disputes Awaiting Action Data



Test Check Dashboard Store Sell Data - Yesterday
    [Documentation]  Check Dashboard Store Sell Data - Yesterday
    [Tags]      mp-ea
    Get Store Activities All Sell Data - GET
    Get Dashboard Store Activities Date By Date Flag- GET       1
    Check Store Activities Sell Data       1


Test Check Dashboard Store Sell Data - PastSevenDays
    [Documentation]  Check Dashboard Store Sell Data - PastSevenDays
    [Tags]      mp-ea
    Get Dashboard Store Activities Date By Date Flag- GET       2
    Check Store Activities Sell Data       2


Test Check Dashboard Store Sell Data - PastThirtyDays
    [Documentation]  Check Dashboard Store Sell Data - PastThirtyDays
    [Tags]      mp-ea
    Get Dashboard Store Activities Date By Date Flag- GET       3
    Check Store Activities Sell Data       3


Test Check Dashboard Store Sell Data - PastYear
    [Documentation]  Check Dashboard Store Sell Data - PastYear
    [Tags]      mp-ea
    Get Dashboard Store Activities Date By Date Flag- GET       4
    Check Store Activities Sell Data       4

Test Check Dashboard Store Sell Data - AllTime
    [Documentation]  Check Dashboard Store Sell Data - AllTime
    [Tags]      mp-ea
    Get Dashboard Store Activities Date By Date Flag- GET       5
    Check Store Activities Sell Data       5


Test Check Dashboard Store Listing Data
    [Documentation]  Check Dashboard Store Listing Data
    [Tags]      mp-ea
    Get Dashboard Store Activities Date By Date Flag- GET    5
    Get Store Listings Status Data By StoreID - GET
    Check Store Listings Status Data


Test Check Dashboard Store Available Balance
    [Documentation]  Check Dashboard Store Available Balance
    [Tags]      mp-ea
    Get Dashboard Store Activities Date By Date Flag- GET    5
    Check Store Available Balance Data
