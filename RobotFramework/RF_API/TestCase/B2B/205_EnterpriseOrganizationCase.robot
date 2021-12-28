*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/OrganizationsKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Organizations
Suite Teardown       Delete All Sessions

*** Test Cases ***
Test Get Organizations List
    [Tags]    b2b    b2b-org-ent
    Get New Organizations Tax Id - GET
    Get New Organizations Name - GET