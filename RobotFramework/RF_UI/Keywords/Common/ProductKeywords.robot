*** Settings ***
Resource       ../../TestData/EnvData.robot

*** Keywords ***
Search Product By Sku
    [Arguments]    ${sku}    ${name}
    input text    //input[@aria-label="Search Input"]     ${sku}
    click button    //button[@aria-label="Search Button"]
    Wait Until Element Is Visible      //p[@title='${name}']
    Sleep    1

Enter Product Detail Page
    Click Element    //p[@title='Watercolor Paper Pad by Recollections®, 12" x 12"']
    Wait Until Element Is Visible     //div[text()="ADD TO CART"]
    Sleep    1

Quantity Increate On Product Detail Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"increment")]
        Sleep    1
    END

Quantity Reduce On Product Detail Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"decrement")]
        Sleep    1
    END

Quantity Update On Product Detail Page
    [Arguments]    ${quantity}=1
    clear element text    //input[@aria-label="Number Stepper"]
    input text    //input[@aria-label="Number Stepper"]    ${quantity}
    Sleep   2

Add Item To Cart On Product Detail Page
    Click Element    //div[text()="ADD TO CART"]
    Wait Until Element Is Visible    //div[text()="View My Cart"]
    Sleep    2

Eneter Cart Page After Add Item To Cart
    Click Element    //div[text()="View My Cart"]
    Wait Until Element Is Visible      //h2[text()="Shopping Cart"]
    Sleep    2
    Wait Until Element Is Not Visible    //*[@id="stepcolors"]

Click Buy Now To Checkout On Product Detail Page
    Click Element    //div[text()="BUY NOW"]
    Wait Until Element Is Visible          //div[text()="Place Order"]

