*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyCreateStore.py
Resource            ../../TestData/MP/PathCreateStore.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot

*** Variables ***
${random_id}
${seller_info_create}
${seller_info_sign}
${application_id}
${seller_user_id}
${seller_store_id}
${seller_session_id}
${index}
${ipv4}
${map_public_data}
${mik_public_data}

*** Keywords ***
Set Initial Data - Store
    [Documentation]    When debug one api, reload the saved seller info from saved file
    ${seller_info_create}    Set Variable     ${null}
    ${seller_info_create}    Run Keyword If    '${seller_info_create}'=='None'    Read File    seller-info-create     ELSE    Set Variable    ${seller_info_create}
    Set Suite Variable    ${seller_info_create}    ${seller_info_create}
    ${seller_info_sign}    Set Variable     ${null}
    ${seller_info_sign}    Run Keyword If    '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
    Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}

Check Email Existed - POST
    [Documentation]   Check email existed, if existed, change it
    FOR     ${index}    IN RANGE    10
        ${random_id}    get random code
        ${body}    create dictionary    email=AT-${random_id}@snapmail.cc
        Set Suite Variable    ${random_id}    ${random_id}
        ${res}    Send Post Request Without Token   ${url-mik}   ${check-email}    ${body}
        ${existed}    Get Json Value     ${res.json()}    data    existed
        ${buyerDisabled}    Get Json Value     ${res.json()}    data    buyerDisabled
        Exit For Loop If    '${existed}'=='False' and '${buyerDisabled}'=='False'
    END

Send Seller Pre Application - POST
    [Documentation]   Send the seller application
    Check Email Existed - POST
    ${body}    Get Seller Pre Application Body    ${random_id}
    ${res}    Send Post Request Without Token   ${url-mik}   ${seller-pre-application}    ${body}
    Run Keyword If    ${res.status_code==200}    Save File    seller-info-create    ${body}
    Set Suite Variable    ${seller_info_create}    ${body}
    ${application_id}    Get Json Value    ${res.json()}    data    sellerStoreApplicationId
    Set Suite Variable     ${application_id}    ${application_id}
    Get Application Info By Id - Get

Get Application Info By Id - Get
    [Documentation]    Get application info by application id and save it
    ${body}    Create Dictionary    applicationId=${application_id}
    ${res}    Send Get Request Without Token    ${url-mik}    ${mik-seller-application}    ${body}
    ${application_info}     Get Json Value    ${res.json()}    application
    Save File    application-info     ${application_info}
    ${application_id}    Get Json Value    ${application_info}    sellerStoreApplicationId
    Set Suite Variable    ${application_id}    ${application_id}



Get Mik Seller Query
    [Documentation]   Get the seller list by company name and status
    log   ${seller_info_create}
    ${company_name}     Get Json Value    ${seller_info_create}     companyName
    ${body}    Get Mik Seller Query Body    ${company_name}
    ${headers}    Set Post Headers - Admin
    ${res}    Send Post Request    ${url-mik}    ${mik-seller-query}    ${body}    ${headers}
    ${application_info}     Get Json Value    ${res.json()}    application
    Save File    application-info     ${application_info}
    ${application_id}    Get Json Value    ${application_info}    sellerStoreApplicationId
    Set Suite Variable    ${application_id}    ${application_id}

Seller Approve On Mik - Post
    [Documentation]   Approve the seller application
    ${body}    get seller approve body   ${application_id}
    ${headers}    Set Post Headers - Admin
    ${res}    Send Post Request    ${url-mik}    ${mik-seller-approve}    ${body}    ${headers}

Seller User Create - POST
    [Documentation]   After approve the seller application, craete user by email link
    ${body}    get mik user create body    ${seller_info_create}    ${pwd}
    ${res}    Send Post Request Without Token   ${url-mik}   ${mik-user-create}    ${body}
#    ${data}     Get Json Value    ${res.json()}     data
#    Run Keyword If    ${res.status_code==200}    Save File    user-info    ${data}

Set Company Name - POST
    [Documentation]   After create seller user, set the seller company name
    ${body}    get mik cms content text    ${seller_info_create}
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}   ${mik-company-name}    ${body}    ${headers}

Set Seller Bank Account - POST
    [Documentation]   After input company name, input bank account info
    ${body}    get mik seller bank account body
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}   ${mik-seller-bank-account}    ${body}    ${headers}

Store Registration - POST
    [Documentation]   After input all seller info, submit all info then regustration
    ${body}    get mik store registration body   ${seller_info_create}    ${application_id}    ${seller_user_id}
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request   ${url-mik}   ${mik-store-registration}    ${body}    ${headers}

Get Store Id By User Id - GET
    [Documentation]   Get store id and name by user id
    ${user_id}    Get Json Value    ${seller_info_sign}     user    id
    ${headers}    Set Get Headers - Seller
    ${res}    Send Get Request    ${url-mik}    ${mik-store-id-by-user-id}/${user_id}     ${null}    ${headers}
    ${seller_store_id}    Get Json Value    ${res.json()}    storeId
    Set Suite Variable    ${seller_store_id}    ${seller_store_id}

Update Store Profile - POST
    [Documentation]   Update store logo and banner
    Get Store Id By User Id - GET
    ${body}    Get Store Profile Body     ${seller_store_id}
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}    ${mik-store-profile}     ${body}    ${headers}

Update Store Customer Service - POST
    [Documentation]   Update store customer service
    Get Store Id By User Id - GET
    ${body}    get new customer services body    ${seller_info_sign}     ${seller_store_id}
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}    ${mik-new-customer-service}     ${body}    ${headers}

Update Store Shipping Rate - POST
    [Documentation]   Update store shipping rate
    Get Store Id By User Id - GET
    ${body}    get shipping rate add body
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}    ${mik-shipping-rate-add}     ${body}    ${headers}

Update Store Fulfillment - Post
    [Documentation]   Update store fulfillment
    Get Store Id By User Id - GET
    ${body}    get store fulfillment body    ${seller_store_id}
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}    ${mik-store-fulfillment}     ${body}    ${headers}

Update Store Return Option - Post
    [Documentation]   Update store fulfillment
    Get Store Id By User Id - GET
    ${body}    get store return option body     ${seller_store_id}
    ${headers}    Set Post Headers - Seller
    ${res}    Send Post Request    ${url-mik}    ${mik-store-return-option}     ${body}    ${headers}

Check Store isEA Seller - Get
    [Documentation]   Check store is ea seller
    ${user_id}    Get Json Value    ${seller_info_sign}     user    id
    ${headers}    Set Get Headers - Seller
    ${res}    Send Get Request    ${url-mik}    ${mik-store-isea-seller}/${user_id}     ${null}    ${headers}
    should be equal as strings    ${res.text}    true

Get Storefront Preview - Get
    [Documentation]   Get Storefront Preview
    Get Store Id By User Id - GET
    ${headers}    Set Get Headers - Seller
    ${res}    Send Get Request    ${url-mik}    ${mik-storefront-preview}/${seller_store_id}     ${null}    ${headers}

Get Store Onboarding Verify - Get
    [Documentation]   Get Store Onboarding verify
    Get Store Id By User Id - GET
    ${headers}    Set Get Headers - Seller
    ${res}    Send Get Request    ${url-mik}    ${mik-store-onboarding-verify}/${seller_store_id}     ${null}    ${headers}

Get Store Seller Info - Get
    [Documentation]   Get Store seller info
    ${user_id}    Get Json Value    ${seller_info_sign}     user    id
    ${headers}    Set Get Headers - Seller
    ${res}    Send Get Request    ${url-mik}    ${mik-store-seller-info}/${user_id}     ${null}    ${headers}



