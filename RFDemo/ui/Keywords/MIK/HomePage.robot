*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot
Resource       ../../Keywords/Common/CommonKeywords.robot


*** Keywords ***
Click Element And Verify Title
    [Arguments]   ${element}   ${title_text}
    Click on the element and wait  ${element}
    IF  '${title_text}'!='${null}'
        wait until page contains element  //title[contains(text(),'${title_text}')]  60
    END

Click Top Table And Verify Title
    [Arguments]   ${element_title}
    FOR  ${element}  ${title}  IN  &{element_title}
        ${ele}  splits_string_get_text  ${element}  /
        ${lenth}  Get Length  ${ele}
        IF  '${lenth}'=='2'
            Click on the element and wait   //p[text()='${ele}[0]']/../../parent::button
            ${element}  Set Variable  ${ele[1]}
        END
        Click Element And Verify Title  //*[text()="${element}"]  ${title}
        Go Back
    END

Click Bottom Table And Verify Title
    [Arguments]   ${One_Table}   ${element_title}
    FOR  ${element}  ${title}  IN  &{element_title}
        Common - Scroll Down Until Page Contains Elements  //p[text()="${One_Table}"]/parent::button
        Scroll Element And Wait And Click  //p[text()="${One_Table}"]/parent::button
        IF  "${element}"=="Track My Order"
            Click Element And Verify Title     (//p[text()="${element}"])[2]  ${title}
        ELSE
            Click Element And Verify Title     //p[text()="${element}"]/parent::a  ${title}
        END
        Go Back
    END

Verify Recommended Product Review
    [Arguments]   ${Title_tab}   ${Product_num}=${null}
    Common - Scroll Down Until Page Contains Elements   //*[text()='${Title_tab}']  60  1
    ${elements}  Get Product Recommended Or Category element  ${Title_tab}  ${Product_num}
    IF  '${Product_num}'=='${null}'
        Mouse Over  (//*[text()='${Title_tab}']/../following-sibling::div/div)[3]
        Click On The Element And Wait  (//*[text()='${Title_tab}']/../following-sibling::div/div)[3]
        Sleep  0.1
    END
    Click On The Element And Wait  ${elements}
    Wait Until Page Contains Elements Ignore Ad  //*[text()='Reviews']  30
    Verify Product Detail Page Reviews Number
    Go Back

Get Product Recommended Or Category element
    [Arguments]   ${Title_tab}  ${Product_num}=${null}
    ${product_element}  Set Variable  //h3[text()='${Title_tab}']/../following-sibling::div/a
    ${count}  Get Element Count  ${product_element}
    IF  "${count}"=="0"
        ${product_element}  Set Variable  //*[text()='${Title_tab}']/../following-sibling::div//div[@aria-hidden="false"]
        ${count}  Get Element Count  ${product_element}
    END
    IF  '${Product_num}'=='${null}'
        ${Product_num}  Evaluate  random.randint(1, ${count})  random
    END
    Return From Keyword  (${product_element})[${Product_num}]

Verify SHOP BY CATEGORY
    Common - Scroll Down Until Page Contains Elements  //*[text()='SHOP BY CATEGORY']  30
    ${product_element}  Set Variable  //*[text()='SHOP BY CATEGORY']/../following-sibling::div/a
    ${count}  Get Element Count  ${product_element}
    FOR  ${Product_num}  IN RANGE  1  ${count}+1
        ${Category_title}  Get Text  (${product_element})[${Product_num}]//span
        Scroll Element And Wait And Click  (${product_element})[${Product_num}]
        Wait Until Page Contains  ${Category_title}  60
        Go Back
        Common - Scroll Down Until Page Contains Elements  //*[text()='SHOP BY CATEGORY']  30
    END
    Scroll Element And Wait And Click  //*[text()='SHOP BY CATEGORY']/following-sibling::a
    Wait Until Page Contains  Site Map  60

Verify Advertising Rotation Diagram
#    Verify Feature available  //div[contains(text(), ' NOW')]
#    Click On The Element And Wait  //p[text()='Michaels']/parent::a
#    Sleep  0.3
    Verify Feature available  //div[@data-index="0"]//img

Verify Feature available
    [Arguments]   ${element}
    Click On The Element And Wait  ${element}
    ${result}  Run Keyword And Ignore Error  Wait Until Page Contains  Feature is not currently available  5
    IF  '${result[0]}'=='PASS'
        Fail  Feature is not currently available
    END
