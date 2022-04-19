
*** Settings ***
Resource    ../../Keywords/Checkout/BuyerBusinessKeywords.robot
Library    Collections

Suite Setup   Run Keywords   initial env data2
Test Setup        Run Keyword     Environ Browser Selection And Setting    ${ENV}   ${BROWSER}
Test Teardown     Run Keywords    clear cart if test case fail   AND    Close All Browsers

*** Variables ***
&{consignee1}    firstName=habe
...             lastName=luo
...             addressLine1=P.O. Box 2431
...             city=Bay St. Louis
...             state=MS
...             zipCode=39540
...             email=ui_cart_smoke@snapmail.cc
...             phoneNumber=469-779-6009


&{consignee2}    firstName=habe
...             lastName=luo
...             addressLine1=PO Box 2854 Dog Hill
...             city=Topeka
...             state=KS
...             zipCode=66608
...             email=ui_cart_smoke@snapmail.cc
...             phoneNumber=469-779-6009

&{consignee3}    firstName=habe
...             lastName=luo
...             addressLine1=po box 2431
...             city=Bay St. Louis
...             state=MS
...             zipCode=39540
...             email=ui_cart_smoke@snapmail.cc
...             phoneNumber=469-779-6009


*** Test Cases ***

01-Guest-MIK-PIS-STM-PO Box-US
    [Documentation]     [PO_box] - US - buy MIK pickup and MIK STM items,input PO box address in checkout page,place order
    [Tags]    PO-box     full-run
    [Template]     Guest Use PO.Box Address To Place Order
    ${consignee1}      MIK|listing|${PIS[0]}|1|ATC|PIS|${EMPTY}    MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}     Add To Cart    Credit Card


02-Guest-MIK-MKP-PO Box-US
    [Documentation]     [PO_box] - US - Buy MIK item and MKP item,input PO box address in checkout page,place order
    [Tags]    PO-box     full-run
    [Template]     Guest Use PO.Box Address To Place Order
    ${consignee2}      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    MKP|listing|${MKP[1]}|1|ATC||${EMPTY}     Add To Cart    Credit Card


03-Guest-MIK-MKR-PO Box-US
    [Documentation]     [PO_box] - US - Buy MIK item and MKR item,input PO box address in checkout page,place order
    [Tags]    PO-box     full-run
    [Template]     Guest Use PO.Box Address To Place Order
    ${consignee3}      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    MKR|listing|${MKR[0]}|1|ATC||${EMPTY}     Add To Cart    Credit Card

04-Guest-MIK-MIK CLass-PO Box-US
    [Documentation]     [PO_box] - US - Buy mik item and class,input PO box address on checkout page,place order
    [Tags]    PO-box    full-run
    [Template]     Guest Use PO.Box Address To Place Order
    ${consignee2}      MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    MIK|class|${MIK CLASS[0]}|1|ACTC||${EMPTY}     Add To Cart    Credit Card


05-Guest-MIK-MKR-PO Box-US
    [Documentation]     [CP-4623],[CP-4624][PO_box]-US-if you buy item that it can not ship to PO box, when the customer input PO box address and clicks “Next Step” in checkout page,
    ...                 popup error message
    [Tags]    PO-box    full-run
    [Template]     item that it can not ship to PO box address
    ${consignee1}     MIK|listing|${NO PO BOX ITEM[0]}|1|ATC|STM|${EMPTY}   Add To Cart    ${EMPTY}
    ${consignee2}     MIK|listing|${NO PO BOX ITEM[0]}|1|ATC|STM|${EMPTY}   Add To Cart    ${EMPTY}
    ${consignee3}     MIK|listing|${NO PO BOX ITEM[0]}|1|ATC|STM|${EMPTY}   Add To Cart    ${EMPTY}


#05-Guest-MIK-MKR-PO Box-US
#    [Documentation]     [PO_box] - US - if you buy items that it can not ship to PO box, when the customer input PO box address and clicks “Next Step” in checkout page,
#    ...                 popup error message
#    [Tags]    PO-box
#    @{product_list}    Create List     MIK|listing|${P.O.Box item[0]}|1|ATC|STM|${EMPTY}   Add To Cart    ${EMPTY}
#    Select Products and Purchase Type   ${product_list}     ${True}     ${False}
#    Click View My Cart Button
#    Click Proceed To Checkout Button
#    Click Continue as Guest Button
#    ${IF PIS}    Input Guest Info In Get Your Order     ${pickupInfo}     ${consignee1}
#    Click Next: Payment & Order Review Button
#    Check error message for PO Box Address

*** Keywords ***
Check error message for PO Box Address
    Wait Until Element Is Visible      //p[text()="Shipping Restrictions"]
    ${error_message}    Get Text     //p[text()="Shipping Restrictions"]/../following-sibling::div/p
    Should Be Equal As Strings     ${error_message}     The items you are trying to ship are unavailable for PO Box addresses. Please enter a different address.     check PO box address error message is wrong





