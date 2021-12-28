*** Settings ***
Library             Selenium2Library
Library             Collections
Library             BuiltIn
Library             DateTime


*** Variables ***
${ENV}                         qa    # tst03 ==> qa |  tst02 ==>  staging
${URL_MIK}                     https://mik.${env}.platform.michaels.com/
${BROWSER}                     Chrome
${PWD}                         Password123
${TIME_OUT}                    30
${URL_MP_LANDING}              https://mik.${env}.platform.michaels.com/mp-landing
${URL_MAP}                     https://map.${env}.platform.michaels.com
${URL_BASE_SIGN_UP}            https://mik.${env}.platform.michaels.com/mp/seller/register/create-account
${MAP_EMAIL}                   yuanxian@michaels.com
${MAP_PWD}                     Yuanxian123
${URL_Onboarding}              https://mik.${env}.platform.michaels.com/mp/seller/onboarding/store-profile
${URL_EMAIL}                   https://www.snapmail.cc
${CTRL_OR_COMMAND}
${RETURN_OR_ENTER}
${UPC_ID}                      sophy@michaels.com
${UPC_PWD}                     Password123
${UPC_KEY}                     8DA83F66B248C8B0