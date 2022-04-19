*** Settings ***
Documentation       This is the case of traversing the directory
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/DirectoryTraversal.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...     AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Directory Traversal
    [Documentation]   Directory Traversal
    [Tags]  mik  mik-DirectoryTraversal
    Run Keyword And Ignore Error  Wait Until Page Contains     MacArthur Park   60
    Directory Traversal