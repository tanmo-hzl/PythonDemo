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
    ${save_sum1}    Get element count   //h3[contains(text(),"Save for Later")]
    IF  ${save_sum1}==1
          Scroll Element Into View   //h3[contains(text(),"Save for Later")]

         ${save_item_sum}        Get element count    ${Save for Later elements}

         FOR  ${i}  IN RANGE   ${1}     ${save_item_sum}

            AD Exception Handle-element visible    ${Save for Later elements}\[${2}\]//div[text()='Remove']
            AD Exception Handle       ${Save for Later elements}\[${2}\]//div[text()='Remove']
            AD Exception Handle-element visible   //h4[contains(text(),' Are you sure you want to remove the following product from the cart?')]
            AD Exception Handle-element visible   //button[@class='css-xfbgqw']
            AD Exception Handle    //button[@class='css-xfbgqw']
            Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
            Sleep  2
            ${save_sumi}    Get element count   //h3[contains(text(),"Save for Later")]
            IF  ${save_sumi}==1
                Scroll Element Into View   //h3[contains(text(),"Save for Later")]
            END
         END
    END
     ${save_item_sumi}    Get element count    //h3[contains(text(),"Save for Later")]
     Should Be Equal As Numbers     ${save_item_sumi}       0

Cart Verify Remove and Save for Later
    [Arguments]     ${action}=save      ${loca_item}=${1}
    Wait Until Page Does Not Contain Element    //*[@stroke="transparent"]
    Sleep  1
    AD Exception Handle-element visible     ${Cart elements}
    ${item_elements}       get Webelements    ${Cart elements}
    ${cart_item_sum}        Get element count    ${Cart elements}
    ${save_item_sum}        Get element count    ${Save for Later elements}

    IF   ${cart_item_sum} >= ${loca_item}
        AD Exception Handle-element visible    ${Cart elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${sku}      Get Text        ${Cart elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${item_name}    Get Text     ${Cart elements}\[${loca_item}\]//a
        IF  '${action}'=='save'
            AD Exception Handle-element visible    ${Cart elements}\[${loca_item}\]//div[text()='Save for Later']
            AD Exception Handle       ${Cart elements}\[${loca_item}\]//div[text()='Save for Later']
            AD Exception Handle-element visible   //p[contains(text(),'was moved to Save for Later')]
            ${var_name}     Get Text    //p[contains(text(),'was moved to Save for Later')]/a
            Should Be Equal As Strings      ${var_name}   ${item_name}
        ELSE
            AD Exception Handle-element visible    ${Cart elements}\[${loca_item}\]//div[text()='Remove']
            AD Exception Handle       ${Cart elements}\[${loca_item}\]//div[text()='Remove']
            AD Exception Handle-element visible   //h4[contains(text(),' Are you sure you want to remove the following product from the cart?')]
            AD Exception Handle-element visible   //button[@class='css-xfbgqw']
            AD Exception Handle    //button[@class='css-xfbgqw']
            AD Exception Handle-element visible    //p[contains(text(),'was removed from Shopping Cart.')]
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
        AD Exception Handle-element visible   ${item_name_xpath}
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
    AD Exception Handle-element visible   ${message_close}
    AD Exception Handle    ${message_close}


Save for Later Verify Remove and Move to cart
    [Arguments]     ${action}=cart      ${loca_item}=${2}
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    sleep   1
    AD Exception Handle-element visible     ${Save for Later elements}
    ${item_elements}       get Webelements    ${Cart elements}
    ${cart_item_sum}        Get element count    ${Cart elements}
    ${save_item_sum}        Get element count    ${Save for Later elements}

    IF   ${save_item_sum} >= ${loca_item}
        AD Exception Handle-element visible    ${Save for Later elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${sku}      Get Text        ${Save for Later elements}\[${loca_item}\]//p[contains(text(),'Item:')]
        ${item_name}    Get Text     ${Save for Later elements}\[${loca_item}\]//a
        IF  '${action}'=='cart'
            AD Exception Handle-element visible    ${Save for Later elements}\[${loca_item}\]//div[text()='Move to Cart']
            AD Exception Handle       ${Save for Later elements}\[${loca_item}\]//div[text()='Move to Cart']
#            AD Exception Handle-element visible   //p[contains(text(),'was moved to Save for Later')]
#            ${var_name}     Get Text    //p[contains(text(),'was moved to Save for Later')]/a
#            Should Be Equal As Strings      ${var_name}   ${item_name}
#            AD Exception Handle-element visible   ${message_close}
#            AD Exception Handle    ${message_close}
        ELSE
            AD Exception Handle-element visible    ${Save for Later elements}\[${loca_item}\]//div[text()='Remove']
            AD Exception Handle       ${Save for Later elements}\[${loca_item}\]//div[text()='Remove']
            AD Exception Handle-element visible   //h4[contains(text(),' Are you sure you want to remove the following product from the cart?')]
            AD Exception Handle-element visible   //button[@class='css-xfbgqw']
            AD Exception Handle    //button[@class='css-xfbgqw']
#            AD Exception Handle-element visible    //p[contains(text(),'was moved to Save for Later.')]
#            ${var_name}     Get Text    //p[contains(text(),'was moved to Save for Later.')]/a
#            Should Be Equal As Strings      ${var_name}   ${item_name}
        END

    END

    IF  '${action}' == 'cart'
        ${cart_item_sum}     Evaluate      ${cart_item_sum}+${1}
        ${item_name_xpath}      text_contains_special_symbols   ${item_name}     ${Cart elements}//a
        AD Exception Handle-element visible     ${item_name_xpath}
        ${save_item_name}       Get Text     ${item_name_xpath}
        Should Be Equal As Strings      ${item_name}     ${save_item_name}
        AD Exception Handle-element visible     ${item_name_xpath}/../following-sibling::div//p
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
    ${save_item_sum}        Get element count    ${Save for Later elements}
    ${store_num}        Get element count   ${Store_elements}
    @{item_list}    Create List
    FOR     ${store_i}   IN RANGE   ${store_num}
        ${store_local}      Evaluate    ${store_i}+${1}
        ${store_item_num}   Get element count    ${Store_elements}\[${store_local}\]${Cart elements}

        FOR  ${i}  IN RANGE  ${store_item_num}
            ${local}      Evaluate      ${i}+${1}
            ${item_name}    Get text    ${Store_elements}\[${store_local}\]${Cart elements}\[${local}\]//a
            Append To List    ${item_list}    ${item_name}
        END
    END
    AD Exception Handle-element visible       //p[text()='Remove All Items']
    AD Exception Handle    //p[text()='Remove All Items']
    AD Exception Handle-element visible    //h4[text()='Are you sure you want to remove all products from the cart?']
    AD Exception Handle-element visible   //div[text()='Yes']
    AD Exception Handle    //div[text()='Yes']
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    sleep   1
    AD Exception Handle-element visible   //p[contains(text(),'was removed from Shopping Cart.')]
    ${remove_item_sum}      Get element count   //p[contains(text(),'was removed from Shopping Cart.')]
    Should Be Equal As numbers      ${cart_item_sum}    ${remove_item_sum}
    Log     ${item_list}
    AD Exception Handle-element visible   //h3[text()="(0 item)"]
    Sleep   1
    ${sign_true}    get element count    //p[text()="Sign In"]
    IF  ${sign_true}==3
        AD Exception Handle-element visible   //h4[text()="Are you missing items?"]
        AD Exception Handle-element visible   //div[text()="Sign In"]
        AD Exception Handle-element visible   //p[text()="to see items you may have added or saved during a previous shopping exprience."]
    ELSE
        AD Exception Handle-element visible   //h4[text()="Your shopping cart is empty"]

    END

    AD Exception Handle-element visible   //div[text()="CONTINUE SHOPPING"]

    FOR  ${item_name}   IN  @{item_list}
        ${item_name_xpath}      text_contains_special_symbols     ${item_name}      //p[contains(text(),'was removed from Shopping Cart.')]/a
        AD Exception Handle-element visible    ${item_name_xpath}
        ${remove_item_name}     Get text    ${item_name_xpath}
        Log     ${remove_item_name}
    END

    AD Exception Handle-element visible   ${message_close}
    AD Exception Handle    ${message_close}

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
    AD Exception Handle  //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to increment counter for number stepper"]/*

cart page click - update item quatity
    [Arguments]   ${item_name}
    ${item_split_name}     text_split_max_length  ${item_name}
    Wait Until Page Contains Element   //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*
    Scroll Element Into View  //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*
    Sleep  1
    Mouse Over   //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*
    AD Exception Handle  //a[contains(text(),"${item_split_name}")]/../../../../..//div[@aria-label="button to decrement counter for number stepper"]/*


cart page input number update item quatity
    [Arguments]   ${item_name}      ${number}=0
    ${item_split_name}     text_split_max_length    ${item_name}
    Wait Until Page Contains Element   //a[contains(text(),"${item_split_name}")]/../../../../..//input

    Scroll Element Into View  //a[contains(text(),"${item_split_name}")]/../../../../..//input
    Sleep  1
    Click Element  //a[contains(text(),"${item_split_name}")]/../../../../..//input
    IF  ${number}!=0
        Input Text  //a[contains(text(),"${item_split_name}")]/../../../../..//input
        ...        ${number}
        Sleep  1
    END
    Mouse Over  //a[contains(text(),"${item_split_name}")]
    ${value}    Get Element Attribute    //a[contains(text(),"${item_split_name}")]/../../../../..//input    value
    [Return]    ${value}





