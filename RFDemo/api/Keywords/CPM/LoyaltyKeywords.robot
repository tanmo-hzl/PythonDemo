*** Settings ***
Resource            ../../TestData/EnvData.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Library             ../../Libraries/CPM/RequestBodyLoyalty.py
Resource            ../../TestData/CPM/PathLoyalty.robot

*** Keywords ***
CPM Delete User To Loyalty- DELETE
    [Arguments]    ${userId}    ${loyaltyId}    ${status}=200
    ${payload}    create dictionary    userId=${userId}    loyaltyId=${loyaltyId}
    ${resp}    Send Delete Request    ${URL-CPM}    ${loyalty}/account-mapping-delete    ${payload}    ${Headers}    ${status}

CPM Create Register Loyalty and associate users- POST
    [Arguments]    ${email}    ${userId}    ${firstName}=Auto    ${lastName}=Buyer    ${dob}=${null}    ${phoneNumber}=${null}
    ${payload}    create_loyalty    ${email}    ${userId}    ${firstName}    ${lastName}    ${dob}    ${phoneNumber}
    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/account/rewrite/creation   ${payload}    ${Headers}

CPM Get Loyalty by user id- Get
    [Arguments]  ${user_id}    ${status}=200
    ${payload}    create dictionary    userId=${user_id}
    ${resp}    Send Get Request    ${URL-CPM}    ${loyalty}/user-id    ${payload}    ${Headers}    ${status}
    ${loyaltyId}    get json value    ${resp.json()}
    return from keyword    ${loyaltyId}

CPM Create Account Registration- POST
    [Arguments]    ${email}=${null}    ${phone_number}=${null}    ${first_name}=${null}    ${last_name}=${null}
    ${payload}    create_registration    ${email}    ${phone_number}    ${first_name}    ${last_name}
    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/account-registration   ${payload}    ${Headers}

CPM Get Account Creation- Get
    [Arguments]  ${userId}    ${phoneNumber}    ${emailId}    ${status}=200
    ${payload}    create dictionary    userId=${userId}    phoneNumber=${phoneNumber}    emailId=${emailId}
    ${resp}    Send Get Request    ${URL-CPM}    ${loyalty}/account/creation    ${payload}    ${Headers}    ${status}

CPM Get Loyalty Info- Get
    [Arguments]  ${userId}
    ${payload}    create dictionary    userId=${userId}
    ${resp}    Send Get Request    ${URL-CPM}    ${loyalty}/findLoyaltyInfoByUserId    ${payload}    ${Headers}
    ${loaylty}    get json value    ${resp.json()}    data    member
    return from keyword    ${loaylty}

CPM Delete Segment- Delete
    [Arguments]    ${loyaltyId}    ${segmentName}    ${statusCode}=${null}
    ${payload}    create dictionary    loyaltyId=${loyaltyId}    segmentName=${segmentName}
    ${resp}    Send Delete Request - Params    ${URL-CPM}    ${loyalty}/segment    ${payload}    ${Headers}
    ${Loyalty}    get json value    ${resp.json()}    statusCode
    run keyword if    "${statusCode}"!=${null}
    ...    should be equal as strings    "${Loyalty}"    "${statusCode}"

CPM Create Activate Crm Offers- POST
    [Arguments]    ${source}    ${loyaltyId}    ${ruleId}    ${offerType}    ${activateAllCRMOffers}=${True}    ${statusDesc}=FAILED: LOYALTY ID NOT FOUND OR CAMPAIGN ALREADY EXISTS WITH LOYALTY ID AND RULE ID
    ${payload}    create dictionary    source=${source}    loyaltyId=${loyaltyId}    ruleId=${ruleId}    offerType=${offerType}    activateAllCRMOffers=${activateAllCRMOffers}
    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/activate-crm-offers   ${payload}    ${Headers}
    ${message}    get json value    ${resp.json()}    statusDesc
    should be equal as strings    ${message}    ${statusDesc}

CPM Create Check Discount- POST
    [Arguments]    ${loyaltyId}    ${emailId}=${null}    ${phoneNo}=${null}    ${company}=${null}    ${division}=${null}    ${source}=${null}
    ...    ${getProfile}=${null}    ${getLoyaltyPointsHistory}=${null}    ${getTaxExemptInfo}=${null}    ${getCRMOffers}=${null}    ${getVouchers}=${null}    ${status}=200

    ${payload}    create_check_discount    ${loyaltyId}    ${emailId}    ${phoneNo}    ${company}    ${division}    ${source}
    ...    ${getProfile}    ${getLoyaltyPointsHistory}    ${getTaxExemptInfo}    ${getCRMOffers}    ${getVouchers}

    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/check-discount  ${payload}    ${Headers}    ${status}

CPM Create Customer Look UP- POST
    [Arguments]    ${loyaltyId}    ${emailId}=${null}    ${phoneNo}=${null}    ${company}=${null}    ${division}=${null}    ${source}=${null}
    ...    ${getProfile}=${null}    ${getLoyaltyPointsHistory}=${null}    ${getTaxExemptInfo}=${null}    ${getCRMOffers}=${null}    ${getVouchers}=${null}    ${status}=${True}

    ${payload}    create_check_discount    ${loyaltyId}    ${emailId}    ${phoneNo}    ${company}    ${division}    ${source}
    ...    ${getProfile}    ${getLoyaltyPointsHistory}    ${getTaxExemptInfo}    ${getCRMOffers}    ${getVouchers}

    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/customerLookUp  ${payload}    ${Headers}
    ${customer}    get json value    ${resp.json()}    data    statusDetails    resStatus
    should be true    ${customer}    ${status}

CPM Create Customer Look UP Negative- POST
    [Arguments]    ${loyaltyId}    ${emailId}=${null}    ${phoneNo}=${null}    ${company}=${null}    ${division}=${null}    ${source}=${null}
    ...    ${getProfile}=${null}    ${getLoyaltyPointsHistory}=${null}    ${getTaxExemptInfo}=${null}    ${getCRMOffers}=${null}    ${getVouchers}=${null}    ${status}=${True}

    ${payload}    create_check_discount    ${loyaltyId}    ${emailId}    ${phoneNo}    ${company}    ${division}    ${source}
    ...    ${getProfile}    ${getLoyaltyPointsHistory}    ${getTaxExemptInfo}    ${getCRMOffers}    ${getVouchers}

    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/customerLookUp  ${payload}    ${Headers}
    ${customer}    get json value    ${resp.json()}    data    statusDetails    resStatus
    should not be true    ${customer}    ${status}


CPM Get Loyalty Cards- Get
    [Arguments]  ${loyaltyId}    ${source}    ${statusDesc}=${null}
    ${payload}    create dictionary    loyaltyId=${loyaltyId}    source=${source}
    ${resp}    Send Get Request    ${URL-CPM}    ${loyalty}/get-loyalty-cards    ${payload}    ${Headers}
    ${Loyalty}    get json value    ${resp.json()}    ResponseHeader    statusDesc
    run keyword if    "${statusDesc}"!="${null}"
    ...    should be equal as strings    ${Loyalty}    ${statusDesc}

CPM Create Retrigger Marketing Email- POST
    [Arguments]    ${source}    ${loyaltyId}     ${statusDesc}=${null}
    ${payload}    create dictionary    loyaltyId=${loyaltyId}    source=${source}
    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/retrigger-loyalty-card-email   ${payload}    ${Headers}
    ${Loyalty}    get json value    ${resp.json()}    statusDesc
    run keyword if    "${statusDesc}"!="${null}"
    ...    should be equal as strings    ${Loyalty}    ${statusDesc}

CPM Create Segment- POST
    [Arguments]    ${loyaltyId}    ${segmentName}    ${channel}     ${statusCode}=${null}
    ${payload}    create dictionary    loyaltyId=${loyaltyId}    segmentName=${segmentName}    channel=${channel}
    ${resp}    Send Post Request    ${URL-CPM}    ${loyalty}/segment   ${payload}    ${Headers}
    ${Loyalty}    get json value    ${resp.json()}    statusCode
    run keyword if    "${statusCode}"!=${null}
    ...    should be equal as strings    "${Loyalty}"    "${statusCode}"