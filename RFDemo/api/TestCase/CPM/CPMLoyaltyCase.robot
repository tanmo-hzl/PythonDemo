*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/LoyaltyKeywords.robot

*** Test Cases ***
Remove User ID to Loyalty ID Mapping Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Remove User ID to Loyalty ID Mapping Positive
    Sign in - MIK - User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${email}    get json value    ${User_Inof}    user    email
    CPM Create Register Loyalty and associate users- POST    ${email}    ${user_id}
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Delete User To Loyalty- DELETE    ${user_id}    ${loyaltyId}

Remove User ID to Loyalty ID Mapping Negative-1
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Remove User ID to Loyalty ID Mapping Negative-1
    Sign in - MIK - User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${email}    get json value    ${User_Inof}    user    email
    CPM Create Register Loyalty and associate users- POST    ${email}    ${user_id}
    CPM Delete User To Loyalty- DELETE    ${user_id}    342423342    404

Remove User ID to Loyalty ID Mapping Negative-2
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Remove User ID to Loyalty ID Mapping Negative-2
    Sign in - MIK - User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${email}    get json value    ${User_Inof}    user    email
    CPM Create Register Loyalty and associate users- POST    ${email}    ${user_id}
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Delete User To Loyalty- DELETE    4612645892195111111    342423342    404

Create A Loyalty Account Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Create A Loyalty Account Negative
    Sign in ENV - MIK -User
    CPM Create Account Registration- POST

Active The CRM Offers In Loyalty Database Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Active The CRM Offers In Loyalty Database Positive
    Sign in ENV - MIK -User
    CPM Create Activate Crm Offers- POST    ECOM    1343243    1199    InStore

Active The CRM Offers In Loyalty Database Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Active The CRM Offers In Loyalty Database Negative
    Sign in ENV - MIK -User
    CPM Create Activate Crm Offers- POST    ECOM    23456    1199    InStore

Check Discount Status Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Check Discount Status Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Create Check Discount- POST    ${loyaltyId}

Check Discount Status Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Check Discount Status Negative
    Sign in ENV - MIK -User
    CPM Create Check Discount- POST    123456    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    404

Looks Up An existing Loyalty Customer's Profile Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Looks Up An existing Loyalty Customer's Profile Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Create Customer Look UP- POST    ${loyaltyId}

Get All Active Cards Information Associated To Loyalty Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Get All Active Cards Information Associated To Loyalty Negative
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Create Customer Look UP Negative- POST    12344567    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${null}    ${False}

Complete Points Rddemption In Loyalty System Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Complete Points Rddemption In Loyalty System Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Get Loyalty Cards- Get    ${loyaltyId}    test    Get Card Details successfull

Get All Active Cards Information Associated To Loyalty Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Looks Up An existing Loyalty Customer's Profile Negative
    Sign in ENV - MIK -User
    CPM Get Loyalty Cards- Get    ${null}    ${null}    No Card found

Retrigger Marking Email To Resend The Card To Customer Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Retrigger Marking Email To Resend The Card To Customer Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Create Retrigger Marketing Email- POST    ECOM    ${loyaltyId}

Retrigger Marking Email To Resend The Card To Customer Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Retrigger Marking Email To Resend The Card To Customer Negative
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Create Retrigger Marketing Email- POST    ECOM    1231432

Changes The Segment Of Loyalty Account Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Changes The Segment Of Loyalty Account Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Create Segment- POST    ${loyaltyId}    Automation    ECOM

Changes The Segment Of Loyalty Account Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Changes The Segment Of Loyalty Account Negative
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Create Segment- POST    321312    Automation    ECOM    21010

Deletes A Segment From The Loyalty Account Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Deletes A Segment From The Loyalty Account Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Delete Segment- Delete   ${loyaltyId}    Automation

Deletes A Segment From The Loyalty Account Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Deletes A Segment From The Loyalty Account Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    ${resp}    CPM Get Loyalty by user id- Get    ${user_id}
    ${loyaltyId}    get from dictionary    ${resp}    loyaltyId
    CPM Delete Segment- Delete   13424342    Automation    21000

Get All Active Cards Information Associated To Loyalty Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Looks Up An existing Loyalty Customer's Profile Negative
    Sign in ENV - MIK -User
    CPM Get Loyalty Cards- Get    ${null}    ${null}    No Card found

Get Loyalty ID By User ID Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Get Loyalty ID By User ID Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Loyalty by user id- Get    ${user_id}

Get Loyalty ID By User ID Negative
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Get Loyalty ID By User ID Negative
    Sign in ENV - MIK -User
    CPM Get Loyalty by user id- Get    123345    404

Get User Loyalty Info Positive
    [Tags]    cpm-loyalty    cpm-Smoke
    [Documentation]    Get User Loyalty Info Positive
    Sign in ENV - MIK -User
    ${user_id}    get json value    ${User_Inof}    user    id
    CPM Get Loyalty Info- Get    ${user_id}