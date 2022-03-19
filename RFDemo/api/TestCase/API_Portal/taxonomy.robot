*** Settings ***
Resource            ../../Keywords/API_Portal/custom.robot
Resource            ../../TestData/API_Portal/config.robot
Suite Setup          Run Keywords    Initial Env Data - API-Portal


*** Test Cases ***
Test Get taxonomy list
    [Tags]   get_taxonomy_list     smoke
    [Documentation]     get all categories
    ${response}    Send Get Request         ${base_url}         ${get_taxonomy_list}
    record_taxonomy    ${response.json()}


Test Get taxonomy specific attributes
    [Tags]   get_taxonomy_attr      smoke
    [Documentation]     get a taxonomy attributes by a valid category
    ${data}=    tools.get_taxonomy_path
    ${response}    Send Get Request    ${base_url}    ${get_taxonomy_attr}      ${data}
    ${response_data}        get from dictionary     ${response.json()}      data

Test Get taxonomy specific attributes By Error Path
    [Tags]   get_taxonomy_attr_by_error_path
    [Documentation]     get a taxonomy attributes by a invalid category
    ${data}=    create dictionary       taxonomyPath=error_taxonomy_path
    ${response}    Send Get Request    ${base_url}    ${get_taxonomy_attr}      ${data}     expected_status=any