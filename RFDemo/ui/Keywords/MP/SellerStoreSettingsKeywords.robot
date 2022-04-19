*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SellerStoreSettingLib.py
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Random_Code}
${SELLER_EMAIL}
${New_Group_Name}
${Cur_Group_Name}

*** Keywords ***
Store Profile - Update Store Name
    [Arguments]    ${store_name}    ${sure}=${True}
    ${count}    Get Element Count    //p[text()="Edit Store Name"]/../parent::button
    Skip If    '${count}'=='0'
    Click Element    //p[text()="Edit Store Name"]/../parent::button
    Wait Until Element Is Visible    //p[text()="Create a new store name"]
    ${Old_Store_Name}    Get Text    //*[@id="storeName"]
    Set Suite Variable    ${Old_Store_Name}    ${Old_Store_Name}
    Input Text    //*[@id="changeStoreName"]//input[@id="storeName"]    ${store_name}
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="Confirm"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Create a new store name"]
    Wait Until Element Is Visible    //p[text()="Your new store name was submitted!"]
    Wait Until Element Is Not Visible    //p[text()="Your new store name was submitted!"]

Store Profile - Update Store Address
    [Arguments]    ${address}
    Clear Element Value    //*[@id="city"]
    Clear Element Value    //*[@id="zipCode"]
    Select From List By Value    //*[@id="state"]    ${address}[state]
    Input Text    //*[@id="zipCode"]    ${address}[zipcode]
    Input Text    //*[@id="city"]   ${address}[city]
    Wait Until Element Is Not Visible    //p[contains(text(),"We cannot validate your entered address, did you mean")]

Store Profile - Update Store Description
    Scroll Last Button Into View
    Clear Element Value    //*[@id="description"]
    ${time}   Get Time
    Input Text    //*[@id="description"]    Store Discription, ${time}.

Store Profile - Show Store Preview Info
    Scroll Element Into View    //div[text()="Preview"]/parent::button
    Click Element    //div[text()="Preview"]/parent::button
    Wait Until Element Is Visible    //header[contains(text(),"Preview")]
    Click Element    //button[@aria-label="Close"]
    Wait Until Element Is Not Visible    //header[contains(text(),"Preview")]

Store Profile - Show Photo Documentation
    ${types}    Create List    Logo     Banner (optional)
    ${item}    Set Variable
    FOR    ${item}    IN    @{types}
        Click Element    //h2[text()="${item}"]/following-sibling::p//p[text()="Click here"]
        Wait Until Element Is Visible    //p[text()="GOT IT"]
        IF    "${item}"=="Logo"
            Page Should Contain Element    //header/p[text()="Michaels Logo Image Standards"]
            Page Should Contain Element    //p[text()="This is how your logo might appear on your storefront."]
        ELSE
            Page Should Contain Element    //header/p[text()="Michaels Banner Image Standards"]
            Page Should Contain Element    //p[text()="This is how your banner might appear on your storefront."]
            Page Should Contain Element    //p[text()="1360 px X 400 px"]
        END
        Click Element    //p[text()="GOT IT"]
        Wait Until Element Is Not Visible    //p[text()="GOT IT"]
    END

Store Profile - Change Store Photo
    ${photo_path}    Get Random Img Path
    ${types}    Create List    Logo     Banner (optional)
    ${item}    Set Variable
    FOR    ${item}    IN    @{types}
        Choose File    //h2[text()="${item}"]/following-sibling::button[1]//input    ${photo_path}
        Wait Until Element Is Visible    //header[text()="Banner photo edit"]
        Click Element    //div[text()="Apply"]/parent::button
        Wait Until Element Is Not Visible    //header[text()="Banner photo edit"]
        Sleep    1
    END

Sotre Settings - Click Button-Save
    Scroll Element Into View    //div[text()="Save"]/parent::button
    Click Element    //div[text()="Save"]/parent::button
    Wait Until Element Is Visible    //p[contains(text(),"Success")]
    Wait Until Element Is Not Visible    //p[contains(text(),"Success")]

Sotre Settings - Click Button SAVE
    Scroll Element Into View    //div[text()="SAVE"]/parent::button
    Click Element    //div[text()="SAVE"]/parent::button
    Wait Until Element Is Visible    //p[contains(text(),"Success")]
    Wait Until Element Is Not Visible    //p[contains(text(),"Success")]

Check Store Address And Description Is Saved
    [Arguments]    ${address}
    Reload Page
    Wait Until Element Is Visible    //*[@name="city" and @value="${address}[city]"]
#    Page Should Contain Element    //*[@name="city" and @value="${address}[city]"]
    Page Should Contain Element    //*[@name="zipCode" and @value="${address}[zipcode]"]
    ${state}   Get Value    //*[@id="state"]
    Should Be Equal As Strings    ${state}   ${address}[state]

Customer Service - Update Primary Contact Info - Email And Phone
    [Arguments]     ${email}
    Scroll Element Into View    //input[@id="phones[0].email"]
    CLear Element Value    //input[@id="phones[0].email"]
    Input Text    //input[@id="phones[0].email"]    ${email}
    ${phone}    Evaluate    str(666)+str(random.randint(200,999))+str(random.randint(1000,9999))
    Clear Element Value    //*[@id="phones[0].phone"]
    Input Text    //input[@id="phones[0].phone"]    ${phone}

Customer Service - Update Primary Contact Info - TimeZone
    ${index}    Evaluate    random.randint(1,6)
    Click Element    //*[@id="customer-service-timezones"]
    Sleep    1
    Click Element    (//*[@id="customer-service-timezones"]/option)[${index}]

Customer Service - Delete Another Select Days
    ${count}    Get Element Count   //*[contains(@class,"icon-tabler-circle-minu")]/../../parent::button
    ${count}    Evaluate    ${count}-1
    FOR    ${index}    IN RANGE    ${count}
        Click Element    //*[contains(@class,"icon-tabler-circle-minu")]/../../parent::button
        Sleep    1
    END

Customer Service - Add Another Select Days
    Click Element    //*[contains(@class,"icon-tabler-circle-plus")]/../../parent::button
    Sleep    1

Customer Service - Update Primary Contact Info - Select Days
    [Arguments]    ${days_index}=0    ${is_weekend}=${False}
#    Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
    Run Keyword If    '${is_weekend}'=='${False}'    Customer Service - Select Days Range    ${days_index}    1    6
    Run Keyword If    '${is_weekend}'=='${True}'    Customer Service - Select Days Range    ${days_index}    6    8
#    Click Element    //*[@id="phones[0].serviceHour[${days_index}].days"]//div[starts-with(text(),"Add (")]
    Click Element    //*[@id="phones[0].serviceHour[${days_index}].days"]

Customer Service - Select Days Range
    [Arguments]    ${days_index}    ${start_index}    ${end_index}
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${start_index}     ${end_index}
        Click Element    (//*[@id="phones[0].serviceHour[${days_index}].days"]//div/label)[${index}]
    END

Customer Service - Unselect All Select Days
    [Arguments]    ${days_index}=0
    Click Element    //*[@id="phones[0].serviceHour[${days_index}].days"]
    ${count_selected}    Get Element Count    (//*[@id="phones[0].serviceHour[${days_index}].days"]//div/label)//span[@data-checked]/p     #计算被选中的有几个
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${count_selected}
        Click Element    //*[@id="phones[0].serviceHour[${days_index}].days"]//div/label//span[@data-checked]/../..
        Sleep    0.05
    END

Customer Service - Select Time Range By Index And Name
    [Arguments]    ${time_index}=0    ${time_name}=start     ${housr}=08    ${minute}=00    ${range}=AM
    Click Element    //*[@id="phones[0].serviceHour[${time_index}].${time_name}"]/following-sibling::div//button[contains(@id,"popover-trigger")]
    ${time_element}    Set Variable    (//*[@id="phones[0].serviceHour[${time_index}].${time_name}"]/..//*[contains(@class,"icon-tabler-chevron-up")]/../following-sibling::p)
    ${up_element}    Set Variable    (//*[@id="phones[0].serviceHour[${time_index}].${time_name}"]/..//*[contains(@class,"icon-tabler-chevron-up")]/parent::button)
    ${down_element}    Set Variable    (//*[@id="phones[0].serviceHour[${time_index}].${time_name}"]/..//*[contains(@class,"icon-tabler-chevron-down")]/parent::button)
    Wait Until Element Is Visible    ${time_element}
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    12
        Log    ${time_element}\[1\]
        ${now_hour}    Get Text    ${time_element}\[1\]
        Exit For Loop If  '${now_hour}'=='${housr}'
        Run Keyword If   '${now_hour}'<'${housr}'   Click Element    ${up_element}\[1\]
        Run Keyword If   '${now_hour}'>'${housr}'   Click Element    ${down_element}\[1\]
        Sleep    0.05
    END
    FOR    ${index}    IN RANGE    60
        ${now_minute}    Get Text    ${time_element}\[2\]
        Exit For Loop If    '${now_minute}'=='${minute}'
        Run Keyword If   '${now_minute}'<'${minute}'   Click Element    ${up_element}\[2\]
        Run Keyword If   '${now_minute}'>'${minute}'   Click Element    ${down_element}\[2\]
        Sleep    0.05
    END
    ${now_range}    Get Text    ${time_element}\[3\]
    Run Keyword If   '${now_range}'<'${range}'   Click Element    ${up_element}\[3\]
    Run Keyword If   '${now_range}'>'${range}'   Click Element    ${down_element}\[3\]

Customer Service - Update Michael Contact Info - Department
    #Customer Care,Billing,Order Resolution,Technical Issues,Marketing
    [Arguments]    ${department_index}=0
    ${base_ele}    Set Variable    (//*[@id="secondaryContacts[${department_index}].department"]//div/label)
    ${ele_count}     Get Element Count    ${base_ele}
    ${radmon_index}    Evaluate    random.randint(1,${ele_count})
    Click Element    ${base_ele}\[${radmon_index}\]
    Sleep    1
    Click Element    //*[@id="secondaryContacts[${department_index}].department"]

Customer Service - Update Michael Contact Info - Unselect All Department
    [Arguments]    ${department_index}=0
    Scroll Element Into View    //h2[text()="Privacy Policy"]
    Click Element    //*[@id="secondaryContacts[${department_index}].department"]
    ${count}    Get Element Count    //*[@id="secondaryContacts[${department_index}].department"]//label/span[@data-checked]/p
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${count}
      Click Element    //*[@id="secondaryContacts[${department_index}].department"]//label/span[@data-checked]/../parent::label
      Sleep    0.1
    END

Customer Service - Update Michael Contact Info - Add Another Contact
    Click Element    //p[text()="Add another contact"]/../parent::button
    Sleep    1

Customer Service - Update Michael Contact Info - Email And Phone
    [Arguments]    ${department_index}=0
    Clear Element Value    //*[@id="secondaryContacts[${department_index}].email"]
    Clear Element Value    //*[@id="secondaryContacts[${department_index}].phone"]
    Input Text    //*[@id="secondaryContacts[${department_index}].email"]     ${SELLER_EMAIL}
    ${phone}    Evaluate    str(5554)+str(random.randint(10,99))+str(random.randint(1000,9999))
    Input Text    //*[@id="secondaryContacts[${department_index}].phone"]    ${phone}

Customer Service - Remove Another Michael Contact
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    10
        ${count}    Get Element Count    //*[contains(text(),"Delete")]/parent::button
        Run Keyword If    '${count}'>'0'    Click Element    //*[contains(text(),"Delete")]/parent::button
        Sleep    1
        Exit For Loop If    '${count}'=='0'
    END

Customer Service - Update Privacy Policy
    ${text}    Get Text    //textarea[@id="privacyNotice"]
    Log    Do Nothing

Return Policy - Update Return Center Location By Index
    [Arguments]    ${index}
    CLick Element    //*[@id="returnCenter"]
    Wait Until Element Is Visible    //*[@id="returnCenter"]/option
    Click Element    (//*[@id="returnCenter"]/option)[${index}]

Return Policy - Update Return Policy
    [Documentation]    No Returns(Not recommended),30 Day Returns,60 Day Returns
    ...      You can enter only part of the text
    [Arguments]    ${name}
    Click Element    //h3[contains(text(),"${name}")]/../parent::label

Return Policy - Set Return Shipping Service Open
    [Arguments]    ${open}=${True}
    ${element}    Set Variable    //p[text()="Return Shipping Service"]/following-sibling::div[1]//label/span[@data-checked]
    ${count}    Get Element Count    ${element}
    IF    '${count}'=='0' and '${open}'=='${True}'
        Click Element    //p[text()="Return Shipping Service"]/following-sibling::div[1]//label
        Element Should Be Visible    //*[@id="upsId"]
    ELSE IF    ${count}>0 and '${open}'=='${False}'
        Click Element    //p[text()="Return Shipping Service"]/following-sibling::div[1]//label
        Element Should Not Be Visible    //*[@id="upsId"]
    END

Return Policy - Input UPS User Info
    [Arguments]   ${name}    ${pwd}    ${accress_key}
    Scroll Element Into View    //*[contains(text(),"SAVE")]
    Clear Element Value    //*[@id="upsId"]
    Clear Element Value    //*[@id="upsMima"]
    Clear Element Value    //*[@id="upsAccessKey"]
    Clear Element Value    //*[@id="upsAccountNumber"]
    Input Text    //*[@id="upsId"]    ${name}
    Input Text    //*[@id="upsMima"]    ${pwd}
    Input Text    //*[@id="upsAccessKey"]    ${accress_key}
    ${number}    Get Random Code    6
    Input Text    //*[@id="upsAccountNumber"]    ${number}

Return Policy - Select Agree To Add Accept The Trems
    ${count}    Get Element Count    //p[starts-with(text(),"I agree to and accept the")]/../parent::label/span[@data-checked]
    Run Keyword If    '${count}'=='0'    Click Element    //p[starts-with(text(),"I agree to and accept the")]/../parent::label
    Sleep    1

Return Policy - Unselect Agree To Add Accept The Trems
    ${count}    Get Element Count    //p[starts-with(text(),"I agree to and accept the")]/../parent::label/span[@data-checked]
    Run Keyword If    '${count}'=='1'    Click Element    //p[starts-with(text(),"I agree to and accept the")]/../parent::label
    Sleep    1

Return Policy - Click Button - Link My UPS Account
    Scroll Element Into View    //div[text()="Link My UPS Account"]/parent::button
    Click Element    //div[text()="Link My UPS Account"]/parent::button
    Wait Until Element Is Visible    //p[contains(text(),"Success")]
    Wait Until Element Is Not Visible    //p[contains(text(),"Success")]

Product Groups - Click Button - Create Product Groups
    ${button}    Set Variable    //div[contains(text(),"PRODUCT GROUP") and starts-with(text(),"CREATE")]/parent::button
    Wait Until Element Is Visible    ${button}
    Click Element    ${button}
    Wait Until Element IS Visible    //*[@id="groupTitle"]
    Wait Until Page ContaIns Element    //div[text()="SAVE"]/parent::button

Product Groups - Input Group Name
    Wait Until Element Is Visible    //*[@id="groupTitle"]
    ${gorup_name}    Get uuid Split
    ${now_time}    Get Time
    ${now_time}    Evaluate    '${now_time}'\[2:10\]
    Clear Element Value    //*[@id="groupTitle"]
    Set Suite Variable    ${New_Group_Name}    ${now_time} ${gorup_name}
    Input Text    //*[@id="groupTitle"]    ${New_Group_Name}

Product Groups - Search Listing
    [Arguments]    ${search_value}
    Input Text    //*[@id="searchGroupItems"]    ${search_value}
    Click Element    //*[@id="searchGroupItems"]
#    Press Keys    None    ${RETURN_OR_ENTER}
    Wait Until Element Is Visible     //*[@id="searchGroupItems"]/following-sibling::div//button

Product Groups - Add Items To Group After Search
    Click Element    //*[@id="searchGroupItems"]/following-sibling::div//div[text()="Add"]/parent::button
    Sleep    0.5

Product Groups - Stop Search Listing
    ${element}    Set Variable    //*[@id="searchGroupItems"]/preceding-sibling::div/*[contains(@class,"icon-tabler-x")]
    ${count}    Get Element Count    ${element}
    Run Keyword If    '${count}'=='1'    Click Element    ${element}
    Sleep    1

Product Groups - Delete Added Listing If Existed
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    10
        ${element}    Set Variable    //form[@id="groupItem"]/div[3]//div[text()="Delete"]/parent::button
        ${count}    Get Element Count    ${element}
        Exit For Loop If    '${count}'=='0'
        Click Element    ${element}
        Sleep    1
    END

Product Groups - Click Button - Back
    Scroll Element Into View    //div[text()="BACK"]/parent::button
    Click Element    //div[text()="BACK"]/parent::button
    Wait Until Element Is Not Visible     //*[@id="groupTitle"]
    Wait Until Element Is Visible     //h2[text()="Product Groups"]

Product Groups - Click Button - Save
    Scroll Element Into View    //div[text()="SAVE"]/parent::button
    Click Element    //div[text()="SAVE"]/parent::button
    Wait Until Element Is Not Visible     //*[@id="groupTitle"]
    Wait Until Element Is Visible     //h2[text()="Product Groups"]
    Wait Until Element Is Visible     //p[text()="Visible in Storefront"]

Product Groups - Preview In Storefront And Back
    [Arguments]    ${group_name}
    Wait Until Element Is Visible    //div[text()="PREVIEW IN STOREFRONT"]/parent::button
    Click Element    //div[text()="PREVIEW IN STOREFRONT"]/parent::button
    Sleep    1
    ${main}    Get Window Handles
    Switch Window    ${main[1]}
    Wait Until Element Is Visible    //h1[text()="CONTACT INFO"]     30
    Wait Until Page Contains Element    //h2[text()="All Listings"]
    Scroll Element Into View    //h2[text()="All Listings"]
    Wait Until Element Is Visible    //p[text()="${group_name}"]
    Sleep    1
    Close Window
    Switch Window
    Wait Until Element Is Visible    //h2[text()="Product Groups"]

Product Groups - Click Button Name With Group Name
    [Documentation]   button list: [edit, copy, trash, chevron-down，chevron-up]
    [Arguments]    ${button}    ${name}
    Sleep    1
    Click Element   //p[text()="${name}"]/../../following-sibling::div//*[contains(@class,"icon-tabler-${button}")]

Product Groups - Get Group Name By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    (//p[text()="Product Group"])[${index}]/following-sibling::p
    ${Croup_Name}    Get Text    (//p[text()="Product Group"])[${index}]/following-sibling::p
    Set Suite Variable    ${Cur_Group_Name}    ${Croup_Name}

Product Groups - Edit Group By Group Name
    [Arguments]    ${name}
    Product Groups - Click Button Name With Group Name    edit    ${name}
    Wait Until Element Is Visible    //label[text()="Product Group Name"]
    Wait Until Page ContaIns Element    //div[text()="SAVE"]/parent::button

Product Groups - Copy Group By Group Name
    [Arguments]    ${name}
    Product Groups - Click Button Name With Group Name    copy    ${name}
    Wait Until Element Is Visible    //p[text()="${name} - copy"]

Product Groups - Delete Group By Group Name
    [Arguments]    ${name}    ${sure}=${True}
    Product Groups - Click Button Name With Group Name    trash    ${name}
    Product Groups - Delete Group Pop-Up    ${sure}
    Wait Until Element Is Not Visible    //p[text()="${name}"]

Product Groups - Delete Group Pop-Up
    [Arguments]    ${sure}=${True}
    Wait Until Element Is Visible    //header[text()="Delete this product group?"]
    Page Should Contain Element    //*[contains(text(),"We will delete this product group once you click")]
    Run Keyword If   '${sure}'=='${True}'    Click Element    //div[text()="Got It"]/parent::button
    Run Keyword If   '${sure}'=='${False}'    Click Element    //div[text()="Caccel"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Delete this product group?"]

Product Groups - Delete All Group
    ${count}    Get Element Count    //*[contains(@class,"icon-tabler-trash")]
    FOR    ${index}    IN RANGE    ${count}
        Click Element    //*[contains(@class,"icon-tabler-trash")]
        Product Groups - Delete Group Pop-Up    ${True}
    END
    Wait Until Page Contains     There are no product group available currently.


Product Groups - Show Group Item By Group Name
    [Arguments]    ${name}
    Product Groups - Click Button Name With Group Name    chevron-down    ${name}
    Wait Until Element Is Visible     //p[text()="Items in this Product Group"]
    #Capture Page Screenshot    filename=EMBED

Product Groups - Hide Group Item By Group Name
    [Arguments]    ${name}
    Product Groups - Click Button Name With Group Name    chevron-up    ${name}
    Wait Until Element Is Not Visible     //p[text()="Items in this Product Group"]

Product Groups - Get Total Group Quantity
    ${count}    Get Element Count    //p[text()="Visible in Storefront"]
    [Return]    ${count}

Product Groups - Set Group Visible In Storefront By Name
    [Arguments]    ${name}    ${visible}=${True}
    ${base_ele}    Set Variable    //p[text()="${name}"]/../../following-sibling::div//label
    ${isVisible}    Get Text    ${base_ele}//p
    Run Keyword If    '${isVisible}'=='No' and '${visible}'=='${True}'
    ...  Click Element    ${base_ele}
    Run Keyword If    '${isVisible}'=='Yes' and '${visible}'=='${False}'
    ...  Click Element    ${base_ele}
    Sleep    1
    IF    '${visible}'=='${True}'
        Wait Until Element Is Visible    ${base_ele}//p[text()="Yes"]
    ELSE
        Wait Until Element Is Visible    ${base_ele}//p[text()="No"]
    END

Fulfillment Info - Rename Fulfillment
    [Arguments]    ${fulfillmentname}
    Click element    //p[text()="Rename"]/parent::*
    wait until element is visible    //*[@id="fulfillmentCenters[0].fulfillmentName"]
    Clear Element Value  //*[@id="fulfillmentCenters[0].fulfillmentName"]
    Input text    //*[@id="fulfillmentCenters[0].fulfillmentName"]    ${fulfillmentname}

Fulfillment Info - Update Address - Address
    Scroll element into view    //p[contains(text(),"Table Set Up Information")]
    [Arguments]    ${ffcenters}=0    ${address1}=Hills    ${address2}=03road
#    click element    //*[@id="fulfillmentCenters[0].address1"]
    Clear element value  //*[@id="fulfillmentCenters[${ffcenters}].address1"]
    Input text    //*[@id="fulfillmentCenters[${ffcenters}].address1"]    ${address1}
    Click element    //*[@id="fulfillmentCenters[${ffcenters}].address2"]
    Clear element value    //*[@id="fulfillmentCenters[${ffcenters}].address2"]
    Input text    //*[@id="fulfillmentCenters[${ffcenters}].address2"]    ${address2}

Fulfillment Info - Update Fulfillment Address
    [Arguments]    ${ffcenters}=0    ${state}=CA    ${city}=Chino Hills    ${zipcode}=91709
    Clear element value    //*[@id="fulfillmentCenters[${ffcenters}].city"]
    Clear Element Value    //*[@id="fulfillmentCenters[${ffcenters}].zipCode"]
    Click Element   //*[@id="fulfillmentCenters[${ffcenters}].state"]
    Sleep    1
    Click Element    (//*[@id="fulfillmentCenters[${ffcenters}].state"]//option[@value="${state}"])
    Input text    //*[@id="fulfillmentCenters[${ffcenters}].city"]    ${city}
    Input Text    //*[@id="fulfillmentCenters[${ffcenters}].zipCode"]    ${zipcode}

Fulfillment Info - Update Fulfillment Center Hours - TimeZone
    [Arguments]    ${ffcenters}=0
    ${index}    Evaluate    random.randint(1,6)
    Click Element    //*[@name="fulfillmentCenters[${ffcenters}].timezone"]
    wait until element is visible    //*[@name="fulfillmentCenters[${ffcenters}].timezone"]
    Click Element    (//*[@name="fulfillmentCenters[${ffcenters}].timezone"]/option)[${index}]

Fulfillment Info - Delete Another Select Days
    [Arguments]    ${ffcenters}=0
    ${count}    Get Element Count    //*[@name="fulfillmentCenters[${ffcenters}].fulfillmentName"]//*[contains(@class,"icon-tabler-circle-minu")]          #//*[contains(@class,"icon-tabler-circle-minu")]/../../parent::button
    ${count}    Evaluate    ${count}-1
    FOR    ${index}    IN RANGE    ${count}
        Click Element    //*[@name="fulfillmentCenters[${ffcenters}].fulfillmentName"]//*[contains(@class,"icon-tabler-circle-minu")]     #//*[contains(@class,"icon-tabler-circle-minu")]/../../parent::button
        Sleep    1
    END

Fulfillment Info - Unselect All Select Days
    [Arguments]     ${ffcenters}=0    ${days_index}=0
    Click Element    //*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${days_index}].days"]
    ${count_selected}    Get Element Count    (//*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${days_index}].days"]//div/label)//span[@data-checked]/p
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${count_selected}
        Click Element    //*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${days_index}].days"]//div/label//span[@data-checked]/../..
        Sleep    0.1
    END

Fulfillment Info - Update Fulfillment Center Hours - Select Days
    [Arguments]    ${ffcenters}=0    ${days_index}=0    ${is_weekend}=${False}
#    Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
    Run Keyword If    '${is_weekend}'=='${False}'    Fulfillment Info - Select Days Range    ${days_index}    1    6    ${ffcenters}
    Run Keyword If    '${is_weekend}'=='${True}'    Fulfillment Info - Select Days Range    ${days_index}    6    8    ${ffcenters}
#    Click Element    //*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${days_index}].days"]//div[starts-with(text(),"Add (")]
    Click Element    //*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${days_index}].days"]

Fulfillment Info - Select Days Range
    [Arguments]     ${days_index}    ${start_index}    ${end_index}   ${ffcenters}=0
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${start_index}     ${end_index}
        Click Element    (//*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${days_index}].days"]//div/label)[${index}]
    END

Fulfillment Info - Select Time Range By Index And Name
    [Arguments]    ${ffcenters}=0    ${time_index}=0    ${time_name}=start     ${housr}=08    ${minute}=00    ${range}=AM
    Click Element    //*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${time_index}].${time_name}"]/following-sibling::div//button[contains(@id,"popover-trigger")]
    ${time_element}    Set Variable    (//*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${time_index}].${time_name}"]/..//*[contains(@class,"icon-tabler-chevron-up")]/../following-sibling::p)
    ${up_element}    Set Variable    (//*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${time_index}].${time_name}"]/..//*[contains(@class,"icon-tabler-chevron-up")]/parent::button)
    ${down_element}    Set Variable    (//*[@id="fulfillmentCenters[${ffcenters}].serviceHour[${time_index}].${time_name}"]/..//*[contains(@class,"icon-tabler-chevron-down")]/parent::button)
    Wait Until Element Is Visible    ${time_element}
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    12
        Log    ${time_element}\[1\]
        ${now_hour}    Get Text    ${time_element}\[1\]
        Exit For Loop If  '${now_hour}'=='${housr}'
        Run Keyword If   '${now_hour}'<'${housr}'   Click Element    ${up_element}\[1\]
        Run Keyword If   '${now_hour}'>'${housr}'   Click Element    ${down_element}\[1\]
        Sleep    0.05
    END
    FOR    ${index}    IN RANGE    60
        ${now_minute}    Get Text    ${time_element}\[2\]
        Exit For Loop If    '${now_minute}'=='${minute}'
        Run Keyword If   '${now_minute}'<'${minute}'   Click Element    ${up_element}\[2\]
        Run Keyword If   '${now_minute}'>'${minute}'   Click Element    ${down_element}\[2\]
        Sleep    0.01
    END
    ${now_range}    Get Text    ${time_element}\[3\]
    Run Keyword If   '${now_range}'<'${range}'   Click Element    ${up_element}\[3\]
    Run Keyword If   '${now_range}'>'${range}'   Click Element    ${down_element}\[3\]

Fulfillment Info - Add Another Select Days
    [Arguments]    ${ffcenters}=0
    Click Element    //*[@name="fulfillmentCenters[${ffcenters}].fulfillmentName"]//*[contains(@class,"icon-tabler-circle-plus")]    #//*[contains(@class,"icon-tabler-circle-plus")]/../../parent::button
    Sleep    1

Fulfillment Info - Update Observed Holidays - Unselect Observed Holidays
    Scroll element into view    //p[contains(text(),"Table Set Up Information")]
    [Arguments]    ${holidays_index}=0
    Click Element    //div[@id="fulfillmentHolidays${holidays_index}"]
        ${count_selected}    Get Element Count    (//div[@id="fulfillmentHolidays${holidays_index}"]//div/label)//span[@data-checked]/p[text()="Select All"]    #计算被选中的select all 有几个
    ${element}    set variable    (//div[@id="fulfillmentHolidays${holidays_index}"]//div/label)//span/p[text()="Select All"]/../parent::label
    run keyword if    "${count_selected}"=="1"  Click Element    ${element}
    run keyword if    "${count_selected}"=="0"  Click Element    ${element}
    run keyword if    "${count_selected}"=="0"  Click Element    ${element}

Fulfillment Info - Update Observed Holidays - Observed Holidays
    #Customer Care,Billing,Order Resolution,Technical Issues,Marketing
    [Arguments]    ${fulfil_index}=0    ${holidays_index}=0    ${holiday}=${None}
    ${base_ele}    Set Variable     //*[@id="fulfillmentCenters[${fulfil_index}].anthorHolidays[${holidays_index}].holidayName"]
    Click Element     ${base_ele}
    Wait Until Element Is Visible    ${base_ele}//p\[text()="New Years Day"\]/..
    Sleep    0.5
    ${name}   Set Variable    ${holiday}[name]
    Scroll Element Into View    ${base_ele}//p\[text()="${name}"\]/..
    Click Element    ${base_ele}//p\[text()="${name}"\]/..
    Sleep    1
    Common - Select Date By Element    ${holiday}[startDate]    //input[@id="fulfillmentCenters[${fulfil_index}].anthorHolidays[${holidays_index}].from"]
    Common - Select Date By Element    ${holiday}[endDate]    //input[@id="fulfillmentCenters[${fulfil_index}].anthorHolidays[${holidays_index}].to"]

Fulfillment Info - Update Observed Holidays - Delete Another Select Holidays
    [Arguments]    ${ffcenters}=0
    ${count}    Get Element Count    //*[@name="fulfillmentCenters[${ffcenters}].fulfillmentName"]//div[starts-with(@id,"fulfillment") and contains(@id,"holidayName")]/following-sibling::div//button[2]
    ${count}    Evaluate    ${count}-1
    FOR    ${index}    IN RANGE    ${count}
        Click Element    //*[@name="fulfillmentCenters[${ffcenters}].fulfillmentName"]//div[starts-with(@id,"fulfillment") and contains(@id,"holidayName")]/following-sibling::div//button[2]
        Sleep    1
    END

Fulfillment Info - Update Observed Holidays - Add Additional Holidays
    [Arguments]    ${index}=0    ${holidays_name}=ege    ${anotherholiday}=0    ${start_day_add}=0
    Click Element    //input[@name="fulfillmentCenters[${index}].anthorHolidays[${anotherholiday}].holidayName"]
    Clear Element Value    //input[@name="fulfillmentCenters[${index}].anthorHolidays[${anotherholiday}].holidayName"]
    Input Text    //input[@name="fulfillmentCenters[${index}].anthorHolidays[${anotherholiday}].holidayName"]     ${holidays_name}
    ${fromDate}    Get Current Date     result_format=%Y-%m-%d
    ${abFrom}    Add Time To Date     ${fromDate}    ${start_day_add} days    result_format=%Y-%m-%d
    ${abTo}    Add Time To Date     ${abFrom}    1 days    result_format=%Y-%m-%d
    ${data_index}    Evaluate    ${anotherholiday}+1
    Common - Select Date By Element    ${abFrom}    (//label[contains(text(),"Start Date")])[${data_index}]/following-sibling::div//input
    Common - Select Date By Element    ${abTo}    (//label[contains(text(),"End Date")])[${data_index}]/following-sibling::div//input

#    ${abFroms}    Evaluate    str('${abFrom}').split("-")
#    ${abTos}    Evaluate    str('${abTo}').split("-")
#    Click Element    //input[@name="fulfillmentCenters[${index}].anthorHolidays[${anotherholiday}].from"]
#    Press Keys    None   LEFT+LEFT+${abFroms[1]}+${abFroms[2]}+${abFroms[0]}
#    Click Element    //input[@name="fulfillmentCenters[${index}].anthorHolidays[${anotherholiday}].to"]
#    Press Keys    None   LEFT+LEFT+${abTos[1]}+${abTos[2]}+${abTos[0]}

Fulfillment Info - Observed Holidays - Open
    ${element}    Set Variable    //*[@name="fulfillmentCenters[1].fulfillmentName"]//*[contains(@class,"chakra-switch__track")]
    ${count}    Get Element Count    ${element}
    Run Keyword If    '${count}'=='0'    Click Element    //*[@name="fulfillmentCenters[1].fulfillmentName"]//*[contains(@class,"chakra-switch__track")]
    Sleep    1

Fulfillment Info - Update Observed Holidays - Add another Holiday
    Click Element    //*[@role="dialog"]//*[contains(@class,"icon-tabler-circle-plus")]/../../parent::button
    Sleep    1

Fulfillment Info - Set address as return center location
    [Arguments]    ${ffcenter}=0
    ${count}    Get Element Count    //div[@name="fulfillmentCenters[${ffcenter}].fulfillmentName"]//span[contains(@class,"chakra-switch__track")]/span[@data-checked]
    Run Keyword If    '${count}'=='0'    Click Element    //div[@name="fulfillmentCenters[${ffcenter}].fulfillmentName"]//span[contains(@class,"chakra-switch__track")]

Fulfillment Info - Update Observed Holidays - Click Button Save
    Click Element    //*[@role="dialog"]//div[text()="SAVE"]/parent::button
    Wait Until Element Is Not Visible     //*[@role="dialog"]//div[text()="SAVE"]/parent::button

Fulfillment Info - Add another Fulfillment Center
    Click Element    //*[contains(text(),"Add another Fulfillment Center")]

Fulfillment Info - Add another Fulfillment Center - Delete
    ${count}    Get Element Count    //p[text()="Delete"]/parent::div
    FOR    ${index}    IN RANGE    ${count}
        Click Element    (//p[text()="Delete"]/parent::div)[${count}]
        Sleep    1
    END

Fulfillment Info - Update Shipping Rate Table - Delete Threshold
    Scroll Element Into View  //*[contains(text(),"SAVE")]
    Click Element    //p[text()="Standard"]/../../../parent::div/following-sibling::div//*[contains(@class,"icon-tabler-circle-minus")]
#    [Arguments]    ${ffcenters}=0
    ${count}    Get Element Count    //p[text()="Standard"]/../../../parent::div/following-sibling::div//*[contains(@class,"icon-tabler-circle-minus")]          #//*[contains(@class,"icon-tabler-circle-minu")]/../../parent::button
    ${count}    Evaluate    ${count}-1
    FOR    ${index}    IN RANGE    ${count}
        Click Element    //p[text()="Standard"]/../../../parent::div/following-sibling::div//*[contains(@class,"icon-tabler-circle-minus")]     #//*[contains(@class,"icon-tabler-circle-minu")]/../../parent::button
        Sleep    1
    END

Fulfillment Info - Update Shipping Rate Table - Add Threshold
    [Arguments]    ${standerdindex}=0    ${expeditedindex}=0    ${shipmentcost}=9.96    ${expeditedshipcost}=8.69    ${shipmentValueMax}=11.55    ${shipmentcost}=9
    Click Element    //p[text()="Standard"]/../../../parent::div/following-sibling::div//*[contains(@class,"icon-tabler-circle-plus")]
    Input Text    //*[@id="standardShippingLines[0].shipmentCost"]    ${shipmentcost}
    Input Text    //*[@id="standardShippingLines[0].shipmentValueMax"]    ${shipmentValueMax}
    Input Text    //*[@id="standardShippingLines[${standerdindex}].shipmentCost"]    ${shipmentcost}
    Input Text    //*[@id="expeditedShippingLines[0].shipmentCost"]    ${shipmentcost}
    Input Text    //*[@id="expeditedShippingLines[${expeditedindex}].shipmentCost"]    ${expeditedshipcost}

Fulfillment Info - Offer Expedited Shipping To Customers Open
    [Arguments]    ${open}=${True}
    ${element}    Set Variable    //p[text()="Will you offer expedited shipping to customers?"]/following-sibling::div//label
    ${count}    Get Element Count    ${element}//span\[@data-checked\]
    IF    '${count}'=='0' and "${open}"=="${True}"
        Click Element     ${element}
        Wait Until Element Is Visible    ${element}//p\[text()="Yes"\]
    ELSE IF    ${count}>0 and "${open}"=="${False}"
        Click Element     ${element}
        Wait Until Element Is Visible    ${element}//p\[text()="No"\]
    END
    Sleep    1

Fulfillment Info - Offer Different Price Threshold For Expedited Shipping Open
    [Arguments]    ${open}=${True}
    ${element}    Set Variable    //p[text()="Will you offer different price threshold for expedited shipping?"]/../following-sibling::div/label
    ${count}    Get Element Count    ${element}/span\[@data-checked\]
    IF    ${count}==0 and "${open}"=="${True}"
        Click Element    ${element}
        Wait Until Element Is Visible    ${element}//p\[text()="Yes"\]
    ELSE IF    ${count}>0 and "${open}"=="${False}"
        Click Element    ${element}
        Wait Until Element Is Visible    ${element}//p\[text()="No"\]
    END
    Sleep    1

Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Delet Threshold
#    [Arguments]    ${ffcenters}=0
    ${count}    Get Element Count    ((//*[@class="css-aymtdu"])[1]//*[contains(@class,"icon-tabler-circle-minus")])[1]
    ${count}    Evaluate    ${count}-1
    FOR    ${index}    IN RANGE    ${count}
        Click Element    ((//*[@class="css-aymtdu"])[1]//*[contains(@class,"icon-tabler-circle-minus")])[1]
        Sleep    1
    END

Fulfillment Info - Offer Different Price Threshold For Expedited Shipping - Add Threshold
    [Arguments]    ${elines}=0    ${shipmentcost}=7.96    ${shipmentValueMax}=10.55
    Click Element    (//p[text()="Expedited"]/../../../parent::div/following-sibling::div//*[contains(@class,"icon-tabler-circle-plus")])[1]
    Input Text    //input[@id="expeditedShippingLines[0].shipmentCost"]    ${shipmentcost}
    Input Text    //input[@id="expeditedShippingLines[0].shipmentValueMax"]    ${shipmentValueMax}
    Input Text    //input[@id="expeditedShippingLines[${elines}].shipmentCost"]    ${elines}


