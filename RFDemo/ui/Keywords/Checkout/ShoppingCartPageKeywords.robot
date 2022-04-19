*** Settings ***
Resource    ../../TestData/Checkout/config.robot
Resource    BuyerCheckKeywords.robot
Resource    ../../Keywords/Checkout/Common.robot
Resource   ../../Keywords/Checkout/VerifyCartKeywords.robot
Library     ../../Libraries/Checkout/BuyerKeywords.py
Library     ../../TestData/Checkout/GuestGenerateAddress.py


*** Variables ***
${loading_ele}    //*[@stroke="transparent"]

*** Keywords ***
Verify Skus On Cart Page
    [Arguments]    ${Sku List}
    Sleep  2
    ${Cart Skus}         Get Webelements      //p[@class='css-1otct4a']
    ${Processed Skus}    Web Sku Process      ${Cart Skus}
    ${Processed Skus}    ${Sku List}   Rearrange Lists    ${Processed Skus}   ${Sku List}
    Run Keyword And Warn On Failure    Should Be Equal    ${Processed Skus}   ${Sku List}

Cart Verify Items Added and Subtotal Calculate
    [Arguments]    ${Items Count}    ${IF PIS}    ${Store Amount}
    Sleep   2

    ${Cart Item Subtotal}       Set Variable
    ${Cart Item Each Subtotal}  Set Variable
    ${Cart Items Count}         Get Element Count    //input[@inputmode="decimal"]
    IF  '${IF PIS}' != 'PISM Existed'
        ${Items Count}=  Evaluate    ${Items Count} * ${Store Amount}
        Run Keyword And Warn On Failure   Should Be Equal   ${Items Count}   ${Cart Items Count}
    END
    FOR   ${i}   IN RANGE   ${Cart Items Count}
        ${Cart Qty}         Get Value  (//input[@inputmode="decimal"])[${i + 1}]

        ${Cart Price}       Get Text   (//p[text()="$"])[${i + 1}]
        ${Each Text}        Run Keyword And Ignore Error    Get Text   (//p[text()="$"])[${i + 1}]/following-sibling::p
        ${Promo Type}       Get Text   //p[text()='$']/preceding-sibling::p
        ${Results Promot}   Cart Promo Display    ${Promo Type}
        IF  '${Results Promot}' == 'YES'
            ${Cart Item Each Subtotal}=   Evaluate   ${Cart Price[1:]}
        ELSE IF   '${Each Text}[0]' == 'PASS'
            ${Cart Item Each Subtotal}=   Evaluate   ${Cart Price[1:]}
        ELSE
            ${Cart Item Each Subtotal}=   Evaluate   ${Cart Qty} * ${Cart Price[1:]}
        END
        ${Cart Item Subtotal}=   Evaluate   ${Cart Item Subtotal} + ${Cart Item Each Subtotal}
    END
    ${Order Summary Subtotal}    Get Text   //p[contains(text(), "Subtotal")]/following-sibling::p
    ${Cart Item Subtotal}        Adjust To Two Digit Data Type   ${Cart Item Subtotal}
    Capture Page Screenshot
    ${Savings Existed}   Run Keyword And Ignore Error      Wait Until Element Is Visible    //p[text()="Savings"]   3
    IF  '${Savings Existed}[0]' == 'FAIL'
        Run Keyword And Warn On Failure   Should Be Equal As Strings       ${Cart Item Subtotal}   ${Order Summary Subtotal[1:]}
    END


Extract Each Product Href Data In The Cart
    Sleep  1
    @{Cart Elements}   Get Webelements   //p/a
    @{hrefs}   Create List
    FOR  ${Cart Element}  IN   @{Cart Elements}
        ${Element Info}    Get Element Attribute   ${Cart Element}   href
        @{temp}   Create List   ${Element Info}
        ${hrefs}=   Evaluate   ${hrefs} + ${temp}
    END
    ${Cart Lists}   Remove Javascript    ${hrefs}

    [Return]    ${Cart Lists}

Guest Continue Next Step As
    [Arguments]  ${Mode}
    IF  '${Mode}' == 'GUEST'
        Wait Until Element Is Enabled    //div[text()='CONTINUE AS GUEST']
        Sleep  2
        Click Element   //div[text()='CONTINUE AS GUEST']
    ELSE IF  '${Mode}' == 'SIGN IN'  # Will Update Later, Right Now Just Write Like This
        Wait Until Element Is Enabled    //div[text()='${Mode}']
        Sleep  2
        Click Element                    //div[text()='${Mode}']
    END

Verify Subtotal Items Correctness Compare Cart With Order Summary
   ${Subtotal}     Get Webelement     //h3[text()="Order Summary"]/following-sibling::div/child::p[text()="Subtotal ("]
   Sleep  1
   ${Side List}    Create List
   @{Side Items}   Get Webelements   //p[@class='css-l24f64']
   FOR   ${Item}   IN   @{Side Items}
         ${Item Info}   Get Text       ${Item}
         @{Item Temp}   Create List    ${Item Info}
         ${Side List}=  Evaluate       ${Side List} + ${Item Temp}
   END
   ${Subtotal Number}   ${Side Items Sum}   Items Verify    ${Subtotal.text}    ${Side List}
   ${Verify Res}    Web Element Number Verification    ${Subtotal Number}   ${Side Items Sum}
   [Return]     ${Verify Res}



Shipping Align Based On PDP and Cart
    [Arguments]    ${Items Shipping Info}    ${Updated Shipping}
    ${Items Shipping Info}    Adjust Shipping Letter    ${Items Shipping Info}
    ${Updated Shipping}       Adjust Shipping Letter    ${Updated Shipping}
    ${Items Shipping Info}    Remove Dash From Shipping Text     ${Items Shipping Info}
    ${Updated Shipping}       Remove Dash From Shipping Text     ${Updated Shipping}
    ${Updated Shipping}       ${Items Shipping Info}    Rearrange Lists    ${Updated Shipping}   ${Items Shipping Info}
    Should Be Equal As Strings    ${Items Shipping Info}   ${Updated Shipping}

Trending Now Exists
    Wait Until Element Is Visible           //h3[text()='Trending Now']     ${Mid Waiting Time}
    Execute Javascript                      document.getElementsByTagName('h3')[1].scrollIntoView({behavior: 'smooth', block: 'center'})
    ${Trending Now}     Get Element Count   //h3[text()='Trending Now']
    Should Not Be Equal As Integers    ${Trending Now}    ${0}
    Sleep  2


Verify The Multiple Store Selection
    [Arguments]    ${Mulit Store Check}    ${Multiple Store Address}   ${Original Store Name}
    ${Re Blue Box List}     Set Variable   PIS
    ${Blue Box List}        Set Variable   Not Set
    ${Address Collection}   Create List
    IF  '${Mulit Store Check}' != 'PIS'
        Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()='${Multiple Store}']/parent::div/following-sibling::div
        ${Blue Box Content}   Run Keyword And Ignore Error    Get Text    //p[text()='${Multiple Store}']/parent::div/following-sibling::div
        IF  '${Blue Box Content}[0]' == 'PASS'
            ${Blue Box List}      Extract Store Name From Web            ${Blue Box Content}[1]
        END
        ${Store Name}    ${Address Collection}     Store Name Extract     ${Multiple Store Address}
        IF  '${Mulit Store Check}' == 'Combined'
            ${Store Name}=  Evaluate   ${Store Name} + ['${Original Store Name}']
        END
        ${Re Blue Box List}   ${Re Store Name}    Rearrange Lists    ${Blue Box List}   ${Store Name}
        Run Keyword And Warn On Failure    Should Be Equal    ${Re Blue Box List}   ${Re Store Name}
        FOR   ${name}   IN   @{Re Store Name}
            ${Multi Check}   Get Element Count  //*[contains(text(), '${name}')]
            IF  '${name}' == '${Original Store Name}'
                Run Keyword And Warn On Failure  Should Be True   ${Multi Check} > 3
            ELSE
                Run Keyword And Warn On Failure  Should Be True   ${Multi Check} == 2
            END
        END
    END

    [Return]   ${Re Blue Box List}    ${Address Collection}


If Ignore Error
    ${status}    Run Keyword And Ignore Error     Wait Until Page Contains Element     //p[text()="Error"]    5
    IF    "${status[0]}" == "PASS"
        Wait Until Page Contains Element    //div[text()="CLOSE"]/..
        Click Element     //div[text()="CLOSE"]/..
    END

Change zipcode
    [Arguments]    ${zipcode}
    Wait Until Page Contains Element     //p[text()="Change"]
    Click Element     //p[text()="Change"]



Click Proceed To Checkout Button
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]     ${Long Waiting Time}
    Run Keyword And Warn On Failure    Wait Until Element Is Visible    //*[text()="Shopping Cart"]
#    If Ignore Error
#    Change ZipCode Adjust Glade Parks      75260
    Run Keyword And Warn On Failure     Wait Until Element Is Visible    //p[text()="Remove All Items"]
    Scroll Element Into View    //div[text()='PROCEED TO CHECKOUT']
    Wait Until Element Is Enabled    //div[text()='PROCEED TO CHECKOUT']/parent::button
    Wait Until Element Is Visible    //div[text()='PROCEED TO CHECKOUT']/parent::button
    Click Button   //div[text()='PROCEED TO CHECKOUT']/parent::button

Paypal Payment in Cart
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]     ${Long Waiting Time}
    Paypal Payment


clear cart if test case fail
    IF   "${TEST_STATUS}" == "FAIL"
        Clear Cart
    END


clear cart
    ${current_url}    Get Location
    ${url}    Split Parameter    ${current_url}    /
    IF    "${url[-1]}" != "cart"
        go to   ${Home URL}/cart
    END
    sleep    2
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]     ${Long Waiting Time}
    Run Keyword And Warn On Failure    Wait Until Element Is Visible    //*[text()="Shopping Cart"]
#    If Ignore Error
    ${is_popup}    Get Element Count    //p[text()="Order Fulfillment Error"]
    IF   ${is_popup} > 0
        Click Element    //div[text()="Got it!"]/..
    END
    ${remove_all_items_ele}     Set Variable     //p[text()="Remove All Items"]
    ${isRemove}   Get Element Count     ${remove_all_items_ele}
    IF   ${isRemove} > 0
        Page Should Contain Element     ${remove_all_items_ele}
        Wait Until Element Is Enabled     ${remove_all_items_ele}
        Close Cart Initiate Error popup
        Click Element    ${remove_all_items_ele}
        Wait Until Element Is Visible    //p[text()="Remove All Products?"]
        Click Element    //div[text()="Yes"]
        Run Keyword And Warn On Failure     Wait Until Element Is Visible    //h3[text()="(0 item)"]
    END



login in shopping cart page
    [Arguments]     ${user}    ${password}
    Wait Until Element Is Visible    //h3[contains(text(),"Sign in to your account")]
    wait until element is visible    //input[@id="email"]
    click element    //input[@id="email"]
    input text    //input[@id="email"]    ${user}
    input text    //input[@id="newPassword"]    ${password}
    click button    //div[text()="SIGN IN"]/parent::button
    ${user_information}    Get Account Info
    Set Suite Variable     ${USER_INFO}    ${user_information}


login in header
    [Arguments]     ${user}    ${password}
    Wait Until Page Contains Element    //p[text()="Sign In"]/parent::div
    Wait Until Element Is Visible     //p[text()="Sign In"]/parent::div
    mouse over    //p[text()="Sign In"]/parent::div
    Wait Until Page Contains Element     //p[text()="Sign In"]/parent::a
    Click Element    //p[text()="Sign In"]/parent::a
    Login Without Open Browser     ${user}    ${password}
    ${user_information}    Get Account Info
    Set Suite Variable     ${USER_INFO}    ${user_information}


change store from cart
    [Arguments]   @{sku_nums}
    sleep   2
    Run Keyword And Warn On Failure    Wait Until Element Is Visible    //*[text()="Shopping Cart"]
    Run Keyword And Warn On Failure    Wait Until Page Contains Element    //h3[text()="Trending Now"]
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    @{stores_text}   Create List
    FOR   ${sku_num}   IN   @{sku_nums}
        ${change_store_ele}   Set Variable    //a[contains(@href,"${sku_num}")]/ancestor::div[3]//p[text()="Change Store"]
        Scroll Element Into View    ${change_store_ele}
        Wait Until Element Is Enabled    ${change_store_ele}
        Wait Until Element Is Visible    ${change_store_ele}
        Click Element    ${change_store_ele}
        Wait Until Element Is Visible     //p[text()="Sort By"]
        Wait Until Element Is Visible     //p[text()="Stores in your Range"]
        Wait Until Element Is Visible     //table
        Select From List By Label     //p[text()="Sort By"]/following-sibling::select    Number In Stock
        sleep   2
        Wait Until Element Is Visible
        Click Element    //table/tr[1]/div//input
        ${store_text}   Get Text   //table/div/tr/td[5]
        ${stores_text}   Split Parameter    ${store_text}   \n
        Click Element    //div[text()="Update Pickup Location"]
        Wait Until Element Is Visible    //h3[text()="Order Summary"]
        Append To List    ${stores_text}   ${store_text[0]}    ${store_text[-1]}
    END
    [Return]   ${stores_text}


check shopping cart
    [Arguments]    ${product_info}
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Run Keyword And Warn On Failure     Wait Until Element Is Visible    //*[text()="Shopping Cart"]
    Run Keyword And Warn On Failure     Wait Until Element Is Visible    //h3[text()="Order Summary"]
    check pickup multiple store tips    ${product_info}
    check skus info in cart    ${product_info}
    ${item_sums}    ${store_subtotals}    ${A_store_item_sums}    ${A_store_subtotals}    get cart all items and subtotal
    check cart store items    ${A_store_item_sums}
    check order summary    ${item_sums}   ${store_subtotals}   cart


check skus info in cart
    [Arguments]    ${product_info}
    @{micheals_store_qty}   Create List
    @{micheals_store_amount}   Create List
    @{MKR_store}   Create List
    FOR   ${sku_info}   IN   @{product_info}
        ${sku_ele}   Set Variable   //a[contains(@href,"${sku_info}[sku]")]
        Scroll Element Into View    ${sku_ele}/ancestor::div[1]
        ${sku_name}   Get Text   ${sku_ele}/ancestor::div[1]/p
        ${sku_num}    Get Text   ${sku_ele}/ancestor::div[1]/div/div[1]
#        Scroll Element Into View    ${sku_ele}/ancestor::div[3]//input
        log   ${sku_ele}/ancestor::div[3]//input
        ${qty_ele_count}   Get Element Count   ${sku_ele}/ancestor::div[2][@type="SaveforLater"]/preceding-sibling::div//input
        ${qty_eles}   Get Webelements    ${sku_ele}/ancestor::div[2][@type="SaveforLater"]/preceding-sibling::div//input
        IF   ${qty_ele_count} > 1
            ${qty}   Get Element Attribute   ${qty_eles[-1]}   value
        ELSE
            ${qty}   Get Element Attribute   ${qty_eles}   value
        END
        IF   ${sku_info}[qty] == 1
            ${price}   Get Text    ${sku_ele}/ancestor::div[2]/following-sibling::div/p[1]
            IF   "SALE" in "${price}"
                ${price}    Set Variable    ${price[5:]}
            END
        ELSE
            ${A_sku_subtotal}   Get Text    ${sku_ele}/ancestor::div[2]/following-sibling::div/p[1]
            IF   "SALE" in "${A_sku_subtotal}"
                ${A_sku_subtotal}   Set Variable    ${A_sku_subtotal[5:]}
                ${reg_price_text}   Get Text    ${sku_ele}/ancestor::div[2]/following-sibling::div/p[contains(text(),"Reg")]
                Run Keyword And Warn On Failure    Should Be Equal As Strings    Reg ${sku_info}[reg_price]    ${reg_price_text}
            END
            ${price_text}   Get Text   ${sku_ele}/ancestor::div[2]/following-sibling::div/p[2]
            ${price}   Set Variable    ${price_text[5:]}
            ${E_sku_subtotal}    Evaluate    ${price[1:]}*${qty}
            Run Keyword And Warn On Failure    Should Be Equal As Strings    $${E_sku_subtotal}    ${A_sku_subtotal}
            Run Keyword And Warn On Failure    Should Be Equal As Strings    Each ${sku_info}[price]    ${price_text}
        END
#        IF   "SALE" in "${price}"
#            ${price}   Set Variable    ${price[5:]}
#        END
        IF   "${sku_info}[channel]" == "MIK" or "${sku_info}[channel]" == "MKP"
            Append To List    ${micheals_store_qty}    ${qty}
            IF   ${sku_info}[qty] == 1
                Append To List    ${micheals_store_amount}    ${price}
            ELSE
                Append To List    ${micheals_store_amount}    ${A_sku_subtotal}
            END
        ELSE IF    "${sku_info}[channel]" == "MKR"
            Append To List    ${MKR_store}    ${sku_info}[store_name]
        END
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${sku_name}    ${sku_info}[product_name]
#        Should Be Equal As Strings    Item:${sku_info}[sku]   ${sku_num}
        Run Keyword And Warn On Failure    Should Be Equal As Strings    qty:${sku_info}[qty]   qty:${qty}
        Run Keyword And Warn On Failure    Should Be Equal As Strings    price:${sku_info}[price]   price:${price}
        IF   "${sku_info}[channel]" == "MIK" and "${sku_info}[product_type]" == "listing"
            IF   "${sku_info}[shipping_method]" == "PIS"
                ${pis_class}   Get Element Attribute    ${sku_ele}/../../..//P[contains(text(),"Pickup")]/../../div//*[name()="svg"]   class
                ${pis_stroke}   Get Element Attribute    ${sku_ele}/../../..//P[contains(text(),"Pickup")]/../../div//*[name()="svg"]    stroke
                Run Keyword And Warn On Failure    Should Be Equal As Strings    ${pis_class}    icon icon-tabler icon-tabler-circle-check
                Run Keyword And Warn On Failure    Should Be Equal As Strings    "${pis_stroke}"   "#CF1F2E"
            ELSE IF    "${sku_info}[shipping_method]" == "STM"
                ${stm_class}   Get Element Attribute    ${sku_ele}/../../..//P[contains(text(),"Ship to me")]/../../div/*[name()="svg"]   class
                ${stm_stroke}   Get Element Attribute    ${sku_ele}/../../..//P[contains(text(),"Ship to me")]/../../div//*[name()="svg"]    stroke
                Run Keyword And Warn On Failure    Should Be Equal As Strings    ${stm_class}    icon icon-tabler icon-tabler-circle-check
                Run Keyword And Warn On Failure    Should Be Equal As Strings    "${stm_stroke}"    "#CF1F2E"
            ELSE IF    "${sku_info}[shipping_method]" == "SDD"
                ${sdd_class}   Get Element Attribute    ${sku_ele}/../../..//P[contains(text(),"Same Day Delivery")]/../../div/*[name()="svg"]   class
                ${sdd_stroke}   Get Element Attribute    ${sku_ele}/../../..//P[contains(text(),"Same Day Delivery")]/../../div//*[name()="svg"]    stroke
                Run Keyword And Warn On Failure    Should Be Equal As Strings    ${sdd_class}    icon icon-tabler icon-tabler-circle-check
                Run Keyword And Warn On Failure    Should Be Equal As Strings    "${sdd_stroke}"    "#CF1F2E"
            END
        END
    END


get cart all items and subtotal
    ${store_eles}   Get Webelements    //*[text()="Shopping Cart"]/../../div[1]/following-sibling::div[1]/div[1]/div
    ${is_save_for_later}   Get Element Count    //h3[text()="Save for Later"]
    ${len}   Get Length    ${store_eles}
    IF   ${is_save_for_later} > 0
        ${len}   Evaluate    ${len}-2
    ELSE
        ${len}   Evaluate    ${len}-1
    END
    @{A_store_item_sums}   Create List
    @{A_store_subtotals}   Create List
    @{A_store_item_sums_int}   Create List
    FOR   ${num}    IN RANGE   ${len}
        ${num}   Evaluate    ${num}+2
        ${item_subtotal_info}   Get Text    //h3[text()="Order Summary"]/../../preceding-sibling::div/div[${num}]/div[1]
        ${item_subtotal_info}   Split Parameter    ${item_subtotal_info}   \n
        ${store_item_sum}   Set Variable    ${item_subtotal_info[1][1:-1]}
        ${store_item_sum_int}   Evaluate   int(${store_item_sum.split(" ")[0]})
        ${store_subtotal}   Set Variable    ${item_subtotal_info[2][11:]}
        ${store_subtotal}   Evaluate    float("%.2f" %${store_subtotal})
        Append To List    ${A_store_item_sums}    ${store_item_sum}
        Append To List    ${A_store_item_sums_int}    ${store_item_sum_int}
        Append To List    ${A_store_subtotals}    ${store_subtotal}
    END
    ${A_store_subtotals}   Evaluate    sum(${A_store_subtotals})
    ${store_subtotals}   Evaluate    "{:.2f}".format(${A_store_subtotals})
    ${item_sums}   Evaluate   sum(${A_store_item_sums_int})
    [Return]    ${item_sums}    ${store_subtotals}    ${A_store_item_sums}    ${A_store_subtotals}


check cart store items
    [Arguments]    ${A_store_item_sums}
    @{E_store_item_sums}   Create List
    @{E_store_subtotal}    Create List
    ${store_eles}   Get Webelements    //h3[text()="Order Summary"]/../../preceding-sibling::div/div
    ${is_save_for_later}   Get Element Count    //h3[text()="Save for Later"]
    ${len}   Get Length    ${store_eles}
    IF   ${is_save_for_later} > 0
        ${len}   Evaluate    ${len}-2
    ELSE
        ${len}   Evaluate    ${len}-1
    END
    FOR   ${i}   IN RANGE   ${len}
        ${i}   Evaluate    ${i}+2
        ${item_qty_eles}   Get Webelements    //h3[text()="Order Summary"]/../../preceding-sibling::div/div[${i}]//input
        @{store_qty}   Create List
        FOR   ${item_qty_ele}   IN   @{item_qty_eles}
            ${item_qty}   Get Element Attribute    ${item_qty_ele}    value
            ${item_qty}   Evaluate    int(${item_qty})
            Append To List    ${store_qty}    ${item_qty}
        END
        ${store_qty_sum}   Evaluate    sum(${store_qty})
        IF   ${store_qty_sum} > 1
            Append To List    ${E_store_item_sums}   ${store_qty_sum} items
        ELSE
            Append To List    ${E_store_item_sums}   ${store_qty_sum} item
        END
    END
    Lists Should Be Equal    ${E_store_item_sums}   ${A_store_item_sums}

Delivering to Zipcode Verify
    [Arguments]    ${Element}
    ${Zip Updated}   Set Variable   Not Set
    Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[text()="${Element} "]    5
    ${Zip Code}    Run Keyword And Ignore Error     Get Text    //p[text()="${Element} "]
    IF  '${Zip Code}[0]' == 'PASS'
        ${Zip Updated}   Extract Last Text    ${Zip Code}[1]
    END
    [Return]    ${Zip Updated}

Change ZipCode Adjust Different ZipCode    #Different ZipCode
    [Arguments]   ${Guest ZipCode}
    ${Zip Display}    Delivering To Zipcode Verify     Delivering to
    IF  '${Zip Display}' != '${Guest ZipCode}'
        Click Element    //p[text()="Change"]
        Input Text       id=zipCode     ${Guest ZipCode}
        Click Element    //button[@formid="zipCode"]
        ${Apply Check}   Run Keyword And Ignore Error   Wait Until Element Is Visible   //p[contains(text(), "is already applied")]    3
        IF  '${Apply Check}[0]' == 'PASS'
            Set Focus To Element   id=zipCode
            Clear Element Text     id=zipCode
            Input Text             id=zipCode     ${Guest ZipCode}
            Click Element    //button[@formid="zipCode"]
        END

        ${Updated ZipCode}    Delivering To Zipcode Verify     Delivering to
        ${Verify Res}  Run Keyword And Warn On Failure   Should Be Equal As Strings    ${Updated ZipCode}  ${Guest ZipCode}
    END
    [Return]   ${Verify Res}


Click Save For Later Button By Index
    [Arguments]     ${index}
    Wait Until Page Contains Element     (//div[text()="Save for Later"])\[${index}\]
    Wait Until Element Is Visible     (//div[text()="Save for Later"])\[${index}\]
    Click Element     (//div[text()="Save for Later"])\[${index}\]


Click Move to Cart Button By Index
    [Arguments]     ${index}
    Wait Until Page Contains Element     (//div[text()="Move to Cart"])\[${index}\]
    Wait Until Element Is Visible     (//div[text()="Move to Cart"])\[${index}\]
    Click Element     (//div[text()="Move to Cart"])\[${index}\]


Check Paper Bag Fees In Order Summary
    [Arguments]    ${E_pbf}
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Element Is Visible    //h3[text()="Order Summary"]
    Wait Until Element Is Visible    //*[text()="Total:"]/following-sibling::h4
    Wait Until Element Is Visible    //p[text()="Other Fees"]
    Click Element     //p[text()="Other Fees"]
    Wait Until Element Is Visible     //p[text()="Paper Bag Fees"]/../following-sibling::p
    ${pbf}   Get Text    //p[text()="Paper Bag Fees"]/../following-sibling::p
    Should Be Equal As Strings     ${pbf}    ${E_pbf}     Paper Bag Fees are wrong


Check Paper Bag Fees Not In Order Summary
    [Arguments]    ${E_pbf}
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Wait Until Element Is Visible    //h3[text()="Order Summary"]
    Wait Until Element Is Visible    //*[text()="Total:"]/following-sibling::h4
    Page Should Contain Element     //p[text()="Paper Bag Fees"]/../following-sibling::p


Click SignIn in michaels rewards moudle
    Wait Until Page Contains Element     //div[text()="Sign In"]/..
    Wait Until Element Is Visible     //div[text()="Sign In"]/..
    Click Element    //div[text()="Sign In"]/..