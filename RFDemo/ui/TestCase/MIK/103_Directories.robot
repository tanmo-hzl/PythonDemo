*** Settings ***
Documentation       This is to Verify Secondary Directories
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/DirectoriesKeywords.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Go to Secondary Directories
    [Documentation]   Go to Secondary Directories
    [Tags]  mik  mik-VerifyPLP  mik-GotoSecondaryDirectories
    Run Keyword And Ignore Error  Wait Until Page Contains     MacArthur Park   60
    Go to Secondary Directories   Party  Party Tableware  Straws

Test Verify PLP ordering
    [Documentation]   Verify PLP ordering
    [Tags]  mik  mik-VerifyPLP  mik-Verifyordering
    Verify PLP ordering

Test Verify PLP filtering conditions
    [Documentation]   Verify PLP filtering conditions
    [Tags]  mik  mik-VerifyPLP  mik-Verifyfilteringconditions
    Select the label and verify  Pickup & Delivery
    Select the label and verify  Price
    Select the label and verify  Brand
#    Select the label and verify  Color
    Select the label and verify  Size
    Select the label and verify  Sales & Offers
    Select the Ratings and verify  5