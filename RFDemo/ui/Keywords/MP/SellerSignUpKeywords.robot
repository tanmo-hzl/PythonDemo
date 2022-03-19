*** Settings ***
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Library        ../../Libraries/MP/SignUpLib.py
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SignUpLib.py


*** Variables ***
${Seller_Info}
${Address}
${Application_No}

*** Keywords ***
Open And Click START SELLING WITH MICHAELS Button
    Open Browser With URL               ${URL_MP_LANDING}       mpLandingURL
    Switch Browser    mpLandingUrl
    Wait Until Element Is Visible       //div[text()='START SELLING WITH MICHAELS']
    Click Element                       //div[text()='START SELLING WITH MICHAELS']
    Wait Until Element Is Visible       //p[text()="Company Information"]

Open And Enter MP Apply Page
    [Arguments]    ${new_browser}=${True}
    IF    "${new_browser}"=="${True}"
        Open Browser With URL    ${URL_MP_APPLY}    mpApply
        Switch Browser    mpApply
    ELSE
        Go To    ${URL_MP_APPLY}
    END
    Wait Until Element Is Visible       //input[@id="companyName"]

Create - Input Company Legal Name
    Wait Until Element Is Visible       //p[text()="Company Information"]
    Input Text                          //input[@id="companyName"]          ${Seller_Info}[name]

Create - Input First And Last Name
    Input Text                          //input[@id="coFirstName"]          ${Seller_Info}[first_name]
    Input Text                          //input[@id="coLastName"]           ${Seller_Info}[last_name]

Create - Input Email And Confirm Email Address
    Input Text                          //input[@id="email"]                ${Seller_Info}[email]
    Input Text                          //input[@id="confirmEmail"]         ${Seller_Info}[email]

Create - Input Employer Identification Number(EIN)
    Input Text                          //input[@id="ein"]          ${Seller_Info}[ein]

Create - Upload Photos
    ${Select_File_Xpath}                 Set Variable     //p[starts-with(text(),"Drag file here ")]/following-sibling::button//input
    Wait Until Element Is Visible        //p[text()="Company Information"]
    Scroll Element Into View             //p[starts-with(text(),"Drag file here")]
    ${photos}    Get Json Value        ${Seller_Info}    photos
    Choose File                          ${Select_File_Xpath}        ${photos[0]}
    Choose File                          ${Select_File_Xpath}        ${photos[1]}
    Wait Until Element Is Visible        (//div[text()="Uploaded"])[1]
    Wait Until Element Is Visible        (//div[text()="Uploaded"])[2]
    Scroll Element Into View             //div[text()="Submit"]

Create - Click Sold And Shipped Lable Button
    Click Element                           //p[@id="switch-label" and text()="No"]/preceding-sibling::label
    Wait Until Element Is Visible           //p[@id="switch-label" and text()="Yes"]

Create - Select Categories You Sell In
    Scroll Element Into View            //div[text()="Submit"]/parent::button
    Click Element                       //div[@id="categories"]
    Wait Until Element Is Visible      //*[@id="categories"]//label//p
    ${categories}    Get Json Value    ${Seller_Info}    categories
    ${item}   set variable
    FOR    ${item}    IN   @{categories}
        Click Element     //*[@id="categories"]//label//p[text()="${item}"]/../parent::label
    END
    Click Element    //div[@id="categories"]

Create - Input Other Platforms Website
    ${links}    Get Json Value    ${Seller_Info}    links
    ${links_len}    Get Length    ${links}
    ${index}  Set Variable
    FOR    ${index}   IN RANGE    ${links_len}
        Wait Until Element Is Visible    //input[@name="productLinks[${index}]"]
        Clear Element Value    //input[@name="productLinks[${index}]"]
        Input Text     //input[@name="productLinks[${index}]"]         ${links[${index}]}
        Wait Until Element Is Visible    //*[@name="productLinks[0]"]/following-sibling::div/div
        Click Element    //*[@name="productLinks[0]"]/following-sibling::div/div
        ${new_index}   Evaluate    ${index}+1
        Exit For Loop If    '${new_index}'=='${links_len}'
        Click Element    //*[@name="productLinks[${index}]"]/../parent::div/following-sibling::div//button
    END

Create - Select Many SKUs In Your Catalog
    [Arguments]    ${value}=2
    Select From List By Value             //select[@id="numberOfSkus"]    ${Seller_Info}[numberOfSkus]

Create - Select Approximate Annual ECommerce Revenue
    [Arguments]    ${value}=2
    Select From List By Value           //select[@id="sales"]    ${Seller_Info}[sales]

Create - Select Integration Source
    [Arguments]    ${value}=0
    Select From List By Value           //select[@id="preferredMethod"]    ${Seller_Info}[preferredMethod]
    IF    '${Seller_Info}[preferredMethod]'=='2'
        Wait Until Element Is Visible    //*[@id="partnerCompanyName"]
        Input Text    //*[@id="partnerCompanyName"]    ${Seller_Info}[name]
    END


Create - Check Privacy Policy Checkbox
    Click Element    //p[starts-with(text(),"By clicking ")]/parent::span/preceding-sibling::span
    Sleep    1

Create - Click Submit Button
    Wait Until Element Is Enabled    //div[text()="Submit"]/parent::button
    Sleep    1
    Click Element                   //div[text()="Submit"]/parent::button
    Wait Until Element Is Visible    //p[text()="You have submitted your application successfully."]

Create An Account and Account Password
    ${SIGN_UP_URL}    set variable      ${URL_BASE_SIGN_UP}?applicationId=${Application_No}&email=${Seller_Info}[email]
    Go To    ${SIGN_UP_URL}
    Sleep    3
    Reload Page
    Wait Until Element Is Visible       //p[text()="Sign up for Marketplace Emails"]
    Click Element                       //p[text()="Sign up for Marketplace Emails"]
    Click Element                       //p[text()="I certify that I am at least 18 years of age"]
    Input Text                          //input[@id="password"]     ${SELLER_PWD}
    Input Text                          //input[@id="confirmPassword"]      ${SELLER_PWD}

Read And Confirm Seller Agreement
    Wait Until Page Contains Element    //div[@id="docx"]
    Scroll Element Into View            //div[text()="Create Account"]
    ${js}    Get Add Element Js
    Execute Javascript    ${js}
    Sleep    1
    Wait Until Page Contains Element    //div[@id="docx"]//*[text()="MICHAELS MARKETPLACE PROGRAM SELLER AGREEMENT"]
    Click Element                       //div[@id="docx"]//*[text()="MICHAELS MARKETPLACE PROGRAM SELLER AGREEMENT"]
    Scroll Element Into View            //span[(text()="end")]
    Sleep   2
    Scroll Last Button Into View
    Wait Until Element Is Enabled       //div[starts-with(text(),"I agree to the")]/../parent::button
    Click Element                       //div[starts-with(text(),"I agree to the")]/../parent::button
    Wait Until Element Is Enabled       //div[text()="Create Account"]/parent::button
    Click Element                       //div[text()="Create Account"]/parent::button
    Wait Until Page Contains Element    //h1[text()="Pick a name for your store."]

Fill In Store Information
    ${Address}    Get Json Value    ${Seller_Info}    address
    Set Suite Variable    ${Address}    ${Address}
    Wait Until Element Is Visible       //input[@id="storeName"]
    Input Text                          //input[@id="storeName"]        ${Seller_Info}[store_name]
    Input Text                          //input[@id="city"]             ${Address}[city]
    Select From List By Value           //select[@id="state"]           ${Address}[state]
    Input Text                          //input[@id="zipCode"]          ${Address}[zipcode]
    Sleep    2
    Click Element                       //div[text()="SAVE AND CONTINUE"]/parent::button
    Wait Until Page Contains Element    //h1[text()="How You’ll Get Paid."]



Fill In Payment Information
    ${now_url}    Get Location
    ${bank_info}   Get Json Value    ${Seller_Info}    bank_info
    Wait Until Element Is Visible       //input[@id="bankName"]
    sleep    1
    Input Text                          //input[@id="bankName"]                     ${bank_info}[name]
    Select From List By Value           //select[@id="accountType"]                 ${bank_info}[accountType]
    Input Text                          //input[@id="accountNumber"]                ${bank_info}[accountNumber]
    Input Text                          //input[@id="confirmAccountNumber"]         ${bank_info}[accountNumber]
    Input Text                          //input[@id="routingNumber"]                ${bank_info}[routingNumber]
    Input Text                          //input[@id="businessName"]                 ${bank_info}[businessName]
    Scroll Element Into View            //div[text()="SAVE AND CONTINUE"]/parent::button
    Input Text                          //input[@id="address1"]                     ${Address}[address1]
    Input Text                          //input[@id="city"]                         ${Address}[city]
    Select From List By Value           //select[@id="state"]                       ${Address}[state]
    Input Text                          //input[@id="zipCode"]                      ${Address}[zipcode]
    Click Element                       //div[text()="SAVE AND CONTINUE"]/parent::button
    Wait Until Page Contains Element    //h1[text()="Complete Billing Information"]

Fill In Billing Information
    ${payment_info}    Get Json Value      ${Seller_Info}    payment_info
    Click Element                       //p[text()="Add Card"]
    Wait Until Page Contains Element    //p[text()="Please enter your credit card information."]
    Input Text                          //input[@id="cardholderName"]               ${payment_info}[cardHolderName]
    Input Text                          //input[@id="bankCardNickName"]             ${payment_info}[bankCardNickName]
    Input Text                          //input[@id="cardNumber"]                   ${payment_info}[cardNumber]
    Press Keys                          //input[@id="expirationDate"]               ${payment_info}[expirationDate]
    Press Keys                          //input[@id="cvv"]                          ${payment_info}[cvv]
    Click Element                       //span[text()="Use previous address"]/parent::label
    Press Keys                          //input[@id="phoneNumber"]                  ${Seller_Info}[phone]
    Click Element                       //div[text()="SAVE"]/parent::button
    Sleep  1
    Wait Until Element Is Not Visible    //p[text()="Please enter your credit card information."]
    Click Element                       //div[text()="Submit"]/parent::button
    Wait Until Page Contains Element    //h4[text()="Congrats!"]
    Click Element                       //div[text()="Start Now"]/parent::button
    ${Not_Visible}                      Run_Keyword_And_Return_Status    Wait_Until_Page_Contains_Element    //h1[text()="Store Profile"]
    Run_keyword_if                      '${Not_Visible}'=='False'        reload page


Fill In Store Log Store Banner And Description
    ${now_url}    Get Location
    Wait Until Page Contains Element     //p[starts-with(text(),"Drag photos here ")]
    ${Select_File_Xpath}                 Set Variable       //p[starts-with(text(),"Drag photos here ")]/following-sibling::button//input
    ${photos}    Get Json Value        ${Seller_Info}    photos
    Choose File                          ${Select_File_Xpath}       ${photos[0]}
    Wait Until Page Contains Element     //div[text()="Apply"]/parent::button
    Click Element                        //div[text()="Apply"]/parent::button
    Wait Until Element Is Visible        (//div[contains(text(),"Change photo")])[1]
    Scroll Element Into View             //p[starts-with(text(),"The short description ")]
    Choose File                          ${Select_File_Xpath}    ${photos[1]}
    Wait Until Page Contains Element     //div[text()="Apply"]/parent::button
    Click Element                        //div[text()="Apply"]/parent::button
    Wait Until Element Is Visible        (//div[contains(text(),"Change photo")])[2]
    Scroll Element Into View             //div[text()="SAVE"]/parent::button
    Input Text                           //*[@id="description"]      ${Seller_Info}[description]
    Click Element                        //div[text()="SAVE"]/parent::button
    Wait Until Page Contains Element     //h4[text()="Primary Contact Information"]

Add Customer Service Datails
    ${now_url}    Get Location
    Input Text                          (//label[text()="Email Address*"]/following-sibling::div/input)[1]    ${Seller_Info}[email]
    Press Keys                          //label[text()="Phone number*"]/following-sibling::div/input    ${Seller_Info}[phone]
    Select From List By Value           //select[@id="customer-service-timezones"]       -6
    ${contact}   Get Json Value    ${Seller_Info}    contact
    ${days}    Set Variable    ${contact}[days]
    Click Element                       //div[contains(@id,".days")]
    Wait Until Element Is Visible      //input[@value="Monday"]/parent::*
    ${item}    Set Variable
    FOR    ${item}    IN    @{days}
        Click Element                       //input[@value="${item}"]/parent::*
    END
    Click Element                       //div[contains(@id,".days")]

    Click Element                       //div[contains(@id,"department")]
    Wait Until Element Is Visible       //input[@value="Customer Care"]/..
    Click Element                       //input[@value="${Seller_Info}[department]"]/..
    Click Element                       //div[contains(@id,"department")]

    Input Text                          (//label[text()="Email Address*"]/following-sibling::div/input)[2]          ${Seller_Info}[email]
    Press Keys                          (//label[text()="Phone number*"]/following-sibling::div/input)[2]           ${Seller_Info}[phone]
    Click Element                       //div[text()="SAVE"]/..
    Wait Until Element Is Visible       //p[starts-with(text(),"Provide your fulfillment center locations,")]



Provide Fulfillment Infomation
    ${now_url}    Get Location
    # Address
    Input Text                          //input[@id="fulfillmentCenters[0].address1"]               ${Address}[address1]
    Input Text                          //input[@id="fulfillmentCenters[0].city"]                   ${Address}[city]
    Select From List By Value           //select[@id="fulfillmentCenters[0].state"]                 ${Address}[state]
    Input Text                          //input[@id="fulfillmentCenters[0].zipCode"]                ${Address}[zipcode]

    # Fulfillment Center Hours
    Scroll Element Into View            //p[text()="Add another Fulfillment Center"]
    Select From List By Value           //select[@id="fulfillment0Timezone"]       -6
    Click Element                       //div[contains(@id,".days")]
    Wait Until Element Is Visible      //input[@value="Monday"]/parent::*
    ${contact}   Get Json Value    ${Seller_Info}    contact
    ${days}    Set Variable    ${contact}[days]
    ${item}    Set Variable
    FOR    ${item}    IN    @{days}
        Click Element                       //input[@value="${item}"]/parent::*
    END
    Click Element                       //div[contains(@id,".days")]

    # Observed Holidays(Optional)
    Click Element                       //div[contains(@id,"fulfillment0holidayName")]
    Wait Until Element Is Visible       //p[text()="New Years Day"]/..
    Click Element                       //p[text()="New Years Day"]/..
    Wait Until Element Is Visible       //input[@id="fulfillmentCenters[0].anthorHolidays[0].from"]
    ${fromDate}    Get Current Date     result_format=%Y-%m-%d
    ${abFrom}    Add Time To Date     ${fromDate}    1 days    result_format=%Y-%m-%d
    ${abTo}    Add Time To Date     ${abFrom}    7 days    result_format=%Y-%m-%d
    Common - Select Date By Element      ${abFrom}    //label[text()="Start Date"]/following-sibling::div//input
    Common - Select Date By Element      ${abFrom}    //label[text()="End Date"]/following-sibling::div//input

    #Shipping Rate Table
    Scroll Element Into View            //div[text()="SAVE"]
    Input Text                          //input[@id="standardShippingLines[0].shipmentCost"]      12
    Click Element                       //div[text()="SAVE"]

Fill In Return Information
    ${now_url}    Get Location
    Wait Until Element Is Visible       //p[starts-with(text(),"Provide your return center location.")]
    Scroll Element Into View            //div[text()="SAVE"]
    Click Element                       //div[text()="SAVE"]
    Wait Until Element Is Visible       //header[text()="Onboarding Complete Confirmation"]
    Click Element                       //div[text()="GO TO MY STOREFRONT"]
    Wait Until Element Is Visible       //h4[text()="Store Name and Location"]

Initialize Seller Data
    ${Seller_Info}    Get New Seller Info    ${ENV}
    Set Suite Variable    ${Seller_Info}    ${Seller_Info}

Flow - Seller Pre Application Submit
    [Arguments]    ${new_browser}=${True}
    Open And Enter MP Apply Page    ${new_browser}
    Create - Input Company Legal Name
    Create - Input First And Last Name
    Create - Input Email And Confirm Email Address
    Create - Input Employer Identification Number(EIN)
    Create - Upload Photos
    Create - Click Sold And Shipped Lable Button
    Create - Select Categories You Sell In
    Create - Input Other Platforms Website
    Create - Select Many SKUs In Your Catalog
    Create - Select Approximate Annual ECommerce Revenue
    Create - Select Integration Source
    Create - Check Privacy Policy Checkbox
    Create - Click Submit Button

Flow - Buyer Sign Up
    Open Browser With URL    ${URL_MIK}/signup   mpApply
    Switch Browser    mpApply
    Input Text    //*[@id="firstName"]    ${Seller_Info}[first_name]
    Input Text    //*[@id="lastName"]    ${Seller_Info}[last_name]
    Input Text    //*[@id="email"]    ${Seller_Info}[email]
    Input Text    //*[@id="password"]    ${SELLER_PWD}
    Input Text    //*[@id="confirmPassword"]    ${SELLER_PWD}
    Scroll Last Button Into View
    Input Text    //*[@id="rewardsPhoneNumber"]    ${Seller_Info}[phone]
    Click Element    //*[@id="signUpForEmails"]
    Click Element    //*[@id="certifyAge"]
    Click Element    //*[@id="keepSignIn"]
    Click Element    //div[text()="Sign up"]/parent::button
    Wait Until Element Is Visible    //h2[text()="Verification email has been sent!"]
