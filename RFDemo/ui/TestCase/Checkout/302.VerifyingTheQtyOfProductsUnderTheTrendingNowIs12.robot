*** Settings ***
Resource    ../../TestData/EnvData.robot
Resource    ../../Keywords/Checkout/VerifyQtyOfProducts_TrendingNowKeywords.robot

Suite Setup         Run Keywords     initial env data2
Test Teardown   close browser

*** Variables ***
${Trending_now}       //h3[text()='Trending Now']
#&{buyer1}    user=yixian@michaels.com    password=Password1234
#&{account_info}    first_name=yixian
#${BROWSER}    Firefox
*** Test Cases ***
1.Verifying cart page Trending Now product list item in 12 number
    [Documentation]   Verifying The Qty Of Products Under The Trending Now Is 12. lift,right arrows
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
#    Reload page
#    go to   ${URL_MIK}/product/glitzhome-42-joy-christmas-wooden-porch-sign-D210695S?component=HolidayDecor
    item pdp pagm to cart
#    AD Exception Handle-element visible   //img[@alt='shopping cart icon header']
#    mouse over  //img[@alt='shopping cart icon header']/../..
#    AD Exception Handle   //img[@alt='shopping cart icon header']/../..
#    AD Exception Handle-element visible    //div[text()="CLOSE"]
#    AD Exception Handle  //div[text()="CLOSE"]
    verifyTrendingNowItemNumber

2.Verifying cart page Trending Now product list RightArrows
    [Documentation]   Verifying The Qty Of Products Under The Trending Now Is 12. lift,right arrows
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
    item pdp pagm to cart
    VerifyRightArrows

3.Verifying cart page Trending Now product list LeftArrows
    [Documentation]   Verifying The Qty Of Products Under The Trending Now Is 12. lift,right arrows
    [Tags]   full-run       yitest1
    open browser    ${URL_MIK}    ${browser}
    item pdp pagm to cart
    VerifyLeftArrows

4.Verifying cart page Trending Now product list item all to pdp page
    [Documentation]   Verifying The Qty Of Products Under The Trending Now Is 12. lift,right arrows
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}     ${browser}
    item pdp pagm to cart
    VerifyEachProductsHasHref
*** Keywords ***
item pdp pagm to cart
    Maximize Browser Window
    go to   ${URL_MIK}/product/10-pack-8-x-10super-value-canvas-by-artists-loft-necessities-10131568
    Sleep  1
    Wait Until Page Contains Element    //div[contains(text(),"Ship to Me")]
    Click Element     //div[contains(text(),"Ship to Me")]
    Wait Until Page Contains Element    //div[text()="Add to Cart"]
    Click Element     //div[text()="Add to Cart"]
    Wait Until Page Contains Element    //div[text()="View My Cart"]
    Click Element    //div[text()="View My Cart"]




