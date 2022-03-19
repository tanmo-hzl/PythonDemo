*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Input_Msg}

*** Keywords ***
Seller Message - Input Message
    ${now_time}    Get Time
    Set Suite Variable    ${Input_Msg}    Sned Message at ${now_time}
    Input Text    //*[@id="message-input"]    ${Input_Msg}

Seller Message - Click Button Send
    Click Element    //form[@form="message-input"]/following-sibling::button
    Wait Until Element Is Visible    //p[text()="${Input_Msg}"]

Seller Message - Add Attach File
    Click Element    //form[@form="message-input"]/../following-sibling::button
    Wait Until Element Is Visible    //*[text()="Attach Media"]
    ${file_path}    Get Random Img By Project Name    MP
    Choose File    //*[text()="Photos"]/following-sibling::div//input    ${file_path}
    Wait Until Element Is Visible    //button/div/img
    Wait Until Element Is Enabled    //*[text()="Send"]/parent::button
    Click Element    //*[text()="Send"]/parent::button
    Sleep    0.2
    Log Source
    Wait Until Element Is Not Visible    //*[text()="Attach Media"]

Seller Message - Contact Buyer - Click Button Contact Buyer
    [Arguments]    ${attach_file}=${False}
    Wait Until Element Is Visible    //a[text()="Contact Buyer"]
    Click Element    //a[text()="Contact Buyer"]
    Wait Until Element Is Visible    //p[text()="Attach File"]
    Page Should Contain Element    //*[text()="How can I help you today?"]

Seller Message - Contact Buyer - Input Send Message
    [Arguments]    ${input_msg}=${True}
    IF    "${input_msg}"=="${True}"
        ${now_time}    Get Time
        Set Suite Variable    ${Input_Msg}    Sned Message at ${now_time}
        Input Text    //*[@placeholder="Ask a question..."]    ${Input_Msg}
    END

Seller Message - Contact Buyer - Click Button Send
    [Arguments]    ${is_msg_input}=${True}
    Click Element    //p[text()="Send"]
    IF     "${is_msg_input}"=="${True}"
        Wait Until Element Is Visible    //*[text()="Your message has been sent!"]
        Page Should Contain Element    //*[contains(text(),"will be in touch with you as soon as possible!")]
        Click Element    //*[text()="View Inbox"]/../parent::button
        Wait Until Element Is Visible    //h2[text()="Messages"]
        Page Should Contain Element    //p[text()="${Input_Msg}"]
    ELSE
        Wait Until Element Is Visible    //p[text()="Cannot send an empty message."]
    END

Seller Message - Contact Buyer - Add Attach File
    ${file_path}    Get Random Img By Project Name    MP
    Click Element    //p[text()="Attach File"]
    Wait Until Element Is Visible    //*[text()="Upload Media"]
    Page Should Contain Element   //*[text()="You can add up to 5 images or videos."]
    Choose File    //*[@id="upload-photo"]    ${file_path}
    Wait Until Element Is Enabled    //div[text()="Save]/parent::button
    Sleep    1
    Click Element    //div[text()="Save]/parent::button
    Wait Until Element Is Not Visible     //div[text()="Save]/parent::button
