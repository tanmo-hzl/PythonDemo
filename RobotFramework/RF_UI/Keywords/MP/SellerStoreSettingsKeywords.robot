*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Random_Code}
${SELLER_EMAIL}
${New_Group_Name}

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

Store Profile - Update Store Address - City
    [Arguments]    ${city}=New York
    Clear Element Value    //*[@id="city"]
    Input Text    //*[@id="city"]   ${city}

Store Profile - Update Store Address - State
    [Arguments]    ${state}=NY
    Click Element    //*[@id="state"]
#    ${count}    Get Element Count    //*[@id="state"]//option
#    ${index}    Evaluate    random.randint(1,${count})
    Sleep    1
    Click Element    (//*[@id="state"]//option[@value="${state}"])

Store Profile - Update Strore Address - Zipcode
    [Arguments]    ${zipcode}=10012
    Clear Element Value    //*[@id="zipCode"]
    Input Text    //*[@id="zipCode"]    ${zipcode}

Store Profile - Update Store Description
    Clear Element Value    //*[@id="description"]
    Input Text    //*[@id="description"]    Store Discription, Nothing! ${Random_Code}

Store Profile - Show Store Preview Info
    Scroll Element Into View    //div[text()="PREVIEW"]/parent::button
    Click Element    //div[text()="PREVIEW"]/parent::button
    Wait Until Element Is Visible    //header[contains(text(),"Preview")]
    Click Element    //button[@aria-label="Close"]
    Wait Until Element Is Not Visible    //header[contains(text(),"Preview")]

Sotre Settings - Click Button Save
    Scroll Element Into View    //div[text()="SAVE"]/parent::button
    Click Element    //div[text()="SAVE"]/parent::button
    Wait Until Element Is Visible    //p[contains(text(),"Success")]
    Wait Until Element Is Not Visible    //p[contains(text(),"Success")]

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
    Click Element    //*[@id="phones[0].serviceHour[${days_index}].days"]//div[starts-with(text(),"Add (")]

Customer Service - Select Days Range
    [Arguments]    ${days_index}    ${start_index}    ${end_index}
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${start_index}     ${end_index}
        Click Element    (//*[@id="phones[0].serviceHour[${days_index}].days"]//div/label)[${index}]
    END

Customer Service - Unselect All Select Days
    [Arguments]    ${days_index}=0
    Click Element    //*[@id="phones[0].serviceHour[${days_index}].days"]
    ${count_selected}    Get Element Count    (//*[@id="phones[0].serviceHour[${days_index}].days"]//div/label)//span[@data-checked]/p
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
    ${radmon_index}    Evaluate    random.randint(1,6)
    Click Element    (//*[@id="secondaryContacts[${department_index}].department"]//label)[${radmon_index}]
    Sleep    1
    Click Element    //*[@id="secondaryContacts[${department_index}].department"]//div[starts-with(text(),"Add (")]

Customer Service - Update Michael Contact Info - Unselect All Department
    [Arguments]    ${department_index}=0
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
    [Documentation]    No Returns(Not recommended),30 Days Return(Default),60 Days Return
    ...      You can enter only part of the text
    [Arguments]    ${name}
    Click Element    //h4[contains(text(),"${name}")]/../parent::label

Return Policy - Return Shipping Service - Open
    ${element}    Set Variable    //p[text()="Return Shipping Service"]/following-sibling::div[1]//label/span[@data-checked]
    ${count}    Get Element Count    ${element}
    Run Keyword If    '${count}'=='0'    Clicke Element    //p[text()="Return Shipping Service"]/following-sibling::div[1]//label
    Sleep    1

Return Policy - Return Shipping Service - Close
    ${element}    Set Variable    //p[text()="Return Shipping Service"]/following-sibling::div[1]//label/span[@data-checked]
    ${count}    Get Element Count    ${element}
    Run Keyword If    '${count}'=='1'    Clicke Element    //p[text()="Return Shipping Service"]/following-sibling::div[1]//label
    Sleep    1

Return Policy - Input UPS User Info
    [Arguments]   ${name}    ${pwd}    ${accress_key}
    Clear Element Value    //*[@id="upsId"]
    Clear Element Value    //*[@id="upsPassword"]
    Clear Element Value    //*[@id="upsAccessKey"]
    Clear Element Value    //*[@id="upsAccountNumber"]
    Input Text    //*[@id="upsId"]    ${name}
    Input Text    //*[@id="upsPassword"]    ${pwd}
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
    Wait Until Element IS Visible    //h1[text()="New Group"]
    Wait Until Page ContaIns Element    //div[text()="SAVE"]/parent::button

Product Groups - Input Group Name
    ${gorup_name}    Get uuid Split
    Clear Element Value    //*[@id="groupTitle"]
    Set Suite Variable    ${New_Group_Name}    Group ${gorup_name}
    Input Text    //*[@id="groupTitle"]    ${New_Group_Name}

Product Groups - Search Listing
    [Arguments]    ${search_value}
    Input Text    //*[@id="searchGroupItems"]    ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
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
    Wait Until Element Is Visible     //p[text()="Visible on Storefront"]

Product Groups - Preview In Storefront And Back
    [Arguments]    ${group_name}
    Wait Until Element Is Visible    //div[text()="PREVIEW IN STOREFRONT"]/parent::button
    Click Element    //div[text()="PREVIEW IN STOREFRONT"]/parent::button
    Sleep    1
    ${main}    Get Window Handles
    Switch Window    ${main[1]}
    Wait Until Element Is Visible    //h1[text()="CONTACT INFO"]
    Wait Until Page Contains Element    //h2[text()="All Listings"]
    Scroll Element Into View    //h2[text()="All Listings"]
    Wait Until Element Is Visible    //p[text()="${group_name}"]
    Sleep    1
    Close Window
    Switch Window
    Wait Until Element Is Visible    //h2[text()="Product Groups"]

Product Groups - Click Button Name With Line Index
    [Documentation]   button list: [edit, copy, trash, chevron-down，chevron-up]
    [Arguments]    ${button}    ${line_index}=1
#    ${buttons}    Create List    edit    copy    trash   chevron-down
#    ${button}    Set Variable    ${buttons[${button_index}]}
    CLick Element    (//div[@data-rbd-droppable-id="droppableList"]//*[contains(@class,"icon-tabler-${button}")])[${line_index}]

Product Groups - Click Button Name With Group Name
    [Documentation]   button list: [edit, copy, trash, chevron-down，chevron-up]
    [Arguments]    ${button}    ${name}
    Sleep    1
    Click Element   //p[text()="${name}"]/../following-sibling::div//*[contains(@class,"icon-tabler-${button}")]
    Sleep    2

Product Groups - Waiting Edit Page Load
    Wait Until Page ContaIns Element    //div[text()="SAVE"]/parent::button

Product Groups - Waiting Group Items Show
    [Arguments]    ${show}=${True}
    Run Keyword If   '${show}'=='${True}'    Wait Until Element Is Visible     //h4[text()="Items in this Product Group"]
    Run Keyword If   '${show}'=='${False}'    Wait Until Element Is Not Visible     //h4[text()="Items in this Product Group"]


Product Groups - Get Total Group Quantity
    ${count}    Get Element Count    //p[text()="Visible on Storefront"]
    [Return]    ${count}

Product Groups - Delete Group Pop-up Window
    [Arguments]    ${sure}=${True}
    Wait Until Element Is Visible    //header[text()="Delete this product group?"]
    Page Should Contain Element    //*[contains(text(),"We will delete this product group once you click")]
    Run Keyword If   '${sure}'=='${True}'    Click Element    //div[text()="Got It"]/parent::button
    Run Keyword If   '${sure}'=='${False}'    Click Element    //div[text()="Caccel"]/parent::button

Product Groups - Set Group Visible On StoreFront By Index
    [Arguments]    ${line_index}=1    ${visible}=${True}
    ${isVisible}    Get Text    (//p[text()="Visible on Storefront"]/following-sibling::div//p)[${line_index}]
    Run Keyword If    '${isVisible}'=='No' and '${visible}'=='${True}'
    ...  Click Element    (//p[text()="Visible on Storefront"]/following-sibling::div/label)[${line_index}]
    Run Keyword If    '${isVisible}'=='Yes' and '${visible}'=='${False}'
    ...  Click Element    (//p[text()="Visible on Storefront"]/following-sibling::div/label)[${line_index}]
    Sleep    1
Product Groups - Set Group Visible On StoreFront By Name
    [Arguments]    ${name}    ${visible}=${True}
    ${isVisible}    Get Text    //p[text()="${name}"]/../following-sibling::div//label/following-sibling::p
    Run Keyword If    '${isVisible}'=='No' and '${visible}'=='${True}'
    ...  Click Element    //p[text()="${name}"]/../following-sibling::div//label
    Run Keyword If    '${isVisible}'=='Yes' and '${visible}'=='${False}'
    ...  Click Element    //p[text()="${name}"]/../following-sibling::div//label
    Sleep    1


