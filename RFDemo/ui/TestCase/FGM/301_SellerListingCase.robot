*** Settings ***
Library     Selenium2Library
Library     ../../Libraries/FGM/SellerListingLib.py
Resource    ../../Keywords/FGM/CommonKeywords.robot


Suite Setup     Run Keywords    Environ Browser Selection And Setting    ${ENV}    Firefox
...                AND    Set Selenium Timeout    ${Waiting_Time}
...                AND    User Sign In            ${SellerEmail}    ${Password}    ${FirstName}
Test Setup        Store Left Menu - Listing Management
Suite Teardown    Close Browser


*** Variables ***
${SellerEmail}      Makerplace@snapmail.cc
${Password}         Password123
${FirstName}        Seller
${URL_Listings}                ${URL_MIK}/fgm/sellertools/my-product-listings
#${URL_Listings_Image}          ${URL_MIK}/fgm/seller/createlisting/photos-and-video?returnUrl=/fgm/sellertools/my-product-listings
${URL_Listings_Inventory}      ${URL_MIK}/fgm/seller/createlisting/inventory-and-pricing?returnUrl=/fgm/sellertools/my-product-listings
${URL_Listings_Shipping}       ${URL_MIK}/fgm/seller/createlisting/shipping?returnUrl=/fgm/sellertools/my-product-listings
#${URL_Listings_Confirmation}   ${URL_MIK}/fgm/seller/createlisting/preview?returnUrl=/fgm/sellertools/my-product-listings


*** Test Cases ***
Test Create Listing Without Variants
    [Documentation]    Create new Listing without variants
    [Tags]     mkr    mkr-smoke    mkr-lst
    Listing Details - No Variants
    Photos and Videos - NO Variants
    Inventory and Pricing - No Variants
    Shipping - No Variants
    Listing Confirmation - No Variants

Test Create Listing With Variants
    [Documentation]    Create new Listing with variants
    [Tags]     mkr    mkr-smoke    mkr-lst
    ${ListingDetails}    Listing Details - With Variants    art    D220734S    15    90
    Photos and Videos - With Variants
    Inventory and Pricing - With Variants
    Shipping - With Variants
    Listing Confirmation - With Variants


*** Keywords ***
Store Left Menu - Listing Management
    Wait Until Element Is Visible    //p[text()="My Product Listings"]
    Click Element                    //p[text()="My Product Listings"]
    Wait Until Element Is Visible    //h1[text()="My Product Listings"]

Listing Details - No Variants
    Wait Until Element Is Enabled         //div[text()="Create Listing"]/..
    Click Element                         //div[text()="Create Listing"]/..
    Wait Until Element Is Visible         //h1[text()="Listing Details"]
    Input Text                            //input[@id="skuDisplayName"]          AU Without Variants
    Input Text                            //input[@id="category"]                art
    Click Element                         //button[@aria-label="Category Search Icon"]
    Wait Until Element Is Visible         //p[text()="Art / Fiber Arts / Rug Hooking"]
    Set Focus To Element                  //p[text()="Art / Fiber Arts / Rug Hooking"]
    Click Element                         //p[text()="Art / Fiber Arts / Rug Hooking"]
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
    Choose File                           //input[@id="ListingImage upload"]      ${CURDIR}/../../CaseData/FGM/IMG/ListingPicture.jpeg
    Sleep    2
    Wait Until Element Is Visible         //button[@class="css-5rj6vi"]
    Click Button                          //button[@class="css-5rj6vi"]

Inventory and Pricing - No Variants
    Wait Until Element Is Visible        //div[text()="Inventory and Pricing"]
    Set Focus To Element                 //input[@name="price"]
    Input Text                           //input[@name="price"]                   7.88
    Sleep    1
#    ${Enter Price}    Run Keyword And Ignore Error     Wait Until Element Is Visible     //p[text()="Enter Amount"]
#    IF  '${Enter Price}[0]' == 'PASS'
#        Input Text    //input[@name="price"]       7.88
#    END
    Set Focus To Element                 //input[@name="inventory"]
    Input Text                           //input[@name="inventory"]               100
#    ${Enter Quantity}    Run Keyword And Ignore Error     Wait Until Element Is Visible     //p[text()="Enter Quantity"]
#    IF  '${Enter Quantity}[0]' == 'PASS'
#        Input Text    //input[@name="inventory"]   100
#    END
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
    Sleep    1
    Click Element                        //span[text()="Priority Mail 2-Day™; Flat Rate Envelope"]
    Sleep    1
    Click Element                        //p[text()="What you will charge"]
    Sleep    1
    Click Element                        //button[text()="Free Shipping"]
    Click Element                        //div[text()="Save and Continue"]

Listing Confirmation - No Variants
    Wait Until Element Is Visible        //h1[text()="Listing Confirmation"]
    Click Element                        //div[text()="Submit to Publish"]
    Wait Until Element Is Visible        //h3[text()="Congrats! You Added a Product Listing!"]
    Click Element                        //div[text()="GO TO LISTING MANAGEMENT"]
    Wait Until Page Contains             AU Without Variants


Listing Details - With Variants
    [Arguments]   ${Category}    ${SKU}    ${LeadTime}    ${Timeframe}
    Go To                                 ${URL_Listings}
    Wait Until Element Is Visible         //div[text()="Create Listing"]
    Click Element                         //div[text()="Create Listing"]
    Wait Until Element Is Visible         //h1[text()="Listing Details"]
    ${ListingTitle}                       listing_title
    Set Suite Variable                    ${Title}                               ${ListingTitle}
    Input Text                            //input[@id="skuDisplayName"]          AU With Variants ${Title}
    Input Text                            //input[@id="category"]                ${Category}
    Click Element                         //button[@aria-label="Category Search Icon"]
    Execute Javascript                    document.getElementsByTagName('div')[19].scrollIntoView();
    Wait Until Page Contains Element      //p[text()="Don't see your listing category? You may add them manually."]
    Sleep    2
    Click Button                          //button[text()="Click here"]
    Select From List By Index             //select[@id="primaryCategory"]        3
    Select From List By Index             //select[@id="secondaryCateogry"]      2
    Select From List By Index             //select[@id="tertiaryCategory"]       1
    Wait Until Element Is Visible         //div[text()="SAVE"]/..
    Click Button                          //div[text()="SAVE"]/..
    Wait Until Element Is Visible         //p[text()="Decor, Candles & Fragrances, Candles"]
    Input Text                            //input[@id="tagInput"]                AT
    Click Button                          //p[text()="Add Tags"]/..
    Wait Until Page Contains              AT
    Input Text                            //input[@id="tagInput"]                Automation
    Click Button                          //p[text()="Add Tags"]/..
    Wait Until Page Contains              Automation
    Input Text                            //input[@id="tagInput"]                Test
    Click Button                          //p[text()="Add Tags"]/..
    Wait Until Page Contains              Test
    Input Text                            //input[@id="tagInput"]                Test
    Click Button                          //p[text()="Add Tags"]/..
    Wait Until Page Contains              Test is already added!
    Clear Element Text                    //input[@id="tagInput"]
    Execute Javascript                    document.getElementsByTagName('textarea')[0].scrollIntoView();
    Wait Until Page Contains Element      //textarea[@id="longDescription"]
    Input Text                            //textarea[@id="longDescription"]     This is the Description for the Listing.
    Click Button                          //div[text()="Select Products"]/..
    Click Element                         //input[@placeholder="Search for an item by name or SKU"]
    Input Text                            //input[@placeholder="Search for an item by name or SKU"]            ${SKU}
    Click Button                          //button[@class="css-13ezjph"]
    Sleep    1
    Set Focus To Element                  //label[@class="chakra-checkbox e32j4ln0 css-l0e1pb"]
    Click Element                         //label[@class="chakra-checkbox e32j4ln0 css-l0e1pb"]
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
    Wait Until Page Contains              ${Listing_Timeframe}
    Click Element                         //div[text()="Save and Continue"]

    ${ListingDetails}   Create Dictionary    Category=${Category}   SKU = ${SKU}    LeadTime = ${LeadTime}    Timeframe = ${Timeframe}
    ...    Listing_Timeframe=${Listing_Timeframe}   Title = AU With Variants ${Title}
    [Return]      ${ListingDetails}
    Set Suite Variable    ${Listing_Details}    ${ListingDetails}


Photos and Videos - With Variants
    Wait Until Element Is Visible         //h1[text()="Photos and Video"]
    Choose File                           //input[@id="ListingImage upload"]      ${CURDIR}/../../CaseData/FGM/IMG/ListingPicture2.jpeg
    Sleep    2
    Element Should Be Visible             //div[@class="evh9c3z4 css-zdc080"]     # upload image successfully
    Choose File                           //input[@id="ListingImage upload"]      ${CURDIR}/../../CaseData/FGM/IMG/ListingPicture.jpeg
    Sleep    2
    Element Should Be Visible             //div[@class="evh9c3z4 css-zdc080"][2]       # upload image successfully
    Wait Until Element Is Visible         //button[@class="css-5rj6vi"]                # Save and Continue - button
    Click Button                          //button[@class="css-5rj6vi"]

Inventory and Pricing - With Variants
#    Go To                                ${URL_Listings_Inventory}
    Wait Until Element Is Visible        //div[text()="Inventory and Pricing"]
    Click Element                        //div[text()="Add Variant"]
    Click Element                        //p[text()="Add variant type"]
    Wait Until Element Is Visible        //button[@value="Size"]
    Click Button                         //button[@value="Size"]
    Click Element                        //p[text()="Select Size options"]
    Click Button                         //button[@value="S"]
    Click Element                        //p[text()="Select Size options"]
    Click Button                         //button[@value="M"]
    Click Element                        //p[text()="Select Size options"]
    Click Button                         //button[@value="L"]
    Wait Until Element Is Visible        //p[text()="Price is same for each variation"]
    Click Element                        //p[text()="Price is same for each variation"]
    Click Element                        //div[text()="Save"]
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Save as Draft"]
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
    Wait Until Element Is Visible        //p[text()="Add photos to your product options."]
    Choose File                          (//input[@id="upload-photo"])[1]         ${CURDIR}/../../CaseData/FGM/IMG/VariantsPicture1.jpeg
    Sleep    2
    Choose File                          (//input[@id="upload-photo"])[2]         ${CURDIR}/../../CaseData/FGM/IMG/VariantsPicture2.jpeg
    Sleep    2
    Choose File                          (//input[@id="upload-photo"])[3]         ${CURDIR}/../../CaseData/FGM/IMG/VariantsPicture3.jpeg
    Sleep    2
    Click Element                        //div[text()="Save"]
    Wait Until Element Is Visible        //span[text()="Off"]
    Click Element                        //span[text()="Off"]
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Save as Draft"]
    Input Text                           //input[@name="personalization.personalizationTitle"]       Would you like to leave some message?
    Input Text                           //input[@name="personalization.personalizationText"]        Yimmy
    Click Element                        //p[text()="Click here if personlization is optional for buyers"]
    Click Element                        //div[text()="Save and Continue"]

Shipping - With Variants
#    Go To                                ${URL_Listings_Shipping}
    Wait Until Element Is Visible        //h1[text()="Shipping and Returns"]
    Input Text                           //input[@id="shipInfo.weightLb"]         1
    Input Text                           //input[@id="shipInfo.weightOz"]         1
    Input Text                           //input[@id="shipInfo.length"]           2
    Input Text                           //input[@id="shipInfo.height"]           2
    Input Text                           //input[@id="shipInfo.width"]            2
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Back"]
    Click Element                        //p[text()="What you will charge"]
    Sleep    1
    Click Element                        //span[text()="Priority Mail 2-Day™; Flat Rate Envelope"]
    Sleep    1
    Click Element                        //p[text()="What you will charge"]
    Sleep    1
    Click Element                        //button[text()="Free Shipping"]
    Input Text                           //input[@id="shipping.handlingRate"]    2.88
    Wait Until Element Is Visible        //span[@class="chakra-switch__thumb css-13yl9wn"]
    Click Element                        //span[@class="chakra-switch__thumb css-13yl9wn"]
    Execute Javascript                   document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible        //div[text()="Back"]
    Wait Until Element Is Visible        //p[text()="30 Days Return"]
    Click Element                        //p[text()="30 Days Return"]
    Click Element                        //div[text()="Save and Continue"]

Listing Confirmation - With Variants
    Wait Until Element Is Visible        //h1[text()="Listing Confirmation"]
    ${a_title}       Get Text            //p[text()="Makerplace Seller"]/following-sibling::div/h3[1]
    ${e_title}       Set Variable        ${Listing_Details}[Title]
    Run Keyword And Warn On Failure      Should Be Equal As Strings    ${a_title}    ${e_title}     Wrong Title in Listing Confirmation
    ${Primary_img}    Get Element Attribute    (//h3[text()="Preview"]/following-sibling::div//img)[1]     src
    Run Keyword And Warn On Failure      Should Not Be Empty    ${Primary_img}     Primary image is missing in Listing Confirmation



#    Click Element                        //div[text()="Submit to Publish"]
#    Wait Until Element Is Visible        //h3[text()="Congrats! You Added a Product Listing!"]
#    Click Element                        //div[text()="GO TO LISTING MANAGEMENT"]
#    Wait Until Page Contains             AU With Variants ${Title}