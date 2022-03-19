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
    [Arguments]  @{path}
    Mouse Over and wait  //div[text()='Shop Categories']/parent::a
    FOR  ${i}  IN  @{path}
        Mouse Over and wait  //div[text()='${i}']
    END
    Click On The Element And Wait  //div[text()='${i}']
    FOR  ${v}  IN  @{path}
        wait until page contains  ${v}
    END
    Verify PLP  ${path}[-1]  Flase

Verify PLP Ordering
    ${sort_text_list}  Create List  Best Sellers  New Arrivals
    ...  Price: High to Low  Price: Low to High  Rating: High to Low
    Mouse Click And Wait  //p[text()='Best Match']/../../parent::button
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
            IF  "${ele_text}"!="In-Store Pickup"
                Click On The Element And Wait  //p[text()='Clear All']
            ELSE
                ${result}  Run Keyword And Ignore Error  Click On The Element And Wait  (${label})[${i}]
                IF  '${result[0]}'=='FAIL'
                    Go Back
                END
            END
            Wait Loading End
        END
    END

Select the Ratings and verify
    [Arguments]  ${num}
    ${count}  Get Element Count  //p[text()='Ratings']
    IF  ${count}>0
        Click On The Element And Wait  (//p[text()='Please choose a rating']/preceding-sibling::div/*)[${num}]
        Wait Until Element Is Visible  //p[@title]
        Wait Until Element Is Visible  //div[text()='Rating: ${num} & UP']  30
        Click On The Element And Wait  //p[text()='Clear All']
        Wait Until Element Is Visible  //p[@title]
    END
