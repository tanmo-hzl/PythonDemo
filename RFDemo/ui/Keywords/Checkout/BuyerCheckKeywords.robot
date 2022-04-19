*** Settings ***
Library    Collections
Library    ../../Libraries/Checkout/BuyerKeywords.py
Resource     Common.robot


*** Variables ***



*** Keywords ***


check the order No. with add to cart
    Get order no from order confirmation
    ${a_orderNo}    Get order no from order history
    Run Keyword And Warn On Failure    should be equal as strings    ${ORDER_NO}    ${a_orderNo}
#    go to   ${Home URL}/cart
#    Wait Until Element Is Visible    //*[text()="Shopping Cart"]
#    Run Keyword And Warn On Failure     Wait Until Element Is Visible   //h4[text()="Your shopping cart is empty"]
#    Run Keyword And Warn On Failure     Wait Until Element Is Visible   //h3[text()="(0 items)"]

Get order no from order confirmation
    wait until element is visible    //h2[text()="Thank you, your order has been placed!"]
    Wait Until Element Is Visible    //h2[text()="Order Confirmation"]
    ${e_orderNo_text}    get text    //h2[contains(text(),"Order Confirmation")]/../div/div/p
    ${e_orderNo}    evaluate    ${e_orderNo_text.split(" ")[2]}
    Set Suite Variable    ${ORDER_NO}    ${e_orderNo}
    log    ck_order_number:${ORDER_NO}



Get order no from order history
    sleep    1
    go to    ${Home URL}/buyertools/order-history
    Sleep    2
    Wait Until Page Contains Element     //input[@id="searchOrders"]
    Wait Until Element Is Visible    //input[@id="searchOrders"]
    ${orderNo_text}    get text    (//p[text()="Order Number"]/following-sibling::p)[1]
    ${orderNo}    Set Variable    ${orderNo_text[1:]}
    [Return]     ${orderNo}

check order summary
    [Arguments]    ${item_sums}   ${store_subtotals}    ${page}=cart
    ${order_summary_eles}   Get Webelements    //h3[text()="Order Summary"]/../div
    ${subtotal_text}   Get Text    ${order_summary_eles[0]}
    ${subtotal_text}   Split Parameter    ${subtotal_text}   \n
    ${A_item_nums}   Set Variable    ${subtotal_text[0]}
    ${A_subtotal}    Set Variable    ${subtotal_text[1]}
    IF   ${item_sums} == 1
        Run Keyword And Warn On Failure    Should Be Equal As Strings    Subtotal (${item_sums} item)    ${A_item_nums}
    ELSE
        Run Keyword And Warn On Failure    Should Be Equal As Strings    Subtotal (${item_sums} items)    ${A_item_nums}
    END
    Run Keyword And Warn On Failure    Should Be Equal As Strings    $${store_subtotals}   ${A_subtotal}
    ${estimated_tax}   Get Text   //p[text()="Estimated Tax"]/following-sibling::p
    IF   "${estimated_tax}" == "TBD"
        ${estimated_tax}   Set Variable   0.00
    ELSE
        ${estimated_tax}   Set Variable   ${estimated_tax[1:]}
    END
    ${is_estimated_shipping}    Get Element Count    //p[text()="Estimated Shipping"]/following-sibling::p
    IF    ${is_estimated_shipping} > 0
        ${estimated_shipping}   check estimated shipping in different page    ${page}
    ELSE
        ${estimated_shipping}   Set Variable    0.00
    END
    ${saving}    Set Variable    0.00
    ${SDD_fee}   Set Variable    0.00
    ${other_fee}   Set Variable    0.00
    ${is_saving}   Get Element Count   //p[text()="Savings"]
    IF   ${is_saving} > 0
        ${saving}   Get Text   //p[text()="Savings"]/following-sibling::p
        ${saving}   Set Variable    ${saving[2:]}
    END
    ${is_SDD}   Get Element Count    (//h3[text()="Order Summary"]/../div)/p[text()="Same Day Delivery"]
    IF   ${is_SDD} > 0
        ${SDD_fee}   Get Text   //h3[text()="Order Summary"]/../div/p[text()="Same Day Delivery"]/following-sibling::p
        IF   "${page}"=="GYO" or "${page}"=="OR"
            ${E_SDD_fee}   get total SDD fee from GYO or OR page
            Run Keyword And Warn On Failure    Should Be Equal As Strings    ${E_SDD_fee}    ${SDD_fee}
        END
        ${SDD_fee}   Set Variable    ${SDD_fee[1:]}
    END
    ${is_other_fee}   Get Element Count    //p[text()="Other Fees"]
    IF   ${is_other_fee} > 0
        ${other_fee}   Get Text   //p[text()="Other Fees"]/following-sibling::p
        ${other_fee}   Set Variable   ${other_fee[1:]}
    END
    ${A_total}   Get Text    //*[text()="Total:"]/following-sibling::h4
    ${A_subtotal}    Set Variable    ${A_subtotal[1:]}
    IF   "${page}"=="cart"
        ${E_total}   Evaluate    float(${A_subtotal})-float(${saving})+float(${SDD_fee})+float(${other_fee})
    ELSE IF   "${page}"=="GYO" or "${page}"=="OR"
    ${E_total}   Evaluate    float(${A_subtotal})-float(${saving})+float(${SDD_fee})+float(${other_fee})+float(${estimated_shipping})+float(${estimated_tax})
    END
    ${E_total}   Evaluate    format(${E_total},".2f")
    Run Keyword And Warn On Failure    Should Be Equal As Strings    ${A_total}    $${E_total}


check estimated shipping in different page
    [Arguments]    ${page}
    ${estimated_shipping}   Get Text   //p[text()="Estimated Shipping"]/following-sibling::p
    IF   "${page}"=="cart"
        IF   "${estimated_shipping}" == "Free"
            Run Keyword And Warn On Failure    Should Be Equal As Strings    ${estimated_shipping}   Free
        ELSE
            Run Keyword And Warn On Failure    Should Be Equal As Strings    ${estimated_shipping}   TBD
        END
    ELSE IF   "${page}"=="GYO"
        ${total_shipping_fees}    get total shipping fee from your order page
        ${estimated_shipping}    check estimated shipping in GYO or OR page     ${total_shipping_fees}    ${estimated_shipping}
    ELSE IF   "${page}"=="OR"
        ${total_shipping_fees}   get total shipping fee from order review page
        ${estimated_shipping}    check estimated shipping in GYO or OR page     ${total_shipping_fees}    ${estimated_shipping}
    END
    [Return]    ${estimated_shipping}


check estimated shipping in GYO or OR page
    [Arguments]    ${total_shipping_fees}    ${estimated_shipping}
    IF   "${total_shipping_fees}" == "$0.0" or "${total_shipping_fees}" == "$0.00"
        Run Keyword And Warn On Failure    Should Be Equal As Strings    Free    ${estimated_shipping}
    ELSE
        Run Keyword And Warn On Failure    Should Be Equal As Strings    ${total_shipping_fees}    ${estimated_shipping}
    END
    IF   "${estimated_shipping}" == "Free"
        ${estimated_shipping}    Set Variable    0.00
    ELSE
        ${estimated_shipping}    Set Variable    ${estimated_shipping[1:]}
    END
    [Return]    ${estimated_shipping}


check pickup multiple store tips
    [Arguments]    ${product_info}
    @{pis_store_names}   Create List
    FOR   ${sku_info}   IN   @{product_info}
        ${shipping_method}   Set Variable    ${sku_info}[shipping_method]
        ${pis_location}    Set Variable    ${sku_info}[pis_location]
        IF   "${pis_location}" != "${EMPTY}"
            ${store_name}   Set Variable    ${pis_location}[store_name]
            Append To List    ${pis_store_names}    ${store_name}
        END
    END
    ${pis_store_len}    Get Length     ${pis_store_names}
    IF    ${pis_store_len} > 1
        ${len}   Get Element Count    //p[contains(@class,"chakra-text")]
        ${len}   Evaluate    ${len}-1
        ${pis_store_eles}   Get Webelements    //p[contains(@class,"chakra-text")]
        @{A_pis_store_names}   Create List
        @{A_pis_store_names}   Create List
        FOR   ${i}    IN RANGE    ${len}
            ${i}   Set Variable    ${i}+1
            ${pis_store_name}    Get Text    ${pis_store_eles[${i}]}
            Run Keyword And Warn On Failure     List Should Contain Value    ${pis_store_names}    ${pis_store_name}
#            Append To List    ${A_pis_store_names}    ${pis_store_name}
        END
    END


get total SDD fee from GYO or OR page
    ${total_SDD_fees}    Set Variable    0.00
    ${is_SDD}   Get Element Count   //h2[text()="Same Day Delivery"]
    IF   ${is_SDD} > 0
        ${SDD_text}    Get Text    //h2[contains(text(),"Same Day Delivery")]/../../../following-sibling::div/div[2]/p
        ${SDD_text}    Split Parameter     ${SDD_text}
        ${SDD_fee}    Set Variable     ${SDD_text[-1]}
    END
    [Return]    ${SDD_fee}



Check Items Equal Plus Qtys
    [Arguments]     ${items}    ${items_list}
    ${qtys_list}    Create List
    FOR   ${item}   IN    @{items_list}
        ${status}   Run Keyword And Return Status    Should Contain    ${item}    Qty:
        IF   "${status}" == "True"
            ${qty}   Evaluate    int(${item[4:]})
            Append To List     ${qtys_list}    ${qty}
        END
    END
    ${qtys}    Evaluate    sum(${qtys_list})
    IF   ${qtys} == 1
        Should Be Equal As Strings     ${items}    (${qtys} item)
    ELSE
        Should Be Equal As Strings     ${items}    (${qtys} items)
    END


Get items num
    [Arguments]    ${items_text}
    ${items}    Split Parameter    ${items_text}
    ${items}    Evaluate    int(${items[0][1:]})
    [Return]    ${items}

Get SDD Skus Info
    ${SDD_sku_dict}    Create Dictionary
    ${SDD_items}   Set Variable    0
    ${is_SDD}    Get Element Count    //h2[contains(text(),"Same Day Delivery")]
    IF   ${is_SDD} > 0
        ${SDD_sku}    Get Text    //h2[contains(text(),"Same Day Delivery")]/../../../..
        ${SDD_sku}    Split Parameter    ${SDD_sku}   \n
        Set To Dictionary    ${SDD_sku_dict}    SDD_sku=${SDD_sku}
        ${SDD_items_text}    Set Variable     ${SDD_sku[1]}
        Check Items Equal Plus Qtys     ${SDD_items_text}    ${SDD_sku}
        ${SDD_items}    Get Items Num    ${SDD_items_text}
    END
    [Return]     ${SDD_sku_dict}    ${SDD_items}

#Get STH Skus Info
#    ${STH_sku_dict}    Create Dictionary
#    ${STH_items}    Set Variable    0
#    ${is_STH}    Get Element Count    //h2[contains(text(),"Ship to Home")]
#    IF   ${is_STH} > 0
#        ${STH_sku}    Get Text    //h2[contains(text(),"Ship to Home")]/../../../..
#        ${STH_sku}    Split Parameter    ${STH_sku}   \n
#        Set To Dictionary    ${STH_sku_dict}    STH_sku=${STH_sku}
#        ${STH_items_text}    Set Variable     ${STH_sku[1]}
#        Check Items Equal Plus Qtys     ${STH_items_text}    ${STH_sku}
#        ${STH_items}    Get Items Num    ${STH_items_text}
#    END
#    [Return]    ${STH_sku_dict}    ${STH_items}


Get MIK STH Skus Info
    ${MIK_STH_sku_dict}    Create Dictionary
    ${MIK_STH_items}    Set Variable    0
#    ${is_MIK_STH}    Get Element Count    //h2[contains(text(),"Shipping from Michaels")]
    ${is_MIK_STH}    Get Element Count     //div[contains(@class,"sth-contain")]
    IF   ${is_MIK_STH} > 0
#        ${MIK_STH_sku}    Get Text    //h2[contains(text(),"Shipping from Michaels")]/../../../..
        ${MIK_STH_sku}    Get Text    //div[contains(@class,"sth-contain")]
        ${MIK_STH_sku}    Split Parameter    ${MIK_STH_sku}   \n
        Set To Dictionary    ${MIK_STH_sku_dict}    MIK_STH_sku=${MIK_STH_sku}
        ${MIK_STH_items_text}    Set Variable     ${MIK_STH_sku[1]}
        Check Items Equal Plus Qtys     ${MIK_STH_items_text}    ${MIK_STH_sku}
        ${MIK_STH_items}    Get Items Num    ${MIK_STH_items_text}
    END
    [Return]    ${MIK_STH_sku_dict}    ${MIK_STH_items}

Get PIS Skus Info
    ${PIS_sku_dict}    Create Dictionary
    ${PIS_items}    Set Variable    0
    ${is_PIS}     Get Element Count    //h2[contains(text(),"Pick Up")]
    IF   ${is_PIS} > 0
        ${PIS_sku}    Get Text    //h2[contains(text(),"Pick Up")]/../../../..
#        ${PIS_sku}    Get Text    //h2[contains(text(),"Pick Up")]
        ${PIS_sku}    Split Parameter    ${PIS_sku}   \n
        Set To Dictionary    ${PIS_sku_dict}   PIS_sku=${PIS_sku}
        ${PIS_items_text}    Set Variable     ${PIS_sku[1]}
        Check Items Equal Plus Qtys     ${PIS_items_text}    ${PIS_sku}
        ${PIS_items}    Get Items Num    ${PIS_items_text}
    END
    [Return]    ${PIS_sku_dict}    ${PIS_items}

Get Classes Skus Info
    ${class_sku_dict}    Create Dictionary
    ${class_items}    Set Variable    0
    ${is_calss}    Get Element Count    //h2[contains(text(),"Classes")]
    IF   ${is_calss} > 0
        ${class_eles}    Get Webelements    //h2[contains(text(),"Classes")]/../../../..
        @{class_sku_list}    Create List
        @{class_items_list}    Create List
        FOR    ${class_ele}    IN    @{class_eles}
            ${class_sku}    Get Text    ${class_ele}
            ${class_sku}    Split Parameter    ${class_sku}   \n
            ${class_items_text}    Set Variable     ${class_sku[1]}
            Check Items Equal Plus Qtys     ${class_items_text}    ${class_sku}
            ${class_items}    Get Items Num    ${class_items_text}
            Append To List    ${class_sku_list}    ${class_items}
            Append To List    ${class_items_list}    ${class_items}
        END
        ${class_items}    Evaluate     sum(${class_items_list})
        Set To Dictionary    ${class_sku_dict}    class_sku=${class_sku_list}
    END
    [Return]     ${class_sku_dict}    ${class_items}

Get MKR Skus Info
    ${MKR_sku_dict}    Create Dictionary
    ${MKR_items}    Set Variable    0
    ${is_MKR}    Get Element Count    //h2[contains(text(),"Shipped from")]
    IF   ${is_MKR} > 0
        ${MKR_eles}    Get Webelements    //h2[contains(text(),"Shipped from")]/../../../..
        @{MKR_sku_list}    Create List
        @{MKR_items_list}    Create List
        FOR    ${MKR_ele}    IN    @{MKR_eles}
            ${MKR_sku}    Get Text    ${MKR_ele}
            ${MKR_sku}    Split Parameter    ${MKR_sku}   \n
            ${MKR_items_text}    Set Variable     ${MKR_sku[1]}
            Check Items Equal Plus Qtys     ${MKR_items_text}    ${MKR_sku}
            ${MKR_items}    Get Items Num    ${MKR_items_text}
            Append To List    ${MKR_items_list}    ${MKR_items}
            Append To List    ${MKR_sku_list}    ${MKR_sku}
        END
        ${MKR_items}    Evaluate     sum(${MKR_items_list})
        Set To Dictionary    ${MKR_sku_dict}    MKR_sku=${MKR_sku_list}
    END
    [Return]    ${MKR_sku_dict}    ${MKR_items}

Get MKP Skus Info
    ${MKP_sku_dict}    Create Dictionary
    ${MKP_items}    Set Variable    0
#    ${is_MKR}    Get Element Count    //h2[contains(text(),"Shipped from")]
    ${is_MKP}    Get Element Count     //div[contains(@class,"ea-contain")]
    IF   ${is_MKP} > 0
#        ${MKP_eles}    Get Webelements    //h2[contains(text(),"Shipped from")]/../../../..
        ${MKP_eles}    Get Webelements     //div[contains(@class,"ea-contain")]
        @{MKP_sku_list}    Create List
        @{MKP_items_list}    Create List
        FOR    ${MKP_ele}    IN    @{MKP_eles}
            ${MKP_sku}    Get Text    ${MKP_ele}
            ${MKP_sku}    Split Parameter    ${MKP_sku}   \n
            ${MKP_items_text}    Set Variable     ${MKP_sku[1]}
            Check Items Equal Plus Qtys     ${MKP_items_text}    ${MKP_sku}
            ${MKP_items}    Get Items Num    ${MKP_items_text}
            Append To List    ${MKP_items_list}    ${MKP_items}
            Append To List    ${MKP_sku_list}    ${MKP_sku}
        END
        ${MKP_items}    Evaluate     sum(${MKP_items_list})
        Set To Dictionary    ${MKP_sku_dict}    MKP_sku=${MKP_sku_list}
    END
    [Return]    ${MKP_sku_dict}    ${MKP_items}


Get Skus Info From GYO or OR Page
    Sleep    3
    ${SDD_sku_dict}    ${SDD_items}    Get SDD Skus Info
    ${MIK_STH_sku_dict}    ${MIK_STH_items}    Get MIK STH Skus Info
    ${PIS_sku_dict}    ${PIS_items}    Get PIS Skus Info
    ${class_sku_dict}    ${class_items}    Get Classes Skus Info
    ${MKR_sku_dict}    ${MKR_items}     Get MKR Skus Info
    ${MKP_sku_dict}    ${MKP_items}     Get MKP Skus Info
    ${total_items}    Evaluate    ${SDD_items}+${MIK_STH_items}+${PIS_items}+${class_items}+${MKR_items}+${MKP_items}
    [Return]    ${SDD_sku_dict}   ${MIK_STH_sku_dict}   ${PIS_sku_dict}    ${class_sku_dict}    ${MKR_sku_dict}    ${MKP_sku_dict}    ${total_items}

Get product subtotal fee
    ${product_eles}    Set Variable     //img[contains(@alt,"thumbnail")]/../following-sibling::div
    ${count}    Get Element Count     ${product_eles}
    @{skus_amount}     Create List
    FOR   ${i}    IN RANGE    ${count}
        ${i}   Evaluate    ${i}+1
        ${product_ele}     Set Variable    ${product_eles}\[${i}\]
        ${product_text}    Get Text    ${product_ele}
        ${product_text}    Split Parameter    ${product_text}    \n
        ${A_price_text}    Set Variable    ${product_text[1]}
        IF   "Reg" in "${A_price_text}"
            ${A_price_text}   Split Parameter    ${A_price_text}
            ${A_price}    Set Variable    ${A_price_text[1][1:]}
        ELSE
            ${A_price}    Set Variable     ${A_price_text[1:]}
        END
        ${qty}    Set Variable    ${product_text[-1][4:]}
        ${sku_amount}    Evaluate     float(${A_price}) * int(${qty})
        Append To List    ${skus_amount}    ${sku_amount}
    END
    ${skus_subtotal}    Evaluate    sum(${skus_amount})
    ${skus_subtotal}   Evaluate    "{:.2f}".format(${skus_subtotal})
    [Return]      ${skus_subtotal}



Check Skus Info in GYO or OR Page
    [Arguments]    ${product_info}
    ${SDD_sku_dict}   ${MIK_STH_sku_dict}   ${PIS_sku_dict}    ${class_sku_dict}    ${MKR_sku_dict}    ${MKP_sku_dict}
    ...     ${total_items}    Get Skus Info From GYO or OR Page
    ${skus_subtotal}     Get product subtotal fee
    @{skus_qty}    Create List
    FOR   ${sku_info}   IN   @{product_info}
        @{sku_list}   Create List
        ${sku_name}   Set Variable    ${sku_info}[product_name]
        ${price}   Set Variable    ${sku_info}[price]
        ${qty}    Set Variable     Qty: ${sku_info}[qty]
        ${store_name}    Set Variable    ${sku_info}[store_name]
        ${store_name}    Capitalize Parameter    ${store_name}
        ${shipping_method}    Set Variable    ${sku_info}[shipping_method]
        ${channel}   Set Variable    ${sku_info}[channel]
        ${product_type}    Set Variable    ${sku_info}[product_type]
        ${pis_location}    Set Variable     ${sku_info}[pis_location]
        IF    "${pis_location}" != "${EMPTY}"
            ${store_address}   Set Variable     ${pis_location}[store_address]
            ${store_phone}    Set Variable     ${pis_location}[store_phone]
            ${pis_location}    Create List     ${store_address}    ${store_phone}
        END
        ${sku_qty}   Evaluate   int(${qty[4:]})
        Append To List    ${skus_qty}   ${sku_qty}
#        IF    "${shipping_method}" == "PIS"
#            Append To List     ${pis_sku_list}    ${sku_name}    ${price}    ${qty}
#        ELSE IF    "${shipping_method}" == "SDD"
#            Append To List     ${sdd_sku_list}    ${sku_name}    ${price}    ${qty}
#        ELSE
#            Append To List     ${sku_list}    ${sku_name}    ${price}    ${qty}    ${store_name}
#        END
        Append To List     ${sku_list}    ${sku_name}    ${price}    ${qty}
        log    ${sku_list}
        IF    "${shipping_method}" == "PIS"
            log    ${PIS_sku_dict}[PIS_sku]
            log    ${sku_list}
            log    ${pis_location}
            ${pis_location}    Set Variable     ${pis_location[0]}
#            ${address}    Split Parameter     ${pis_location}    ,
#            ${pis_location}    Catenate     ${address[0]},${address[1]},${address[2]},${address[4]},${address[3]}
#            ${pis_location}     Catenate     ${pis_location}
            Run Keyword And Warn On Failure    List Should Contain Sub List    ${PIS_sku_dict}[PIS_sku]    ${sku_list}
            Run Keyword And Warn On Failure    List Should Contain Value    ${PIS_sku_dict}[PIS_sku]    ${pis_location}
        ELSE IF    "${shipping_method}" == "STM"
            Run Keyword And Warn On Failure    List Should Contain Sub List    ${MIK_STH_sku_dict}[MIK_STH_sku]    ${sku_list}
        ELSE IF    "${shipping_method}" == "SDD"
            Run Keyword And Warn On Failure    List Should Contain Sub List    ${SDD_sku_dict}[SDD_sku]    ${sku_list}
        ELSE IF    "${channel}" == "MKR"
            ${MKRs}    Set Variable    ${MKR_sku_dict}[MKR_sku]
            FOR    ${one_MKR}   IN    @{MKRs}
                ${status}    Run Keyword And Return Status   List Should Contain Sub List    ${one_MKR}    ${sku_list}
                Exit For Loop If    "${status}" == "True"
            END
        ELSE IF    "${product_type}" == "class"
            ${classes}    Set Variable     ${class_sku_dict}[class_sku]
            FOR    ${one_class}   IN    @{classes}
                ${status}    Run Keyword And Return Status    List Should Contain Sub List    ${class_sku_dict}[class_sku]    ${sku_list}
                Exit For Loop If    "${status}" == "True"
            END
        ELSE IF    "${channel}" == "MKP"
            ${MKP}    Set Variable    ${MKP_sku_dict}[MKP_sku]
            FOR    ${one_MKP}   IN    @{MKP}
                ${status}    Run Keyword And Return Status   List Should Contain Sub List    ${one_MKP}    ${sku_list}
                Exit For Loop If    "${status}" == "True"
            END
        END
    END
#    ${skus_subtotal}    Evaluate    sum(${skus_amount})
#    ${skus_subtotal}   Evaluate    "{:.2f}".format(${skus_subtotal})
    ${skus_total_qty}   Evaluate    sum(${skus_qty})
    Run Keyword And Warn On Failure    Should Be Equal As Strings     ${total_items}    ${skus_total_qty}
    [Return]    ${skus_subtotal}    ${total_items}



Get Account Info
    ${first_name}    Set Variable    ${account_info}[first_name]
    ${last_name}     Set Variable    ${account_info}[last_name]
    ${consignee_information}    Set Variable     ${account_info}[address]
    ${phone}    Set Variable     ${account_info}[phone]
    ${email}    Set Variable     ${account_info}[email]
    ${user_information}    Create List    ${first_name}    ${last_name}    ${consignee_information}    ${phone}    ${email}
#    ${wallet_info}    Get Wallet Info
    [Return]    ${user_information}

Get Wallet Info
    Go To   ${Home URL}/buyertools/wallet
    Wait Until Element Is Visible    //h2[text()="Wallet"]
    Wait Until Element Is Visible    //h4[text()="Gift Cards"]
    Wait Until Element Is Visible    //p[contains(text(),"Visa")]
    ${credit_card}    Get Text    //p[contains(text(),"Visa")]
    ${credit_card_expiration}    Get Text    //p[contains(text(),"Expiration")]/..
    Wait Until Element Is Visible    //p[contains(text(),"Added on")]/..
    ${gift_cards}    Get Text    //p[contains(text(),"Added on")]/..
    ${gift_cards}    Split Parameter     ${gift_cards}    \n
    ${Balance}    Get Text    //p[contains(text(),"Balance")]/..
    ${wallet_info}    Create List    ${credit_card}    ${credit_card_expiration}   ${gift_cards}    ${Balance}
    [Return]    ${wallet_info}





