*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MIK/MikCommonKeywords.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot

*** Variables ***
${child_directory}
${Directory_info}
${statistical_variable}

*** Keywords ***
Directory Traversal
    Set Suite Variable   ${statistical_variable}  ${0}
    ${Directory_info}  Create List  Shop Categories
    Set Suite Variable  ${Directory_info}
    Mouse Over and wait  //div[text()='Shop Categories']/parent::a
    ${One_Directory}  Get Webelements  //div[text()='Shop Categories']/parent::a/following-sibling::div//a/div
    ${title_list}  Create List
    FOR  ${One_ele}  IN  @{One_Directory}
        ${title_text}  Get Text And Wait  ${One_ele}
        Append To List  ${title_list}  ${title_text}
    END
    FOR  ${title}  IN  @{title_list}
        Mouse Over and wait  //div[text()='Shop Categories']/parent::a
        Set Suite Variable  ${child_directory}  //div[text()='${title}']/parent::a/../../following-sibling::div
        Verify that there are subdirectories and click  ${title}
    END

Verify that there are subdirectories and click
    [Arguments]  ${title}
    Append To List  ${Directory_info}  ${title}
    Hover over the target directory  ${Directory_info}
    Sleep  0.2
    Set Suite Variable  ${statistical_variable}  ${statistical_variable+1}
    ${Directory}  Get Webelements  ${child_directory}\[${statistical_variable}\]//a/div
    IF  '${Directory}'!='[]'
        ${result}  Determine if it is Trending Now  ${statistical_variable}
        IF  '${result}'!='True'
            ${test_num}  Set Variable  1
            FOR  ${child_ele}  IN  @{Directory}
                Hover over the target directory  ${Directory_info}
                Sleep  0.2
                ${child_title}  Get Text And Wait  (${child_directory}\[${statistical_variable}\]//a/div)[${test_num}]
                ${test_num}  Evaluate  ${test_num}+1
                Verify that there are subdirectories and click  ${child_title}
            END
#        ELSE
#            Loop click on items from Trending Now  ${Directory}
        END
    END
    Go to Directories And Verify  ${Directory_info}
    remove_from_list  ${Directory_info}  -1
    Set Suite Variable  ${statistical_variable}  ${statistical_variable-1}
    Sleep  0.2

Determine if it is Trending Now
    [Arguments]  ${num}
    ${ele}  Get Webelements  ${child_directory}\[${num}\]//h4[text()='Trending Now']
    Log  ${child_directory}\[${num}\]//h4[text()='Trending Now']
    IF  '${ele}'=='[]'
        Return From Keyword  False
    ELSE
        Return From Keyword  True
    END

Go to Directories And Verify
    [Arguments]  ${path}
    ${len}  Get Length  ${path}
    Mouse Over And Wait  //div[text()='Shop Categories']/parent::a
    Mouse Over And Wait  //div[text()='Shop Categories']/parent::a/following-sibling::div//a
    FOR  ${num}  IN RANGE  0  ${len}
        Sleep  0.2
        IF  '${path}[${num}]'=='Trending Now'
            Scroll Element And Wait And Click  (//h4[text()='Trending Now']/following-sibling::a)[${path[-1]}]
            Wait Until Page Contains  Add to Cart
            Exit For Loop
        ELSE IF  '${num}'=='${len-1}'
            IF  '${num}'=='1'
                ${ele}  Get Webelements  //div[text()='${path}[${num}]']/parent::a
                Scroll Element And Wait And Click  ${ele}[-1]
                IF  '${path}[${num}]' in 'New Arrivals Clearance Sale'
                    ${CATEGORY}  Get Webelements  //h2/following-sibling::div/a
                    FOR  ${v}  IN  ${CATEGORY}
                        ${CATEGORY_title}  Get Text And Wait  ${v}
                        Scroll Element And Wait And Click  ${v}
                        IF  'All' in ${CATEGORY_title}
                            ${CATEGORY_title}  Set Variable  ${CATEGORY_title[4:]}
                        END
                        Wait Until Page Contains  ${CATEGORY_title}
                        Wait Until Page Contains  Results
                    END
                ELSE
                    Run Keyword And Ignore Error  Click On The Element And Wait  //div[text()='SHOP NOW']/parent::a  1
                    Wait Until Page Contains  ${path}[${num}]
                END
            ELSE IF  '${path}[${num}]' in 'New Arrivals Clearance Sale'
                Exit For Loop
            ELSE
                ${ele}  Get Webelements  //div[text()='${path}[${num}]']/parent::a
                Scroll Element And Wait And Click  ${ele}[-1]
                Run Keyword And Ignore Error  Wait Until Page Contains  Sort By  5
            END
            wait until page contains  ${path}[${num}]
        ELSE
            ${ele}  Get Webelements  //div[text()='${path}[${num}]']/parent::a
            Scroll Element And Mouse Over And Wait  ${ele}[-1]
        END
    END

Hover over the target directory
    [Arguments]  ${ele}
    Mouse Over And Wait  //div[text()='Shop Categories']/parent::a
    Mouse Over And Wait  //div[text()='Shop Categories']/parent::a/following-sibling::div//a
    FOR  ${title}  IN  @{ele}
        ${ele_01}  Get Webelements  //div[text()='${title}']/parent::a
        Scroll Element And Mouse Over And Wait  ${ele_01}[-1]
    END

Loop click on items from Trending Now
    [Arguments]  ${Directory}
    Append To List  ${Directory_info}  Trending Now
    ${len}  Get Length  ${Directory}
    FOR  ${num}  IN RANGE  1  ${len}+1
        Append To List  ${Directory_info}  ${num}
        Go to Directories And Verify  ${Directory_info}
        remove_values_from_list   ${Directory_info}  ${num}
    END
    remove_values_from_list   ${Directory_info}  Trending Now