*** Settings ***
Library      ../../Libraries/Checkout/CartKeywords.py

*** Variables ***
${Trending_now}       //h3[text()='Trending Now']
${item_parent}        //div[@class="css-9u7dfx efn42h22"]
${current_item}       ${item_parent}//div[@class='slick-slide slick-active slick-current']
${item_up}            //div[@class='slick-arrow slick-prev css-0']
${item_next}          //div[@class='slick-arrow slick-next css-0']
${sleep_time}         0.3
*** Keywords ***
TrendingNowInitval
    Wait Until Page Does Not contain Element    //*[@stroke="transparent"]
    Sleep   ${sleep_time}
    AD Exception Handle-element visible    ${Trending_now}
    Scroll Element Into View        ${Trending_now}
    AD Exception Handle-element visible       ${Trending_now}/../div[3]
    mouse over      ${Trending_now}/../div[3]
    Sleep   ${sleep_time}
    AD Exception Handle-element visible   ${item_up}
    AD Exception Handle-element visible   ${item_next}

VerifyLeftArrows
    TrendingNowInitval
    ${item_lcoal}   Get Element Attribute  ${current_item}  data-index
    AD Exception Handle-element visible   ${item_up}
    AD Exception Handle   ${item_up}
    Sleep  ${sleep_time}
    ${item_lcoal2}   Get Element Attribute  ${current_item}   data-index
    IF  ${item_lcoal}==0
        Should Be Equal As Numbers   ${item_lcoal2}  11
    ELSE
        ${var}  evaluate     ${item_lcoal}-${1}
        Should Be Equal As Numbers   ${item_lcoal2}  ${var}
    END

VerifyRightArrows
    TrendingNowInitval
    ${item_lcoal}   Get Element Attribute  ${current_item}   data-index
    AD Exception Handle-element visible   ${item_next}
    AD Exception Handle   ${item_next}
    Sleep  ${sleep_time}
    ${item_lcoal2}   Get Element Attribute  ${current_item}   data-index
    IF  ${item_lcoal}==11
        Should Be Equal As Numbers   ${item_lcoal2}  0
    ELSE
        ${var}  evaluate     ${item_lcoal}+${1}
        Should Be Equal As Numbers   ${item_lcoal2}  ${var}
    END

verifyTrendingNowItemNumber
    TrendingNowInitval
    ${item_number}  get element count   //div[@class='slick-list']/div/div
    IF  ${item_number}>=12
        log  ${item_number}
    ELSE
        Fail  item_number:${item_number}<12
    END
    ${item_1}   Get Element Attribute   ${current_item}    data-index
    FOR  ${i}   IN RANGE    ${12}
        ${item-current}     get element count   ${current_item}
        ${item-active}     get element count   ${item_parent}//div[@class='slick-slide slick-active']
        ${item-cloned}     get element count   ${item_parent}//div[@class='slick-slide slick-active slick-cloned']
        ${item_count}   Evaluate     ${item-current}+${item-active}+${item-cloned}
        Log     ${item_count}
        IF  ${item_count}==4
            Log  ${item_count}
        ELSE
            Fail    ${item_count}
        END
        mouse over      ${Trending_now}/../div[3]
        Sleep   ${sleep_time}
        AD Exception Handle-element visible   ${item_next}
        AD Exception Handle   ${item_next}
        Sleep   ${sleep_time}
        ${item_var}   Get Element Attribute   ${current_item}    data-index
        IF  "${item_var}"=="${item_1}" and "${i}"!="11"
            ${var}  evaluate    ${i}+${1}
            Fail  Trending Now item number: ${var}
        END
    END
    ${item_2}   Get Element Attribute   ${current_item}    data-index
    IF  ${item_1}==${item_2}
        Log   ${item_1},${item_2}
    ELSE
        Fail   ${item_2},${item_1}
    END

VerifyEachProductsHasHref
#    AD Exception Handle-element visible   //img[@alt='shopping cart icon header']
#    mouse over  //img[@alt='shopping cart icon header']/../..
#    AD Exception Handle   //img[@alt='shopping cart icon header']/../..
#    TrendingNowInitval
    FOR  ${i}   IN RANGE    ${12}
        TrendingNowInitval
        ${item_loca}    Get Element Attribute    ${current_item}   data-index
        IF  "{item_local}"!="${i}"
            FOR  ${j}   IN RANGE    ${i}
                AD Exception Handle-element visible   ${item_next}
                AD Exception Handle   ${item_next}
                Sleep   ${sleep_time}
            END
            ${item_loca1}    Get Element Attribute    ${current_item}   data-index
             IF  ${item_loca1}==${i}
                Log  ${item_loca1}
             ELSE
                fail    ${item_loca1}
             END

        END
        AD Exception Handle-element visible   ${current_item}
        AD Exception Handle-element visible    ${current_item}//p
        ${item_name}  get text      ${current_item}//p
        AD Exception Handle    ${current_item}
        Sleep   ${sleep_time}
        wait until element is not visible   //div[text()="Product not found."]
#        ${item_name_xpath}      text_contains_special_symbols   ${item_name}     //h1
#        AD Exception Handle-element visible     ${item_name_xpath}
        Wait Until Page Contains Element     //button[text()="REVIEWS"]
        AD Exception Handle-element visible   //img[@alt='shopping cart icon header']
        mouse over  //img[@alt='shopping cart icon header']/../..
        AD Exception Handle   //img[@alt='shopping cart icon header']/../..
    END
