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

Product - Enter Product Detail Page
    [Arguments]    ${name}
    Click Element    //p[@title='${name}']
    Wait Until Element Is Visible     //div[text()="ADD TO CART"]
    Sleep    1

Product - Quantity Increate On Product Detail Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"increment")]
        Sleep    1
    END

Product - Quantity Reduce On Product Detail Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"decrement")]
        Sleep    1
    END

Product - Quantity Update On Product Detail Page
    [Arguments]    ${quantity}=1
    Wait Until Element Is Enabled    //input[@aria-label="Number Stepper"]
    Sleep    1
    Clear Element Value    //input[@aria-label="Number Stepper"]
    Input Text    //input[@aria-label="Number Stepper"]    ${quantity}
    Sleep   1

Product - Add Item To Cart On Product Detail Page
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

Product - Click Buy Now To Checkout On Product Detail Page
    Click Element    //div[text()="BUY NOW"]
    Wait Until Element Is Visible          //div[text()="Place Order"]

