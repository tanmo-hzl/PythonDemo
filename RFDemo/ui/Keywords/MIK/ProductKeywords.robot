*** Settings ***
Library        String
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot

*** Keywords ***
Click plus and minus verify the quantity
    ${count}   Get Element Count   //input[@aria-label="Number Stepper" and @disabled]
    IF  '${count}'=='0'
        ${vaule_ele}  Set Variable  //input[@aria-label="Number Stepper"]
        ${stat_num}  Get Value  ${vaule_ele}
        Click On The Element And Wait  ${vaule_ele}/following-sibling::div
        ${vaule}  Get Value  ${vaule_ele}
        ${stat_num_add}  Evaluate  ${stat_num}+${stat_num}
        Should Be Equal As Numbers  ${vaule}  ${stat_num_add}
        Click On The Element And Wait  ${vaule_ele}/preceding-sibling::div
        ${vaule}  Get Value  ${vaule_ele}
        Should Be Equal As Numbers  ${vaule}  ${stat_num}
    END

Verify Product Details page
    ${item_type}  Verify Product Is Mik Or EA Or FGM
    Click On The Element And Wait  //p[text()='Add to list']
    IF  '${item_type}'!='FGM'
        Click On The Element And Wait  (//p[text()='Share'])[1]
    END
    Verify Product Detail Page Reviews Number
#    Add Reviews  5  test  test
#    Reload Page
#    Verify Product Detail Page Reviews Number













