*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MIK/MikCommonKeywords.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot
Resource       ../../Keywords/MIK/CartAndOrder.robot

*** Variables ***


*** Keywords ***
Verify Receiving Way
    ${PLP_info}  Get PLP Or PDP page Transportation  PLP
    ${PDP_info}  Get PLP Or PDP page Transportation  PDP
    Verify_PDP_PLP_Transportation  ${PLP_info}  ${PDP_info}

Verify PDP Receiving Way
    Wait Until Page Contains Elements Ignore Ad  //h1
    Sleep  1
    ${Transportation_list}  Create List
    FOR  ${i}  IN  Pick-Up  Ship to Me  Same Day Delivery
        ${text}  Get Text To List  //div[starts-with(text(), '${i}')]
        ${result_default}  ${path}  Run Keyword And Ignore Error  Get Element Attribute   //div[starts-with(text(), '${i}')]/preceding-sibling::div/*/*[3]  d
        IF  '${i}'=='Pick-Up'
            ${text}  Create List  Store Pickup
            ${store_name}  Get Text To List  //div[starts-with(text(), '${i}')]/../following-sibling::div[2]//p
            ${inventory}   Get Text To List  //div[starts-with(text(), '${i}')]/../../following-sibling::div//span/span
            Append To List  ${Transportation_list}  ${store_name}  ${inventory}
        END
        IF  '${result_default}'=='PASS'
            ${default}  Create List  default-${text[0]}
            Append To List   ${Transportation_list}    ${default}    ${text}
        ELSE
            ${result_line}  ${line}  Run Keyword And Ignore Error  Get Element Attribute   //div[starts-with(text(), '${i}')]/preceding-sibling::div/*/*[3]  x1
            IF  '${result_default}'=='FAIL'
                Append To List  ${Transportation_list}  ${text}
            END
        END
    END
    Return From Keyword  ${Transportation_list}

Verify the Pick Up of the PLP Page
    ${ele}  Set Variable  //p[text()='Sort By']/../../../following-sibling::div[@style]//*[@title]
    Wait Until Element Is Visible  ${ele}   ${Default_wait_time}
    ${transportation}  Get Text To List     ${ele}/../../../following-sibling::div//p
    FOR  ${i}  IN  @{transportation}
        IF  'Stock at' in '${i}'
            Click On The Element And Wait  ${ele}/../../../following-sibling::div//p//i
            ${PLP_Stores_info}  Get information about Stores in your Range
            Mouse Click And Wait  //span[contains(text(), 'in Stock')]/../../../preceding-sibling::div//input/following-sibling::div/*
            Click On The Element And Wait  //div[text()='ADD TO CART']/parent::button
            Wait Until Page Contains       Shopping cart added successfully
            Exit For Loop
        END
    END
    Click On The Element And Wait  ${ele}
    Wait Until Page Contains Element  //h1
    Click On The Element And Wait  //div[starts-with(text(), 'Pick-Up')]/../../following-sibling::div//span[2]
    ${PDP_Stores_info}  Get information about Stores in your Range
    Verify_List_identical  ${PLP_Stores_info}  ${PDP_Stores_info}
    Click On The Element And Wait  //span[contains(text(), 'in Stock')]/../../../preceding-sibling::div//input/following-sibling::div/*
    Click On The Element And Wait  //div[text()='ADD TO CART']/parent::button
    Wait Until Page Contains Element  //div[text()='View My Cart']
    Remove All Shopping Cart

Get information about Stores in your Range
    Sleep  1
    ${ele}  Set Variable        //p[contains(text(), 'Stores in your Range')]/../../following-sibling::div/div/div[2]
    ${len}  Get Element Count  ${ele}
    ${ALL_info}  Create List
    FOR  ${i}  IN RANGE  1  ${len}
        ${distance}  Get Text And Wait  ((${ele})[${i}]//p)[1]
        ${inventory}  Get Text And Wait  (${ele})[${i}]//span[contains(text(), 'Stock')]
        ${store_name}  Get Text And Wait  (${ele})[${i}]//span[contains(text(), 'Open')]/..
        ${info}  Create List  ${distance}  ${inventory}  ${store_name}
        Append To List  ${ALL_info}   ${info}
    END
    Return From Keyword  ${ALL_info}

Go To Store Pickup And Verify Stock
    Click On The Element And Wait  //p[text()='Sort By']/../../../following-sibling::div[@style]//*[@title]/../../../following-sibling::div//p//i
    Verify That Pick UP Exceeds Inventory
    Click On The Element And Wait  //p[text()='Sort By']/../../../following-sibling::div[@style]//*[@title]
    Wait Until Page Contains Element  //h1
    Click On The Element And Wait  //div[starts-with(text(), 'Pick-Up')]/../../following-sibling::div//span[2]
    Verify That Pick UP Exceeds Inventory

Verify That Pick UP Exceeds Inventory
    ${Stock}  Get Text And Wait  //span[contains(text(), 'in Stock')]
    ${inventory}  splits_string_get_text  ${Stock}  ' in'
    ${num}  Evaluate  ${inventory[0]}+1
    Input Text And Wait  //span[contains(text(), 'in Stock')]/../../../preceding-sibling::div//input  ${num}
    Wait Until Page Contains  Please adjust quantity
    Click On The Element And Wait  //header//button

Get PLP Or PDP page Transportation
    [Arguments]  ${PDP_PLP}
    Set Suite Variable    ${title_ele}   //p[text()='Sort By']/../../../following-sibling::div[@style]//*[@title]
    Wait Until Page Contains Element        ${title_ele}
    ${info}  Create List
    Common - Scroll Down Until Page Contains Elements   //div[text()='SIGN UP']
    ${product_count}  Get Element Count     ${title_ele}
    FOR  ${i}  IN RANGE  1  ${product_count}+1
        IF  '${PDP_PLP}'=='PLP'
            ${Transportation}  Get PLP page Transportation  ${title_ele}  ${i}
        ELSE
            ${Transportation}  Get PDP page Transportation  ${title_ele}  ${i}
        END
        Append To List  ${info}  ${Transportation}
    END
    Return From Keyword  ${info}

Get PLP page Transportation
    [Arguments]  ${title_ele}  ${i}
    ${ele}  Set Variable  (${title_ele})[${i}]/../../../following-sibling::div
    ${transportation}  Get Text To List     ${ele}//p
    ${Colors_version}  Get Text To List     (${title_ele})[${i}]/../../preceding-sibling::div//a/p
    ${Size_version}  Get Text To List     (${title_ele})[${i}]/../../preceding-sibling::div//div/div/div
    ${PLP_Transportation}  Package_PLP_Transportation  ${transportation}  ${Colors_version}  ${Size_version}
    Return From Keyword  ${PLP_Transportation}

Get PDP page Transportation
    [Arguments]  ${title_ele}  ${i}
    Click On The Element And Wait  (${title_ele})[${i}]
    ${Transportation_list}  Verify PDP Receiving Way
    ${PDP_Transportation}  Package_PDP_Transportation  ${Transportation_list}
    Go Back
    Return From Keyword  ${PDP_Transportation}

Verify Receiving Way Screening Condition
    [Arguments]  @{Criteria}
    FOR  ${i}  IN  @{Criteria}
        IF  '${Criteria[0]}'=='Store Pickup'
            Click On The Element And Wait  //p[text()='In-Store Pickup']
        ELSE IF  '${Criteria[0]}'=='Same Day Delivery'
            Click On The Element And Wait  (//p[text()='Same Day Delivery'])[2]
        ELSE
            Click On The Element And Wait  //p[text()='Ship to Me']
        END
    END
    ${PLP_info}  Get PLP Or PDP page Transportation  PLP
    ${len}  Get Length  ${Criteria}
    IF  ${len}==1
        FOR  ${v}  IN  @{PLP_info}
            IF  "${v}[${Criteria[0]}]"=="False"
                Fail  Condition filtering is not correct
            END
        END
    ELSE IF  ${len}==2
        FOR  ${v}  IN  @{PLP_info}
            IF  "${v}[${Criteria[0]}]"=="False" and "${v}['${Criteria[1]}']"=="False"
                Fail  Condition filtering is not correct
            END
        END
    ELSE IF  ${len}==3
        FOR  ${v}  IN  @{PLP_info}
            IF  "${v}[${Criteria[0]}]"=="False" and "${v}['${Criteria[1]}']"=="False" and "${v}['${Criteria[2]}']"=="False"
                Fail  Condition filtering is not correct
            END
        END
    END
    Scroll Element And Wait And Click  //p[text()='Clear All']/../parent::button
    Wait Until Element Is Not Visible  //p[text()='Clear All']/../parent::button
    Sleep  0.5

Verify Receiving Way Nearby Stores
    Click On The Element And Wait      //p[text()='In-Store Pickup']
    Wait Until Page Contains Element  //p[text()='Clear All']/../parent::button
    ${len}  Get Element Count  //p[text()='Check nearby stores']/following-sibling::div//p
    IF  ${len}>5
        Fail  Nearby Stores more than five
    END