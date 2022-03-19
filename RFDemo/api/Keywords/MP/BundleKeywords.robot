*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyBundle.py
Resource            ../../TestData/MP/PathBundle.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot


*** Variables ***
${post_headers}
${get_headers}


*** Keywords ***
Set Initial Data - Bundle
    [Documentation]    Set Headers
    ${get_headers}    Set Get Headers - Seller
    Set Suite Variable    ${get_headers}     ${get_headers}
    ${post_headers}    Set Post Headers - seller
    Set Suite Variable    ${post_headers}    ${post_headers}

Get Timeframe By BundleId - POST
    [Arguments]    ${bundleId}
    ${body}    Get Timeframe Body    ${bundleId}
    ${res}    Send Post Request    ${url-mik}    ${bundle-timeframe}    ${body}    ${post_headers}


Get Pricing By BundleId - POST
    [Arguments]    ${bundleId}
    ${body}    Get Pricing Body
    ${res}    Send Post Request    ${url-mik}    ${bundle-pricing}    ${body}    ${post_headers}

Get Photos By BundleId - POST
    [Arguments]    ${bundleId}
    ${body}    Get Photos Body
    ${res}    Send Post Request    ${url-mik}    ${bundle-photos}    ${body}    ${post_headers}

Get Option By BundleId - POST
    [Arguments]    ${bundleId}
    ${body}    Get Option Body
    ${res}    Send Post Request    ${url-mik}    ${bundle-option}    ${body}    ${post_headers}

Get ProductList - POST
    ${body}    Get ProductList Body
    ${res}    Send Post Request    ${url-mik}    ${bundle-productList}    ${body}    ${post_headers}

Get List - POST
    ${body}    Get List Body
    ${res}    Send Post Request    ${url-mik}    ${bundle-list}    ${body}    ${post_headers}

Create New Bundle Option - POST
    ${body}    Get Create New Bundle Option Body
    ${res}    Send Post Request    ${url-mik}    ${bundle-create-new-bundle-option}    ${body}    ${post_headers}

Get Create - POST
   ${body}    Get Create Body
   ${res}    Send Post Request    ${url-mik}    ${bundle-create}    ${body}    ${post_headers}

Add AddCardCheck - POST
    [Arguments]    ${michaelsStoreId}
    ${body}    get addCardCheck body
    ${res}    Send Post Request    ${url-mik}    ${bundle-addCardCheck}    ${body}    ${post_headers}

Update Bundle Status - PATCH
    [Arguments]    ${bundleId}    ${status}
    ${res}    Send PATCH Request    ${url-mik}    ${bundle-update-bundle-status}    ${post_headers}

Update Bundle - PATCH
    ${body}   update bundle body
    ${res}    Send Patch Request    ${url-mik}    ${bundle-update}    ${body}    ${post_headers}

Get BundleId - GET
    [Arguments]    ${michaelsStoreId}
    ${res}    Send Get Request    ${url-mik}    ${bundle-bundleId}    ${get_headers}

Get checkPrice - GET
    [Arguments]    ${bundleId}
    ${res}    Send Get Request    ${url-mik}    ${bundle-checkPrice}    ${get_headers}

Get skuNumber - GET
    [Arguments]    ${skuNumber}
    ${res}    Send Get Request    ${url-mik}    ${bundle-skuNumber}    ${get_headers}

Get All Bundle Options - GET
    ${res}    Send Get Request    ${url-mik}    ${bundle-all-bundle-options}    ${get_headers}

Get All - GET
    ${res}    Send Get Request    ${url-mik}    ${bundle-all}    ${get_headers}
    ${page_data}    Get Json Value    ${res.json()}    data    pageData