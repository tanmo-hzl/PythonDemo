*** Settings ***
Documentation       This is the product recommended by the verification homepage
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/HomePage.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...      AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Verify YOU MAY ALSO LIKE random Products
    [Documentation]   Verify YOU MAY ALSO LIKE
    [Tags]    mik  mik-home  mik-RECProduct  mik-YOUMAYALSOLIKE
    FOR  ${v}  IN RANGE   1  5
        Verify Recommended Product Review  YOU MAY ALSO LIKE
    END