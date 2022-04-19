*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MIK/MikCommonKeywords.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot

*** Variables ***
${categories_list}
${text}
${cate_len}
${little_title}

*** Keywords ***
Go to Secondary Directories
    [Arguments]  ${path}
    Mouse Over and wait  //div[text()='Shop Categories']/parent::a
    Mouse Over And Wait  //div[text()='Shop Categories']/parent::a/following-sibling::div//a
    FOR  ${title}  IN   @{path}
        IF  '${title}'=='Trending Now'
            Scroll Element And Wait And Click  (//h4[text()='Trending Now']/following-sibling::a)[${path[-1]}]
            Wait Until Page Contains  ADD TO CART
            Exit For Loop
        ELSE IF  '${title}'=='${path}[-1]'
            Scroll Element And Mouse Over And Wait  //div[text()='${title}']/parent::a
            IF  '${title}'=='${path}[0]'
                Scroll Element And Wait And Click    (//div[text()='${title}']/parent::a)[16]
            ELSE
                Scroll Element And Wait And Click    //div[text()='${title}']/parent::a
            END
            FOR  ${v}  IN  @{path}
                wait until page contains  ${v}
            END
        ELSE
            Scroll Element And Mouse Over And Wait  //div[text()='${title}']/parent::a
        END
    END

Verify PLP Ordering
    ${sort_text_list}  Create List  Best Sellers  New Arrivals
    ...  Price: High to Low  Price: Low to High  Rating: High to Low  Best Match
    Mouse Click And Wait  //p[text()='Sort By']/following-sibling::button
    FOR  ${i}  IN  @{sort_text_list}
        Click On The Element And Wait  //p[text()='${i}']/parent::button
        Wait Loading End
        Sleep  1
        IF  ':' in '${i}'
            ${product_info}  Get PLP Product Info
            IF  '${i}' == 'Price: High to Low'
                ${sort_product_info}  verify_product_sort  ${product_info}  max  True
            ELSE IF  '${i}' == 'Price: Low to High'
                ${sort_product_info}  verify_product_sort  ${product_info}  min  False
            ELSE IF   '${i}' == 'Rating: High to Low'
                ${sort_product_info}  verify_product_sort  ${product_info}  reviews_num  True
            END
            IF  ${product_info} != ${product_info}
                Fail  The sort order is inconsistent
            END
            Scroll Element Into View  //p[text()='${i}']/../../parent::button
        END
        Mouse Click And Wait  //p[text()='${i}']/../../parent::button
    END

Select the label and verify
    [Arguments]  ${label_name}
    IF  '${label_name}'=='Pickup & Delivery'
        ${label}  Set Variable  //p[text()='${label_name}']/following-sibling::div//p
    ELSE
        ${label}  Set Variable  //p[text()='${label_name}']/../following-sibling::div//p
    END
    ${count}  Get Element Count  ${label}
    IF  ${count}>0
        FOR  ${i}  IN RANGE  ${count}  0  -1
            ${ele_text}  Get Text  (${label})[${i}]
            Click On The Element And Wait  (${label})[${i}]
            Wait Loading End
            Click On The Element And Wait  //p[text()='Clear All']
            Wait Loading End
        END
    END

Select the Ratings and verify
    [Arguments]  ${num}
    ${count}  Get Element Count  //p[text()='Ratings']
    IF  ${count}>0
        Click On The Element And Wait  (//p[text()='Please choose a rating']/preceding-sibling::div/*)[${num}]
        Wait Until Element Is Visible  //div[text()='Rating: ${num} & UP']  30
        Click On The Element And Wait  //p[text()='Clear All']
        Wait Until Element Is Not Visible  //p[text()='Clear All']
    END
