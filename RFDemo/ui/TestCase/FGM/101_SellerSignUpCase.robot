*** Settings ***
Library     Selenium2Library
Library     ../../Libraries/FGM/SellerSignUpLib.py
Resource    ../../Keywords/FGM/CommonKeywords.robot


Suite Setup      Set Selenium Timeout    ${Waiting_Time}
Test Setup       Environ Browser Selection And Setting   ${ENV}   Firefox    ${URL_FGM_SELL}
#Test Teardown    Close Browser

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
    Wait Until Element Is Visible       //div[text()='Create your Shop']
    Click Element                       //div[text()='Create your Shop']
    Wait Until Element Is Visible       //h1[text()='Welcome Maker!']
    Input Text                          //input[@id='firstName']              ${FirstName}
    Input Text                          //input[@id='lastName']               ${LastName}
    ${SellerAccount}                    seller_email
    Set Suite Variable                  ${SellerEmail}                        ${SellerAccount}
    Input Text                          //input[@id='email']                  ${SellerEmail}@snapmail.cc
    Input Text                          //input[@id='phoneNumber']            334-297-9166
    ${PWD}                              seller_pwd
    Set Suite Variable                  ${Password}                           ${PWD}
    Input Text                          //input[@id='password']               ${Password}
    Input Text                          //input[@id='confirmPassword']        ${Password}
    Click Element                       //p[text()='Not at this time']
    Click Element                       //button[@id='certifyAge']
    Click Element                       //div[text()='Create Account']
    Wait Until Element Is Visible       //h2[text()="Verification email has been sent!"]

Add Email To Snapmail and Verify the Email
    Go To                               ${Snapmail.cc}
    Wait Until Element Is Visible       //span[text()="Add email box"]
    Click Element                       //span[text()="Add email box"]
    Set Focus To Element                //input[@id="inputEmail" and @ng-model="newEmailBoxName"]
    Input Text                          //input[@id="inputEmail" and @ng-model="newEmailBoxName"]             ${SellerEmail}
    Click Element                       //button[text()="Save"]
    Sleep    5
    Click Element                       //*[text()="${FirstName}, please confirm your email address."]
    Sleep    3
    Select Frame                        (//iframe)[2]
    Wait Until Element Is Enabled            //a[@id="verifyButton"]
    ${href link}   Get Element Attribute     //a[@id="verifyButton"]    href
    Set Test Variable    ${URL_Register}     ${href link}
    Go To    ${href link}
    Wait Until Element Is Visible       //p[text()="Your account is ready. Start selling today!"]
    Click Element                       //div[text()="Sign In and Create my Storefront"]

Fill in Store Information
    Wait Until Element Is Visible       //h1[text()="Sign in"]
    Input Text                          //input[@id="email"]                  ${SellerEmail}@snapmail.cc
    Input Text                          //input[@id="password"]               ${Password}
    Click Element                       //form/button[@type="submit" and @form="sign-in-form"]
    Wait Until Element Is Visible       //h2[text()="Welcome Maker!"]         20
    Click Element                       //button[@id="productsOrListing"]
    Click Element                       //button[@id="classes"]
    Click Element                       //button[@id="projects"]
    ${StoreName}                        store_name
    Input Text                          //input[@id="storeName"]              ${StoreName}
    Execute Javascript                  document.getElementsByTagName('h4')[2].scrollIntoView({behavior: 'smooth', block: 'center'})
    Choose File                         (//input[@id="upload-photo"])[1]      ${CURDIR}/../../CaseData/FGM/IMG/StoreLogo.jpeg
    Execute Javascript                  document.getElementsByTagName('footer')[0].scrollIntoView();
    Choose File                         (//input[@id="upload-photo"])[3]      ${CURDIR}/../../CaseData/FGM/IMG/Banner.jpeg
    Click Element                       //div[@class="css-6kc3q enwq52y2"]
    Click Element                       (//span[@class="chakra-checkbox__control css-3sgifz"])[1]
    Click Element                       (//span[@class="chakra-checkbox__control css-3sgifz"])[7]
    Click Element                       //select[@id="storeOpenTimeStatus"]
    Click Element                       //option[@value="0"]
    Input Text                          //textarea[@id="description"]       This is the description for Makerplace Store.
    Execute Javascript                  document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible       //div[text()="NEXT: MAKER BIOGRAPHY"]
    Click Element                       //div[text()="NEXT: MAKER BIOGRAPHY"]

Fill In Maker Biography
    Wait Until Element Is Visible       //h2[text()="Maker Biography"]
    Choose File                         //input[@id="avatarUpload"]            ${CURDIR}/../../CaseData/FGM/IMG/Profile.jpeg
    Click Element                       //div[text()="Apply"]
    Set Focus To Element                //textarea[@id="makerBiography.makerBio"]
    Input Text                          //textarea[@id="makerBiography.makerBio"]      This is the maker Biography for Makerplace Store.
    Execute Javascript                  document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Visible       //p[text()="Back"]
    Input Text                          //input[@id="websiteInput"]            https://www.yimmy.com
    Click Element                       //*[@class="icon icon-tabler icon-tabler-square-plus"]
    Sleep      2
    Click Element                       //div[text()="NEXT: PAYMENT INFORMATION"]

Fill In Payment Information
    Wait Until Element Is Visible      //h2[text()="How You’ll Get Paid."]
    Input Text                         //input[@id="payeeBankAccountAndTaxInfo.bankName"]            Chase
    Input Text                         //input[@id="payeeBankAccountAndTaxInfo.accountNumber"]       7213735787
    Input Text                         //input[@id="confirmAccountNumber"]                           7213735787
    Input Text                         //input[@id="payeeBankAccountAndTaxInfo.routingNumber"]       122199983
    Input Text                         //input[@id="payeeBankAccountAndTaxInfo.firstName"]           YX
    Input Text                         //input[@id="payeeBankAccountAndTaxInfo.lastName"]            Dai
    Input Text                         //input[@id="sellerIdentityValue"]                            123456789
    Execute Javascript                 document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Enabled      //p[text()="Back"]
    Click Element                      //div[text()="NEXT: SELECT YOUR PLAN"]


Select Your Plan
    Wait Until Element Is Visible       //p[text()="MakerPlace+ Plan"]
    Click Element                       //p[text()="MakerPlace+ Plan"]
    Click Element                       //div[text()="NEXT: BILLING INFORMATION"]


Fill In Billing Information
    Wait Until Element Is Visible      //h2[text()="How You’ll Pay Michaels."]
    Input Text                         //input[@id="payerBillingInfo.wallet.cardHolderName"]        YX
    Input Text                         //input[@id="payerBillingInfo.wallet.bankCardNickName"]      Dai
    Input Text                         //input[@id="payerBillingInfo.wallet.cardNumber"]            341134113411347
    Input Text                         //input[@id="payerBillingInfo.wallet.expirationDate"]        10/24
    Input Text                         //input[@id="payerBillingInfo.wallet.cvv"]                   1234
    Sleep    3
    Input Text                         //input[@id="payerBillingInfo.addressLine1"]                 1398 Valencia St
    Input Text                         //input[@id="payerBillingInfo.addressLine2"]                 373 17TH AVE
    Input Text                         //input[@id="payerBillingInfo.city"]                         SAN FRANCISCO
    Select From List By Value          //select[@id="payerBillingInfo.state"]                       CA
    Input Text                         //input[@id="payerBillingInfo.zipCode"]                      94110
    Input Text                         //input[@id="payerBillingInfo.phoneNumber"]                  510-287-3114
    Execute Javascript                 document.getElementsByTagName('footer')[0].scrollIntoView();
    Wait Until Element Is Enabled      //p[text()="Back"]
    Sleep    3
    Click Element                      //button[@type="submit"]
    Wait Until Element Is Visible      //h1[text()="Welcome New Seller!"]













