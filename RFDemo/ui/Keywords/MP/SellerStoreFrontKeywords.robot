*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot
Resource       ../../TestData/MP/SellerData.robot


*** Variables ***


*** Keywords ***
Store Front - Go To Seller Store Front Page
    Go To    ${URL_MIK}/mp/storefront/${SELLER_STORE_NAME}?sellerStoreId=${SELLER_STORE_ID}
    Wait Until Element Is Visible    //h1[text()="CONTACT INFO"]

Store Front - Select Random Listing Enter Detail Page
    [Arguments]    ${index}=${None}
    Wait Until Element Is Visible    (//div[@pointer-events="all"]//div[contains(@class,"chakra-aspect-ratio")])
    Wait Until Page Contains Element    //div[@aria-label="Previous Page"]
    Sleep    1
    ${lst_ele}    Set Variable    (//div[@pointer-events="all"]//div[contains(@class,"chakra-aspect-ratio")])
    ${count}   Get Element Count    ${lst_ele}
    IF    '${index}'=='${None}'
        ${index}   Evaluate    random.randint(1,${count})
    ELSE
        IF    ${index}>=${count}
            ${index}   Evaluate    ${count}
        ELSE
            ${index}   Evaluate    ${count}-${index}
        END
    END
    Scroll Element Into View    ${lst_ele}\[${index}\]
    Sleep    0.5
    Click Element    ${lst_ele}\[${index}\]
    Wait Until Element Is Visible    //div[text()="ADD TO CART"]/parent::button
    Wait Until Element Is Enabled    //div[text()="ADD TO CART"]/parent::button

