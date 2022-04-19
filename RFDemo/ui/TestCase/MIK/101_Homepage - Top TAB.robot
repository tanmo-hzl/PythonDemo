*** Settings ***
Documentation       This is the verify homepage top menu bar
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/HomePage.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...      AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Click Top Left TAB Verify Title
    [Documentation]   Click Top Left TAB Verify Title
    [Tags]  mik  mik-home  mik-TopTAB  mik-toplefttab  mik-dev
    ${element_dict}  Create Dictionary  Makerplace=Makerplace
    ...  Custom Framing=Michaels Custom Framing
    ...  Business/Enterprise=Michaels Pro
    ...  Business/Education=Michaels Pro
    ...  Michaels Family/Photo Gift=Photo Gifts, Photo Prints
    Click Top Table And Verify Title  ${element_dict}

Test Click Top Right TAB Verify Title
    [Documentation]   Click Top Right TAB Verify Title
    [Tags]  mik  mik-home  mik-TopTAB  mik-toprighttab  mik-dev
    ${element_dict}  Create Dictionary
    ...  Michaels Rewards=Rewards - Enroll Today
    ...  Classes & Events=Online Art Classes for Kids and Adults
    ...  Projects=Crafting Projects
    ...  Weekly Ad=Weekly Ad | Michaels  Coupons=Coupons & Promo Codes
    ...  Gift Cards=Gift Cards
    Click Top Table And Verify Title  ${element_dict}