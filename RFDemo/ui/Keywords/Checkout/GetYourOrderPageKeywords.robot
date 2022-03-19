*** Settings ***
Resource    ../../TestData/Checkout/config.robot
Resource    BuyerCheckKeywords.robot
Library     ../../Libraries/Checkout/BuyerKeywords.py
Library     ../../TestData/Checkout/GuestGenerateAddress.py


*** Variables ***


*** Keywords ***
Use USPS Suggested Address
    [Arguments]   ${IF PIS}
    ${Suggested Address}   Set Variable    Not Using Suggested Address
    IF  '${IF PIS}' != 'PIS Only'
        ${Suggested Address}   Get Text    //p[text()='USPS Suggested']//following-sibling::p
        Click Element                      //div[text()='Use USPS Suggestion']
    END
    [Return]   ${Suggested Address}

Checkout Class - Input All Guest Info
    [Arguments]     ${product_info}
#    ${count}    Get Element Count    (//h2[text()="Classes"]/../../../..//div[contains(text(),"Guest")])
    ${status}    If Class In Products     ${product_info}
    IF   "${status}" == "True"
        ${Guest_Ele}    Set Variable    (//h2[text()="Classes"]/../../../..//div[contains(text(),"Guest")])
        Wait Until Page Contains Element     ${Guest_Ele}
        Wait Until Element Is Visible     ${Guest_Ele}
        ${count}    Get Element Count    ${Guest_Ele}
        ${Guest_Data}    Get Class Guest Info    ${count}
        ${index}    Set Variable    1
        FOR    ${Guest_Info}    IN    @{Guest_Data}
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"firstName")]    ${Guest_Info}[firstName]
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"lastName")]    ${Guest_Info}[lastName]
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"email")]    ${Guest_Info}[email]
            Input Text    ${Guest_Ele}\[${index}\]/following-sibling::div//input[contains(@id,"phoneNumber")]    ${Guest_Info}[phone]
            ${index}    Evaluate    ${index}+1
        END
    END

Adding The Personal Infomation For the Getting Your Order Page
    [Arguments]    ${IF PIS}    ${product_channel_info}    ${Class Set Qty}
    ${Class Length}    Get Length    ${Class Set Qty}

    IF  '${IF PIS}' == 'PIS Only'
    Wait Until Element Is Visible      //h3[text()="Pick Up Person Information"]
        FOR    ${key}   ${value}   IN ZIP   ${pickupInfo.keys()}    ${pickupInfo.values()}
            Wait Until Element Is Visible    //input[@id='${key}']
            Input Text    //input[@id='${key}']       ${value}
        END
    ELSE
        FOR    ${key}   ${value}   IN ZIP   ${guestInfo.keys()}    ${guestInfo.values()}
            Input Text    //input[@id='${key}']       ${value}
        END
        IF  ${Class Length} > 0
            FOR   ${i}  IN RANGE  ${Class Length}
                FOR   ${j}  IN RANGE  ${Class Set Qty[${i}]}
                    Execute JavaScript     window.scrollTo(0, document.body.scrollHeight)
                    Input Text   (//input[@id='firstName${j}'])[${i + 1}]     ${classInfo['firstName${j + 1}']}
                    Input Text   (//input[@id='lastName${j}'])[${i + 1}]      ${classInfo['lastName${j + 1}']}
                    Input Text   (//input[@id='email${j}'])[${i + 1}]         ${classInfo['email${j + 1}']}
                    Input Text   (//input[@id='phoneNumber${j}'])[${i + 1}]   ${classInfo['phoneNumber${j + 1}']}
                END
            END

        END
    END


Click Next: Payment & Order Review Button
    sleep    3
    Wait Until Page Contains Element     //h3[text()="Order Summary"]
    Wait Until Element Is Visible     //h3[text()="Order Summary"]
    Wait Until Element Is Visible     //p[text()="Total:"]
    Scroll Element Into View    //h3[text()="Order Summary"]
    Wait Until Element Is Enabled    //div[text()="Next: Payment & Order Review"]/parent::button
    Click Button    //div[text()="Next: Payment & Order Review"]/parent::button

#If toast
#    ${is_toast}    Get Element Count     //li[@class="chakra-toast"]
#    IF   ${is_toast} > 0
#        ${text}    Get Text    //li[@class="chakra-toast"]//p
#    END



check getting your order page
    [Arguments]    ${product_info}
    Wait Until Element Is Visible    //h2[contains(text(),"Getting your Order")]
    check pickup multiple store tips    ${product_info}
    check delivery address
    Check SDD Fee    ${product_info}
#    check sku pickup location    GYO   ${product_info}
#    ${skus_subtotal}    check sku info in GYO or OR page    ${product_info}
    ${skus_subtotal}    ${total_items}    Check Skus Info in GYO or OR Page    ${product_info}
#    ${total_items}    get items from GYO or OR page
    check order summary    ${total_items}   ${skus_subtotal}   GYO



get total shipping fee from your order page
    ${total_shipping_fees}    Set Variable    $0.00
    ${is_checked}   Get Element Count    //h4/parent::span[@data-checked]
    IF   ${is_checked} > 0
        ${checked_eles}    Get Webelements    //h4/parent::span[@data-checked]/h4
        @{shipping_fees_list}    Create List
        FOR   ${checked_ele}   IN   @{checked_eles}
            ${text}    Get Text    ${checked_ele}
            ${text}    Split Parameter    ${text}   -
            ${shipping_fee}    Set Variable    ${text[-1]}
            IF   "FREE" in "${shipping_fee}"
                ${shipping_fee}   Set Variable   0.00
            ELSE
                ${shipping_fee}    Set Variable    ${text[-1][2:]}
            END
            ${shipping_fee}    Evaluate    float(${shipping_fee})
            Append To List     ${shipping_fees_list}    ${shipping_fee}
        END
        ${total_shipping_fees}    Evaluate    sum(${shipping_fees_list})
        ${total_shipping_fees}   Evaluate    "{:.2f}".format(${total_shipping_fees})
        ${total_shipping_fees}    Catenate    $${total_shipping_fees}
    END
    [Return]    ${total_shipping_fees}


Get Delivery Address
    Wait Until Element Is Visible     //h3[text()="Delivery Address"]/../div/div
    ${delivery_address}    Get Text    //h3[text()="Delivery Address"]/../div/div
    ${delivery_address}    Split Parameter     ${delivery_address}   \n
    [Return]     ${delivery_address}


Check Delivery Address
    ${delivery_address}     Get Delivery Address
    Set Suite Variable     ${DELIVERY_ADDRESS}     ${delivery_address}
    ${delivery_address}     Catenate    ${delivery_address[0]},${delivery_address[1]}${delivery_address[2]}${delivery_address[3]}
    ${address}    Upper Parameter    ${USER_INFO[2]}
    ${phone}    Set Variable     ${USER_INFO[3]}
    ${E_delivery_address}    Catenate     ${USER_INFO[0]} ${USER_INFO[1]},${address},${phone}
    Run Keyword And Warn On Failure    Should Be Equal As Strings     ${E_delivery_address}     ${delivery_address}    Delivery address are inconsistent in getting your order page

Get SDD Fee
    Wait Until Element Is Visible     //h2[contains(text(),"Same Day Delivery")]/../../../following-sibling::div/div[2]/p
    ${SDD_fee}   Get Text    //h2[contains(text(),"Same Day Delivery")]/../../../following-sibling::div/div[2]/p
    ${SDD_fee}   Split Parameter    ${SDD_fee}    -
    ${SDD_fee}   Set Variable    ${SDD_fee[1][1:]}
    [Return]    ${SDD_fee}

If Class in Products
    [Arguments]     ${product_info}
    @{product_type_list}    Create List
    FOR    ${sku_info}    IN    @{product_info}
        ${product_type}    Set Variable    ${sku_info}[product_type]
        IF   "${product_type}" == "class"
            Append To List     ${product_type_list}    ${product_type}
        END
    END
    ${status}     Set Variable If    "class" in ${product_type_list}    True
#    Run Keyword And Return Status     List Should Contain Value     ${product_type_list}    class
#    Set Variable If    ${product_type_list} > 0    True
    [Return]     ${status}



Check SDD Fee
    [Arguments]    ${product_info}
    @{shipping_method_list}    Create List
    @{channel_list}    Create List
    @{skus_amount}     Create List
    FOR    ${sku_info}    IN    @{product_info}
        ${shipping_method}    Set Variable    ${sku_info}[shipping_method]
        ${channel}    Set Variable     ${sku_info}[channel]
        ${price}    Set Variable    ${sku_info}[price]
        ${qty}    Set Variable    ${sku_info}[qty]
        Append To List     ${shipping_method_list}    ${shipping_method}
        Append To List     ${channel_list}     ${channel}
        IF   "${shipping_method}" == "SDD"
            ${sku_amount}   Evaluate    ${price[1:]}*${qty}
            Append To List     ${skus_amount}    ${sku_amount}
        END
    END
    ${skus_subtotal}    Evaluate    sum(${skus_amount})
    ${skus_subtotal}   Evaluate    "{:.2f}".format(${skus_subtotal})
    IF   'SDD' in ${shipping_method_list}
        ${SDD_fee}    Get SDD Fee
        IF   ${skus_subtotal} > 100.00
            Run Keyword And Warn On Failure    Should Be Equal As Strings    ${SDD_fee}    $7.99
        ELSE
            Run Keyword And Warn On Failure    Should Be Equal As Strings    ${SDD_fee}    $9.99
        END
    END


Get Skus Info From GYO Page




get skus info
    [Arguments]     ${sku_info_eles}
    ${reg_price}    Set Variable    ${EMPTY}
    ${variation}    Set Variable    ${EMPTY}
    ${size}    Set Variable    ${EMPTY}
    ${color}    Set Variable     ${EMPTY}
    @{skus_info}    Create List
    FOR    ${sku_info_ele}    IN    @{sku_info_eles}
        ${sku_info}    Get Text    ${sku_info_ele}
        ${sku_info}    Split Parameter    ${sku_info}    \n
        ${product_name}    Set Variable    ${sku_info[0]}
        ${price}    Set Variable    ${sku_info[1]}
        ${qty}    Set Variable     ${sku_info[-1]}
        ${sku_info1}    Get List Value     ${sku_info}    2
        FOR    ${index}    ${value}    IN ENUMERATE     @{sku_info1}
            IF    'Reg' in '${value}'
                ${reg_price}    Set Variable    ${value}
            ELSE IF    'Size:' == '${value}'
                ${size_index}    Evaluate    ${index}+1
                ${size}    Set Variable    ${sku_info1[${size_index}]}
            ELSE IF    'Color:' == '${value}'
                ${color_index}    Evaluate    ${index}+1
                ${color}    Set Variable    ${sku_info1[${color_index}]}
            END
            ${variation}    Create Dictionary    size=${size}    color=${color}
        END
        ${sku_info}    Create Dictionary     product_name=${product_name}    price=${price}    reg_price=${reg_price}    variation=${variation}    qty=${qty}
        Append To List     ${skus_info}     ${sku_info}
    END
    [Return]    ${skus_info}




Get PIS Skus Info2
    Sleep    5
    Wait Until Element Is Visible    //h2[contains(text(),"Getting your Order")]
    Wait Until Element Is Visible    //h3[text()="Order Summary"]
    ${pis_info}    Set Variable     ${EMPTY}
    ${PIS_items}    Set Variable    0
    ${is_PIS}     Get Element Count    //h2[contains(text(),"Pick Up")]
    IF   ${is_PIS} > 0
        ${eles}    Get Webelements     //h2[contains(text(),"Pick Up")]/../../../../div
        ${pis_items_text}    Get Text     ${eles[0]}
        ${pis_items_text}    Split Parameter     ${pis_items_text}    \n
        ${pis_items}     Set Variable     ${pis_items_text[1]}
        ${store_sku_eles}    Get List Value    ${eles}    1
        @{pis_skus_info}    Create List
        FOR    ${index}    ${value}    IN ENUMERATE    @{store_sku_eles}
            ${index}    Evaluate     ${index}+2
            ${one_store_sku_ele}    Set Variable     //h2[contains(text(),"Pick Up")]/../../../../div[${index}]
            # get pick up location info
            ${pis_location_ele}    Set Variable    ${one_store_sku_ele}/div[3]
            ${pis_location_text}    Get Text    ${pis_location_ele}
            ${pis_location_text}    Split Parameter     ${pis_location_text}    \n
            Run Keyword And Warn On Failure     Page Should Contain Element     ${one_store_sku_ele}//p[text()="Add additional pickup person"]/../parent::button
            ${store_city}    Set Variable     ${pis_location_text[1]}
            ${store_address}    Set Variable     ${pis_location_text[2]}
            ${store_phone}    Set Variable     ${pis_location_text[3]}
            ${pis_location}    Create Dictionary    store_city=${store_city}    store_address=${store_address}     store_phone=${store_phone}
            # get sku info
            ${sku_info_eles}    Set Variable    ${one_store_sku_ele}/div[1]/div
            ${sku_info_eles}    Get Webelements     ${sku_info_eles}
            ${sku_info_eles}    Get List Value     ${sku_info_eles}    0   -1
            ${skus_info}     get skus info     ${sku_info_eles}
            ${pis_sku_info}    Create Dictionary     sku_info=${skus_info}    pis_location=${pis_location}
            Append To List     ${pis_skus_info}     ${pis_sku_info}
        END
        ${pis_info}     Create Dictionary    pis_items_qty=${pis_items}     pis_items_info=${pis_skus_info}
    END
    [Return]    ${pis_info}


Get SDD Items Info2
    ${sdd_info}    Set Variable    ${EMPTY}
    ${sdd_items}   Set Variable    0
    ${is_sdd}    Get Element Count    //h2[contains(text(),"Same Day Delivery")]
    IF   ${is_sdd} > 0
        ${eles}    Get Webelements     //h2[contains(text(),"Same Day Delivery")]/../../../../div
        ${sdd_items_text}    Get Text     ${eles[0]}
        ${sdd_items_text}    Split Parameter     ${sdd_items_text}    \n
        ${sdd_items}     Set Variable     ${sdd_items_text[1]}
        ${store_sku_eles}    Get List Value    ${eles}    1
        @{sdd_skus_info}    Create List
        FOR    ${index}    ${value}    IN ENUMERATE    @{store_sku_eles}
            ${index}    Evaluate     ${index}+2
            ${one_store_sku_ele}    Set Variable     //h2[contains(text(),"Same Day Delivery")]/../../../../div[${index}]
            ${sdd_fee_ele}    Set Variable    ${one_store_sku_ele}/div[2]
            ${sdd_fee_text}    Get Text    ${sdd_fee_ele}
            ${sku_info_eles}    Set Variable    ${one_store_sku_ele}/div[1]/div
            ${sku_info_eles}    Get Webelements     ${sku_info_eles}
            ${skus_info}     get skus info     ${sku_info_eles}
            ${sdd_sku_info}    Create Dictionary     sku_info=${skus_info}    sdd_fee=${sdd_fee_text}
            Append To List     ${sdd_skus_info}     ${sdd_sku_info}
        END
        ${sdd_info}    Create Dictionary     sdd_items_qty=${sdd_items}     sdd_items_info=${sdd_skus_info}
    END
    [Return]     ${sdd_info}



Get STH Items Info2
    ${sth_info}    Set Variable    ${EMPTY}
    ${sth_items_qty}   Set Variable    0
    ${is_sth}    Get Element Count    //h2[contains(text(),"Ship to Home")]
    IF   ${is_sth} > 0
        ${sth_items_text}    Get Text     //div[contains(@class,"sth-contain")]/div
        ${sth_items_text}    Split Parameter     ${sth_items_text}    \n
        ${sth_items}     Set Variable     ${sth_items_text[1]}
        ${store_sku_eles}    Get Webelements     //div[contains(@class,"sth-contain")]//div[contains(@class,"ShipItem")]
        @{sth_skus_info}    Create List
        FOR    ${index}    ${value}    IN ENUMERATE    @{store_sku_eles}
            ${index}    Evaluate     ${index}+1
            ${one_store_sku_ele}    Set Variable     //div[contains(@class,"sth-contain")]//div[contains(@class,"ShipItem")][${index}]
            ${sku_info_eles}    Get Webelements     ${one_store_sku_ele}/div[1]/div[1]
            ${skus_info}     get skus info     ${sku_info_eles}
            ${store_name}    Get Text     ${one_store_sku_ele}/div[2]/p[2]
            IF   "${store_name}" == "Michaels"
                ${sth_shipping_info}    Get MIK shipping Info     ${one_store_sku_ele}
            ELSE
                ${sth_shipping_info}    Get EA shipping Info      ${one_store_sku_ele}
            END
            ${sth_sku_info}    Create Dictionary     sku_info=${skus_info}    sth_shipping_info=${sth_shipping_info}    store_name=${store_name}
            Append To List     ${sth_skus_info}     ${sth_sku_info}
        END
        ${sth_info}    Create Dictionary     sth_items_qty=${sth_items}     sth_items_info=${sth_skus_info}
    END
    [Return]    ${sth_info}


Get FGM Items Info2
    # to do
    ${fgm_info}    Set Variable    ${EMPTY}
    ${fgm_items_qty}   Set Variable    0
    ${is_fgm}    Get Element Count    //h2[contains(text(),"Shipped from")]
    IF   ${is_fgm} > 0
        ${fgm_eles}    Set Variable     //div[contains(@class,"fgm-contain")]
        ${fgm_eles}    Get Webelements    ${fgm_eles}
        FOR    ${index}    ${value}    IN ENUMERATE    @{store_sku_eles}
            ${fgm_items_text}    Get Text     //h2[contains(text(),"Shipped from")]/following-sibling::p
            ${fgm_items_text}    Split Parameter     ${fgm_items_text}    \n
            ${fgm_items}     Set Variable     ${fgm_items_text[1]}
        END
    END








Get MIK shipping Info
    [Arguments]    ${one_store_sku_ele}
    ${shipping_info_ele}     Set Variable     ${one_store_sku_ele}/div[1]/div[2]
    Scroll Element Into View    //label[contains(text(),"Is this order a gift")]
    Page Should Contain Element     ${shipping_info_ele}//input[@value="GROUND_STANDARD"]/following-sibling::span[@data-checked][1]
    ${shipping_info}    Get Text     ${one_store_sku_ele}/div[1]/div[2]
    ${shipping_info}    Split Parameter     ${shipping_info}    \n
    ${sth_shipping_info}     Create Dictionary     standard_ground_fee=${shipping_info[0]}     standard_ground_date=${shipping_info[1]}
    ...    overnight_fee=${shipping_info[2]}     overnight_date=${shipping_info[3]}     second_day_fee=${shipping_info[4]}     second_day_date=${shipping_info[5]}
    [Return]    ${sth_shipping_info}

Get EA shipping Info
    [Arguments]     ${one_store_sku_ele}
    ${shipping_info_ele}     Set Variable     ${one_store_sku_ele}/div[1]/div[2]
    Scroll Element Into View    //label[contains(text(),"Is this order a gift")]
    Page Should Contain Element     ${shipping_info_ele}//input[@value="THP_STANDARD"]/following-sibling::span[@data-checked][1]
    ${shipping_info}    Get Text     ${shipping_info_ele}//span[2]
    ${shipping_info}    Split Parameter     ${shipping_info}
    ${Standard_fee}     Set Variable     ${shipping_info[0]}
    ${Standard_date}    Set Variable     ${shipping_info[1]}
    ${Expedited_fee}    Set Variable    ${EMPTY}
    ${Expedited_date}    Set Variable     ${EMPTY}
    FOR    ${index}    ${value}    IN ENUMERATE     @{shipping_info}
        IF    'Expedited' in '${value}'
            ${date_index}    Evaluate    ${index}+1
            ${Expedited_fee}    Set Variable    ${shipping_info[${index}]}
            ${Expedited_date}    Set Variable     ${shipping_info[${date_index}]}
        END
    END
    ${sth_shipping_info}     Create Dictionary     Standard_fee=${Standard_fee}     Standard_date=${Standard_fee}     Expedited_fee=${Expedited_fee}     Expedited_date=${Expedited_date}
    [Return]     ${sth_shipping_info}

USPS Address Handling
    [Arguments]    ${Button}     ${Verify}    ${Trigger}
    Click Element      //div[text()='${Button}']
    ${USPS Verify}    Run Keyword And Ignore Error     Wait Until Element Is Visible    //h4[text()="${Verify}"]    3
    ${USPS Trigger}   Run Keyword And Ignore Error     Wait Until Element Is Enabled    //div[text()="${Trigger}"]    3
    [Return]     ${USPS Verify}   ${USPS Trigger}