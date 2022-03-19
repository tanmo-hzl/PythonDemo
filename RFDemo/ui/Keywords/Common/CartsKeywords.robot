*** Settings ***
Resource       ../../TestData/EnvData.robot


*** Keywords ***
Shipping Cart - Enter Buyer Cart Page On Home Page
    ${cart_ele}    Set Variable    //*[@alt="shopping cart icon header"]/../parent::a
    Wait Until Element Is Visible    ${cart_ele}
    Wait Until Element Is Enabled    ${cart_ele}
    Click Element    ${cart_ele}
    Sleep    1
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]

Shipping Cart - Remove All Items From Cart If Existed
    Go To    ${URL_MIK}/cart
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    ${count}   Get Element Count   //*[text()="Remove All Items"]
    Run Keyword If    '${count}'=='1'   Shipping Cart - Remove All Items From Cart

Shipping Cart - Remove All Items From Cart
    Wait Until Element Is Enabled    //*[text()="Remove All Items"]
    Click Element    //*[text()="Remove All Items"]
    Wait Until Element Is Visible      //div[text()="Yes"]/parent::button
    Sleep    1
    Page Should Contain Element     //h4[text()="Are you sure you want to remove all products from the cart?"]
    Click Element    //div[text()="Yes"]/parent::button
    Sleep    1
    Wait Until Element Is Visible     //*[contains(text(),"Your shopping cart is empty")]
    Page Should Contain Element    //h4[contains(text(),"Your shopping cart is empty")]

Shipping Cart - Quantity Increate On Shipping Cart Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"increment")]
        Sleep    1
    END

Shipping Cart - Quantity Reduce On Shipping Cart Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"decrement")]
        Sleep    1
    END

Shipping Cart - Quantity Update On Shipping Cart Page
    [Arguments]    ${quantity}=1
    Clear Element Text    //input[@aria-label="Number Stepper"]
    Input Text    //input[@aria-label="Number Stepper"]    ${quantity}
    Sleep   2

Shipping Cart - Remove Items From Cart
    Click Element    //div[text()="Remove"]
    Wait Until Element Is Visible      //p[text()="Remove Product?"]
    Sleep    1
    Page Should Contain Element     //h4[text()="Are you sure you want to remove the following product from the cart?"]
    Click Element    //div[text()="Yes"]
    Sleep    1

Shipping Cart - Item Save For Later On Shipping Cart Page
    Click Element    //div[text()="Save for Later"]
    Wait Until Element Is Visible    //p[ends-with(text()," was removed from Shopping Cart.")]

Shipping Cart - Get Listing Number On Cart
    ${count}    Get Element Count    //input[@aria-label="Number Stepper"]
    [Return]    ${count}
