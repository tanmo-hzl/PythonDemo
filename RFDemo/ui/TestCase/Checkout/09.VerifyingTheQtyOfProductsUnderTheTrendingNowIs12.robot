*** Settings ***
Resource    ../../TestData/EnvData.robot
Resource    ../../Keywords/Checkout/Common.robot
Resource    ../../Keywords/Checkout/VerifyQtyOfProducts_TrendingNowKeywords.robot
#Suite Setup         Run Keywords     Initial Env Data
Suite Setup     set selenium timeout    ${TIME_OUT}
Test Teardown   close browser

*** Variables ***
${Trending_now}       //h3[text()='Trending Now']

*** Test Cases ***
Verifying cart page Trending Now product list item in 12 number
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

Verifying cart page Trending Now product list RightArrows
    [Documentation]   Verifying The Qty Of Products Under The Trending Now Is 12. lift,right arrows
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
    item pdp pagm to cart
    VerifyRightArrows

Verifying cart page Trending Now product list LeftArrows
    [Documentation]   Verifying The Qty Of Products Under The Trending Now Is 12. lift,right arrows
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
    item pdp pagm to cart
    VerifyLeftArrows

Verifying cart page Trending Now product list item all to pdp page
    [Documentation]   Verifying The Qty Of Products Under The Trending Now Is 12. lift,right arrows
    [Tags]   full-run       yitest
    open browser    ${URL_MIK}    ${browser}
    item pdp pagm to cart
    VerifyEachProductsHasHref
*** Keywords ***
item pdp pagm to cart
    Maximize Browser Window
    go to   ${URL_MIK}/product/mini-easels-by-artists-loft-10219091
    Sleep  1
    AD Exception Handle-element visible     //p[contains(text(),"Ship to Me")]
    AD Exception Handle   //p[contains(text(),"Ship to Me")]
    AD Exception Handle-element visible   //div[text()="ADD TO CART"]
    AD Exception Handle   //div[text()="ADD TO CART"]
    AD Exception Handle-element visible   //div[text()="View My Cart"]
    AD Exception Handle   //div[text()="View My Cart"]




