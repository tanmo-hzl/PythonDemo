*** Settings ***
Resource            ../../Keywords/MP/SellerReportKeywords.robot
Resource            ../../Keywords/MP/SellerStoreSettingKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - Report
Suite Teardown       Delete All Sessions

*** Variables ***


*** Test Cases ***
Test Update Store Profile
    [Tags]    ea    ea-demo1
#    Get StoreName And StoreId By useId - GET
#    Get Report StoreSummary - POST
#    Get OrderStatistics - Get
#    Get Seller OrderList - Get
#    Get Top Selling Listings - GET
#    Get Dashboard Store Activities - Get
    Send Email Subscription - Post
