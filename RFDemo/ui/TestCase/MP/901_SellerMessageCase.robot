*** Settings ***
Resource            ../../Keywords/MP/SellerMessageKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../TestData/MP/SellerData.robot
Suite Setup         Run Keywords    Initial Data And Open Browser   ${URL_MIK_SIGNIN}${Return_Url}
...                             AND   User Sign In - MP   ${SELLER_EMAIL}    ${SELLER_PWD}    ${SELLER_NAME}
Suite Teardown      Close All Browsers
Test Setup          Store Left Menu - Messages
Test Teardown       Run Keyword If    "${TEST_STATUS}"=="FAIL"    Reload Page

*** Variables ***
${Return_Url}    ?returnUrl=/mp/sellertools/messages

*** Test Cases ***
Test Send Message To Buyer
    [Documentation]    Send message to buyer on message page
    [Tags]    mp    mp-ea   ea-seller-msg
    Seller Message - Input Message
    Seller Message - Click Button Send

Test Send Attach File To Buyer
    [Documentation]    Send attach file to buyer on message page
    [Tags]    mp    mp-ea   ea-seller-msg
    Seller Message - Add Attach File