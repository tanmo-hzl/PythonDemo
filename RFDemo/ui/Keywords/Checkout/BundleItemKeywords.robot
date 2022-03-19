*** Settings ***
#Library    selenium2Library

*** Variables ***
${bundle_product_number}    //p[text()="Choose Your Products"]/..//div[@class="css-j7qwjs"]/div[@class="css-0"]
*** Keywords ***

get bundle item product number
    Wait Until Page Contains Element   //p[text()="Choose Your Products"]
    scroll element into view     //p[text()="Choose Your Products"]
    Sleep  1
    ${product_number}  get element count   ${bundle_product_number}
    [Return]     ${product_number}


get_product_item_number
    [Arguments]    ${product_local}
    Wait Until Page Contains Element   ${bundle_product_number}\[${product_local}\]
    scroll element into view     ${bundle_product_number}\[${product_local}\]
    Sleep  1
    ${product_item_number}    Create List
    ${product_number_line}  get element count   ${bundle_product_number}\[${product_local}\]//div[@class="css-ruo2fq ehggolo4"]/div/div
    ${product_number_line}   Evaluate     ${product_number_line}+${1}
    FOR   ${i}   IN RANGE     ${1}    ${product_number_line}
        ${number}       get element count      ${bundle_product_number}\[${product_local}\]//div[@class="css-ruo2fq ehggolo4"]/div/div[${i}]/div
        append to list   ${product_item_number}     ${number}
    END
    ${count}    Set Variable   ${0}
    FOR   ${i}  IN   @{product_item_number}
        ${count}    Evaluate     ${count}+${i}
    END
    [Return]    ${product_item_number}   ${count}


get bundle product item name
    [Arguments]   ${product_local}=1      ${item_local}=1      ${line}=0
    Wait Until Page Contains Element   ${bundle_product_number}\[${product_local}\]//div[@class="css-ruo2fq ehggolo4"]/div/div[${line}]/div[${item_local}]//p[1]
    ${item_name}    get text     ${bundle_product_number}\[${product_local}\]//div[@class="css-ruo2fq ehggolo4"]/div/div[${line}]/div[${item_local}]//p[1]
    [Return]    ${item_name}

select bundle product a item
    [Arguments]    ${product_local}     ${line}=1     ${item_local}=1
    Wait Until Page Contains Element   ${bundle_product_number}\[${product_local}\]
    scroll element into view     ${bundle_product_number}\[${product_local}\]
    Sleep  1
    scroll element into view     ${bundle_product_number}\[${product_local}\]//div[@class="css-ruo2fq ehggolo4"]/div/*
    mouse over     ${bundle_product_number}\[${product_local}\]//div[@class="css-ruo2fq ehggolo4"]/div/*

    FOR  ${i}  IN RANGE   ${1}    ${line}
        Wait Until Page Contains Element      //div[@class="ehggolo0 css-sr3o49"]/*
        mouse over     //div[@class="ehggolo0 css-sr3o49"]/*
        click element   //div[@class="ehggolo0 css-sr3o49"]/*

#        Log Source
    END

    click element     ${bundle_product_number}\[${product_local}\]//div[@class="css-ruo2fq ehggolo4"]/div/div[${line}]/div[${item_local}]//p[1]




product_count_select_verify
    Wait Until Page Contains Element   //div[@class="e1ozjs1x2 css-z2qomk"]/div
    scroll element into view    //div[@class="e1ozjs1x2 css-z2qomk"]/div
    Sleep  1
    ${Progress completion}     Get Element Attribute      //div[@class="e1ozjs1x2 css-z2qomk"]/div     aria-valuenow
    ${Progress completion_text}    get text     //div[@class="e1ozjs1x2 css-z2qomk"]/following-sibling::p
     ${text_length}       Get Length     ${Progress completion_text}
     IF  ${text_length}==15
         ${baifenbi}    Evaluate  int(${Progress completion_text[0]})/int(${Progress completion_text[5]})*${100}
     END
     Should Be Equal As Numbers     ${baifenbi}    ${Progress completion}
    [Return]     ${Progress completion_text[0]}



get_bundle_item_local
    [Arguments]   ${product_list}    ${local}
    ${line}  Set Variable    ${1}
    FOR   ${i}  IN   @{product_list}
            ${var}   Evaluate     ${local}-${i}
            IF  ${var}<=0
                ${result_lcoal}    Set Variable   ${local}
                Exit For Loop
            ELSE
                ${lcoal}    Set Variable   ${var}
                ${line}  Evaluate    ${line}+${1}
            END
    END

   [Return]   ${line}     ${result_lcoal}






select a bundle product to cart
    [Documentation]    arguments: product path | item1_local|item2_local|....|product_number
    [Arguments]   ${product}
    ${bundle_product_list}   split_parameter     ${product}     |
    Go To     ${url_mik}/${bundle_product_list[0]}
    ${bundle_product_count}   get bundle item product number
    ${product_length}        Get Length    ${bundle_product_list}
    ${product_length}     Evaluate     ${product_length}-${2}
    Should Be Equal As Numbers    ${bundle_product_count}      ${product_length}
    ${bundle_product_count}   Evaluate   ${bundle_product_count}+${1}
    FOR  ${i}   IN RANGE   ${1}    ${bundle_product_count}
        ${item_number_data}   ${product_count}     get_product_item_number    ${i}

        ${item_local_count}    Set Variable      ${bundle_product_list[${i}]}
        IF   ${item_local_count}>${product_count}
            Fail     bundle product 第 ${i} 个item没有 ${item_local_count} 个，请最多输入 ${product_count} 个商品
        END
        ${line}   ${item_local}    get_bundle_item_local   ${item_number_data}    ${item_local_count}
        select bundle product a item    ${i}     ${line}    ${item_local}
        ${date}    product_count_select_verify
    END
    ${date}    product_count_select_verify
    Add Product Quantity From PDP   listing      ${bundle_product_list[-1]}
    Click Add to Cart Button   MIK

