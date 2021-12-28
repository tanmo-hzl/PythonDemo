*** Settings ***
Library        ../../Libraries/MP/ListingLib.py
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Listing_Title}
${Random_Data}
${Selected_Item_Name}


*** Keywords ***
Click Create A Listing Button
    Click Element    //div[text()="CREATE A LISTING"]/..
    Wait Until Page Contains Element    //h1[text()="Listing Details"]

Create - Input Listing Title
    ${title}    Set Variable    Auto UI Test Item ${Random_Data}
    Set Suite Variable    ${Listing_Title}    ${title}
    Input Text    //input[@id="listingTitle"]     ${title}

Create - Select Listing Category
    Click Element    //input[@id="category-search"]
    Input Text    //input[@id="category-search"]    A
    Wait Until Element Is Visible    //*[@id="category-search"]/parent::div/following-sibling::div/div
    Click Element    //input[@id="category-search"]/parent::div/following-sibling::div/div

Create - Input Barand And Manufacturer
    Input Text    //input[@id="brandName"]    Auto UI Test
    Input Text    //input[@id="manufactureName"]    Optional ${Random_Data}

Create - Input Description
    Input Text    //textarea[@id="description"]    Auto UI Test Listing Create, description is None, ${Random_Data}.

Create - Select Recommented Age
    [Arguments]    ${index}=2
    ${count}    Get Element Count    //*[@id="recommended_age_range"]
    Run Keyword If     '${count}'=='1'    Click Element    //*[@id="recommended_age_range"]
    Run Keyword If     '${count}'=='1'    Click Element    (//*[@id="recommended_age_range"]/option)[${index}]

Create - Input Listing Tags
    [Arguments]    ${tag_name}=Create
    Input Text    //input[@id="tagSearch"]    ${tag_name}
    Click Button    //button[@aria-label="Add More Tags Button"]      # //form[@id="tagSearch"]//button
    Wait Until Element Is Visible    //span[@type="submit"]//p[text()="${tag_name}"]

Create - Input Date Range - Availabel
    ${abFrom}    Get Current Date     result_format=%Y-%m-%d
    ${abTo}    Add Time To Date     ${abFrom}    7 days    result_format=%Y-%m-%d
    ${abFroms}    Evaluate    str('${abFrom}').split("-")
    ${abTos}    Evaluate    str('${abTo}').split("-")
    Click Element    //input[@id="availableFrom"]
    Press Keys    None   ${abFroms[1]}+${abFroms[2]}+${abFroms[0]}
    Click Element    //input[@id="availableTo"]
    Press Keys    None   ${abTos[1]}+${abTos[2]}+${abTos[0]}

Create - Select Item Has No End Date
    ${count}    Get Element Count    //*[@id="unknownDate" and @value="true"]
    Run Keyword If     '${count}'!='1'    Click Element    //*[@id="unknownDate"]
    Run Keyword If     '${count}'!='1'    Wait Until Page Contains Element    //*[@id="unknownDate" and @value="true"]
#    ${availableTo}    Get Value    //input[@id="availableTo"]
#    Should Be Empty    ${availableTo}

Create - Unselect Item Has No End Date
    ${count}    Get Element Count    //*[@id="unknownDate" and @value="false"]
    Run Keyword If     '${count}'!='1'    Click Element    //*[@id="unknownDate"]
    Run Keyword If     '${count}'!='1'    Wait Until Page Contains Element    //*[@id="unknownDate" and @value="false"]

Create - Click Save As Draft
    Click Button    //div[text()="SAVE AS DRAFT"]/parent::button

Create - Click Save And Next
    Click Button    //div[text()="SAVE AND NEXT"]/parent::button

Create - Click Back
    Click Button    //p[text()="BACK"]/../parent::button

Create - Upload Photos
    [Arguments]    ${quantity}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${quantity}
        Wait Until Element Is Visible    //h1[text()="Inventory, Pricing and Photos"]
#        Click Element    //div[text()="SELECT FILES"]/parent::button
        ${file_path}    Get Random img Path
#        Upload File Mac    ${file_path}
        Choose File    Xpath=//*[@id="upload-photo"]    ${file_path}
    END
    Sleep   2
    Wait Until Element Is Visible    //*[@id="inventoryPricing"]/div[1]//img[@alt="uploaded"]

Create - Input Price And Quantity
    [Arguments]    ${price}=4.99    ${quantity}=66
    Input Text    //*[@id="price"]    ${price}
    Input Text    //*[@id="quantity"]    ${quantity}

Create - Open Add Variations Pop-up Windows
    [Arguments]    ${selected}=${True}
    Wait Until Element Is Visible    //h1[text()="Inventory, Pricing and Photos"]
    ${element}    Set Variable    //*[@id="show-variations"]/following-sibling::span
    ${count}    Get Element Count    //*[@id="show-variations"]/following-sibling::span[@data-checked]
    Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Click Element    ${element}
    Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Wait Until Element Is Visible    //p[starts-with(text(),"Add Variations")]

Create - Save Add Variations
    [Arguments]    ${sure}=${True}
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="SAVE"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="CANCEL"]/parent::button

Create - Upload Photos To Vaiantions
    ${file_path}    Get Random Img Path
    Wait Until Element Is Visible    //*[text()="Add photos to your product options."]
    Choose File    //p[starts-with(text(),"Add photos to")]/following-sibling::div//*[@id="upload-photo"]   ${file_path}
    Wait Until Element Is Visible    (//section//img)[2]
    Click Element    //div[text()="SAVE"]/parent::button
    Wait Until Element Is Not Visible    //*[text()="Add photos to your product options."]

Create - Input Variant Inventory And Price
    [Arguments]    ${inventory}=88    ${price}=5.66
    Input Text    //input[starts-with(@id,"inventories")]    ${inventory}
    Input Text    //input[starts-with(@id,"prices")]    ${price}

Create - Set Item Don't Hava Variants
    [Arguments]    ${sure}=${True}
    ${element_selected}    Set Variable    //*[@id="show-variations"]/following-sibling::span[@data-checked]
    ${count}    Get Element Count    ${element_selected}
    Run Keyword If    '${count}'=='1'    Create - Clear Table    ${sure}    ${element_selected}
    Run Keyword If    '${count}'=='1' and '${sure}'=='${False}'    Wait Until Element Is Visible    ${element_selected}
    Run Keyword If    '${count}'=='1' and '${sure}'=='${True}'    Wait Until Element Is Not Visible    ${element_selected}

Create - Clear Table Pop-up Windows Event
    [Arguments]    ${sure}=${True}    ${element}=${None}
    Mouse Over    ${element}
    Click Element    ${element}
    Wait Until Element Is Visible    //p[text()="Clear Table"]
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="YES, CLEAR TABLE"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="CANCEL"]/parent::button

Create - Select Variant Type One
    [Arguments]    ${value}=Size
    Select From List By Value    //Select[@id="variationTypeOne"]    ${value}

Create - Remove Added Variant Type
    [Arguments]    ${sure}=${True}
    Click Element    //p[text()="Remove"]/parent::button
    Wait Until Element Is Visible    //p[text()="We will empty the table!"]
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="Continue"]/parent::button
    Run Keyword If    '${sure}'=='${True}'    Wait Until Element Is Visible    //select[@id="variationTypeOne"]
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Wait Until Element Is Visible    //*[@name="category-search"]

Create - Add More Variations
    ${ele}    Set Variable    //p[text()="Add More Variations"]/parent::button
    ${count}    Get Element Count    ${ele}
    Run Keyword If    '${count}'=='1'    Click Element    ${ele}
    Wait Until Element Is Not Visible    ${ele}

Create - Select Variant Type Two
    [Arguments]    ${value}=Size
    Select From List By Value    //Select[@id="variationTypeTwo"]    ${value}
    Input Text    //*[@name="category-search"]    Larget

Create - Add Value To Variant One - Not Color
    [Arguments]    ${size}=Normal
    Input Text    //*[@name="category-search"]     ${size}
    Click Element    //*[contains(@class,"icon-tabler-circle-plus")]/parent::button
    Wait Until Element Is Visible    //*[starts-with(@aria-label,"Remove Tag")]

Create - Add Value To Variant One - Color
    [Arguments]    ${index}=2
    Select From List By Index     //select[@id="variationOne"]    ${index}
    Wait Until Element Is Visible    //*[starts-with(@aria-label,"Remove Tag")]

Create - Add Value To Variant Two - Color
    [Arguments]    ${index}=2
    Select From List By Index     //select[@id="variationTwo"]    ${index}
    Wait Until Element Is Visible    //*[starts-with(@aria-label,"Remove Tag")]

Create - Set Inventory varies for each variation Selected
    [Arguments]    ${selected}=${True}
    ${count}    Get Element Count    //p[text()=" Inventory varies for each variation"]/parent::span[@data-checked]
    ${element}    Set Variable    //p[text()=" Inventory varies for each variation"]/parent::span
    Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Click Element    ${element}
    Run Keyword If    '${selected}'=='${False}' and '${count}'=='1'    Click Element    ${element}

Create - Set Price varies for each variation Selected
    [Arguments]    ${selected}=${True}
    ${element_selected}    Set Variable    //p[text()=" Price varies for each variation"]/parent::span[@data-checked]
    ${count}    Get Element Count    ${element_selected}
    ${element}    Set Variable    //p[text()=" Price varies for each variation"]/parent::span
    Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Click Element    ${element}
#    Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Wait Until Element Is Visible    ${element_selected}
    Run Keyword If    '${selected}'=='${False}' and '${count}'=='1'    Click Element    ${element}
#    Run Keyword If    '${selected}'=='${False}' and '${count}'=='1'    Wait Until Element Is Not Visible    ${element_selected}

Create - Set Item Have Subscription
    ${count}    Get Element Count    //*[@id="subscription-discounts"]/following-sibling::span[@data-checked]
    Run Keyword If     '${count}'!='1'    Click Element    //*[@id="subscription-discounts"]/following-sibling::span
    Run Keyword If     '${count}'!='1'    Wait Until Page Contains Element    //*[@id="subscription-discounts"]/following-sibling::span[@data-checked]

Create - Set Item Don't Have Subscription
    ${count}    Get Element Count    //*[@id="subscription-discounts"]/following-sibling::span[@data-checked]
    Run Keyword If     '${count}'!='0'    Click Element    //*[@id="subscription-discounts"]/following-sibling::span
    Run Keyword If     '${count}'!='0'    Wait Until Page Does Not Contain Element    //*[@id="subscription-discounts"]/following-sibling::span[@data-checked]

Create - Open Item Attributes Pop-up Window for Variations
    Wait Until Element Is Visible    //h1[text()="Shipping and Return"]
    Click Element    //table//p[text()="Update"]
    Wait Until Element Is Visible    //p[text()="Select Attributes for Variations"]

Create - Close Item Attributes Pop-up Window for Variations
    [Arguments]    ${save}=${true}
    Run Keyword If    '${save}'=='${True}'    Click Element    //div[text()="Update Changes"]/parent::button
    Run Keyword If    '${save}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Select Attributes for Variations"]

Create - Input Item Attributes - Color Family
    [Arguments]    ${value}=Red
    Wait Until Element Is Visible    //h1[text()="Shipping and Return"]
    Click Element    //select[@id="variationTypeColor"]
    Wait Until Element Is Visible    //option[text()="${value}"]
    Click Element    //option[text()="${value}"]
    Input Text    //*[@id="variationColor"]    Primary Color Name ${Random_Data}

Create - Input Item Attributes - GTIN
    [Arguments]    ${value}=UPC
    ${number}    Evaluate    str(random.randint(1000,9999))*3
    Click Element    //Select[@id="globalTradeItemNumberType"]
    Wait Until Element Is Visible    //option[text()="${value}"]
    Click Element    //option[text()="${value}"]
    Input Text    //input[@id="globalTradeItemNumber"]     ${number}

Create - Input Item Volume
    Input Text    //input[@id="length"]     1
    Input Text    //input[@id="width"]     1
    Input Text    //input[@id="height"]     1
    Input Text    //input[@id="weight"]     0.25
    Sleep    1
    ${volume}    Get Value     //*[@id="volume"]
    Run Keyword And Ignore Error    Should Be Equal As Strings    ${volume}    1.00

Create - Enter Listing Confirmation Page
    Scroll Element Into View    //div[text()="SAVE AND NEXT"]/parent::button
    Create - Click Save And Next
    Wait Until Element Is Visible      //h1[text()="Listing Confirmation"]

Create - Click Publish Campaign And Select Next Page
    [Arguments]    ${to_page}=1
    Wait Until Element Is Visible    //div[text()="Publish Listing"]/parent::button
    Sleep    1
    Scroll Element Into View    //div[text()="Publish Listing"]/parent::button
    Click Element    //div[text()="Publish Listing"]/parent::button
    Wait Until Element Is Visible    //p[text()="Your Listing Submission Is Confirmed"]
    Run Keyword If    '${to_page}'!='1'    Click Element    //div[text()="GO TO DASHBOARD"]/parent::button
    Run Keyword If    '${to_page}'=='1'    Click Element    //div[text()="GO TO LISTING MANAGEMENT"]/parent::button
    Run Keyword If    '${to_page}'!='1'    Wait Until Element Is Visible    //h1[starts-with(text(),"Welcome to your Dashboard")]
    Run Keyword If    '${to_page}'=='1'    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Create - Stop Create Listing
    ${count}    Get Element Count    //a[@aria-label="Close and return to Michaels.com"]
    Run Keyword If     '${count}'!='0'    Scroll Element Into View    //a[@aria-label="Close and return to Michaels.com"]
    Run Keyword If     '${count}'!='0'    Click Element    //a[@aria-label="Close and return to Michaels.com"]

Enter Listing Detail Page By Index
    [Arguments]  ${index}=1
    Click Element    //table/tbody/tr[${index}]/td/button
    Sleep    2
    Wait Until Element Is Visible    //h1[text()="Listing Details"]

Update - Stop Update Listing
    Scroll Element Into View    //*[@class="icon icon-tabler icon-tabler-x"]
    Click Element    //*[@class="icon icon-tabler icon-tabler-x"]

Update - Click Cancel
    Scroll Element Into View    //div[text()="CANCEL"]/parent::button
    Click Element    //div[text()="CANCEL"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Update - Click Publish
    Scroll Element Into View    //div[text()="PUBLISH"]/parent::button
    Click Element    //div[text()="PUBLISH"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Update - Click Update Changes
    Scroll Element Into View    //div[text()="UPDATE CHANGES"]/parent::button
    Click Element    //div[text()="UPDATE CHANGES"]/parent::button
#    Your Listing Submission Is Confirmed
    Run Keyword And Ignore Error    Update - Submission Confirmed Pop-up Windows
    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Update - Submission Confirmed Pop-up Windows
    Wait Until Element Is Visible    //p[text()="Your Listing Submission Is Confirmed"]
    Click Element    //div[text()="GO TO LISTING MANAGEMENT"]/parent::button

Update - Change Listing Title
    Wait Until Element Is Visible    //*[@id="skuName"]
    Clear Element Value   //*[@id="skuName"]
    ${title}    Set Variable    New Auto UI Test Item ${Random_Data}
    Set Suite Variable    ${Listing_Title}    ${title}
    Input Text    //*[@id="skuName"]    ${title}

Update - Change Listing Category
    [Arguments]    ${is_update}=${True}
    Click Element    //input[@id="category-search"]
    Input Text    //input[@id="category-search"]    A
    Wait Until Element Is Visible    //*[@id="category-search"]/parent::div/following-sibling::div/div/div
    Sleep    1
    Click Element    //*[@id="category-search"]/parent::div/following-sibling::div/div/div
    Wait Until Element Is Visible    //header[text()="Confirmation of Category Update"]
    Run Keyword If   '${is_update}'=='${True}'    Click Element   //div[text()="UPDATE CATEGORY"]/parent::button
    Run Keyword If   '${is_update}'=='${False}'    Click Element   //div[text()="CANCEL"]/parent::button

Update - Change Barand Name And Manufacturer
    Clear Element Value    //*[@id="brandName"]
    Clear Element Value    //*[@id="manufactureName"]
    Create - Input Barand And Manufacturer

Update - Change Description
    Scroll Element Into View    //h4[text()="Product Description"]
    Clear Element Value    //*[@id="longDescription"]
    Input Text    //*[@id="longDescription"]    Auto UI Test Listing Update, description is None, ${Random_Data}.

Update - Change Selected Recommented Age
    [Arguments]    ${index}=2
    Create - Select Recommented Age    ${index}

Update - Change Listing Tags
    [Arguments]    ${tag_name}=Update
    Scroll Element Into View    //h4[text()="Tags"]
    ${count}    Get Element Count    //*[starts-with(@aria-label,"Remove Tag")]
    Run Keyword If    '${count}'!='0'    Update - Remove All tags    ${count}
    Create - Input Listing Tags    ${tag_name}

Update - Remove All tags
    [Arguments]    ${count}=0
    ${count}    Get Element Count    //*[starts-with(@aria-label,"Remove Tag")]
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${count}
        Click Element    //*[starts-with(@aria-label,"Remove Tag")]
    END

Update - Select Item Has No End Date
    Create - Select Item Has No End Date

Update - Unselected Item Has No End Date
    Create - Unselect Item Has No End Date

Update - Change Date Range End
    Scroll Element Into View    //h4[text()="Listing Date Range"]
    Create - Unselect Item Has No End Date
    ${abFrom}    Get Current Date     result_format=%Y-%m-%d
    ${abTo}    Add Time To Date     ${abFrom}    7 days    result_format=%Y-%m-%d
    ${abTos}    Evaluate    str('${abTo}').split("-")
    Click Element    //input[@id="toDate"]
    Press Keys    None   ${abTos[1]}+${abTos[2]}+${abTos[0]}

Update - Change Price And Inverntory
    [Arguments]   ${price}=5.88    ${inverntory}=77
    Scroll Element Into View    //h4[text()="Inventory and Pricing"]
    Clear Element Value    //*[@id="price"]
    Input Text    //*[@id="price"]    ${price}
    Clear Element Value    //*[@id="inventory"]
    Input Text    //*[@id="inventory"]    ${inverntory}

Update - Upload Photos
    [Arguments]    ${quantity}=1
    Scroll Element Into View    //h4[text()="Video"]
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${quantity}
        Wait Until Element Is Visible    //h1[text()="Inventory, Pricing and Photos"]
        Click Element    //div[text()="SELECT FILES"]/parent::button
        Sleep   3
        ${file_path}    Get Random img Path
        Upload File Mac    ${file_path}
    END
    Sleep   3
    Wait Until Element Is Visible    //*[@id="inventoryPricing"]/div[1]//img[@alt="uploaded"]

Update - Change Color Family
    [Arguments]    ${index}=2
    Scroll Element Into View    //h4[text()="Item Weight and Warning Attributes"]
    Select From List By Index    //select[@id="variationTypeColor"]    ${index}
    Clear Element Value    //*[@id="variationColor"]
    Input Text    //*[@id="variationColor"]    Primary Color Name ${Random_Data}

Update - Change Item Volume
    Clear Element Value    //input[@id="length"]
    Clear Element Value    //input[@id="width"]
    Clear Element Value    //input[@id="height"]
    Clear Element Value    //input[@id="weight"]
    Create - Input Item Volume

Filters - Clear All Filters
    Click Element    //p[text()="Filters"]/following-sibling::button
    Wait Until Element Is Visible    //header[text()="Filters"]
    Click Element    //div[text()="CLEAR ALL"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Filters"]

Filters - Search Listing By Status
    [Documentation]    status list: Prohibited,Pending Review,Out of stock,Archived,Active,Draft,Inactive,Suspended
    [Arguments]    ${status}=Draft
    Click Element    //p[text()="Filters"]/following-sibling::button
    Wait Until Element Is Visible    //header[text()="Filters"]
    Click Element    //p[text()="${status}"]/../../parent::label[starts-with(@class,"chakra-checkbox")]
    Sleep    1
    Click Element    //div[text()="VIEW RESULTS"]/parent::button
    Wait Until Element Is Not Visible     //header[text()="Filters"]

Set Listing Selected By Index
    [Arguments]    ${index}=1
    Click Element    //table//tbody//tr[${index}]//td[1]
    ${Selected_Item_Name}    Get Text    //table//tbody//tr[${index}]//td[3]//p
    Set Suite Variable    ${Selected_Item_Name}    ${Selected_Item_Name}

Set The Last Listing Selected On Page
    ${count}    Get Element Count    //table//tbody//tr
    Set Listing Selected By Index    ${count}

Delete Lisitng After Selected Draft Item
    [Arguments]    ${is_sure}=${True}
    Wait Until Element Is Visible    //*[contains(@class,"icon-tabler-trash")]/parent::button
    Click Element    //*[contains(@class,"icon-tabler-trash")]/parent::button
    Wait Until Element Is Visible    //p[text()="Confirmation of listing deletion"]
    Run Keyword If    '${is_sure}'=='${True}'    Click Element    //div[text()="CONTINUE"]/parent::button
    Run Keyword If    '${is_sure}'=='${False}'    Click Element    //div[text()="CANCEL"]/parent::button

Search Lisitng By Title
    [Arguments]    ${search_key}
    Clear Element Value    //input[@title="search-materials"]
    Input Text    //input[@title="search-materials"]    ${search_key}
    Press Keys    //input[@title="search-materials"]    RETURN
    Wait Until Element Is Visible    //table//tbody//tr//td[3]//p[contains(text(),"${search_key}")]
    Clear Element Value    //input[@title="search-materials"]

Check Listing Status By Title
    [Arguments]    ${status}
    Filters - Clear All Filters
    Filters - Search Listing By Status    ${status}
    Search Lisitng By Title     ${Selected_Item_Name}

Recover Listing After Selected Archived Item
    Wait Until Element Is Visible    //*[contains(@class,"icon-tabler-rotate-clockwise")]/parent::button
    Click Element    //*[contains(@class,"icon-tabler-rotate-clockwise")]/parent::button
    Sleep    3

Relist Listing After Selected Inactive Item
    [Arguments]    ${is_sure}=${True}
    Wait Until Element Is Visible    //*[contains(@class,"icon-tabler-notes")]/parent::button
    Click Element    //*[contains(@class,"icon-tabler-notes")]/parent::button
    Wait Until Element Is Visible    //p[text()="Confirmation of listing relist"]
    ${abFrom}    Get Current Date     result_format=%Y-%m-%d
    ${abTo}    Add Time To Date     ${abFrom}    7 days    result_format=%Y-%m-%d
    ${abFroms}    Evaluate    str('${abFrom}').split("-")
    ${abTos}    Evaluate    str('${abTo}').split("-")
    Click Element    //input[@id="startDate"]
    Press Keys    None   ${abFroms[0]}+TAB+${abFroms[1]}+${abFroms[2]}
    Click Element    //input[@id="endDate"]
    Press Keys    None   ${abTos[0]}+TAB+${abTos[1]}+${abTos[2]}
    Run Keyword If    '${is_sure}'=='${True}'    Click Element    //div[text()="CONTINUE"]/parent::button
    Run Keyword If    '${is_sure}'=='${False}'    Click Element    //div[text()="CANCEL"]/parent::button



