*** Settings ***
Library    Collections
Library    ../../Libraries/Checkout/BuyerKeywords.py
Resource    BuyerCheckKeywords.robot
Resource    ../../TestData/Checkout/config.robot



*** Variables ***
${Mid Waiting Time}     8
${Long Waiting Time}    12



*** Keywords ***

check getting your order page
    [Arguments]    ${product_info}
    Wait Until Element Is Visible    //h2[contains(text(),"Getting your Order")]
    check pickup multiple store tips    ${product_info}
    check sku pickup location    GYO   ${product_info}
    ${skus_subtotal}    check sku info in GYO or OR page    ${product_info}
    ${total_items}    get items from GYO or OR page
    check order summary    ${total_items}   ${skus_subtotal}   GYO


check order review page
    [Arguments]    ${product_info}
    Wait Until Element Is Visible    //h2[contains(text(),"Payment & Order Review")]
    Wait Until Page Contains Element     //h3[contains(text(),"Order Review")]
    check pickup multiple store tips     ${product_info}
    check sku pickup location    OR   ${product_info}
    ${skus_subtotal}    check sku info in GYO or OR page    ${product_info}
    ${total_items}    get items from GYO or OR page
    check order summary    ${total_items}   ${skus_subtotal}   OR


check sku info in GYO or OR page
    [Arguments]    ${product_info}
    sleep   5
    @{skus_amount}    Create List
    @{skus_qty}    Create List
    FOR   ${sku_info}   IN   @{product_info}
        ${store_name}   Set Variable   ${EMPTY}
        ${sku_amount}   Set Variable   0.00
        ${channel}   Set Variable    ${sku_info}[channel]
        ${product_type}   Set Variable    ${sku_info}[product_type]
        ${shipping_method}   Set Variable    ${sku_info}[shipping_method]
        IF   "${product_type}" == "listing"
            IF   "${channel}" == "MIK"
                ${sku_name}    Split Parameter    ${sku_info}[product_name]
                ${product_name_ele}    Set Variable    //p[contains(text(),"${sku_name[0]}") and contains(text(),"${sku_name[1]}") and contains(text(),"${sku_name[2]}")]
                Wait Until Page Contains Element    ${product_name_ele}
                Scroll Element Into View    ${product_name_ele}
                Wait Until Page Contains Element    ${product_name_ele}
                ${product_name}   Get Text    ${product_name_ele}/../p[1]
                ${qty}   Get Text    ${product_name_ele}/../p[2]
                ${price}    Get Text    ${product_name_ele}/../div/p[1]
                ${is_reg}   Get Element Count    ${product_name_ele}/../div/p[contains(text(),"Reg")]
                IF   ${is_reg} > 0
                    ${reg_price}    Get Text    ${product_name_ele}/../div/p[2]
#                    ${sku_amount}   Evaluate    ${reg_price[1:]}*${qty[4:]}
                    Run Keyword And Warn On Failure    Should Be Equal As Strings     Reg.${sku_info}[reg_price]    Reg.${reg_price}
                END
                ${sku_amount}   Evaluate    ${price[1:]}*${qty[4:]}
                Run Keyword And Warn On Failure    Should Be Equal As Strings     ${sku_info}[price]    ${price}
                IF   "${shipping_method}" == "STM"
                    ${store_name}    Get Text   ${product_name_ele}/ancestor::div[5]/div[2]/p[2]
                    ${E_store_name}    Capitalize Parameter    ${sku_info}[store_name]
                    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${E_store_name}    ${store_name}
                END
            ELSE IF   "${channel}" == "MKP" or "${channel}" == "MKR"
                ${sku_name}   Set Variable    ${sku_info}[product_name]
                ${product_name_ele}    Set Variable    //p[contains(text(),"${sku_name}")]
                Wait Until Page Contains Element    ${product_name_ele}
                Scroll Element Into View    ${product_name_ele}
                Wait Until Page Contains Element    ${product_name_ele}
                ${product_name}    Get Text   ${product_name_ele}/../p[1]
                ${qty}    Get Text    ${product_name_ele}/../p[2]
                ${price}    Get Text     ${product_name_ele}/../div/p
                ${price_len}   Get Length     ${price}
                IF   ${price_len} > 15
                    ${price_list}   Split Parameter    ${price}   (
                    ${price}    Set Variable    ${price_list[0]}
                    ${Handling_fee}    Set Variable    ${price[1][1:]}
                END
                ${is_reg}   Get Element Count    ${product_name_ele}/../div/p[contains(text(),"Reg")]
                IF   ${is_reg} > 0
                    ${reg_price}    Get Text    ${product_name_ele}/../div/p[3]
#                    ${sku_amount}   Evaluate    ${reg_price[1:]}*${qty[4:]}
                    Run Keyword And Warn On Failure    Should Be Equal As Strings     Reg.${sku_info}[reg_price]    Reg.${reg_price}
                END
#                ${store_name}    Get Text    ${product_name_ele}/../../../following-sibling::div[2]/p[2]
                ${store_name}    Get Text    ${product_name_ele}/ancestor::div[5]/div[2]/p[2]
                ${sku_amount}   Evaluate    ${price[1:]}*${qty[4:]}
                ${E_store_name}    Upper Parameter    ${sku_info}[store_name]
                ${store_name}    Upper Parameter    ${store_name}
                Run Keyword And Warn On Failure    Should Be Equal As Strings     ${sku_info}[price]    ${price}
                Run Keyword And Warn On Failure    Should Be Equal As Strings    ${E_store_name}    ${store_name}
            END
        ELSE IF   "${product_type}" == "class"
            ${sku_name}   Set Variable    ${sku_info}[product_name]
            ${product_name_ele}    Set Variable    //p[contains(text(),"${sku_name}")]
            Wait Until Page Contains Element    ${product_name_ele}
            Scroll Element Into View    ${product_name_ele}
            Wait Until Page Contains Element    ${product_name_ele}
            ${product_name}    Get Text   //p[contains(text(),"${sku_name}")]
            ${qty}    Get Text    ${product_name_ele}/following-sibling::p[4]
            ${price}    Get Text     ${product_name_ele}/following-sibling::p[1]
            ${date}    Get Text    ${product_name_ele}/following-sibling::p[2]
            ${time}    Get Text    ${product_name_ele}/following-sibling::p[3]
            ${store_name}   Get Text    ${product_name_ele}/ancestor::div[5]/div/div[2]/p[2]
            ${sku_amount}   Evaluate    ${price[1:]}*${qty[4:]}
            ${E_store_name}    Capitalize Parameter    ${sku_info}[store_name]
            Run Keyword And Warn On Failure    Should Be Equal As Strings     ${sku_info}[price]    ${price}
            Run Keyword And Warn On Failure    Should Be Equal As Strings    ${E_store_name}    ${store_name}
        END
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${sku_info}[product_name]   ${product_name}
        Run Keyword And Warn On Failure    Should Be Equal As Strings    Qty: ${sku_info}[qty]    ${qty}
        Append To List    ${skus_amount}    ${sku_amount}
        ${sku_qty}   Evaluate   int(${qty[4:]})
        Append To List    ${skus_qty}   ${sku_qty}
    END
    log    ${skus_amount}
    ${skus_subtotal}    Evaluate    sum(${skus_amount})
    ${skus_subtotal}   Evaluate    "{:.2f}".format(${skus_subtotal})
    ${skus_total_qty}   Evaluate    sum(${skus_qty})
    [Return]    ${skus_subtotal}


get items from GYO or OR page
    ${PIS_items}    Set Variable    0
    ${SDD_items}    Set Variable    0
    ${STH_items}    Set Variable    0
    ${MKR_store_items}   Set Variable    0
    ${class_items}   Set Variable   0
    ${is_PIS}   Get Element Count   //h2[text()="Pick Up"]
    IF   ${is_PIS} > 0
        ${PIS_items}   Get Text    //h2[text()="Pick Up"]/following-sibling::p
        ${PIS_items}   Split Parameter   ${PIS_items}
        ${PIS_items}   Evaluate    int(${PIS_items[0][1:]})
        ${PIS_qty_eles}    Get Webelements    //h2[contains(text(),"Pick Up")]/ancestor::div[4]//img/../div/p[2]
        @{PIS_qtys}    Create List
        FOR    ${PIS_qty_ele}    IN    @{PIS_qty_eles}
            ${PIS_qty}    Get Text    ${PIS_qty_ele}
            ${PIS_qty}    Evaluate    int(${PIS_qty[4:]})
            Append To List    ${PIS_qtys}    ${PIS_qty}
        END
        ${PIS_qtys}   Evaluate    sum(${PIS_qtys})
        Run Keyword And Warn On Failure    Should Be Equal As Strings    (${PIS_items} items)    (${PIS_qtys} items)
    END
    ${is_SDD}   Get Element Count   //h2[text()="Same Day Delivery"]
    IF   ${is_SDD} > 0
        ${SDD_items}   Get Text    //h2[text()="Same Day Delivery"]/following-sibling::p
        ${SDD_items}   Split Parameter   ${SDD_items}
        ${SDD_items}   Evaluate    int(${SDD_items[0][1:]})
        ${SDD_qty_eles}    Get Webelements     //h2[contains(text(),"Same Day Delivery")]/ancestor::div[3]//img/../div/p[2]
        @{SDD_qtys}    Create List
        FOR    ${SDD_qty_ele}    IN    @{SDD_qty_eles}
            ${SDD_qty}    Get Text    ${SDD_qty_ele}
            ${SDD_qty}    Evaluate    int(${SDD_qty[4:]})
            Append To List    ${SDD_qtys}    ${SDD_qty}
        END
        ${SDD_qtys}   Evaluate    sum(${SDD_qtys})
        Run Keyword And Warn On Failure    Should Be Equal As Strings    (${SDD_items} items)    (${SDD_qtys} items)
    END
    ${is_STH}   Get Element Count   //p[text()="Ship to Home"]
    IF   ${is_STH} > 0
        ${STH_items}   Get Text    //p[text()="Ship to Home"]/following-sibling::p
        ${STH_items}   Split Parameter   ${STH_items}
        ${STH_items}   Evaluate    int(${STH_items[0][1:]})
        ${STH_qty_eles}    Get Webelements     //p[contains(text(),"Ship to Home")]/ancestor::div[3]//img/../div/p[2]
        @{STH_qtys}    Create List
        FOR    ${STH_qty_ele}    IN    @{STH_qty_eles}
            ${STH_qty}    Get Text    ${STH_qty_ele}
            ${STH_qty}    Evaluate    int(${STH_qty[4:]})
            Append To List    ${STH_qtys}    ${STH_qty}
        END
        ${STH_qtys}   Evaluate    sum(${STH_qtys})
        Run Keyword And Warn On Failure    Should Be Equal As Strings    (${STH_items} items)     (${STH_qtys} items)
    END
    ${MKR_store}    Get Element Count    //p[contains(text(),"Shipped from")]
    ${MKR_store_eles}   Get Webelements    //p[contains(text(),"Shipped from")]/following-sibling::p
    IF   ${MKR_store} > 0
        ${is_MKR_STH}   Get Element Count    //div[contains(@class,"ShipToHome-Contain")]
        ${is_other_STH}    Get Element Count    //div[contains(@class,"ShipToHome-Contain")]//p[contains(text(),"Ship to Home")]
        IF   ${is_other_STH} > 0
            ${is_MKR_STH}    Evaluate    ${is_MKR_STH}-1
        END
        @{MKR_store_items}    Create List
        FOR    ${i}    IN RANGE    ${is_MKR_STH}
            ${i}   Evaluate    ${i}+2
            ${MKR_store_item}    Get Text     (//div[contains(@class,"ShipToHome-Contain")])[${i}]/div[1]/div/p[2]
            ${MKR_store_item}   Split Parameter   ${MKR_store_item}
            ${MKR_store_item}   Evaluate    int(${MKR_store_item[0][1:]})
            Append To List    ${MKR_store_items}    ${MKR_store_item}
            ${one_store_eles}    Get Webelements    (//div[contains(@class,"ShipToHome-Contain")])[${i}]//img/../div/p[2]
            @{one_store_qtys}    Create List
            FOR    ${one_store_ele}    IN    @{one_store_eles}
                ${one_store_qty}    Get Text    ${one_store_ele}
                ${one_store_qty}    Evaluate    int(${one_store_qty[4:]})
                Append To List    ${one_store_qtys}    ${one_store_qty}
            END
            ${one_store_qtys}    Evaluate     sum(${one_store_qtys})
            Run Keyword And Warn On Failure     Should Be Equal As Strings     (${MKR_store_item} items)     (${one_store_qtys} items)
        END
        ${MKR_store_items}    Evaluate    sum(${MKR_store_items})
    END
    ${class}    Get Element Count    //h2[contains(text(),"Classes")]
    ${class_eles}   Get Webelements    //h2[contains(text(),"Classes")]/following-sibling::p
    IF   ${class} > 0
        @{class_items}    Create List
        FOR   ${class_ele}    IN    @{class_eles}
            ${class_item}    Get Text    ${class_ele}
            ${class_item}   Split Parameter   ${class_item}
            ${class_item}   Evaluate    int(${class_item[0][1:]})
            Append To List    ${class_items}    ${class_item}
            #to do
        END
        ${class_items}   Evaluate    sum(${class_items})
    END
    ${total_items}   Evaluate    ${PIS_items}+${SDD_items}+${STH_items}+${MKR_store_items}+${class_items}
    [Return]    ${total_items}


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

get total shipping fee from order review page
    ${total_STH_fees}    Set Variable    $0.00
    ${is_STH_fee}    Get Element Count    //div[contains(@class,"ShipMethodItem")]
    IF    ${is_STH_fee} > 0
        ${STH_fee_eles}   Get Webelements   //div[contains(@class,"ShipMethodItem")]//p
        @{STH_fees}    Create List
        FOR    ${STH_fee_ele}    IN    @{STH_fee_eles}
            ${STH_fee_text}    Get Text    ${STH_fee_ele}
            IF   "- $" in "${STH_fee_text}"
                ${STH_fee_list}    Split Parameter    ${STH_fee_text}   -
                ${STH_fee_text}    Set Variable     ${STH_fee_list[-1]}
                IF   "$0" in "${STH_fee_text}"
                    ${STH_fee}   Set Variable   0.00
                ELSE
                    ${STH_fee}    Evaluate    ${STH_fee_text[2:]}
                END
                ${STH_fee}    Evaluate    float(${STH_fee})
                Append To List     ${STH_fees}    ${STH_fee}
            END
        END
        ${total_STH_fees}    Evaluate    sum(${STH_fees})
        ${total_STH_fees}   Evaluate    "{:.2f}".format(${total_STH_fees})
        ${total_STH_fees}    Catenate    $${total_STH_fees}
    END
    [Return]    ${total_STH_fees}


get total SDD fee from GYO or OR page
    ${total_SDD_fees}    Set Variable    0.00
    ${is_SDD}   Get Element Count   //h2[text()="Same Day Delivery"]
    IF   ${is_SDD} > 0
        ${SDD_text}    Get Text    //h2[contains(text(),"Same Day Delivery")]/../../../following-sibling::div/div[2]/p
        ${SDD_text}    Split Parameter     ${SDD_text}
        ${SDD_fee}    Set Variable     ${SDD_text[-1]}
    END
    [Return]    ${SDD_fee}



check pickup multiple store tips
    [Arguments]    ${product_info}
    ${is_mul_store}   Get Element Count    //p[contains(text(),"Multiple pickup location are selected in this order:")]
    IF   ${is_mul_store} > 0
        ${len}   Get Element Count    //p[contains(@class,"chakra-text")]
        ${len}   Evaluate    ${len}-1
        ${pis_store_eles}   Get Webelements    //p[contains(@class,"chakra-text")]
        @{A_pis_store_names}   Create List
        FOR   ${i}    IN RANGE    ${len}
            ${i}   Set Variable    ${i}+1
            ${pis_store_name}    Get Text    ${pis_store_eles[${i}]}
            Append To List    ${A_pis_store_names}    ${pis_store_name}
        END
        @{pis_store_names}   Create List
        FOR   ${sku_info}   IN   @{product_info}
            ${shipping_method}   Set Variable    ${sku_info}[shipping_method]
            ${pis_location}    Set Variable    ${sku_info}[pis_location]
            IF   "${shipping_method}" == "PIS"
                ${store_name}   Set Variable    ${pis_location}[store_name]
                Append To List    ${pis_store_names}    ${store_name}
            END
        END
        Run Keyword And Warn On Failure    Lists Should Be Equal    ${pis_store_names}     ${A_pis_store_names}
    END


check sku pickup location
    [Arguments]    ${page}   ${product_info}
    ${is_pickup_location}   Get Element Count    //p[contains(text(),"Pickup Location :")]
    IF   ${is_pickup_location} > 0
        FOR   ${i}   IN RANGE    ${is_pickup_location}
            ${i}    Evaluate    ${i}+1
            FOR   ${sku_info}   IN   @{product_info}
                ${shipping_method}   Set Variable    ${sku_info}[shipping_method]
                IF   "${shipping_method}" == "PIS"
                    ${pis_location}    Set Variable    ${sku_info}[pis_location]
                    ${Pickup Location_eles}    Set Variable     (//p[contains(text(),"Pickup Location :")])
                    IF   "${page}" == "GYO"
                        Wait Until Page Contains Element    (${Pickup Location_eles}/../div[1])\[${i}\]
                        log   (${Pickup Location_eles}/../div[1])\[${i}\]
                        ${pickup_location_address}    Get Text   (${Pickup Location_eles}/../div[2])\[${i}\]/div/p
                        ${store_phone}    Get Text    ${Pickup Location_eles}[${i}]/../div[2]/p
                        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${pis_location}[store_address]    ${pickup_location_address}
                        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${pis_location}[store_phone]    ${store_phone}
                    ELSE IF   "${page}" == "OR"
                        Wait Until Page Contains Element    (${Pickup Location_eles}/../div[1])\[${i}\]
                        ${pickup_location_address}    Get Text   (${Pickup Location_eles}/../div[2])\[${i}\]/div/p
                        ${store_phone}    Get Text    ${Pickup Location_eles}[${i}]/../div[2]/p
                        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${pis_location}[store_address]    ${pickup_location_address}
                        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${pis_location}[store_phone]    ${store_phone}
                    END
                END
                Exit For Loop
            END
        END
    END





check delivery address
    ${delivery_address}    Get Text    //h3[text()="Delivery Address"]/../div/div
    ${delivery_address}    Split Parameter    ${delivery_address}   \n
    # to do


get account info


















