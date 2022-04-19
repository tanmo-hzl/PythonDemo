*** Settings ***
Documentation       This is verifying the Receiving Way - NearbyStores
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/ReceivingWay.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Verify Receiving Way Nearby Stores
    [Documentation]   Verify Receiving Way NearbyStores
    [Tags]  mik  mik-ReceivingWay  mik-NearbyStores
    Run Keyword And Ignore Error  Wait Until Page Contains     My Store    60
    Go To  ${URL_MIK}/shop/frames/wall-frames/open-back-frames
    Verify Receiving Way Nearby Stores