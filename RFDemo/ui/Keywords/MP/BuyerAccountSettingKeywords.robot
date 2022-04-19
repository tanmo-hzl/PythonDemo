*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${BUYER_NAME}
${Card_Info}
${Address_Info}

*** Keywords ***
Buyer - Profile - Update - Profile
    [Arguments]    ${fname}    ${lname}
    Click Element    //*[contains(@class,"icon-tabler-edit")]
    CLear Element Value    //*[@id="firstName"]
    Input Text    //*[@id="firstName"]    ${fname}
    CLear Element Value    //*[@id="lastName"]
    Input Text    //*[@id="lastName"]    ${lname}
    ${phone}    Evaluate    str(666)+str(random.randint(200,999))+str(random.randint(1000,9999))
    CLear Element Value    //*[@id="mobilePhone"]
    Input Text    //*[@id="mobilePhone"]    ${phone}

Buyer - Profile - Address - Enter Manage Address Page
    ${count}    Get Element Count    //p[text()="Manage Address"]/parent::button
    IF    ${count}==1
        Click Element    //p[text()="Manage Address"]/parent::button
        Wait Until Element Is Visible    //h2[text()="Manage Addresses"]
    END

Buyer - Profile - Address - Add A New Address
    Wait Until Page Contains Element    //div[text()="Add Shipping Address"]
    Scroll Element Into View    //div[text()="Add Shipping Address"]
    Click Element    //div[text()="Add Shipping Address"]/parent::button
    Wait Until Element Is Visible    //header/p[text()="Add New Address"]
    Sleep    3
    Buyer - Profile - Address - Input Address Info
    Click Element    //div[text()="SAVE"]/parent::button
    Sleep    1
    Buyer - Profile - Verify Address

Buyer - Profile - Address - Input Address Info
    Input Text    //*[@placeholder="First Name"]    ${BUYER_NAME}
    Input Text    //*[@placeholder="Last Name"]    ${Address_Info}[lastName]
    Input Text    //*[contains(@name,"addressLine1")]    ${Address_Info}[address1]
    Input Text    //*[contains(@name,"addressLine2")]    ${Address_Info}[address2]
    Input Text    //*[contains(@name,"city")]    ${Address_Info}[city]
    Input Text    //*[contains(@name,"state")]    ${Address_Info}[state]
    Input Text    //*[contains(@name,"zipCode")]    ${Address_Info}[zipcode]
    Input Text    //*[contains(@name,"phoneNumber")]    ${Address_Info}[phone]

Buyer - Profile - Address - Clear Address Info
    Clear Element Value    //*[@placeholder="First Name"]
    Clear Element Value    //*[@placeholder="Last Name"]
    Clear Element Value    //*[contains(@name,"addressLine1")]
    Clear Element Value    //*[contains(@name,"addressLine2")]
    Clear Element Value    //*[contains(@name,"city")]
    Clear Element Value    //*[contains(@name,"state")]
    Clear Element Value    //*[contains(@name,"zipCode")]
    Clear Element Value    //*[contains(@name,"phoneNumber")]

Buyer - Profile - Address - Verify Address
    ${count}    Get Element Count    //header//p[text()="Verify Address"]
    IF   ${count}>0
        Click Element    //div[text()="SAVE"]/parent::button
    END
    Wait Until Element Is Not Visible    //header//p[text()="Verify Address"]

Buyer - Profile - Address - Edit Address By Index
    [Arguments]    ${index}=1
    Click Element     //*[text()="Edit Profile"]
    ${count}    Get Element Count    (//*[contains(@class,"icon-tabler-pencil")]/parent::button)
    Wait Until Element Is Visible    (//*[contains(@class,"icon-tabler-pencil")]/parent::button)
    Click Element    (//*[contains(@class,"icon-tabler-pencil")]/parent::button)[${index}]
    Wait Until Element Is Visible    //header//p[text()="Edit Address"]
    Buyer - Profile - Address - Clear Address Info
    Buyer - Profile - Address - Input Address Info
    Click Element    //div[text()="SAVE"]/parent::button
    Sleep    1
    Buyer - Profile - Verify Address

Buyer - Profile - Verify Address
    ${count}    Get Element Count    //header//p[text()="Verify Address"]
    IF   ${count}>0
        Click Element    //div[text()="SAVE"]/parent::button
    END
    Wait Until Element Is Not Visible    //header//p[text()="Verify Address"]
#    Wait Until Element Is Visible    //*[contains(text(),"Success")]

Buyer - Profile - Address - Remove Address By Index
    [Arguments]    ${index}=1
    Scroll Element Into View    //*[text()="Edit Profile"]
    Click Element     //*[text()="Edit Profile"]
    ${count}    Get Element Count    (//*[contains(@class,"icon-tabler-trash")])
    IF    ${count}<3
        #Capture Page Screenshot    filename=EMBED
        Skip    The address list less than 3
    END
    Click Element    (//*[contains(@class,"icon-tabler-trash")])[${index}]
    Wait Until Element Is Visible    //header//p[contains(text(),"Remove Address")]
    Click Element    //div[text()="Delete"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="Delete"]/parent::button
    Sleep   5

Buyer - Profile - Address - Set Default Address By Index
    [Arguments]    ${index}=1
    Click Element     //*[text()="Edit Profile"]
    Click Element     (//*[text()="MANAGE SHIPPING ADDRESS"]/following-sibling::div)[${index}]//*[@type="button"]

Buyer - Account Setting - Update - Input Current Password
    [Arguments]    ${old_password}
    input text    //*[@id="currentPassword"]    ${old_password}

Buyer - Account Setting - Update - Input New Password
    [Arguments]    ${new_password}
    input text    //*[@id="newPassword"]    ${new_password}
    input text    //*[@id="confirmPassword"]   ${new_password}

Buyer - Account Setting - Save - Click Change Password
    Wait Until Element Is Visible    //*[@id="change-password-form"]/button/div
    click element    //div[text()="CHANGE PASSWORD"]/parent::button
    Sleep   1
    Wait Until Element Is Visible   //*[contains(text(),"Success")]
    Wait Until Element Is Not Visible   //*[contains(text(),"Success")]

Buyer - Profile - Update Profile - Click Button Save
    Click Element    //*[text()="Save"]/parent::button
    Wait Until Element Is Not Visible     //*[@role="dialog"]//div[text()="SAVE"]/parent::button

Buyer - Wallet - Add A New Card
    Wait Until Element Is Visible    //div[contains(text(),"ADD")]/parent::button
    ${new_count}    Get Element Count    //div[text()="ADD A NEW CARD"]/parent::button
    IF   '${new_count}'=='1'
        Buyer - Wallet - Add Card Flow
    ELSE
        Pass Execution    This account have card, so skip.
    END

Buyer - Wallet - Add Card Flow
    ${Card_Info}    Get Card Info    ${True}
    Set Suite Variable    ${Card_Info}    ${Card_Info}
    Buyer - Wallet - Click Add A New Card or Additonal Card
    Buyer - Wallet - Input Card Infor
    Buyer - Wallet - Input Billing Address
    Buyer - Wallet - Set Default Payment
    Buyer - Wallet - Save Card Info

Buyer - Wallet - Click Add A New Card or Additonal Card
    Wait Until Element Is Visible    //div[contains(text(),"ADD")]/parent::button
    ${new_count}    Get Element Count    //div[text()="ADD A NEW CARD"]/parent::button
    IF   '${new_count}'=='1'
        Click Element   //div[text()="ADD A NEW CARD"]/parent::button
    ELSE
        Click Element   //p[text()="Add Additional Card"]/parent::button
    END
#    Click Element   //p[text()="Add Additional Card"]/parent::button
    Wait Until Element Is Visible    //header//p[text()="Add New Card"]

Buyer - Wallet - Input Card Infor
    ${card}    Get Json Value    ${Card_Info}    card
    Input Text    //*[@name="cardHolderName"]    ${card}[cardName]
    Input Text    //*[@name="bankCardNickName"]    ${card}[nickName]
    Input Text    //*[@name="cardNumber"]    ${card}[cardNumber]
    Press Keys    //*[@name="expirationDate"]    ${card}[expirationDate]
    Press Keys    //*[@name="cvv"]    ${card}[cvv]

Buyer - Wallet - Input Billing Address
    ${address}    Get Json Value    ${Card_Info}    address
    Input Text    //*[@name="firstName"]    ${BUYER_NAME}
    Input Text    //*[@name="lastName"]    ${address}[lastName]
    Input Text    //*[@name="addressLine1"]    ${address}[address1]
    Input Text    //*[@name="addressLine2"]    ${address}[address2]
    Input Text    //*[@name="city"]    ${address}[city]
    Select From List By Value    //*[@name="state"]    ${address}[state]
    Input Text    //*[@name="zipCode"]    ${address}[zipcode]
    Input Text    //*[@name="phoneNumber"]    ${address}[phone]

Buyer - Wallet - Set Default Payment
    ${default_payment}    Get Element Count    //*[@name="saveDefaultPayment"]
    IF   '${default_payment}'=='1'
        Click Element   //*[@name="saveDefaultPayment"]
    END

Buyer - Wallet - Save Card Info
    [Arguments]    ${sure}=${True}
    Wait Until Element Is Visible    //div[text()="SAVE"]/parent::button
    IF    '${sure}'=='${True}'
        Click Element    //div[text()="SAVE"]/parent::button
        Wait Until Element Is Not Visible    //div[text()="CANCEL"]/parent::button
        Sleep    1
        Buyer - Wallet - Verify Address
    ELSE
        Click Element    //div[text()="CANCEL"]/parent::button
        Wait Until Element Is Not Visible    //div[text()="SAVE"]/parent::button
    END

Buyer - Wallet - Verify Address
    ${count}    Get Element Count    //header//p[text()="Verify Address"]
    IF   ${count}>0
        Click Element    //div[text()="SAVE"]/parent::button
    END
    Wait Until Element Is Not Visible    //header//p[text()="Verify Address"]
    Wait Until Element Is Visible    //*[contains(text(),"Success")]

Buyer - Wallet - Click Edit By Index
    [Arguments]    ${index}=1
    ${count}    Get Element Count    //p[text()="Edit"]/../parent::button
    IF   ${count}>0
        Reload Page
        Wait Until Element Is Visible    (//p[text()="Expiration"]/../following-sibling::div/button)
    END
    ${count}   Get Element Count    (//p[text()="Expiration"]/../following-sibling::div/button)
    IF   ${count}==0
        #Capture Page Screenshot    filename=EMBED
        Skip    There ara no card to edit on wallet!
    END
    IF   ${count}<${index}
        ${new_index}    Set Variable    ${count}
    ELSE
        ${new_index}    Set Variable    ${index}
    END
    Click Element    (//p[text()="Expiration"]/../following-sibling::div/button)[${new_index}]
    Wait Until Element Is Visible    //p[text()="Edit"]/../parent::button
    Click Element    //p[text()="Edit"]/../parent::button
    Wait Until Element Is Visible    //header//p[text()="Edit Card"]

Buyer - Wallet - Update Card Infor
    ${card}    Get Json Value    ${Card_Info}    card
    Clear Element Value    //*[@name="cardHolderName"]
    Input Text    //*[@name="cardHolderName"]    ${card}[cardName]
    Clear Element Value    //*[@name="bankCardNickName"]
    Input Text    //*[@name="bankCardNickName"]    ${card}[nickName]
    Clear Element Value    //*[@name="expirationDate"]
    Press Keys    //*[@name="expirationDate"]    ${card}[expirationDate]

Buyer - Wallet - Update Billing Address
    ${address}    Get Json Value    ${Card_Info}    address
    Clear Element Value    //*[@name="firstName"]
    Clear Element Value    //*[@name="lastName"]
    Input Text    //*[@name="firstName"]    ${BUYER_NAME}
    Input Text    //*[@name="lastName"]    ${address}[lastName]
    Clear Element Value    //*[@name="addressLine1"]
    Clear Element Value    //*[@name="addressLine2"]
    Input Text    //*[@name="addressLine1"]    ${address}[address1]
    Input Text    //*[@name="addressLine2"]    ${address}[address2]
    Clear Element Value    //*[@name="city"]
    Clear Element Value    //*[@name="zipCode"]
    Clear Element Value    //*[@name="phoneNumber"]
    Input Text    //*[@name="city"]    ${address}[city]
    Select From List By Value    //*[@name="state"]    ${address}[state]
    Input Text    //*[@name="zipCode"]    ${address}[zipcode]
    Input Text    //*[@name="phoneNumber"]    ${address}[phone]

Buyer - Wallet - Remove Card By Index
    [Arguments]    ${index}=1
    ${count}    Get Element Count    //p[text()="Edit"]/../parent::button
    IF   ${count}>0
        Reload Page
        Wait Until Element Is Visible    (//p[text()="Expiration"]/../following-sibling::div/button)
    END
    ${count}   Get Element Count    (//p[text()="Expiration"]/../following-sibling::div/button)
    IF   ${count}==0
        #Capture Page Screenshot    filename=EMBED
        Skip    There ara no card to edit on wallet!
    END
    IF   ${count}==1
        #Capture Page Screenshot    filename=EMBED
        Skip    There ara only one card on wallet, don't remove!
    END
    IF   ${count}<${index}
        ${new_index}    Set Variable    ${count}
    ELSE
        ${new_index}    Set Variable    ${index}
    END
    Click Element    (//p[text()="Expiration"]/../following-sibling::div/button)[${new_index}]
    Wait Until Element Is Visible    //p[text()="Remove"]/../parent::button
    Click Element    //p[text()="Remove"]/../parent::button
    Wait Until Element Is Visible    //header//p[text()="Remove Payment Method"]
    Click Element    //div[text()="Confirm"]/parent::button
    Wait Until Element Is Not Visible    //header//p[text()="Remove Payment Method"]
    Wait Until Element Is Visible    //*[contains(text(),"Success")]





