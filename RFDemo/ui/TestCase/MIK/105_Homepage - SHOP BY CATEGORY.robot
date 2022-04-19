*** Settings ***
Documentation       This is the product recommended by the verification homepage
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/HomePage.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...      AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Verify SHOP BY CATEGORY
    [Documentation]   Verify SHOP BY CATEGORY
    [Tags]    mik  mik-home  mik-RECProduct  mik-SHOPBYCATEGORY
    Run Keyword And Ignore Error  Wait Until Page Contains     MacArthur Park   60
    Verify SHOP BY CATEGORY