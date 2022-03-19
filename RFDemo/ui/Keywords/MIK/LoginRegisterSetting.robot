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
    Click On The Element And Wait  //div[text()='Sign up']/parent::button

Verify Snapmail Browser
    Wait Until Page Contains Element  (//span[text()='${email}']/../parent::a)[2]  60
    Click On The Element And Wait  (//span[text()='${email}']/../parent::a)[2]
    Wait Until Element Is Visible  //iframe[@name="preview-iframe"]
    Sleep  1
    Select Frame  //iframe[@name="preview-iframe"]
    Click On The Element And Wait  //a[text()='Verify My Email']
    Sleep  1
    ${Handles}   Get Window Handles
    Switch Window   ${Handles[1]}
    Click On The Element And Wait  //div[text()='CONTINUE SHOPPING']/parent::button

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

Go To Snapmail Browser Verify email
    Open Snapmail Browser
    ${temp_list}  splits_string_get_text  ${email}  @
    Add New Snapmail  ${temp_list[0]}
    Verify Snapmail Browser

Change password
    [Arguments]   ${current_password}  ${new_password}
    Click On The Element And Wait  (//p[text()='Account Settings'])[2]
    ${info_text}  Create Dictionary  currentPassword=${current_password}  newPassword=${new_password}
    ...  confirmPassword=${new_password}
    For dict and input text  ${info_text}
    Click On The Element And Wait  //div[text()='CHANGE PASSWORD']/parent::button
    wait until page contains  Success

verify Name And Emaile
    [Arguments]   ${Name}=summer  ${verify_email}=${email}
    ${info_text}  Create Dictionary  First Name=${Name}   Last Name=${Name}   Email Address=${verify_email}
    FOR   ${key}  ${value}  IN  &{info_text}
        ${temp_text}  Get Text And Wait  //h4[text()='${key}:']/parent::p
        Should Contain  ${temp_text}  ${value}
    END

Add New Address
    [Arguments]   ${Address_info_dict}
    Click On The Element And Wait  //div[text()='Add Shipping Address']/parent::button
    For dict and input text        ${Address_info_dict}
    Click On The Element And Wait  //div[text()='SAVE']/parent::button
    Click On The Element And Wait  //div[text()='Use USPS Suggestion']/parent::button

Add New Card
    [Arguments]   ${card_info_dict}
    Click On The Element And Wait  (//p[text()='Wallet'])[2]
    Click On The Element And Wait  //div[text()='ADD A NEW CARD']/parent::button
    For dict and input text        ${card_info_dict}
    Select From List By Value      //select[@name="state"]  TX
    Click On The Element And Wait  //div[text()='SAVE']/parent::button
    Click On The Element And Wait  //div[text()='Use USPS Suggestion']/parent::button

verify setting
    Mouse Over and wait  //p[text()='${first_name}']/../parent::button
    ${text}   Create List   Account  Orders & Purchases  Order History  Subscription  Rewards & Referrals
    ...  Rewards  Coupons  Referrals  Account Information  Profile
    FOR  ${i}  IN  @{text}
        IF  '${i}'=='Account'
            Click On The Element And Wait  //p[text()='${i}']
        ELSE IF  '${i}'=='Coupons'
            Click On The Element And Wait  //div/p[text()='${i}']
        ELSE IF  '${i}'=='Rewards'
            Click On The Element And Wait  (//p[text()='${i}'])[3]
        ELSE
            Click On The Element And Wait  (//p[text()='${i}'])[2]
        END
    END

Add New List
    [Arguments]   ${list_ame}=summer_list
    Click On The Element And Wait  (//p[text()='My Lists'])[2]
    Click On The Element And Wait  //h3[text()='Add a List']
    Sleep  1
    Input Text And Wait  //input[@id="name"]  ${list_ame}
    Click On The Element And Wait  //div[text()='Create']/parent::button
    Sleep  0.5
    ${count}  Get Element Count  //p[text()='Lists must have unique names']
    IF  ${count}>0
        Click On The Element And Wait  //div[text()='Cancel']
    END
    Wait Until Page Contains Element  //h3[text()='${list_ame}']

Add Prodict To List
    [Arguments]   ${list_ame}=summer
    Wait Until Page Contains Element  //*[text()='Reviews']  30
    Click On The Element And Wait  //p[text()="Add to list"]
    Wait Until Element Is Enabled  //p[text()="Add to list"]/parent::button[@aria-expanded="true"]
    Click On The Element And Wait  //p[text()="${list_ame}"]/parent::*[@type="button"]
    Wait Until Page Contains       Item successfully

Go To My List
    [Arguments]   ${list_ame}=summer  ${first_name}=summer
    Go To personal information  Account  ${first_name}
    Click On The Element And Wait  (//p[text()='Account Information'])[2]
    Click On The Element And Wait  (//p[text()='My Lists'])[2]
    Click On The Element And Wait  //h3[text()='${list_ame}']

Add Product To List And Verify Browsing History
    Go To   ${URL_MIK}
    Search Project  ${search_result}
    Verify PLP     ${search_result}
    Add Prodict To List  summer_list
    ${result}  ${item_text}  Run Keyword And Ignore Error  Get Text And Wait  //h1
    IF  '${result}'=='FAIL'
        ${item_text}  Get Text And Wait  //p[starts-with(text(), 'Item # ')]/preceding-sibling::p
    END
    Go To My List  summer_list
    wait until page contains   ${item_text}
    Click On The Element And Wait  //a/div/p[text()='Browsing History']
    wait until page contains   ${item_text}

Verify Login Status
    ${result}  Run Keyword And Ignore Error  Login Status
    IF  '${result[0]}'=='FAIL'
        Sign Up
        Go To Snapmail Browser Verify email
        Go To  ${URL_MIK_SIGNIN}
        Sign in  ${email}  ${password}
    END

Login Status
    ${result}  Run Keyword And Ignore Error  Wait Until Page Contains Element  //p[text()='${firstName}']  1
    IF  '${result[0]}'=='FAIL'
        Go To  ${URL_MIK_SIGNIN}
        Sign in  ${email}  ${password}
    END