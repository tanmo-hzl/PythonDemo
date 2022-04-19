*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Resource    ../../Keywords/Checkout/OrderReviewPageKeywords.robot
Resource    ../../Keywords/Checkout/InventoryAPIKeywords.robot

Suite Setup   Run Keywords   initial env data2     AND     CK Buyer login    ${buyer7}[user]     ${buyer7}[password]
Suite Teardown   Run Keyword    Close All Browsers

*** Variables ***

&{buyer7}        user=neivi124@snapmail.cc     password=Aa123456
&{buyer8}        user=neivi125@snapmail.cc     password=Aa123456

&{giftInfo1}     card_number=6006496912999906223    pin=4596    balance=Balance: $2,000.00
&{giftInfo2}     card_number=6006496912999904962    pin=9478    balance=0
&{giftInfo3}     card_number=6006496912999906231    pin=5485    balance=2000
&{invalid_giftInfo}     card_number=56778888899657    pin=3456    balance=invalid


&{creditInfo0}   cardHolderName=JOHN BELL
...             cardNumber=5155718238074354
...             expirationDate=10/23
...             cvv=123

&{creditInfo1}   cardHolderName=JOHN BELL
...             cardNumber=6545000000000009
...             expirationDate=08/26
...             cvv=234

&{creditInfo2}   cardHolderName=LISA LUO
...             cardNumber=5111005111051128
...             expirationDate=10/23
...             cvv=611

&{creditInfo3}   cardHolderName=JOHN BELL
...             cardNumber=4286090011039763
...             expirationDate=10/23
...             cvv=123

&{creditInfo4}   cardHolderName=HABE LUO
...             cardNumber=4112344112344113
...             expirationDate=12/22
...             cvv=234

&{billAddress1}    firstName=lisa
...               lastName=luo
...               addressLine1=2435 Marfa Ave
...               city=Dallas
...               state=TX
...               zipCode=75216
...               phoneNumber=469-779-6009




${wallet_text_ele}     //h2[text()="Wallet"]
${add_a_gift_card_ele}     //div[text()="ADD A GIFT CARD"]
${input_card_number_ele}    //input[@id="cardNumber"]
${input_pin_ele}     //input[@id="pin"]
${save_ele}    //div[text()="SAVE"]
${delete_button_ele}      //div[text()="Delete"]


*** Test Cases ***

01-Verify-GiftCard-OrderReviewPage
    [Documentation]     [CP-3652]Gift Card - After using the gift card to place the order and pay, the amount remaining on the gift card is correct
    [Tags]    full-run   gift-card
    [Teardown]    Run Keywords    Delete User Gift Card - DELETE    ${gift_card_id}    AND    Close All Browsers
    login     ${buyer7}[user]     ${buyer7}[password]
    Clear Cart
#    Add User Gift Card - POST     ${giftInfo3}
    Add User Gift Card    ${giftInfo3}
    ${res1}     Get User Gift Card List - GET
    ${gift_card_id}    Set Variable     ${res1[0]}[giftCardId]
    ${balance}    Set Variable     ${res1[0]}[balance]
    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    ${EMPTY}
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    ${total_amount}    Get total amount in order review
    select payments method     Gift Card
    ${res2}     Get User Gift Card List - GET
    ${after_balance}    Set Variable      ${res2[0]}[balance]
    ${actual_balance}    Evaluate    float(${balance}) - float(${total_amount[1:]})
    ${actual_balance}   Evaluate    format(${actual_balance},".2f")
    Should Be Equal As Strings     ${actual_balance}      ${after_balance}


02-Verify-GiftCard-OrderReviewPage
    [Documentation]     [CP-3651]Gift Card - If the gift card is not enough to pay, the amount of the gift card is deducted first, and the rest is deducted by credit card
    [Tags]   full-run   gift-card
    [Teardown]    Run Keyword    Close All Browsers
    # to do
    login     ${buyer7}[user]     ${buyer7}[password]
    Clear Cart
    ${gift_card}    init_gift_card    2
    ${giftInfo}     Create Dictionary     card_number=${gift_card}[card_number]     pin=${gift_card}[pin]
    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    ${EMPTY}
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    ${total_amount}    Get total amount in order review
    Add A Card In Order Review     ${gift_card}[card_number]    ${gift_card}[pin]
    ${gift_card_pay}    Get Text     //p[text()="Gift Card"]/following-sibling::p
    Should Be Equal As Strings     ${gift_card_pay}     -$2.00
    ${E_credit_card_pay}    Evaluate     float(${total_amount[1:]}) - float(${gift_card_pay[2:]})
    ${E_credit_card_pay}   Evaluate    format(${E_credit_card_pay},".2f")
    Click Place Order Button In Order Review Page
    Get order no from order confirmation
    ${actual_credit_card_pay}    Get credit card pay     4113
    Should Be Equal As Strings     ${actual_credit_card_pay}     $${E_credit_card_pay}



03-Verify-GiftCard-OrderReviewPage
    [Documentation]     [CP-3638]Add gift cards on your Wallet page and they will be displayed In the Payment & Order Review page
    [Tags]    full-run   gift-card
    login     ${buyer8}[user]     ${buyer8}[password]
    Clear Cart
#    Add Gift Card In Wallet     ${giftInfo1}[card_number]     ${giftInfo1}[pin]
    Add User Gift Card - POST     ${giftInfo1}
    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    0
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Check Gift Card In Order Review2      ${giftInfo1}[card_number]     ${giftInfo1}[balance]


04-Verify-GiftCard-OrderReviewPage
    [Documentation]     [CP-3639]Delete the gift card from wallet, the deleted gift card will not be displayed In the Payment & Order Review page
    [Tags]    full-run   gift-card
#    Delete Gift Card In Wallet
    ${res1}     Get User Gift Card List - GET
    ${gift_card_id}    Set Variable     ${res1[0]}[giftCardId]
    Delete User Gift Card - DELETE       ${gift_card_id}
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Check non-existed gift card in order review     ${giftInfo1}[card_number]



05-Verify-GiftCard-OrderReviewPage
    [Documentation]     [CP-3642]Enter the gift card number and PIN In Order Review Page, and click Apply to add the gift card successfully
    [Tags]    full-run   gift-card
#    login     ${buyer2}[user]     ${buyer2}[password]
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Add A Card In Order Review     ${giftInfo3}[card_number]    ${giftInfo3}[pin]
    Check add valid gift card      ${giftInfo3}[card_number]


06-Verify-GiftCard-OrderReviewPage
    [Documentation]     [CP-3644]Enter a gift card with $0 banlance in order review page, can apply fail and a error message is diaplayed
    [Tags]    full-run    gift-card
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Add A Card In Order Review     ${giftInfo2}[card_number]    ${giftInfo2}[pin]
    Check add gift card with balance 0


07-Verify-GiftCard-OrderReviewPage
    [Documentation]     [CP-3643]Enter an invalid gift card in order review page, apply fail and display a error message
    [Tags]    gift-card
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Add A Card In Order Review     ${invalid_giftInfo}[card_number]    ${invalid_giftInfo}[pin]
    Check add invalid gift card


08-Verify-GiftCard-OrderReviewPage?
    [Documentation]     [CP-3646]The credit card needs to be selected regardless of whether the gift card is sufficient for payment in order review page
    [Tags]    full-run    gift-card
#    Add Gift Card In Wallet     ${giftInfo3}[card_number]     ${giftInfo3}[pin]
#    Clear Cart
    Add User Gift Card - POST     ${giftInfo3}
    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    0
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Gift Card Check-box
    Check credit card still be selected


09-Verify-GiftCard-OrderReviewPage
    [Documentation]      [CP-3648 CP-3649 CP-3650]1.Click [Apply] in order review page, the gift card from Wallet will be used, and the order summary shows how much a gift card can pay
    ...                  2.If the gift card is sufficient to pay, only the amount of the gift card is deducted in order review page
    ...                  3.Click [Undo] in order review page, the gift card from Wallet will not be used
    [Tags]    full-run    gift-card
#    login     ${buyer2}[user]     ${buyer2}[password]
#    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    0
#    Select Products and Purchase Type     ${product_list}
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Gift Card Check-box
    ${total_amout}    Get total amount from order summary
    Click Apply button for gift card
    Check gift card pay amount equal total amout     ${total_amout}
    ${remainder_total_amount}      Get total amount from order summary
    Should Be Equal As Strings      ${remainder_total_amount}     $0.00
    Click Undo Button for gift card
    Check gift card hiden from order summary


10-Verify-GiftCard-OrderReviewPage
    [Documentation]      [CP-3640]If you choose to use paypal, the gift card cannot be used for payment
    [Tags]    full-run   gift-card
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Paypal Radio
    Check gift card has been banned


11-Verify-GiftCard-OrderReviewPage
    [Documentation]      [CP-3653]If you choose to use Google Pay, you can't use a gift card to Pay, and there is a message on the page
    [Tags]    full-run   gift-card
    [Teardown]     Run Keyword    Close All Browsers
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Google Pay Radio
    Check gift card has been banned
    ${res1}     Get User Gift Card List - GET
    ${gift_card_id}    Set Variable     ${res1[0]}[giftCardId]
    Delete User Gift Card - DELETE     ${gift_card_id}
#    Delete Gift Card In Wallet


12-Verify-Add-A-Credit-Card
    [Documentation]      [CP-3821]Payment - A maximum of 5 credit cards can be added. When 5 cards are added, the "Add Additional Card "button is deactivated
    [Tags]    full-run    credit-card
    login     ${buyer8}[user]     ${buyer8}[password]
    Clear Cart
    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    0
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Change Payment
    Check Credit Card Popup
#    FOR    ${i}    IN RANGE    5
#        ${creditInfo}    Catenate     creditInfo${i}
#        Add A Credit Card     ${${creditInfo}}     ${billAddress1}
#    END



*** Keywords ***


Check Credit Card Popup
    Wait Until Page Contains Element     //p[text()="Credit Cards"]
    ${cc_number}    Get Element Count     //p[text()="Credit Cards"]/following-sibling::div/div
    Should Be Equal As Strings     ${cc_number}    5
    Page Should Contain Element     //p[text()="Add Additional Card"]/parent::button[@disabled]
    ${text}    Get Text     //p[text()="Add Additional Card"]/parent::button/following-sibling::p
    Should Be Equal As Strings     ${text}      You’ve reached your max limit of 5 cards. Remove one to add another.


Add Gift Card In Wallet
    [Arguments]     ${gift_card}    ${pin}
    go to    ${Home URL}/buyertools/wallet
    Sleep     1
    Wait Until Page Contains Element    ${wallet_text_ele}
    Wait Until Page Contains Element     ${add_a_gift_card_ele}
    Scroll Element Into View     ${add_a_gift_card_ele}
    Wait Until Element Is Enabled     ${add_a_gift_card_ele}
    Click Element   ${add_a_gift_card_ele}
    Wait Until Page Contains Element    ${input_card_number_ele}
    Input Text     ${input_card_number_ele}     ${gift_card}
    Input Text     ${input_pin_ele}      ${pin}
    Click Element   ${save_ele}
    sleep     1
#    ${gift_card}    Set Variable      ${gift_card[-4:]}
#    Wait Until Page Contains Element    //p[contains(text(),"${gift_card}")]


Delete Gift Card In Wallet
    go to    ${Home URL}/buyertools/wallet
    Sleep     1
    Wait Until Page Contains Element    ${wallet_text_ele}
    Wait Until Page Contains Element     ${add_a_gift_card_ele}
#    ${gift_card}    Set Variable      ${gift_card[-4:]}
#    ${delete_gift_card_ele}    Set Variable     //p[contains(text(),"${gift_card}")]/../../following-sibling::div[2]//*[name()='svg']
    ${delete_gift_card_ele}    Set Variable     //*[name()="svg" and @class="icon icon-tabler icon-tabler-trash"]
    Wait Until Page Contains Element     ${delete_gift_card_ele}
    Click Element       ${delete_gift_card_ele}
    Wait Until Page Contains Element     //p[contains(text(),"Delete Gift Card")]
    Wait Until Page Contains Element     ${delete_button_ele}
    Click Element      ${delete_button_ele}
    Wait Until Page Does Not Contain Element     ${delete_gift_card_ele}


Get total amount in order review
    Wait Until Page Contains Element     //*[text()="Total:"]/following-sibling::h4
    Wait Until Element Is Visible     //*[text()="Total:"]/following-sibling::h4
    ${total_amount}    Get Text     //*[text()="Total:"]/following-sibling::h4
    [Return]     ${total_amount}


Get credit card pay
    [Arguments]    ${last_four_digits_of_cc}
    go to    ${Home URL}/buyertools/order-history?detail=${ORDER_NO}
    Wait Until Page Contains Element     //p[text()="Order Detail"]
    Wait Until Page Contains Element    (//h4)[1]
    Wait Until Element Is Visible    (//h4)[1]
    ${actual_credit_card_pay}    Get Text    //span[text()="${last_four_digits_of_cc}"]/../following-sibling::p
    [Return]     ${actual_credit_card_pay}