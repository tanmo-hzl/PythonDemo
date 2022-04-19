*** Settings ***
Resource            ../../Keywords/MAP/MarketplaceReturnDisputesKeywords.robot
Suite Setup         Run Keywords     Initial Env Data
...                 AND    Open Browser With URL    ${URL_MAP}
Suite Teardown      Close All Browsers
Test Setup          Skip If    '${Par_Case_Status}'=='FAIL' or '${Par_Case_Status}'=='SKIP'

*** Variables ***
${Cur_Dispute_ID}

*** Test Cases ***
Test Random Adjudication For Escalation Dispute
    [Documentation]   [MKP-5996],Michaels adjudication for escalation dispute
    [Tags]    mp    mp-ea    mp-map-disputes    mp-rsc
    Sign In Map With Admin Account
    Main Menu - To Marketplace
    Marketplace Left Menu - Resolution Center - Return Disputes
    MAP - Disputes - Search By Value     ${BUYER_NAME}
    MAP - Disputes - Search By Status     Escalated
    MAP - Disputes - Check Escalated Order Existed
    MAP - Disputes - View Dispute Detail By Index
    MAP - Disputes Detail - Click Review Escalation
    MAP - Disputes Detail - Click Provide Adjudication
    MAP - Disputes Adjudication - Get Adjudication Info
    MAP - Disputes Adjudication - Set Michaels Adjudication For Items
    MAP - Disputes Adjudication - Select I Acknowledge
    MAP - Disputes Adjudication - Click Submit
