*** Settings ***
Documentation       This is verifying the Receiving Way
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/ReceivingWay.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Verify Receiving Way
    [Documentation]   Verify Receiving Way
#    [Tags]  mik  mik-ReceivingWay
    Run Keyword And Ignore Error  Wait Until Page Contains     My Store  60
    Go To  ${URL_MIK}/shop/frames/wall-frames/open-back-frames
    Verify Receiving Way

Test Verify the Pick Up of the PLP Page
    [Documentation]   Verify the Pick Up of the PLP page
    [Tags]  mik  mik-ReceivingWay  mik-PickUp-ADDCART
    Run Keyword And Ignore Error  Wait Until Page Contains     My Store  60
    Go To  ${URL_MIK}/search?q=10635675
    Verify the Pick Up of the PLP Page

Test Verify that Pick UP exceeds inventory
    [Documentation]   Verify the Pick Up of the PLP page
    [Tags]  mik  mik-ReceivingWay  mik-PickUp-Stock
    Run Keyword And Ignore Error  Wait Until Page Contains     My Store  60
    Go To  ${URL_MIK}/search?q=10635675
    Go To Store Pickup And Verify Stock