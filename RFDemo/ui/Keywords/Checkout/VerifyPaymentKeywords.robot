*** Settings ***

*** Variables ***
${sleep_time}   0.5
${payment_slect}   /ancestor::span/preceding-sibling::span
${Credit_card}     //p[text()="Credit/Debit Card"]
${paypal}         //p[text()="Paypal"]
${google_pay}     //p[text()="Google Pay"]
${monthly}        //p[text()="Buy with monthly payments"]
${gift_card}      //p[text()="Add A Gift Card"]/preceding-sibling::div

*** Keywords ***
verify select payment only
    [Arguments]     ${method}=${Credit_card}
    ${payment_list}     create list     ${Credit_card}   ${paypal}    ${google_pay}   #${monthly}
    ${value}     Create List
    FOR  ${var}  IN     @{payment_list}
        Wait Until Element Is Visible   ${var}${payment_slect}
        ${att}  get element attribute   ${var}${payment_slect}      data-checked
        Append To List   ${value}   ${att}
    END
    Log  ${value}
    ${payment_number}   Count Values In List   ${value}      ${EMPTY}
    Should Be Equal   ${payment_number}   ${1}
    ${index}    get index from list     ${payment_list}    ${method}
    Should Be Equal     ${value[${index}]}      ${EMPTY}
    ${gift_card_num}    get element count   ${gift_card}/*
    IF  ${index}==0
        Should Be Equal As Numbers      ${gift_card_num}    1
    ELSE
        Should Be Equal As Numbers      ${gift_card_num}    0
    END

verify payment only
    [Arguments]  ${method}=${paypal}
    wait until element is visible   ${method}
    AD Exception Handle   ${method}
    verify select payment only     ${method}

verify gift card is checkbox
    verify payment only     ${Credit_card}
    ${gift_checkbox}    get element count    ${gift_card}/div
    IF  ${gift_checkbox}==0
        wait until element is visible   ${gift_card}/*
#        ${gift_card_checkbox}   get element attribute     ${gift_card}/*    viewBox
#        Should Be Equal As Strings   ${gift_card_checkbox}      0 0 24 24
        AD Exception Handle   ${gift_card}/*
        Sleep  ${sleep_time}
        wait until element is visible   ${gift_card}/div
        ${gift_checkbox1}    get element count    ${gift_card}/div
        Should Be Equal As Numbers  ${gift_checkbox1}   1
    ELSE IF   ${gift_checkbox}==1
        wait until element is visible   ${gift_card}/*
#        ${gift_card_checkbox}   get element attribute     ${gift_card}/div/*    viewBox
#        Should Be Equal As Strings   ${gift_card_checkbox}      0 0 24 24
        AD Exception Handle   ${gift_card}/*
        Sleep  ${sleep_time}
        ${gift_checkbox1}    get element count    ${gift_card}/div
        Should Be Equal As Numbers  ${gift_checkbox1}   0
    ELSE
        Should Be Equal As Numbers  ${gift_checkbox1}   1
    END



