*** Settings ***
Documentation     Common Method For Cart Checkout Flow
Library           OperatingSystem
Library          ../../TestData/Checkout/GuestGenerateAddress.py
Resource          ../../TestData/Checkout/config.robot

*** Keywords ***
Add Browser Cookies
    [Arguments]   ${ENV}
    Delete All Cookies
    Add Cookie   tracker_device   eaefaf1b-d3a5-4b69-9cb5-4dff1a362030
    IF  '${ENV}' == 'qa'
        Add Cookie   spid.7997        1a20fc83-51c0-448f-bda9-350d639fc69b.1635386728.64.1644202154.1643279208.dea01cea-05be-4465-b0af-72a31a788ab4    /   .michaels.com    ${True}
        Add Cookie   _sp_id.0f37      a5cdbd48-541f-44a8-8363-a33a8bf45f0a.1639361011.25.1644202131.1643019061.a67a7955-34b3-4a8e-ad6f-a292376ad6fb    /   mik.qa.platform.michaels.com   ${True}
    ELSE IF  '${ENV}' == 'stg'
        Add Cookie   spid.7997        1a20fc83-51c0-448f-bda9-350d639fc69b.1635386728.65.1644204705.1644202432.c2ea826e-12b0-44d0-97c4-7c0cac319ae7    /   .michaels.com    ${True}
        Add Cookie   _sp_id.0c26      8dd43a33-a890-4d4b-9c6f-e05759b1788d.1636714392.37.1644202341.1642514383.cc43f94e-b2d2-43f1-901e-b4373107911e    /   mik.stg.platform.michaels.com   ${True}
    ELSE IF  '${ENV}' == 'tst'
        Add Cookie   spid.7997        1a20fc83-51c0-448f-bda9-350d639fc69b.1635386728.84.1645610356.1645535978.21f39d62-e7bf-4b3b-82a1-155b3bfe355f    /   .michaels.com    ${True}
        Add Cookie   _sp_id.d3bd      556c8557-c394-49ab-a9e4-85f521846858.1635386728.12.1645610355.1645423706.49bb8a40-831f-4c79-b35d-f3148c6143ae    /   mik.tst.platform.michaels.com   ${True}
    END

Finalization Processment
    Delete All Cookies
    Close All Browsers

Select Or Change a Store In the Homepage
    [Arguments]    ${Store}   ${Method}
    ${Selected Name}   Set Variable
    IF  '${Method}' == 'SELECT'
        Wait Until Element Is Visible    //p[text()='Select a Store']         ${Long Waiting Time}
        ${Select Store Element}          Set Variable   //p[text()='Select a Store']
        Sleep  2
        Click Element                    //p[text()='Select a Store']
        ${Store Address}    Select Change Store Common Process   ${Store}
    ELSE IF  '${Method}' == 'CHANGE'
        Wait Until Page Contains Element     (//p[text()="My Store:"])[1]
        Wait Until Element Is Visible        (//p[text()="My Store:"])[1]
        Mouse Over                           (//p[text()="My Store:"])[1]
        Wait Until Page Contains Element     //p[text()="FIND OTHER STORES"]/..
        Wait Until Element Is Visible        //p[text()="FIND OTHER STORES"]/..
        Click Element                        //p[text()="FIND OTHER STORES"]/..

        ${Store Address}     Select Change Store Common Process   ${Store}
        ${Selected Name}     Run Keyword And Ignore Error    Wait Until Element Is Visible    //div[contains(text(), "you have already selected")]   3
        IF  '${Selected Name}[0]' == 'FAIL'
            Click Element                 //p[text()='${Store}']/preceding-sibling::div/child::label
            ${Store Address}   Get Text   //p[text()='${Store}']/parent::div/parent::div/following-sibling::div
            Click Element                 //div[contains(text(),"CHANGE MY STORE")]/..
        END
    END

    [Return]    ${Store Address}

Add Products To Cart Process
    [Arguments]   ${product_channel_info}    ${qty_process}    ${store_amount}
    ${PDP Shipping}      Create List
    ${Class Set Qty}     Create List
    ${Store Address}     Create List
    ${Cart Text Color}   Set Variable   Awaits Setting
    FOR    ${product}    ${channel}    IN ZIP    ${product_channel_info.keys()}    ${product_channel_info.values()}
        Go To    ${Home URL}/${product}
        ${MIK Check}          Mik Channel Check     ${channel}
        ${ClassOrNot}         If Class              ${product}
        ${MIK Mode Result}    Mik Ship Major Mode   ${channel}
#        ${Before Count}       Sliding Right Panel Verification Qty   ${ClassOrNot}
        IF   '${channel}' == 'MKP' or '${channel}' == 'MKPS'
            Sleep  5
        END
        IF   '${ClassOrNot}' == 'Class'
            ${Class Qty}   Set Variable    ${qty_process.pop()}
            Wait Until Element Is Enabled             (//p[text()="Add Class to Cart"])[2]
            Sleep  2
            ${Class Add to Cart}    Get Webelement    (//p[text()="Add Class to Cart"])[2]
            Inputing the Product or Class Quantity    ${Class Qty}    ${ClassOrNot}
            ${Class Set Qty}=  Evaluate   ${Class Set Qty} + [${Class Qty}]
            Sleep  2
#            ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
            AD Exception Handle     ${Class Add to Cart}
            Sliding Right Panel Have Correct Buttons and QTY      ${Class Qty}  ${MIK Check}
        ELSE
            IF  '${channel}' == 'SDD' or '${channel}' == 'SDDH'
                Wait Until Element Is Enabled    //p[contains(text(),'Ship to Me')]       ${Long Waiting Time}
                Sleep    2
                ${SDD}    Get Webelements        //p[@class='css-1tyd7ay']
                Wait Until Element Is Enabled    ${SDD[2]}
                ${Ship Text}     Get Text        ${SDD[2]}
                ${Ship List}     Create List     ${Ship Text}
                ${PDP Shipping}  Evaluate        ${PDP Shipping} + ${Ship List}
                AD Exception Handle    ${SDD[2]}
                ${SDD Qty}       Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${SDD Qty}
                Wait Until Element Is Visible    //*[contains(text(),'ADD TO CART')]     ${Mid Waiting Time}

#                ${After Count}     Sliding Right Panel Verification Qty   ${ClassOrNot}
                AD Exception Handle   //*[contains(text(),'ADD TO CART')]
                Sliding Right Panel Have Correct Buttons And QTY      ${SDD Qty}   ${MIK Check}
            ELSE IF  '${channel}' == 'PISM'
                Wait Until Element Is Enabled       //p[contains(text(),'Ship to Me')]      ${Mid Waiting Time}
                ${Store Address}   ${Total Items}   Pick Up In Store One Product With Different Stores    ${store_amount}    ${qty_process.pop()}     200
                ${PISM_Shipping}   PISM List    Pick-up - Free    ${store_amount}
                ${PDP Shipping}    Evaluate     ${PDP Shipping} + ${PISM_Shipping}
#                ${After Count}     Sliding Right Panel Verification Qty   ${ClassOrNot}
                Sliding Right Panel Have Correct Buttons And QTY      ${Total Items}   ${MIK Check}
            ELSE

                ${PDP Handle}      Run Keyword And Warn On Failure     Wait Until Element Is Enabled       //p[contains(text(),'${MIK Mode Result}')]      ${Long Waiting Time}
                IF   '${PDP Handle}[0]' == 'FAIL'
                    Reload Page
                END
                ${Ship Text}       Get Text         //p[contains(text(),'${MIK Mode Result}')]
                ${Ship List}       Create List      ${Ship Text}
                ${PDP Shipping}    Evaluate         ${PDP Shipping} + ${Ship List}
                AD Exception Handle    //p[contains(text(),'${MIK Mode Result}')]
                ${Qty Required}    Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${Qty Required}
                Sleep  1
                Wait Until Element Is Visible      //*[contains(text(),'ADD TO CART')]    ${Mid Waiting Time}
#                ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
                AD Exception Handle    //*[contains(text(),'ADD TO CART')]
                Sliding Right Panel Have Correct Buttons And QTY     ${Qty Required}   ${MIK Check}
            END
        END
        Wait Until Element Is Visible    //div[text()='View My Cart']    ${Long Waiting Time}

    END
    [Return]    ${PDP Shipping}    ${Class Set Qty}    ${Store Address}

Verify Calculation On The Order Summary Panel and Subtals Comparison
    [Arguments]    ${Order Summary Panel In}
    Wait Until Element Is Visible    //p[text()="Total:"]
    Wait Until Element Is Visible    //p[text()="Total:"]/following-sibling::h4
    ${Order Summary List}   Get Webelements    //h3[text()="Order Summary"]/following-sibling::div/child::p/following-sibling::p
    ${Except Subtotals}      Create List        Other Fees    Savings    Estimated Shipping
    FOR    ${Other Fee}   IN    @{Except Subtotals}
        ${Element}   Get Webelements    //p[text()="${Other Fee}"]
        ${Order Summary List}    Order Summary Panel Additional Consideration   ${Element}   ${Other Fee}   ${Order Summary List}
    END

#    ${Cart Fees Info}       Get Webelements    //p[text()="Other Fees"]
#    ${Savings Info}         Get Webelements    //p[text()="Savings"]
#    ${Estimate Shipping}    Get Webelements    //p[text()="Estimated Shipping"]
#
#    ${Order Summary List}    Order Summary Panel Additional Consideration     ${Cart Fees Info}      Other Fees            ${Order Summary List}
#    ${Order Summary List}    Order Summary Panel Additional Consideration     ${Savings Info}        Savings               ${Order Summary List}
#    ${Order Summary List}    Order Summary Panel Additional Consideration     ${Estimate Shipping}   Estimated Shipping    ${Order Summary List}
    ${Total Calculated}   ${Order Subtotal}   Order Summary Page Process      ${Order Summary List}

    ${Total Display}     Get Text        //p[text()='Total:']/following-sibling::h4
    ${Total Number}      Set Variable    ${Total Display[1:]}
    IF  '${Order Summary Panel In}' == 'CART'
#        Run Keyword And Warn On Failure    String Comparison     ${Cart Subtotals}      ${Order Subtotal}
        Run Keyword And Warn On Failure    String Comparison     ${Total Calculated}    ${Total Number}
    ELSE
        Run Keyword And Warn On Failure    String Comparison     ${Total Calculated}    ${Total Number}
    END
    [Return]   ${Total Number}

Inputing the Product or Class Quantity
    [Arguments]   ${qty}    ${Class}=Not
    IF  '${qty}' > '1'
        IF  '${Class}' == 'Class'
            Wait Until Element Is Enabled   (${Class Plus Mark})[2]
            FOR  ${i}  IN RANGE   ${${qty} - 1}
                AD Exception Handle    (${Class Plus Mark})[2]
            END
        ELSE
            Wait Until Element Is Enabled   ${Plus Mark}
            FOR  ${i}  IN RANGE   ${${qty} - 1}
                AD Exception Handle    ${Plus Mark}
            END
        END
    END

Pick Up In Store One Product With Different Stores
    [Arguments]   ${Required Store Amount}   ${qty}   ${Store Range}
    ${Total Items}   Set Variable   0
    ${Total Items}=  Evaluate   ${Required Store Amount} * ${qty}
    ${Multiple Store Address}    Create List
    ${Available Store}   Set Variable   0
    Wait Until Element Is Visible    //span[text()='Available Nearby']     ${Long Waiting Time}
    AD Exception Handle    //span[text()='Available Nearby']
    ${SelectStoreHandle}   Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[contains(text(), "Stores in your Range")]     10
    IF  '${SelectStoreHandle}[0]' == 'FAIL'
        Run Keyword And Ignore Error    Wait Until Element Is Visible    //p[contains(text(), "Stores in your range")]     5
    END
    Sleep   2

    FOR    ${i}    IN RANGE    20    #${store_amount}
        ${Stock Row}   Set Variable    (//span[contains(text(), "in Stock")])[${i + 1}]
        ${Stock}       Get Text        ${Stock Row}
        ${Stock Adequate}  Store Panel Stock Handle    ${Stock}  ${qty}
        Continue For Loop If     ${Stock Adequate} == ${False}
        Sleep  1
        Execute Javascript       window.scrollBy(0,140)         #querySelectorAll('tr')[${i + 1}].scrollIntoView({behavior: 'smooth', block: 'center'})

        FOR    ${j}   IN RANGE   ${qty}
            AD Exception Handle   ((${Stock Row}/parent::div/preceding-sibling::div)[1]/child::div/child::div/child::div)[2]
        END

        ${Store Name}         Get Text    (//span[text()="Store Hours"]/parent::div/preceding-sibling::div)[${i + 1}]       #(//table/tr[${i + 1}]/td[5]/child::div/child::div/child::p)[1]
        ${Current Address}    Get Text    (//span[text()="Store Hours"]/parent::div/following-sibling::p)[${i + 1}]         #//table/tr[${i + 1}]/td[5]/child::div/child::p
        ${Available Store}=   Evaluate    ${Available Store} + 1
        ${Current Address}    Convert Store Address To Regular Space    ${Current Address}

        ${Multiple Store Address}=    Evaluate    ${Multiple Store Address} + ['${Store Name}'] + ['${Current Address}']
        ${Exit Loop Condition}=       Evaluate    ${Required Store Amount} == ${Available Store}
        Exit For Loop If     ${Exit Loop Condition}
    END
    Sleep   1
    Run Keyword And Warn On Failure    Check Items and Locations In Store Locator   ${Total Items}   ${Required Store Amount}
    ${AddCartButtons}    Get Webelements     //div[text()='ADD TO CART']
    AD Exception Handle   ${AddCartButtons[1]}

    [Return]   ${Multiple Store Address}   ${Total Items}

Check Items and Locations In Store Locator
    [Arguments]    ${Total Items}    ${Required Store Amount}
    Wait Until Element Is Visible         //*[text()='${Total Items}' and text()='${Required Store Amount}']


String Comparison
    [Arguments]    ${Message Source One}   ${Message Source Two}
    Should Be Equal As Strings   ${Message Source One}    ${Message Source Two}

Edit Cart Items and Subtotal Items Comparison
    Wait Until Element Is Visible     //p[text()='Edit Cart']
    Wait Until Element Is Visible     //p[contains(text(), 'Subtotal')]

    ${Edit Cart Qty}    Get Text      //p[text()='Edit Cart']
    ${Subtotal Qty}     Get Text      //p[contains(text(), 'Subtotal')]

    ${Edit Cart Qty}    Number Extracted    ${Edit Cart Qty}
    ${Subtotal Qty}     Number Extracted    ${Subtotal Qty}

    Should Be Equal As Strings     ${Edit Cart Qty}   ${Subtotal Qty}

Sliding Right Panel Verification Qty
    [Arguments]    ${ClassOrNot}
    IF   '${ClassOrNot}' == 'Class'
        ${PDP Title}   Get Text   //h2
    ELSE
        ${PDP Title}   Get Text   //h1
    END
    ${Title Count}     Get Element Count   //*[text()="${PDP Title}"]
    [Return]    ${Title Count}

Sliding Right Panel Have Correct Buttons and QTY
    [Arguments]    ${Qty Input}   ${MIK Check}
    Wait Until Element Is Visible     //p[text()="Items added to cart!"]     ${Mid Waiting Time}
    Run Keyword And Warn On Failure   Page Should Contain Element    //p[text()="Items added to cart!"]
    Wait Until Element Is Visible     //*[text()="View My Cart"]/parent::button
    Page Should Contain Button        //*[text()="View My Cart"]/parent::button
    Run Keyword And Warn On Failure   Page Should Contain Button     //*[text()="Continue Shopping"]/parent::button

    ${View My Cart}        Set Variable    //*[text()="View My Cart"]/parent::button
    ${Continue Shopping}   Set Variable    //*[text()="Continue Shopping"]/parent::button
#
#    ${View My Cart Color}        Execute Javascript   return document.evaluate("${View My Cart}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue['background-color']
#    ${Continue Shopping Color}   Execute Javascript   return document.evaluate("${Continue Shopping}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue['background-color']
    IF  '${MIK Check}' == 'MICHAELS'
        Page Should Contain Element       (//p[text()= "Michaels"])[2]
    ELSE

        Page Should Not Contain Element   (//p[text()= "Michaels"])[2]
    END
    ${Qty On Sliding}   Get Text   //p[text()="QTY: "]
    ${Qty}   Set Variable    ${Qty On Sliding[5:]}
    Run Keyword And Warn On Failure   Should Be Equal As Strings    ${Qty}   ${Qty Input}


Environ Browser Selection And Setting
    [Arguments]   ${ENV}   ${BROWSER}   ${URL}=${Home URL}
    IF   "${BROWSER}" == "Chrome"
        Open Browser    ${URL}    ${BROWSER}
    ELSE IF  "${BROWSER}" == "Firefox"
        ${Firefox Profile}   Create Profile
        ${Cap Profile}       Desired Capabilities Setting
        Open Browser    ${URL}    ${BROWSER}    desired_capabilities=${Cap Profile}   ff_profile_dir=${Firefox Profile}
    END
    Add Browser Cookies       ${ENV}
    Maximize Browser Window

Select Change Store Common Process
    [Arguments]    ${Store}
    Wait Until Element Is Visible    //p[text()='SELECT OTHER STORE']     ${Long Waiting Time}
    Input Text                       //input[@placeholder='Enter city, state, zip']     ${Store}
    Wait Until Element Is Enabled    //select
    Select From List By Value        //select      200
    Wait Until Element Is Visible    //p[text()='${Store}']               ${Long Waiting Time}
    Wait Until Element Is Visible    (//p[text()='MY STORE']/following-sibling::div/child::div/following-sibling::div)[1]
    ${Store Address}    Get Text     (//p[text()='MY STORE']/following-sibling::div/child::div/following-sibling::div)[1]
    [Return]    ${Store Address}


AD Exception Handle
    [Arguments]    ${Triggering Element}
    ${Pop Handle}   Run Keyword And Ignore Error     Click Element     ${Triggering Element}
    IF  '${Pop Handle}[0]' == 'FAIL'
        Advertisement Processment Handle   ${Triggering Element}
    END

AD Exception Handle-element visible
    [Arguments]    ${Triggering Element}
    ${Pop Handle}   Run Keyword And Ignore Error     Wait Until Element Is Visible     ${Triggering Element}
    IF  '${Pop Handle}[0]' == 'FAIL'
        Advertisement Processment Handle   ${Triggering Element}  flase
    END


Advertisement Processment Handle
    [Arguments]    ${Button}   ${click_true}=true
    ${Selected}    Run Keyword And Ignore Error     Select Frame        id:attentive_creative
    IF   '${Selected}[0]' == 'PASS'
        ${Crorss Icon}   Run Keyword And Ignore Error   Wait Until Element Is Visible     //button[@id='closeIconContainer']
        Run Keyword And Ignore Error   Wait Until Element Is Visible    //button[@id='closeIconContainer']
        Run Keyword And Ignore Error   Click Element                    //button[@id='closeIconContainer']
        Unselect Frame
        Sleep  1
        Wait Until Element Is Enabled      ${Button}
        Sleep  1
        Click Element                      ${Button}
    ELSE
        Sleep  1
        Wait Until Element Is Enabled      ${Button}   15
        Sleep  1
        IF  "${click_true}"=="true"
            Click Element                      ${Button}
        END
    END


Order Summary Panel Additional Consideration
    [Arguments]    ${Elements}   ${Consider Info}   ${Order Summary List}
    ${Consider Check}   Set Variable
    ${Info Existed}     Extract Cart Fee And Check Str    ${Elements}    ${Consider Info}
    IF   ${Info Existed} == ${True}
        ${Consider Check}    Run Keyword And Warn On Failure   Page Should Contain Element    //p[text()="${Consider Info}"]
        IF  '${Consider Check}[0]' == 'PASS'
           ${Consider Fees}       Run Keyword And Warn On Failure     Get Webelement      //p[text()="${Consider Info}"]/following-sibling::p
           ${Order Summary List}   Append Element To List   ${Order Summary List}   ${Consider Fees}[1]
        END
    END
    [Return]    ${Order Summary List}


Select Store If Needed
    [Arguments]    ${Initial Store Name}
    ${Select Or Change}     Run Keyword And Ignore Error    Wait Until Element Is Visible    (//p[text()="My Store:"])[1]    20
    IF  '${Select Or Change}[0]' == 'PASS'
        ${Store Address}    Select Or Change A Store In The Homepage   ${Initial Store Name}    CHANGE
    ELSE
        ${Store Address}    Select Or Change A Store In The Homepage   ${Initial Store Name}    SELECT
    END
    [Return]   ${Store Address}



Add Products To Cart Process - Guest Continue As Guest
    [Arguments]   ${product_channel_info}    ${qty_process}    ${store_amount}
    ${PDP Shipping}      Create List
    ${Class Set Qty}     Create List
    ${Store Address}     Create List
    ${Cart Text Color}   Set Variable   Awaits Setting
    FOR    ${product}    ${channel}    IN ZIP    ${product_channel_info.keys()}    ${product_channel_info.values()}
        Go To    ${Home URL}/${product}
        ${MIK Check}          Mik Channel Check     ${channel}
        ${ClassOrNot}         If Class              ${product}
        ${MIK Mode Result}    Mik Ship Major Mode   ${channel}
#        ${Before Count}       Sliding Right Panel Verification Qty   ${ClassOrNot}
        IF   '${channel}' == 'MKP' or '${channel}' == 'MKPS'
            Sleep  5
        END
        IF   '${ClassOrNot}' == 'Class'
            ${Class Qty}   Set Variable    ${qty_process.pop()}
            Wait Until Element Is Enabled             (//p[text()="Book Class Only"])[2]
            Sleep  2
            ${Class Add to Cart}    Get Webelement    (//p[text()="Book Class Only"])[2]
            Inputing the Product or Class Quantity    ${Class Qty}    ${ClassOrNot}
            ${Class Set Qty}=  Evaluate   ${Class Set Qty} + [${Class Qty}]
            Sleep  2
#            ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
            AD Exception Handle     ${Class Add to Cart}
        ELSE
            IF  '${channel}' == 'SDD' or '${channel}' == 'SDDH'
                Wait Until Element Is Enabled    //p[contains(text(),'Ship to Me')]       ${Long Waiting Time}
                Sleep    2
                ${SDD}    Get Webelements        //p[@class='css-1tyd7ay']
                Wait Until Element Is Enabled    ${SDD[2]}
                ${Ship Text}     Get Text        ${SDD[2]}
                ${Ship List}     Create List     ${Ship Text}
                ${PDP Shipping}  Evaluate        ${PDP Shipping} + ${Ship List}
                AD Exception Handle    ${SDD[2]}
                ${SDD Qty}       Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${SDD Qty}
                Wait Until Element Is Visible    //*[contains(text(),'BUY NOW')]     ${Mid Waiting Time}
#                ${After Count}     Sliding Right Panel Verification Qty   ${ClassOrNot}
                AD Exception Handle   //*[contains(text(),'BUY NOW')]
            ELSE
                ${PDP Handle}      Run Keyword And Warn On Failure     Wait Until Element Is Enabled       //p[contains(text(),'${MIK Mode Result}')]      ${Long Waiting Time}
                IF   '${PDP Handle}[0]' == 'FAIL'
                    Reload Page
                END
                ${Ship Text}       Get Text         //p[contains(text(),'${MIK Mode Result}')]
                ${Ship List}       Create List      ${Ship Text}
                ${PDP Shipping}    Evaluate         ${PDP Shipping} + ${Ship List}
                AD Exception Handle    //p[contains(text(),'${MIK Mode Result}')]
                ${Qty Required}    Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${Qty Required}
                Sleep  1
                Wait Until Element Is Visible      //*[contains(text(),'BUY NOW')]    ${Mid Waiting Time}
#                ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
                AD Exception Handle    //*[contains(text(),'BUY NOW')]
            END
        END
    END
    [Return]    ${PDP Shipping}    ${Class Set Qty}    ${Store Address}