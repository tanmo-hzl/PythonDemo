*** Settings ***
Library             Collections
Library             BuiltIn
Library             RequestsLibrary
Library             ../../Libraries/Common.py
Library             ../../Libraries/MP/RequestBodyCreateStore.py
Resource            ../../TestData/MP/PathUpload.robot
Resource            ../../TestData/EnvData.robot

*** Keywords ***
Upload Store Logo JPEG - POST
    ${seller_info_sign}    Read File    seller-info-sign
    ${user_id}    Get Json Value    ${seller_info_sign}     user    id
    ${token}    Get Json Value    ${seller_info_sign}     token
    ${user_info}    Create Dictionary     source_type=mik    user_id=${user_id}    token=${token}
    ${res}    Upload Img To Cms Request    ${URL-MIK}   ${cms-uploadFilesToGcs}    up_logo.jpeg    ${user_info}
    ${url}    Get Json Value    ${res.json()}    data    uploadedFiles    url
    Run Keyword If    '${url}'!='None'    Save Img Url To File    logoUrl    ${url}

Upload Store Banner JPEG - POST
    ${seller_info_sign}    Read File    seller-info-sign
    ${user_id}    Get Json Value    ${seller_info_sign}     user    id
    ${token}    Get Json Value    ${seller_info_sign}     token
    ${user_info}    Create Dictionary     source_type=mik    user_id=${user_id}    token=${token}
    ${res}    Upload Img To Cms Request    ${URL-MIK}    ${cms-uploadFilesToGcs}    up_banner.jpeg    ${user_info}
    ${url}    Get Json Value    ${res.json()}    data    uploadedFiles    url
    Run Keyword If    '${url}'!='None'    Save Img Url To File    bannerUrl    ${url}

Save Img Url To File
    [Arguments]    ${key}    ${url}
    ${upload_img_data}    Read File    upload-img-data
    IF    ${upload_img_data}==None
        ${upload_img_data}  Create Dictionary
    END
    Set To Dictionary    ${upload_img_data}    ${key}    ${url}
    Save File    upload-img-data    ${upload_img_data}


Upload Image Files
    ${res}  upload_files_to_gcs  ${URL-MIK}  /cms/content/v2/uploadFilesToGcs
    [Return]  ${res}