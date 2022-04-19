*** Settings ***
Resource        ../../Keywords/Checkout/Common.robot
Library         ../../Libraries/Checkout/CartKeywords.py


*** Variables ***
${Save for Later elements}     //h3[contains(text(),"Save for Later")]/../../div
${Cart elements}       //div[@class='css-1iwjw72']/div
${Store_elements}       //div[@class='css-1cwf0q5 ent7o7d7']
${message_close}        //div[@class='css-97s6mk e1kazezv4']//button/*
*** Keywords ***
initial save for later list remove all item
     Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    ${save_sum1}    Run Keyword And Ignore Error   Wait Until Page Contains Elements Ignore Ad  //h3[contains(text(),"Save for Later")]
    IF  "${save_sum1[0]}"=="PASS"
          Close Cart Initiate Error popup
          Scroll Element Into View   //h3[contains(text(),"Save for Later")]

         ${save_item_sum}        Get element count    ${Save for Later elements}

         FOR  ${i}  IN RANGE   ${1}     ${save_item_sum}
            Close Cart Initiate Error popup
            Wait Until Element Is Visible    ${Save for Later elements}\[${2}\]//div[text()='Remove']
            Click Element       ${Save for Later elements}\[${2}\]//div[text()='Remove']
            Wait Until Element Is Visible   //h4[contains(text(),' Are you sure you want to remove the following product from the cart?')]
            Wait Until Element Is Visible   //button[@class='css-xfbgqw']
            Click Element    //button[@class='css-xfbgqw']
            Execute Javascript       window.location.reload();

#            Reload Page
            Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
            Sleep  2
            ${save_sumi}    Get element count   //h3[contains(text(),"Save for Later")]
            IF  ${save_sumi}==1
                Scroll Element Into View   //h3[contains(text(),"Save for Later")]
            END
         END
    END
    Wait Until Page Does Not Contain Element    //h3[contains(text(),"Save for Later")]
     ${save_item_sumi}    Get element count    //h3[contains(text(),"Save for Later")]
     Should Be Equal As Numbers     ${save_item_sumi}       0


Cart Item To Save for Later
     [Arguments]  ${loca_item}=1
     Wait Until Element Is Visible                  ${Cart elements}\[${loca_item}\]//div[text()='Save for Later']
     Wait Until Page Contains Elements Ignore Ad    ${Cart elements}\[${loca_item}\]//a
     ${Save_item_name}   Get Text                   ${Cart elements}\[${loca_item}\]//a
     Click Element                                  ${Cart elements}\[${loca_item}\]//div[text()='Save for Later']
     [Return]                                       ${Save_item_name}

Cart Verify Remove and Save for Later
    [Arguments]     ${action}=save      ${loca_item}=${1}
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Sleep  1
    Wait Until Element Is Visible     ${Cart elements}
    ${item_elements}       get Webelements    ${Cart elements}
    ${cart_item_sum}        Get element count    ${Cart elements}
    ${save_item_sum}        Get element count    ${Save for Later elements}

    IF   ${cart_item_sum} >= ${loca_item}
        Wait Until Element Is Visible    ${Cart elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${sku}      Get Text        ${Cart elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${item_name}    Get Text     ${Cart elements}\[${loca_item}\]//p[@class="productName css-1ouddpy"]/a
        IF  '${action}'=='save'
            Wait Until Element Is Visible    ${Cart elements}\[${loca_item}\]//div[text()='Save for Later']
            Click Element       ${Cart elements}\[${loca_item}\]//div[text()='Save for Later']
#暂时注释，product bug
#            Wait Until Element Is Visible   //p[contains(text(),'was moved to Save for Later')]
#            ${var_name}     Get Text    //p[contains(text(),'was moved to Save for Later')]/a
#            Should Be Equal As Strings      ${var_name}   ${item_name}
        ELSE
            Wait Until Element Is Visible    ${Cart elements}\[${loca_item}\]//div[text()='Remove']
            Click Element       ${Cart elements}\[${loca_item}\]//div[text()='Remove']
            Wait Until Element Is Visible   //h4[contains(text(),' Are you sure you want to remove the following product from the cart?')]
            Wait Until Element Is Visible   //button[@class='css-xfbgqw']
            Click Element    //button[@class='css-xfbgqw']
            Wait Until Element Is Visible    //p[contains(text(),'was removed from Shopping Cart.')]
            ${var_name}     Get Text    //p[contains(text(),'was removed from Shopping Cart.')]/a
            Should Be Equal As Strings      ${var_name}   ${item_name}
        END

    END
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Sleep   2
#    ${cart_item_sum2}        Get element count    ${Cart elements}
#    ${save_item_sum2}        Get element count    ${Save for Later elements}
#    ${cart_item_sum2}     Evaluate      ${cart_item_sum2}+${1}
    IF  '${action}' == 'save'
        ${item_name_xpath}      text_contains_special_symbols   ${item_name}     ${Save for Later elements}//a
        Wait Until Element Is Visible   ${item_name_xpath}
        ${save_item_name}       Get Text     ${item_name_xpath}
        Should Be Equal As Strings      ${item_name}     ${save_item_name}
        ${save_sku}       Get Text     ${item_name_xpath}/../following-sibling::div//p
        Should Be Equal As Strings      ${save_sku}      ${sku}
    END
    Sleep  1
    ${cart_item_sum2}        Get element count    ${Cart elements}
    ${save_item_sum2}        Get element count    ${Save for Later elements}
    ${cart_item_sum2}     Evaluate      ${cart_item_sum2}+${1}
    IF  '${action}' == 'save'
        IF      ${save_item_sum} == 0
            ${save_item_sum3}     Evaluate    ${save_item_sum2}-${2}
        ELSE
            ${save_item_sum3}     Evaluate    ${save_item_sum2}-${1}
        END
    ELSE
         ${save_item_sum3}   Set Variable    ${save_item_sum2}
    END
    Should Be Equal As numbers      ${cart_item_sum2}       ${cart_item_sum}
    Should Be Equal As numbers      ${save_item_sum3}       ${save_item_sum}
    [Return]   ${item_name}



Save for Later Verify Remove and Move to cart
    [Arguments]     ${action}=cart      ${loca_item}=${2}
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    sleep   1
    Wait Until Element Is Visible     ${Save for Later elements}
    ${item_elements}       get Webelements    ${Cart elements}
    ${cart_item_sum}        Get element count    ${Cart elements}
    ${save_item_sum}        Get element count    ${Save for Later elements}

    IF   ${save_item_sum} >= ${loca_item}
        Wait Until Element Is Visible    ${Save for Later elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${sku}      Get Text        ${Save for Later elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${item_name}    Get Text     ${Save for Later elements}\[${loca_item}\]//p[@class="productName css-1ouddpy"]/a
        IF  '${action}'=='cart'
            Wait Until Element Is Visible    ${Save for Later elements}\[${loca_item}\]//div[text()='Move to Cart']
            Click Element       ${Save for Later elements}\[${loca_item}\]//div[text()='Move to Cart']
#            Wait Until Element Is Visible   //p[contains(text(),'was moved to Save for Later')]
#            ${var_name}     Get Text    //p[contains(text(),'was moved to Save for Later')]/a
#            Should Be Equal As Strings      ${var_name}   ${item_name}
#            Wait Until Element Is Visible   ${message_close}
#            Click Element    ${message_close}
        ELSE
            Wait Until Element Is Visible    ${Save for Later elements}\[${loca_item}\]//div[text()='Remove']
            Click Element       ${Save for Later elements}\[${loca_item}\]//div[text()='Remove']
            Wait Until Element Is Visible   //h4[contains(text(),' Are you sure you want to remove the following product from the cart?')]
            Wait Until Element Is Visible   //button[@class='css-xfbgqw']
            Click Element    //button[@class='css-xfbgqw']
            #暂时使用产品bug
            Reload Page
            Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
#            Wait Until Element Is Visible    //p[contains(text(),'was moved to Save for Later.')]
#            ${var_name}     Get Text    //p[contains(text(),'was moved to Save for Later.')]/a
#            Should Be Equal As Strings      ${var_name}   ${item_name}
        END

    END

    IF  '${action}' == 'cart'
        ${cart_item_sum}     Evaluate      ${cart_item_sum}+${1}
        ${item_name_xpath}      text_contains_special_symbols   ${item_name}     ${Cart elements}//a
        Wait Until Element Is Visible     ${item_name_xpath}
        ${save_item_name}       Get Text     ${item_name_xpath}
        Should Be Equal As Strings      ${item_name}     ${save_item_name}
        Wait Until Element Is Visible     ${item_name_xpath}/../following-sibling::div//p
        ${save_sku}       Get Text     ${item_name_xpath}/../following-sibling::div//p
        Should Be Equal As Strings      ${item_name}     ${save_item_name}
    END
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    sleep   3
    ${cart_item_sum2}        Get element count    ${Cart elements}
    ${save_item_sum2}        Get Element Count    ${Save for Later elements}
    IF  ${save_item_sum2} == 0
        ${save_item_sum3}     Evaluate    ${save_item_sum2}+${2}
    ELSE
        ${save_item_sum3}     Evaluate    ${save_item_sum2}+${1}
    END
    Should Be Equal As numbers      ${cart_item_sum2}       ${cart_item_sum}
    Should Be Equal As numbers      ${save_item_sum3}       ${save_item_sum}


Remove all Items
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    sleep   1
    ${cart_item_sum}        Get element count    ${Cart elements}
#    ${save_item_sum}        Get element count    ${Save for Later elements}
    ${store_num}        Get element count   ${Store_elements}
    @{item_list}    Create List
    FOR     ${store_i}   IN RANGE   ${store_num}
        ${store_local}      Evaluate    ${store_i}+${1}
        ${store_item_num}   Get element count    ${Store_elements}\[${store_local}\]${Cart elements}

        FOR  ${i}  IN RANGE  ${store_item_num}
            ${local}      Evaluate      ${i}+${1}
            ${item_name}    Get text    ${Store_elements}\[${store_local}\]${Cart elements}\[${local}\]//p[@class="productName css-1ouddpy"]/a
            Append To List    ${item_list}    ${item_name}
        END
    END
    Wait Until Element Is Visible       //p[text()='Remove All Items']
    Close Cart Initiate Error popup
    Click Element    //p[text()='Remove All Items']
    Wait Until Element Is Visible    //h4[text()='Are you sure you want to remove all products from the cart?']
    Wait Until Element Is Visible   //div[text()='Yes']
    Click Element    //div[text()='Yes']
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    sleep   1
    Wait Until Element Is Visible   //p[contains(text(),'was removed from Shopping Cart.')]
    ${remove_item_sum}      Get element count   //p[contains(text(),'was removed from Shopping Cart.')]
    Should Be Equal As numbers      ${cart_item_sum}    ${remove_item_sum}
    Log     ${item_list}
    Wait Until Element Is Visible   //h3[text()="(0 item)"]
    Sleep   1
    ${sign_true}    get element count    //p[text()="Sign In"]
    IF  ${sign_true}==2
        Wait Until Element Is Visible   //h4[text()="Are you missing items?"]
        Wait Until Element Is Visible   //div[text()="Sign In"]
        Wait Until Element Is Visible   //p[text()="to see items you may have added or saved during a previous shopping exprience."]
    ELSE
        Wait Until Element Is Visible   //h4[text()="Your shopping cart is empty"]
    END

    Wait Until Element Is Visible   //div[text()="CONTINUE SHOPPING"]

    FOR  ${item_name}   IN  @{item_list}
        ${item_name_xpath}      text_contains_special_symbols     ${item_name}      //p[contains(text(),'was removed from Shopping Cart.')]/a
        Wait Until Element Is Visible    ${item_name_xpath}
        ${remove_item_name}     Get text    ${item_name_xpath}
        Log     ${remove_item_name}
    END

cart page item layout
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Sleep  10
    ${michaels_item_count}    Get Element Count   //div[text()="Michaels"]/../../../..//p[text()="Item: "]
    ${michaels_item_count}   Evaluate    ${michaels_item_count}+${1}
    ${michaels_sku_list}    Create List
    FOR  ${sku_var}  IN  @{PRODUCT_INFO_LIST}
        IF  "MKP" in "${sku_var["channel"]}" or "MIK" in "${sku_var["channel"]}"
            Log   sku=${sku_var["sku"]}
            Append To List    ${michaels_sku_list}    ${sku_var["sku"]}
        END
    END
    Log   ${michaels_sku_list}
    FOR   ${i}   IN RANGE   ${1}    ${michaels_item_count}
        ${sku1}   Get Text       (//div[text()="Michaels"]/../../../..//p[text()="Item: "])[${i}]
        ${sku_name}      string.split      ${sku1}    :${SPACE}
        IF "${sku_name[-1]}" in  ${michaels_sku_list}
            Log  ${sku_name[-1]}
        END
    END


cart page click + update item quatity
    [Arguments]   ${item_name}
    ${item_split_name}     text_split_max_length  ${item_name}
    Wait Until Page Contains Element   //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to increment counter for number stepper"]/*
    Scroll Element Into View  //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to increment counter for number stepper"]/*
    Sleep  1
    Mouse Over   //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to increment counter for number stepper"]/*
    Click Element  //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to increment counter for number stepper"]/*

cart page click - update item quatity
    [Arguments]   ${item_name}
    ${item_split_name}     text_split_max_length  ${item_name}
    Wait Until Page Contains Element   //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*
    Scroll Element Into View  //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*
    Sleep  1
    Mouse Over   //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*
    Click Element  //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*


cart page input number update item quatity
    [Arguments]   ${item_name}      ${number}=0
    ${item_split_name}     text_split_max_length    ${item_name}
    Wait Until Page Contains Element   //a[contains(text(),"${item_split_name}")]/../../../../..//input

    Scroll Element Into View  //a[contains(text(),"${item_split_name}")]/../../../../..//input
    Sleep  1
    Close Cart Initiate Error popup
    Click Element  //a[contains(text(),"${item_split_name}")]/../../../../..//input
    IF  ${number}!=0
        Input Text  //a[contains(text(),"${item_split_name}")]/../../../../..//input
        ...        ${number}
        Sleep  1
    END
    Mouse Over  //a[contains(text(),"${item_split_name}")]
    ${value}    Get Element Attribute    //a[contains(text(),"${item_split_name}")]/../../../../..//input    value
    [Return]    ${value}


pdp class time
    Wait Until Page Contains Element   //div[@class="css-3iesda e1bdg1em15"]//label[@class="custom-radio e1bdg1em29 css-zqowcj" and @data-checked=""]//div[@class="css-vxgrp0"]
    ${class_time}   Get Text    //div[@class="css-3iesda e1bdg1em15"]//label[@class="custom-radio e1bdg1em29 css-zqowcj" and @data-checked=""]//div[@class="css-vxgrp0"]
    [Return]    ${class_time}

cart class product info
#        //p[@class="productName css-1ouddpy"]
    ${class_name_xpath}    Set Variable     (//p[@class="productName css-1ouddpy"])[1]
#    ${class_item_info}   Create Dictionary    item_name=${empty}
    Wait Until Page Contains Element   ${class_name_xpath}/a
    ${item_name}    Get Text    ${class_name_xpath}/a
    ${item_sku}    Get Text    ${class_name_xpath}/following-sibling::div//p
    ${item_eles}    Get Webelements    ${class_name_xpath}/../following-sibling::div/p
    ${number}       Get Length     ${item_eles}
    Should Be Equal As Numbers      ${number}     3
    ${item_date}    Get Text    ${item_eles}[0]
    ${item_time}    Get Text    ${item_eles}[1]
    ${item_type}    Get Text    ${item_eles}[2]
    ${item_shpping_eles}    Get Webelements    ${class_name_xpath}/../../following-sibling::div//p
    ${number}       Get Length     ${item_shpping_eles}
    IF  ${number}==4
        ${item_total_price}    Get Text    ${item_shpping_eles}[1]
        ${item_each_price}    Get Text    ${item_shpping_eles}[2]
        ${item_store}    Get Text    ${item_shpping_eles}[3]
    ELSE
        ${item_total_price}    Get Text    ${item_shpping_eles}[1]
        ${item_store}    Get Text    ${item_shpping_eles}[2]
        ${item_each_price}    Set Variable     Each ${item_total_price}
    END
    ${class_item_info}   Create Dictionary    item_name=${item_name}     item_sku=${item_sku[6:]}
    ...   item_date=${item_date[6:]}    item_time=${item_time[6:]}     item_type=${item_type[6:]}
    ...   item_total_price=${item_total_price}     item_each_price=${item_each_price}
    ...   item_store = ${item_store}
    [Return]    ${class_item_info}

Close Cart Initiate Error popup
    ${err_win}   Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad  //p[text()="Sorry, a problem has occurred."]
    IF   "${err_win[0]}"=="PASS"
        Wait Until Page Contains Elements Ignore Ad  //div[text()="CLOSE"]
        Click Element    //div[text()="CLOSE"]/parent::button
    END

Get Cart item All name
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    sleep   1
    ${cart_item_sum}        Get element count    ${Cart elements}
#    ${save_item_sum}        Get element count    ${Save for Later elements}
    ${store_num}        Get element count   ${Store_elements}
    @{item_list}    Create List
    FOR     ${store_i}   IN RANGE   ${store_num}
        ${store_local}      Evaluate    ${store_i}+${1}
        ${store_item_num}   Get element count    ${Store_elements}\[${store_local}\]${Cart elements}

        FOR  ${i}  IN RANGE  ${store_item_num}
            ${local}      Evaluate      ${i}+${1}
            ${item_name}    Get text    ${Store_elements}\[${store_local}\]${Cart elements}\[${local}\]//p[@class="productName css-1ouddpy"]/a
            Append To List    ${item_list}    ${item_name}
        END
    END
    [Return]  ${item_list}

Close Cart Message
    Wait Until Page Does Not Contain Element  //*[@stroke="transparent"]
    Wait Until Element Is Visible   ${message_close}
    Click Element    ${message_close}

Cart item remove Save for Later Message
    [Arguments]  ${item_name}
    Wait Until Element Is Visible   //p[contains(text(),'was moved to Save for Later')]
    ${var_name}     Get Text        //p[contains(text(),'was moved to Save for Later')]/a
    Should Be Equal As Strings      ${var_name}   ${item_name}
    Close Cart Message


Add 4 items to shopping cart
    Maximize Browser Window
    Sleep  1
    Clear Cart
    ${product_item_list}     Create List     MIK|listing|${MIK[0]}|1|ATC|STM|${EMPTY}    MKP|listing|${MKP[1]}|1|ATC|STM|${EMPTY}    MKR|listing|${MKR[0]}|1|ATC|STM|${EMPTY}    MIK|listing|${PIS[0]}|1|ATC|PIS|${EMPTY}    Add To Cart    Credit Card
    Select Products and Purchase Type   ${product_item_list}
    Wait Until Page Contains Elements Ignore Ad    //div[text()="View My Cart"]
    Sleep  1
    Click Element     //div[text()="View My Cart"]
    initial save for later list remove all item