*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerDashboardKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}      SellerDashboard
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
...                             AND    API - Seller Sign In
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Dashboard


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/dashboard


*** Test Cases ***
Test Check Dashboard Fixed Element Text
    [Documentation]    Check Fixed Element Text
    [Tags]    mp    mp-ea    ea-dashboard
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerDashboard.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}

Test Check Visit Your Live Store Here
    [Documentation]  check visit your live store
    [Tags]      mp      mp-ea       ea-dashboard        dashboard-live-store
    Check Visit Your Live Store Here

Test Check The Data Of Cards In Scroll Box
    [Documentation]     check the data of cards in scroll box
    [Tags]      mp      mp-ea       ea-dashboard        dashboard-scroll-box
    Check The Data Of Cards In Scroll Box

Test Check Dashboard Store Activities Data
    [Documentation]  check dashboard Store Activities data
    [Tags]  mp     mp-ea    ea-dashboard    dashboard-store-activities
    Get Dashboard Store Activities Data - GET
    Check Dashboard Store Activites Data

Test Check Dashboard Business Actions Listing Data
    [Documentation]     check dashboard business actions listing data
    [Tags]     mp     mp-ea     ea-dashboard       dashboard-business        dashboard-business-actions-listing
    Seller Dashboard - Get Page Info
    Check Dashboard Business Actions Listing Data

Test Check Dashboard Business Actions Order Data
    [Documentation]     check dashboard business actions order data
    [Tags]     mp     mp-ea     ea-dashboard       dashboard-business        dashboard-business-actions-order
    Check Dashboard Business Actions Order Data

Test Check Dashboard Business Actions Marketing Data
    [Documentation]     check dashboard business actions marketing data
    [Tags]     mp     mp-ea     ea-dashboard       dashboard-business        dashboard-business-actions-marketing
    Check Dashboard Business Actions Marketing Data

Test Check The Redirect address Of the Dashboard Page Link
    [Documentation]     Check the redirect address of the dashboard page link
    [Tags]      mp      mp-ea       dashboard-page-link
    [Template]      Check The Redirect Address Of The Dashboard Page Link
    # My Storefront
    Visit Live Store                        //h1[text()="CONTACT INFO"]
    Select Store Template                   //h2[text()="My Storefront"]
    Setup Product Groups                    //h2[text()="Product Groups"]
    # Store Setting
    Update Store Profile                    //h2[text()="Store Profile"]
    Update Customer Service                 //h2[text()="Customer Service"]
    Update Fulfillment Information          //h2[text()="Fulfillment"]
    Update Return Information               //h2[text()="Return Policy"]
    # Finances
    View All Transactions                   //h2[text()="Transactions"]
    Manage Wallets                          //h2[text()="Payments"]
    Update Business Information             //h2[text()="Tax Information"]
    # Account Setting
    Change Password                         //div[text()="Change Password"]
    View Device History                     //div[text()="Device History"]
    # Reports
    View Store Data                         //h3[text()="Explore Your Data"]
    View Your Top Selling List              //h3[text()="Top Selling Items"]
    View Top Search Keywords                //h2[text()="Your Top Search Keywords"]
    # Messages
    View Messages                           //h2[text()="Messages"]