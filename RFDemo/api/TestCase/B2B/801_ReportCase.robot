*** Settings ***
Resource            ../../Keywords/B2B/ReportKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Reports
Suite Teardown       Delete All Sessions


*** Variables ***


*** Test Cases ***
Test Create Sales-summary
    [Tags]  b2b  b2b-reporter
    Create Sales-summary - Post

Test Save Spend Summary Reporter
    [Tags]  b2b  b2b-reporter
    Save Sales-summary Repoter - Post

Test Get Report List
    [Tags]  b2b  b2b-reporter
    Get Report Crieria Lists - Get

Test Create Sales Report
    [Tags]  b2b  b2b-reporter
    Create Spend Report - Post