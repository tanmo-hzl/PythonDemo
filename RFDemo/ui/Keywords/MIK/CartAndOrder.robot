*** Settings ***
Library        String
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot

*** Variables ***
${item_value}
${detail_page_price}

*** Keywords ***
Add Shopping Cart
    [Arguments]  ${cart_num}=1
    Verify Add Shopping Cart And Input Cart Num  ${cart_num}
    ${result}  ${detail_page_title}  Run Keyword And Ignore Error  Get Text And Wait  //h1
    IF  '${result}'=='FAIL'
        ${detail_page_title}  Get Text And Wait  //p[starts-with(text(), 'Item # ')]/preceding-sibling::p
    END
    ${detail_page_price}        Get Text And Extraction Price  (//*[starts-with(text(),'$')])[1]
    Set Suite Variable          ${detail_page_price}
    ${detail_page_num}          Get Value  //input[@aria-label="Number Stepper"]
    ${detail_page_all_price}    Evaluate  round(${detail_page_price}*${detail_page_num}, 2)
    ${product_table}  Verify Product Is MIK Or EA Or FGM
    IF  "${product_table}"=="FGM"
        ${ADD_CART_ELE}  Set Variable  //p[text()='ADD TO CART']/../parent::button
    ELSE
        ${ADD_CART_ELE}  Set Variable  //div[text()='ADD TO CART']/parent::button
    END
    Click On The Element And Wait  ${ADD_CART_ELE}
    Wait Until Element Is Enabled  //div[text()='View My Cart']/parent::button
    Sleep  0.5
    ${popup_ele}           Set Variable  //p[text()='Items added to cart!']/../../div[3]//p
    ${popup_title}         Get Text And Extraction data  (${popup_ele})[2]
    ${popup_price}         Get Text And Extraction Price   (${popup_ele})[3]
    ${popup_num}           Get Text And Extraction Data  (${popup_ele})[4]  4
    ${popup_Subtotal_num}  Get Text And Extraction Data  //p[contains(text(),'Subtotal')]  10  -7
    ${popup_all_price}     Get Text And Extraction Price   //p[contains(text(),'Subtotal')]/following-sibling::p
    ${popup_count_all_price}        Evaluate  round(${popup_price}*${popup_num}, 2)
    Should Be Equal As Strings      ${detail_page_title}  ${popup_title}
    Should Be Equal As Numbers      ${detail_page_price}  ${popup_price}
    Should Be Equal As these data   ${detail_page_num}    ${popup_num}  ${popup_Subtotal_num}
    Should Be Equal As these data   ${popup_all_price}    ${popup_count_all_price}  ${detail_page_all_price}
    Click On The Element And Wait   //div[text()='View My Cart']/parent::button
    Wait Until Page Contains Element  //p[text()='Total:']/following-sibling::h4  60
    Sleep  1

Click Cart Add and Minus
    [Arguments]  ${Add_Minus}   ${item_num}
    ${cart_num}  Get Value  (//input[@aria-label="Number Stepper"])[${item_num}]
    IF  '${Add_Minus}'=='+'
        Click On The Element And Wait  (//input[@aria-label="Number Stepper"]/following-sibling::div/*)[${item_num}]
#        ${result}  Run Keyword And Ignore Error   Wait Until Page Contains Element   (//input[@aria-label="Number Stepper" and @aria-describedby])[${item_num}]  1
#        IF  '${result[0]}'=='FAIL'
#            ${cart_num}  Evaluate  ${cart_num}+${item_value}
#        END
        ${result}  Run Keyword And Ignore Error   Wait Until Page Contains   Stock At  1
        IF  '${result[0]}'=='FAIL'
            ${cart_num}  Evaluate  ${cart_num}+${item_value}
        END
    ELSE IF  '${Add_Minus}'=='-'
        ${cart_value}  Get Value      (//input[@aria-label="Number Stepper"])[${item_num}]
        IF  ${cart_value}>1
            Click On The Element And Wait  (//input[@aria-label="Number Stepper"]/preceding-sibling::div/*)[${item_num}]
            ${cart_num}  Evaluate  ${cart_num}-${item_value}
        END
    ELSE
        Log  The ginseng error
    END
    Click On The Element And Wait  //p[text()='Total:']/following-sibling::h4
    Sleep  0.3
    ${cart_value}  Get Value      (//input[@aria-label="Number Stepper"])[${item_num}]
    Should Be Equal As Numbers    ${cart_num}  ${cart_value}
    ${all_price}  Evaluate        round(${detail_page_price}*${cart_num},2)
    ${cart_all_price}  Get Text And Extraction price  (//p[starts-with(text(),'Item: ')]/../../../../following-sibling::div//p[2])[${item_num}]
    Should Be Equal As Numbers  ${cart_all_price}  ${all_price}

Verify Cart Add and Minus
    [Arguments]  ${item_num}=1
    ${cart_num}  Get Value  (//input[@aria-label="Number Stepper"])[${item_num}]
    IF  '${cart_num}'=='999'
        Click Cart Add and Minus  -      ${item_num}
        Click Cart Add and Minus  +      ${item_num}
    ELSE
        Click Cart Add and Minus  +      ${item_num}
        Click Cart Add and Minus  -      ${item_num}
    END

Input Shopping Cart Num
    [Arguments]  ${cart_num}=6
    ${item_value}  Get Value  //input[@aria-label="Number Stepper"]
    Set Suite Variable          ${item_value}
    IF  '${item_value}'=='1'
        Log  The minimum purchase quantity is 1
    ELSE IF  ${cart_num}>${item_value}
        ${remainder}  Evaluate  ${cart_num}%${item_value}
        ${cart_num}  Evaluate  ${cart_num}-${remainder}
        Log  Item must be ordered in multiples of ${remainder}.
    ELSE
        Log  No less than the minimum purchase quantity
        ${cart_num}  Set Variable   ${item_value}
    END
    ${input_disabled}  Get Element Count  //input[@aria-label="Number Stepper" and @disabled]
    IF  '${input_disabled}'=='0'
        Input Text And Wait  //input[@aria-label="Number Stepper"]  ${cart_num}
        Sleep  1
        ${stock}  Get Element Count  //input[@aria-label="Number Stepper" and @aria-describedby]
        IF  ${stock}>0
            Log  The quantity of input exceeds the stock
        END
    ELSE
        Log  Shortage of commodity stock
    END

Remove All Shopping Cart
    Go To  ${URL_MIK_cart}
    ${result}  Run Keyword And Ignore Error   Wait Until Page Contains Element   //p[text()='Remove All Items']
    IF  '${result[0]}'=='PASS'
        Wait Until Page Contains Element  //p[text()='Total:']/following-sibling::h4  60
        Click On The Element And Wait  //p[text()='Remove All Items']
        Click On The Element And Wait  //div[text()='Yes']/parent::button
        Click On The Element And Wait  //div[text()='CONTINUE SHOPPING']/parent::button
    END

Verify Add Shopping Cart And Input Cart Num
    [Arguments]  ${cart_num}=6
    ${add_cart_disabled}  Get Element Count   //div[text()='ADD TO CART']/parent::button[@disabled]
    IF  ${add_cart_disabled}>0
        Log  Items not inventory
        Search Project  ${search_result}
        Verify PLP     ${search_result}
    END
    Input Shopping Cart Num          ${cart_num}

Save for Later
    Click On The Element And Wait  //div[text()='Save for Later']/parent::button
    Wait Until Page Contains       Save for Later
    Click On The Element And Wait  //div[text()='Move to Cart']/parent::button

Verify Shopping Cart info
    [Arguments]  ${item_len}=1
    ${Order_Summary}  Get Shoop Cart Order Summary
    ${Cart_Total}     Get Text And Extraction price  //p[text()='Total:']/following-sibling::h4
    Should Be Equal As These Data  ${Order_Summary}  ${Cart_Total}

Get Shoop Cart Order Summary
    ${order_Subtotal_price}  Get Text And Extraction price  //p[contains(text(),'Subtotal')]/following-sibling::p
    ${Savings}               Get Savings
    ${Other_Fees}            Get Other Fees
    ${Estimated_Shipping}    Get Estimated Shipping
    ${Estimated_Tax}         Get Estimated Tax
    ${order_price}  Evaluate  ${order_Subtotal_price}-${Savings}+${Other_Fees}+${Estimated_Shipping}+${Estimated_Tax}
    Return From Keyword  ${order_price}

Get Savings
    ${count}  Get Element Count  //p[text()='Savings']/following-sibling::p
    IF  ${count}>0
        ${Savings}  Get Text And Extraction Data  //p[text()='Savings']/following-sibling::p  2
    ELSE
        ${Savings}  Set Variable  0
    END
    Return From Keyword  ${Savings}

Get Other Fees
    ${count}  Get Element Count  //p[text()='Other Fees']/following-sibling::p
    IF  ${count}>0
        ${Other_Fees}  Get Text And Extraction Data  //p[text()='Other Fees']/following-sibling::p  1
    ELSE
        ${Other_Fees}  Set Variable  0
    END
    Return From Keyword  ${Other_Fees}

Get Estimated Shipping
    ${Estimated_Shipping}  Get Text  //p[text()='Estimated Shipping']/following-sibling::p
    IF  '${Estimated_Shipping}' in ['TBD','Free']
        ${Estimated_Shipping}  Set Variable  0
    ELSE
        ${Estimated_Shipping}  Get Text And Extraction Data  //p[text()='Estimated Shipping']/following-sibling::p  1
    END
    Return From Keyword  ${Estimated_Shipping}

Get Estimated Tax
    ${Estimated_Tax}  Get Text  //p[text()='Estimated Tax']/following-sibling::p
    IF  '${Estimated_Tax}' in ['TBD','Free']
        ${Estimated_Tax}  Set Variable  0
    ELSE
        ${Estimated_Tax}  Get Text And Extraction Data  //p[text()='Estimated Tax']/following-sibling::p  1
    END
    Return From Keyword  ${Estimated_Tax}

Check Out
    Wait Until Page Contains Element  //p[text()='Total:']/following-sibling::h4
    wait until page contains element  //div[text()='PROCEED TO CHECKOUT']
    Click On The Element And Wait  //div[text()='PROCEED TO CHECKOUT']/parent::button
    Wait Until Page Contains  Getting your Order
    ${info_count}  Get Element Count  //input[@id="firstName"]
    IF  ${info_count}>0
        ${info_dict}  Create Dictionary  firstName=summer  lastName=summer  addressLine1=5907 Wisdom Creek Dr
        ...  addressLine2=5907 Wisdom Creek Dr  city=Dallas  state=TX  zipCode=75249  phoneNumber=3252235680
        For dict and input text  ${info_dict}
    END
    Wait Until Page Contains  Qty
    ${Total}  Get Text And Extraction Data  //p[text()='Total:']/following-sibling::h4  1
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Click On The Element And Wait  //div[text()='Next: Payment & Order Review']/parent::button
    ${result}  Run Keyword And Ignore Error  Wait Until Page Contains  Payment Method  5
    IF  '${result[0]}'=='FAIL'
        ${count}  Get Element Count  //div[text()='Use USPS Suggestion']/parent::button
        IF  ${count}>0
            Click On The Element And Wait  //div[text()='Use USPS Suggestion']/parent::button
        END
    END
    Wait Until Page Contains       Payment Method  60
    Click On The Element And Wait  //p[text()='Paypal']
    Click On The Element And Wait  (//h3[text()='Payment Method']/parent::div//span)[1]
    Wait Until Page Contains Element  //div[text()='PLACE ORDER']/parent::button
    Click On The Element And Wait  //p[text()='Add A Gift Card']/preceding-sibling::div/*
    Click On The Element And Wait  //div[text()='PLACE ORDER']/parent::button
    Wait Until Page Contains  Order Confirmation

Go To Order History
    Mouse Over  //p[text()='summer']/../parent::button
    Click On The Element And Wait  //p[text()='Orders']

Search Order History
    [Arguments]  ${Search_order}
    Input Text And Wait  //input[@placeholder="Search"]  ${Search_order}
    Wait Until Page Contains Element    //input[@value="${Search_order}"]/following-sibling::*
    Click On The Element And Wait  //input[@value="${Search_order}"]/following-sibling::*

Verify Order History
    ${count}  Get Element Count  //div[contains(@id,"page-")]
    IF  ${count}>1
        ${order_count}  Get Element Count  //p[text()='View Details']
        IF  "${order_count}"!="10"
            Log  Order History Page Count Not Is 10
        END
        Click On The Element And Wait  (//div[contains(@id,"page-")])[${count}]
        Wait Until Page Contains  View Details
        Click On The Element And Wait  //div[contains(@id,"page-1")]
    END
    Search Order History  summer


Order History screening condition
    [Arguments]  ${from}=${null}  ${To}=${null}  ${Filter_by_Duration}=${null}  ${Sort_order}=${null}
    Click On The Element And Wait  //div[text()='Order History']/../../../following-sibling::div//button/*
#    Input Text And Wait   //p[text()='From']/following-sibling::input  ${from}
#    Input Text And Wait   //p[text()='To']/following-sibling::input    ${To}
    screening condition   ${Filter_by_Duration}
    screening condition  ${Sort_order}
    Click On The Element And Wait  //div[text()='View Results']/parent::button

screening condition
    [Arguments]   ${condition}
    IF  '${condition}'!='${null}'
        Click On The Element And Wait  //p[text()='${condition}']
    END

Order History View Details
    [Arguments]  ${num}=1
    Go To Order Details Page  ${num}
    Click On The Element And Wait  //div[text()='Buy All Again']
    Wait Until Page Contains       Success  60
    Click On The Element And Wait  //p[text()='View Receipt']
    Wait Until Page Contains       Order Date
    ${Order_Total_one}  Get Text And Extraction price  (//p[text()='Order Total'])[1]/following-sibling::p
    Scroll Element Into View  (//p[text()='Order Total'])[2]
    ${Order_Total_two}  Get Text And Extraction price  (//p[text()='Order Total'])[2]/following-sibling::p
    Should Be Equal As Numbers  ${Order_Total_one}  ${Order_Total_two}
    Scroll Element And Wait And Click  //button[@aria-label="Close"]
    Click On The Element And Wait  //p[text()='Orders']/parent::a
    Go To Order Details Page  ${num}
    Click On The Element And Wait  //a[text()='Help Center']
    Wait Until Page Contains  Customer Care

Go To Order Details Page
    [Arguments]  ${num}=1
    Click On The Element And Wait  (//p[text()='View Details'])[${num}]