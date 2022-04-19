*** Settings ***
Resource   ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource   ../../Keywords/Checkout/VerifyCartKeywords.robot
Resource   ../../Keywords/Checkout/GuestBUsinessKeywords.robot
Resource   ../../Keywords/Checkout/PopupMessageKeywords.robot
Resource   ../../Keywords/Checkout/VerifyPaymentKeywords.robot
Library     ../../Libraries/MailManager.py
Suite Setup   Run Keywords     initial env data2
#Test Setup    Run Keywords     Login    ${account_info["user"]}    ${account_info["password"]}
#...            AND    clear cart
##...            AND    Select Store If Needed    ${Initial Store Name}

Test Teardown   Run Keywords     Clear Cart    AND     close browser

*** Variables ***
&{account_info}    user=autoCpmUi6@xxxhi.cc    password=Password123
...            first_name=autoui     last_name=zhang     address=2901 Rio Grande Blvd,Euless,TX,76039-1339
...     		   phone=619-876-5675    email=autoCpmUi6@xxxhi.cc

#&{account_info1}    user=autoCpmUi3@xxxhi.cc    password=Password123
#...            first_name=autoui     last_name=zhang     address=2901 Rio Grande Blvd,Euless,TX,76039-1339
#...     		   phone=619-876-5675    email=autoCpmUi1@xxxhi.cc
&{store2_info}     zipcode=76039   store_name=Glade Parks

&{billAddress}    firstName=MO
...               lastName=DD
...               addressLine1=2435 Marfa Ave
...               city=Dallas
...               state=TX
...               zipCode=75216
...               phoneNumber=469-779-6009
&{billAddress1}    firstName=MO
...               lastName=DD
...               addressLine1=2701 Rio Grande Blvd
...               city=Euless
...               state=TX
...               zipCode=76039
...               phoneNumber=469-779-6009
&{creditInfo}   cardHolderName=JOHN BELL
...             cardNumber=5155718238074354
...             expirationDate=10/23
...             cvv=123
&{creditInfo1}   cardHolderName=JOHN BELLb
...             cardNumber=5155718238074354
...             expirationDate=10/23
...             cvv=123


*** Test Cases ***
1.[Class]- all buy and 1 mik online class to checkout
    [Documentation]   [CP-3462][Class] - all- buy 1 mik  STH and 1 mik pickup and 1 mik  SDD and 1 FGM  and 1 EA and 1 mik online class to checkout
    [Tags]   full-run      yitest1
    [Setup]  Run Keywords    Login    ${account_info["user"]}    ${account_info["password"]}
    ...            AND    clear cart
#    ...            AND    Change Store From Pdp Page-v2    MacArthur Park     75063
#    ...            AND    Set Test Variable   {store2_info}
#    [Template]   Buyer Checkout Work Flow
    ${login_slide_user}      Create Dictionary      email=Guest               password=Password123
    Set Test Variable   ${delivering_zipCode_shipping}    ${EMPTY}
    PBF-Guest-Sign in-checkout      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}
    ...    MIK|listing|${PIS[0]}|1|ATC|PIS|75063_1_MacArthur Park
    ...    MIK|listing|${SDD[0]}|1|ATC|SDD|Glade Parks,76039
    ...    MIK|listing|${MIK[1]}|1|ATC|STM|${EMPTY}
    ...    MKP|listing|${MKP[0]}|1|ATC|STM|${EMPTY}
    ...    MKR|listing|${MKR[0]}|1|ATC|STM|${EMPTY}
    ...    MIK|class|${MIK CLASS[0]}|1|ACTC|STM|${EMPTY}
    ...    Add To Cart       Credit Card     payment_order=true    Verfiy Point=false

2.[Class] - Order of the products in Checkout page is the same as payment page
    [Documentation]  [CP-2945][Class] - Order of the products in Checkout page is the same as payment page
    [Tags]   full-run     yitest
    [Setup]  Run Keywords     Login    ${account_info["user"]}    ${account_info["password"]}
...            AND    clear cart
    ${product_list}     Create List     MIK|class|${MIK CLASS[0]}|1|ACTC|STM|${EMPTY}     Add To Cart      Credit Card
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Click Proceed To Checkout Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Page Contains Element     //h2[text()="Getting your Order"]
    Wait Until Element Is Visible   //h2[text()="Getting your Order"]
    Wait Until Element Is Visible    //h3[text()="Order Summary"]
#    select tax address    ${ship_address}
    Wait Until Element Is Visible   //div[text()="Next: Payment & Order Review"]
    ${order_product_data}    get class item info
    Checkout Class - Input All Guest Info       ${PRODUCT_INFO_LIST}
    Click Element  //div[text()="Next: Payment & Order Review"]
#    Ignore Default Shipping Info IN None
#    Sleep  10
    Wait Until Element Is Visible   //div[text()="PLACE ORDER"]
    ${payment_product_data}    get class item info
    Should Be Equal    ${order_product_data}    ${payment_product_data}


3.[Class] - Cart - the calss date and time should be the same as PDP
    [Documentation]   [CP-3040][Class] - Cart - the calss date and time should be the same as PDP
    [Tags]   full-run     yitest
    [Setup]  Run Keywords      Open Browser   ${Home URL}    ${BROWSER}    AND    Maximize Browser Window
#    Login    ${account_info["user"]}    ${account_info["password"]}
...            AND    clear cart

    ${product_list}     Create List     MIK|class|${MIK CLASS[0]}|1|ACTC|STM|${EMPTY}     Add To Cart      Credit Card
    Select Products and Purchase Type     ${product_list}
    ${pdp_class_time}    pdp class time
    Click View My Cart Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    ${cart_class_info}      cart class product info
    Should Not Be Equal As Strings   ${pdp_class_time[0:14]},2022        ${cart_class_info["item_date"]}
    Should Not Be Equal As Strings   ${pdp_class_time[-25:-16]} to ${pdp_class_time[-15:]}        ${cart_class_info["item_time"]}


4.[Class]-Cart-click "Classname"should link to pdp page,url correct
    [Documentation]   [CP-3043]Cart-click "Classname"should link to"https://mik.{environ}.platform.michaels.com/class/{event name}-{schdule id}-{event id}
    [Setup]    Run Keywords    Open Browser   ${Home URL}    chrome    AND    Maximize Browser Window
    [Tags]    full-run   yitest
    ${product_list}     Create List     MIK|class|${MIK CLASS[0]}|1|ACTC|STM|${EMPTY}     Add To Cart      Credit Card
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Click Element   (//p[@class="productName css-1ouddpy"])[1]/a
    Wait Until Page Contains Element     //*[text()="Add Class to Cart"]
    ${class_url}    Get Location
    Location Should Be   ${Home URL}/${MIK CLASS[3]}

5.[Class]-Book class only- TAX is calculated from the address in the credit card
    [Documentation]   [CP-3125]Book class only- TAX is calculated from the address in the credit card.
    ...               The tax is different according to the address of the bank card
    [Setup]   Run Keywords     Login    ${account_info["user"]}    ${account_info["password"]}
    ...         AND     Clear Cart
#    [Teardown]    Run Keywords     Clear Cart    AND    Close Browser
    [Tags]    full-run      yitest
    ${product_list}     Create List     MIK|class|${MIK CLASS[0]}|1|By|STM|${EMPTY}     Buy Now    Credit Card
    Select Products and Purchase Type     ${product_list}
    Sleep  1
    ${tax}    Get buy Now tax data
    Buy Now Payment Select   true
    Sleep  1
    ${tax1}    Get buy Now tax data
    Should Not Be Equal As Numbers     ${tax}     ${tax1}

6.[Class]-Calculate TAX from the address in shippingInformation
    [Documentation]    [CP-3126]The tax varies according to the shipping address
    [Setup]   Run Keywords    Login    ${account_info["user"]}    ${account_info["password"]}
    ...       AND   Clear Cart
#    [Teardown]    Run Keywords     Clear Cart    AND    Close Browser
    [Tags]    full-run      yitest
    ${product_list}     Create List     MIK|class|${MIK CLASS[0]}|1|ACTC|STM|${EMPTY}     Add To Cart    Credit Card
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Page Contains Element            //h2[text()="Getting your Order"]
    Wait Until Element Is Visible               //h2[text()="Getting your Order"]
    Wait Until Element Is Visible               //h3[text()="Order Summary"]
    select tax address                          yixian
    Wait Until Element Is Visible               //div[text()="Next: Payment & Order Review"]
    ${data}     get order summary data

    select tax address                          tax two
    Sleep  2
    Wait Until Element Is Visible               //div[text()="Next: Payment & Order Review"]
    ${data2}     get order summary data
    Should Not Be Equal As Strings   ${data["Estimated Tax"]}     ${data2["Estimated Tax"]}

7.[Guest]-Class-class can be ordered to checkout by firefox browser
    [Documentation]  [CP-2941]class can be ordered to checkout by firefox browser
    [Tags]   full-run     yitest

    [Setup]  Environ Browser Selection And Setting   ${ENV}   Firefox
    [Teardown]    Finalization Processment
    ${product_list}  Create List   MIK|class|${MIK CLASS[0]}|1|ACTC|STM|${EMPTY}     Add To Cart    Credit Card
    Select Products and Purchase Type   ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Again If No Reaction       //div[text()='PROCEED TO CHECKOUT']    CONTINUE AS GUEST
    Guest Continue Next Step As      GUEST
    Wait Until Page Contains Element   //div[text()="Next: Payment & Order Review"]
    ${class qty}   Create List    ${1}
    Adding The Personal Infomation For the Getting Your Order Page     guest     ${empty}    ${class qty}
#    Add To Cart Payment Process    ${product_list[-1]}
    Click Next: Payment & Order Review Button
    Wait Until Element Is Visible       //p[text()="USPS Address Suggestion"]
    Wait Until Element Is Visible       //div[text()="Use USPS Suggestion"]
    Click Element                       //div[text()="Use USPS Suggestion"]
#    Click Next: Payment & Order Review Button
    Wait Until Element Is Visible   //h3[text()="Payment Method"]
    Payment Method Process     Credit Card      no pis
    Click Place Order Button In Order Review Page
#    Payment process   ${product_list[-2]}   ${product_list[-1]}    ${PRODUCT_INFO_LIST[0]}
    Wait Until Page Contains Element     //p[text()="ORDER NO. "]
    ${ORDER_NO}     Get Text            //p[text()="ORDER NO. "]
    Log    ${ORDER_NO[10:]}

8.[Class]-Email-24hours before the start of the course, will send the course link email
    [Documentation]    [CP-3049]24 hours before the start of the course, will send the course link email
    [Setup]   Run Keywords    Login    ${account_info["user"]}    ${account_info["password"]}
    ...         AND   imap_email_init_inbox
    ...         AND   Clear Cart
    [Teardown]    Run Keywords     Clear Cart    AND    Close Browser
    [Tags]    full-run      yitest
    ${product_list}     Create List     MIK|class|${MIK CLASS[0]}|1|ACTC|STM|${EMPTY}     Add To Cart    Credit Card
    Select Products and Purchase Type     ${product_list}
#    Payment process   ${product_list[-2]}   ${product_list[-1]}    ${PRODUCT_INFO_LIST[0]}
    Click View My Cart Button
#        Run Keyword And Warn On Failure    check shopping cart    ${PRODUCT_INFO_LIST}
    Click Proceed To Checkout Button
    ${order_summary_ele}     Set Variable     //h3[text()="Order Summary"]
    ${next_payment_order_review}     Set Variable      //div[text()="Next: Payment & Order Review"]/parent::button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
#    Wait Until Page Contains Element     ${getyourorder_ele}
#    Wait Until Element Is Visible    ${getyourorder_ele}
    Wait Until Page Contains Element     ${order_summary_ele}
    Wait Until Element Is Visible     ${order_summary_ele}
    Wait Until Page Contains Element     ${next_payment_order_review}
    Wait Until Element Is Visible     ${next_payment_order_review}
    Run Keyword And Warn On Failure    check getting your order page    ${PRODUCT_INFO_LIST}
#    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    ${status}    If Class In Products     ${PRODUCT_INFO_LIST}
    IF   "${status}" == "True"
        ${Guest_Ele}    Set Variable    (//div[contains(text(),"Guest")])
        Wait Until Page Contains Element     ${Guest_Ele}
        Wait Until Element Is Visible     ${Guest_Ele}
        ${count}    Get Element Count    ${Guest_Ele}
        ${index}    Set Variable    1
        ${Guest_Data}  Create List
        FOR  ${i}  IN RANGE   ${count}
                ${guest_info}   Create Dictionary    firstName=auto_cpm    lastName=zhang   email=testyixian666@qq.com   phone=9897960001
                Append To List  ${Guest_Data}    ${guest_info}
        END
        FOR    ${Guest_Info}    IN    @{Guest_Data}
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]       ${Guest_Info}[firstName]
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]        ${Guest_Info}[lastName]
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]           ${Guest_Info}[email]
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]     ${Guest_Info}[phone]
            ${index}    Evaluate    ${index}+1
        END
#        END
    END
    Click Next: Payment & Order Review Button
    Run Keyword And Warn On Failure    check order review page    ${PRODUCT_INFO_LIST}
    select payments method    ${product_list[-1]}
    ${err_popup}  Run Keyword And Ignore Error   Close popup Cannot Transaction
    IF  "${err_popup[0]}"=="PASS"
        select payments method    ${product_list[-1]}
    END
    check the order No. with add to cart

    imap_inbox_in_class_email    order_number=${ORDER_NO}    class_name=${PRODUCT_INFO_LIST[0]["product_name"]}
    log    ${ORDER_NO}

9.[Class]Book class in 24 hours before the start of class,Will receive two emails
    [Documentation]  [CP-3122] Book class in 24 hours before the start of class,will send the class link email and the class success booked email
    [Setup]   Run Keywords    Login    ${account_info["user"]}    ${account_info["password"]}
    ...         AND   imap_email_init_inbox
    ...         AND   Clear Cart
    [Teardown]    Run Keywords     Clear Cart    AND    Close Browser
    [Tags]    full-run      yitest
    ${product_list}     Create List     MIK|class|${MIK CLASS[2]}|1|ACTC|STM|${EMPTY}     Add To Cart    Credit Card
    Select Products and Purchase Type     ${product_list}
#    Payment process   ${product_list[-2]}   ${product_list[-1]}    ${PRODUCT_INFO_LIST[0]}
    Click View My Cart Button
#        Run Keyword And Warn On Failure    check shopping cart    ${PRODUCT_INFO_LIST}
    Click Proceed To Checkout Button
    ${order_summary_ele}     Set Variable     //h3[text()="Order Summary"]
    ${next_payment_order_review}     Set Variable      //div[text()="Next: Payment & Order Review"]/parent::button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
#    Wait Until Page Contains Element     ${getyourorder_ele}
#    Wait Until Element Is Visible    ${getyourorder_ele}
    Wait Until Page Contains Element     ${order_summary_ele}
    Wait Until Element Is Visible     ${order_summary_ele}
    Wait Until Page Contains Element     ${next_payment_order_review}
    Wait Until Element Is Visible     ${next_payment_order_review}
    Run Keyword And Warn On Failure    check getting your order page    ${PRODUCT_INFO_LIST}
#    Checkout Class - Input All Guest Info     ${PRODUCT_INFO_LIST}
    ${status}    If Class In Products     ${PRODUCT_INFO_LIST}
    IF   "${status}" == "True"
        ${Guest_Ele}    Set Variable    (//div[contains(text(),"Guest")])
        Wait Until Page Contains Element     ${Guest_Ele}
        Wait Until Element Is Visible     ${Guest_Ele}
        ${count}    Get Element Count    ${Guest_Ele}
        ${index}    Set Variable    1
        ${Guest_Data}  Create List
        FOR  ${i}  IN RANGE   ${count}
                ${guest_info}   Create Dictionary    firstName=auto_cpm    lastName=zhang   email=testyixian666@qq.com   phone=9897960001
                Append To List  ${Guest_Data}    ${guest_info}
        END
        FOR    ${Guest_Info}    IN    @{Guest_Data}
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]       ${Guest_Info}[firstName]
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]        ${Guest_Info}[lastName]
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]           ${Guest_Info}[email]
            Click Element   ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]
            Press Keys      ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]     ${Guest_Info}[phone]
            ${index}    Evaluate    ${index}+1
        END
    END
    Click Next: Payment & Order Review Button
    Run Keyword And Warn On Failure    check order review page    ${PRODUCT_INFO_LIST}
    select payments method    ${product_list[-1]}
    check the order No. with add to cart

    imap_inbox_in_scheduled_within_24_hours_email    order_number=${ORDER_NO}    class_name=${PRODUCT_INFO_LIST[0]["product_name"]}
    log    ${ORDER_NO}
