*** Settings ***
Resource            ../../Keywords/MP/UserKeywords.robot
Resource            ../../Keywords/MP/ListingKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - Listing
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Get Seller Listing List
    [Tags]    mp   listing
    Get Seller Listings List - GET