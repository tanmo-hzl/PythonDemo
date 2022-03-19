*** Settings ***
Library             ../../Libraries/Common.py
Resource            ../../TestData/B2B/PathOrganizations.robot
Resource            ../../TestData/EnvData.robot

*** Variables ***
${B2B_File_Info}

*** Keywords ***
Upload B2B File
    ${res}    Upload B2B File Request    ${URL-B2B-CMS}    ${UPLOAD_DOCUMENT}    up_org.pdf
    Save File    b2b-file    ${res.json()}
    Set Suite Variable    ${B2B_File_Info}    ${res.json()}
