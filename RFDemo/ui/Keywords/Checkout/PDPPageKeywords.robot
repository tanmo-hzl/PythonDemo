*** Settings ***

Resource    ../../TestData/Checkout/config.robot
Resource    BuyerCheckKeywords.robot
Resource    OrderSummaryKeywords.robot

Library     ../../Libraries/Checkout/BuyerKeywords.py
#Library     ../../Libraries/CustomSeleniumKeywords.py       run_on_failure=Capture Screenshot and embed it into the report


*** Variables ***
#${add_to_cart_ele}    //*[text()="ADD TO CART"]/parent::button
${MKR_add_to_cart_ele}    //p[text()="ADD TO CART"]/../..
${add_to_cart_ele}    //div[text()="ADD TO CART"]/..
${items_added_to_cart_text}   //p[text()="Items added to cart!"]
${buy_now_ele}   //div[text()="BUY NOW"]/parent::button
${MKR_buy_now_ele}    //p[text()="BUY NOW"]/../parent::button
${add_class_to_cart_ele}    //p[text()="Add Class to Cart"]/../parent::button
${book_class_only_ele}    //p[text()="Book Class Only"]/../..
${product_description_text_ele}    //p[text()="Product Description"]

${listing_add_qty_ele}    //div[@role='button' and @aria-label='button to increment counter for number stepper']
${class_add_qty_ele}      //h3[text()="Class Description"]/../../div[2]//input[@type="text"]/following-sibling::div
${listing_qty_ele}    //input[contains(@class,"chakra-input")]
${class_description_ele}     //h3[text()="Class Description"]
${class_qty_ele}     //h3[text()="Class Description"]/../../div[2]//input[@type="text"]

${MKR_item_properties_select_ele}
${MKR_personalization_textfield_ele}    //textarea[@id="Personalization Textfield"]

${pick_up_icon_eles}    //p[contains(text(),"Pick-Up")]/parent::div//*[name()='svg']
${pick_up_ele}    //p[contains(text(),"Pick-Up")]
${ship_to_me_ele}    //*[contains(text(),"Ship to Me")]
${sdd_icon_class_ele}   (//p[contains(text(),"Ship to Me")])/../../following-sibling::div/div/*[name()='svg']
#${sdd_icon_class_ele}    (//p[contains(text(),"Ship to Me")])/../..//*[name()='svg']
${sdd_ele}    (//p[contains(text(),"Ship to Me")])/../../following-sibling::div/div//p

${search_ele}    //input[contains(@placeholder,"Enter city")]
${search_icon_ele}    //input[contains(@placeholder,"Enter city")]/../div//*[name()='svg']
#${first_plus_ele}    (//div[@aria-label="button to increment counter for number stepper"])[2]
${sort_by_text_ele}    //p[text()="Sort By"]
${meter_select_ele}    (//select)[1]
${stores_in_your_range_text_ele}    //p[text()="Stores in your Range"]
${sort_by_select_ele}    //p[text()="Sort By"]/../following-sibling::select
#${check_other_stores_ele}    //span[text()="Check Other Stores"]
#${check_other_stores_ele}    //span[contains(text(),"Also ")]
${check_other_stores_ele}    //p[contains(text(),"Pick-Up")]/../../following-sibling::div/div/span[2]

*** Keywords ***

Change Store From Home Page
    [Arguments]    ${store_name}
    sleep    2
    Wait Until Page Contains Element     (//p[text()="My Store:"])[1]
    Wait Until Element Is Enabled       (//p[text()="My Store:"])[1]
#    Wait Until Element Is Visible        (//p[text()="My Store:"])[1]
    ${is_store_name}     Get Element Count     (//p[text()="${store_name}"])[1]
    IF   ${is_store_name} == 0
        Mouse Over                           (//p[text()="My Store:"])[1]
        Wait Until Page Contains Element     //p[text()="FIND OTHER STORES"]/..
#        Wait Until Element Is Visible        //p[text()="FIND OTHER STORES"]/..
        Click Element                        //p[text()="FIND OTHER STORES"]/..
        Wait Until Page Contains Element     //p[text()='SELECT OTHER STORE']
#        Wait Until Element Is Visible        //p[text()='SELECT OTHER STORE']
        Input Text       //input[contains(@class,"chakra-input")]     ${store_name}
        Wait Until Page Contains Element     //select
#        Wait Until Element Is Visible    //select
        Select From List By Value     //select    200
        Wait Until Page Contains Element     //p[text()="${store_name}"]
#        Wait Until Element Is Visible    //p[text()="${store_name}"]
        Click Element    //span[contains(@class,"chakra-radio__control")]
        Click Element    //div[contains(text(),"CHANGE MY STORE")]/..
        Wait Until Page Contains Element     //p[text()="${store_name}"]
#        Wait Until Element Is Visible    //p[text()="${store_name}"]
        sleep   1
    END


If signin in PDP
    [Arguments]    ${product_type}    ${shipping_method}    ${product_info}    ${is_signin}
    IF   "${is_signin}" == "${True}"
        Run Keyword And Warn On Failure    Check Buy Now Slide Page     ${product_type}    ${shipping_method}    ${product_info}
    ELSE
        login in slide page
        Run Keyword And Warn On Failure    Check Buy Now Slide Page     ${product_type}    ${shipping_method}    ${product_info}
    END


select purchase type if sign in
    [Arguments]    ${product_type}   ${purchase_type}   ${channel}    ${shipping_method}    ${product_info}    ${is_signin}=${True}
    IF  "${product_type}" == "listing"
        IF  "${purchase_type}" == "ATC"
            Click Add to Cart Button     ${channel}
            Run Keyword And Warn On Failure    check view my cart popup     ${purchase_type}   ${product_info}
        ELSE
            Click Buy Now Button     ${channel}
            If signin in PDP    ${product_type}    ${shipping_method}    ${product_info}    ${is_signin}
        END
    ELSE IF   "${product_type}" == "class"
        IF  "${purchase_type}" == "ACTC"
            Click Add Class to Cart Button
            Run Keyword And Warn On Failure    check view my cart popup    ${purchase_type}   ${product_info}
        ELSE
            Click Book Class Only Button
            Buy Now Class - Input All Guest Info    ${product_type}
#            If signin in PDP    ${product_type}    ${shipping_method}    ${product_info}    ${is_signin}
        END
    END


Click Add to Cart Button
    [Arguments]    ${channel}
    IF   "${channel}" == "MKR"
        Wait Until Page Contains Element     ${MKR_add_to_cart_ele}
#        Wait Until Element Is Visible    ${MKR_add_to_cart_ele}
        Wait Until Element Is Enabled    ${MKR_add_to_cart_ele}
        Click Element    ${MKR_add_to_cart_ele}
    ELSE
        Wait Until Page Contains Element     ${add_to_cart_ele}
#        Wait Until Element Is Visible    ${add_to_cart_ele}
        Wait Until Element Is Enabled    ${add_to_cart_ele}
        Click Element    ${add_to_cart_ele}
    END
    sleep   2
    Wait Until Page Contains Element     ${items_added_to_cart_text}    ${Long Waiting Time}
#    Wait Until Element Is Visible    ${items_added_to_cart_text}    ${Long Waiting Time}


Click Buy Now Button
    [Arguments]    ${channel}
    IF   "${channel}" == "MKR"
        Wait Until Page Contains Element     ${MKR_buy_now_ele}
        Wait Until Element Is Enabled    ${MKR_buy_now_ele}
        Click Element    ${MKR_buy_now_ele}
    ELSE
        Wait Until Page Contains Element     ${buy_now_ele}
        Wait Until Element Is Enabled    ${buy_now_ele}
        Click Element    ${buy_now_ele}
    END

Click Add Class to Cart Button
    Wait Until Page Contains Element     ${class_description_ele}
#    Wait Until Element Is Visible    ${class_description_ele}
    ${eles}   Get Webelements    ${add_class_to_cart_ele}
    Click Element    ${eles[1]}
#    Wait Until Element Is Visible     ${items_added_to_cart_text}

Click Book Class Only Button
    Wait Until Page Contains Element     ${class_description_ele}
#    Wait Until Element Is Visible    ${class_description_ele}
    ${eles}   Get Webelements   ${book_class_only_ele}
    Click Element    ${eles[1]}


Add Product Quantity From PDP
    [Arguments]    ${product_type}   ${num}
    ${A_num}   Evaluate    ${num}-1
    IF   "${product_type}" == "listing"
        FOR   ${i}  IN RANGE   ${A_num}
            Wait Until Page Contains Element     ${ship_to_me_ele}
#            Wait Until Element Is Visible     ${ship_to_me_ele}
            Wait Until Element Is Enabled    ${listing_add_qty_ele}
            Click Element    ${listing_add_qty_ele}
            Sleep    1
        END
        ${qty}    Get Element Attribute    ${listing_qty_ele}    value
        Should Be Equal As Strings    ${qty}    ${num}
    ELSE
        FOR   ${i}  IN RANGE   ${A_num}
            Wait Until Page Contains Element     ${class_description_ele}
#            Wait Until Element Is Visible    ${class_description_ele}
#            ${plus_eles}   Get Webelements     ${class_add_qty_ele}
#            Click Element    ${plus_eles[-1]}
            Click Element      ${class_add_qty_ele}
            Sleep    1
        END
        ${qty}    Get Element Attribute    ${class_qty_ele}   value
        Should Be Equal As Strings    ${qty}    ${num}
    END


Select Item Properties In PDP
    #to do
    [Arguments]    ${channel}
    IF   "${channel}" == "MKR"
        MKR Select Variant In PDP
        MKR input personalization in PDP     test
    END

MKR Select Variant In PDP
    #to do
    Wait Until Page Contains Element    ${product_description_text_ele}
    ${is_properties}   Get Element Count   //select
    IF   ${is_properties} > 0
        ${properties_eles}    Get Webelements    //select
        FOR   ${item}   IN    @{properties_eles}
            Select From List By Index    ${item}   1
        END
    END

MKR input personalization in PDP
    #to do
    [Arguments]    ${input}
    ${is_personalization}   Get Element Count   ${MKR_personalization_textfield_ele}
    IF   ${is_personalization} > 0
        Input Text   ${MKR_personalization_textfield_ele}     ${input}
        sleep    1
        ${output}   Get Text    ${MKR_personalization_textfield_ele}
        Run Keyword And Warn On Failure     Should Be Equal As Strings     ${output}    ${input}
    END


Select Shipping Method
    [Documentation]    shipping_method, 1:Pick-Up   2:Ship to Me  2.Same Day Delivery
    [Arguments]     ${shipping_method}
    Wait Until Page Contains Element     //button[text()="DESCRIPTION"]    ${Long Waiting Time}
#    Wait Until Element Is Visible    //button[text()="DESCRIPTION"]     ${Long Waiting Time}
    IF    '${shipping_method}'=='PIS'
        Select Pick Up Shipping Method
    ELSE IF    '${shipping_method}'=='STM'
        Select Ship to Me Shipping Method
    ELSE IF    '${shipping_method}'=='SDD'
        Select Same Day Delivery Shipping Method
    ELSE IF    '${shipping_method}'=='SDDH'
        Select Same Day Delivery Shipping Method
    END

Select Pick Up Shipping Method
    ${pis_icon_eles}   Get Webelements    ${pick_up_icon_eles}
    ${pis_icon_class}    Get Element Attribute    ${pis_icon_eles[0]}   class
    IF   "${pis_icon_class}" == "icon icon-tabler icon-tabler-circle"
         Wait Until Page Contains Element     ${pick_up_ele}
#         wait until element is visible    ${pick_up_ele}
         click element    ${pick_up_ele}
         select pis store     MacArthur Park
    ELSE IF   "${pis_icon_class}" == "icon icon-tabler icon-tabler-ban"
         Should Be Equal As Strings    ${pis_icon_class}   icon icon-tabler icon-tabler-circle     out of stock
    END

Select Ship to Me Shipping Method
    Wait Until Page Contains Element     ${ship_to_me_ele}
#    wait until element is visible    ${ship_to_me_ele}
    click element    ${ship_to_me_ele}

Select Same Day Delivery Shipping Method
    Page Should Contain Element     ${ship_to_me_ele}
#    Wait Until Element Is visible    ${ship_to_me_ele}
    ${sdd_icon_class}    Get Element Attribute    ${sdd_icon_class_ele}   class
    IF   "${sdd_icon_class}" == "icon icon-tabler icon-tabler-circle"
        Wait Until Page Contains Element     ${sdd_ele}
        Wait Until Element Is Enabled     ${sdd_ele}
        Click Element     ${sdd_ele}
    ELSE
        Should Be Equal As Strings    ${sdd_icon_class}    icon icon-tabler icon-tabler-circle    out of stock
    END


Select Other Store From PDP
    [Arguments]    ${store_num}
    IF   ${store_num} > 0
        Click Check Other Stores Element
#        ${pis_store_info_list}    Item Pickup In Other Store    ${store_num}    200    Number In Stock
        Search and Pickup In Other Store    ${store2_info["store_name"]}
    END
#    [Return]    ${pis_store_info_list}

Click Check Other Stores Element
    sleep    3
    Wait Until Page Contains Element     ${check_other_stores_ele}
#    Wait Until Element Is Visible    ${check_other_stores_ele}
    Click Element   ${check_other_stores_ele}

Item Pickup In Other Store
    [Arguments]    ${store_num}    ${meter}    ${sort_by}
    Wait Until Page Contains Element     ${sort_by_text_ele}
#    Wait Until Element Is Visible     ${sort_by_text_ele}
    Select From List By Label     ${sort_by_select_ele}    ${sort_by}
    Select From List By Value    ${meter_select_ele}   ${meter}
    Wait Until Page Contains Element     ${stores_in_your_range_text_ele}
#    Wait Until Element Is Visible     ${stores_in_your_range_text_ele}
    sleep    3
    ${pis_store_info_list}   Create List
    FOR   ${i}   IN RANGE   ${store_num}
        ${i}   Evaluate   ${i}+2
        Wait Until Page Contains Element     //table/tr[${i}]/td[1]//div[@aria-label="button to increment counter for number stepper"]
#        Wait Until Element Is Visible    //table/tr[${i}]/td[1]//div[@aria-label="button to increment counter for number stepper"]
        Wait Until Element Is Enabled     //table/tr[${i}]/td[1]//div[@aria-label="button to increment counter for number stepper"]
        Mouse Over    //table/tr[${i}]/td[1]//div[@aria-label="button to increment counter for number stepper"]
        Click Element    //table/tr[${i}]/td[1]//div[@aria-label="button to increment counter for number stepper"]
        ${pis_store_info}   get Pickup store info from Pickup in store popup    ${i}
        Append To List    ${pis_store_info_list}     ${pis_store_info}
    END
    Click Add to Cart In Pickup Store Popup
    [Return]    ${pis_store_info_list}

Search and Pickup In Other Store
    [Arguments]    @{store_names}
    FOR   ${store_name}   IN    @{store_names}
        Wait Until Page Contains Element     ${search_ele}
#        Wait Until Element Is Visible     ${search_ele}
        Click Element    ${search_ele}
        Input Text    ${search_ele}     ${store_name}
#        Wait Until Element Is Visible     ${search_icon_ele}
        Press Keys     ${search_ele}    \ue007
        ${search_store_ele}    Set Variable     //p[contains(text(),"${store_name}")]
        Wait Until Page Contains Element     ${search_store_ele}
        Sleep    3
        ${search_store_plus_ele}    Set Variable     ${search_store_ele}/../../../preceding-sibling::div[4]//input/following-sibling::div
        Wait Until Page Contains Element     ${search_store_plus_ele}
#        Wait Until Element Is Visible     ${first_plus_ele}
        Click Element    ${search_store_plus_ele}
    END
    Click Add to Cart In Pickup Store Popup




Click Add to Cart In Pickup Store Popup
    sleep     2
#    Wait Until Page Contains Element      (//div[text()="ADD TO CART"])[8]/..
#    Wait Until Element Is Enabled     (//div[text()="ADD TO CART"])[8]/..
    ${eles}   Get Webelements    //div[text()="ADD TO CART"]
    Click Element    ${eles[-1]}

Get MIK or MKP Item Properties
    ${size}    Set Variable    ${EMPTY}
    ${color}   Set Variable    ${EMPTY}
    ${count}   Set Variable    ${EMPTY}
    ${item_properties_ele}   Set Variable   //*[contains(text(),"Ship to Me")]/ancestor::div[6]//h1/../../div[3]
    ${isSize}   Get Element Count    ${item_properties_ele}//b[contains(text(),"SIZE")]
    IF   ${isSize} > 0
        ${size_data}   Get Text   ${item_properties_ele}//b[contains(text(),"SIZE")]/..
        ${size}   Split Parameter   ${size_data}   :
        ${size}   strip_parameter    ${size[1].strip()}
    END
    ${isColor}   Get Element Count    ${item_properties_ele}//b[contains(text(),"COLORS")]
    IF   ${isColor} > 0
        ${color_data}   Get Text   ${item_properties_ele}//b[contains(text(),"COLORS")]/..
        ${color}   Split Parameter   ${color_data}   :
        ${color}   strip_parameter    ${color[1]}
    END
    ${isCount}   Get Element Count    ${item_properties_ele}//b[contains(text(),"COUNT")]
    IF   ${isCount} > 0
        ${count_data}   Get Text   ${item_properties_ele}//b[contains(text(),"COUNT")]/..
        ${count}   Split Parameter   ${count_data}   :
        ${count}   strip_parameter    ${count[1].strip()}
    END
    [Return]    ${size}   ${color}   ${count}

Get MKR Item Properties
    ${size}    Set Variable    ${EMPTY}
    ${color}   Set Variable    ${EMPTY}
    ${isSize}   Get Element Count    //select/option[contains(text(),"Choose Size")]
    IF   ${isSize} > 0
        ${size}   Get Text   //select/option[contains(text(),"Choose Size")]/following-sibling::option
    END
    ${isColor}   Get Element Count    //select/option[contains(text(),"Choose Color")]
    IF   ${isColor} > 0
        ${color}   Get Text   //select/option[contains(text(),"Choose Color")]/following-sibling::option
    END
    [Return]    ${size}   ${color}


Get product name and price for qa
    ${product_name}   Set Variable    ${EMPTY}
    ${price}    Set Variable     ${EMPTY}
    ${reg_price}   Set Variable    ${EMPTY}
    ${product_name}  Get Text   (//*[contains(text(),"Ship to Me")]/ancestor::div[6]//p)[1]
    ${price_list}   Get Text    (//*[contains(text(),"Ship to Me")]/ancestor::div[6]//p)[1]/../../div[2]
    ${price_list}   Split Parameter    ${price_list}   \n
    ${price_len}    Get Length    ${price_list}
    ${price}   Set Variable    ${price_list[0]}
    IF   ${price_len} > 1
        IF   "Reg" in "${price_list[1]}"
            ${reg_price}    Set Variable    ${price_list[1][4:]}
        END
    END
    [Return]    ${product_name}    ${price}    ${reg_price}

Get product name and price for stg or tst or MKR
    ${product_name}   Set Variable    ${EMPTY}
    ${price}    Set Variable     ${EMPTY}
    ${reg_price}   Set Variable    ${EMPTY}
    ${product_name}  Get Text   //*[contains(text(),"Ship to Me")]/ancestor::div[6]//h1
    ${price_list}   Get Text    //*[contains(text(),"Ship to Me")]/ancestor::div[6]//h1/../../div[2]
    ${price_list}   Split Parameter    ${price_list}   \n
    ${price_len}    Get Length    ${price_list}
    ${price}   Set Variable    ${price_list[0]}
    IF   ${price_len} > 1
        IF   "Reg" in "${price_list[1]}"
            ${reg_price}    Set Variable    ${price_list[1][4:]}
        END
    END
    [Return]    ${product_name}    ${price}    ${reg_price}


Get Skus Info From PDP
    #to do
    [Arguments]   ${channel}   ${product_type}   ${sku_url}=${EMPTY}   ${shipping_method}=${EMPTY}   ${pis_store_num}=${EMPTY}
    ${size}    Set Variable    ${EMPTY}
    ${color}   Set Variable    ${EMPTY}
    ${count}   Set Variable    ${EMPTY}
    ${reg_price}   Set Variable    ${EMPTY}
    ${pis_location}   Set Variable   ${EMPTY}
    ${store_name}    Set Variable     ${EMPTY}
    ${sku}   Split Parameter    ${sku_url}   /
    IF   "-" in "${sku[-1]}"
        ${sku}   Split Parameter    ${sku_url}   -
        ${sku}   Set Variable    ${sku[-1]}
    ELSE
        ${sku}   Set Variable    ${sku[-1]}
    END
    IF   "${product_type}" == "listing"
        Wait Until Page Contains Element     //*[contains(text(),"Ship to Me")]    ${Long Waiting Time}
#        Wait Until Element Is Visible    //*[contains(text(),"Ship to Me")]    ${Long Waiting Time}
#        Wait Until Element Is Visible    //*[contains(text(),"Ship to Me")]/ancestor::div[5]//input[@aria-label="Number Stepper"]
        ${ENV}    Lower Parameter    ${ENV}
        IF   "${ENV}" == "qa"
            IF   "${channel}"=="MKR"
                ${product_name}    ${price}    ${reg_price}    Get product name and price for stg or tst or MKR
            ELSE
                ${product_name}    ${price}    ${reg_price}    Get product name and price for qa
            END
        ELSE
            ${product_name}    ${price}    ${reg_price}    Get product name and price for stg or tst or MKR
        END
        ${qty}   Get Element Attribute    //*[contains(text(),"Ship to Me")]/ancestor::div[5]//input[@aria-label="Number Stepper"]   value
        ${subtotal}   Evaluate    format(${price[1:]}*${qty},".2f")
        ${subtotal}   Catenate    $${subtotal}
        IF   "${channel}"=="MIK"
            ${store_name}   Set Variable    MICHAELS
            ${size}   ${color}   ${count}     Get MIK or MKP Item Properties
            IF   "${shipping_method}" == "PIS"
                IF    "${pis_store_num}" == "0"
#                    ${pis_location}    get Pickup store info from PDP
                    ${pis_location}    Set Variable     ${store1_info}
                ELSE IF    "${pis_store_num}" == "1"
                    ${pis_location}    Set Variable     ${store2_info}
                END
            END
        ELSE IF   "${channel}"=="MKP"
            ${size}   ${color}   ${count}     Get MIK or MKP Item Properties
            Wait Until Page Contains Element   //p[text()="Sold and shipped by"]/following-sibling::p    ${Long Waiting Time}
            Wait Until Page Contains Element    //p[text()="Sold and shipped by"]/following-sibling::p    ${Long Waiting Time}
            ${store_name}   Get Text   //p[text()="Sold and shipped by"]/following-sibling::p
            ${store_name}   upper_parameter    ${store_name}
        ELSE IF   "${channel}"=="MKR"
            ${size}   ${color}    Get MKR Item Properties
            ${store_name}   Get Text    //*[contains(text(),"Ship to Me")]/ancestor::div[6]//a
            ${store_name}   upper_parameter    ${store_name}
        END
    ELSE IF   "${product_type}" == "class"
        Wait Until Page Contains Element     //h3[text()="Class Description"]
#        Wait Until Element Is Visible    //h3[text()="Class Description"]
        ${product_name}   Get Text    //h3[text()="Class Description"]/preceding-sibling::div/div[2]//h2
        ${price}   Get Text   //h3[text()="Class Description"]/preceding-sibling::div//hr[1]/preceding-sibling::div[1]
        ${qty}   Get Element Attribute    //h3[text()="Class Description"]/../../div[2]//input[@type="text"]   value
        ${subtotal}    Get Text   //h3[text()="Class Description"]/../../div[2]//p[contains(@class,"subtotal")]
        ${subtotal}    Split Parameter    ${subtotal}
        ${subtotal}    Set Variable     ${subtotal[-1]}
#        ${date_eles}   Get Webelements    //h3[text()="Book Class"]/..//span[@data-checked]/div/div/p
#        ${date}    Get Text    ${date_eles[-1]}
#        ${time}    Get Text    ${date_eles[-2]}
        IF   "${channel}"=="MIK"
            ${store_name}   Set Variable    MICHAELS
#        ELSE IF    "${channel}"=="MKR"
#            ${store_name}    Get store name for MKR calss
        END
    END
    ${product_info}   Create Dictionary    channel=${channel}    product_type=${product_type}    sku=${sku}    product_name=${product_name}   price=${price}   reg_price=${reg_price}    qty=${qty}
    ...    subtotal=${subtotal}    store_name=${store_name}   size=${size}   color=${color}   count=${count}    pis_location=${pis_location}
    ...    sku_url=${sku_url}   shipping_method=${shipping_method}
    Set Suite Variable     ${ONE_PRODUCT_INFO}     ${product_info}
#    [Return]    ${product_info}


Get store name for MKR calss
    Wait Until Page Contains Element     //p[text()="View Storefront"]
#    Wait Until Element Is Visible    //p[text()="View Storefront"]
    Click Element    //p[text()="View Storefront"]
#            Wait Until Page Contains Element     //h2[text()="All Products"]
#            Wait Until Element Is Visible    //h2[text()="All Products"]
    Wait Until Page Contains Element     //div[text()="SHOP OWNER"]
#    Wait Until Element Is Visible    //div[text()="SHOP OWNER"]
    ${store_name}   Get Text    //h1
    ${store_name}   upper_parameter    ${store_name}
    Go Back
#    Wait Until Element Is Visible    //h3[text()="Class Description"]
    [Return]     ${store_name}


get Pickup store info from PDP
    Mouse Over    (//p[contains(text(),"My Store:")])[1]
    ${store_phone}    Get Text    //p[contains(text(),"My Store:")]/../div/div/div/p[3]
    ${store_name}    Get Text    (//p[contains(text(),"My Store:")])[1]/following-sibling::p
    Wait Until Element Is Enabled     //p[text()="FIND OTHER STORES"]/..
    Click Element    //p[text()="FIND OTHER STORES"]/..
    ${store_address}    Get Text    //p[text()="MY STORE"]/../div/div[2]
    ${store_address}    Split Parameter     ${store_address}    \n
    ${city_zipcode}     Split Parameter     ${store_address[1]}    ,
    ${zipcode}    Set Variable    ${city_zipcode[2][1:]}
    ${store_address}    Set Variable     ${store_address[0]} ${city_zipcode[0]},${zipcode},${city_zipcode[1]}
    Wait Until Element Is Enabled    (//p[text()="Details"])[1]
    Click Element    (//p[text()="Details"])[1]/..
    ${store_hours}   Get Text    (//p[text()="Store Hours"]/..)[1]
    ${store_hours}   Split Parameter   ${store_hours}   \n
    ${pis_store_info}    Create Dictionary    store_name=${store_name}    store_address=${store_address}    store_phone=${store_phone}    store_hours=${store_hours}
    Click Element    //div[text()="CHANGE MY STORE"]/..
    [Return]   ${pis_store_info}


get Pickup store info from Pickup in store popup
    [Arguments]    ${i}
    ${store_text}    Get Text    //table/tr[${i}]/td[5]
    ${store_text}    Split Parameter    ${store_text}   \n
    ${store_name_text}    Set Variable    ${store_text[0]}
    ${store_name_text}    Split Parameter    ${store_name_text}    —
    ${store_name}    Set Variable     ${store_name_text[0][:-1]}
    ${store_address_text}    Set Variable     ${store_text[3]}
    ${address}    Split Parameter     ${store_address_text}    ,
    ${zipcode}    Split Parameter     ${address[-1]}
    ${store_address}    Catenate     ${address[0]},${address[1]}, ${zipcode[2]}, ${zipcode[1]}
    ${store_phone}    Set Variable     ${store_text[1]}
    Click Element    //table/tr[2]/td[5]//span[text()="Store Hours"]
    ${store_hours}    Get Text    //table/tr[2]/td[5]//span[text()="Store Hours"]/../div/div/div
    ${pis_store_info}    Create Dictionary    store_name=${store_name}     store_address=${store_address}    store_phone=${store_phone}    store_hours=${store_hours}
    [Return]   ${pis_store_info}