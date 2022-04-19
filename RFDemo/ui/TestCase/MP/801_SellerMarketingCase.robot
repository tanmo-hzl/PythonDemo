*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerMarketingKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Marketing - Overview
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    ${User_Type}    ${Page_Name}


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/marketing-overview
${User_Type}    seller
${Page_Name}    mak
@{Day_Range}    1    3
${Cur_Promotion_Info}


*** Test Cases ***
Test Check Marketing Page Fixed Element text
    [Documentation]   [MKP-6566],Check Marketing page fixed element text
    [Tags]  mp    mp-ea    ea-store-setting    ea-marketing-ele
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerMarketingOverview.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}

Test Create Promotion - Spend & Get - % Off - Save Draft
    [Documentation]    Create new customer promotion by type - spend & get - % off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    99    ${null}    9    ${False}

Test Create Promotion - Spend & Get - % Off - Publish Scheduled
    [Documentation]    [MKP-6648],Create new customer promotion by type - spend & get - % off and publish Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    1
    Seller Marketing - Set Day Range    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    88    ${null}    8    ${True}

Test Create Promotion - Spend & Get - % Off - Publish Active
    [Documentation]    [MKP-6649],Create new customer promotion by type - spend & get - % off and publish Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    1
    Seller Marketing - Set Day Range    -1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    88    ${null}    8    ${True}

Test Create Promotion - Spend & Get - $ Amount Off - Save Draft
    [Documentation]    Create new promotion type to spend & get - $ amount off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Click Button Create Customer Promotion
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    99    ${null}    9    ${False}

Test Create Promotion - Spend & Get - $ Amount Off - Publish Scheduled
    [Documentation]    [MKP-6682],Create new promotion type to spend & get - $ amount off and Publish Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Set Day Range    1
    Seller Marketing - Click Button Create Customer Promotion
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    88    ${null}    7    ${True}

Test Create Promotion - Spend & Get - $ Amount Off - Publish Active
    [Documentation]    [MKP-6683],Create new promotion type to spend & get - $ amount off and Publish Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Set Day Range    -1
    Seller Marketing - Click Button Create Customer Promotion
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    88    ${null}    7    ${True}

Test Create Promotion - Buy & Get - % Off - Save Draft
    [Documentation]    Create new customer promotion by type - buy & get - % off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    3
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    10    2    9    ${False}

Test Create Promotion - Buy & Get - % Off - Publish Scheduled
    [Documentation]    [MKP-6718],Create new customer promotion by type - buy & get - % off and Publish Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    3
    Seller Marketing - Set Day Range    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    9    2    8    ${True}

Test Create Promotion - Buy & Get - % Off - Publish Active
    [Documentation]    [MKP-6719],Create new customer promotion by type - buy & get - % off and Publish Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    3
    Seller Marketing - Set Day Range    -1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    9    2    8    ${True}

Test Create Promotion - Buy A & Get A - Save Draft
    [Documentation]    Create new customer promotion by type - Buy A & Get A and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    4
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    10    2    ${null}    ${False}

Test Create Promotion - Buy A & Get A - Publish Scheduled
    [Documentation]    [MKP-6752],Create new customer promotion by type - Buy A & Get A and Publish Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    4
    Seller Marketing - Set Day Range    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    13    3    ${null}    ${True}

Test Create Promotion - Buy A & Get A - Publish Active
    [Documentation]    [MKP-6753],Create new customer promotion by type - Buy A & Get A and Publish Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    4
    Seller Marketing - Set Day Range    -1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    13    3    ${null}    ${True}

Test Create Promotion - Percent Off - Save Draft
    [Documentation]    Create new customer promotion by type - Percent Off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    5
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    ${null}    ${null}    12    ${False}

Test Create Promotion - Percent Off - Publish Scheduled
    [Documentation]    [MKP-6784],Create new customer promotion by type - Percent Off and Publish Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    5
    Seller Marketing - Set Day Range    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    ${null}    ${null}    10    ${True}

Test Create Promotion - Percent Off - Publish Active
    [Documentation]    [MKP-6785],Create new customer promotion by type - Percent Off and Publish Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    5
    Seller Marketing - Set Day Range    -1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    ${null}    ${null}    10    ${True}

Test Create Promotion - BMSM - % Off - Save Draft
    [Documentation]    Create new customer promotion by type - BMSM - % Off and save darft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    6
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    10    ${null}    12    ${False}

Test Create Promotion - BMSM - % Off - Publish Scheduled
    [Documentation]    [MKP-6818],Create new customer promotion by type - BMSM - % Off and Publish Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    6
    Seller Marketing - Set Day Range    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    11    ${null}    10    ${True}

Test Create Promotion - BMSM - % Off - Publish Active
    [Documentation]    [MKP-6819],Create new customer promotion by type - BMSM - % Off and Publish Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-create
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    6
    Seller Marketing - Set Day Range    -1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    11    ${null}    10    ${True}

Test Marketing Campaign - Update And Publish - Spend & Get - $ Amount Off
    [Documentation]    [MKP-6574,MKP-6720],Update promotion type to spend & get - $ amount off and publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-update
    Seller Marketing - Campaign - Filter By Status    Draft
    Seller Marketing - Campaign - Edit By Index
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Click Link Change Promotion Type
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Remove Added Product By Index    0
    Seller Marketing - Flow - Create&Update Promotion Info    ${Promotion_Type}    98    ${null}    8    ${True}

Test Marketing Campaign - Update Start Date Large Than Now Date And Publish
    [Documentation]    [MKP-6722,MKP-6581],Update promotion Start Date Large Than Now Date And Publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-update
    Seller Marketing - Campaign - Filter By Status    Scheduled
    Seller Marketing - Campaign - Edit By Index
    Seller Marketing - Set Day Range    2
    Seller Marketing - Set Start And End Time    ${Day_Range}[0]    ${Day_Range}[1]
    Seller Marketing - Create Promotion - Save And Continue
    Seller Marketing - Promotion Review - Publish Campaign

Test Marketing Campaign - Update Start Date Less Than Now Date And Publish
    [Documentation]    [MKP-6723,MKP-6581],Update promotion Start Date Less Than Now Date And Publish
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-update
    Seller Marketing - Campaign - Filter By Status    Scheduled
    Seller Marketing - Campaign - Edit By Index
    Seller Marketing - Set Day Range    -1
    Seller Marketing - Set Start And End Time    ${Day_Range}[0]    ${Day_Range}[1]
    Seller Marketing - Create Promotion - Save And Continue
    Seller Marketing - Promotion Review - Publish Campaign

Test Marketing Campaign - See More
    [Documentation]     [MKP-6567],Added promotion see more
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - See More By Index

Test Seller Marketing - Campaign - View Details After Filter By Status
    [Documentation]     [MKP-6572,MKP-6573,MKP-6579],Seller Marketing - Campaign - View Details After Filter By Status
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    [Template]    Seller Marketing - Campaign - View Details After Filter By Status
    Active
    Completed
    Draft
    Terminated
    Scheduled

Test Marketing Campaign - Filter By Date Range
    [Documentation]    [MKP-6616],Seller Marketing - Campaign - Filter By Date Range
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    ${filter_date_range}    Seller Marketing - Campaign - Filter By Date Range   -7    0
    Seller Marketing - Campaign - Check Results After Filter By Date Range    ${filter_date_range}

Test Marketing Campaign - Search By Message Then Filter
    [Documentation]    [MKP-6595,MKP-6616,MKP-6613], Marketing Campaign - Search Promotion By Message
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Common - Page Turning    Next
    Seller Marketing - Campaign - Wait Loading Hidden
    Seller Marketing - Campaign - Get Promotion Info By Index
    Seller Marketing - Campaign - Search     ${Cur_Pomotion_Msg}
    Seller Marketing - Campaign - Wait Loading Hidden
    Page Should Contain    ${Cur_Pomotion_Msg}
    Common - Page Turning    Last
    Seller Marketing - Campaign - Wait Loading Hidden
    Seller Marketing - Campaign - Get Promotion Info By Index
    Seller Marketing - Campaign - Filter By Status    ${Cur_Pomotion_Status}
    Page Should Contain    ${Cur_Pomotion_Status}
    Seller Marketing - Campaign - Clear Search Value

Test Marketing Campaign - Filter Then Search By Message
    [Documentation]    [MKP-6597,MKP-6618], Marketing Campaign - Search Promotion By Message
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - Clear Search Value
    Common - Page Turning    2
    Seller Marketing - Campaign - Wait Loading Hidden
    Seller Marketing - Campaign - Get Promotion Info By Index
    Seller Marketing - Campaign - Filter By Status    ${Cur_Pomotion_Status}
    Page Should Contain    ${Cur_Pomotion_Status}
    Seller Marketing - Campaign - Get Promotion Info By Index
    Seller Marketing - Campaign - Search     ${Cur_Pomotion_Msg}
    Seller Marketing - Campaign - Wait Loading Hidden
    Page Should Contain    ${Cur_Pomotion_Msg}
    Seller Marketing - Campaign - Clear Search Value

Test Marketing Campaign - Delete Draft Promotion
    [Documentation]    [MKP-6575],Delete added promotion which status is Draft
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - Filter By Status    Draft
    Seller Marketing - Campaign - Delete By Index

Test Marketing Campaign - Terminated Active Promotion
    [Documentation]    [MKP-6571],Terminated added promotion which status is Active
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - Filter By Status    Active
    Seller Marketing - Campaign - Terminated By Index

Test Marketing Campaign - Terminated Scheduled Promotion
    [Documentation]    [MKP-6580],Terminated added promotion which status is Scheduled
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Campaign - Scroll To End
    Seller Marketing - Campaign - Filter By Status    Scheduled
    Seller Marketing - Campaign - Terminated By Index

Test Marketing Effect - Go to Analytics for more details
    [Documentation]    [MKP-6565],Go to Analytics for more details and back
    [Tags]    mp    mp-ea    ea-marketing    ea-marketing-list
    Seller Marketing - Go To Analytics For More Details

Test Marketing - Jump To Advertisement
    [Documentation]    Jump to Advertisement page
    [Tags]    mp    ea-marketing    ea-marketing-list
    Store Left Menu - Marketing - Advertisement

