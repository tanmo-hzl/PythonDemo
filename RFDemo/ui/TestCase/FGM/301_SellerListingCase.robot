*** Settings ***
Library     ../../Libraries/FGM/SellerListingLib.py
Library     ../../Libraries/CommonLibrary.py
Resource    ../../Keywords/FGM/CommonKeywords.robot


Suite Setup         Run Keywords    Environ Browser Selection And Setting    ${ENV}    Firefox
...                 AND    User Sign In - FGM   ${SellerEmail}    ${Password}    ${FirstName}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Listing Management
Test Teardown       Go To Expect Url Page    ${TEST_STATUS}    ${User_Type}    ${Page_Name}


*** Variables ***
${SellerEmail}    Makerplace@snapmail.cc
${Password}       Password123
${FirstName}      Seller
${User_Type}      seller
${Page_Name}      lst


*** Test Cases ***
Test Create New Listing - No Variants
    [Documentation]    Create new Listing without variants
    [Tags]     mkr    mkr-smoke    mkr-lst
    Listing Details - No Variants
    Photos and Videos - NO Variants
    Inventory and Pricing - No Variants
    Shipping - No Variants
    Listing Confirmation - No Variants


Test Repeated Tags for Listing
    [Documentation]    Test the repeated tags for Listing
    [Tags]     mkr    mkr-smoke    mkr-lst
    Listing Details - Repeated Tags


Test Create New Listing - Have Variants
    [Documentation]    Create new Listing with variants
    [Tags]     mkr    mkr-smoke    mkr-lst
    ${ListingDetails}    Listing Details - Have Variants    Art    10525736    15    90
    Photos and Videos - Have Variants
    Inventory and Pricing - Have Variants
    Shipping - Have Variants
    Listing Confirmation - Have Variants
    Listing PDP - Have Variants


*** Keywords ***
Store Left Menu - Listing Management
    Wait Until Element Is Visible         //p[text()="My Product Listings"]
    Click Element                         //p[text()="My Product Listings"]
    Wait Until Element Is Visible         //h1[text()="My Product Listings"]

Listing Details - No Variants
    Wait Until Element Is Enabled         //div[text()="Create Listing"]/..
    Click Element                         //div[text()="Create Listing"]/..
    Wait Until Element Is Visible         //h1[text()="Listing Details"]
    ${ListingTitle}                       listing_title
    Set Test Variable                     ${Title}                               ${ListingTitle}
    Input Text                            //input[@id="skuDisplayName"]          AU No Variants ${Title}
    Input Text                            //input[@id="category"]                art
    Click Element                         //button[@aria-label="Category Search Icon"]
    ${Verify Category}      Run Keyword And Ignore Error      Wait Until Page Contains Element      //p[text()="Art / Drawing / Charcoal"]
    IF  '${Verify Category}[0]' == 'FAIL'
        Click Element                         //button[@aria-label="Category Search Icon"]
        Wait Until Page Contains Element      //p[text()="Art / Drawing / Charcoal"]
    END
    Click Element                         //p[text()="Art / Drawing / Charcoal"]
    Wait Until Page Contains Element      //textarea[@id="longDescription"]
    Input Text                            //textarea[@id="longDescription"]      This is the Description for the Listing.
    Execute Javascript                    document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible         //div[text()="Save as Draft"]
    Click Element                         (//p[text()=" Days"])[1]
    Click Element                         //button[@value="3"]
    Wait Until Element Contains           //p[text()="1-3 Days"]                 1-3 Days
    Click Element                         //p[text()=" Days"]
    Click Element                         //button[@value="180"]
    Wait Until Element Contains           //p[text()="6 Months"]                 6 Months
    Click Element                         //div[text()="Save and Continue"]

Photos and Videos - NO Variants
    Wait Until Element Is Visible         //h1[text()="Photos and Video"]
    ${file_path}    Get Random Img By Project Name    FGM
    Choose File                           //input[@id="ListingImage upload"]      ${file_path}
    Sleep    2
    Wait Until Page Contains Element      (//div[@class="css-1c8ckg8"])[5]/..
    Click Button                          (//div[@class="css-1c8ckg8"])[5]/..

Inventory and Pricing - No Variants
    Wait Until Element Is Visible        //div[text()="Inventory and Pricing"]
    Set Focus To Element                 //input[@name="price"]
    Input Text                           //input[@name="price"]                   7.88
    Sleep    1
    Set Focus To Element                 //input[@name="inventory"]
    Input Text                           //input[@name="inventory"]               100
    Sleep  1
    Click Element                        //div[text()="Save and Continue"]

Shipping - No Variants
    Wait Until Element Is Visible        //h1[text()="Shipping and Returns"]
    Input Text                           //input[@id="shipInfo.weightLb"]         1
    Input Text                           //input[@id="shipInfo.weightOz"]         1
    Input Text                           //input[@id="shipInfo.length"]           2
    Input Text                           //input[@id="shipInfo.height"]           2
    Input Text                           //input[@id="shipInfo.width"]            2
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Back"]
    Click Element                        //p[text()="What you will charge"]
    Sleep    1.5
    Click Element                        //span[text()="Priority Mail 2-Day™; Flat Rate Envelope"]
    Wait Until Page Contains             Priority Mail 2-Day™; Flat Rate Envelope
    Click Element                        //p[text()="What you will charge"]
    Sleep    1
    Click Element                        //button[text()="Free Shipping"]
    Wait Until Page Contains             Free Shipping
    Click Element                        //div[text()="Save and Continue"]

Listing Confirmation - No Variants
    Wait Until Element Is Visible        //h1[text()="Listing Confirmation"]
    Click Element                        //div[text()="Submit to Publish"]
    Wait Until Element Is Visible        //h3[text()="Congrats! You Added a Product Listing!"]
    Click Element                        //div[text()="GO TO LISTING MANAGEMENT"]
    Wait Until Page Contains             AU No Variants ${Title}


Listing Details - Repeated Tags
    Wait Until Element Is Visible         //div[text()="Create Listing"]
    Click Element                         //div[text()="Create Listing"]
    Wait Until Element Is Visible         //h1[text()="Listing Details"]
    @{tags}    Create List    AT    Automation    Test    Test
    FOR    ${item}    IN    @{tags}
        Input Text                        //input[@id="tagInput"]      ${item}
        Click Button                      //p[text()="Add Tags"]/..
        Sleep    0.5
    END
    Wait Until Page Contains              Test is already added!
    Click Element                         //a[@aria-label="Close and return to Michaels.com"]


Listing Details - Have Variants
    [Arguments]   ${Category}    ${SKU}    ${LeadTime}    ${Timeframe}
    Store Left Menu - Listing Management
    Wait Until Element Is Visible         //div[text()="Create Listing"]
    Click Element                         //div[text()="Create Listing"]
    Wait Until Element Is Visible         //h1[text()="Listing Details"]
    ${ListingTitle}                       listing_title
    Set Test Variable                     ${Title}                               ${ListingTitle}
    Input Text                            //input[@id="skuDisplayName"]          AU have Variants ${Title}
    Input Text                            //input[@id="category"]                ${Category}
    Click Element                         //button[@aria-label="Category Search Icon"]
    ${Verify Category}      Run Keyword And Warn On Failure      Wait Until Page Contains Element      //p[text()="Art / Drawing / Charcoal"]
    IF  '${Verify Category}[0]' == 'FAIL'
        Click Element                         //button[@aria-label="Category Search Icon"]
        Wait Until Page Contains Element      //p[text()="Art / Drawing / Charcoal"]
    END
    Execute Javascript                    document.getElementsByTagName('div')[19].scrollIntoView();
    Wait Until Page Contains Element      //p[text()="Don't see your listing category? You may add them manually."]
    ${Verify Click here}    Run Keyword And Warn On Failure      Wait Until Page Contains      Click here
    IF  '${Verify Click here}[0]' == 'FAIL'
        Execute Javascript                    document.getElementsByTagName('div')[19].scrollIntoView();
        Wait Until Page Contains Element      //p[text()="Don't see your listing category? You may add them manually."]
    END
    Wait Until Page Contains Element      //button[text()="Click here"]
    Wait Until Element Is Enabled         //button[text()="Click here"]

    Click Button                          //button[text()="Click here"]
    Select From List By Index             //select[@id="primaryCategory"]        0
    Select From List By Index             //select[@id="secondaryCateogry"]      2
    Select From List By Index             //select[@id="tertiaryCategory"]       3
    Wait Until Element Is Visible         //div[text()="SAVE"]/..
    Click Button                          //div[text()="SAVE"]/..
    Wait Until Page Contains              Art, Glass, Suncatchers
    Input Text                            //input[@id="tagInput"]      Automation
    Click Button                          //p[text()="Add Tags"]/..
    Execute Javascript                    document.getElementsByTagName('textarea')[0].scrollIntoView();
    Wait Until Page Contains Element      //textarea[@id="longDescription"]
    Input Text                            //textarea[@id="longDescription"]     This is the Description for the Listing.
    Click Button                          //div[text()="Select Products"]/..
    Click Element                         //input[@placeholder="Search for an item by name or SKU"]
    Input Text                            //input[@placeholder="Search for an item by name or SKU"]            ${SKU}
    Click Button                          //button[@class="css-13ezjph"]
    Sleep    1.5
    Click Element                         //p[text()="$2.99"]/preceding-sibling::label
    Click Button                          //div[text()="Add These Products"]/..
    Wait Until Page Contains              Item # ${SKU}
    Click Element                         (//p[text()=" Days"])[1]
    Input Text                            //input[@id="customLeadTime"]          ${LeadTime}
    Wait Until Page Contains              ${LeadTime}
    Click Element                         //p[text()="${LeadTime} Days"]
    Execute Javascript                    document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible         //div[text()="Save as Draft"]
    Click Element                         //p[text()=" Days"]
    Click Element                         //button[@value="${Timeframe}"]
    IF    "${Timeframe}" == "180"
        ${Listing_Timeframe}   Set Variable    6 Months
    ELSE IF    "${Timeframe}" == "90"
        ${Listing_Timeframe}   Set Variable    3 Months
    ELSE IF    "${Timeframe}" == "30"
        ${Listing_Timeframe}   Set Variable    1 Month
    ELSE IF    "${Timeframe}" == "10"
        ${Listing_Timeframe}   Set Variable    10 Days
    END
    Wait Until Page Contains               ${Listing_Timeframe}
    Set Task Variable    ${e_timeframe}    ${Listing_Timeframe}
    Click Element                         //div[text()="Save and Continue"]
    ${ListingDetails}   Create Dictionary    Category=${Category}   SKU=${SKU}    LeadTime=${LeadTime}    Timeframe=${Timeframe}
    ...    Listing_Timeframe=${Listing_Timeframe}   Listing_Title=AU have Variants ${Title}
    [Return]      ${ListingDetails}
    Set Test Variable    ${Details}    ${ListingDetails}


Photos and Videos - Have Variants
    Wait Until Element Is Visible         //h1[text()="Photos and Video"]
    ${file_path}    Get Random Img By Project Name    FGM    2
    Choose File                           //input[@id="ListingImage upload"]      ${file_path}[0]
    Sleep    3
    Choose File                           //input[@id="ListingImage upload"]      ${file_path}[1]
    Sleep    3
    Wait Until Element Is Visible         //button[@class="css-5rj6vi"]                # Save and Continue - button
    Click Button                          //button[@class="css-5rj6vi"]

Inventory and Pricing - Have Variants
    Wait Until Page Contains Element     //div[text()="Inventory and Pricing"]
    Click Element                        //div[text()="Add Variant"]
    Click Element                        //p[text()="Add variant type"]
    Wait Until Page Contains Element     //button[@value="Size"]
    Click Button                         //button[@value="Size"]
    Click Element                        //p[text()="Select Size options"]
    Click Button                         //button[@value="S"]
    Click Element                        //p[text()="Select Size options"]
    Click Button                         //button[@value="M"]
    Click Element                        //p[text()="Select Size options"]
    Click Button                         //button[@value="L"]
    Wait Until Page Contains Element     //p[text()="Price is same for each variation"]
    Click Element                        //p[text()="Price is same for each variation"]
    Click Element                        //div[text()="Save"]
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Page Contains Element     //div[text()="Save as Draft"]
    Set Focus To Element                 //input[@name="subSkus[0].inventory"]
    Input Text                           //input[@name="subSkus[0].inventory"]    10
    Sleep    2
    Set Focus To Element                 //input[@name="subSkus[1].inventory"]
    Input Text                           //input[@name="subSkus[1].inventory"]    20
    Sleep    2
    Set Focus To Element                 //input[@name="subSkus[2].inventory"]
    Input Text                           //input[@name="subSkus[2].inventory"]    30
    Sleep    2
    Set Focus To Element                 //input[@name="subSkus[0].price"]
    Input Text                           //input[@name="subSkus[0].price"]        8.88
    Sleep    2
    Click Element                        //p[text()=" Photos"]
    Select From List By Value            //select[@id="selectvariant"]            Size
    Wait Until Page Contains Element     //p[text()="Add photos to your product options."]
    ${file_path}    Get Random Img By Project Name    FGM   3
    Choose File                          (//input[@id="upload-photo"])[1]      ${file_path}[0]
    Sleep    2
    Choose File                          (//input[@id="upload-photo"])[2]      ${file_path}[1]
    Sleep    2
    Choose File                          (//input[@id="upload-photo"])[3]      ${file_path}[2]
    Sleep    2
    Wait Until Page Contains Element     //div[text()="Save"]
    Set Focus To Element                 //div[text()="Save"]
    Sleep    2
    Click Element                        //div[text()="Save"]
    Wait Until Page Contains Element     //span[text()="Off"]
    Click Element                        //span[text()="Off"]
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Page Contains Element     //div[text()="Save as Draft"]
    Input Text                           //input[@name="personalization.personalizationTitle"]       Would you like to leave some message?
    Input Text                           //input[@name="personalization.personalizationText"]        Test for Personalization Text
    Click Element                        //p[text()="Click here if personlization is optional for buyers"]
    Click Element                        //div[text()="Save and Continue"]

Shipping - Have Variants
    Wait Until Element Is Visible        //h1[text()="Shipping and Returns"]
    Input Text                           //input[@id="shipInfo.weightLb"]         1
    Input Text                           //input[@id="shipInfo.weightOz"]         1
    Input Text                           //input[@id="shipInfo.length"]           2
    Input Text                           //input[@id="shipInfo.height"]           2
    Input Text                           //input[@id="shipInfo.width"]            2
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Back"]
    Click Element                        //p[text()="What you will charge"]
    Sleep    2
    Click Element                        //span[text()="Priority Mail 2-Day™; Flat Rate Envelope"]
    Wait Until Page Contains             Priority Mail 2-Day™; Flat Rate Envelope
    Click Element                        //p[text()="What you will charge"]
    Sleep    1
    Click Element                        //button[text()="Free Shipping"]
    Wait Until Page Contains             Free Shipping
    Input Text                           //input[@id="shipping.handlingRate"]    2.88
    Wait Until Element Is Visible        //span[@class="chakra-switch__thumb css-13yl9wn"]
    Click Element                        //span[@class="chakra-switch__thumb css-13yl9wn"]
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Back"]
    Wait Until Element Is Visible        //p[text()="30 Days Return"]
    Click Element                        //p[text()="30 Days Return"]
    Click Element                        //div[text()="Save and Continue"]

Listing Confirmation - Have Variants
    Wait Until Element Is Visible        //h1[text()="Listing Confirmation"]
    ${a_title}       Get Text            //p[text()="Makerplace Seller"]/following-sibling::div/h3[1]
    ${e_title}       Set Variable        ${Details}[Listing_Title]
    Run Keyword And Warn On Failure      Should Be Equal As Strings    ${a_title}    ${e_title}     Wrong Title in Listing Confirmation
    ${primary_img}    Get Element Attribute    (//h3[text()="Preview"]/following-sibling::div//img)[1]     src
    Run Keyword And Warn On Failure      Should Not Be Empty    ${primary_img}     Primary image is missing in Listing Confirmation
    ${dic}    Create Dictionary     Product Category=${Details}[Category]      Lead Time=${Details}[LeadTime]    Listing Timeframe=${Details}[Timeframe]
    FOR    ${key}   ${value}   IN ZIP   ${dic.keys()}    ${dic.values()}
        ${a_value}    Get Text            //h4[text()="${key}"]/following-sibling::p
        IF  '${key}' == 'Product Category'
            Run Keyword And Warn On Failure      Should Start With      ${a_value}    ${value}    Wrong ${key} in Listing Confirmation
        ELSE
            Run Keyword And Warn On Failure      Should Be Equal As Strings     ${a_value}    ${value}    Wrong ${key} in Listing Confirmation
        END
    END
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Back"]
    ${a_sku}         Get Text            //p[@class="css-1giiycw"]/following-sibling::p
    ${e_sku}         Set Variable        ${Details}[SKU]
    Run Keyword And Warn On Failure      Should Contain         ${a_sku}    ${e_sku}         Wrong sku in Listing Confirmation
    ${QTY}   Create List    10  20  30
    FOR  ${e_qty}  IN  @{QTY}
        ${a_qty}        Get Text            //div[text()="${e_qty}"]
        Run Keyword And Warn On Failure      Should Contain           ${a_qty}    ${e_qty}    Wrong inventory in Listing Confirmation
    END
    ${a_price}       Get Text            //p[text()="$8.88"]
    Run Keyword And Warn On Failure      Should Be Equal As Strings     ${a_price}     Price: $8.88    Wrong price in Listing Confirmation
    Click Element                        //div[text()="Submit to Publish"]
    Wait Until Element Is Visible        //h3[text()="Congrats! You Added a Product Listing!"]
    Click Element                        //div[text()="GO TO LISTING MANAGEMENT"]

Listing PDP - Have Variants
    Wait Until Page Contains             ${Details}[Listing_Title]
    Click Element                        //img[@alt="${Details}[Listing_Title] image"]
    Wait Until Page Contains             ${Details}[Listing_Title]
    ${variants}   Create List    S  M  L
    FOR  ${e_variants}  IN  @{variants}
        Select From List By Value            //select[@aria-label="Size"]    ${e_variants}
        ${a_price}        Get Text           //div[text()="$8.88"]
        Run Keyword And Warn On Failure      Should Be Equal As Strings      ${a_price}    $8.88    Wrong price in PDP
    END
    ${a_shippolicy}       Get Text       (//h4[text()="Return Policy"]/following-sibling::p)[1]
    Run Keyword And Warn On Failure      Should Start With    ${a_shippolicy}    30 days return     Wrong shipping policy in PDP













