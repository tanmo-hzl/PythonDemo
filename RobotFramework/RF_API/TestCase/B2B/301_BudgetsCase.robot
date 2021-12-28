*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/BudgetsKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Budgets
Suite Teardown       Delete All Sessions

*** Test Cases ***
Test Get Budget List
    [Tags]    b2b    b2b-budget
    Get User Budget List - GET

Test Add Budget To Parent Organization
    [Tags]    b2b    b2b-budget
    Add Budget To Parent Organization - POST

Test Get Budget Detail
    [Tags]    b2b    b2b-budget
    Get Budget Detail - GET

Test Update Budget To Sub Account
    [Tags]    b2b    b2b-budget
    Update Budget To Sub Accout - PATCH

Test Delete Budget
    [Tags]    b2b    b2b-budget
    Delete Budget - DELETE