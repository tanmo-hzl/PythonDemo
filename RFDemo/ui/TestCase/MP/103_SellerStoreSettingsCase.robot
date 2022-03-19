*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerStoreSettingsKeywords.robot
Resource            ../../Keywords/MAP/MarketplaceStoreManagementKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Teardown       Run Keyword If    '${TEST STATUS}'=='FAIL'    Reload Page

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/store-profile
${Random_Data}
${Old_Store_Name}

*** Test Cases ***
Test Check Store Settings - Store Profile Page Fixed Element text
    [Documentation]   Check Store Profile page fixed element text
    [Tags]  mp    mp-ea    ea-store-setting    ea-store-setting-ele
    Store Left Meun - Store Settings - Store Profile
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerStoreSettings.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    storeProfile

Test Check Store Settings - Customer Service Page Fixed Element text
    [Documentation]   Check Customer Service page fixed element text
    [Tags]  mp    mp-ea    ea-store-setting    ea-store-setting-ele
    Store Left Meun - Store Settings - Customer Service
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerStoreSettings.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    customerService

Test Check Store Settings - Fulfillment Info Page Fixed Element text
    [Documentation]   Check Fulfillment Info page fixed element text
    [Tags]  mp    mp-ea    ea-store-setting    ea-store-setting-ele
    Store Left Meun - Store Settings - Fulfillment Info
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerStoreSettings.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    fulfillmentInfo

Test Check Store Settings - Return Policy Page Fixed Element text
    [Documentation]   Check Return Policy page fixed element text
    [Tags]  mp    mp-ea    ea-store-setting    ea-store-setting-ele
    Store Left Meun - Store Settings - Return Policy
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerStoreSettings.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}    returnPolicy

Test Update Store Photos
    [Documentation]    Seller update store address and Description
    [Tags]   mp    mp-ea    ea-store-setting
    Store Left Meun - Store Settings - Store Profile
    Store Profile - Show Photo Documentation
    Store Profile - Change Store Photo

Test Update Store Address And Description
    [Documentation]    Seller update store address and Description
    [Tags]   mp    mp-ea    ea-store-setting
    ${address}    Get Address Info
    Store Left Meun - Store Settings - Store Profile
    Store Profile - Update Store Address    ${address}
    Store Profile - Update Store Description
    Store Profile - Show Store Preview Info
    Sotre Settings - Click Button-Save
    Check Store Address And Description Is Saved    ${address}

Test Update Customer Service Primary Contact Information
    [Documentation]    Seller update Customer Service Primary Contact Information
    [Tags]   mp    mp-ea    ea-store-setting
    Store Left Meun - Store Settings - Customer Service
    Customer Service - Update Primary Contact Info - Email And Phone    ${SELLER_EMAIL}
    Customer Service - Delete Another Select Days
    Customer Service - Unselect All Select Days    0
    Customer Service - Update Primary Contact Info - Select Days    0    ${False}
    ${contact}     Get Primary Contact
    ${start1}   Set Variable    ${contact}[start1]
    ${end1}   Set Variable    ${contact}[end1]
    Customer Service - Select Time Range By Index And Name    0    start    ${start1[0]}    ${start1[1]}    ${start1[2]}
    Customer Service - Select Time Range By Index And Name    0    end    ${end1[0]}    ${end1[1]}    ${end1[2]}
    Customer Service - Add Another Select Days
    Customer Service - Unselect All Select Days    1
    Customer Service - Update Primary Contact Info - Select Days    1    ${True}
    ${start2}   Set Variable    ${contact}[start2]
    ${end2}   Set Variable    ${contact}[end2]
    Customer Service - Select Time Range By Index And Name    1    start    ${start2[0]}    ${start2[1]}    ${start2[2]}
    Customer Service - Select Time Range By Index And Name    1    end    ${end2[0]}    ${end2[1]}    ${end2[2]}
    Customer Service - Update Primary Contact Info - TimeZone
    Sotre Settings - Click Button SAVE

Test Update Customer Service Michael Contact Info
    [Documentation]    Seller update Customer Service Michael Contact Info
    [Tags]   mp    mp-ea    ea-store-setting
    Store Left Meun - Store Settings - Customer Service
    Customer Service - Remove Another Michael Contact
    Customer Service - Update Michael Contact Info - Unselect All Department    0
    Customer Service - Update Michael Contact Info - Department    0
    Customer Service - Update Michael Contact Info - Email And Phone    0
    Customer Service - Update Michael Contact Info - Add Another Contact
    Customer Service - Update Michael Contact Info - Unselect All Department    1
    Customer Service - Update Michael Contact Info - Department    1
    Customer Service - Update Michael Contact Info - Email And Phone    1
    Customer Service - Update Privacy Policy
    Sotre Settings - Click Button SAVE

Test Update Seller Fulfillment Info
    [Documentation]    Seller Update Fulfillment Address
    [Tags]   mp    mp-ea    ea-store-setting1
    Store Left Meun - Store Settings - Fulfillment Info
    ${ful_info}     Get Fulfillment Info
    Fulfillment Info - Rename Fulfillment    ${ful_info}[name]
    Fulfillment Info - Update Address - Address    0    ${ful_info}[address1]    ${ful_info}[address2]
    Fulfillment Info - Update Fulfillment Address    0    ${ful_info}[state]    ${ful_info}[city]    ${ful_info}[zipcode]
    Fulfillment Info - Delete Another Select Days    0
    Fulfillment Info - Unselect All Select Days    0    0
    Fulfillment Info - Update Fulfillment Center Hours - Select Days    0    0    ${False}
    ${start1}   Set Variable    ${ful_info}[start1]
    ${end1}   Set Variable    ${ful_info}[end1]
    Fulfillment Info - Select Time Range By Index And Name    0    0    start    ${start1[0]}   ${start1[1]}   ${start1[2]}
    Fulfillment Info - Select Time Range By Index And Name    0    0    end    ${end1[0]}    ${end1[1]}    ${end1[2]}
    Fulfillment Info - Add Another Select Days    0
    Fulfillment Info - Unselect All Select Days    0    1
    Fulfillment Info - Update Fulfillment Center Hours - Select Days    0    1    ${True}
    ${start2}   Set Variable    ${ful_info}[start2]
    ${end2}   Set Variable    ${ful_info}[end2]
    Fulfillment Info - Select Time Range By Index And Name    0    1    start    ${start2[0]}   ${start2[1]}   ${start2[2]}
    Fulfillment Info - Select Time Range By Index And Name    0    1    end    ${end2[0]}    ${end2[1]}    ${end2[2]}
    Fulfillment Info - Update Fulfillment Center Hours - TimeZone    0
    Fulfillment Info - Update Observed Holidays - Delete Another Select Holidays    0
    ${holiday1}   Set Variable    ${ful_info}[holiday1]
    Fulfillment Info - Update Observed Holidays - Observed Holidays    0    0    ${holiday1}
    Sotre Settings - Click Button SAVE


Test Update Shipping Rate Table
    [Documentation]    Update store shipping reate
    [Tags]   mp    mp-ea    ea-store-setting
    Store Left Meun - Store Settings - Fulfillment Info
    Fulfillment Info - Update Shipping Rate Table - Delete Threshold
    Fulfillment Info - Offer Expedited Shipping To Customers - Close
    Fulfillment Info - Offer Expedited Shipping To Customers - Open
    Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Open
    Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Close
    ${shipping_rate}    Get Shipping Rate Info
    ${standard}   Set Variable    ${shipping_rate}[Standard]
    ${expedited}   Set Variable    ${shipping_rate}[Expedited]
#    {'Standard': ['3.30', '30.28', '4.99', '47.66', '1.79'], 'Expedited': ['6.93', '8.94', '0.19']}
    Fulfillment Info - Update Shipping Rate Table - Add Threshold    1    1    ${standard[0]}    ${standard[1]}    ${standard[2]}    ${expedited[0]}
    Sotre Settings - Click Button SAVE
    Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Close
    Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Open
    Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Add Threshold    1    ${standard[0]}   ${expedited[0]}
    Sotre Settings - Click Button SAVE
    Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Close
    Sotre Settings - Click Button SAVE

Test Add Another Fulfillment Center
    [Documentation]    Add another fulfillment center to store
    [Tags]   mp    mp-ea    ea-store-setting   debug
    Store Left Meun - Store Settings - Fulfillment Info
    Fulfillment Info - Add another Fulfillment Center - Delete
    Fulfillment Info - Add another Fulfillment Center
    ${ful_info}     Get Fulfillment Info
    Fulfillment Info - Update Address - Address    1    ${ful_info}[address1]    ${ful_info}[address2]
    Fulfillment Info - Update Fulfillment Address    1    ${ful_info}[state]    ${ful_info}[city]    ${ful_info}[zipcode]
    Fulfillment Info - Delete Another Select Days    1
    Fulfillment Info - Unselect All Select Days    1    0
    Fulfillment Info - Update Fulfillment Center Hours - Select Days    1    0    ${False}
    ${start1}   Set Variable    ${ful_info}[start1]
    ${end1}   Set Variable    ${ful_info}[end1]
    Fulfillment Info - Select Time Range By Index And Name    1    0    start    ${start1[0]}   ${start1[1]}   ${start1[2]}
    Fulfillment Info - Select Time Range By Index And Name    1    0    end    ${end1[0]}    ${end1[1]}    ${end1[2]}
    Fulfillment Info - Add Another Select Days    1
    Fulfillment Info - Unselect All Select Days    1    1
    Fulfillment Info - Update Fulfillment Center Hours - Select Days    1    1    ${True}
    ${start2}   Set Variable    ${ful_info}[start2]
    ${end2}   Set Variable    ${ful_info}[end2]
    Fulfillment Info - Select Time Range By Index And Name    1    1    start    ${start2[0]}   ${start2[1]}   ${start2[2]}
    Fulfillment Info - Select Time Range By Index And Name    1    1    end    ${end2[0]}    ${end2[1]}    ${end2[2]}
    Fulfillment Info - Update Fulfillment Center Hours - TimeZone    1
    Fulfillment Info - Update Observed Holidays - Delete Another Select Holidays    1
    ${holiday1}   Set Variable    ${ful_info}[holiday1]
    Fulfillment Info - Update Observed Holidays - Observed Holidays    1    0    ${holiday1}
    Sotre Settings - Click Button SAVE
    Fulfillment Info - Add another Fulfillment Center - Delete

Test Return Policy
    [Documentation]    Set return policy to store
    [Tags]   mp    mp-ea    ea-store-setting
    Store Left Meun - Store Settings - Return Policy
    Return Policy - Update Return Center Location By Index    1
    Return Policy - Update Return Policy    60 Days Return
    Return Policy - Return Shipping Service - Close
    Return Policy - Return Shipping Service - Open
    Return Policy - Input UPS User Info    ${UPC_ID}    ${UPC_PWD}    ${UPC_KEY}
    Return Policy - Select Agree To Add Accept The Trems
    Return Policy - Unselect Agree To Add Accept The Trems
    Return Policy - Click Button - Link My UPS Account
    Sotre Settings - Click Button SAVE
