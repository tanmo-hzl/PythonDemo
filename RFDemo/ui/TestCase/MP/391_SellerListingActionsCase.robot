*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerListingKeywords.robot
Resource            ../../TestData/MP/ListingData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_LST_EMAIL}    ${SELLER_PWD}    ${SELLER_LST_NAME}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Listing Management
Test Teardown       Go To Expect Url Page    ${TEST_STATUS}    ${User_Type}    ${Page_Name}

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/listing-management
${Par_Case_Status}
${Random_Data}
${User_Type}    seller
${Page_Name}    lst

*** Test Cases ***
Test Delete One Listing Which Status Draft
    [Documentation]    [MKP-5240],Delete listing which status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Set Multiple Listings Selected By Status    Draft    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover One Listing Which Status Is Draft To Archived
    [Documentation]    [MKP-5244],Recover listing which status is Archived which parent status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    1
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Deactivate One Listing Which Status Is Active
    [Documentation]    [MKP-5239],Deactivate listing which status is Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Active
    Listing - Set Multiple Listings Selected By Status    Active    1
    Listing - Deactivate Listing After Seleted Active Item
    Listing - Check Listing Status By Title    Inactive

Test Delete One Listing Which Status Is Active To Inactive
    [Documentation]    [MKP-5243],Delete listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover One Listing Which Status Is Inactive To Archived
    [Documentation]    [MKP-5244],Recover listing which status is Archived and parent status is Inactive, Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    1
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft
#[MKP-5242], +N days
Test Relist One Listing Which Status Is Archived To Inactive
    [Documentation]    [MKP-5241],Relist listing which status is Inactive and the parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete One Listing Which Status Is Expired
    [Documentation]    Delete one listing which status is expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover One Listing Which Status Is Expired To Archived
    [Documentation]    [MKP-5244],Recover one listing which status is Archived and parent status is Expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    1
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist One Listing Which Status Is Archived To Expired
    [Documentation]    Relist two listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete Three Listing Which Status Is Draft
    [Documentation]    [MKP-5240],Delete three listing which status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Set Multiple Listings Selected By Status    Draft    3
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Draft To Archived
    [Documentation]    [MKP-5244],Recover two listing which status is Archived and parent status is Draft
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Deactivate Three Listing Which Status Is Active
    [Documentation]    [MKP-5239],Deactivate three listing which status is Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Active
    Listing - Set Multiple Listings Selected By Status    Active    3
    Listing - Deactivate Listing After Seleted Active Item   3
    Listing - Check Listing Status By Title    Inactive

Test Delete Three Listing Which Status Is Active To Inactive
    [Documentation]    Delete two listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    3
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Inactive To Archived
    [Documentation]    [MKP-5244],Recover two listing which status is Archived and parent status is Inactive, Active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist Two Listing Which Status Is Archived To Inactive
    [Documentation]    Relist two listing which status is Inactive and parent status is active
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Inactive
    Listing - Set Multiple Listings Selected By Status    Inactive    2
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete Two Listing Which Status Is Expired
    [Documentation]    Delete one listing which status is expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    2
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Expired To Archived
    [Documentation]    [MKP-5244],Recover one listing which status is Archived and parent status is Expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist Two Listing Which Status Is Archived To Expired
    [Documentation]    Relist two listing which status is Inactive and parent status is Expired,Archived
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Search Listing By Status Single    Expired
    Listing - Set Multiple Listings Selected By Status    Expired    2
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

Test Delete Two Listing Which Status Is Expired And Inactive
    [Documentation]    Delete one listing which status is expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Clear All Filter
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Delete Lisitng After Selected Item
    Listing - Check Listing Status By Title    Archived

Test Recover Two Listing Which Status Is Expired And Inactive To Archived
    [Documentation]    [MKP-5244],Recover one listing which status is Archived and parent status is Expired
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Clear All Filter
    Listing - Filter - Search Listing By Status Single    Archived
    Listing - Set Multiple Listings Selected By Status    Archived    2
    Listing - Recover Listing After Selected Archived Item
    Listing - Check Listing Status By Title    Inactive    Expired    Draft

Test Relist Two Listing Which Status Is Expired And Inactive
    [Documentation]    Relist two listing which status is Inactive and parent status is Expired,Archived
    [Tags]    mp    mp-ea    ea-lst   ea-lst-actions
    Listing - Filter - Clear All Filter
    Listing - Set Multiple Listings Selected By Status    Expired    1
    Listing - Set Multiple Listings Selected By Status    Inactive    1
    Listing - Relist Listing After Selected Inactive Item
    Listing - Check Listing Status By Title    Active

#    [MKP-5245], map Prohibited delete