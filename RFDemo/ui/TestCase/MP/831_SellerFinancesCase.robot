*** Settings ***
Resource            ../../Keywords/MP/SellerFinanceKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Teardown       Run Keyword If    "${TEST_STATUS}"=="FAIL"    Reload Page

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/finance-overview


*** Test Cases ***
Test Check Finances - Overview Page Fixed Element text
    [Documentation]   [MKP-6942],Check Overview page fixed element text
    [Tags]  mp    mp-ea    ea-fin    ea-fin-ele
    Store Left Menu - Finances - Overview
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerFinances.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    overview

Test Check Finances - Deposit Options Page Fixed Element text
    [Documentation]   [MKP-6877],Check Deposit Options page fixed element text
    [Tags]  mp    mp-ea    ea-fin    ea-fin-ele
    Store Left Menu - Finances - Deposit Options
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerFinances.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    depositOptions

Test Check Finances - Transactions Page Fixed Element text
    [Documentation]   Check Transactions page fixed element text
    [Tags]  mp    mp-ea    ea-fin    ea-fin-ele
    Store Left Menu - Finances - Transactions
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerFinances.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    transactions

Test Check Finances - Tax Information Page Fixed Element text
    [Documentation]   Check Tax Information page fixed element text
    [Tags]  mp    mp-ea    ea-fin    ea-fin-ele
    Store Left Menu - Finances - Tax Information
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerFinances.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    taxInformation

Test Change Bank Detail On Overview Page
    [Documentation]    [MKP-6943],Finanices change bank detail
    [Tags]    mp    mp-ea    ea-fin   ea-fin-bank
    Store Left Menu - Finances - Overview
    ${Bank_Detail}    Get Bank Detail Info
    Set Suite Variable    ${Bank_Detail}    ${Bank_Detail}
    Overview - Click Button Change
    Overview - Bank Details - Bank Account Info
    Overview - Bank Details - Bank Address Info
    Finance - Bank Details - Update

#    [MKP-6957], api
#    [MKP-6950], error bank detail

Test Edit Bank Detail On Deposit Options Page
    [Documentation]    [MKP-6949],Check bank detail is update
    [Tags]    mp    mp-ea    ea-fin    ea-fin-bank
    Store Left Menu - Finances - Deposit Options
    Deposit Options - Click Button Edit Bank Detail
    Finance - Bank Details - Update    ${False}

Test Add Additional Card With Virtual Address
    [Documentation]    [MKP-6918],Add new card With Virtual Address
    [Tags]    mp    mp-ea    ea-fin    ea-fin-card
    Store Left Menu - Finances - Deposit Options
    ${Card_Detail}    Get Card Detail Info    ${True}
    Set Suite Variable    ${Card_Detail}    ${Card_Detail}
    Deposit Options - Click Add Additional Card
    Deposit Options - Add Card Info
    Deposit Options - Billing Address
    Deposit Options - Add&Edit Card Save    ${False}    ${True}     ${False}

Test Add Additional Card With Real address
    [Documentation]    [MKP-6918],Add new card With Real Address
    [Tags]    mp    mp-ea    ea-fin    ea-fin-card
    Store Left Menu - Finances - Deposit Options
    Reload Page
    ${Card_Detail}    Get Card Detail Info    ${False}
    Set Suite Variable    ${Card_Detail}    ${Card_Detail}
    Deposit Options - Click Add Additional Card
    Deposit Options - Add Card Info
    Deposit Options - Billing Address
    Deposit Options - Add&Edit Card Save    ${True}    ${True}     ${True}

#[6959] 校验return完成时余额变动
#6957 提现 api
Test Edit Credit Cards
    [Documentation]    [MKP-7046],Edit card and check info
    [Tags]    mp    mp-ea    ea-fin    ea-fin-card
    Store Left Menu - Finances - Deposit Options
    Deposit Options - Select Last Credit Card
    Deposit Options - Click Edit Card Info
#    Deposit Options - Check New Card Info
    Deposit Options - Add&Edit Card Save    ${None}

Test Remove Credit Cards
    [Documentation]    [MKP-6917],Remove added card info
    [Tags]    mp    mp-ea    ea-fin    ea-fin-card
    Store Left Menu - Finances - Deposit Options
    Deposit Options - Select Last Credit Card
    Deposit Options - Remove Credit Card

Test Transactions Link And Search
    [Documentation]    [MKP-6920,MKP-6952],Link to transactions and search by order number
    [Tags]    mp    mp-ea    ea-fin    ea-fin-tran
    Store Left Menu - Finances - Overview
    Overview - View Transaction History
    Transactions - Get Order Number By Index    2
    Transactions - Search Order    ${Order_Number}
    Page Should Contain Element    //table//tbody/tr[1]/td[2]//p[contains(text(),"${Order_Number}")]

Test Transactions - Filter By Date Range
    [Documentation]    [MKP-6935,MKP-6936,MKP-6934],Filter transactions order By Date Range
    [Tags]    mp    mp-ea    ea-fin    ea-fin-tran-filter
    Store Left Menu - Finances - Transactions
    ${filter_date_range}    Transactions - Filter By Date Range    -7    0
    Transactions - Check Date Range Filter Results    ${filter_date_range}

Test Transactions Order Filter
    [Documentation]    [MKP-6937],Search transactions order By status
    [Tags]    mp    mp-ea    ea-fin    ea-fin-tran
    Store Left Menu - Finances - Transactions
    Transactions - Filter By Status Or Transaction Single    Pending
    Transactions - Get Order Number By Index

Test Transactions View Detail
    [Documentation]    Transactions view detail
    [Tags]    mp    mp-ea    ea-fin    ea-fin-tran
    Store Left Menu - Finances - Transactions
    Transactions - Filter By Status Or Transaction Single    Pending
    Transactions - Show Detail By Index
    Transactions - Check Details
    Transactions - Close

Test Transactions Link To Order Detail
    [Documentation]    [MKP-6936],Transactions link to order detail page then back dispute list page
    [Tags]    mp    mp-ea    ea-fin    ea-fin-tran
    Store Left Menu - Finances - Transactions
    Transactions - Filter By Status Or Transaction Single    Pending
    Transactions - Show Detail By Index    2
    Transactions - Click Link To Order Detail And Back

Test Transactions Edit Business Info But Not Save
    [Documentation]    Edit store bussiness info
    [Tags]    mp    mp-ea    ea-fin    ea-fin-tax
    Store Left Menu - Finances - Tax Information
    Tax Information - Check EIN Tips

Test Export Transactions To Xlsx On Overview Page And Check Results
    [Documentation]  [MKP-6954],Export transactions to xlsx on overview page and check results
    [Tags]    mp    mp-ea    ea-fin    ea-fin-export
    Store Left Menu - Finances - Overview
    Transactions - Export To Xlsx On Overview Page And Check Results

Test Export To Xlsx On Transactions Page By Transaction And Check Results
    [Documentation]  [MKP-7044],Export transactions to xlsx on Transactions page and check results
    [Tags]    mp    mp-ea    ea-fin    ea-fin-export
    [Template]    Transactions - Export To Xlsx On Transactions Page By Transaction And Check Results
    All
    Sale
    Refund
    Payout
    Cancellation
    Return Shipping Label Fee

