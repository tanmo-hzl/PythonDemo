*** Settings ***
Documentation    To use these keywords, you need to enter the delivery truck page first
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/CheckoutClassLib.py
Resource       ../../Keywords/Common/CheckoutKeywords.robot
Resource       ../../TestData/EnvData.robot
Resource       ../../TestData/MP/ReturnData.robot

*** Variables ***
${Order_Number}
${Guest_Ele}
${Guest_Data}
${Guest_Info}

*** Keywords ***
Checkout Class - Get Class Guest Quantity
    Sleep    2
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Sleep    2
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Element Is Visible    //h2[text()="Getting your Order"]
    Wait Until Element Is Visible    //div[text()="Next: Payment & Order Review"]/parent::button
    ${Guest_Ele}    Set Variable    (//div[contains(text(),"Guest")])
    Set Suite Variable    ${Guest_Ele}    ${Guest_Ele}
    ${count}    Get Element Count    ${Guest_Ele}
    ${Guest_Data}    Get Class Guest Info    ${count}
    Set Suite Variable    ${Guest_Data}    ${Guest_Data}

Checkout Class - Input All Guest Info
    ${index}    Set Variable    1
    ${item}    Set Variable
    FOR    ${item}    IN    @{Guest_Data}
        Set Suite Variable    ${Guest_Info}    ${item}
        Checkout Class - Input FirstName By Guest Index    ${index}
        Checkout Class - Input LastName By Guest Index    ${index}
        Checkout Class - Input Email By Guest Index    ${index}
        Checkout Class - Input Phone Number By Guest Index    ${index}
        ${index}    Evaluate    ${index}+1
    END

Checkout Class - Input FirstName By Guest Index
    [Arguments]    ${index}
    Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]    ${Guest_Info}[firstName]

Checkout Class - Input LastName By Guest Index
    [Arguments]    ${index}
    Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]    ${Guest_Info}[lastName]

Checkout Class - Input Email By Guest Index
    [Arguments]    ${index}
    Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]    ${Guest_Info}[email]

Checkout Class - Input Phone Number By Guest Index
    [Arguments]    ${index}
    Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]    ${Guest_Info}[phone]


Checkout Class - Flow - Proceed To Payment To Place
    Checkout - Click Button - Proceed To Checkout
    Checkout Class - Get Class Guest Quantity
    Checkout Class - Input All Guest Info
    Checkout - Click Button - Payment & Order Review
    Checkout - Click Button - Place Order



