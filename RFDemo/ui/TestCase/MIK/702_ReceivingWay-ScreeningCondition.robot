*** Settings ***
Documentation       This is verifying the Receiving Way Screening Condition
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/ReceivingWay.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Verify Receiving Way Screening Condition
    [Documentation]   Verify Receiving Way Screening Condition
#    [Tags]  mik  mik-ReceivingWay  mik-ScreeningCondition
    Run Keyword And Ignore Error  Wait Until Page Contains     My Store  60
    Go To  ${URL_MIK}/shop/frames/wall-frames/open-back-frames
    Verify Receiving Way Screening Condition  Store Pickup
    Verify Receiving Way Screening Condition  Ship to Me
    Verify Receiving Way Screening Condition  Same Day Delivery
    Verify Receiving Way Screening Condition  Store Pickup  Same Day Delivery
    Verify Receiving Way Screening Condition  Store Pickup  Ship to Me
    Verify Receiving Way Screening Condition  Ship to Me  Same Day Delivery
    Verify Receiving Way Screening Condition  Ship to Me  Same Day Delivery  Store Pickup