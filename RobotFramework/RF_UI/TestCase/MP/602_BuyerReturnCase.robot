*** Settings ***
Library             Selenium2Library
Library             ../../Libraries/CommonLibrary.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/Common/MenuKeywords.robot
Resource            ../../Keywords/MP/BuyerReturnKeywords.robot
Resource            ../../TestData/MP/ReturnData.robot
Resource            ../../Keywords/Common/MP/SellerOrderManagementKeywords.robot
Suite Setup         Run Keyword    Open Browser - MP
Suite Teardown      Close All Browsers
Test Setup          Skip If   '${Login_Status}'=='FAIL'

*** Variables ***
${Cur_User_Name}
${Login_Status}    PASS
${Par_Case_Status}
${Random_Data}


*** Test Cases ***
Test Buyer Sign In And Enter Storefront
    [Documentation]    Seller Sign In and enter Storefront Page
#    [Tags]    mp
    Log   TODO
#    Set Suite Variable    ${Cur_User_Name}    ${BUYER_NAME_RETURN}
#    User Sign In - MP    ${BUYER_EMAIL_RETURN}    ${BUYER_PWD_RETURN}    ${Cur_User_Name}
#    Main Menu - Order Page
#    [Teardown]    Set Suite Variable    ${Login_Status}    ${TEST STATUS}

Test Enter order History page
    LOG  TODO
#    点击右上角order
#    Main Menu - Order Page
#    Sleep   1
##    进入 order History
#    Store Left Meun - Order Management - Overview    ???
#    Sleep   1

#    Clear Search Order Number
#    Search Order By Order Number
#    Enter To Order Detail Page By Line Index
#
#






#Test Buy
#
#    FOR   ${index}   IN RANGE   5
#        Flow - Add Items And Chekcout
#    END