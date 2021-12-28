*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/OrganizationsKeywords.robot
Resource            ../../Keywords/B2B/UploadFileKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Organizations
Suite Teardown       Delete All Sessions

*** Test Cases ***
Test Michaels Get Organizations List
    [Tags]    b2b    b2b-org
    Get Michaels Organizations List - GET
    Get Michaels Organizations List By Org Name - GET    Par Org

Test Michaels Add New Organization
    [Tags]    b2b    b2b-org
    Get New Organizations Name - GET
    Get New Organizations Tax Id - GET
    Michaels Add New Organization - POST

Test Michaels Organization Detail
    [Tags]    b2b    b2b-org
    Get Organization Detail - GET

Test Upload B2B File
    [Tags]    b2b    b2b-org
    Upload B2B File

Test Organization Upload Pricing Catelog Contracts
    [Tags]    b2b    b2b-org
    Organization Upload Pricing Catelog Contracts - POST

Test Michaels Add Organization Tax Bussiness Info
    [Tags]    b2b    b2b-org
    Michaels Add Organization Tax Bussiness Info - POST

Test Michaels Add Organization Tax Signatory Information
    [Tags]    b2b    b2b-org
    Michaels Add Organization Tax Signatory Information - POST

Test Michaels Submit Organization State Tax Exempt
    [Tags]    b2b    b2b-org
    Michaels Submit Organization State Tax Exempt - POST

Test Get Organization Tax Exempt
    [Tags]    b2b    b2b-org
    Get Organization Tax Exempt - GET

Test Get Organization State Tax Exempt Infomation
    [Tags]    b2b    b2b-org
    Get Organization State Tax Exempt Infomation - GET

Test Michaels Update Organization State Tax Exempt
    [Tags]    b2b    b2b-org
    Michaels Update Organization State Tax Exempt - PATCH

Test Michaels Delete Organization State Tax Exempt
    [Tags]    b2b    b2b-org
    Michaels Delete Organization State Tax Exempt - DELETE

Test Michaels Get Sub Accounts List
    [Tags]    b2b    b2b-org
    Get Sub Accounts List - GET

Test Michaels Add New Sub Accounts
    [Tags]    b2b    b2b-org
    Add New Sub Account - POST

Test Michaels Get Sub Accounts Detail
    [Tags]    b2b    b2b-org
    Get Sub Account Detail - GET

Test Michaels Update Sub Accounts Info
    [Tags]    b2b    b2b-org
    Update Sub Account Info- PATCH

Test Michaels Update Sub Accounts Status To Inactive
    [Tags]    b2b    b2b-org
    Update Sub Account Status - PATCH    INACTIVE
    Check Sub Account Status    INACTIVE

Test Michaels Update Sub Accounts Status To Active
    [Tags]    b2b    b2b-org
    Update Sub Account Status - PATCH    ACTIVE
    Check Sub Account Status    ACTIVE


