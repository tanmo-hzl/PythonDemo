*** Settings ***
Resource        ../../Keywords/Checkout/Common.robot
Library         String
Library        ../../Libraries/Checkout/CartKeywords.py

*** Variables ***
${order summary}    //h3[text()="Order Summary"]

*** Keywords ***
Order Summary Element Tag Exist In Click
    [Arguments]  ${xpath}
    ${ele exist}    Run Keyword And Ignore Error  Wait Until Page Contains Elements Ignore Ad   ${xpath}
    IF  "${ele exist[0]}"=="PASS"
#        ${d}  Set Variable   M10.999 6.8457L5.99902 1.8457L0.999024 6.8457
        Wait Until Page Contains Elements Ignore Ad  ${xpath}/parent::button
        ${text}   Get Element Attribute   ${xpath}/parent::button   aria-expanded
        IF  "${text}"=="false"
            Click Element    ${xpath}
        END

    END
get order summary data
    Wait Until Page Contains Elements Ignore Ad   ${order summary}
    Order Summary Element Tag Exist In Click                        //p[text()="Other Fees"]
    Order Summary Element Tag Exist In Click                       //p[text()="Savings"]
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
            IF  "${data_key}" == "Total:"
                ${data_value}     Get Text    ${data_xpath}\[${i}\]/h4
            ELSE IF  "${data_key}" == "Paper Bag Fees"
                ${data_value}     Get Text     //p[text()="Paper Bag Fees"]/../following-sibling::p
            ELSE IF  "$" not in "${data_key}"
                ${data_value}     Get Text    (${data_xpath}\[${i}\]//p\[2\])\[${j}\]
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
    Wait Until Page Contains Element    //button[@class="css-1pmone7"]
    Click Element                       //button[@class="css-1pmone7"]
    Wait Until Page Contains Element    //p[text()="${tax name}"]/parent::span/preceding-sibling::span
    Click Element                       //p[text()="${tax name}"]/parent::span/preceding-sibling::span
    Wait Until Page Contains Element    //div[text()="Use this Address"]
    Click Element                       //div[text()="Use this Address"]


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
    Wait Until Page Contains Elements Ignore Ad   //*[text()="FIND OTHER SOTRES"]
    Wait Until Page Contains Elements Ignore Ad   //p[text()="MY STORE"]
    Wait Until Page Contains Elements Ignore Ad  //div[@class="chakra-input__group css-4302v8"]/input
    Input Text    ${state}
    Sleep  1
    select_from_list_by_value   //select[@class="chakra-select css-142e6yo"]     200 mi
    Sleep  1
    Click Element   //div[@class="chakra-input__group css-4302v8"]/input/following-sibling::div
    Sleep  3
    Click Element  (//div[@class="chakra-radio-group css-qyiimp"]//input)[1]
    Sleep  1
    Click Element  //div[text()="CHANGE MY STORE"]


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
        Click Element    //div[@class="chakra-input__right-element css-1lvskjz"]
        Wait Until Page Contains Elements Ignore Ad  (//div[@class="css-1d1pmvf e1jmn62g4"]//input)[1]
        ${store_number1}    Get Element Count  (//div[@class="css-1d1pmvf e1jmn62g4"]//input)[1]
        IF  ${store_number1}>0
#            Wait Until Page Contains Elements Ignore Ad    (//div[@class="css-1d1pmvf e1jmn62g4"]//input)[1]
#            ${store_infor}    Get Text    ((//div[@class="css-1d1pmvf e1jmn62g4"])[1]//p)[3]
#            Should Contain     ${store_infor}     ${state}
            Sleep  1
            Click Element   (//div[@class="css-1d1pmvf e1jmn62g4"]//input)[1]/..
            Sleep  1
            Click Element  //div[text()="CHANGE MY STORE"]
        END
    Pdp Page Ignore Reload Error
    Select Pick Up Shipping Method
    END










