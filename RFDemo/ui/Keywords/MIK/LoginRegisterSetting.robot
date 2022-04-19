*** Settings ***
Library        String
Resource       ../Common/SnapmailKeywords.robot
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot

*** Variables ***
${password}
${email}
${firstName}

*** Keywords ***
Enter registration Information
    [Arguments]  ${info_text}
    For dict and input text  ${info_text}
    Click On The Element And Wait  //p[text()='Not at this time']
    Click On The Element And Wait  //p[text()='I certify that I am at least 13 years of age']
    Scroll Last Button Into View
    Click On The Element And Wait  //div[text()='Sign up']/parent::button

Verify Snapmail Browser
    [Arguments]   ${Verify}   ${newPassword}
    IF  '${Verify}'=='email'
        Click On The Element And Wait  //span[contains(text(), 'please confirm your email address')]
        ${text}  Set Variable  Verify My Email
    ELSE
        Click On The Element And Wait  //span[contains(text(), 'received your request to reset your password')]
        ${text}  Set Variable  RESET PASSWORD
    END
    Wait Until Page Contains Element  //iframe[@name="preview-iframe"]
    Sleep  1
    Select Frame  //iframe[@name="preview-iframe"]
    Click On The Element And Wait  //a[text()='${text}']
    Sleep  1
    ${Handles}   Get Window Handles
    Switch Window   ${Handles[1]}
    IF  '${Verify}'=='email'
        Click On The Element And Wait  //div[text()='CONTINUE SHOPPING']/parent::button
    ELSE
        Input Text And Wait  //input[@id="newPassword"]  ${newPassword}
        Input Text And Wait  //input[@id="confirmPassword"]  ${newPassword}
        Click On The Element And Wait  //div[text()='Reset']/parent::button
        Wait Until Page Contains  Your password has been reset successfully
        Click On The Element And Wait  //div[text()='Sign in']/parent::button
    END


Sign up
    [Arguments]  ${email}=${null}  ${password}=PASSword123
    ...  ${first_name}=summer  ${lastname}=summer
    IF  '${email}'=='${null}'
        ${name}  Generate Random String	 8  [NUMBERS]
        ${email}  Set Variable  summer${name}@snapmail.cc
    END
    Set Suite Variable  ${email}
    Set Suite Variable  ${password}
    Set Suite Variable  ${first_name}
    Click On The Element And Wait  //div[text()='CREATE ACCOUNT']/parent::button
    ${info_text}  Create Dictionary  firstName=${firstName}
    ...  lastName=${lastName}  email=${email}
    ...  password=${password}  confirmPassword=${password}
    Enter registration Information  ${info_text}

Go To Snapmail Browser Verify Email
    [Arguments]   ${email}=${email}   ${Verify}=email  ${newPassword}=${null}
    Open Snapmail Browser
    ${temp_list}  splits_string_get_text  ${email}  @
    Add New Snapmail  ${temp_list[0]}
    Verify Snapmail Browser  ${Verify}  ${newPassword}

Change password
    [Arguments]   ${current_password}  ${new_password}
    Click On The Element And Wait  (//p[text()='Account Settings'])[2]
    ${info_text}  Create Dictionary  currentPassword=${current_password}  newPassword=${new_password}
    ...  confirmPassword=${new_password}
    For dict and input text  ${info_text}
    Click On The Element And Wait  //div[text()='CHANGE PASSWORD']/parent::button

Verify Name And Emaile
    [Arguments]   ${Name}=summer  ${verify_email}=${email}
    ${info_text}  Create Dictionary  First Name=${Name}   Last Name=${Name}   Email Address=${verify_email}
    FOR   ${key}  ${value}  IN  &{info_text}
        ${temp_text}  Get Text And Wait  //h4[text()='${key}:']/parent::p
        Should Contain  ${temp_text}  ${value}
    END

Verify Dashboard
    Click On The Element And Wait  (//p[text()='Dashboard'])[2]
    Wait Until Page Contains  RECENT PURCHASES
    Wait Until Page Contains  Tax Exempt, Information, Status and application

Edit personal Information
    [Arguments]   ${info_text}  ${Month}  ${Date}
    Click On The Element And Wait  //p[text()='Edit Profile']/parent::button
    Sleep  1
    Choose File And Wait  //div[text()='CHANGE PICTURE']/../following-sibling::input
    For Dict And Input Text  ${info_text}
    Scroll Element Into View  //div[text()='Save']/parent::button
    Click On The Element And Wait  //p[text()='Month of Birth']/following-sibling::button
    Click On The Element And Wait  //button[text()='${Month}']
    Click On The Element And Wait  //p[text()='Date of Birth']/following-sibling::button
    Scroll Element And Wait And Click  //button[text()='${Date}']
    Scroll Element And Wait And Click  //*[@class="icon icon-tabler icon-tabler-pencil"]
    Scroll Element And Wait And Click  //div[text()='SAVE']/parent::button
    Click On The Element And Wait  //div[text()='Use USPS Suggestion']/parent::button
    Click On The Element And Wait   //*[@class="icon icon-tabler icon-tabler-trash"]
    Click On The Element And Wait  //div[text()='Delete']/parent::button
    Scroll Element And Wait And Click  //div[text()='Save']/parent::button
    Wait Until Page Contains  Success

Add New Address
    [Arguments]   ${Address_info_dict}
    Click On The Element And Wait  //div[text()='Add Shipping Address']/parent::button
    Enter and save the address information  ${Address_info_dict}

Enter and save the address information
    [Arguments]   ${Address_info_dict}
    For dict and input text        ${Address_info_dict}
    Click On The Element And Wait  //div[text()='SAVE']/parent::button
    Click On The Element And Wait  //div[text()='Use USPS Suggestion']/parent::button

Add New Card
    [Arguments]   ${card_info_dict}
    Click On The Element And Wait  (//p[text()='Wallet'])[2]
    ${result}  Run Keyword And Ignore Error  Click On The Element And Wait  //div[text()='ADD A NEW CARD']/parent::button
    IF  '${result[0]}'=='FAIL'
        Click On The Element And Wait  //p[text()='Add Additional Card']/parent::button
    END
    For dict and input text        ${card_info_dict}
    Select From List By Value      //select[@name="state"]  TX
    Click On The Element And Wait  //div[text()='SAVE']/parent::button
    Click On The Element And Wait  //div[text()='Use USPS Suggestion']/parent::button

Add Same Card
    [Arguments]   ${card_info_dict}
    Add New Card  ${card_info_dict}
    Click On The Element And Wait  //div[text()='Try Again']/parent::button

Edit Card
    Click On The Element And Wait  (//p[text()='Wallet'])[2]
    Click On The Element And Wait  //p[text()='Expiration']/../following-sibling::div/button
    Click On The Element And Wait  //p[text()='Edit']/../parent::button
    Click On The Element And Wait  //div[text()='SAVE']/parent::button
    Click On The Element And Wait  //div[text()='Use USPS Suggestion']/parent::button
    Wait Until Page Contains  Success

Setting The Default Card
    Click On The Element And Wait  //div[text()='Set Default']/parent::button
    Click On The Element And Wait  (//div[text()='Set Default']/parent::button)[2]
    Wait Until Page Contains  Success

Remove Card
    Click On The Element And Wait  (//p[text()='Wallet'])[2]
    Click On The Element And Wait  //p[text()='Expiration']/../following-sibling::div/button
    Click On The Element And Wait  //p[text()='Remove']/../parent::button
    Click On The Element And Wait  //div[text()='Confirm']/parent::button
    Wait Until Page Contains  Success
    Click On The Element And Wait  //p[text()='Expiration']/../following-sibling::div/button
    Wait Until Page Contains  To delete card, please add another payment method

Add Gift Cards
    [Arguments]   ${card_number}  ${pin}
    Click On The Element And Wait  (//p[text()='Wallet'])[2]
    Click On The Element And Wait  //div[text()='ADD A GIFT CARD']/parent::button
    Input Text And Wait  //input[@id="cardNumber"]  ${card_number}
    Input Text And Wait  //input[@id="pin"]  ${pin}
    Click On The Element And Wait  //div[text()='SAVE']/parent::button

Verify Gitf Card And Remove Card
    [Arguments]   ${card_number}  ${pin}
    Add Gift Cards  6006496912999907486  5171
    Wait Until Page Contains  Balance
    Add Gift Cards  6006496912999907486  5171
    Wait Until Page Contains       Invalid Card Number and PIN combination
    Click On The Element And Wait  //div[text()='Cancel']/parent::button
    Click On The Element And Wait  //p[starts-with(text(), 'Balance')]/../following-sibling::div/*
    Click On The Element And Wait  //div[text()='Delete']/parent::button

verify setting
    ${text}   Create List    Orders & Purchases  Order History  Subscription  Rewards  Coupons
    ...    Return and Dispute  Classes Calendar  Account Information  Profile
    FOR  ${i}  IN  @{text}
        IF  '${i}'=='Profile' or '${i}'=='Classes Calendar'
            Click On The Element And Wait  //p[text()='${i}']
        ELSE IF  '${i}'=='Rewards' or '${i}'=='Coupons'
            Click On The Element And Wait  (//p[text()='${i}'])[3]
        ELSE
            Click On The Element And Wait  (//p[text()='${i}'])[2]
        END
    END

Add New List
    [Arguments]   ${list_name}=summer_list
    Click On The Element And Wait  (//p[text()='My Lists'])[2]
    Click On The Element And Wait  //*[text()='Add a List']
    Sleep  1
    Input Text And Wait  //input[@id="name"]  ${list_name}
    Click On The Element And Wait  //div[text()='Create']/parent::button
    Sleep  0.5
    ${count}  Get Element Count  //p[text()='Lists must have unique names']
    IF  ${count}>0
        Click On The Element And Wait  //div[text()='Cancel']
    END

Add New List And Verify
    [Arguments]   ${list_name}=summer_list
    Add New List  ${list_name}
    Reload Page
    Wait Until Page Contains Element  //*[text()='${list_name}']

Add Prodict To List
    [Arguments]   ${list_ame}=summer_list
    Wait Until Page Contains Element  //*[text()='Reviews']  30
    Click On The Element And Wait  //p[text()="Add to list"]
    Wait Until Element Is Enabled  //p[text()="Add to list"]/parent::button[@aria-expanded="true"]
    Click On The Element And Wait  //p[text()="${list_ame}"]/parent::*[@type="button"]
    Wait Until Page Contains       Item successfully

Verify Wish List - Favorites
    [Arguments]   ${list_ame}
    Click On The Element And Wait  (//p[text()='My Lists'])[2]
    Click On The Element And Wait  //*[text()='${list_ame}']/preceding-sibling::*
    Click On The Element And Wait  //p[text()='Manage']/../../parent::button
    Wait Until Page Does Not Contain  Delete

Verify My List And Remove
    [Arguments]   ${list_ame}=summer_list
    Click On The Element And Wait  (//p[text()='My Lists'])[2]
    Click On The Element And Wait  //*[text()='${list_ame}']
    Click On The Element And Wait  //p[text()='Add All to Cart']/../parent::button
    Wait Until Page Contains  Success
    Click On The Element And Wait  //p[text()='Share']/../parent::button
    Sleep  0.2
    Click On The Element And Wait  //h2[text()='Share']/../preceding-sibling::button
    Click On The Element And Wait  //p[text()='Manage']/../../parent::button
    Click On The Element And Wait  //p[text()='Delete']/parent::button
    Click On The Element And Wait  //div[text()='Delete']/parent::button

Verify My List Ordering
    [Arguments]   ${list_ame}=summer_list
    Click On The Element And Wait  (//p[text()='My Lists'])[2]
    Click On The Element And Wait  //*[text()='${list_ame}']
    ${sort_text_list}  Create List  Price: High to Low  Price: Low to High
    ...  Date (Newest First)  Date (Oldest First)
    FOR  ${sort}  IN  @{sort_text_list}
        Mouse Click And Wait  //p[text()='Sort by']/following-sibling::button
        Click On The Element And Wait  //p[text()='${sort}']/parent::button
    END
    Click On The Element And Wait  //div[text()='ADD TO CART']/parent::button
    Click On The Element And Wait  //div[text()='View My Cart']/parent::button

Go To My List
    [Arguments]   ${list_ame}=summer_list  ${first_name}=summer
    Go To personal information  Account  ${first_name}
    Click On The Element And Wait  (//p[text()='Account Information'])[2]
    Sleep  0.2
    Click On The Element And Wait  (//p[text()='My Lists'])[2]
    Click On The Element And Wait  //*[text()='${list_ame}']

Add Product To List
    Search Project  ${search_result}
    Verify PLP     ${search_result}
    Add Prodict To List  summer_list
    ${result}  ${item_text}  Run Keyword And Ignore Error  Get Text And Wait  //h1
    IF  '${result}'=='FAIL'
        ${item_text}  Get Text And Wait  //p[starts-with(text(), 'Item # ')]/preceding-sibling::p
    END
    Go To My List  summer_list
    wait until page contains   ${item_text}

Verify Browsing History The PDP
    Click On The Element And Wait  //a/div/p[text()='Browsing History']
    ${title}  Get Text And Wait  (//h1[text()='Browsing History']/../following-sibling::div/div)[1]//p
    Click On The Element And Wait  (//h1[text()='Browsing History']/../following-sibling::div/div)[1]//p
    Wait Until Page Contains  ${title}

Verify Browsing History And Remove
    Click On The Element And Wait  //a/div/p[text()='Browsing History']
    Wait Until Element Is Visible  //div[text()='ADD TO CART']/parent::button
    Click On The Element And Wait  //div[text()='ADD TO CART']/parent::button
    Wait Until Page Contains  Shopping cart added successfully
    Click On The Element And Wait  //div[text()='REMOVE ALL']/parent::button
    Click On The Element And Wait  //div[text()='Clear']/parent::button
    Wait Until Page Contains  No items have been browsed yet

Verify Login Status
    [Arguments]   ${name}=${firstName}
    ${result}  Run Keyword And Ignore Error  Login Status
    Go To  ${URL_MIK_profile}
    Wait Until Page Contains Element  //p[text()='${name}']  60

Login Status
    [Arguments]   ${name}=${firstName}
    ${result}  Run Keyword And Ignore Error  Wait Until Page Contains Element  //p[text()='${name}']  1
    IF  '${result[0]}'=='FAIL'
        Go To  ${URL_MIK_SIGNIN}
        Sign in  ${email}  ${password}
    END

Log Out Device
    Click On The Element And Wait  (//p[text()='Account Settings'])[2]
    Scroll Element And Wait And Click  //button[text()='Logout']
    Wait Until Page Contains  Cannot delete the device current session in used