*** Settings ***
Documentation       This is to Verify Product Details Page
Library        ../../Libraries/CommonLibrary.py
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/ProductKeywords.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Verify Product Details page
    [Documentation]   Verify Product Details page
    [Tags]  mik  mik-ProductDetailspage  mik-Product  mik-dev
    Search Project  ${search_result}
    Verify PLP      ${search_result}  True
    Click plus and minus verify the quantity
    Verify Product Details page
