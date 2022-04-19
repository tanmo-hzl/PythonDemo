*** Settings ***
Library     SeleniumLibrary
Library     ../../Libraries/FGM/SellerSignUpLib.py
Library     ../../Libraries/CommonLibrary.py
Library     ../../Libraries/CustomSeleniumKeywords.py    run_on_failure=Capture Screenshot and embed it into the report    implicit_wait=0.2 seconds
Resource    ../../Keywords/FGM/CommonKeywords.robot


Suite Setup      Set Library Search Order    CustomSeleniumKeywords
Test Setup       Environ Browser Selection And Setting   ${ENV}   Firefox    ${URL_FGM_SELL}
Test Teardown    Close Browser

*** Variables ***
${FirstName}            Seller
${LastName}             FGM


*** Test Cases ***
Test Create FGM Seller Account
    [Documentation]    Create A FGM Seller Account
    [Tags]    mkr    mkr-smoke    mkr-signup
    Create FGM Seller Account
    Add Email To Snapmail and Verify the Email
    Fill in Store Information
    Fill In Maker Biography
    Fill In Payment Information
    Select Your Plan
    Fill In Billing Information


*** Keywords ***
Create FGM Seller Account
    Wait Until Page Contains Element    //div[text()='Create your Shop']
    Click Element                       //div[text()='Create your Shop']
    Wait Until Page Contains Element    //h1[text()='Welcome Maker!']
    Input Text                          //input[@id='firstName']              ${FirstName}
    Input Text                          //input[@id='lastName']               ${LastName}
    ${SellerAccount}                    seller_email
    Set Test Variable                   ${SellerEmail}                         Maker_${SellerAccount}
    Input Text                          //input[@id='email']                  ${SellerEmail}@snapmail.cc
    Input Text                          //input[@id='phoneNumber']            334-297-9166
    ${PWD}                              seller_pwd
    Set Test Variable                   ${Password}                           ${PWD}
    Input Text                          //input[@id='password']               ${Password}
    ${Verify Password}      Run Keyword And Ignore Error      Wait Until Page Contains      6-20 characters with at least 1      3
    IF    '${Verify Password}[0]' == 'PASS'
        Clear Element Text              //input[@id='password']
        ${PWD}                          seller_pwd
        Set Test Variable               ${Password}                           ${PWD}
        Input Text                      //input[@id='password']               ${Password}
    END
    Input Text                          //input[@id='confirmPassword']        ${Password}
    Click Element                       //p[text()='Not at this time']
    Click Element                       //button[@id='certifyAge']
    Click Element                       //div[text()='Create Account']
    Wait Until Page Contains Element    //p[text()="A VERIFICATION EMAIL HAS BEEN SENT."]

Add Email To Snapmail and Verify the Email
    Go To                               ${Snapmail.cc}
    Wait Until Page Contains Element    //span[text()="Add email box"]
    Click Element                       //span[text()="Add email box"]
    Wait Until Page Contains Element    //input[@id="inputEmail"]
    Wait Until Element Is Enabled       //input[@id="inputEmail"]
    Clear Element Text                  //input[@id="inputEmail"]
    Input Text                          //input[@id="inputEmail"]            ${SellerEmail}
    Click Element                       //button[text()="Save"]
    Sleep    5
    Wait Until Page Contains Element    //*[text()="${FirstName}, please confirm your email address."]
    Click Element                       //*[text()="${FirstName}, please confirm your email address."]
    Sleep    3
    Select Frame                        //iframe[@name="preview-iframe"]
    Wait Until Page Contains Element         //a[@id="verifyButton"]
    ${href link}   Get Element Attribute     //a[@id="verifyButton"]    href
    Go To    ${href link}
    Wait Until Element Is Visible       //p[text()="Your account was verified and is ready!"]
    Click Element                       //div[text()="SIGN IN"]

Fill in Store Information
    Wait Until Page Contains Element    //div[text()="SIGN IN"]
    Input Text                          //input[@id="email"]                  ${SellerEmail}@snapmail.cc
    Input Text                          //input[@id="password"]               ${Password}
    Click Button                       //div[text()="SIGN IN"]/parent::button
    Wait Until Page Contains Element    //h1[text()="Welcome, ${FirstName} ${LastName}!"]
    ${StoreName}                        store_name
    Input Text                          //input[@id="storeName"]              MakerAU${StoreName}
    Click Element                       //p[text()="Store Name"]
    Execute Javascript                  document.getElementsByTagName('img')[1].scrollIntoView({block:'center'})
    Wait Until Page Contains Element    //span[@class="chakra-checkbox__control css-3sgifz"]
    Click Element                       (//span[@class="chakra-checkbox__control css-3sgifz"])[1]/..
    Click Element                       (//span[@class="chakra-checkbox__control css-3sgifz"])[2]/..
    Click Element                       (//span[@class="chakra-checkbox__control css-3sgifz"])[3]/..
    ${file_path}    Get Random Img By Project Name    FGM   3
    Choose File                         //input[@id="Banner"]                 ${file_path}[0]
    Sleep    1
    Choose File                         //input[@id="Logo"]                   ${file_path}[1]
    Sleep    1
    Choose File                         //input[@id="Profile"]                ${file_path}[2]
    Sleep    1
    Click Element                       //p[text()="CLICK TO TYPE YOUR STOREFRONT DESCRIPTION"]
    Input Text                          //textarea[@type="text"]              This is the description for Makerplace Store.
    Click Element                       //select[@id="sellerCategories"]/../..
    Execute Javascript                  document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible       //div[text()="NEXT: MAKER BIOGRAPHY"]
    Click Element                       //input[@value="Art"]/..
    Click Element                       //input[@value="Holiday & Seasonal"]/..
    Select From List By Value           //select[@id="storeOpenTimeStatus"]     0
    Wait Until Page Contains Element    //option[@label="I am a first time seller"]
    Click Element                       //div[text()="NEXT: MAKER BIOGRAPHY"]

Fill In Maker Biography
    Wait Until Element Is Visible       //h2[text()="Post your elevator pitch"]
    Input Text                          //textarea[@id="makerBiography.makerBio"]      This is the maker Biography for Makerplace Store.
    Click Element                       (//label[@class="chakra-switch e1vmw4cl0 css-1ssmtoi"])[1]
    Input Text                          //input[@id="websiteInput"]            https://www.yimmy.com
    Click Element                       //p[text()="Add Link"]
    Execute Javascript                  document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible       //p[text()="Back"]
    Click Element                       //div[text()="NEXT: PAYMENT INFORMATION"]

Fill In Payment Information
    Wait Until Page Contains Element    //h2[text()="How You’ll Get Paid."]
    Input Text                          //input[@id="payeeBankAccountAndTaxInfo.bankName"]            Chase
    Input Text                          //input[@id="payeeBankAccountAndTaxInfo.accountNumber"]       7213735787
    Input Text                          //input[@id="confirmAccountNumber"]                           7213735787
    Input Text                          //input[@id="payeeBankAccountAndTaxInfo.routingNumber"]       122199983
    Input Text                          //input[@id="payeeBankAccountAndTaxInfo.firstName"]           YX
    Input Text                          //input[@id="payeeBankAccountAndTaxInfo.lastName"]            Dai
    Input Text                          //input[@id="sellerIdentityValue"]                            473566116
    Execute Javascript                  document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible       //p[text()="Back"]
    Click Element                       //div[text()="NEXT: SELECT YOUR PLAN"]


Select Your Plan
    Wait Until Page Contains Element    //p[text()="MakerPlace+ Plan"]
    Click Element                       //p[text()="MakerPlace+ Plan"]
    Click Element                       //div[text()="NEXT: BILLING INFORMATION"]
    ${status}      Run Keyword And Ignore Error      Wait Until Element Is Visible      //div[contains(text(),"Something went wrong")]
    IF   '${status}[0]' == 'PASS'
        Sleep    2
        Click Element                   //div[text()="NEXT: BILLING INFORMATION"]
    END

Fill In Billing Information
    Wait Until Page Contains Element    //h2[text()="How You’ll Pay Michaels."]
    Input Text                          //input[@id="payerBillingInfo.wallet.cardHolderName"]        YX
    Input Text                          //input[@id="payerBillingInfo.wallet.bankCardNickName"]      Dai
    Input Text                          //input[@id="payerBillingInfo.wallet.cardNumber"]            5111005111051128
    Input Text                          //input[@id="payerBillingInfo.wallet.expirationDate"]        10/24
    Input Text                          //input[@id="payerBillingInfo.wallet.cvv"]                   611
    Sleep    3
    Input Text                          //input[@id="payerBillingInfo.addressLine1"]                 1398 Valencia St
    Input Text                          //input[@id="payerBillingInfo.addressLine2"]                 373 17TH AVE
    Input Text                          //input[@id="payerBillingInfo.city"]                         SAN FRANCISCO
    Select From List By Value           //select[@id="payerBillingInfo.state"]                       CA
    Input Text                          //input[@id="payerBillingInfo.zipCode"]                      94110
    ${Verify_Address}      Run Keyword And Ignore Error      Wait Until Page Contains      Is your address:      3
    IF  '${Verify_Address}[0]' == 'PASS'
        Clear Element Text                       //input[@id="payerBillingInfo.zipCode"]
        Wait Until Element Does Not Contain      //input[@id="payerBillingInfo.zipCode"]             94110
        Input Text                               //input[@id="payerBillingInfo.zipCode"]             9411
        Wait Until Page Contains                 9411
        Input Text                               //input[@id="payerBillingInfo.zipCode"]             0
    END
    Execute Javascript                  document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Enabled       //p[text()="Back"]
    Sleep    2
    Click Element                       //button[@type="submit"]
    Wait Until Page Contains Element    //h1[text()="Welcome!"]      60













