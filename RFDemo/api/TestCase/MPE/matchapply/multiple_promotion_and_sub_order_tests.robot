*** Settings ***
#Library     ../../../Libraries/CommonLibrary.py
Resource    ../../../Keywords/MPE/applyVerifyKeyWords.robot


*** Test Cases ***
#multiple_promotion_performance_tests
#    [Tags]   mpe     multipleapply       multiple_promotion
#    [Template]      Verify Apply case keyword
#    multiple_promotion_performance_tests

multiple_sub_order_tests
    [Tags]          mpe     multipleapply     multiple_order
    [Template]      Verify Apply case keyword
    multiple_order_tests1
    multiple_order_tests2
    multiple_order_tests3