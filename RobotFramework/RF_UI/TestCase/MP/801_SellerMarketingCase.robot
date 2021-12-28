*** Settings ***
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerMarketingKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keyword    Initial Data And Open Browser   ${URL_MIK}
#Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS

*** Test Cases ***
Test Seller Sign In And Enter Storefront
    [Documentation]    Seller Sign In and enter Storefront Page
    [Tags]    mp    mp-marketing    mp-marketing-create-test    mp-marketing-list   mp-mk1-2   mp-mk6   mp-mk3   mp-mk4   mp-mk5
    Set Suite Variable    ${Cur_User_Name}    ${SELLER_NAME}
    User Sign In - MP    ${SELLER_EMAIL}    ${SELLER_PWD}    ${Cur_User_Name}
    Main Menu - Storefront Page
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Create New Customer Promotion - Spend & Get - % Off
    [Documentation]    Create new customer promotion by type - spend & get - % off
    [Tags]    mp    mp-marketing    mp-marketing-create-test    mp-mk1-2
    Store Left Menu - Marketing
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    1
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Click Link Change Promotion Type
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Input Promotion Name
    Seller Marketing - Set Start And End Time    1    3
    Seller Marketing - Click Button Select Product
    Seller Marketing - Select Product - Selected By Index
    Seller Marketing - Select Product - Add
    Seller Marketing - Input Conditions Value    99
    Seller Marketing - Input Get Value    9
    Seller Marketing - Check For Example Text By Promotion Type   ${Promotion_Type}    99    9
#    Seller Marketing - Create Promotion - Save And Continue
#    Seller Marketing - Promotion Review - Save As Draft
#    [Teardown]    Run Keyword If    '${TEST_STATUS}'=='FAIL'    Seller Marketing - Create Promotion - Close

Test Marketing Campaign - Edit And Publish - Spend & Get - $ Amount Off
    [Documentation]    Update promotion type to spend & get - $ amount off and publish
    [Tags]    mp    mp-marketing    mp-marketing-edit    mp-mk1-2
    Store Left Menu - Marketing
    Seller Marketing - Campaign - Search    ${Promotion_Code}
    Seller Marketing - Campaign - Edit By Index
    ${Promotion_Type}    Set Variable    2
    Seller Marketing - Click Link Change Promotion Type
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Input Promotion Name
    Seller Marketing - Set Start And End Time    1    3
    Seller Marketing - Remove Added Product By Index    1
    Seller Marketing - Click Button Select Product
    Seller Marketing - Select Product - Selected By Index
    Seller Marketing - Select Product - Add
    Seller Marketing - Input Conditions Value    99
    Seller Marketing - Input Get Value    9
    Seller Marketing - Check For Example Text By Promotion Type   ${Promotion_Type}    99    9
    Seller Marketing - Create Promotion - Save And Continue
    Seller Marketing - Promotion Review - Publish Campaign
    [Teardown]    Run Keyword If    '${TEST_STATUS}'=='FAIL'    Seller Marketing - Create Promotion - Close


Test Create New Customer Promotion - Buy & Get - % Off
    [Documentation]    Create new customer promotion by type - buy & get - % off
    [Tags]    mp    mp-marketing    mp-marketing-create    mp-mk3
    Store Left Menu - Marketing
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    3
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Input Promotion Name
    Seller Marketing - Set Start And End Time    1    3
    Seller Marketing - Click Button Select Product
    Seller Marketing - Select Product - Selected By Index   2
    Seller Marketing - Select Product - Add
    Seller Marketing - Input Conditions Value    10
    Seller Marketing - Input Get Value    1
    Seller Marketing - Input Off Value    9
    Seller Marketing - Check For Example Text By Promotion Type   ${Promotion_Type}    10    1    9
    Sleep    10
    Seller Marketing - Create Promotion - Save And Continue
    Seller Marketing - Promotion Review - Save As Draft
    [Teardown]    Run Keyword If    '${TEST_STATUS}'=='FAIL'    Seller Marketing - Create Promotion - Close


Test Create New Customer Promotion - Buy A & Get B - Free
    [Documentation]    Create new customer promotion by type - Buy A & Get B - Free
    [Tags]    mp    mp-marketing    mp-marketing-create   mp-mk4
    Store Left Menu - Marketing
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    4
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Input Promotion Name
    Seller Marketing - Set Start And End Time    1    3
    Seller Marketing - Click Button Select Product
    Seller Marketing - Select Product - Selected By Index   3
    Seller Marketing - Select Product - Add
    Seller Marketing - Input Conditions Value    10
    Seller Marketing - Click Button Choose Gift
    Seller Marketing - Select Product - Selected By Index    4
    Seller Marketing - Select Product - Add
    Seller Marketing - Check For Example Text By Promotion Type   ${Promotion_Type}    10    1
    Seller Marketing - Create Promotion - Save And Continue
    Seller Marketing - Promotion Review - Publish Campaign
    [Teardown]    Run Keyword If    '${TEST_STATUS}'=='FAIL'    Seller Marketing - Create Promotion - Close


Test Create New Customer Promotion - Percent Off
    [Documentation]    Create new customer promotion by type - Percent Off
    [Tags]    mp    mp-marketing    mp-marketing-create    mp-mk5
    Store Left Menu - Marketing
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    5
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Input Promotion Name
    Seller Marketing - Set Start And End Time    1    3
    Seller Marketing - Input Conditions Value    12
    Seller Marketing - Click Button Select Product
    Seller Marketing - Select Product - Selected By Index    5
    Seller Marketing - Select Product - Add
    Seller Marketing - Check For Example Text By Promotion Type   ${Promotion_Type}    12
    Seller Marketing - Create Promotion - Save And Continue
    Seller Marketing - Promotion Review - Publish Campaign
    [Teardown]    Run Keyword If    '${TEST_STATUS}'=='FAIL'    Seller Marketing - Create Promotion - Close


Test Create New Customer Promotion - BMSM - % Off
    [Documentation]    Create new customer promotion by type - BMSM - % Off
    [Tags]    mp    mp-marketing    mp-marketing-create   mp-mk6
    Store Left Menu - Marketing
    Seller Marketing - Click Button Create Customer Promotion
    ${Promotion_Type}    Set Variable    6
    Seller Marketing - Promotion Type - Select By Index    ${Promotion_Type}
    Seller Marketing - Input Promotion Name
    Seller Marketing - Set Start And End Time    1    3
    Seller Marketing - Input Conditions Value    10
    Seller Marketing - Input Get Value    12
    Seller Marketing - Click Button Select Product
    Seller Marketing - Select Product - Selected By Index    6
    Seller Marketing - Select Product - Add
    Seller Marketing - Check For Example Text By Promotion Type   ${Promotion_Type}    10    12
    Seller Marketing - Create Promotion - Save And Continue
    Seller Marketing - Promotion Review - Save As Draft
    [Teardown]    Run Keyword If    '${TEST_STATUS}'=='FAIL'    Seller Marketing - Create Promotion - Close


Test Marketing Campaign - See More And Detail
    [Documentation]     Added promotion see more and detail
    [Tags]    mp    mp-marketing    mp-marketing-list
    Seller Marketing - Campaign - See More By Index
    Seller Marketing - Campaign - View Details By Index

Test Marketing Campaign - Delete Draft Promotion
    [Documentation]    Delete added promotion with status is Draft
    [Tags]    mp    mp-marketing    mp-marketing-list
    Store Left Menu - Marketing
    Seller Marketing - Campaign - Filters Search By Status    Draft
    Seller Marketing - Campaign - Delete By Index

Test Marketing Campaign - Terminated Active Promotion
    [Documentation]    Terminated added promotion with status is Active
    [Tags]    mp    mp-marketing    mp-marketing-list
    Store Left Menu - Marketing
    Seller Marketing - Campaign - Filters Search By Status    Active
    Seller Marketing - Campaign - Terminated By Index

Test Marketing Effect - Go to Analytics for more details
    [Documentation]    Go to Analytics for more details and back
    [Tags]    mp    mp-marketing    mp-marketing-list
    Seller Marketing - Go To Analytics For More Details