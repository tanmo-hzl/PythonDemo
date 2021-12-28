*** Settings ***
Library             SeleniumLibrary
Suite Teardown      close browser

*** Variables ***
#${URL}          https://mik.tst02.platform.michaels.com/
${URL}        https://mik.tst02.platform.michaels.com/buyertools/order-history
${BROWSER}      Chrome

*** Test Cases ***
Test demo1


