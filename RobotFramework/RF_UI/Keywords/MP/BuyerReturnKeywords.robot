*** Settings ***
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource        ../../Keywords/Common/CartsKeywords.robot
Resource        ../../Keywords/Common/MenuKeywords.robot
Library        ../../Libraries/MP/SignUpLib.py
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SignUpLib.py



*** Keywords ***
sign in by account
    Open Browser With URL   https://mik.tst03.platform.michaels.com   mpLandingUrl
    wait until element is visible  //*[text()='Sign In']
    Click Element  //*[text()='Sign In']
    Wait Until Element Is Visible    //input[@id="email"]
    input text    //input[@id="email"]     jr_tst03_buyer001@snapmail.cc
    Sleep   1
    input text    //input[@id="password"]     Rsc123456
    Sleep   1
    click button  //*[@type="submit"]
    sleep  2

#进入 order history 页面
Enter order history page
    click element   //p[contains(text(),'Order History')]
    wait until element is visible   //input[@id='searchOrders']
    Sleep   1


Click search
    [Arguments]    ${order_number}
    Input Text    //input[@id="searchOrders"]    ${order_number}
    Press Keys    //input[@id="searchOrders"]    RETURN


Click Buy All Again
    click element   //div[contains(text(),'Buy All Again')]
    Sleep   1

Enter shopping cart






