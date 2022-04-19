*** Settings ***
Resource    Common.robot
Resource    ../../TestData/Checkout/config.robot
Library     ../../Libraries/Checkout/BuyerKeywords.py
Library     ../../TestData/Checkout/GuestGenerateAddress.py


*** Keywords ***
Guest Track My Order Process
    [Arguments]      ${Extracted Number}   ${Channel Mode}   ${Mulit Store Check}    ${Place Order Total}    ${IF PIS}   ${IF MKR}   ${Refined Store Address}   ${Updated ZipCode}   ${Multiple Store Address}=None
    # Store Address For PIS MODE, Multiple Store For PISM Mode
    ${Ship Address}                 Set Variable
    ${Order Address Collection}     Create List
    ${Items Actual Added Message}   Set Variable
    ${MIK Exist}    If Mik Exist    ${Channel Mode}
    ${Track Info}     Create Dictionary    orderNumber=${Extracted Number}   lastName=${guestInfo.lastName}      emailAddress=${guestInfo.email}
    IF   '${IF PIS}' == 'PIS Only'
        Set To Dictionary	${Track Info}    lastName=${pickupInfo.lastName}
    END
    Go TO    ${Home URL}/${Track Order Suffix}
    ${Track Order Page Check}   Run Keyword And Ignore Error     Wait Until Element Is Visible      //div[text()='It seems the feature is currently unavailable']    3
    IF  '${Track Order Page Check}[0]' == 'PASS'
        Go TO    ${Home URL}/footer-nav/${Track Order Suffix}
    END
    Wait Until Element Is Visible     //h2[text()='Track Order']     ${Mid Waiting Time}
    FOR    ${key}   ${value}   IN ZIP   ${Track Info.keys()}    ${Track Info.values()}
        Input Text    //input[@id='${key}']    ${value}
    END

    Wait Until Element Is Enabled    //div[text()='TRACK ORDER']     ${Mid Waiting Time}
    Click Element                    //div[text()='TRACK ORDER']
    Sleep  2

    Wait Until Element Is Visible    //h1[text()='Track My Order']    ${Mid Waiting Time}
    ${Track Order Page Info}    Get Text            //h4[text()="Order #"]
    ${Track Page Order}         Number Extracted    ${Track Order Page Info}
    Should Be Equal             ${Track Page Order}    ${Extracted Number}

    IF  '${Mulit Store Check}' == 'Combined'
        ${Multiple Store Address}=  Evaluate   ${Multiple Store Address} + ['${Refined Store Address}']
    ELSE IF    '${Mulit Store Check}' == 'PIS'
        ${Multiple Store Address}=  Evaluate   ['${Refined Store Address}']
    END

    ${Track Page Order Total}   Get Text        //p[contains(text(),'Order Total')]/following-sibling::p
    ${Track Total Refined}      Set Variable    ${Track Page Order Total[1:]}      #${Total Display[1:]}
    Run Keyword And Warn On Failure      String Comparison     ${Track Total Refined}    ${Place Order Total}

    Run Keyword And Warn On Failure      Placed Order Should Not Contain Red Icon       ${Cart Icon Element}
    Run Keyword And Warn On Failure      Buy All Again button and Cancel Items Check    ${IF MKR}   ${MIK Exist}

    IF  '${IF PIS}' != 'PIS Only'
        ${Actual Address}    Get Text       //p[text()="Ship To"]/parent::div/following-sibling::div
        ${Actual Address}    Convert Store Address To Regular Space    ${Actual Address}
        ${Expected Address}  Join Address   ${guestInfo.addressLine1}   ${guestInfo.city}   ${guestInfo.state}   ${Updated ZipCode}
        Run Keyword And Warn On Failure    String Comparison    ${Expected Address}   ${Actual Address}
    ELSE
        ${Ship To}    Get Element Count     //*[contains(text(), "Ship To")]
        Should Be Equal As Strings    ${Ship To}    0
    END
    Run Keyword And Ignore Error   Click Element    //button[text()="view all"]
    ${Address Count}    Get Element Count   //div[text()="Get Directions"]

    FOR    ${i}    IN RANGE    ${Address Count}
        ${Order Address}    Get Text        (//div[text()="Get Directions"])[${i + 1}]/preceding-sibling::div
        ${Order Address}    Convert Store Address To Regular Space     ${Order Address}
        ${Order Address Collection}=   Evaluate    ${Order Address Collection} + ['${Order Address}']
    END
    ${Order Address Collection}      Remove Last Four Zipcode Digit    ${Order Address Collection}
    ${Multiple Store Address}   ${Order Address Collection}     Rearrange Lists     ${Multiple Store Address}   ${Order Address Collection}
    Run Keyword And Warn On Failure   Should Be Equal  ${Multiple Store Address}   ${Order Address Collection}

    ${Items In Order Summary}          Get Text    //p[contains(text(), "Subtotal")]
    ${Qty}     Number Extracted        ${Items In Order Summary}
    Wait Until Element Is Visible      //div[text()="Buy All Again"]
    Click Element                      //div[text()="Buy All Again"]
    Wait Until Element Is Visible      (//p[text()="Success"]/following-sibling::p)[1]

    ${Buy All Again}   ${Items Actual Added Message}     Run Keyword And Warn On Failure    Get Text    (//p[text()="Success"]/following-sibling::p)[1]
    Run Keyword And Warn On Failure        Buy All Again String Comparison       ${Items Actual Added Message}   ${Qty}
    Clear The Cart After Clicking Buy All Again    Guest


Placed Order Should Not Contain Red Icon
    [Arguments]    ${Cart Icon Element}
    Run Keyword And Ignore Error   Page Should Not Contain Element    ${Cart Icon Element}

Buy All Again button and Cancel Items Check
    [Arguments]    ${IF MKR}   ${MIK Exist}
    IF  '${IF MKR}' == 'MKR Only'
        Page Should Not Contain Element    //button[text()="Cancel Items"]
    ELSE IF  '${MIK Exist}' == 'YES'
        Page Should Contain Element        //button[text()="Cancel Items"]
    END
    Wait Until Element Is Visible          //div[text()="Buy All Again"]


Buy All Again String Comparison
    [Arguments]    ${Items Actual Added Message}   ${Qty}
    ${Statement}   Set Variable   items have been added to cart.
    IF  '${Qty}' == '1'
        ${Statement}   Set Variable  item has been added to cart.
    END
    Run Keyword And Ignore Error   Should Be Equal As Strings   ${Items Actual Added Message}    ${Qty} ${Statement}

Clear The Cart After Clicking Buy All Again
    [Arguments]    ${Role}
    Go To  ${Home URL}/cart
    ${Continue Shopping}  Run Keyword And Ignore Error  Wait Until Element Is Visible  //div[text()="CONTINUE SHOPPING"]    5
    IF  '${Continue Shopping}[0]' == 'FAIL'
        ${Remove Items}       Run Keyword And Ignore Error  Wait Until Element Is Visible  //p[text()="Remove All Items"]
        IF   '${Remove Items}[0]' == 'FAIL'
             AD Exception Handle   //p[text()="Remove All Items"]
        END
        AD Exception Handle              //p[text()="Remove All Items"]
        Run Keyword And Ignore Error     Wait Until Element Is Visible    //h4[text()="Are you sure you want to remove all products from the cart?"]
        AD Exception Handle              //div[text()="Yes"]
        IF  '${Role}' == 'Guest' or '${Role}' == 'GUEST'
            Run Keyword And Warn On Failure    Wait Until Page Contains Element    //h4[text()="Are you missing items?"]
        ELSE
            Run Keyword And Warn On Failure    Wait Until Page Contains Element    //h4[text()="Your shopping cart is empty"]
        END
        Run Keyword And Ignore Error    Wait Until Element Is Visible   //div[text()="CONTINUE SHOPPING"]
    END


Get Guest Track My Order info
    [Arguments]    ${order_number}   ${last_name}     ${email}
    Go To   ${Home URL}/${Track Order Suffix}
    Track Order by Order Number    ${order_number}   ${last_name}     ${email}
    Wait Until Page Contains Elements Ignore Ad   //*[text()="Track My Order"]
    Wait Until Page Contains Elements Ignore Ad   //*[text()="Order #"]
    ${tarck_order_number}   Get Text  //*[text()="Order #"]
    Should Be Equal As Strings   ${tarck_order_number[7:]}   ${order_number}


Track Order by Order Number
    [Arguments]    ${order_number}   ${last_name}     ${email}
    Wait Until Page Contains Elements Ignore Ad  //*[text()="Track Order by Order Number"]
    Click Element   //input[@id="orderNumber"]
    Press Keys      //input[@id="orderNumber"]    ${order_number}
    Click Element   //input[@id="lastName"]
    Press Keys      //input[@id="lastName"]        ${last_name}
    Click Element   //input[@id="emailAddress"]
    Press Keys      //input[@id="emailAddress"]    ${email}
    Click Element   //*[text()="TRACK ORDER"]/parent::button