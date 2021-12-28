*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/ProductKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Product
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Get Full Categories
    [Tags]    b2b    b2b-pro
    Get Full Categories List - GET

Test Get Product Trending Now List - GET
    [Tags]    b2b    b2b-pro
    Get Product Trending Now List - GET

Test Get Product Purchased Together Items
    [Tags]    b2b    b2b-pro
    Get Product Purchased Together Items - GET

Test Get Product Similar Items - GET
    [Tags]    b2b    b2b-pro
    Get Product Similar Items - GET

Test Get Product Simple
    [Tags]    b2b    b2b-pro
    Get Product Simple - GET

Test Get Product Complete Info By Sku Number
    [Tags]    b2b    b2b-pro
    Get Product Complete Info By Sku Number - GET

Test Get Product Sku Info By Sku Number
    [Tags]    b2b    b2b-pro
    Get Product Sku Info By Sku Number - GET
