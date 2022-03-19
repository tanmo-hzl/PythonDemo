*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Promotion_Code}
${Day_Range}

*** Keywords ***
Seller Marketing - Click Button Create Customer Promotion
    Wait Until Element Is Visible    //div[text()="CREATE A PROMOTION"]/parent::button
    Click Element    //div[text()="CREATE A PROMOTION"]/parent::button
    Sleep    1

Seller Marketing - Promotion Type - Close
    Click Element    //header[contains(@id,"chakra-modal--header")]/following-sibling::button
    Wait Until Element Is Not Visible    //header[contains(@id,"chakra-modal--header")]/following-sibling::button
    Sleep    1

Seller Marketing - Promotion Type - Select By Index
    [Documentation]    1-Spend & Get - % Off;2-Spend & Get - $ Amount Off;3-Buy  & Get  - % Off;
    ...    4-Buy A & Get B - Free;5-Percent Off;6-BMSM - % Off
    [Arguments]    ${index}
    Wait Until Element Is Visible    //header[contains(@id,"chakra-modal--header")]/following-sibling::button
    Sleep    1
    Click Element    //header[contains(@id,"chakra-modal--header")]/following-sibling::div/div/div[${index}]
    Wait Until Element Is Not Visible    //header[contains(@id,"chakra-modal--header")]/following-sibling::button
    Sleep    1
    Wait Until Element Is Visible    //h2[text()="Promotion Details"]
    Sleep    1

Seller Marketing - Click Link Change Promotion Type
    Click Element    //form[@id="promotionForm"]//div[text()="Change "]/parent::button
    Wait Until Element Is Visible    //header[contains(@id,"chakra-modal--header")]/following-sibling::button

Seller Marketing - Input Promotion Name
    ${Promotion_Code}    Get Uuid Split
    Set Suite Variable    ${Promotion_Code}   ${Promotion_Code}
    Log    Don't need promotion name
    Clear Element Value      //*[@id="description"]
    Input Text    //*[@id="description"]    Promotion ${Promotion_Code}

Seller Marketing - Click Start Time
    Click Element    //input[@placeholder="Start Time"]

Seller Marketing - Click End Time
    Click Element    //input[@placeholder="End Time"]

Seller Marketing - Clear Start Time
    Mouse Over    //input[@placeholder="Start Time"]
    Click Element    //input[@placeholder="Start Time"]/following-sibling::div//*[contains(@class,"icon-tabler-x")]

Seller Marketing - Clear End Time
    Mouse Over    //input[@placeholder="End Time"]
    Click Element    //input[@placeholder="End Time"]/following-sibling::div//*[contains(@class,"icon-tabler-x")]

Seller Marketing - Select Timeframe
    [Arguments]    ${year}    ${month}    ${day}    ${hour}    ${minute}    ${second}
    Click Element    //div[contains(@class,"rmdp-header-values")]//span[2]    # select year
    Sleep    0.5
    Click Element    //div[contains(@class,"rmdp-year-picker")]//span[text()="${year}"]/parent::div
    Sleep    0.5
    Click Element    //div[contains(@class,"rmdp-header-values")]//span[1]    # select month
    Sleep    0.5
    Click Element    //div[contains(@class,"rmdp-month-picker")]//span[contains(text(),"${month}")]/parent::div
    Sleep    0.5
    Double Click Element    //div[contains(@class,"rmdp-time-picker")]//input[@name="hour"]
    Input Text    //div[contains(@class,"rmdp-time-picker")]//input[@name="hour"]    ${hour}
    Double Click Element    //div[contains(@class,"rmdp-time-picker")]//input[@name="minute"]
    Input Text    //div[contains(@class,"rmdp-time-picker")]//input[@name="minute"]    ${minute}
    Double Click Element    //div[contains(@class,"rmdp-time-picker")]//input[@name="second"]
    Input Text    //div[contains(@class,"rmdp-time-picker")]//input[@name="second"]    ${second}
    Sleep    0.5
    Click Element    //div[contains(@class,"rmdp-calendar")]//span[text()="${day}"]

Seller Marketing - Set Start And End Time
    [Arguments]    ${start_day_add}=0     ${end_day_add}=3
    ${now_tiem}    Get Current Date
    ${abFrom}    Add Time To Date     ${now_tiem}    ${start_day_add} days
    ${abTo}    Add Time To Date     ${abFrom}    ${end_day_add} days
    ${s_t}    Convert Date    ${abFrom}    datetime
    ${e_t}    Convert Date    ${abTo}    datetime
    ${s_month}    Get En Month    ${s_t.month}
    ${e_month}    Get En Month    ${e_t.month}
#    Seller Marketing - Clear Start Time
    Seller Marketing - Click Start Time
    Seller Marketing - Select Timeframe    ${s_t.year}   ${s_month}    ${s_t.day}    ${s_t.hour}    ${s_t.minute}    ${s_t.second}
#    Seller Marketing - Clear End Time
    Seller Marketing - Click End Time
    Seller Marketing - Select Timeframe    ${e_t.year}   ${e_month}    ${e_t.day}    ${e_t.hour}    ${e_t.minute}    ${e_t.second}

Seller Marketing - Click Button Select Product
    Scroll Element Into View    //div[text()="Select Product"]/parent::button
    Click Element    //div[text()="Select Product"]/parent::button
    Wait Until Element Is Visible    //h3[text()="Choose Products to add"]
    Wait Until Element IS Visible    //table//tbody//td[4]//p
    Sleep    1

Seller Marketing - Click Button Choose Gift
    Scroll Element Into View    //div[text()="Choose Gift"]/parent::button
    Click Element    //div[text()="Choose Gift"]/parent::button
    Wait Until Element Is Visible    //h3[text()="Choose Products to add"]
    Wait Until Element IS Visible    //table//tbody//td[4]//p
    Sleep    1

Seller Marketing - Select Product - Close
    Click Element    //h3[text()="Choose Products to add"]/following-sibling::button
    Wait Until Element Is Not Visible    //h3[text()="Choose Products to add"]/following-sibling::button
    Sleep    1

Seller Marketing - Select Product - Cancel
    Click Element    //div[text()="CANCEL"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="CANCEL"]/parent::button
    Sleep    1

Seller Marketing - Select Product - Add
    Click Element    //div[text()="ADD"]/parent::button
    Wait Until Element Is Not Visible    //div[text()="ADD"]/parent::button
    Sleep    1

Seller Marketing - Select Product - Search
    [Documentation]    search_type:1-title;2-sku
    [Arguments]    ${search_value}    ${search_type}=1
    Click Element    //button[text()="Reset"]
    Input Text    //input[@title="search-materials"]    ${search_value}
    Press Keys    ${RETURN_OR_ENTER}
    Sleep    1
    Run Keyword If    '${search_type}'=='1'
    ...    Wait Until Element Is Visible    //table//tbody//td[4]//p[contains(text(),"${search_value}")]
    Run Keyword If    '${search_type}'=='2'
    ...    Wait Until Element Is Visible    //table//tbody//td[3]//p[text()="${search_value}"]
    Sleep    1

Seller Marketing - Select Product - Selected By Index
    [Documentation]    index:=0 - select all; >0 - select by line index
    [Arguments]    ${index}=1
    ${count}    Get Element Count    (//div[contains(@id,"page-")]/p)
    ${page_index}    Evaluate    random.randint(1,${count})
    Scroll Element Into View    (//div[contains(@id,"page-")]/p)[${page_index}]
    Click Element    (//div[contains(@id,"page-")]/p)[${page_index}]
    Sleep    1
    Wait Until Page Contains Element     //table//thead//th//*[@stroke="currentColor"]
    Scroll Element Into View    //table//thead//th//*[@stroke="currentColor"]
    IF    '${index}'=='0'
        Click Element    //table//thead//th//*[@stroke="currentColor"]
    ELSE
        Click Element    (//table//tbody//td//*[@stroke="currentColor"])[${index}]
    END

Seller Marketing - Add Sale Product To Promotion
    Seller Marketing - Click Button Select Product
    Seller Marketing - Select Product - Selected By Index    0
    Seller Marketing - Select Product - Add

Seller Marketing - Add Gift Product To Promotion
    Seller Marketing - Click Button Choose Gift
    Seller Marketing - Select Product - Selected By Index    0
    Seller Marketing - Select Product - Add

Seller Marketing - Remove Added Product By Index
    [Documentation]    index:=0 - remove all; >0 - remove by product index
    [Arguments]    ${index}=1
    ${element}    Set Variable    //h4[text()="Choose a Product"]/following-sibling::div/div[2]//button
    ${count}    Get Element Count    ${element}
    IF    ${count}>0
        IF    '${index}'=='0'
            FOR    ${ele_index}    IN RANGE    ${count}
                Click Element    ${element}
                Sleep    0.2
            END
        ELSE
            Click Element    ${element}\[${index}\]
        END
    END

Seller Marketing - Input Conditions Value
    [Arguments]    ${buy_value}
    Clear Element Value     //*[@id="buyValue"]
    Input Text    //*[@id="buyValue"]    ${buy_value}
    Sleep    0.5

Seller Marketing - Input Get Value
    [Arguments]    ${get_value}
    Clear Element Value     //*[@id="getValue"]
    Input Text    //*[@id="getValue"]    ${get_value}
    Sleep    0.5

Seller Marketing - Input Off Value
    [Arguments]    ${off_value}
    Clear Element Value     //*[@id="offValue"]
    Input Text    //*[@id="offValue"]    ${off_value}
    Sleep    0.5

Seller Marketing - Check For Example Text By Promotion Type
    [Arguments]    ${pom_type}=1    ${buy_value}=0    ${get_value}=0    ${off_value}=0
    Scroll Element Into View    //div[text()="BACK"]
    Sleep    1
    IF    '${pom_type}'=='1'
        Page Should Contain Element   //h4[text()="Spend $${buy_value} or more get ${off_value}% Off"]
    ELSE IF  '${pom_type}'=='2'
        Page Should Contain Element   //h4[text()="Spend $${buy_value} get $${off_value} amount Off"]
    ELSE IF  '${pom_type}'=='3'
        Page Should Contain Element   //h4[text()="Buy ${buy_value} get ${get_value} pieces ${off_value}% Off"]
    ELSE IF  '${pom_type}'=='4'
        Page Should Contain Element   //h4[text()="Buy ${buy_value} get ${get_value} free, add ${${buy_value}+${get_value}} items to qualify"]
    ELSE IF  '${pom_type}'=='5'
        Page Should Contain Element   //h4[text()="get ${off_value}% Off"]
    ELSE IF  '${pom_type}'=='6'
        Page Should Contain Element   //h4[text()="Buy ${buy_value} pieces or more for ${off_value}% Off"]
    ELSE
        Log    ${pom_type}
    END

Seller Marketing - Create Promotion - Close
    Click Element    //a[@aria-label="Close and return to Michaels.com"]
    Wait Until Element Is Visible      //h2[text()="Marketing"]
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]


Seller Marketing - Create Promotion - Back
    Click Element    //div[text()="BACK"]/parent::button
    Wait Until Element Is Visible      //h2[text()="Marketing"]
    Sleep    1
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]

Seller Marketing - Create Promotion - Save And Continue
    Click Element    //div[text()="SAVE AND CONTINUE"]/parent::button
    Wait Until Element Is Visible      //h2[text()="Promotion Review"]


Seller Marketing - Promotion Review - Save As Draft
    Click Element    //div[text()="SAVE AS DRAFT"]/parent::button
    Sleep   2
    Wait Until Element Is Visible      //div[text()="Back to My Marketing Overview"]/parent::button
    Click Element    //div[text()="Back to My Marketing Overview"]/parent::button
    Sleep    1
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]

Seller Marketing - Promotion Review - Publish Campaign
    Click Element    //div[text()="PUBLISH CAMPAIGN"]/parent::button
    Sleep    2
    Wait Until Element Is Visible      //div[text()="Back to My Marketing Overview"]/parent::button
    Click Element    //div[text()="Back to My Marketing Overview"]/parent::button
    Sleep    1
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]

Seller Marketing - Go To Analytics For More Details
    Click Element    //p[text()="Go to Analytics for more details"]/../parent::a
    Wait Until Element Is Visible    //h3[text()="Analytics"]
    Element Should Not Be Visible    //p[text()="Marketing Overview"]/parent::button

Seller Marketing - Campaign - Scroll To End
    ${count}    Get Element Count     //div[@aria-label="Previous Page"]
    Run Keyword If    ${count}>0    Scroll Element Into View     //div[@aria-label="Previous Page"]

Seller Marketing - Campaign - Search
    [Arguments]    ${search_value}
    ${count}    Get Element Count    //p[text()="No Data!"]
    Run Keyword If   '${count}'=='1'   Scroll Element Into View    //p[text()="No Data!"]
    Run Keyword If   '${count}'=='0'   Scroll Element Into View    //p[text()="view"]
    Clear Element Value    //*[@id="searchOrders"]
    Input Text    //*[@id="searchOrders"]    ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
    Sleep    1
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]
    Sleep    1

Seller Marketing - Campaign - Filter Clear All
    Click Element    ${Filter_Btn_Ele1}
    Wait Until Element Is Visible    ${Filter_View_Results}
    Sleep    1
    Click Element    ${Filter_Clear_All}

Seller Marketing - Campaign - Filter Search By Status
    [Documentation]    All Status,Active,Completed,Draft,Terminated,Scheduled
    [Arguments]    ${status}
    Click Element    ${Filter_Btn_Ele1}
    Wait Until Element Is Visible    ${Filter_View_Results}
    Sleep    1
    Click Element    //h5[text()="Status"]/following-sibling::button[text()="CLEAR"]
    Click Element    //span[text()="${status}"]/parent::label
    Click Element    ${Filter_View_Results}
    Sleep    1
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]
    Sleep    1

Seller Marketing - Campaign - Select Actions By Index
    [Documentation]    action:View Details,Edit,Delete,Terminated
    [Arguments]    ${action}=View Details    ${index}=1
    Click Element    //table//tbody/tr[${index}]//button
    ${element}     Set Variable    //table//tbody/tr[${index}]//button/following-sibling::div//p[contains(text(),"${action}")]/parent::button
    Wait Until Element Is Visible    ${element}
    Click Element    ${element}
    Sleep    1

Seller Marketing - Campaign - See More By Index
    [Arguments]    ${index}=1
    Click Element    (//p[text()="see more"]/parent::button)[${index}]
    Wait Until Element Is Visible    (//p[text()="see more"]/parent::button)[${index}]/following-sibling::*//button
    Wait Until Element Is Visible    (//p[text()="see more"]/parent::button)[1]/following-sibling::*//div[contains(@id,"popover-body")]//img
    Sleep    1
    Click Element  (//p[text()="see more"]/parent::button)[${index}]/following-sibling::*//button
    Wait Until Element Is Not Visible    (//p[text()="see more"]/parent::button)[${index}]/following-sibling::*//button

Seller Marketing - Campaign - View Details By Index
    [Arguments]    ${index}=1
    Seller Marketing - Campaign - Select Actions By Index    View Details    ${index}
    Wait Until Element Is Visible    //header[text()="Promotion Details"]
    Click Element    //div[text()="Close"]/parent::button
    Wait Until Element Is Not Visible    //header[text()="Promotion Details"]

Seller Marketing - Campaign - Delete By Index
    [Arguments]    ${index}=1    ${sure}=${True}
    Seller Marketing - Campaign - Select Actions By Index    Delete    ${index}
    Wait Until Element Is Visible    //header[text()="Warning"]
    Page Should Contain Element    //p[text()="Are you sure you want to delete this activity?"]
    Sleep    1
    Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="CANCEL"]/parent::button
    IF    '${sure}'=='${True}'
        Click Element    //div[text()="CONTINUE"]/parent::button
        Sleep    1
    END
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]
    Sleep    1

Seller Marketing - Campaign - Terminated By Index
    [Arguments]    ${index}=1    ${sure}=${True}
    ${count}   Get Element Count    //p[text()="No Data!"]
    Skip If    ${count} == 1    There are no data can do test.
    Seller Marketing - Campaign - Select Actions By Index    Terminated    ${index}
    Wait Until Element Is Visible    //header[text()="Warning"]
    Page Should Contain Element    //p[text()="Are you sure you want to Pause this campaign?"]
    Sleep    1
    IF   '${sure}'=='${True}'
        Click Element    //div[text()="CONTINUE"]/parent::button
        Wait Until Element Is Visible    //*[contains(text(),"Stop")]
    ELSE
        Click Element    //div[text()="CANCEL"]/parent::button
    END
    Wait Until Element Is Visible    //*[@id="searchOrders"]/preceding-sibling::div//*[contains(@class,"icon-tabler-search")]
    Sleep    1

Seller Marketing - Campaign - Edit By Index
    [Arguments]    ${index}=1
    Seller Marketing - Campaign - Select Actions By Index    Edit    ${index}
    Wait Until Element Is Visible    //h2[text()="Promotion Details"]
    Sleep    1

Seller Marketing - Flow - Create&Update Promotion Info
    [Arguments]    ${pom_type}    ${buy_value}    ${get_value}    ${off_value}    ${publish}=${True}
    Seller Marketing - Input Promotion Name
    Seller Marketing - Set Start And End Time    ${Day_Range}[0]    ${Day_Range}[1]
    Seller Marketing - Add Sale Product To Promotion
    IF    ${pom_type}!=5
        Seller Marketing - Input Conditions Value    ${buy_value}
    END
    IF    ${pom_type}==3 or ${pom_type}==4
        Seller Marketing - Input Get Value    ${get_value}
    END
    IF    ${pom_type}!=4
        Seller Marketing - Input Off Value    ${off_value}
    END
    Seller Marketing - Check For Example Text By Promotion Type    ${pom_type}    ${buy_value}    ${get_value}    ${off_value}
        Seller Marketing - Create Promotion - Save And Continue
    IF    '${publish}'=='${True}'
        Seller Marketing - Promotion Review - Publish Campaign
    ELSE
        Seller Marketing - Promotion Review - Save As Draft
    END
