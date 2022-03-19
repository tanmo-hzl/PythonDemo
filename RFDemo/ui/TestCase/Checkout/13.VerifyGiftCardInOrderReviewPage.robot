*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
#Resource    ../../Keywords/Checkout/AccountWalletPageKeywords.robot
#Resource    ../../Libratires/MP/CommonLibrary.py
Resource    ../../Keywords/Checkout/Common.robot
Resource    ../../Keywords/Checkout/OrderReviewPageKeywords.robot

Suite Setup   Run Keywords   initial env data2
#Suite Teardown    Close Browser
#Test Setup    Run Keywords   Login and change store    AND    clear cart
Suite Teardown   Run Keywords    Close All Browsers

*** Variables ***
&{giftInfo1}     giftCard=6006496912999905381    pin=9500    balance=Balance: $2,000.00
&{giftInfo2}     giftCard=6006496912999904962    pin=9478    balance=0
&{giftInfo3}     giftCard=6006496912999905258    pin=4113    balance=2000
&{invalid_giftInfo}     giftCard=56778888899657    pin=3456    balance=invalid


${wallet_text_ele}     //h2[text()="Wallet"]
${add_a_gift_card_ele}     //div[text()="ADD A GIFT CARD"]
${input_card_number_ele}    //input[@id="cardNumber"]
${input_pin_ele}     //input[@id="pin"]
${save_ele}    //div[text()="SAVE"]
${delete_button_ele}      //div[text()="Delete"]


*** Test Cases ***

01-Verify-GiftCard-OrderReviewPage
    [Documentation]     Add gift cards on your Wallet page and they will be displayed In the Payment & Order Review page
    [Tags]    full-run   gift-card
    login     ${buyer2}[user]     ${buyer2}[password]
    Clear Cart
    Add Gift Card In Wallet     ${giftInfo1}[giftCard]     ${giftInfo1}[pin]
    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    0
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Check Gift Card In Order Review2      ${giftInfo1}[giftCard]     ${giftInfo1}[balance]


02-Verify-GiftCard-OrderReviewPage
    [Documentation]     Delete the gift card from wallet, the deleted gift card will not be displayed In the Payment & Order Review page
    [Tags]    full-run   gift-card
    Delete Gift Card In Wallet
#    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    0
#    Select Products and Purchase Type     ${product_list}
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Check non-existed gift card in order review     ${giftInfo1}[giftCard]



03-Verify-GiftCard-OrderReviewPage
    [Documentation]     Enter the gift card number and PIN In Order Review Page, and click Apply to add the gift card successfully
    [Tags]    full-run   gift-card
#    login     ${buyer2}[user]     ${buyer2}[password]
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Add A Card In Order Review     ${giftInfo3}[giftCard]    ${giftInfo3}[pin]
    Check add valid gift card      ${giftInfo3}[giftCard]


04-Verify-GiftCard-OrderReviewPage
    [Documentation]     Enter a gift card with $0 banlance in order review page, can apply fail and a error message is diaplayed
    [Tags]    full-run    gift-card
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Add A Card In Order Review     ${giftInfo2}[giftCard]    ${giftInfo2}[pin]
    Check add gift card with balance 0


05-Verify-GiftCard-OrderReviewPage
    [Documentation]     Enter an invalid gift card in order review page, can apply fail and a error message is diaplayed
    [Tags]    gift-card
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Add A Card In Order Review     ${invalid_giftInfo}[giftCard]    ${invalid_giftInfo}[pin]
    Check add invalid gift card


06-Verify-GiftCard-OrderReviewPage
    [Documentation]     The credit card needs to be selected regardless of whether the gift card is sufficient for payment in order review page
    [Tags]    full-run    gift-card
    Add Gift Card In Wallet     ${giftInfo3}[giftCard]     ${giftInfo3}[pin]
#    Clear Cart
    @{product_list}     Create List      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    Add To Cart    0
    Select Products and Purchase Type     ${product_list}
    Click View My Cart Button
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Gift Card Check-box
    Check credit card still be selected


07-Verify-GiftCard-OrderReviewPage
    [Documentation]      1.Click [Apply] in order review page, the gift card from Wallet will be used, and the order summary shows how much a gift card can pay
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
    ${gift_card_amount}    Check gift card from order summary
    Should Be Equal As Strings      ${gift_card_amount}    -${total_amout}
    ${remainder_total_amount}      Get total amount from order summary
    Should Be Equal As Strings      ${remainder_total_amount}     $0.00
    Click Undo Button for gift card
    Check gift card hiden from order summary


08-Verify-GiftCard-OrderReviewPage
    [Documentation]      If you choose to use paypal, the gift card cannot be used for payment
    [Tags]    full-run   gift-card
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Paypal Radio
    Check gift card has been banned


09-Verify-GiftCard-OrderReviewPage
    [Documentation]      If you choose to use Google Pay, you can't use a gift card to Pay, and there is a message on the page
    [Tags]    full-run   gift-card
    go to     ${Home URL}/cart
    Click Proceed To Checkout Button
    Click Next: Payment & Order Review Button
    Click Google Pay Radio
    Check gift card has been banned
    Delete Gift Card In Wallet

#10-Verify-GiftCard-OrderReviewPage
#    [Documentation]      After using the gift card to place the order and pay, the amount remaining on the gift card is correct
#    [Tags]    gift-card
#    login     ${buyer2}[user]     ${buyer2}[password]
#    Add Gift Card In Wallet     ${giftInfo3}[giftCard]     ${giftCard3}[pin]
#    save_file     gift_card_balance     ${giftInfo3}[balance]
#    @{product_list}     Create List      MIK|listing|${SDD[1]}|1|ATC|PIS|${EMPTY}    Add To Cart    0
#    Select Products and Purchase Type     ${product_list}
#    Click View My Cart Button
#    Click Proceed To Checkout Button
#    Click Next: Payment & Order Review Button
#    Click Gift Card Check-box
#    Click Apply button for gift card
#    ${gift_card_amount}    Check gift card from order summary
#    Click Place Order Button In Order Review Page







*** Keywords ***




Add Gift Card In Wallet
    [Arguments]     ${gift_card}    ${pin}
    go to    ${Home URL}/buyertools/wallet
    Sleep     1
    Wait Until Page Contains Element    ${wallet_text_ele}
    Wait Until Page Contains Element     ${add_a_gift_card_ele}
    Scroll Element Into View     ${add_a_gift_card_ele}
    Wait Until Element Is Enabled     ${add_a_gift_card_ele}
    AD Exception Handle   ${add_a_gift_card_ele}
    Wait Until Page Contains Element    ${input_card_number_ele}
    Input Text     ${input_card_number_ele}     ${gift_card}
    Input Text     ${input_pin_ele}      ${pin}
    AD Exception Handle     ${save_ele}
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
    AD Exception Handle      ${delete_gift_card_ele}
    Wait Until Page Contains Element     //p[contains(text(),"Delete Gift Card")]
    Wait Until Page Contains Element     ${delete_button_ele}
    AD Exception Handle     ${delete_button_ele}
    Wait Until Page Does Not Contain Element     ${delete_gift_card_ele}     3





