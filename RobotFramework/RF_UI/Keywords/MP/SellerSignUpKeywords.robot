*** Settings ***
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Library        ../../Libraries/MP/SignUpLib.py
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SignUpLib.py


*** Variables ***
${Seller_Account}
${Application_No}

*** Keywords ***
Click START SELLING WITH MICHAELS Button
    Open Browser With URL               ${URL_MP_LANDING}       mpLandingURL
    Wait Until Element Is Visible       //div[text()='START SELLING WITH MICHAELS']
    Click Element                       //div[text()='START SELLING WITH MICHAELS']
    Wait Until Element Is Visible       //p[text()="Company Information"]

Create - Input Company Legal Name
    Wait Until Element Is Visible       //p[text()="Company Information"]
    Input Text                          //input[@id="companyName"]          ${Seller_Account}

Create - Input First And Last Name
    Input Text                          //input[@id="coFirstName"]          ${Seller_Account}
    Input Text                          //input[@id="coLastName"]           ${Seller_Account}


Create - Input Email And Confirm Email Address
    Input Text                          //input[@id="email"]                ${Seller_Account}@snapmail.cc
    Input Text                          //input[@id="confirmEmail"]         ${Seller_Account}@snapmail.cc

Create - Input Employer Identification Number(EIN)
    ${Random_Str}                       Evaluate                    random.randint(100000000,999999999)
    Input Text                          //input[@id="ein"]          ${Random_Str}

Create - Upload Photos
    ${Select_File_Xpath}                 Set Variable     //p[starts-with(text(),"Drag file here ")]/following-sibling::button//input
    ${File_Paths}                        Get Random Img Path    2
    ${File_Path_One}                     Set Variable    ${File_Paths[0]}
    ${File_Path_Two}                     Set Variable    ${File_Paths[1]}
    Wait Until Element Is Visible        //p[text()="Company Information"]
    Scroll Element Into View             //p[starts-with(text(),"Drag file here")]
    Choose File                          ${Select_File_Xpath}        ${File_Path_Two}
    Wait Until Element Is Visible        (//div[text()="Uploaded"])[1]
#    Click Element    //div[@type="button"]
    Sleep    5
    My Choose File                       ${Select_File_Xpath}        ${File_Path_One}
#    My Choose File                       ${Select_File_Xpath}        ${File_Path_Two}
    Wait Until Element Is Visible        (//div[text()="Uploaded"])[2]
    Sleep    5
    Scroll Element Into View             //div[text()="Submit"]

Create - Click Sold And Shipped Lable Button
    Click Element                           //p[@id="switch-label" and text()="No"]/preceding-sibling::label
    Wait Until Element Is Visible           //p[@id="switch-label" and text()="Yes"]


Create - Select Categories You Sell In
    Scroll Element Into View            //div[text()="Submit"]/parent::button
    Click Element                       //div[@id="categories"]/div/p
    Wait Until Element Is Visible       //div[@id="categories"]/div/div[2]
    ${index}   set variable    1
    FOR    ${index}    IN RANGE    1    15
        Click Element                   (//*[@id="categories"]//input[@name="categories"]/..)[${index}]
    END
    Click Element                       //div[@id='categories']//div[starts-with(text(),"Add")]

Create - Input Other Platforms Website
    Input Text                            //input[@id="products"]         ${Seller_Account}.com

Create - Select Many SKUs In Your Catalog
    [Arguments]    ${value}=2
    Select From List By Value             //select[@id="numberOfSkus"]    ${value}


Create - Select Approximate Annual ECommerce Revenue
    [Arguments]    ${value}=2
    Select From List By Value           //select[@id="sales"]    ${value}


Create - Select Integration Source
    [Arguments]    ${value}=0
    Select From List By Value           //select[@id="preferredMethod"]    ${value}

Create - Check Privacy Policy Checkbox
#    Click Element                       //*[@id="apply"]/label/span[1]
    Click Element    //p[starts-with(text(),"By clicking ")]/parent::span/preceding-sibling::span
    Sleep    1

Create - Click Submit Button
    Wait Until Element Is Enabled    //div[text()="Submit"]/parent::button
    Sleep    1
    Click Element                   //div[text()="Submit"]/parent::button
    Wait Until Element Is Visible    //p[text()="You have submitted your application successfully."]
#
#
#Sign In Map With Admin Account
#    Go To   ${URL_MAP}
#    Wait Until Element Is Visible       //h2[text()="Member Login"]
##    Input Text  //div[text()="Email Address"]/following-sibling::div/input    admin1@michaels.com
##    Input Text  //div[text()="Password"]/following-sibling::div/span/input    Admin123
#    Input Text                          //input[@type='text']    ${MAP_EMAIL}
#    Input Text                          //input[@type='password']    ${MAP_PWD}
#    Click Element                       xpath=//button[@type='submit']
#    Wait Until Element Is Visible       //p[text()="Marketplace"]
#
#Approve Seller Applications
#    Click Element                       //p[text()="Marketplace"]
#    Wait Until Element Is Visible       //span[text()="Vendor Management"]
#    Click Element                       //span[text()="Vendor Management"]
#    Wait Until Element Is Visible       //span[text()="Seller Applications"]
#    Click Element                       //span[text()="Seller Applications"]/..
#    Wait Until Element Is Visible       //tbody
#    Input Text                          //input[@id="saerchValue"]          ${Seller_Account}
#    Press Keys                          //input[@id="saerchValue"]      ENTER
#    Wait Until Element Is Visible       //div[text()="${Seller_Account}"]/../following-sibling::td[6]
#    ${Application_No}    Get Text       //div[text()="${Seller_Account}"]/../following-sibling::td[1]
#    Set Suite Variable                  ${Application_No}                   ${Application_No}
#    Sleep   1
#    Mouse Over                          //div[text()="${Seller_Account}"]/../..
#    Wait Until Element Is Visible       ((//div[starts-with(@class,"${Application_No}")]/div/div)[1]/following-sibling::*)[1]
#    Click Element                       ((//div[starts-with(@class,"${Application_No}")]/div/div)[1]/following-sibling::*)[1]
#    Wait Until Element Is Visible       //div[text()="Approve"]
#    Click Element                       //div[text()="Approve"]


Create An Account and Account Password
    ${SIGN_UP_URL}    set variable      ${URL_BASE_SIGN_UP}?applicationId=${Application_No}&email=${Seller_Account}@snapmail.cc
    Go To    ${SIGN_UP_URL}
#    Open Browser With URL    ${SIGN_UP_URL}    signUpURL
    Wait Until Element Is Visible       //p[text()="Sign up for Marketplace Emails"]
    Click Element                       //p[text()="Sign up for Marketplace Emails"]
    Click Element                       //p[text()="I certify that I am at least 18 years of age"]
    Input Text                          //input[@id="password"]     ${PWD}
    Input Text                          //input[@id="confirmPassword"]      ${PWD}

Read And Confirm Seller Agreement
    Wait Until Page Contains Element    //div[@id="docx"]
    Scroll Element Into View            //div[text()="Create Account"]
    ${js}    Get Add Element Js
    Execute Javascript    ${js}
    Sleep    1
    Wait Until Page Contains Element    //div[@id="docx"]//*[text()="MICHAELS MARKETPLACE PROGRAM SELLER AGREEMENT"]
    Click Element    //div[@id="docx"]//*[text()="MICHAELS MARKETPLACE PROGRAM SELLER AGREEMENT"]
    Scroll Element Into View            //span[(text()="end")]
    Sleep  2
    Click Element                       //input[@type="checkbox"]/..
    Click Element                       //div[text()="Create Account"]
    Wait Until Page Contains Element    //h1[text()="Pick a name for your store."]

Fill In Store Information
    Press Keys                          //input[@id="storeName"]        ${Seller_Account}
    Input Text                          //input[@id="city"]             Houston
    Select From List By Value           //select[@id="state"]           TX
    Input Text                          //input[@id="zipCode"]          77093
    Click Element                       //button[@type="submit"]
    Wait Until Page Contains Element    //h1[text()="How You’ll Get Paid."]
    Sleep  2



Fill In Payment Information
    Input Text                          //input[@id="bankName"]                     ${Seller_Account}
    Select From List By Value           //select[@id="accountType"]                 0
    Input Text                          //input[@id="accountNumber"]                10500008944
    Input Text                          //input[@id="confirmAccountNumber"]         10500008944
    Input Text                          //input[@id="routingNumber"]                122199983
    Input Text                          //input[@id="businessName"]                 ${Seller_Account}
    Scroll Element Into View            //button[@type="submit"]
    Input Text                          //input[@id="address1"]                     2317 Margaret St
    Input Text                          //input[@id="city"]                         Houston
    Select From List By Value           //select[@id="state"]                       TX
    Input Text                          //input[@id="zipCode"]                      77093
    Click Element                       //button[@type="submit"]
    Wait Until Page Contains Element    //h1[text()="Complete Billing Information"]

Fill In Billing Information
    Click Element                       //p[text()="Add Card"]
    Wait Until Page Contains Element    //p[text()="Please enter your credit card information."]
    Input Text                          //input[@id="cardholderName"]               ${Seller_Account}
    Input Text                          //input[@id="bankCardNickName"]             ${Seller_Account}
    Input Text                          //input[@id="cardNumber"]                   6011016011016011
    Press Keys                          //input[@id="expirationDate"]               1133
    Press Keys                          //input[@id="cvv"]                          113
    Click Element                       //span[text()="Use previous address"]
    Press Keys                          //input[@id="phoneNumber"]                  6666666666
    Click Element                       //div[text()="SAVE"]/..
    Sleep  1
    Click Element                       //div[text()="Submit"]/..
    Wait Until Page Contains Element    //h4[text()="Congrats!"]
    Click Element                       //div[text()="Start Now"]
    ${Not_Visible}                      Run_Keyword_And_Return_Status    Wait_Until_Page_Contains_Element    //h1[text()="Store Profile"]
    Run_keyword_if                      '${Not_Visible}'=='False'        reload page


Fill In Store Log Store Banner And Description
#    Open Browser - MP    seller
#    User Sign In - MP    ${Seller_Account}@snapmail.cc    Password123    ${Seller_Account}
#    Go To  ${URL_Onboarding}
#    Sleep  2

    Wait Until Page Contains Element     //p[starts-with(text(),"Drag photos here ")]
    ${Select_File_Xpath}                 Set Variable       //p[starts-with(text(),"Drag photos here ")]/following-sibling::button//input
    ${File_Path_One}                     Get Random Img Path
    Choose File                          ${Select_File_Xpath}       ${File_Path_One}
    Wait Until Page Contains Element     //div[text()="Apply"]
    Click Element                        //div[text()="Apply"]
    Wait Until Element Is Visible        (//div[contains(text(),"Change photo")])[1]
    Scroll Element Into View             //p[starts-with(text(),"The short description ")]
    Choose File                          ${Select_File_Xpath}    ${File_Path_One}
    Wait Until Page Contains Element     //div[text()="Apply"]
    Click Element                        //div[text()="Apply"]
    Wait Until Element Is Visible        (//div[contains(text(),"Change photo")])[2]
    Scroll Element Into View             //div[text()="SAVE"]
    Input Text                           //*[@id="description"]      this is a Description*
    Click Element                        //div[text()="SAVE"]
    Wait Until Page Contains Element     //h4[text()="Primary Contact Information"]



Add Customer Service Datails
    Input Text                          (//label[text()="Email Address*"]/following-sibling::div/input)[1]    ${Seller_Account}@snapmail.cc
    Press Keys                          //label[text()="Phone number*"]/following-sibling::div/input    6666666666
    Select From List By Value           //select[@id="customer-service-timezones"]       -6

    Click Element                       //p[text()="Select days"]
    Wait Until Element Is Visible       (//div[starts-with(text(),"Add")])[1]
    Click Element                       //input[@value="Monday"]/..
    Click Element                       //input[@value="Tuesday"]/..
    Click Element                       //input[@value="Wednesday"]/..
    Click Element                       //input[@value="Thursday"]/..
    Click Element                       //input[@value="Friday"]/..
    Click Element                       //input[@value="Saturday"]/..
    Click Element                       //input[@value="Sunday"]/..
    Click Element                       (//div[starts-with(text(),"Add")])[1]

    Click Element                       //p[text()="Select observed department"]
    Wait Until Element Is Visible       (//div[starts-with(text(),"Add")])[2]
    Click Element                       //input[@value="Customer Care"]/..
    Click Element                       //input[@value="Billing"]/..
    Click Element                       //input[@value="Order Resolution"]/..
    Click Element                       //input[@value="Technical Issues"]/..
    Click Element                       //input[@value="Marketing"]/..
    Click Element                       (//div[starts-with(text(),"Add")])[2]


    Input Text                          (//label[text()="Email Address*"]/following-sibling::div/input)[2]          test${Seller_Account}@snapmail.cc
    Press Keys                          (//label[text()="Phone number*"]/following-sibling::div/input)[2]           6666666666
    Click Element                       //div[text()="SAVE"]/..
    Wait Until Element Is Visible       //p[starts-with(text(),"Provide your fulfillment center locations,")]



Provide Fulfillment Infomation
    # Address
    Input Text                          //input[@id="fulfillmentCenters[0].address1"]               2317 Margaret St
    Input Text                          //input[@id="fulfillmentCenters[0].city"]                   Houston
    Select From List By Value           //select[@id="fulfillmentCenters[0].state"]                 TX
    Input Text                          //input[@id="fulfillmentCenters[0].zipCode"]                77093

    # Fulfillment Center Hours
    Scroll Element Into View            //p[text()="Add another Fulfillment Center"]
    Select From List By Value           //select[@id="fulfillment0Timezone"]       -6
    Click Element                       //p[text()="Select days"]
    Wait Until Element Is Visible       (//div[starts-with(text(),"Add")])[1]
    Click Element                       //input[@value="Monday"]/..
    Click Element                       //input[@value="Tuesday"]/..
    Click Element                       //input[@value="Wednesday"]/..
    Click Element                       //input[@value="Thursday"]/..
    Click Element                       //input[@value="Friday"]/..
    Click Element                       //input[@value="Saturday"]/..
    Click Element                       //input[@value="Sunday"]/..
    Click Element                       (//div[starts-with(text(),"Add")])[1]

    # Observed Holidays(Optional)
    Click Element                       //p[text()="Select observed holidays"]
    Wait Until Element Is Visible       (//div[starts-with(text(),"Add")])[2]
    Click Element                       //p[text()="Select All"]/..
    Click Element                       (//div[starts-with(text(),"Add")])[2]

    #Shipping Rate Table
    Scroll Element Into View            //div[text()="SAVE"]
    Input Text                          //input[@id="standardShippingLines[0].shipmentCost"]      12
    Click Element                       //div[text()="SAVE"]




Fill In return Information
    Wait Until Element Is Visible       //p[starts-with(text(),"Provide your return center location.")]
    Scroll Element Into View            //div[text()="SAVE"]
    Click Element                       //div[text()="SAVE"]
    Wait Until Element Is Visible       //header[text()="Onboarding Complete Confirmation"]
    Click Element                       //div[text()="GO TO MY STOREFRONT"]
    Wait Until Element Is Visible       //h4[text()="Store Name and Location"]



