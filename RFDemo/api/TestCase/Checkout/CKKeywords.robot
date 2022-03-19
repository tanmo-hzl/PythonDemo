*** Settings ***
Variables            ../../TestData/Checkout/productInfo.py
Resource            ../TestData/EnvData.robot
Library              BuyKeyword.py
Library              Collections

*** Variables ***

${timeout}    20



*** Keywords ***

Initial Checkout Env Data
#    Set Selenium Timeout      ${timeout}
    ${test_data}    Set Variable    ${test_data}[${ENV}]
    ${keys}    Get Dictionary Keys     ${test_data}
    FOR    ${key}    IN    @{keys}
        ${skus_list}     Get skus list     ${test_data}[${key}]
        Set Suite Variable    ${${key}}    ${skus_list}
    END


Get skus list
    [Arguments]    ${product_list}
    @{skus_list}    Create List
    FOR   ${sku}    IN    @{product_list}
        ${sku}   split_parameter    ${sku}   /
        IF   "-" in "${sku[-1]}"
            ${sku}   split_parameter    ${sku[-1]}   -
            ${sku}   Set Variable    ${sku[-1]}
        ELSE
            ${sku}   Set Variable    ${sku[-1]}
        END
#        ${sku}    Evaluate     int(${sku})
        Append To List     ${skus_list}     ${sku}
    END
    [Return]     ${skus_list}