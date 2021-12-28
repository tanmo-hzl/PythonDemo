*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/Common/CartsKeywords.robot
Resource            ../../Keywords/Common/CheckoutKeywords.robot
Resource            ../../Keywords/MP/BuyerOrderHistoryKeywords.robot
Resource            ../../TestData/MP/ReturnData.robot
Suite Setup         Run Keyword   Initial Data And Open Browser   ${URL_MIK}    buyer
#...                                AND    Open Browser - MP    seller
Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS


*** Test Cases ***
Test Buyer Sign In
    [Documentation]    Buyer Sign In
#    [Tags]    mp
    Switch Browser    buyer
    Set Suite Variable    ${Cur_User_Name}    ${BUYER_NAME_RETURN}
    User Sign In - MP    ${BUYER_EMAIL_RETURN}    ${BUYER_PWD_RETURN}    ${Cur_User_Name}
    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

