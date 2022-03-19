*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodySellerReport.py
Resource            ../../TestData/MP/PathSellerReport.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller_headers}
${seller_headers_post}
${seller_info_sign}
${seller_store_id}
${seller-account}
${variant_contents}

*** Keywords ***
Set Initial Data - Report
    Mik Seller Sign In Scuse Of Order - POST    ${seller-account}
    ${seller_headers}    Set Get Headers - Seller
    Set Suite Variable    ${seller_headers}    ${seller_headers}
    ${seller_headers_post}    Set Post Headers - Seller
    Set Suite Variable    ${seller_headers_post}    ${seller_headers_post}
    ${seller_info_sign}    Set Variable     ${null}
    ${seller_info_sign}    Run Keyword If    '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
    Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}
    ${seller_store_id}    Get Json Value    ${seller_info_sign}    sellerStoreProfile    sellerStoreId
    Set Suite Variable    ${seller_store_id}    ${seller_store_id}

Get Text ModerateForm - Post
    ${res}    Send Post Request    ${url-mik}    ${report-text-moderateForm}    ${seller_headers_post}

Get Top Selling Listings - Get
    ${body}   create dictionary  startTime=1645027199999    orderBy=sales
    ${res}    Send Get Request    ${url-mik}    ${report-top-selling}    ${body}    ${seller_headers}

#Get Top Selling Listings With Trending - GET
#    [Arguments]    ${timeOption}    ${orderBy}    ${pastDays}
#    ${res}    Send Get Request    ${url-mik}    ${report-top-selling-products}    ${seller_headers}
#
#Get Listing Management Sla Notification - GET
#    ${res}    Send Get Request    ${url-mik}    ${report-listings-notification}    ${seller_headers_post}


Get Report StoreSummary - Post
    ${body}    create dictionary    timeInterval=5    startDate=${None}    endDate=${None}    index=listing_views
    ${res}    Send Post Request - Params    ${url-mik}    ${report-storeSummary}/${seller_store_id}/lineChartData    ${body}    ${seller_headers_post}

Get OrderStatistics - Get
    ${body}    create dictionary    startTime=-1507968000001    endTime=1645631999999
    ${res}    Send Get Request    ${url-mik}    ${seller-orderStatistics}   ${body}    ${seller_headers}

Get Seller OrderList - Get
    ${body}    create dictionary    startTime=-1507968000001    endTime=1645631999999    orderStatusList=3000,3500,6800,7000,7300,7500,8000,8500,8600,8700,9000,9700,10000    currentPage=1    pageSize=1    simpleMode=true
    ${res}    Send Get Request    ${url-mik}    ${seller-orderList}   ${body}    ${seller_headers}

Get Dashboard Store Activities - Get
    ${body}    create dictionary    timeOption=5
    ${res}    Send Get Request    ${url-mik}    ${seller-orderStatistics}    ${body}    ${seller_headers}

Send Email Subscription - Post
    ${body}   send email subscription body
    ${res}    Send Post Request     ${url-mik}    ${email-subscription}    ${body}    ${seller_headers_post}
