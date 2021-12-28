*** Settings ***
Library        DateTime
Library        ../../Libraries/MP/ListingLib.py
Library        ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Listing_Title}
${Random_Data}
${Selected_Item_Name}


*** Keywords ***
Click Return Button
    Open Browser With URL
    User Sign In - MP
    Open User Menu List
    Main Menu - Order Page





