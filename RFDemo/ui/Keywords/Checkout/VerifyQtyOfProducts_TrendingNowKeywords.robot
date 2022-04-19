*** Settings ***
Library      ../../Libraries/Checkout/CartKeywords.py
Resource     Common.robot

*** Variables ***
${Trending_now}       //h3[text()='Trending Now']
${item_parent}        //div[@class="css-9u7dfx efn42h22"]
${current_item}       ${item_parent}//div[@class='slick-slide slick-active slick-current']
${item_up}            //h3[text()="Trending Now"]/parent::div//div[@class='slick-arrow slick-prev slick-disabled css-0']
${item_next}          //h3[text()="Trending Now"]/parent::div//div[@class='slick-arrow slick-next css-0']
${sleep_time}         0.3
*** Keywords ***
TrendingNowInitval
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    Sleep   ${sleep_time}
#    AD Exception Handle-element visible    ${Trending_now}
    Wait Until Element Is Visible     ${Trending_now}
    Scroll Element Into View        ${Trending_now}
#    AD Exception Handle-element visible       ${Trending_now}/../div[3]
    Wait Until Element Is Visible      ${Trending_now}/../div[3]
    mouse over      ${Trending_now}/../div[3]
    Sleep   ${sleep_time}
    Wait Until Element Is Visible     ${item_up}
    Wait Until Element Is Visible     ${item_next}
#    AD Exception Handle-element visible   ${item_up}
#    AD Exception Handle-element visible   ${item_next}

VerifyLeftArrows
    TrendingNowInitval
    ${item_lcoal}   Get Element Attribute  ${current_item}  data-index
    IF  ${item_lcoal}==0
            Wait Until Element Is Visible    ${item_next}
            Click Element    ${item_next}
    END
    Sleep  ${sleep_time}
    Wait Until Page Contains Elements Ignore Ad    //h3[text()="Trending Now"]/parent::div//div[@class='slick-arrow slick-prev css-0']
    Click Element    //h3[text()="Trending Now"]/parent::div//div[@class='slick-arrow slick-prev css-0']
#    AD Exception Handle-element visible   ${item_up}
#    AD Exception Handle   ${item_up}
    Sleep  ${sleep_time}
    ${item_lcoal2}   Get Element Attribute  ${current_item}   data-index
    IF  ${item_lcoal}==0
        Should Be Equal As Numbers   ${item_lcoal2}  0
    ELSE
        ${var}  evaluate     ${item_lcoal}-${1}
        Should Be Equal As Numbers   ${item_lcoal2}  ${var}
    END

VerifyRightArrows
    TrendingNowInitval
    ${item_lcoal}   Get Element Attribute  ${current_item}   data-index
    Wait Until Element Is Visible     ${item_next}
    Click Element     ${item_next}
#    AD Exception Handle-element visible   ${item_next}
#    AD Exception Handle   ${item_next}
    Sleep  ${sleep_time}
    ${item_lcoal2}   Get Element Attribute  ${current_item}   data-index
    IF  ${item_lcoal}==8
        Should Be Equal As Numbers   ${item_lcoal2}  8
    ELSE
        ${var}  evaluate     ${item_lcoal}+${1}
        Should Be Equal As Numbers   ${item_lcoal2}  ${var}
    END

verifyTrendingNowItemNumber
    TrendingNowInitval
    ${item_number}  get element count   //div[@class='slick-list']/div/div
    IF  ${item_number}==12
        log  ${item_number}
    ELSE
        Fail  item_number:${item_number}<12
    END
    ${item_1}   Get Element Attribute   ${current_item}    data-index
#    FOR  ${i}   IN RANGE    ${9}
    ${item-current}     get element count   ${current_item}
    ${item-active}     get element count   ${item_parent}//div[@class='slick-slide slick-active']
#        ${item-cloned}     get element count   ${item_parent}//div[@class='slick-slide slick-active slick-cloned']
#        ${item_count}   Evaluate     ${item-current}+${item-active}+${item-cloned}
    ${item_count}   Evaluate     ${item-current}+${item-active}
    Log     ${item_count}
    IF  ${item_count}==4
        Log  ${item_count}
    ELSE
        Fail    ${item_count}
    END
#        mouse over      ${Trending_now}/../div[3]
#        Sleep   ${sleep_time}
#         Wait Until Element Is Visible     ${item_next}
#         Click Element    ${item_next}
##        AD Exception Handle-element visible   ${item_next}
##        AD Exception Handle   ${item_next}
#        Sleep   ${sleep_time}
#        ${item_var}   Get Element Attribute   ${current_item}    data-index
#        IF  "${item_var}"=="${item_1}" and "${i}"!="11"
#            ${var}  evaluate    ${i}+${1}
#            Fail  Trending Now item number: ${var}
#        END
#    END
#    ${item_2}   Get Element Attribute   ${current_item}    data-index
#    IF  ${item_1}==${item_2}
#        Log   ${item_1},${item_2}
#    ELSE
#        Fail   ${item_2},${item_1}
#    END

VerifyEachProductsHasHref
#    AD Exception Handle-element visible   //img[@alt='shopping cart icon header']
#    mouse over  //img[@alt='shopping cart icon header']/../..
#    AD Exception Handle   //img[@alt='shopping cart icon header']/../..
#    TrendingNowInitval
    FOR  ${i}   IN RANGE    ${12}
        TrendingNowInitval
        ${item_loca}    Get Element Attribute    ${current_item}   data-index
        IF  ${i}<8
            ${loop_count}   Set Variable  ${i}
        ELSE
            ${loop_count}   Set Variable  ${8}
        END
        FOR  ${j}   IN RANGE    ${loop_count}
            Wait Until Element Is Visible   ${item_next}
            ${next_view}    Run Keyword And Ignore Error  Scroll Element Into View   ${item_next}
#                Execute Javascript     window.scrollTo(0, 2000)
            IF  "${next_view[0]}"=="FAIL"
                Execute Javascript         document.body.scrollHeight
            END
            Click Element  ${item_next}
            Sleep   ${sleep_time}
        END
        ${item_loca1}    Get Element Attribute    ${current_item}   data-index
         IF  ${item_loca1}==${loop_count}
            Log  ${item_loca1}
         ELSE
            fail    ${item_loca1}
         END
        Wait Until Element Is Visible   ${current_item}
        Wait Until Element Is Visible    ${current_item}//p
        ${item_name}  get text      ${current_item}//p
        Click Element   ${current_item}
        Sleep   ${sleep_time}
        ${pdp_normal}  Run Keyword And Ignore Error  verify Pdp normal
        IF  "${pdp_normal[0]}"=="FAIL"
            Reload Page
            verify Pdp normal
        END
        Wait Until Element Is Visible   //img[@alt='shopping cart icon header']
        mouse over  //img[@alt='shopping cart icon header']/../..
        Click Element  //img[@alt='shopping cart icon header']/../..
        IF  ${i}>8
            ${active_eles}  Get Webelements   ${item_parent}//div[@class='slick-slide slick-active']
            FOR  ${active_ele}  IN  ${active_eles}
                Click Element   ${current_item}
                Sleep   ${sleep_time}
                wait until element is not visible   //div[text()="Product not found."]
        #        ${item_name_xpath}      text_contains_special_symbols   ${item_name}     //h1
        #        Wait Until Element Is Visible     ${item_name_xpath}
                ${handle}   Run Keyword And Ignore Error   Wait Until Page Contains Element     //*[text()="REVIEWS"]
                IF  '${handle}[0]' == 'FAIL'
                     Wait Until Page Contains Element     //*[text()="REVIEW"]
                END
                Wait Until Element Is Visible   //img[@alt='shopping cart icon header']
                mouse over  //img[@alt='shopping cart icon header']/../..
                Click Element  //img[@alt='shopping cart icon header']/../..
            END
        END
    END

verify Pdp normal
        wait until element is not visible   //div[text()="Product not found."]
#        ${item_name_xpath}      text_contains_special_symbols   ${item_name}     //h1
#        Wait Until Element Is Visible     ${item_name_xpath}
        ${handle}   Run Keyword And Ignore Error   Wait Until Page Contains Element     //*[text()="REVIEWS"]
        IF  '${handle}[0]' == 'FAIL'
             Wait Until Page Contains Element     //*[text()="REVIEW"]
        END

