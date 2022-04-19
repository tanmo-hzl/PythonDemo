*** Settings ***
Library        ../../Libraries/MP/SellerListingLib.py
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/RwXlsxFile.py
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../Keywords/MP/EAInitialSellerDataAPiKeywords.robot

*** Variables ***
${Selected_Item_Name}
${Listing_Info}
${Single_Sku}
${Attributes}
${Volumes}
${Variants}
${Photos}
${Variant_Quantity}
${SELLER_STORE_ID}
${Cur_Listing_Total}
${Cur_Listing_Info}
${Export_Listing_Have_Variants}    ${None}
${Export_Listing_No_Variants}    ${None}
${Export_Listing_Required_Keys}    ${None}
${Download_Dir}    ${None}
${Catefory_Need_Update}     ${False}

*** Keywords ***
Listing - Click Create A Listing Button
    Click Element    //div[text()="CREATE A LISTING"]/..
    Wait Until Page Contains Element    //h1[text()="Listing Details"]

Create - Input Listing Title
    Input Text    //input[@name="listingTitle"]     ${Listing_Info}[title]

Create - Select Listing Category
    Click Element    //input[@name="category-search"]
    Wait Until Element Is Visible    //*[@name="category-search"]/parent::div/following-sibling::div//div[contains(@class,"category-item")]   ${MAX_TIME_OUT}
    Input Text    //input[@name="category-search"]    ${Listing_Info}[category]
    Sleep    1
    Click Element    //input[@name="category-search"]/parent::div/following-sibling::div//div[contains(@class,"category-item")]

Create - Input Seller Sku
    Input Text    //*[@name="sellerSkuNumber"]    ${Listing_Info}[sellerSku]

Create - Automatically Generate Seller Sku
    Click Element    //div[text()="Automatically generate"]/parent::button

Create - Input Barand And Manufacturer
    Clear Element Value    //input[@name="brandName"]
    Input Text    //input[@name="brandName"]    ${Listing_Info}[bandName]
    Clear Element Value    //input[@name="manufactureName"]
    Input Text    //input[@name="manufactureName"]    ${Listing_Info}[manufacturer]

Create - Input Description
    Clear Element Value    //textarea[@name="description"]
    Input Text    //textarea[@name="description"]    ${Listing_Info}[description]

Create&Update - Select Optional Info
    [Arguments]   ${is_create}=${True}
    IF    '${is_create}'=='${True}'
        ${optional_ele}    Set Variable   (//label[contains(text(),"Optional")]/following-sibling::div/select)
    ELSE
        ${optional_ele}    Set Variable   (//*[text()="Listing Details"]/../following-sibling::div//label[contains(text(),"Optional")]/following-sibling::div/select)
    END
    ${count}   Get Element Count    ${optional_ele}
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE   1    ${count}
        Click Element    ${optional_ele}\[${index}\]
        Wait Until Element Is Visible    ${optional_ele}\[${index}\]//option\[2\]
        Click Element    ${optional_ele}\[${index}\]//option\[2\]
    END

Create - Input Listing Tags
    ${tags}    Get Json Value    ${Listing_Info}    tags
    ${item}    Set Variable
    FOR    ${item}    IN    @{tags}
        Input Text    //input[@name="tag_input"]    ${item}
        Click Button    //button[@aria-label="Add More Tags Button"]      # //form[@id="tagSearch"]//button
        Wait Until Element Is Visible    //span[@type="submit"]//p[text()="${item}"]
    END

Create - Input Date Range - Availabel
    [Arguments]    ${add_from_days}=0
    Scroll Element Into View    //input[@name="availableFrom"]
    ${availableFrom}    Get Current Date     result_format=%Y-%m-%d
    ${availableFrom}    Add Time To Date     ${availableFrom}    ${add_from_days} days
    ${fromDate}    Evaluate    '${availableFrom}'\[:10\]
    Set To Dictionary    ${Listing_Info}     fromDate=${fromDate}
#    Click Element    //input[@name="availableFrom"]
    Common - Select Date By Element   ${Listing_Info}[fromDate]    //input[@name="availableFrom"]
#    Click Element    //input[@name="availableTo"]
    Common - Select Date By Element   ${Listing_Info}[toDate]    //input[@name="availableTo"]


Create - Item End Date Setting
    Run Keyword If     '${Listing_Info}[endDate]'=='${False}'
    ...    Create&Update - Unselect Item Has No End Date
    Run Keyword If     '${Listing_Info}[endDate]'=='${True}'
    ...    Create&Update - Select Item Has No End Date

Create&Update - Select Item Has No End Date
    Scroll Element Into View    //*[@name="unknownDate"]
    ${count}    Get Element Count    //*[@name="unknownDate" and @value="true"]
    Run Keyword If     '${count}'!='1'    Click Element    //*[@name="unknownDate"]
    Run Keyword If     '${count}'!='1'    Wait Until Page Contains Element    //*[@name="unknownDate" and @value="true"]

Create&Update - Unselect Item Has No End Date
    Scroll Element Into View    //*[@name="unknownDate"]
    ${count}    Get Element Count    //*[@name="unknownDate" and @value="false"]
    Run Keyword If     '${count}'!='1'    Click Element    //*[@name="unknownDate"]
    Run Keyword If     '${count}'!='1'    Wait Until Page Contains Element    //*[@name="unknownDate" and @value="false"]

Create - Click Save As Draft
    Click Button    //div[text()="SAVE AS DRAFT"]/parent::button
    Create - Save Draft Confirmed

Create - Click Save And Next
    [Arguments]    ${index}=1
    Click Button    //div[text()="SAVE AND NEXT"]/parent::button
    IF    ${index}==1
        Wait Until Element Is Visible    //h1[text()="Inventory, Pricing and Photos"]
    ELSE IF    ${index}==2
        Wait Until Element Is Visible    //h1[text()="Shipping and Return"]
    ELSE IF    ${index}==3
        Wait Until Element Is Visible      //h2[text()="Listing Confirmation"]
        Scroll Last Button Into View
        Wait Until Page Contains Element    //h3[text()="Shipping & Returns"]
        Wait Until Page Contains Element    //h3[text()="Store Information"]
    END

Create - Click Back
    Click Button    //p[text()="BACK"]/../parent::button
    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Create - Upload Photos
    ${photos}    Get Json Value    ${Listing_Info}    photos
    Set Suite Variable    ${Photos}    ${photos}
    ${item}    Set Variable
    FOR    ${item}    IN    @{photos}
        ${count}    Get Element Count    //img[@alt="uploaded"]
        ${new_count}    Evaluate    ${count}+1
        Wait Until Element Is Visible    //h1[text()="Inventory, Pricing and Photos"]
        Choose File    Xpath=//*[@id="upload-photo"]    ${item}
#        Wait Until Element Is Visible    (//img[@alt="uploaded"])[${new_count}]
    END
    Sleep   1

Create - Wait Photos Uploaded For Single Sku
    ${len}    Get Length    ${Photos}
    Wait Until Page Contains Element    (//img[@alt="uploaded"])[${len}]

Create - Input Price And Quantity
    Set Suite Variable    ${Single_Sku}    ${Listing_Info}[singleSku]
    Clear Element Value    //*[@name="price"]
    Input Text    //*[@name="price"]    ${Single_Sku}[price]
    Clear Element Value    //*[@name="quantity"]
    Input Text    //*[@name="quantity"]    ${Single_Sku}[quantity]

Create&Update - Open Add Variations Pop-up Windows
    [Arguments]    ${is_create}=${True}    ${selected}=${True}
    IF    '${is_create}'=='${True}'
        Wait Until Element Is Visible    //h1[text()="Inventory, Pricing and Photos"]
        ${element}    Set Variable    //*[@id="show-variations"]/following-sibling::span
        ${count}    Get Element Count    //*[@id="show-variations"]/following-sibling::span[@data-checked]
        Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Click Element    ${element}
        Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Wait Until Element Is Visible    //p[starts-with(text(),"Add Variations")]
    ELSE
        Scroll Element Into View    //div[text()="Edit Variants"]/parent::button
        Click Element    //div[text()="Edit Variants"]/parent::button
        Wait Until Element Is Visible    //p[starts-with(text(),"Add Variations")]
    END

Create&Update - Save Add Variations
    [Arguments]    ${sure}=${True}
    Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="SAVE"]/parent::button
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="CANCEL"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="SAVE"]/parent::button

Create&Update - Loop Upload Photos To Vaiantions
    Scroll Element Into View     //th[text()="Photos"]/../../../tbody
    Wait Until Element Is Visible     //th[text()="Photos"]/../../../tbody/tr
    ${base_ele}    Set Variable    //th[text()="Photos"]/../../../tbody/tr
    ${photos_count}    Get Element Count    ${base_ele}
    Sleep    2
    ${photos_count}    Evaluate    ${photos_count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${photos_count}
        Click Element    ${base_ele}\[${index}\]//td\[2\]/div/img\[@alt=""\]
        Create&Update - Upload Photos To Vaiantions On Pop-up Windows    ${index}
    END

Create&Update - Upload Photos To Vaiantions On Pop-up Windows
    [Arguments]  ${index}=1
    Wait Until Element Is Visible    //p[text()="Upload Photos"]
    IF    '${index}'=='1'
        ${count}   Get Element Count    //p[starts-with(text(),"Swatch Image")]/following-sibling::div//input
        IF    '${count}'=='1'
            Choose File    //p[starts-with(text(),"Swatch Image")]/following-sibling::div//input    ${Photos[0]}
        END
        ${count}    Get Element Count    //p[starts-with(text(),"Variant Image")]/following-sibling::div//img
        IF    '${count}'=='1'
            Choose File    //p[starts-with(text(),"Variant Image")]/following-sibling::div//input    ${Photos[0]}
        END
    ELSE
        Click Element    //p[text()="Upload New Photos"]/../following-sibling::div/label
        Wait Until Element Is Visible    //option[text()="Select from the list"]/parent::select
        ${count}    Get Element Count    //option[text()="Select from the list"]/parent::select/option
        ${value}    Evaluate    ${count}-2
        Select From List By Value    //option[text()="Select from the list"]/parent::select    ${value}
        Wait Until Element Is Visible    //p[starts-with(text(),"Variant Image")]
        ${count}   Get Element Count    //p[starts-with(text(),"Swatch Image")]/following-sibling::div//input
        IF    '${count}'=='1'
            Choose File    //p[starts-with(text(),"Swatch Image")]/following-sibling::div//input    ${Photos[0]}
        END
    END
    Wait Until Element Is Not Visible    //span[text()="Loading..."]
    Sleep    0.5
    Click Element    //div[text()="Save"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Upload Photos"]

Create - Upload Photos To Vaiantions
    ${count}    Get Element Count    //*[text()="Add photos to your product options."]
    IF    '${count}'=='0'
        Click Element    //div[text()="Edit Photos"]/parent::button
    END
    Wait Until Element Is Visible    //*[text()="Add photos to your product options."]
    ${count}    Get Element Count    //*[contains(@id,"chakra-modal")]//*[@id="upload-swatch"]
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${count}    1
        Choose File    (//*[contains(@id,"chakra-modal")]//*[@id="upload-swatch"])[${index}]    ${Photos[0]}
    END
    ${count}    Get Element Count    //*[contains(@id,"chakra-modal")]//*[@id="upload-photo"]
    ${count}    Evaluate    ${count}+1
    FOR    ${index}    IN RANGE    1    ${count}    1
        Choose File    (//*[contains(@id,"chakra-modal")]//*[@id="upload-photo"])[${index}]    ${Photos[0]}
    END
    Create - Wait Photos Uploaded For Vaiantions
    Sleep    1
    Wait Until Element Is Enabled    //div[text()="SAVE"]/parent::button
    Click Element    //div[text()="SAVE"]/parent::button
    Wait Until Element Is Not Visible    //*[text()="Add photos to your product options."]
    Sleep    1

Create - Wait Photos Uploaded For Vaiantions
    ${count}    Get Element Count    //*[contains(@id,"chakra-modal")]//*[@id="upload-photo"]
    Wait Until Page Does Not Contain Element    (//*[contains(@id,"chakra-modal")]//*[@id="upload-swatch"])
    Wait Until Page Contains Element    (//div[contains(text(),"Upload Photos")]/../preceding-sibling::div//button)[${count}]

Create - Set One Variant Is Not Visible    ${ele_id}    Set Variable    ${Variants}[unVisible]
    Execute Javascript    document.querySelector("#variation-${ele_id}-visible").scrollIntoView()
    Sleep    1
    Execute Javascript     document.querySelector("#variation-${ele_id}-visible").click()
    Sleep    0.5

Create&Update - Select All To Update Variant Inventory And Price
    Wait Until Element Is Visible    //p[contains(text(),"Select All")]/../parent::button
    Scroll Element Into View    //*[@name="variationsTable[0].inventory"]
    Scroll Element Into View    //p[contains(text(),"Select All")]/../parent::button
    Sleep    1
    Click Element    //p[contains(text(),"Select All")]/../parent::button
    Wait Until Element Is Enabled    //*[text()="Update Price"]/../parent::button
    Create&Update - Update Price For All Variants
    Create&Update - Update Inventory For All Variants

Create&Update - Update Price For All Variants
    [Arguments]    ${sure}=${True}
    Click Element    //p[text()="Update Price"]/../parent::button
    Wait Until Element Is Visible    //p[text()="Update Price for Variants"]
    Clear Element Value    //*[@placeholder="Price in US Dollars"]
    Input Text    //*[@placeholder="Price in US Dollars"]    ${Variants}[price]
    Click Element    //div[text()="Update"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Update Price for Variants"]

Create&Update - Update Inventory For All Variants
    [Arguments]    ${sure}=${True}
    Click Element    //p[text()="Update Inventory"]/../parent::button
    Wait Until Element Is Visible    //p[text()="Update Inventory for Variants"]
    Clear Element Value    //*[@placeholder="Enter Quantity"]
    Input Text    //*[@placeholder="Enter Quantity"]    ${Variants}[quantity]
    Click Element    //div[text()="Update"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Update Inventory for Variants"]


Create - Input Variant Inventory And Price
    [Arguments]    ${inventory}=88    ${price}=5.66
    Input Text    //input[contains(@name,"inventory")]    ${inventory}
    Input Text    //input[contains(@name,"price")]    ${price}

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

Create&Update - Set Variants Info
    [Arguments]    ${is_create}=${True}
    Set Suite Variable    ${Variants}    ${Listing_Info}[variants]
    Create&Update - Open Add Variations Pop-up Windows    ${is_create}
    ${var_type}    Get Json Value    ${Variants}    type
    IF    "${is_create}"=="${False}"
        Listing - Variant Type - Remove Added Variations
    END
    Create - Select Variant Type By Index    ${var_type[0]}
    ${var_type_one_value}    Get Json Value    ${Variants}    ${var_type[0]}
    ${item}    Set Variable
    FOR    ${item}    IN    @{var_type_one_value}
        Create - Add Value To Variant - Size   ${item}
    END
    Sleep    1
    IF    '${Variant_Quantity}'=='2' or '${Variant_Quantity}'=='3'
        Create - Add More Variations
        Create - Select Variant Type By Index    ${var_type[1]}
        ${var_type_two_value}    Get Json Value    ${Variants}    ${var_type[1]}
        Create - Add Value To Variant - Color    ${var_type_two_value[0]}
        Create - Add Value To Variant - Other Color - V1    ${Variants}[otherColor]
    END
    Sleep    1
    IF    '${Variant_Quantity}'=='3'
        Create - Add More Variations
        Create - Select Variant Type By Index    ${var_type[2]}
        ${var_type_three_value}    Get Json Value    ${Variants}    ${var_type[2]}
        FOR    ${item}    IN    @{var_type_three_value}
            Create - Add Value To Variant - Count   ${item}
        END
    END
    Create&Update - Set Inventory varies for each variation Selected
    Create&Update - Set Price Varies For Each Variation Selected
    Create&Update - Save Add Variations

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
#    Wait Until Element Is Not Visible    ${ele}
    Sleep    1

Create - Select Variant Type By Index
    [Arguments]    ${value}=Size    ${index}=1
    Select From List By Value    (//option[text()="Select variant type"]/parent::select)[${index}]    ${value}

Create - Add Value To Variant - Size
    [Arguments]    ${value}=Normal
    Input Text    //*[@placeholder="Enter new Size options"]     ${value}
    Click Element    //*[@placeholder="Enter new Size options"]/following-sibling::div/button
    Wait Until Element Is Visible    //p[text()="${value}"]/../following-sibling::*[starts-with(@aria-label,"Remove Tag")]

Create - Add Value To Variant - Count
    [Arguments]    ${value}=Six
    Input Text    //*[@placeholder="Enter new Count options"]     ${value}
    Click Element    //*[@placeholder="Enter new Count options"]/following-sibling::div/button
    Wait Until Element Is Visible    //p[text()="${value}"]/../following-sibling::*[starts-with(@aria-label,"Remove Tag")]

Create - Add Value To Variant - Model
    [Arguments]    ${value}=Model
    Input Text    //*[@placeholder="Enter new Model options"]     ${value}
    Click Element    //*[@placeholder="Enter new Model options"]/following-sibling::div/button
    Wait Until Element Is Visible    //p[text()="${value}"]/../following-sibling::*[starts-with(@aria-label,"Remove Tag")]

Create - Add Value To Variant - Color
    [Arguments]    ${label}=Red
    Wait Until Element Is Visible    //*[@placeholder="Please select options"]
    Click Element    //*[@placeholder="Please select options"]
    ${color_ele}   Set Variable    //p[text()="${label}"]/../parent::label
    Wait Until Element Is Visible    ${color_ele}
    Click Element    ${color_ele}
    Click Element    //p[text()="Color"]
    Wait Until Page Contains Element    //p[text()="${label}"]/../following-sibling::*[starts-with(@aria-label,"Remove Tag")]
    Sleep    0.5

Create - Add Value To Variant - Other Color - V1
    [Arguments]    ${name}=Other    ${value}=None of these work? Create a new one!
    Wait Until Element Is Visible    //*[@placeholder="Please select options"]
    Click Element    //*[@placeholder="Please select options"]
    ${color_ele}   Set Variable    //p[text()="${value}"]/../parent::label
    Wait Until Element Is Visible    ${color_ele}
    Click Element    ${color_ele}
    Click Element    //p[text()="Color"]
    Wait Until Element Is Visible    //*[@placeholder="Enter new Color options"]
    Input Text    //*[@placeholder="Enter new Color options"]    ${name}
    Click Element    //*[@placeholder="Enter new Color options"]/following-sibling::div/button
    Wait Until Element Is Visible    //p[text()="${name}"]/../following-sibling::*[starts-with(@aria-label,"Remove Tag")]
    Sleep    0.5

Create - Add Value To Variant - Other Color
    [Arguments]    ${name}=Other
    Input Text    //*[@placeholder="Enter new Color options"]    ${name}
    Click Element    //*[@placeholder="Enter new Color options"]/following-sibling::div/button
    Wait Until Element Is Visible    //p[text()="${name}"]/../following-sibling::*[starts-with(@aria-label,"Remove Tag")]
    Sleep    0.5

Create&Update - Set Inventory varies for each variation Selected
    [Arguments]    ${selected}=${True}
    ${count}    Get Element Count    //p[text()=" Inventory varies for each variation"]/parent::span[@data-checked]
    ${element}    Set Variable    //p[text()=" Inventory varies for each variation"]/parent::span
    Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Click Element    ${element}
    Run Keyword If    '${selected}'=='${False}' and '${count}'=='1'    Click Element    ${element}

Create&Update - Set Price varies for each variation Selected
    [Arguments]    ${selected}=${True}
    ${element_selected}    Set Variable    //p[text()=" Price varies for each variation"]/parent::span[@data-checked]
    ${count}    Get Element Count    ${element_selected}
    ${element}    Set Variable    //p[text()=" Price varies for each variation"]/parent::span
    Run Keyword If    '${selected}'=='${True}' and '${count}'=='0'    Click Element    ${element}
    Run Keyword If    '${selected}'=='${False}' and '${count}'=='1'    Click Element    ${element}


#Create - Subscription Setting
#    ${subscription}    Set Variable    ${Listing_Info}[subscription]
#    IF    '${subscription}[status]'!='${None}'
#        IF    '${subscription}[status]'=='${True}'
#            Create&Update - Set Item Have Subscription
#            Input Text    //*[@name="percentOffOnPrice"]    ${subscription}[firstOff]
#            Input Text    //*[@name="percentOffOnRepeatDeliveries"]    ${subscription}[repeatOff]
#        ELSE
#            Create&Update - Set Item Don't Have Subscription
#        END
#    END

Create - Update Variant Items Attributes
    Wait Until Element Is Visible    //table//p[text()="Update"]
    Wait Until Element Is Enabled    //table//p[text()="Update"]
    Sleep    1
    ${variant_attributes}    Get Json Value    ${Variants}    attributes
    Set Suite Variable    ${Volumes}    ${Variants}[volumes]
    ${update_count}    Get Element Count    //table//p[text()="Update"]
    ${index}    Set Variable
    FOR    ${index}    IN RANGE   ${update_count}
        Set Suite Variable    ${Attributes}    ${variant_attributes[${index}]}
        ${update_index}    Evaluate    ${index}+1
        Create - Open Item Attributes Pop-up Window for Variations    ${update_index}
        Create&Update - Input Item Attributes - GTIN
        Create - Variant Input Seller Sku
        Create&Update - Input Item Volume    ${True}
        Create - Close Item Attributes Pop-up Window For Variations
        Sleep    0.5
    END

Create - Variant Input Seller Sku
    Input Text    //*[@name="sellerSkuNumber"]    ${Attributes}[sku]

Create - Open Item Attributes Pop-up Window for Variations
    [Arguments]    ${index}=1
#    Wait Until Element Is Visible    //*[text()="Item Weight and Warning Attributes"]
    Click Element    (//table//p[text()="Update"])[${index}]
    Wait Until Element Is Visible    //p[text()="Select Attributes for Variations"]

Create - Close Item Attributes Pop-up Window for Variations
    [Arguments]    ${save}=${true}
    Run Keyword If    '${save}'=='${True}'    Click Element    //div[text()="Update Changes"]/parent::button
    Run Keyword If    '${save}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Select Attributes for Variations"]

Create - Input Item Attributes - Color Family
    Set Suite Variable    ${Attributes}    ${Single_Sku}[attributes]
    Wait Until Element Is Visible    //h1[text()="Shipping and Return"]
    Click Element    //select[@name="colorFamily"]
    Wait Until Element Is Visible    //option[text()="${Attributes}[color]"]
    Click Element    //option[text()="${Attributes}[color]"]
    Input Text    //*[@name="colorName"]    ${Attributes}[colorName]

Create&Update - Input Item Attributes - GTIN
    ${count}    Get Element Count    //Select[@name="globalTradeItemNumberType" and @disabled]
    IF    '${count}'=='0'
        Click Element    //Select[@name="globalTradeItemNumberType"]
        Wait Until Element Is Visible    //option[text()="${Attributes}[numberType]"]
        Click Element    //option[text()="${Attributes}[numberType]"]
        Clear Element Value    //input[@name="globalTradeItemNumber"]
        Input Text    //input[@name="globalTradeItemNumber"]     ${Attributes}[number]
    END

Create&Update - Set Shipping Policy
    Scroll Element Into View    //*[text()="Shipping Rate Table"]
    ${switch_name}   Create List    flammableContent    hazmatIndicator    giftingNote    restrictAKHIShip    groundShipOnly
    ${index}    Set Variable
    IF    '${Listing_Info}[shippingPolicy]'=='${True}'
        FOR    ${index}    IN RANGE    4    -1    -1
            ${text_one}    Get Text   //*[@name="${switch_name[${index}]}"]//following-sibling::span/p
            IF   "${text_one}"=="No"
                Click Element  //*[@name="${switch_name[${index}]}"]/parent::label
                Wait Until Element Is Visible    //*[@name="${switch_name[${index}]}"]//following-sibling::span/p[text()="Yes"]
            END
        END
    ELSE
        FOR    ${index}    IN RANGE    4
            ${text_one}    Get Text    //*[@name="${switch_name[${index}]}"]//following-sibling::span/p
            IF   "${text_one}"=="Yes"
                Click Element    //*[@name="${switch_name[${index}]}"]/parent::label
                Wait Until Element Is Visible    //*[@name="${switch_name[${index}]}"]//following-sibling::span/p[text()="No"]
            END
        END
    END

Create&Update - Override Shipping Rate
    Scroll Element Into View    //*[text()="Return Location"]
    ${text}    Get Text    //*[text()="Override Shipping Rate"]/following-sibling::label//p
    ${shipping_rate}    Set Variable    ${Listing_Info}[overShippingRate]
    IF    '${shipping_rate}[status]'=='${True}' and '${text}'=='No'
        Click Element    //*[@name="overrideShippingRate"]/parent::label
        Wait Until Element Is Visible    //*[@name="standardRate"]
        Input Text    //*[@name="standardRate"]    ${shipping_rate}[standard]
        IF   '${Listing_Info}[shippingPolicy]'=='${False}'
            Input Text    //*[@name="expeditedRate"]    ${shipping_rate}[expedited]
        END
    ELSE IF  '${shipping_rate}[status]'=='${True}' and '${text}'=='Yes'
        Clear Element Value    //*[@name="standardRate"]
        Input Text    //*[@name="standardRate"]    ${shipping_rate}[standard]
        IF   '${Listing_Info}[shippingPolicy]'=='${False}'
            Clear Element Value    //*[@name="expeditedRate"]
            Input Text    //*[@name="expeditedRate"]    ${shipping_rate}[expedited]
        END
    ELSE IF  '${shipping_rate}[status]'=='${False}' and '${text}'=='Yes'
        Click Element    //*[@name="overrideShippingRate"]/parent::label
    END
    Sleep    1

Create&Update - Set Return Policy
    Scroll Element Into View    //p[text()="Set a custom return policy for this item"]
    ${custom_return}    Set Variable    ${Listing_Info}[customReturn]
    ${text}    Get Text   //*[@name="overrideShippingReturnPolicy"]//following-sibling::span/p
    IF    '${custom_return}[status]'=='${True}' and '${text}'=='No'
        Click Element    //*[@name="overrideShippingReturnPolicy"]/parent::label
    END
    IF    '${custom_return}[status]'=='${True}'
        Scroll Element Into View    //h4[text()="60 Day Returns"]
        IF    '${custom_return}[returnPolicy]'=='1'
            Return Policy - Select By Index    1
        ELSE IF    '${custom_return}[returnPolicy]'=='2'
            Return Policy - Select By Index    2
            Return Policy - Buyer Item Need Return Setup    ${True}
        ELSE IF    '${custom_return}[returnPolicy]'=='3'
            Return Policy - Select By Index    2
            Return Policy - Buyer Item Need Return Setup    ${False}
        ELSE IF    '${custom_return}[returnPolicy]'=='4'
            Return Policy - Select By Index    3
            Return Policy - Buyer Item Need Return Setup    ${True}
        ELSE IF    '${custom_return}[returnPolicy]'=='5'
            Return Policy - Select By Index    3
            Return Policy - Buyer Item Need Return Setup    ${False}
        END
    END

Return Policy - Select By Index
    [Arguments]    ${index}
    Click Element    //div[@role="radiogroup"]/div/label[${index}]

Return Policy - Buyer Item Need Return Setup
    [Arguments]    ${need_return}=${True}
    ${return_item}    Get Text    //*[@name="refundOnly"]//following-sibling::span/p
    IF    '${need_return}'=='${True}' and '${return_item}'=='No'
        Click Element   //*[@name="refundOnly"]/parent::label
    ELSE IF  '${need_return}'=='${False}' and '${return_item}'=='Yes'
        Click Element   //*[@name="refundOnly"]/parent::label
    END

Create - Enter Listing Confirmation Page
    Scroll Element Into View    //div[text()="SAVE AND NEXT"]/parent::button
    Create - Click Save And Next     3

Create - Click Publish Campaign And Select Next Page
    [Arguments]    ${to_page}=1
    Wait Until Element Is Visible    //div[text()="Publish Listing"]/parent::button
    Sleep    1
    Scroll Element Into View    //div[text()="Publish Listing"]/parent::button
    Click Element    //div[text()="Publish Listing"]/parent::button
    Create&Update - Publish Confirmed    ${to_page}

Create&Update - Publish Confirmed
    [Arguments]    ${to_page}=1
    Listing - Check Toast Top    //p[text()="Your Listing Submission Is Confirmed"]
    Wait Until Element Is Visible    //p[text()="Your Listing Submission Is Confirmed"]
    IF    '${to_page}'!='1'
        Click Element    //div[text()="GO TO DASHBOARD"]/parent::button
        Wait Until Element Is Visible    //h1[starts-with(text(),"Welcome to your Dashboard")]
    ELSE
        Click Element    //div[text()="GO TO LISTING MANAGEMENT"]/parent::button
        Wait Until Element Is Visible    //h2[text()="Listing Management"]
    END
    Wait Loading Hidden

Create - Save Draft Confirmed
    [Arguments]    ${to_page}=1
    Wait Until Element Is Visible    //p[text()="It has been saved as a draft."]
    Run Keyword If    '${to_page}'!='1'    Click Element    //div[text()="GO TO DASHBOARD"]/parent::button
    Run Keyword If    '${to_page}'=='1'    Click Element    //div[text()="GO TO LISTING MANAGEMENT"]/parent::button
    Run Keyword If    '${to_page}'!='1'    Wait Until Element Is Visible    //h1[starts-with(text(),"Welcome to your Dashboard")]
    Run Keyword If    '${to_page}'=='1'    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Create - Stop Create Listing
    Execute Javascript    document.querySelectorAll("a")[1].click()

Listing - Enter Listing Detail Page By Index
    [Arguments]  ${index}=1
    Click Element    //table/tbody/tr[${index}]/td/button
    Sleep    2
    Wait Until Element Is Visible    //h1[text()="Listing Details"]

Listing - Get Listing Index By Variants Or Not
    [Arguments]    ${have_variants}=${False}
    ${count}    Get Element Count    //table//tbody/tr
    ${index}    Set Variable
    ${listing_index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${${count} + 1}
        ${inventory}    Get Text    //table//tbody//tr[${index}]//td[5]//p
        ${result}    Check Listing Have Variants    ${inventory}
        IF    '${have_variants}'=='${False}' and '${result}'=='${False}'
            ${listing_index}    Set Variable    ${index}
            Exit For Loop
        ELSE IF    '${have_variants}'=='${True}' and '${result}'=='${True}'
            ${listing_index}    Set Variable    ${index}
            Exit For Loop
        END
    END
    [Return]   ${listing_index}

Listing - Get Listing Info By Variants Or Not
    [Arguments]    ${have_variants}=${False}
    ${listing_index}    Listing - Get Listing Index By Variants Or Not    ${have_variants}
    ${title}    Get Text    //table//tbody/tr[${listing_index}]/td[3]//p
    ${Cur_Listing_Info}    Create Dictionary    title=${title}
    Set Suite Variable    ${Cur_Listing_Info}    ${Cur_Listing_Info}

Listing - Enter Listing Detail Page By Variants Or Not
    [Arguments]    ${have_variants}=${False}
    ${listing_index}    Listing - Get Listing Index By Variants Or Not    ${have_variants}
    Listing - Enter Listing Detail Page By Index    ${listing_index}

Update - Cancel Update Listing
    Wait Until Page Contains Element    //div[text()="Cancel"]/parent::button
    Scroll Element Into View    //div[text()="Cancel"]/parent::button
    Click Element    //div[text()="Cancel"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Update - Click Publish
    Scroll Element Into View    //div[text()="Publish"]/parent::button
    Click Element    //div[text()="Publish"]/parent::button

Update - Click Save Changes
    Scroll Element Into View    //div[text()="Save Changes"]/parent::button
    Click Element    //div[text()="Save Changes"]/parent::button
    IF    "${Catefory_Need_Update}"=="${True}"
        Create&Update - Publish Confirmed
    END
    Wait Until Element Is Visible    //h2[text()="Listing Management"]

Listing - Check Toast Top
    [Arguments]    ${expect_ele}
    FOR    ${i}    IN RANGE    ${TIME_OUT}
        Sleep    1
        ${toast_top_ele}    Set Variable    //*[@id="chakra-toast-manager-top"]
        ${toast_top_count}    Get Element Count    ${toast_top_ele}//p
        ${expect_ele_count}    Get Element Count    ${expect_ele}
        Exit For Loop If    ${expect_ele_count}==1
        IF    ${toast_top_count}==1
            Wait Until Element Is Visible    ${toast_top_ele}//p
            ${text}    Get Text    ${toast_top_ele}//p
            Capture Element Screenshot     ${toast_top_ele}//div     filename=EMBED
            Run Keyword And Ignore Error    Get Browser Console Log
            Fail    Fail, Error msg: ${text}
        END
    END


Update - Submission Confirmed Pop-up Windows
    Wait Until Element Is Visible    //p[text()="Your Listing Submission Is Confirmed"]
    Click Element    //div[text()="GO TO LISTING MANAGEMENT"]/parent::button

Update - Change Listing Title
    ${count}    Get Element Count    //*[text()="Variants Preview"]
    ${subTitles}    Get Json Value    ${Listing_Info}    subTitle
    ${sub_title}    Set Variable If    '${count}'=='0'   ${subTitles[0]}    ${subTitles[1]}
    Wait Until Element Is Visible    //*[@name="listingTitle"]
    Clear Element Value   //*[@name="listingTitle"]
    Input Text    //*[@name="listingTitle"]    ${Listing_Info}[title]${sub_title}

Update - Change Listing Category
    [Arguments]    ${is_update}=${True}
    ${count}    Get Element Count    //p[contains(text(),"Michaels shoppers will find your listing in all of these categories.")]/following-sibling::span
    ${categories}    Create List
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${${count}+1}
        ${category}     Get Text    //p[contains(text(),"Michaels shoppers will find your listing in all of these categories.")]/following-sibling::span[${index}]/span
        Append To List    ${categories}    ${category}
    END
    Click Element    //input[@name="category-search"]
    Wait Until Element Is Visible    //*[@name="category-search"]/parent::div/following-sibling::div//div[contains(@class,"category-item")]   ${MAX_TIME_OUT}
    Input Text    //input[@name="category-search"]    ${Listing_Info}[category]
    Sleep    1
    Click Element    //*[@name="category-search"]/parent::div/following-sibling::div//div[contains(@class,"category-item")]
    ${category_update}    Set Variable    ${True}
    ${item}    Set Variable
    FOR    ${item}    IN    @{categories}
        IF    '${item}'=='${Listing_Info}[category]'
            ${category_update}    Set Variable    ${False}
        END
    END
    IF    '${category_update}'=='${True}'
        Sleep    2
        ${count}    Get Element Count    //header[text()="Confirmation of Category Update"]
        IF    ${count}>0
            Wait Until Element Is Visible    //header[text()="Confirmation of Category Update"]
            Run Keyword If   '${is_update}'=='${True}'    Click Element   //div[text()="UPDATE CATEGORY"]/parent::button
            Run Keyword If   '${is_update}'=='${False}'    Click Element   //footer//div[text()="CANCEL"]/parent::button
        END
    END

Update - Change Seller Sku
    ${count}    Get Element Count    //*[@name="sellerSkuNumber" and @disabled]
    IF    '${count}'=='0'
        Clear Element Value    //*[@name="sellerSkuNumber"]
        Input Text    //*[@name="sellerSkuNumber"]    ${Attributes}[sku]
    END

Update - Change Barand Name And Manufacturer
    Clear Element Value    //*[@name="brandName"]
    Clear Element Value    //*[@name="manufactureName"]
    Create - Input Barand And Manufacturer

Update - Change Description
    Scroll Element Into View    //*[text()="Product Description"]
    Sleep   1
    Clear Element Value    //textarea[@name="description"]
    Input Text    //textarea[@name="description"]    ${Listing_Info}[description]

Update - Change Listing Tags
    Scroll Element Into View    //*[text()="Tags"]
    ${count}    Get Element Count    //*[starts-with(@aria-label,"Remove Tag")]
    Run Keyword If    '${count}'!='0'    Update - Remove All tags    ${count}
    Create - Input Listing Tags

Update - Remove All tags
    [Arguments]    ${count}=0
    ${count}    Get Element Count    //*[starts-with(@aria-label,"Remove Tag")]
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${count}
        Click Element    //*[starts-with(@aria-label,"Remove Tag")]
    END

Update - Change Date Range End
    ${endDate}    Set Variable    ${Listing_Info}[endDate]
    Scroll Element Into View    //*[text()="Listing Date Range"]
    IF    '${endDate}'=='${True}'
        Create&Update - Select Item Has No End Date
    ELSE
        Create&Update - Unselect Item Has No End Date
        Common - Select Date By Element   ${Listing_Info}[toDate]    //input[@name="availableTo"]
    END

Update - Change Price And Inverntory
    Scroll Element Into View    //*[text()="Pricing and Inventory"]
    ${count}    Get Element Count    //*[text()="Variants Preview"]
    IF    '${count}'=='0'
        Set Suite Variable    ${Single_Sku}    ${Listing_Info}[singleSku]
        Clear Element Value    //*[@name="price"]
        Input Text    //*[@name="price"]    ${Single_Sku}[price]
        Clear Element Value    //*[@name="quantity"]
        Input Text    //*[@name="quantity"]    ${Single_Sku}[quantity]
    ELSE
        Set Suite Variable    ${Variants}    ${Listing_Info}[variants]
        Create&Update - Set Variants Info    ${False}
        Create&Update - Select All To Update Variant Inventory And Price
        Create - Set One Variant Is Not Visible
    END

#
#Update - Change Subscription Setting
#    ${subscription}    Set Variable    ${Listing_Info}[subscription]
#    IF    '${subscription}[status]'!='${None}'
#        IF    '${subscription}[status]'=='${True}'
#            Create&Update - Set Item Have Subscription
#            Clear Element Value    //*[@name="percentOffOnPrice"]
#            Clear Element Value    //*[@name="percentOffOnRepeatDeliveries"]
#            Input Text    //*[@name="percentOffOnPrice"]    ${subscription}[firstOff]
#            Input Text    //*[@name="percentOffOnRepeatDeliveries"]    ${subscription}[repeatOff]
#        ELSE
#            Create&Update - Set Item Don't Have Subscription
#        END
#    END

#Create&Update - Set Item Have Subscription
#    ${text}    Get Text  //*[@id="subscription-discounts"]/parent::label/following-sibling::p
#    IF    "${text}"=="No"
#        Click Element    //*[@id="subscription-discounts"]/parent::label
#    END
#    Sleep    1
#    Page Should Contain Element    //*[@id="subscription-discounts"]/parent::label/following-sibling::p[text()="Yes"]

#Create&Update - Set Item Don't Have Subscription
#    ${text}    Get Text  //*[@id="subscription-discounts"]/parent::label/following-sibling::p
#    IF    "${text}"=="Yes"
#        Click Element    //*[@id="subscription-discounts"]/parent::label
#    END
#    Sleep    1
#    Page Should Contain Element    //*[@id="subscription-discounts"]/parent::label/following-sibling::p[text()="No"]

Update - Upload Photos
    Scroll Element Into View    //*[text()="Video"]
    ${count}    Get Element Count    //img[@alt="uploaded"]
    IF    '${count}'=='0'
        ${photos}    Get Json Value    ${Listing_Info}    photos
        ${item}    Set Variable
        FOR    ${item}    IN    @{photos}
            ${count}    Get Element Count    //img[@alt="uploaded"]
            ${new_count}    Evaluate    ${count}+1
            Choose File    Xpath=//*[@id="upload-photo"]    ${item}
            Wait Until Element Is Visible    (//img[@alt="uploaded"])[${new_count}]
        END
    END
    Sleep    1

Update - Change Items Attributes Info
    Scroll Element Into View    //p[text()="Is the item ground shipping only?"]
    ${count}    Get Element Count    //select[@name="colorFamily"]
    IF    '${count}'=='1'
        Update - Change Color Family
        Create&Update - Input Item Attributes - GTIN
        Create&Update - Input Item Volume
    ELSE
        Update - Update Variant Items Attributes
    END

Update - Update Variant Items Attributes
    ${variant_attributes}    Get Json Value    ${Variants}    attributes
    Set Suite Variable    ${Volumes}    ${Variants}[volumes]
    ${update_count}    Get Element Count    //table//p[text()="Update"]
    ${index}    Set Variable
    FOR    ${index}    IN RANGE   ${update_count}
        Set Suite Variable    ${Attributes}    ${variant_attributes[${index}]}
        ${update_index}    Evaluate    ${index}+1
        Create - Open Item Attributes Pop-up Window for Variations    ${update_index}
        Create&Update - Input Item Attributes - GTIN
        Update - Variant Input Seller Sku
        Create&Update - Input Item Volume    ${True}
        Create - Close Item Attributes Pop-up Window For Variations
        Sleep    0.5
    END

Update - Variant Input Seller Sku
    ${ele}    Set Variable  //p[text()="Select Attributes for Variations"]/../following-sibling::div
    ${count}    Get Element Count    ${ele}//input[@name="sellerSkuNumber" and @disabled\]
    IF   '${count}'=='0'
        Clear Element Value    ${ele}//input\[@name="sellerSkuNumber"\]
        Input Text    ${ele}//input\[@name="sellerSkuNumber"\]   ${Attributes}[sku]
    END

Update - Change Color Family
    Set Suite Variable    ${Attributes}    ${Single_Sku}[attributes]
    Scroll Element Into View    //*[text()="Item Weight and Warning Attributes"]
    Click Element    //select[@name="colorFamily"]
    Click Element    //option[text()="${Attributes}[color]"]
    Clear Element Value    //*[@name="colorName"]
    Input Text    //*[@name="colorName"]    ${Attributes}[colorName]

Create&Update - Input Item Volume
    [Arguments]    ${is_variant}=${False}
    IF   '${is_variant}'=='${False}'
        ${Volumes}    Get Json Value    ${Listing_Info}    singleSku    volumes
    END
    Clear Element Value    //input[@name="length"]
    Clear Element Value    //input[@name="width"]
    Clear Element Value    //input[@name="height"]
    Clear Element Value    //input[@name="weight"]
    Input Text    //input[@name="length"]     ${Volumes[0]}
    Input Text    //input[@name="width"]     ${Volumes[1]}
    Input Text    //input[@name="height"]     ${Volumes[2]}
    Input Text    //input[@name="weight"]     ${Volumes[3]}
    Sleep    1
    ${volume}    Get Value     //*[@name="volume"]
    Run Keyword And Ignore Error    Should Be Equal As Numbers    ${volume}    ${Volumes[4]}

Listing - Filter - Clear All Filter
    Listing - Filter - Open Filter
    Listing - Filter - View Results

Listing - Filter Listing By API And Go To Edit Page
    [Arguments]    ${status}    ${variant_number}=1    ${have_variants}=${False}    ${location}=3
    Set Suite Variable     ${Variant_Quantity}    ${variant_number}
    ${Listing_Info}    Get Listing Body    ${False}    ${True}    ${Variant_Quantity}
    Set Suite Variable    ${Listing_Info}    ${Listing_Info}
    ${filter_listing_info}    API - Get Listing Info By Status And Variants    ${status}    ${have_variants}    ${location}
    Go To    ${URL_MIK}/mp/seller/edit-listing/${filter_listing_info}[sku]
    Log    EA_Report_Data=${filter_listing_info}[sku]
    Wait Until Element Is Visible    //*[@name="listingTitle"]
    ${need_update}    ${new_category}    Listing - Check Listing Category Is Need Update    ${filter_listing_info}[category]
    Set Suite Variable    ${Catefory_Need_Update}    ${need_update}

Listing - Filter - Search Listing By Status Single
    [Documentation]    status list: Prohibited,Pending Review,Out of stock,Archived,Active,Draft,Inactive,Suspended
    [Arguments]    ${status}=Draft
    Listing - Filter - Open Filter
    Listing - Filter - Show Following Element By Text    Listing Status    ${True}
    ${listing_number}    Get Text    //p[text()="${status}"]/following-sibling::p
    Click Element    //p[text()="${status}"]/../../parent::label[starts-with(@class,"chakra-checkbox")]
    Listing - Filter - View Results
    [Return]    ${listing_number}

Listing - Close All Tips
    ${table-x-ele}   Set Variable   //div[contains(@style,"display: block;")]//button//*[contains(@class,"icon-tabler-x")]/parent::button
    ${count}    Get Element Count   ${table-x-ele}
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    ${count}
        Run Keyword And Ignore Error    Click Element    ${table-x-ele}
        Sleep    0.5
    END

Listing - Filter - Open Filter
    [Arguments]    ${remove_tips}=${True}
    Scroll Element Into View    //h2[text()="Listing Management"]
    Run Keyword If    "${remove_tips}"=="${True}"    Listing - Close All Tips
    Click Element    ${Filter_Btn_Ele1}
    Wait Until Element Is Visible    ${Filter_View_Results}
    Click Element    ${Filter_Clear_All}
    Sleep    0.5

Listing - Filter - View Results
    Sleep    0.5
    Click Element    ${Filter_View_Results}
    Wait Until Element Is Not Visible     ${Filter_View_Results}
    Sleep    0.5

Listing - Filter - Search Listing By Status List
    [Documentation]    status list: Prohibited,Pending Review,Out of stock,Archived,Active,Draft,Inactive,Suspended
    [Arguments]    ${status}=Draft
    Listing - Filter - Open Filter
    Listing - Filter - Show Following Element By Text    Listing Status    ${True}
    ${listing_number}    Set Variable     0
    ${item}    Set Variable
    FOR    ${item}    IN    @{status}
        ${number}    Get Text    //p[text()="${item}"]/following-sibling::p
        Click Element    //p[text()="${item}"]/../../parent::label[starts-with(@class,"chakra-checkbox")]
        ${listing_number}    Evaluate    ${listing_number}+${number}
    END
    Listing - Filter - View Results
    [Return]    ${listing_number}

Listing - Get Results Total Number
    Sleep    0.5
    ${result_ele}    Set Variable    //table/../following-sibling::div//p
    Wait Until Page Contains Element    ${result_ele}
    ${count}    Get Element Count    ${result_ele}
    IF    ${count}>0
        ${result}    Get Text    ${result_ele}
        ${listing_total}    Evaluate    '${result}'.split(" ")\[2\]
        Set Suite Variable    ${Cur_Listing_Total}    ${listing_total}
    END

Listing - Check Page Tips
    ${count}    Get Element Count    //p[text()="Low Inventory"]
    IF    ${count}==1
        Element Should Be Visible    //p[text()="The inventory of your items is low. Please verify or update your inventory."]
        Click Element    //div[text()="REVIEW LISTING"]/parent::button
        Sleep    1
        Click Element    //p[text()="Low Inventory"]//following-sibling::button
        Wait Until Element Is Not Visible    //p[text()="Low Inventory"]
        Listing - Filter - Open Filter    ${False}
        ${status_total}    Get Text    //p[text()="Out of stock"]/following-sibling::p
        Should Not Be Equal As Strings    ${status_total}    0
        Listing - Filter - View Results
    END
    ${count}    Get Element Count    //p[text()="Your listing has been deactivated due to [inappropriate content]."]
    IF    ${count}==1
        Click Element    //p[text()="Please contact Michaels Management Team if you have more questions."]//button/div[text()="REVIEW LISTING"]
        Sleep    1
        Wait Until Element Is Visible    //table//tbody/tr[1]/td//p[text()="Prohibited"]
        Click Element    //p[text()="Your listing has been deactivated due to [inappropriate content]."]//following-sibling::button
        Element Should Not Be Visible     //p[text()="Please contact Michaels Management Team if you have more questions."]
        Listing - Filter - Open Filter    ${False}
        ${status_total}    Get Text    //p[text()="Prohibited"]/following-sibling::p
        Should Not Be Equal As Strings    ${status_total}    0
        Listing - Filter - View Results
    END

Listing - Filter - Search Listing By Status And Check Result
    [Arguments]    ${quantity}=1    ${check_order_quantity}=${True}
    Listing - Filter - Open Filter
    Listing - Filter - Show Following Element By Text    Listing Status    ${True}
    ${item}    Set Variable
    ${count}    Get Element Count    (//div[@role="dialog"]//div[@role="region"])[1]//label[@disabled]
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    ${disabled_status}    Create List
    FOR    ${index}     IN RANGE    1    ${count}
        ${dis_sts}    Get Value    ((//div[@role="dialog"]//div[@role="region"])[1]//label[@disabled]/input)[${index}]
        Append To List    ${disabled_status}    ${dis_sts}
    END
    ${status}    Get Listing Status By Number    ${disabled_status}    ${quantity}
    ${listing_number}    Set Variable     0
    FOR    ${item}    IN    @{status}
        ${number}    Get Text    //p[text()="${item}"]/following-sibling::p
        Click Element    //p[text()="${item}"]/../../parent::label[starts-with(@class,"chakra-checkbox")]
        ${listing_number}    Evaluate    ${listing_number}+${number}
    END
    Listing - Filter - View Results
    IF    "${check_order_quantity}"=="${True}"
        Listing - Get Results Total Number
        IF   '${Cur_Listing_Total}'!='${listing_number}'
            Fail    ${status}, Filter=${listing_number},Results=${Cur_Listing_Total}
        END
    END
    [Return]    ${status}

Listing - Filter - Search Listing By Inventory Range
    [Arguments]    ${min}=100    ${max}=300
    Listing - Filter - Open Filter
    Listing - Filter - Show Following Element By Text    Listing Status    ${False}
    Listing - Filter - Show Following Element By Text    Inventory Range    ${True}
    Input Text    //p[text()="Minimum Inventory"]/following-sibling::input    ${min}
    Input Text    //p[text()="Maximum Inventory"]/following-sibling::input    ${max}
    Listing - Filter - View Results

Listing - Filter - Search Listing By Primary Categories
    [Arguments]    ${quantity}=1
    Listing - Filter - Open Filter
    Listing - Filter - Show Following Element By Text    Listing Status    ${False}
    Listing - Filter - Show Following Element By Text    Inventory Range    ${False}
    Listing - Filter - Show Following Element By Text    Primary Categories    ${True}
    ${base_ele}    Set Variable     (//div[@role="dialog"]//div[@role="region"])[3]//label
    ${count}    Get Element Count    ${base_ele}
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    ${categories}    Create List
    FOR    ${index}     IN RANGE    1    ${count}
        ${category}    Get Value    (${base_ele}/input)\[${index}\]
        Append To List    ${categories}    ${category}
    END
    ${cate_length}    Get Length    ${categories}
    IF   ${quantity}>${cate_length}
        ${quantity}    Set Variable  ${cate_length}
    END
    ${search_categories}    Evaluate    random.sample(${categories},${quantity})
    ${item}   Set Variable
    ${listing_number}    Set Variable
    FOR    ${item}    IN    @{search_categories}
        ${number}    Get Text    //p[text()="${item}"]/following-sibling::p
        Click Element    //p[text()="${item}"]/../../parent::label[starts-with(@class,"chakra-checkbox")]
        ${listing_number}    Evaluate    ${listing_number}+${number}
    END
    Listing - Filter - View Results
    Listing - Get Results Total Number
    IF   '${Cur_Listing_Total}'!='${listing_number}'
        Fail    ${search_categories}, Filter=${listing_number},Results=${Cur_Listing_Total}
    END
    [Return]    ${search_categories}

Listing - Filter - Check Search Primary Categories Result
    [Arguments]    ${quantity}=1
    ${search_categories}    Listing - Filter - Search Listing By Primary Categories    ${quantity}
    ${count}    Get Element Count    //table//tbody/tr
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    ${page_categories}    Create List
    FOR    ${index}    IN RANGE    1    ${count}
        Wait Until Element Is Enabled    //table//tbody//tr[${index}]//td[3]//p
        ${category}    Get Text    //table//tbody//tr[${index}]//td[6]//p
        Append To List    ${page_categories}    ${category}
    END
    ${item}    Set Variable
    FOR    ${item}    IN    @{page_categories}
        ${cate}    Evaluate    '${item}'.split("/")\[0\]
        List Should Contain Value     ${search_categories}    ${cate}
    END

Listing - Filter - Check Search Inventory Range Result
    [Arguments]    ${min}=100    ${max}=300
    Listing - Filter - Search Listing By Inventory Range    ${min}    ${max}
    ${count}    Get Element Count    //table//tbody/tr
    Pass Execution If     ${count}==0    There are no order in inventory range ${min} to ${max}
    ${count}    Evaluate    ${count}+1
    ${index}    Set Variable
    ${inventorys}    Create List
    FOR    ${index}    IN RANGE    1    ${count}
        Wait Until Element Is Enabled    //table//tbody//tr[${index}]//td[3]//p
        ${inventory}    Get Text    //table//tbody//tr[${index}]//td[5]//p
        Append To List    ${inventorys}    ${inventory}
    END
    ${item}    Set Variable
    FOR    ${item}    IN    @{inventorys}
        IF    ${min}==0 and ${max}==0
            Should Be Equal As Strings    ${item}    Out of stock
        ELSE
            IF    ${min}==0
                ${result}    Check Inventory Value Equal    ${item}    Out of stock
                IF    '${result}'=='${True}'
                    Continue For Loop
                ELSE
                    ${invent}    Get Listing Inventory    ${item}
                    IF  ${invent}<${min} or ${invent}>${max}
                        Fail    ${invent} not in range ${min} to ${max}.
                    END
                END
            END
        END
    END

Listing - Filter - Show Following Element By Text
    [Arguments]    ${text}=Listing Status    ${show}=${True}
    ${count}    Get Element Count      //button[text()="${text}" and @aria-expanded="true"]
    IF    '${show}'=='${True}' and ${count}==0
        Click Element    //button[text()="${text}"]
        Wait Until Element Is Visible    //button[text()="${text}"]/following-sibling::div
    ELSE IF  '${show}'=='${False}' and ${count}==1
        Click Element    //button[text()="${text}"]
        Wait Until Element Is Not Visible    //button[text()="${text}"]/following-sibling::div
    END
    Sleep    1

Listing - Save Active Listings Info To File
    [Arguments]    ${status}=Active
    IF    '${status}'=='Active'
        Sleep    0.5
        ${count}    Get Element Count    //td//p[text()="Active"]
        ${count}    Evaluate    ${count}+1
        ${index}    Set Variable
        ${listings}    Create List
        FOR    ${index}    IN RANGE    1    ${count}
            Wait Until Element Is Enabled    //table//tbody//tr[${index}]//td[3]//p
            ${title}    Get Text    //table//tbody//tr[${index}]//td[3]//p
            ${inventory}    Get Text    //table//tbody//tr[${index}]//td[5]//p
            ${listing}    Create Dictionary    title=${title}     inventory=${inventory}
            Append To List    ${listings}    ${listing}
        END
        Save File    active_listings    ${listings}    MP    ${ENV}
    END

Listing - Set Listing Selected By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Enabled    //table//tbody//tr[${index}]//td[1]//*
    ${count}    Get Element Count    //table//tbody//tr[1]//td[1]//*[contains(@class,"icon-tabler-square-check")]
    Run Keyword If    '${count}'=='0'    Click Element    //table//tbody//tr[${index}]//td[1]//*
    ${Selected_Item_Name}    Get Text    //table//tbody//tr[${index}]//td[3]//p
    Set Suite Variable    ${Selected_Item_Name}    ${Selected_Item_Name}

Listing - Set Listing Selected By Status And Index
    [Arguments]    ${status}    ${index}=1
    ${page_index}   Set Variable
    ${listing_selected}    Set Variable    ${False}
    FOR    ${page_index}   IN RANGE    10
        ${count}    Get Element Count    (//p[text()="${status}"])[${index}]/../preceding-sibling::td
        IF    ${count}>0
            Click Element    (//p[text()="${status}"])[${index}]/../preceding-sibling::td
            ${Selected_Item_Name}    Get Text    ((//p[text()="${status}"])[${index}]/../preceding-sibling::td)[3]//p
            Set Suite Variable    ${Selected_Item_Name}    ${Selected_Item_Name}
            ${listing_selected}    Set Variable    ${True}
            Exit For Loop
        END
        ${count}    Get Element Count    //div[@aria-label="Next Page" and @disabled]
        Exit For Loop If    ${count}==1
        Scroll Element Into View    //div[@aria-label="Next Page"]
        Click Element    //div[@aria-label="Next Page"]
        Sleep    1
    END
    IF    "${listing_selected}"=="${False}"
        Skip    There are no ${status} listings can do test.
    END

Listing - Set Multiple Listings Selected By Status
    [Arguments]    ${status}    ${quantity}=1
    ${index}    Set Variable
    ${count}    Get Element Count    //div[@aria-label="Page 1 active"]
    IF    "${count}"=="0"
        Click Element    //div[@id="page-1"]
        Scroll Element Into View    //h2[text()="Listing Management"]
        Sleep    1
    END
    FOR    ${index}    IN RANGE    1    ${${quantity}+1}
        Listing - Set Listing Selected By Status And Index    ${status}    ${index}
        Sleep    1
    END

Listing - Set The Last Listing Selected On Page
    ${count}    Get Element Count    //table//tbody//tr

Listing - Search Lisitng By Search Value
    [Arguments]    ${search_key}
    Clear Element Value    //input[@title="search-materials"]
    Input Text    //input[@title="search-materials"]    ${search_key}
    Press Keys    //input[@title="search-materials"]    RETURN
    Sleep    0.5
    Wait Until Page Does Not Contain Element    //input[@title="search-materials" and @disabled]
    Sleep    1
    Clear Element Value    //input[@title="search-materials"]

Listing - Check Listing Status By Title
    [Arguments]    @{status}
    Sleep    1
    Listing - Filter - Clear All Filter
    Listing - Search Lisitng By Search Value    ${Selected_Item_Name}
    Wait Loading Hidden
    Wait Until Element Is Visible    //p[text()="${Selected_Item_Name}"]/../../../following-sibling::td
    ${now_status}    Get Text    //p[text()="${Selected_Item_Name}"]/../../../following-sibling::td/p
    ${inventory}    Get Text    //p[text()="${Selected_Item_Name}"]/../../../following-sibling::td[2]/p
    ${inventory}    Get Listing Inventory    ${inventory}
    IF    "${inventory}"=="0" and "${status}[0]"=="Active"
        Should Be Equal As Strings    ${now_status}    Out of stock
    ELSE IF   '${now_status}'!='Pending Review'
        List Should Contain Value    ${status}    ${now_status}
    END

Listing - Check Listing Status After Import
    [Arguments]    ${listing_data}    ${status}
    FOR    ${item}    IN    @{listing_data}
        IF    "${item}[sku_type]"=="Parent" or "${item}[sku_type]"=="Standalone"
            ${title}    Set Variable    ${item}[item_name]
            Listing - Search Lisitng By Search Value    ${title}
            Wait Loading Hidden
            Wait Until Element Is Visible    //p[text()="${title}"]/../../../following-sibling::td
            ${now_status}    Get Text    //p[text()="${title}"]/../../../following-sibling::td/p
            IF   '${now_status}'!='Pending Review'
                IF    "${status}"!="${now_status}"
                    Fail    Fail, expect status ${status} != ${now_status}.
                END
            END
        END
    END

Listing - Check Listing Detail Is Update After Import
    [Arguments]      ${listing_data}
    ${sku_number}    Get Json Value    ${listing_data}    sku_number
    IF    "${sku_number}"!="${NULL}"
        ${listing_detail}    API - Get Listing Detail By Sku Number    ${sku_number}
        ${results}    ${msg}    Check Listing Detail Is Update After Import    ${listing_data}    ${listing_detail}
        IF    '${results}'=='${False}'
            Fail    ${msg}
        END
    END

Listing - Delete Lisitng After Selected Item
    [Arguments]    ${is_sure}=${True}
    Wait Until Page Contains Element    //*[contains(@class,"icon-tabler-trash")]/parent::button
    Scroll Element Into View    //*[contains(@class,"icon-tabler-trash")]/parent::button
    Click Element    //*[contains(@class,"icon-tabler-trash")]/parent::button
    Wait Until Element Is Visible    //p[text()="Confirmation of listing deletion"]
    IF    '${is_sure}'=='${True}'
        Click Element    //div[text()="CONTINUE"]/parent::button
    ELSE
        Click Element    //div[text()="CANCEL"]/parent::button
    END
    Sleep    1

Listing - Deactivate Listing After Seleted Active Item
    [Arguments]    ${selected_quantity}=1
    Wait Until Page Contains Element    //*[contains(@class,"icon-tabler-ban")]/parent::button
    Scroll Element Into View    //*[contains(@class,"icon-tabler-ban")]/parent::button
    IF    '${selected_quantity}'=='1'
        Element Should Be Visible    //*[contains(@class,"icon-tabler-edit")]/parent::button
    END
    Click Element    //*[contains(@class,"icon-tabler-ban")]/parent::button
    Sleep    3

Listing - Recover Listing After Selected Archived Item
    Wait Until Page Contains Element    //*[contains(@class,"icon-tabler-rotate-clockwise")]/parent::button
    Scroll Element Into View    //*[contains(@class,"icon-tabler-rotate-clockwise")]/parent::button
    Scroll Element Into View     //*[contains(@class,"icon-tabler-rotate-clockwise")]/parent::button
    Click Element    //*[contains(@class,"icon-tabler-rotate-clockwise")]/parent::button
    Sleep    3

Listing - Relist Listing After Selected Inactive Item
    [Arguments]    ${is_sure}=${True}
    Wait Until Page Contains Element    //*[contains(@class,"icon-tabler-notes")]/parent::button
    Scroll Element Into View    //*[contains(@class,"icon-tabler-notes")]/parent::button
    Click Element    //*[contains(@class,"icon-tabler-notes")]/parent::button
    Wait Until Element Is Visible    //p[text()="Confirmation of listing relist"]
    ${abFrom}    Get Current Date     result_format=%Y-%m-%d
    ${abTo}    Add Time To Date     ${abFrom}    21 days    result_format=%Y-%m-%d
    Common - Select Date By Element    ${abFrom}    //input[@id="startDate"]
    Common - Select Date By Element    ${abTo}      //input[@id="endDate"]
    Run Keyword If    '${is_sure}'=='${True}'    Click Element    //div[text()="CONTINUE"]/parent::button
    Run Keyword If    '${is_sure}'=='${False}'    Click Element    //div[text()="CANCEL"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="CONTINUE"]/parent::button

Listing - Export Listing After Selected Item
    Remove Download File If Existed    listings.xlsx    ${False}    ${Custom_Chrome_Download_Path}
    Wait Until Element Is Visible    //*[contains(@class,"icon-tabler-file-export")]/parent::button
    Click Element    //*[contains(@class,"icon-tabler-file-export")]/parent::button
    ${results}    ${file_path}    Wait Until File Download    listings.xlsx    ${TIME_OUT}    ${False}    ${Custom_Chrome_Download_Path}
    IF    "${results}"=="${False}"
        Fail    Fail to export file listings.xlsx.
    END

Listing - Check Download File Info After Selected Listing
    ${file_info}    Read Download Excel    listings.xlsx
    ${header_info}    Set Variable    ${file_info[0]}
    ${header_len}    Get Length    ${header_info}
    ${tbody_info}    Set Variable    ${file_info[1:]}
    ${start_index}    Set Variable    2
    ${tbody_len}    Get Length    ${tbody_info}
    ${index}   Set Variable
    FOR    ${index}    IN RANGE    ${header_len}
         Run Keyword And Ignore Error   Table Header Should Contain    //table    ${header_info[${index}]}
    END
    ${line_index}    Set Variable
    FOR    ${line_index}    IN RANGE    ${tbody_len}
        ${tbody}   Set Variable    ${tbody_info[${line_index}]}
        Listing - Search Lisitng By Search Value    ${tbody[1]}
        Page Should Contain Element     //table/tbody/tr[1]/td[2]//img[@src="${tbody[0]}"]
        FOR    ${index}    IN RANGE    1     4
            ${text_index}   Evaluate    ${index}+${start_index}
            ${text}   Get Text    //table/tbody/tr[1]/td[${text_index}]//p
            Run Keyword And Ignore Error    Should Be Equal As Strings    ${text}    ${tbody[${index}]}
        END

    END

Listing Detail - Shipping Rate Switch Check - Hazardous
    Scroll Element Into View    //p[text()="Is the item ground shipping only?"]
    ${text}    Get Text    //*[@name="hazmatIndicator"]/following-sibling::span/p
    IF    '${text}'=='No'
        Click Element    //*[@name="hazmatIndicator"]/parent::label
        Wait Until Element Is Visible    //*[@name="groundShipOnly"]/parent::label[@data-disabled]
        Scroll Element Into View    //*[text()="Return Location"]
        ${over_text}    Get Text    //*[@name="overrideShippingRate"]/following-sibling::span/p
        IF    '${over_text}'=='No'
            Click Element    //*[@name="overrideShippingRate"]/parent::label
        END
        Wait Until Element Is Visible    //*[@name="freeStandardShipping"]/parent::label[@data-disabled]
        Page Should Contain Element    //*[@name="expeditedRate" and @disabled]
        Page Should Contain Element    //*[@name="ltlFreightRate" and @disabled]
    END

Listing Detail - Shipping Rate Switch Check - Free Standard
    ${text}    Get Text    //input[@name="hazmatIndicator"]/following-sibling::span/p
    IF    '${text}'=='Yes'
        Click Element    //input[@name="hazmatIndicator"]/parent::label
    END
    ${over_text}    Get Text    //*[@name="overrideShippingRate"]/following-sibling::span/p
    IF    '${over_text}'=='No'
        Click Element    //*[@name="overrideShippingRate"]/parent::label
    END
    Wait Until Element Is Visible    //*[@name="freeStandardShipping"]/parent::label
    Click Element    //*[@name="freeStandardShipping"]/parent::label
    Wait Until Element Is Visible    //*[@name="hazmatIndicator"]/parent::label[@data-disabled]
    Page Should Contain Element    //*[@name="standardRate" and @disabled]
    Page Should Contain Element    //*[@name="ltlFreightRate" and @disabled]

Listing - Variant Type - Check Variant Type Value
    Listing - Variant Type - Select Category    Crafts & Hobbies
    ${mapping_value}    Get Mapping Values
    Save File    mapping_value    ${mapping_value}    MP    ${ENV}
    ${page_mapping_value}    Create Dictionary
    Listing - Variant Type - Remove Added Variations
    ${item}    Set Variable
    FOR    ${item}    IN     @{mapping_value.keys()}
        ${type_values}    Listing - Variant Type - Get Variant Type Value    ${item}
        Set To Dictionary    ${page_mapping_value}    ${item}=${type_values}
        Click Element    //footer//div[text()="CANCEL"]/parent::button
        Listing - Variant Type - Remove Added Variations    ${False}
    END
    ${page_mapping_value_list}    Create List    ${page_mapping_value}
    Save File    page_mapping_value    ${page_mapping_value_list}    MP    ${ENV}
    ${result}    Comparison Variant Type Value Results    ${ENV}
    Run Keyword If    '${result}'=='${False}'    Fail    Please check the result on VariantTypeCheckValueResults.xlsx

Listing - Variant Type - Check Category Variant Type
    ${categories}    Get Par Category Info
    Save File    categories    ${categories}    MP    ${ENV}
    ${cate_mapping}    Get Cate Mapping Info
    Save File    cate_mapping    ${cate_mapping}    MP    ${ENV}
    ${page_cate_mapping}    Create Dictionary
    ${item}    Set Variable
    FOR    ${item}    IN    @{categories}
        Listing - Variant Type - Select Category    ${item}
        Listing - Variant Type - Remove Added Variations
        ${variant_types}    Listing - Variant Type - Get Variant Type
        Set To Dictionary    ${page_cate_mapping}    ${item}=${variant_types}
        Click Element    //footer//div[text()="CANCEL"]/parent::button
    END
    ${page_cate_mapping_list}    Create List    ${page_cate_mapping}
    Save File    page_cate_mapping    ${page_cate_mapping_list}    MP    ${ENV}
    ${result}    Comparison Variant Type Results    ${ENV}
    Run Keyword If    '${result}'=='${False}'    Fail    Please check the result on VariantTypeCheckResults.xlsx

Listing - Variant Type - Select Category
    [Arguments]    ${category}
    Scroll Element Into View    //input[@name="category-search"]
    Click Element    //input[@name="category-search"]
    Input Text    //input[@name="category-search"]    ${category}
    Wait Until Element Is Visible    //*[@name="category-search"]/parent::div/following-sibling::div/div
#    Click Element    //input[@name="category-search"]/parent::div/following-sibling::div/div
    Click Element    //input[@name="category-search"]/parent::div/following-sibling::div/div/div/div/p[2][starts-with(text(),"${category}")]/../..
    Wait Until Element Is Visible    //header[text()="Confirmation of Category Update"]
    Click Element   //div[text()="UPDATE CATEGORY"]/parent::button
    Sleep   0.5

Listing - Variant Type - Remove Added Variations
    [Arguments]    ${scroll}=${True}
    ${add_variations_count}    Get Element Count    //p[contains(text(),"Add Variations")]
    IF    ${add_variations_count}==0
        IF   '${scroll}'=='${True}'
            Scroll Element Into View    //div[text()="Edit Variants"]/parent::button
        END
        Click Element    //div[text()="Edit Variants"]/parent::button
        Wait Until Element Is Visible    //p[contains(text(),"Add Variations")]
    END
    ${count}    Get Element Count    //p[text()="Remove"]/parent::button
    ${index}   Set Variable
    ${count}    Evaluate     ${count}+1
    FOR    ${index}    IN RANGE    1    ${count}
        Click Element    //p[text()="Remove"]/parent::button
        Sleep    0.5
        ${count}    Get Element Count    //p[text()="We will empty the table!"]
        IF    '${count}'!='0'
            Click Element    //div[text()="Continue"]/parent::button
            Wait Until Element Is Not Visible    //p[text()="We will empty the table!"]
        END
    END
    Wait Until Element Is Not Visible    //p[text()="Remove"]/parent::button
    Sleep    0.5

Listing - Variant Type - Get Variant Type
    ${variant_types}    Create List
    ${option_ele}    Set Variable    (//option[text()="Select variant type"]/following-sibling::option)
    ${count}    Get Element Count    ${option_ele}
    ${index}   Set Variable
    ${count}    Evaluate     ${count}+1
    FOR    ${index}   IN RANGE    1    ${count}
        ${ele_value}    Get Value    ${option_ele}\[${index}\]
        Append To List    ${variant_types}    ${ele_value}
    END
    [Return]    ${variant_types}

Listing - Variant Type - Get Variant Type Value
    [Arguments]    ${variant_type}
    ${type_values}    Create List
    Select From List By Value    //option[text()="Select variant type"]/parent::select    ${variant_type}
    ${select_ele}    Set Variable    //*[@placeholder="Please select options"]
    Wait Until Element Is Visible    //p[text()="Remove"]/parent::button
    ${count}    Get Element Count    ${select_ele}
    IF    '${count}'!='0'
        Click Element    ${select_ele}
        Wait Until Element Is Visible    //div[@role="rowgroup"]//label//p
        ${label_ele}    Set Variable    (//div[@role="rowgroup"]//label//p)
        ${label_count}    Get Element Count    ${label_ele}
        ${index}   Set Variable
        ${label_count}    Evaluate     ${label_count}+1
        FOR    ${index}   IN RANGE    1    ${label_count}
            ${ele_value}    Get Text   ${label_ele}\[${index}\]
            Append To List    ${type_values}    ${ele_value}
        END
        Click Element    ${select_ele}
    END
    [Return]    ${type_values}


Listing - Check Listing Save Draft Success
    Listing - Filter - Clear All Filter
    Listing - Filter - Search Listing By Status Single    Draft
    Listing - Search Lisitng By Search Value    ${Listing_Info}[title]

Listing - Check Listing Publish Success
    [Arguments]    ${expect_status}=${None}
    Listing - Filter - Clear All Filter
    Listing - Search Lisitng By Search Value    ${Listing_Info}[title]
    ${status}     Get Text    //table//tbody//tr//td[4]//p
    IF    "${expect_status}"!="${None}"
        Should Be Equal As Strings    ${status}    ${expect_status}
    ELSE
        ${pub_status}    Create List      Pending Review    Active
        List Should Contain Value    ${pub_status}    ${status}
    END


Flow - Create - Step 1
    [Arguments]    ${add_from_days}=0
    Create - Input Listing Title
    Create - Select Listing Category
    Create - Input Seller Sku
    Create - Input Barand And Manufacturer
    Create&Update - Select Optional Info
    Create - Input Description
    Create - Input Listing Tags
    Create - Input Date Range - Availabel    ${add_from_days}

Flow - Create - Step 2 - No Variants
    Create - Upload Photos
    Create - Input Price And Quantity
#    Create - Subscription Setting
    Create - Wait Photos Uploaded For Single Sku

Flow - Create - Step 2 - Have Variants
    Create - Upload Photos
    Create&Update - Set Variants Info
    Create&Update - Loop Upload Photos To Vaiantions
    Create - Input Variant Inventory And Price
    Create&Update - Select All To Update Variant Inventory And Price
    Create - Set One Variant Is Not Visible
#    Create - Subscription Setting

Flow - Create - Step 3 - No Variants
    Create - Input Item Attributes - Color Family
    Create&Update - Input Item Attributes - GTIN
    Create&Update - Input Item Volume
    Create&Update - Set Shipping Policy
    Create&Update - Override Shipping Rate
    Create&Update - Set Return Policy

Flow - Create - Step 3 - Have Variants
    Create - Update Variant Items Attributes
    Create&Update - Set Shipping Policy
    Create&Update - Override Shipping Rate
    Create&Update - Set Return Policy

Flow - Create Listing - Have Variants
    Listing - Click Create A Listing Button
    Flow - Create - Step 1
    Create - Click Save And Next
    Create - Upload Photos
    Flow - Create - Step 2 - Have Variants
    Create - Click Save And Next    2
    Flow - Create - Step 3 - Have Variants
    Create - Enter Listing Confirmation Page
    Create - Click Publish Campaign And Select Next Page

Flow - Update Listing - Update All Information
    Update - Change Listing Title
    Update - Change Listing Category
    Update - Change Description
    Create&Update - Select Item Has No End Date
    Update - Change Price And Inverntory
#    Update - Change Subscription Setting
    Update - Upload Photos
    Update - Change Items Attributes Info
    Create&Update - Set Shipping Policy
    Create&Update - Override Shipping Rate
    Create&Update - Set Return Policy

Flow - Update Listing If Category Need Update
    IF    "${Catefory_Need_Update}"=="${True}"
        Update - Change Listing Category
        Update - Change Price And Inverntory
        Update - Upload Photos
        Update - Change Items Attributes Info
    END


Listing - Download Lisings By Status
    [Arguments]    ${status}=Active    ${export_flag}=${True}
    Listing - Filter - Search Listing By Status Single    ${status}
    ${results}    ${file_path}    Listing - Download Listing
    IF    '${results}'=='${False}'
        Fail    Listing export fail after filter by ${status}.
        Wait Until Element Is Not Visible    //p[text()="Export failed."]
        Sleep    1
    END
    ${listings_data}    ${request_keys}    Read Listing Info From Excel    ${file_path}
    IF    "${export_flag}"=="${True}"
        FOR    ${item}    IN    @{listings_data}
            IF    "${item}[sku_type]"=="Parent" or "${item}[sku_type]"=="Standalone"
                Page Should Contain    ${item}[item_name]
            END
        END
    ELSE
        ${listing_len}    Get Length    ${listings_data}
        IF    ${listing_len}!=0
            Fail    ${status} listing can't export, but export now.
        END
    END

Listing - Download Listing
    Remove Download File By Part Name    All_listings_*.xlsx    ${False}    ${Custom_Chrome_Download_Path}
    Scroll Element Into View  //div[text()="DOWNLOAD LISTINGS"]/parent::button
    Click Element    //div[text()="DOWNLOAD LISTINGS"]/parent::button
    ${results}    ${file_path}    Wait Until File Download By Part Name    All_listings_*.xlsx    ${TIME_OUT}    ${False}    ${Custom_Chrome_Download_Path}
    [Return]    ${results}    ${file_path}

Listing - Download Listing Excel Template By Random Category
    [Arguments]    ${quantity}=1
    Click Element    //div[text()="BULK IMPORT LISTING"]/parent::button
    Wait Until Element Is Visible     //div[text()="How would you like to manage your listings?"]
    FOR    ${index}    IN RANGE    ${quantity}
        ${category}    Get Random Category
        Click Element    //*[@name="category-search"]
        Wait Until Element Is Visible    //*[@name="category-search"]/parent::div/following-sibling::div//div[contains(@class,"category-item")]
        Input Text     //*[@name="category-search"]    ${category}
        Sleep    1
        Click Element    //*[@name="category-search"]/parent::div/following-sibling::div//div[contains(@class,"category-item")]
        Sleep    1
    END
    Remove Download File If Existed     category.xlsx    ${False}    ${Custom_Chrome_Download_Path}
    Click Element    //p[text()="Download the spreadsheet template for bulk upload or listing update"]/../parent::button
    ${results}   ${file_path}   Wait Until File Download     category.xlsx    ${TIME_OUT}    ${False}    ${Custom_Chrome_Download_Path}
    IF    "${results}"=="${False}"
        Fail    Fail to export file category.xlsx for ${category}.
    END
    Click Element    //p[text()="Bulk Import Listings"]/../following-sibling::button
    Wait Until Element Is Not Visible    //p[text()="Bulk Import Listings"]/../following-sibling::button

Listing - Download Listing Excel Template By All Category
    Click Element    //div[text()="BULK IMPORT LISTING"]/parent::button
    Wait Until Element Is Visible     //div[text()="How would you like to manage your listings?"]
    Remove Download File If Existed     category.xlsx    ${False}    ${Custom_Chrome_Download_Path}
    Click Element    //p[text()="Download the file of listing category or taxonomy"]/../parent::button
    ${results}   ${file_path}   Wait Until File Download     category.xlsx    ${TIME_OUT}    ${False}    ${Custom_Chrome_Download_Path}
    IF    "${results}"=="${False}"
        Fail    Fail to export file category.xlsx for all categories.
    END
    Click Element    //p[text()="Bulk Import Listings"]/../following-sibling::button
    Wait Until Element Is Not Visible    //p[text()="Bulk Import Listings"]/../following-sibling::button

Listing - Update Listing Taxonomy File
    ${texonomy_need_update}    Check Taxonomy File Is Need Update
    IF    "${texonomy_need_update}"=="${True}"
        ${texonomy_info}    API - Get EA Taxomomy Info
        Save Taxonomy File    ${texonomy_info}
    END

Listing - Check Listing Category Is Need Update
    [Arguments]    ${category}
    ${status}    API - Check Listing Category Is Normal    ${category}
    IF    "${status}"!="200"
        ${new_category}    Get New Category By Old    ${category}
        ${need_update}    Set Variable    ${True}
    ELSE
        ${new_category}    Set Variable    ${category}
        ${need_update}    Set Variable    ${False}
    END
    [Return]    ${need_update}    ${new_category}

Listing - Download listing By API
    [Arguments]    ${order_list}
    ${res}    API - Export All Listings - POST    ${order_list}
    ${file_path}    Save Download Listings File    ${res}    ${Download_Dir}    all_listings_${SELLER_STORE_ID}
    [Return]    ${file_path}

Listing - Download Excel Template By API
    [Arguments]    ${category_list}
    ${res}    Api - Download Excel Template - POST    ${category_list}
    ${file_path}    Save Download Listings File    ${res}    ${Download_Dir}    listings_template
    [Return]    ${file_path}

Listing - Import To Update Listing
    [Arguments]     ${status}=Active     ${have_variants}=${False}    ${update}=${False}
    ...    ${data_status}=${None}    ${listing_status}=${None}    ${expect_status}=${None}
    Run Keyword And Ignore Error    Listing - Close All Tips
    ${filter_listing_info}    API - Get Listing Info By Status And Variants    ${status}    ${have_variants}
    ${order_list}    Create List      ${filter_listing_info}[sku]
    ${need_update}    ${new_category}    Listing - Check Listing Category Is Need Update    ${filter_listing_info}[category]
    ${file_path}    Listing - Download listing By API    ${order_list}
    IF    "${update}"=="${True}"
        ${listing_data}    ${required_keys}    Read Listing Info From Excel    ${file_path}
        ${new_listing_data}    Update Import Listing Data     ${listing_data}    ${required_keys}
        ...    data_status=${data_status}   listing_status=${listing_status}    log=${True}    category_path=${new_category}
        Write Listing Info To Excel     ${file_path}    ${new_listing_data}
    END
    Sleep    1
    ${listing_data}    ${required_keys}    Read Listing Info From Excel    ${file_path}
    IF    "${need_update}"=="${True}" and "${update}"=="${False}"
        ${listing_data}    Update Import Listing Category    ${listing_data}    ${new_category}
        ${category_list}    Create List    ${new_category}
        ${template_file_path}    Listing - Download Excel Template By API     ${category_list}
        ${file_path}    Write Listing Info To Excel    ${template_file_path}    ${listing_data}    ${None}    ${False}
        Write Listing Info To Excel     ${file_path}    ${listing_data}
    END
    IF    "${have_variants}"=="${False}"
        Set Suite Variable    ${Export_Listing_No_Variants}    ${listing_data}
    ELSE
        Set Suite Variable    ${Export_Listing_Have_Variants}    ${listing_data}
    END
    Set Suite Variable    ${Export_Listing_Required_Keys}    ${required_keys}
    ${result}    Check Required Key Not Null    ${listing_data}    ${required_keys}
    ${import_success}    Listing - Import And Check Results    ${file_path}    ${listing_data}    ${result}    ${status}    ${expect_status}
    IF    "${import_success}"=="${True}"
        Listing - Check Listing Detail Is Update After Import    ${listing_data}
    END

Listing - Import And Check Results
    [Arguments]    ${file_path}    ${listing_data}    ${result}    ${status}    ${expect_status}
    Scroll Element Into View    //div[text()="BULK IMPORT LISTING"]/parent::button
    Click Element    //div[text()="BULK IMPORT LISTING"]/parent::button
    Wait Until Element Is Visible     //div[text()="How would you like to manage your listings?"]
    Choose File    //div[text()="SELECT FILE"]/input    ${file_path}
    Wait Until Element Is Not Visible    //div[text()="How would you like to manage your listings?"]
    Sleep    1
    Wait Until Element Is Not Visible    //p[text()="Uploading your file..."]
    Scroll Element Into View    //h2[text()="Listing Management"]
    Sleep    1
    ${success_count}    Get Element Count    //p[text()="Spreadsheet Successfully Uploaded!"]
    ${fail_count}    Get Element Count    //p[text()="Spreadsheet Uploaded Failed!"]
    ${import_success}    Set Variable    ${False}
    IF    '${result}'=='${True}' and ${success_count}==1
        ${import_success}    Set Variable    ${True}
        Click Element    //p[text()="Spreadsheet Successfully Uploaded!"]/following-sibling::button
        Listing - Check Listing Status After Import     ${listing_data}     ${expect_status}
    END
    IF    '${result}'=='${True}' and ${fail_count}==1
        ${err_info}    Listing - Download Import Fail Log And Check    ${listing_data}
        Fail    Fail reason: ${err_info}
    END
    IF    '${result}'=='${False}' and ${success_count}==1
        Click Element    //p[text()="Spreadsheet Successfully Uploaded!"]/following-sibling::button
        Listing - Check Listing Status After Import     ${listing_data}     ${status}
        Fail   Fail, date error but import success!
    END
    IF    '${result}'=='${False}' and ${fail_count}==1
        ${err_info}    Listing - Download Import Fail Log And Check    ${listing_data}
        Log    Fail reason: ${err_info}
    END
    [Return]    ${import_success}

Listing - Download Import Fail Log And Check
    [Arguments]    ${listing_data}
    Wait Until Element Is Visible    //div[text()="See Import logs"]/parent::button
    Remove Download File If Existed    BulkUploadListings.xlsx     ${False}    ${Custom_Chrome_Download_Path}
    Click Element    //div[text()="See Import logs"]/parent::button
    ${results}    ${file_path}    Wait Until File Download    BulkUploadListings.xlsx    ${TIME_OUT}    ${False}    ${Custom_Chrome_Download_Path}
    IF    "${results}"=="${False}"
        Fail    Fail to export file BulkUploadListings.xlsx.
    END
    ${err_listing_data}    ${required_keys}    Read Listing Info From Excel    ${file_path}
    ${err_info}    Compare Output Results    ${listing_data}    ${err_listing_data}
    [Return]    ${err_info}

Listing - Import To Create Listing
    [Arguments]    ${status}    ${data_status}    ${date_type}    ${number}    ${expect_status}
    IF    ${Export_Listing_No_Variants}==${None} or ${Export_Listing_Have_Variants}==${None}
        ${Export_Listing_No_Variants}    ${Export_Listing_Required_Keys}    Read Listing Info From Excel    listings_no_variants
        ${Export_Listing_Have_Variants}    ${Export_Listing_Required_Keys}    Read Listing Info From Excel    listings_have_variants
    END
    Run Keyword And Ignore Error    Listing - Close All Tips
    ${new_listing_data}    ${category_path}    Create Import New Listing Data    ${Export_Listing_No_Variants}    ${Export_Listing_Have_Variants}
    ...    ${Export_Listing_Required_Keys}    ${status}    ${data_status}    ${date_type}    ${number}
    ${category_list}    Create List    ${category_path}
    ${template_file_path}    Listing - Download Excel Template By API     ${category_list}
    ${file_path}    Write Listing Info To Excel    ${template_file_path}    ${new_listing_data}    ${None}    ${False}
    ${result}    Check Required Key Not Null    ${new_listing_data}    ${Export_Listing_Required_Keys}
    Listing - Import And Check Results    ${file_path}    ${new_listing_data}    ${result}    ${status}    ${expect_status}


