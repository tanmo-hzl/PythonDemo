*** Settings ***
Resource       ../../TestData/EnvData.robot
Resource        ../../Keywords/Common/CommonKeywords.robot

*** Variables ***
${Product_Name}


*** Keywords ***
Product - Search Product By Sku
    [Arguments]    ${sku}    ${name}
    input text    //input[@aria-label="Search Input"]     ${sku}
    click button    //button[@aria-label="Search Button"]
    Wait Until Element Is Visible      //p[@title='${name}']
    Sleep    1

Product - Search Product By Product Name
    [Arguments]    ${name}
    input text    //input[@aria-label="Search Input"]     ${name}
    click button    //button[@aria-label="Search Button"]
    Wait Until Element Is Visible      //p[@title='${name}']
    Sleep    1

Product - Enter PDP
    [Arguments]    ${name}
    Click Element    //p[@title='${name}']
    Wait Until Element Is Visible     //div[text()="ADD TO CART"]
    Sleep    1

Product - Quantity Increate On PDP
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"increment")]
        Sleep    1
    END

Product - Quantity Reduce On PDP
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"decrement")]
        Sleep    1
    END

Product - Quantity Update On PDP
    [Arguments]    ${quantity}=1
    Wait Until Element Is Visible    //input[@aria-label="Number Stepper"]
    Wait Until Element Is Enabled    //input[@aria-label="Number Stepper"]
    Sleep    1
    Clear Element Value    //input[@aria-label="Number Stepper"]
    Input Text    //input[@aria-label="Number Stepper"]    ${quantity}
    Sleep   1

Product - Add Item To Cart On PDP
    Wait Until Element Is Visible    //div[text()="ADD TO CART"]/parent::button
    Wait Until Element Is Enabled    //div[text()="ADD TO CART"]/parent::button
    Click Element    //div[text()="ADD TO CART"]
    Wait Until Element Is Visible    //div[text()="View My Cart"]/parent::button
    Sleep    1

Product - Eneter Cart Page After Add Item To Cart
    Click Element    //div[text()="View My Cart"]/parent::button
    Wait Until Element Is Visible      //h2[text()="Shopping Cart"]
    Sleep    2
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]

Product - Click Buy Now To Checkout On PDP
    Click Element    //div[text()="BUY NOW"]
    Wait Until Element Is Visible          //div[text()="Place Order"]

Product - Change Selected Variant By Sku Info
    [Arguments]    ${Unique_Discount_Sku}
    ${sku}    Set Variable    ${Unique_Discount_Sku}[value]
    ${sku}    Set Variable    ${Unique_Discount_Sku}[variants]
    IF    "${sku_variants}"!="${None}"
        FOR    ${item}    IN    @{sku_variants}
            Click Element  //ul[contains(@class,"chakra-wrap__list")]//li[text()="${item}"]
            Sleep    0.5
        END
    END
    ${cur_sub_sku}    Get Text    //p[text()="Sold and shipped by"]/../../p
    ${need_sub_sku}    Set Variable    Item # ${sku}
    Should Be Equal As Strings    ${cur_sub_sku}    ${need_sub_sku}

