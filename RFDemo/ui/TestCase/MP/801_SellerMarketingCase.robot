*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerMarketingKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Marketing
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/marketing
${User_Type}    seller
${Page_Name}    mak
@{Day_Range}    1    7


*** Test Cases ***
Test Check Marketing Page Fixed Element text
    [Documentation]   Check Marketing page fixed element text
    [Tags]  mp    mp-ea    ea-store-setting    ea-store-setting-ele
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerMarketingOverview.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}

Test Create New Customer Promotion - Spend & Get - % Off - Save Draft
    [Documentation]    Create new customer promotion by type - spend & get - % off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    99    ${null}    9    ${False}

Test Create New Customer Promotion - Spend & Get - % Off - Publish
    [Documentation]    Create new customer promotion by type - spend & get - % off and publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    88    ${null}    8    ${True}

Test Create New Customer Promotion - Spend & Get - $ Amount Off - Save Draft
    [Documentation]    Create new promotion type to spend & get - $ amount off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Click Button Create Customer Promotion
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    99    ${null}    9    ${False}

Test Create New Customer Promotion - Spend & Get - $ Amount Off - Publish
    [Documentation]    Create new promotion type to spend & get - $ amount off and Publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Click Button Create Customer Promotion
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    88    ${null}    7    ${True}

Test Create New Customer Promotion - Buy & Get - % Off - Save Draft
    [Documentation]    Create new customer promotion by type - buy & get - % off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    3
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    10    2    9    ${False}

Test Create New Customer Promotion - Buy & Get - % Off - Publish
    [Documentation]    Create new customer promotion by type - buy & get - % off and Publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    3
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    9    2    8    ${True}

Test Create New Customer Promotion - Buy A & Get A - Save Draft
    [Documentation]    Create new customer promotion by type - Buy A & Get A and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    4
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    10    2    ${null}    ${False}

Test Create New Customer Promotion - Buy A & Get A - Publish
    [Documentation]    Create new customer promotion by type - Buy A & Get A and Publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    4
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    13    3    ${null}    ${True}

Test Create New Customer Promotion - Percent Off - Save Draft
    [Documentation]    Create new customer promotion by type - Percent Off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    5
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    ${null}    ${null}    12    ${False}

Test Create New Customer Promotion - Percent Off - Publish
    [Documentation]    Create new customer promotion by type - Percent Off and Publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    5
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    ${null}    ${null}    10    ${True}

Test Create New Customer Promotion - BMSM - % Off - Save Draft
    [Documentation]    Create new customer promotion by type - BMSM - % Off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    6
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    10    ${null}    12    ${False}

Test Create New Customer Promotion - BMSM - % Off - Publish
    [Documentation]    Create new customer promotion by type - BMSM - % Off and Publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    6
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    11    ${null}    10    ${True}

Test Marketing Campaign - Update And Publish - Spend & Get - $ Amount Off
    [Documentation]    Update promotion type to spend & get - $ amount off and publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-update
    Seller Marketing - Campaign - Filter Search By Status    Draft
    Seller Marketing - Campaign - Edit By Index
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Click Link Change Promotion Type
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Remove Added Product By Index    0
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    98    ${null}    8    ${True}

Test Marketing Campaign - See More And Detail
    [Documentation]     Added promotion see more and detail
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - See More By Index
    Seller Marketing - Campaign - View Details By Index

Test Marketing Campaign - Delete Draft Promotion
    [Documentation]    Delete added promotion which status is Draft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - Filter Search By Status    Draft
    Seller Marketing - Campaign - Delete By Index

Test Marketing Campaign - Terminated Active Promotion
    [Documentation]    Terminated added promotion which status is Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - Filter Search By Status    Active
    Seller Marketing - Campaign - Terminated By Index

Test Marketing Campaign - Terminated Scheduled Promotion
    [Documentation]    Terminated added promotion which status is Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - Filter Search By Status    Scheduled
    Seller Marketing - Campaign - Terminated By Index

Test Marketing Effect - Go to Analytics for more details
    [Documentation]    Go to Analytics for more details and back
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Go To Analytics For More Details