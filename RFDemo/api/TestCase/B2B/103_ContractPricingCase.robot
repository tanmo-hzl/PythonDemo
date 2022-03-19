*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/B2B/ContractPricingKeywords.robot
Suite Setup          Run Keywords    Set Initial Data - B2B - Contract
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Get Contract Pricing List
    [Tags]    b2b    b2b-contract
    Get Contract Pricing List - GET

Test Create Contract Pricing By Name
    [Tags]   b2b    b2b-contract
    Create Contract Pricing By Name - POST

Test Get Contract Pricing Element
    [Tags]   b2b    b2b-contract
    Get Contract Pricing Catalogs Elements - GET

Test Update Contract Name
    [Tags]   b2b    b2b-contract
    Update Contract Pricing Name - PATCH

Test Check New Contract Name
    [Tags]   b2b    b2b-contract
    Get Contract Pricing List By Name - GET    ${New_Contract_Name}
    ${new_name}    Get Json Value    ${Contract_Info}    name
    Should Be Equal As Strings    ${new_name}    ${New_Contract_Name}

Test Get Core Items
    [Tags]   b2b    b2b-contract
    Get Core Items - GET

Test Add Core Items To Contract
    [Tags]   b2b    b2b-contract
    Add Core Items To Contract - PATCH

Test Check Core Item In Contract
    [Tags]   b2b    b2b-contract
    Get Contract Pricing Catalogs Elements - GET
    Check New Item In List    ${Contract_Elements}    ${Core_Item_Info}

Test Get Pricing Tiers List
    [Tags]   b2b    b2b-contract
    Get Pricing Tiers - GET

Test Get Pricing Tiers Items
    [Tags]   b2b    b2b-contract
    Get Pricing Tiers Items - POST

Test Add Pricing Tiers Items To Contract
    [Tags]   b2b    b2b-contract
    Add Pricing Tiers Items To Contract - PATCH

Test Check Pricing Tiers Item In Contract
    [Tags]   b2b    b2b-contract
    Get Contract Pricing Catalogs Elements - GET
    Check New Item In List    ${Contract_Elements}    ${Pricing_Tiers_Item_Info}

Test Remove Item From Elements
    [Tags]   b2b    b2b-contract
    Remove Item From Elements - PATCH

Test Check Item Not In Contract
    [Tags]   b2b    b2b-contract
    Get Contract Pricing Catalogs Elements - GET
    Check Item Not In List    ${Contract_Elements}    ${Remove_Element_Info}
