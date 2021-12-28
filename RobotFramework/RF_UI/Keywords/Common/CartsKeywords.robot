*** Settings ***
Resource       ../../TestData/EnvData.robot


*** Keywords ***
Enter Buyer Cart Page On Home Page
    Click Element    //img[@alt="shopping cart icon header"]/../..
    Wait Until Element Is Visible    //h2[text()="Shopping Cart"]
    Sleep    1
    Wait Until Element Is Not Visible    //*[@id="stepcolors"]

Remove All Items From Cart If Existed
    Wait Until Element Is Not Visible    //*[@id="stepcolors"]
    ${count}   Get Element Count   //div[text()="Remove all Items"]
    Run Keyword If    '${count}'=='1'   Remove All Items From Cart

Remove All Items From Cart
    Click Element    //div[text()="Remove all Items"]
    Wait Until Element Is Visible      //div[text()="Yes"]/parent::button
    Sleep    1
    Page Should Contain Element     //h4[text()="Are you sure you want to remove all products from the cart?"]
    Click Element    //div[text()="Yes"]/parent::button
    Sleep    1
    Wait Until Element Is Visible     //h3[text()="(0 items)"]
    Page Should Contain Element    //h4[contains(text(),"Your shopping cart is empty")]

Quantity Increate On Shipping Cart Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"increment")]
        Sleep    1
    END

Quantity Reduce On Shipping Cart Page
    [Arguments]    ${number}=1
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    ${number}
        Click Element    //div[@role="button" and contains(@aria-label,"decrement")]
        Sleep    1
    END

Quantity Update On Shipping Cart Page
    [Arguments]    ${quantity}=1
    Clear Element Text    //input[@aria-label="Number Stepper"]
    Input Text    //input[@aria-label="Number Stepper"]    ${quantity}
    Sleep   2

Remove Items From Cart
    Click Element    //div[text()="Remove"]
    Wait Until Element Is Visible      //p[text()="Remove Product?"]
    Sleep    1
    Page Should Contain Element     //h4[text()="Are you sure you want to remove the following product from the cart?"]
    Click Element    //div[text()="Yes"]
    Sleep    1

Item Save For Later On Shipping Cart Page
    Click Element    //div[text()="Save for Later"]
    Wait Until Element Is Visible    //p[ends-with(text()," was removed from Shopping Cart.")]

