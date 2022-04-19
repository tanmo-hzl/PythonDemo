*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerReturnsKeywords.robot
Resource            ../../Keywords/MP/SellerMessageKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
...                             AND    API - Seller Sign In
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Order Management - Returns
Test Teardown       Go To Expect Url Page    ${TEST STATUS}    seller    ret

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/returns
@{Return_Status}    Pending Return    Refund Rejected    Returned    Return Cancelled    Pending Refund

*** Test Cases ***
Test Check Returns Page Fixed Element text
    [Documentation]   Check returns page fixed element text
    [Tags]  mp    mp-ea    ea-s-return        ea-s-return-ele
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerOrderManagement.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    returns

Test Seller Enter Return Detail Page And Check Fixed Element
    [Documentation]    [MKP-6967],Enter return detail page and check fixed element
    [Tags]    mp    mp-ea    ea-s-return        ea-s-return-ele
    Seller Returns - Enter Return Detail Page By Line Index
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerReturnDetail.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}

Test Seller Search Order By Return ID
    [Documentation]    [MKP-5912],Search return order by  Return ID
    [Tags]    mp    mp-ea    ea-s-return
    Seller Returns - Filter - Clear All Filter
    Seller Returns - Get Return Order Info By Line Index
    Seller Returns - Search Order By Return ID    ${Return_ID}
    Page Should Contain Element    //p[text()="${Return_ID}"]
    Seller Returns - Clear Search Value

Test Seller Search Order By Order Number
    [Documentation]    [MKP-5912],Search return order by Order Number
    [Tags]    mp    mp-ea    ea-s-return
    Seller Returns - Filter - Clear All Filter
    Seller Returns - Get Return Order Info By Line Index
    Seller Returns - Search Order By Return ID    ${Order_Number}
    Page Should Contain Element    //p[text()="${Order_Number}"]
    Seller Returns - Clear Search Value

Test Seller Submit Return Decision - No Refund And Full Refund And Default
    [Documentation]    [MKP-5947],Seller Submit Return Decision - No Refund And Full Refund And Default
    [Tags]    mp    mp-ea    ea-s-return    mp-rsc
    Seller Returns - Get Pending Return Order By API    noReturned    3
    Seller Returns - Go To Return Order Detail Page
    Seller Returns - Select Decision By Index    1    ${False}
    Seller Returns - Select Decision By Index    1    ${True}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page
    Seller Returns - Check Return Order Status By API    ${Return_Status[2]}

Test Seller Submit Return Decision - No Selected Decision Or Reason
    [Documentation]    [MKP-5941,MKP-5943],Seller Submit Return Decision - No Selected Decision Or Reason
    [Tags]    mp    mp-ea    ea-s-return   ea-s-return-tip
    Seller Returns - Get Pending Return Order By API    noReturned    2
    Seller Returns - Go To Return Order Detail Page
    Seller Returns - Click Button Submit Refund Decision
    Wait Until Page Contains    Please select a decision
    Wait Until Page Does Not Contain    Please select a decision
    Seller Returns - Select Decision By Index    1    ${False}    ${False}
    Seller Returns - Click Button Submit Refund Decision
    Wait Until Page Contains Element    //p[contains(text(),"Enter A Reason For No Refund")]
    Seller Returns - Back To Return List On Return Detail Page

Test Seller Submit Return Decision - Full Refund And Default Decision
    [Documentation]    [MKP-5944],Seller Submit Return Decision - Full Refund And Default Decision
    [Tags]    mp    mp-ea    ea-s-return    mp-rsc
    Seller Returns - Get Pending Return Order By API    noReturned    2
    Seller Returns - Go To Return Order Detail Page
    Seller Returns - Select Decision By Index    1    ${True}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page
    Seller Returns - Check Return Order Status By API    ${Return_Status[2]}

Test Seller Submit Return Decision - No Refund And Default Decision
    [Documentation]    [MKP-5945],Seller Submit Return Decision - Full Refund And Default Decision
    [Tags]    mp    mp-ea    ea-s-return    mp-rsc
    Seller Returns - Get Pending Return Order By API    noReturned    2
    Seller Returns - Go To Return Order Detail Page
    Seller Returns - Select Decision By Index    1    ${False}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page
    Seller Returns - Check Return Order Status By API    ${Return_Status[1]}

Test Seller Submit Return Decision - No Refund And Full Refund
    [Documentation]    [MKP-5946],Seller Submit Return Decision - No Refund And Full Refund
    [Tags]    mp    mp-ea    ea-s-return    mp-rsc
    Seller Returns - Get Pending Return Order By API    noReturned    2
    Seller Returns - Go To Return Order Detail Page
    Seller Returns - Select Decision By Index    1    ${False}
    Seller Returns - Select Decision By Index    1    ${True}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page
    Seller Returns - Check Return Order Status By API    ${Return_Status[1]}

Test Seller Submit Return Decision For Have Returned Items Order - No Refund
    [Documentation]    [MKP-5952,MKP-5939,MKP-5955],Seller Submit Return Decision For Have Returned Items Order
    [Tags]    mp    mp-ea    ea-s-return    mp-rsc
    Seller Returns - Get Pending Return Order By API    haveReturned
    Seller Returns - Go To Return Order Detail Page
    Page Should Contain Element    //p[text()="Status"]/following-sibling::p[text()="Returned"]
    Seller Returns - Set All Items Full Or No Refund    ${False}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page
    Seller Returns - Check Return Order Status By API    ${Return_Status[2]}

Test Seller Submit Return Decision For Have Returned Items Order - Full Refund
    [Documentation]    [MKP-5952,MKP-5939,MKP-5954],Seller Submit Return Decision For Have Returned Items Order
    [Tags]    mp    mp-ea    ea-s-return    mp-rsc
    Seller Returns - Get Pending Return Order By API    haveReturned
    Seller Returns - Go To Return Order Detail Page
    Page Should Contain Element    //p[text()="Status"]/following-sibling::p[text()="Returned"]
    Seller Returns - Set All Items Full Or No Refund    ${True}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page
    Seller Returns - Check Return Order Status By API    ${Return_Status[2]}

Test Seller Submit Return Decision - All Full Refund
    [Documentation]    [MKP-5940,MKP-5953],Seller Submit Return Decision - All Full Refund
    [Tags]    mp    mp-ea    ea-s-return   ea-s-return-approve    mp-rsc
    Seller Returns - Get Pending Return Order By API    noReturned    0
    Seller Returns - Go To Return Order Detail Page
    Seller Returns - Set All Items Full Or No Refund    ${True}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page
    Seller Returns - Check Return Order Status By API    ${Return_Status[1]}

Test Seller Submit Return Decision - All No Refund
    [Documentation]    [MKP-5942],Seller Submit Return Decision - All No Refund
    [Tags]    mp    mp-ea    ea-s-return   ea-s-return-rejected    mp-rsc
    Seller Returns - Get Pending Return Order By API    noReturned    0
    Seller Returns - Go To Return Order Detail Page
    Seller Returns - Set All Items Full Or No Refund    ${False}
    Seller Returns - Submit Refund Decision Pop-Ups
    Seller Returns - Back To Return List On Return Detail Page

Test Compare Order And Return Detail Data By API
    [Documentation]    [MKP-5960,MKP-5961.MKP-5962],check return order shipping rate
    [Tags]    mp    mp-ea    ea-s-return   ea-s-return-check    mp-rsc
    [Template]    Seller Returns - Compare Order And Return Detail Data By API
    0
    1
    2
    3
    4
    5
    6
    7
    8
    9

Test Seller Submit Refund Decision - No Refund By API - Do Many Times
    [Documentation]    [MKP-5960,MKP-5961.MKP-5962],check return order shipping rate
    [Tags]    mp    mp-ea    ea-init-data   mp-rsc
    [Template]  Seller Returns - Flow - Submit Refund Decision By API
    1    noReturned    1    ${True}    reject
    2    noReturned    1    ${True}    reject
    3    noReturned    1    ${True}    reject
    4    noReturned    1    ${True}    reject
    5    noReturned    1    ${True}    reject


Test Seller Filter Order By Duration And Status
    [Documentation]  Seller filters order by Duration And Status
    [Tags]    mp    mp-ea    ea-s-return    ea-s-return-filter
    [Template]    Seller Returns - Filter - Search By Duration And Status
    Past 7 Days     Returned    Refund Rejected
    Past 30 Days    Pending Return    Return Canceled

Test Seller Filter Returns Order By Status And Check Result
    [Documentation]  Seller filters order by status and check result
    [Tags]    mp    mp-ea    ea-s-return    ea-s-return-filter
    [Template]    Seller Returns - Filter - Search By Status And Check Result
    1
    2
    3
    5

Test Seller Filter Returns Order By Duration And Check Result
    [Documentation]  Seller filters order by Duration and check result
    [Tags]    mp    mp-ea    ea-s-return    ea-s-return-filter
    [Template]    Seller Returns - Filter - Search By Duration And Check Result
    All Time
    Today
    Yesterday
    Past 7 Days
    Past 30 Days
    Past 6 Months

Test Enter Order Detail Page And Back
    [Documentation]  [MKP-6968],Seller enter order detail page on return page then back to return page
    [Tags]    mp    mp-ea    ea-s-return
    Seller Returns - Enter Order Detail Page By Line Index
    Seller Returns - Back To Return List On Order Detail Page

Test Click Return Table Header Text To Sort Data And Check Result
    [Documentation]    Click Return Table Header Text To Sort Data And Check Result
    [Tags]    mp    mp-ea    ea-s-return-sort
    [Template]    Common - Check Sort Data After Click Table Header Text
    Return ID           firstClick      iconNotFollow       1       string
    Return ID           secondClick     iconNotFollow       1       string
    Status              firstClick      iconNotFollow       3       status
    Status              secondClick     iconNotFollow       3       status
    Order Number        firstClick      iconNotFollow       4       string
    Order Number        secondClick     iconNotFollow       4       string

Test Contact Buyer On Return Detail Page
    [Documentation]    Contact buyer on return detail page
    [Tags]    mp    mp-ea   ea-s-return   ea-s-return-msg
    Seller Returns - Enter Return Detail Page By Line Index
    Seller Message - Contact Buyer - Click Button Contact Buyer
    Seller Message - Contact Buyer - Input Send Message    ${None}
    Seller Message - Contact Buyer - Click Button Send    ${None}
    ${now_time}    Get Time
    ${input_msg}    Set Variable    Send Return Msg at ${now_time}
    Seller Message - Contact Buyer - Input Send Message    ${input_msg}
    Seller Message - Contact Buyer - Add Attach File
    Seller Message - Contact Buyer - Click Button Send    ${input_msg}