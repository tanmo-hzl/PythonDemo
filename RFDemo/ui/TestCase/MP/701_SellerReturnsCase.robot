*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerReturnsKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
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
    [Documentation]    Enter return detail page and check fixed element
    [Tags]    mp    mp-ea    ea-s-return        ea-s-return-ele
    Seller Returns - Enter Return Detail Page By Line Index
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerReturnDetail.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}

Test Seller Search Order By Return ID
    [Documentation]    Search return order by  Return ID
    [Tags]    mp    mp-ea    ea-s-return
    Seller Returns - Filter - Clear All Filter
    Seller Returns - Get Return Order Info By Line Index
    Seller Returns - Search Order By Return ID    ${Return_ID}
    Seller Returns - Clear Search Value

Test Seller Approve Return Order For All Items
    [Documentation]    Seller enter Returns page and Approve for Pending Return order
    [Tags]    mp    mp-ea    ea-s-return   ea-s-return-approve    mp-rsc
    Seller Returns - Flow - Approve Or Reject For All Items    ${True}

Test Seller Reject Return Order For All Items
    [Documentation]    Seller enter Returns page and Reject for Pending Return order
    [Tags]    mp    ea-s-return   ea-s-return-rejected    mp-rsc
    Seller Returns - Flow - Approve Or Reject For All Items    ${False}

Test Seller Reject Return Order For All Items - Do Many Times
    [Documentation]    Seller enter Returns page and Reject for Pending Return order, do many times
    [Tags]    mp    mp-ea    ea-s-return   ea-s-return-rejected    mp-rsc
    [Template]    Seller Returns - Flow - Reject Refund For All Items
    1
    2
    3

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
    Past 7 days
    Past 30 days
    Past 6 Month

Test Enter Order Detail Page And Back
    [Documentation]  Seller enter order detail page on return page then back to return page
    [Tags]    mp    mp-ea    ea-s-return
    Seller Returns - Enter Order Detail Page By Line Index
    Seller Returns - Back To Return List On Order Detail Page

Test Contact Buyer On Return Detail Page
    [Documentation]    Contact buyer on return detail page
    [Tags]    mp    mp-ea   ea-s-return   ea-s-return-msg
    Seller Returns - Enter Return Detail Page By Line Index
    Seller Message - Contact Buyer - Click Button Contact Buyer
    Seller Message - Contact Buyer - Input Send Message    ${False}
    Seller Message - Contact Buyer - Click Button Send
    Seller Message - Contact Buyer - Input Send Message
    Seller Message - Contact Buyer - Add Attach File
    Seller Message - Contact Buyer - Click Button Send