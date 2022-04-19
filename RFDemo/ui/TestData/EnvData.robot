*** Settings ***
Library             SeleniumLibrary     run_on_failure=Capture Screenshot and embed it into the report
Library             Collections
Library             BuiltIn
Library             DateTime


*** Variables ***
${ENV}                         qa    # tst03 ==> qa |  tst02 ==>  staging
${BROWSER}                     Chrome
${TIME_OUT}                    15
${MAX_TIME_OUT}                30
${URL_MIK}                     https://mik.${env}.platform.michaels.com
${URL_MIK_SIGNIN}              ${URL_MIK}/signin
${URL_MIK_cart}                ${URL_MIK}/cart
${URL_MIK_profile}             ${URL_MIK}/buyertools/profile
${URL_MP_LANDING}              ${URL_MIK}/mp/landing
${URL_MP_APPLY}                ${URL_MIK}/mp/apply
${URL_MAP}                     https://map.${env}.platform.michaels.com
${URL_BASE_SIGN_UP}            ${URL_MIK}/mp/seller/register/create-account
${URL_Onboarding}              ${URL_MIK}/mp/seller/onboarding/store-profile
${URL_EMAIL}                   https://www.snapmail.cc
${CTRL_OR_COMMAND}
${RETURN_OR_ENTER}
${UPC_ID}                      sophy@michaels.com
${UPC_PWD}                     Password123
${UPC_KEY}                     8DA83F66B248C8B0
${URL_summer_store}            ${URL_MIK}/fgm/storefront/summer?type=1

${API_HOST_MIK}                ${URL_MIK}/api

*** Keywords ***
Capture Screenshot and embed it into the report
    Run Keyword And Ignore Error    Get Browser Console Log
    Capture Page Screenshot    filename=EMBED