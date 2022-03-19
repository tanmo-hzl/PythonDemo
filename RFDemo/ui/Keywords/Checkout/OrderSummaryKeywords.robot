*** Settings ***
Resource        ../../Keywords/Checkout/Common.robot
Library         String
Library        ../../Libraries/Checkout/CartKeywords.py

*** Variables ***
${order summary}    //h3[text()="Order Summary"]

*** Keywords ***
get order summary data
    [Arguments]
    AD Exception Handle-element Visible   ${order summary}
    Sleep  1
    ${data_xpath}   Set Variable   ${order summary}/../div
    ${data_count}   Get Element Count   ${data_xpath}
    ${data_count1}   Evaluate   ${data_count}+${1}
    ${data}      Create Dictionary   a   1
    Remove From Dictionary    ${data}    a
    Log   ${data}

    FOR  ${i}   IN RANGE   ${1}   ${data_count1}
        ${text_count}   Get Element Count    ${data_xpath}\[${i}\]//p\[1\]
        ${text_count}   Evaluate   ${text_count}+${1}
        FOR  ${j}   IN RANGE   ${1}   ${text_count}
            ${data_key}     Get Text    (${data_xpath}\[${i}\]//p\[1\])\[${j}\]
            IF  "${data_key}" != "Total:"
                ${data_value}     Get Text    (${data_xpath}\[${i}\]//p\[2\])\[${j}\]

            ELSE
                ${data_value}     Get Text    ${data_xpath}\[${i}\]/h4
            END
#        IF  "Subtotal" in "${data_key}"
#            ${data_key2}    String.split string     ${data_key}     (
#
#        END
            Set To Dictionary    ${data}     ${data_key}     ${data_value}
        END

    END
    Log   ${data}
    ${data1}   get_order_summary_data_fun   ${data}
    [Return]    ${data1}

select tax address
    [Arguments]   ${tax name}=tax
    AD Exception Handle-element Visible   //button[@class="css-1pmone7"]
    AD Exception Handle   //button[@class="css-1pmone7"]
    AD Exception Handle-element Visible   //p[text()="${tax name}"]/parent::span/preceding-sibling::span
    AD Exception Handle    //p[text()="${tax name}"]/parent::span/preceding-sibling::span
    AD Exception Handle-element Visible   //div[text()="Use this Address"]
    AD Exception Handle   //div[text()="Use this Address"]


select a store-state
    [Arguments]   ${state}
    ${pop_handle}    Run Keyword And Ignore Error   AD Exception Handle     //p[text()="My Store:"]
    IF  '${pop_handle}[0]' == 'FAIL'
        Reload Page
        Sleep  5
        go to  ${Home URL}/${MIK[0]}
        ${pop_handle}    Run Keyword And Ignore Error   AD Exception Handle     //p[text()="My Store:"]

    END
    Mouse Over  //p[text()="My Store:"]
    AD Exception Handle-element Visible   //*[text()="FIND OTHER SOTRES"]
    AD Exception Handle-element Visible   //p[text()="MY STORE"]
    AD Exception Handle-element Visible  //div[@class="chakra-input__group css-4302v8"]/input
    Input Text    ${state}
    Sleep  1
    select_from_list_by_value   //select[@class="chakra-select css-142e6yo"]     200 mi
    Sleep  1
    AD Exception Handle   //div[@class="chakra-input__group css-4302v8"]/input/following-sibling::div
    Sleep  3
    AD Exception Handle  (//div[@class="chakra-radio-group css-qyiimp"]//input)[1]
    Sleep  1
    AD Exception Handle  //div[text()="CHANGE MY STORE"]


select pis store
    [Arguments]   ${state}=TX
    Sleep  3
    ${count}    Get Element Count    //h3[text()="MY STORE"]
    IF  ${count}==1
        AD Exception Handle-element Visible   //h3[text()="MY STORE"]
        Wait Until Page Contains Element   //div[@class="chakra-input__right-element css-1lvskjz"]/preceding-sibling::input
        Sleep  2
        Select From List By Value    //select[@class="chakra-select e1guvl1h2 css-12txjxl"]    200
#        Wait Until Page Contains Element    //select[@class="chakra-select e1guvl1h2 css-12txjxl"]
#        Mouse Over   //select[@class="chakra-select e1guvl1h2 css-12txjxl"]
#        Mouse Down  //select[@class="chakra-select e1guvl1h2 css-12txjxl"]
#        Sleep  1
#        AD Exception Handle-element Visible    //select[@class="chakra-select e1guvl1h2 css-12txjxl"]/option[5]
#        Mouse Over   //select[@class="chakra-select e1guvl1h2 css-12txjxl"]/option[5]
#        Mouse Down  //select[@class="chakra-select e1guvl1h2 css-12txjxl"]/option[5]

        Input Text  //div[@class="chakra-input__right-element css-1lvskjz"]/preceding-sibling::input
        ...         ${state}
        Sleep  1
        AD Exception Handle    //div[@class="chakra-input__right-element css-1lvskjz"]
        ${store_number1}    Get Element Count  (//div[@class="css-1d1pmvf e1jmn62g4"]//input)[1]
        IF  ${store_number1}>0
            Wait Until Page Contains Element    (//div[@class="css-1d1pmvf e1jmn62g4"]//input)[1]
            ${store_infor}    Get Text    ((//div[@class="css-1d1pmvf e1jmn62g4"])[1]//p)[3]
            Should Contain     ${store_infor}     ${state}
            Sleep  1
            AD Exception Handle   (//div[@class="css-1d1pmvf e1jmn62g4"]//input)[1]/..
        END
        Sleep  1
        AD Exception Handle  //div[text()="CHANGE MY STORE"]
    END










