*** Settings ***
Resource            ../../Keywords/B2B/QuotesKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Quotes
Suite Teardown       Delete All Sessions

*** Test Cases ***
Test Get quotes List
    [Tags]    b2b    b2b-quotes
    Get quotes List - GET

Test CRU quotes with items by sales admin
    [Tags]    b2b    b2b-quotes  cru-quotes
    ${Quote_id}   Create Quotes with items - POST
    ${quotes_item_detail}  Get Quotes Items Details - GET   ${Quote_id}
    Update Quotes with items - PATCH  ${quotes_item_detail}
    Create Approve Quotes - PATCH  ${Quote_id}

