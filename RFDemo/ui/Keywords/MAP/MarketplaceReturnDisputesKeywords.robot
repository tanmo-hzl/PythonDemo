*** Settings ***
Library         ../../Libraries/MAP/MichaelsDisputeLib.py
Resource        ../../Keywords/Common/MapCommonKeywords.robot
Resource        ../../Keywords/Common/CommonKeywords.robot

*** Variables ***
${Dispute_ID}
${loading_ele}    //div[contains(@class,"ant-spin-spinning")]
${Cur_Dispute_ID}
@{Decisions}    Full Refund    Partily Refund    Reject Refund
${Decitons_Info}

*** Keywords ***
MAP - Disputes - Search By Value
    [Arguments]    ${search_value}
    Input Text    //h2[text()="Return Disputes"]/following-sibling::div/span//input    ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
    Sleep    2

MAP - Disputes - Clear Search Value
    ${clear_ele}    Set Variable    //h2[text()="Return Disputes"]/following-sibling::div/span//input/following-sibling::span/span
    ${count}    Get Element Count    ${clear_ele}
    IF    "${count}"=="1"
        Click Element    ${clear_ele}
#        Wait Until Element Is Visible    ${loading_ele}
        Sleep    0.5
        Wait Until Element Is Not Visible    ${loading_ele}
    END

MAP - Disputes - Search By Status
    [Documentation]    Escalated,Escalation In Review,Resolved
    [Arguments]    ${status}=Escalated
    Click Element    //*[@id="horizontal-filters_status"]
    Wait Until Element Is Visible    //div[text()="Resolved"]
    Click Element    //div[text()="${status}"]/..
#    Wait Until Element Is Visible    ${loading_ele}
    Sleep    0.5
    Wait Until Element Is Not Visible    ${loading_ele}

MAP - Disputes - Check Escalated Order Existed
    ${count}    Get Element Count    //table//tbody//div[text()="No Data"]
    IF    '${count}'=='1'
        #Capture Page Screenshot    filename=EMBED
        Skip     there are no escalated order!
    END

MAP - Disputes - View Dispute Detail By Index
    [Arguments]    ${index}=1
    ${index}   Evaluate    ${index}+1
    ${Cur_Dispute_ID}    Get Text    //table//tbody//tr[${index}]//td[1]/span
    Set Suite Variable    ${Cur_Dispute_ID}    ${Cur_Dispute_ID}
    Wait Until Element Is Visible    //table//tbody//tr[${index}]//td[1]/span
    Click Element    //table//tbody//tr[${index}]//td[1]/span
    Wait Until Element Is Visible    //div[text()="Dispute"]
    Wait Until Element Is Visible    //div[text()="${Cur_Dispute_ID}"]
    Wait Until Element Is Not Visible    ${loading_ele}
    Wait Until Element Is Visible    //h4[text()="Report Information"]
    Wait Until Page Contains Element    //div[text()="Dispute Summary"]/parent::button
    Sleep    2

MAP - Disputes - Close Dispute Detail By Dispute ID
    [Arguments]    ${dispute_id}
    Wait Until Element Is Visible    //div[text()="${dispute_id}"]/../following-sibling::div/*
    Click Element    //div[text()="${dispute_id}"]/../following-sibling::div/*

MAP - Disputes Detail - Click Dispute Summary
    Scroll Last Button Into View
    Click Element     //div[text()="Dispute Summary"]/parent::button
    Wait Until Element Is Visible    //p[text()="Associated Orders"]

MAP - Disputes Detail - Click Review Escalation
    Scroll Last Button Into View
    ${count}    Get Element Count    //p[text()="Escalated"]
    ${power_count}    Get Element Count    //div[text()="Review Escalation"]/parent::button
    IF    ${power_count}==0
        Skip    This account no power to Review Escalation
    END
    IF    '${count}'=='1'
        Scroll Element Into View    //div[text()="Review Escalation"]/parent::button
        Click Element    //div[text()="Review Escalation"]/parent::button
        Wait Until Element Is Not Visible    //div[text()="Review Escalation"]/parent::button
        Wait Until Element Is Visible    //div[text()="Provide Adjudication"]/parent::button
    END

MAP - Disputes Detail - Click Provide Adjudication
    Scroll Last Button Into View
    ${power_count}    Get Element Count    //div[text()="Provide Adjudication"]/parent::button
    IF    ${power_count}==0
        Skip    This account no power to Provide Adjudication
    END
    Wait Until Element Is Visible    //div[text()="Provide Adjudication"]/parent::button
    Click Element    //div[text()="Provide Adjudication"]/parent::button
    Wait Until Element Is Visible    //h4[text()="Provide Adjudication"]

MAP - Disputes Adjudication - Get Adjudication Info
    Wait Until Element Is Visible    //table//tbody//tr
    ${line_count}    Get Element Count    //table//tbody//tr
    ${line_count}    Evaluate    ${line_count}+1
    ${items_info}    Create List
    ${index}    Set Variable
    FOR    ${index}    IN RANGE    1    ${line_count}
        ${name}    Get Text    //table//tbody//tr[${index}]/td[1]//p
        ${amount}    Get Value   //table//tbody//tr[${index}]/td[4]//input
        ${item}    Create Dictionary    name=${name}    amount=${amount}
        Append To List    ${items_info}    ${item}
    END
    ${Decitons_Info}    Get Michaels Decision Info    ${items_info}
    Set Suite Variable    ${Decitons_Info}    ${Decitons_Info}

MAP - Disputes Adjudication - Set Michaels Adjudication For Items
    ${item}    Set Variable
    ${index}    Set Variable    1
    ${Deciton_List}    Get Json Value    ${Decitons_Info}    decision
    FOR    ${item}    IN    @{Deciton_List}
        MAP - Disputes Adjudication - Select Decision    ${item}[decision]    ${index}
        MAP - Disputes Adjudication - Input Amount    ${item}[amount]    ${index}
        MAP - Disputes Adjudication - Input Reason    ${item}[reason]    ${index}
        ${index}    Evaluate    ${index}+1
    END
    MAP - Disputes Adjudication - Set Refund Shipping And Handling Free    ${Decitons_Info}[refundShippingFree]

MAP - Disputes Adjudication - Select Decision
    [Arguments]    ${decision}    ${index}=1
    Wait Until Element Is Visible    //table//tbody/tr[${index}]/td[2]//input/..
    Click Element    //table//tbody/tr[${index}]/td[2]//input/..
    Wait Until Element Is Visible    (//div[text()="${decision}"])[${index}]
    Sleep    0.5
    Click Element    (//div[text()="${decision}"])[${index}]
    Sleep    1
    Wait Until Element Is Not Visible    (//div[text()="${decision}"])[${index}]

MAP - Disputes Adjudication - Input Amount
    [Arguments]    ${amount}    ${index}=1
    IF    "${amount}"!="0"
        Wait Until Element Is Enabled    //table//tbody//tr[${index}]/td[4]//input
        Clear Element Value    //table//tbody//tr[${index}]/td[4]//input
        Input Text    //table//tbody//tr[${index}]/td[4]//input    ${amount}
    END

MAP - Disputes Adjudication - Input Reason
    [Arguments]    ${reason}    ${index}=1
    Input Text    //table//tbody/tr[${index}]/td[6]//input    ${reason}

MAP - Disputes Adjudication - Set Refund Shipping and Handling Free
    [Arguments]    ${refund}=${True}
    ${base_ele}    Set Variable    //span[text()="Refund Shipping & Handling Fee"]/parent::label
    ${count}    Get Element Count    ${base_ele}/span\[contains(@class,"Mui-checked")\]
    IF    '${count}'=='0' and '${refund}'=='${True}'
        Click Element    ${base_ele}
    ELSE IF    '${count}'=='1' and '${refund}'=='${False}'
        Click Element    ${base_ele}
    END

MAP - Disputes Adjudication - Select I Acknowledge
    [Arguments]    ${selected}=${True}
    ${base_ele}    Set Variable    //span[starts-with(text(),"I acknowledge that")]/parent::label
    ${count}    Get Element Count    ${base_ele}/span\[contains(@class,"Mui-checked")\]
    IF    '${count}'=='0' and '${selected}'=='${True}'
        Click Element    ${base_ele}
    ELSE IF    '${count}'=='1' and '${selected}'=='${False}'
        Click Element    ${base_ele}
    END

MAP - Disputes - Click Back
    Scroll Last Button Into View
    Click Element    //div[text()="Back"]/parent::button
    Wait Until Element Is Visible    //h4[text()="Report Information"]

MAP - Disputes Adjudication - Click Submit
    Scroll Last Button Into View
    Click Element    //div[text()="Submit"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="Submit"]/parent::button
    Wait Until Element Is Visible    //p[text()="Resolved"]



