*** Settings ***
Library        ../../Libraries/MIK/MikCommonKeywords.py
Library        ../../Libraries/MIK/MikFileLib.py
Resource       ../../Keywords/Common/CommonKeywords.robot

*** Keywords ***
Click On The Element And Wait
    [Arguments]   ${element}
    Wait Until Page Contains Element    ${element}  30
    Click Element   ${element}

Mouse Over And Wait
    [Arguments]   ${element}
    Wait Until Page Contains Element    ${element}  30
    Mouse Over  ${element}

Input Text And Wait
    [Arguments]   ${element}  ${text}
    Wait Until Page Contains Element    ${element}  30
    Clear Element Value  ${element}
    Clear Element Text   ${element}
    Input Text  ${element}  ${text}

Scroll Element And Wait And Click
    [Arguments]   ${element}
    Wait Until Page Contains Element    ${element}  30
    Scroll Element Into View  ${element}
    Click On The Element And Wait  ${element}

Get Text And Wait
    [Arguments]   ${element}
    Wait Until Page Contains Element    ${element}  30
    ${text}  Get Text  ${element}
    Return From Keyword  ${text}

Mouse Click And Wait
    [Arguments]   ${element}
    Wait Until Page Contains Element    ${element}  30
    Mouse Down  ${element}
    Mouse Up    ${element}

For Dict And Input Text
    [Arguments]  ${info_dict}
    FOR  ${key}  ${value}  IN  &{info_dict}
        Wait Until Page Contains Element  //input[@id="${key}"]
        Input Text And Wait  //input[@id="${key}"]  ${value}
    END

Sign in
    [Arguments]   ${email}  ${password}  ${Cur_User_Name}=summer
    Input Text And Wait  //input[@id="email"]  ${email}
    Input Text And Wait  //input[@id="password"]  ${password}
    Click On The Element And Wait  //div[text()='SIGN IN']/parent::button
    Wait Until Page Contains Element  //p[text()='${Cur_User_Name}']  60

Search Project
    [Arguments]  ${search_result}
    Run Keyword And Ignore Error  Wait Until Page Contains     MacArthur Park   60
    Input Text And Wait  //input[@aria-label="Search Input"]  ${search_result}
    Click On The Element And Wait  //button[@aria-label="Search Button"]
    Sleep  5

Get Text To List
    [Arguments]  ${elements}
    ${temp_list}  Create List
    ${elements_text}  Get Webelements  ${elements}
    ${count}  Get Length  ${elements_text}
    IF  ${count}>0
        FOR  ${v}  IN  @{elements_text}
            ${text}  Get Text And Wait  ${v}
            Append To List  ${temp_list}  ${text}
        END
    END
    Return From Keyword  ${temp_list}

Get PLP Product Info
    Wait Until Page Contains Element  //p[text()='Sort By']/../../../following-sibling::div[@style]//p[@title]
    Scroll Element Into View          //div[contains(@id,'page-')]
    ${product_count}  Get Element Count  //p[text()='Sort By']/../../../following-sibling::div[@style]//p[@title]
    ${product_list}  Create List
    FOR  ${i}  IN RANGE  1  ${product_count}+1
        Sleep  3
        Scroll Element Into View  (//p[@title])[${i}]
        ${title}  Get Text And Wait  (//p[@title])[${i}]
        ${result}   ${reviews_num}  Run Keyword And Ignore Error  Get Text And Extraction Data  (//p[@title])[${i}]/../following-sibling::div[1]//p  1  -1
        IF  '${result}'=='FAIL'
            ${reviews_num}  Set Variable  0
        END
        ${price_list}  Get Text To List  (//p[@title])[${i}]/../following-sibling::div[2]//p[1]
        ${transportation}  Get Text To List  (//p[@title])[${i}]/../../following-sibling::div//p
        ${product_info}  get_product_create_dict  ${title}  ${reviews_num}  ${price_list}  ${transportation}
        Append To List  ${product_list}  ${product_info}
    END
    Return From Keyword  ${product_list}

Judge Search Results
    Sleep  1
    ${seach_count}  Get Element Count  //p[text()='Try a different search term or check out some of our suggestions below.']
    ${cart_count}   Get Element Count  //div[text()='ADD TO CART']
    ${List_count}   Get Element Count  //div[text()='ADD TO LIST']
    ${Shop_Now}  Get Element Count  //div[text()='Shop Now']/parent::a
    IF  ${seach_count}>0
        Log  Search results are empty
        Return From Keyword  False
    ELSE IF  ${cart_count}>0 or ${List_count}>0
        Return From Keyword  Cart
    ELSE IF  ${Shop_Now}>0
        Click On The Element And Wait  //div[text()='Shop Now']/parent::a
        Wait Until Page Contains Element  //p[@title]
    END
    Return From Keyword  True

Verify PLP Page Num
    [Arguments]  ${seach_result_num}
    ${page_num_element}  Get Webelements  //div[contains(@id,'page-')]
    ${page_num}  Get Length  ${page_num_element}
    IF  ${page_num}>1
        Scroll Element and wait and click  (//div[contains(@id,'page-')])[${page_num}]
        Sleep  5
        ${page_id_text}  Get Element Attribute  (//div[contains(@id,'page-')])[${page_num}]  id
        ${page_id_num}  Evaluate  ${page_id_text}[5:]
        ${product_info}  Get PLP Product Info
        ${pege_end_item}  Get Length   ${product_info}
        ${seach_resp_num}  Evaluate  24*(${page_id_num}-1)+${pege_end_item}
        Scroll Element and wait and click  //div[@id='page-1']
        Wait Until Element Is Visible  //p[@title]
    ELSE
        ${product_info}  Get PLP Product Info
        ${seach_resp_num}  Get Length   ${product_info}
    END
    Should Be Equal As Numbers  ${seach_result_num}  ${seach_resp_num}

Verify PLP
    [Arguments]  ${search_result}  ${stay_PLP}=True
    FOR  ${i}  IN   ${search_result}  summer  test  123
        ${PLP_PDP}  Judge search results
        ${text}  Set Variable  ${i}
        IF  '${PLP_PDP}'=='False'
            Search Project  ${text}
        ELSE
            Exit for loop
        END
    END
    IF  '${PLP_PDP}'=='True'
        Verify PLP And Cart  ${text}  ${stay_PLP}
    END

Verify PLP And Cart
    [Arguments]  ${seach_text}  ${stay_PLP}=True
    ${result}  Run Keyword And Ignore Error   Wait Until Page Contains Element  //p[text()='We found']  3
    IF  '${result[0]}'=='PASS'
        Wait Until Element Is Visible   //p[text()='We found']/span
        ${title_text}  Get Webelements  //p[text()='We found']/span
        ${seach_result_num_text}  Get Text And Wait  ${title_text}[0]
        ${seach_result_num}  split_str_get_num   ${seach_result_num_text}
        ${seach_result_text}  Get Text And Wait  ${title_text}[-1]
        Should Be Equal As Strings  ${seach_result_text}  "${seach_text}"
        ${title_text}  Get Webelements  //p[text()='We found']/span
        ${seach_result_num_text}  Get Text And Wait  ${title_text}[0]
        ${seach_result_num}  split_str_get_num   ${seach_result_num_text}
    ELSE
        Wait Until Element Is Visible  //p[contains(text(), 'Result')]/parent::p
        ${seach_result_text}  Get Text And Wait  //p[contains(text(), 'Result')]/parent::p
        ${seach_result_num_text}  Get Text And Wait  //p[contains(text(), 'Result')]/span
        ${seach_result_num}  split_str_get_num   ${seach_result_num_text}
        Should Contain  ${seach_result_text}  ${seach_text}[1:]
        ${seach_result_num}  Get Text And Extraction Data  //p[contains(text(), 'Result')]/span
    END
    Verify PLP Page Num  ${seach_result_num}
    IF  "${stay_PLP}"=="True"
        Go to Merchandise details page
    END

Go To Merchandise Details Page
    ${product_info}  Get PLP Product Info
    ${product_len}  Get Length  ${product_info}
    ${num}  Evaluate  random.randint(1,${product_len})  random
    ${item_title_text}  Get Text And Wait  (//p[@title])[${num}]
    Scroll Element and wait and click  (//p[@title])[${num}]
    Wait Until Element Is Visible  //h1  300
    ${item_title_text_h1}  Get Text And Wait  //h1
    Should Be Equal As Strings  ${item_title_text}  ${item_title_text_h1}

Count The Number Of Reviews On The Product Details Page
    ${Reviews}  Set Variable  //*[text()='Reviews']/following-sibling::div//div/p[2]
    Wait Until Element Is Visible  ${Reviews}  60
    Scroll Element Into View  ${Reviews}
    ${Reviews_num}  Set Variable  0
    FOR  ${i}  IN RANGE   1   6
        ${num}  Get Text And Wait  (${Reviews})[${i}]
        ${Reviews_num}  Evaluate  ${Reviews_num}+${num}
    END
    Return From Keyword  ${Reviews_num}

Verify Product Detail Page Reviews Number
    [Arguments]  ${Reviews_num}=${null}
    ${result}  ${item_Reviews}  Run Keyword And Ignore Error  Get Text And Wait   //p[contains(text(),'Item')]/following-sibling::div/p
    IF  '${result}'=='FAIL'
        ${item_Reviews}  Evaluate  0
    END
    ${item_Reviews_num}  get_pdp_reviews  ${item_Reviews}
    ${Count_Reviews_num}  Count The Number Of Reviews On The Product Details Page
    IF  ${Reviews_num}==${null}
        Should Be Equal As these data  ${item_Reviews_num}  ${Count_Reviews_num}
    ELSE
        Should Be Equal As these data  ${Reviews_num}  ${item_Reviews_num}  ${Count_Reviews_num}
    END

Add Reviews
    [Arguments]  ${rating_num}  ${title_text}  ${reviews_text}  ${file}=${null}
    ${Count_Reviews_num}  Count The Number Of Reviews On The Product Details Page
    IF  ${Count_Reviews_num}==0
        Click On The Element And Wait  //div[text()='WRITE THE FIRST REVIEW']/parent::button
    ELSE
        Click On The Element And Wait  //div[text()=' WRITE A REVIEW']/parent::button
    END
    Click On The Element And Wait  (//p[text()='Your Rating']/following-sibling::div/*)[${rating_num}]
    Input Text And Wait  //label[text()='Review Headline']/following-sibling::div/input  ${title_text}
    Input Text And Wait  //label[text()='Review']/following-sibling::textarea  ${reviews_text}
    IF  ${file}
        Choose File  //div[text()='Select Files']/parent::button/preceding-sibling::input  ${file}
    END
    Click On The Element And Wait  //div[text()='SUBMIT REVIEW']/parent::button
    ${reviews_warn}  Get Element Count  //p[text()='You already submitted a review. Thanks!']
    IF  ${reviews_warn}>0
        Log  Add Reviews Pass
    ELSE
        Log  Add Reviews fail
    END

Verify Product is MIK or EA or FGM
    ${count}  Get Element Count  //p[contains(text(),'Item # ')]
    IF  ${count}==0
        Return From Keyword  FGM
    END
    ${item_id}  Get Text And Wait  //p[contains(text(),'Item')]
    ${item_id_length}  Get Length  ${item_id}
    IF  ${item_id_length}>20
        Return From Keyword  EA
    ELSE
        Return From Keyword  MIK
    END

Get Text And Extraction Data
    [Arguments]  ${element}  ${front_num}=0  ${queen_num}=${null}
    ${text}  Get Text And Wait  ${element}
    IF  ${queen_num}==${null}
        IF  ${front_num}==0
            ${data_text}  Set Variable  ${text}
        ELSE
            ${data_text}  Evaluate  ${text}[${front_num}:]
        END
    ELSE
        ${data_text}  Evaluate  ${text}[${front_num}:${queen_num}]
    END
    Return From Keyword  ${data_text}

Get Text And Extraction price
    [Arguments]  ${element}
    ${text}   Get Text And Wait  ${element}
    ${price}  splits_string_get_text  ${text}  $
    ${price}  Evaluate   round(${price}[-1], 2)
    Return From Keyword  ${price}

Should Be Equal As These Data
    [Arguments]  @{data_list}
    ${length}  Get Length  ${data_list}
    FOR  ${i}  IN RANGE  ${length}-1
        ${v}  Evaluate  ${i}+1
        Should Be Equal As Strings  ${data_list}[${i}]  ${data_list}[${v}]
    END

Go To personal information
    [Arguments]  ${button}    ${name}=summer
    Mouse Over  //p[text()='${name}']
    Click On The Element And Wait  //p[text()='${button}']

Choose File And Wait
    [Arguments]  ${element}
    Wait Until Element Is Enabled  ${element}
    ${photos_path}  get_mik_img_path
    Choose File  ${element}   ${photos_path}

Wait Loading End
    Run Keyword And Ignore Error  Wait Until Element Is Visible       //img[@src="https://static.platform.michaels.com/assets/header/images/loading-red-circle.svg"]  5
    Run Keyword And Ignore Error  Wait Until Element Is Not Visible  //img[@src="https://static.platform.michaels.com/assets/header/images/loading-red-circle.svg"]