*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodySellerAccountSetting.py
Resource            ../../TestData/MP/PathSellerAccountSetting.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/MP/UserKeywords.robot

*** Variables ***
${seller_headers}
${seller_headers_post}
${seller_info_sign}
${seller_store_id}
${seller_user_id}
${seller-account}
${variant_contents}
${deviceUuid}     ${None}

*** Keywords ***
Set Initial Data - Account Setting
    Mik Seller Sign In Scuse Of Order - POST    ${seller-account}
    ${seller_headers}    Set Get Headers - Seller
    Set Suite Variable    ${seller_headers}    ${seller_headers}
    ${seller_headers_post}    Set Post Headers - Seller
    Set Suite Variable    ${seller_headers_post}    ${seller_headers_post}
    ${seller_info_sign}    Set Variable     ${null}
    ${seller_info_sign}    Run Keyword If    '${seller_info_sign}'=='None'    Read File    seller-info-sign     ELSE    Set Variable    ${seller_info_sign}
    Set Suite Variable    ${seller_info_sign}    ${seller_info_sign}
    ${seller_store_id}    Get Json Value    ${seller_info_sign}    sellerStoreProfile    sellerStoreId
    Set Suite Variable    ${seller_store_id}    ${seller_store_id}
    ${seller_user_id}    Get Json Value    ${seller_info_sign}    sellerStoreProfile    userId
    Set Suite Variable    ${seller_user_id}    ${seller_user_id}

Get Account User Device - Get
    ${res}    send get Request    ${url-mik}    ${Account-user-device}    ${NUll}   ${seller_headers}
    ${data}     get json value    ${res.json()}      data
    FOR    ${item}    IN    @{data}
        ${user_id}     set variable     ${item}[userId]
        IF   "${user_id}"!="${seller_user_id}"
             set suite variable    ${deviceUuid}      ${item}[deviceUuid]
        END
    END

Update Account Two Factor Verify Code - Post
    ${body}    update account two factor verify code body
    ${res}    send post request    ${url-mik}    ${Account-update-two-factor-verify-code}   ${body}   ${seller_heade rs_post}

Update Account Two Factor Verify Auth - Post
    ${body}    update account two factor verify auth body
    ${res}    send post request    ${url-mik}    ${Account-update-two-factor-verify-auth}   ${body}   ${seller_headers_post}

Update Account Password Secure - Post
    ${res}    Send Get Request Without Token   ${URL-MIK-MAP}    ${map-get-public-key}     ${null}
    ${map_public_data}    Get Json Value    ${res.json()}    data
    ${public_key}    Get Json Value    ${map_public_data}    publicKey
    ${pwd_info}      create dictionary     password=${pwd}      newPassword=1234567
    ${map_email_password}    Rsa Encrypt Sha256 Msg By Key    ${public_key}    ${pwd_info}
    ${map_email_password}    str_to_url_encode      ${map_email_password}
    ${body}    create dictionary     passwordAndNewPassword=${map_email_password}
    ${res}    send post request    ${url-mik}    ${Account-update-password-secure}   ${body}   ${seller_headers_post}

    ${pwd_info}      create dictionary     password=1234567      newPassword=${pwd}
    ${map_email_password}    Rsa Encrypt Sha256 Msg By Key    ${public_key}    ${pwd_info}
    ${map_email_password}    str_to_url_encode      ${map_email_password}
    ${body}    create dictionary     passwordAndNewPassword=${map_email_password}
    ${res}    send post request    ${url-mik}    ${Account-update-password-secure}   ${body}   ${seller_headers_post}

Delete Account User Device - Delete
    IF    "${deviceUuid}"!="${None}"
        ${res}    send delete request    ${url-mik}    ${Account-user-device}/${deviceUuid}   ${NUll}   ${seller_headers}
    ELSE
        Skip    No other device uuid exited.
    END