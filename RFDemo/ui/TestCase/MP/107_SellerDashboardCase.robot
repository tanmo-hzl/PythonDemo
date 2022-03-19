*** Settings ***
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/SellerDashboardKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords   Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Dashboard


*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/dashboard


*** Test Cases ***
Test Check Fixed Element Text
    [Documentation]    Check Fixed Element Text
    [Tags]    mp    mp-ea    ea-dashboard
    ${fixed_ele}    Get Ea Fixed Element    FixedElement_SellerDashboard.json
    Common - Check Page Contain Fixed Element    ${fixed_ele}


