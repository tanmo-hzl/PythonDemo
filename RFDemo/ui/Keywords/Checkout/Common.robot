*** Settings ***
Documentation     Common Method For Cart Checkout Flow
Library           SeleniumLibrary
Library           OperatingSystem
Library           ../../TestData/Checkout/GuestGenerateAddress.py
Library           ../../Libraries/CustomSeleniumKeywords.py    run_on_failure=Capture Screenshot and embed it into the report    implicit_wait=0.2 seconds
Resource          ../../TestData/Checkout/config.robot
Variables         ../../TestData/Checkout/productInfo.py

*** Variables ***
${Buy Now General}         //*[contains(text(),'BUY NOW')]
${Buy Now Exception}       //*[contains(text(),'Buy Now')]
${Add To Cart General}     (//*[contains(text(),'ADD TO CART')])[1]
${Add To Cart Exception}   (//*[contains(text(),'Add to Cart')])[1]
${Note One}    Note: Pickup person must bring the order number and their ID to pick up your order.
${Note Two}    We'll send an email to you and your additional pickup person once your order is ready.
@{Add Panel Text}    ${Note One}    ${Note Two}
${SDD Element}       (//div[contains(@aria-label, "Open samedaydelivery Details Modal")]/preceding-sibling::div)[2]
${Header Store}      (//p[text()="My Store:"])[1]/following-sibling::p
*** Keywords ***
Add Browser Cookies
    [Arguments]   ${ENV}
    Delete All Cookies
    Add Cookie   tracker_device   eaefaf1b-d3a5-4b69-9cb5-4dff1a362030


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
            Sleep  2
        END
    END

    [Return]    ${Store Address}

Add Products To Cart Process
    [Arguments]   ${product_channel_info}    ${qty_process}    ${store_amount}=1
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
        IF   '${ClassOrNot}' == 'Class'
            ${Class Qty}   Set Variable    ${qty_process.pop()}
            Wait Until Element Is Enabled             (//p[text()="Add Class to Cart"])[2]
            Sleep  2
            ${Class Add to Cart}    Get Webelement    (//p[text()="Add Class to Cart"])[2]
            Inputing the Product or Class Quantity    ${Class Qty}    ${ClassOrNot}
            ${Class Set Qty}=  Evaluate   ${Class Set Qty} + [${Class Qty}]
            Sleep  2
#            ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
            Click Element           ${Class Add to Cart}
            Click Again If No Reaction    ${Class Add to Cart}    Items added to cart!
            Sliding Right Panel Have Correct Buttons and QTY      ${Class Qty}  ${MIK Check}
        ELSE
            IF  '${channel}' == 'SDD' or '${channel}' == 'SDDH'
                Wait Until Element Is Visible      ${Header Store}    50
                ${Store In Header}    Get Text     ${Header Store}
                ${Store Address}      Channel Pre-Initialization    ${channel}    ${Store In Header}
                Wait Until Element Is Enabled    //*[contains(text(),'Ship to Me')]       ${Long Waiting Time}
                Sleep    2
                Wait Until Element Is Enabled    ${SDD Element}
                ${Ship Text}     Get Text        ${SDD Element}
                ${Ship List}     Create List     ${Ship Text}
                ${PDP Shipping}  Evaluate        ${PDP Shipping} + ${Ship List}
                Click Element    ${SDD Element}
                ${SDD Qty}       Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${SDD Qty}

#                ${After Count}     Sliding Right Panel Verification Qty   ${ClassOrNot}
                ${Click Exception}   Run Keyword And Warn On Failure   Click Element   ${Add To Cart General}
                IF  '${Click Exception}[0]' == 'FAIL'
                    Click Element   ${Add To Cart Exception}
                    Click Again If No Reaction    ${Add To Cart Exception}    Items added to cart!
                END
                Click Again If No Reaction    ${Add To Cart General}     Items added to cart!
                Sliding Right Panel Have Correct Buttons And QTY      ${SDD Qty}   ${MIK Check}
            ELSE IF  '${channel}' == 'PISM'
                Wait Until Element Is Enabled       //*[contains(text(),'Ship to Me')]      ${Mid Waiting Time}
                ${Store Address}   ${Total Items}   Pick Up In Store One Product With Different Stores    ${store_amount}    ${qty_process.pop()}     200
                ${PISM_Shipping}   PISM List    Pick-up - Free    ${store_amount}
                ${PDP Shipping}    Evaluate     ${PDP Shipping} + ${PISM_Shipping}
#                ${After Count}     Sliding Right Panel Verification Qty   ${ClassOrNot}
                Sliding Right Panel Have Correct Buttons And QTY      ${Total Items}   ${MIK Check}
            ELSE
                IF  '${channel}' == 'PIS'
                    Wait Until Element Is Visible      ${Header Store}    50
                    ${Store In Header}    Get Text     ${Header Store}
                    ${Store Address}      Channel Pre-Initialization    ${channel}    ${Store In Header}
                END
                ${PDP Handle}      Run Keyword And Warn On Failure     Wait Until Element Is Enabled       //*[contains(text(),'${MIK Mode Result}')]      ${Long Waiting Time}
                IF   '${PDP Handle}[0]' == 'FAIL'
                    Reload Page
                END
                ${Ship Text}       Get Text         //*[contains(text(),'${MIK Mode Result}')]
                ${Ship List}       Create List      ${Ship Text}
                ${PDP Shipping}    Evaluate         ${PDP Shipping} + ${Ship List}
                Click Element    //*[contains(text(),'${MIK Mode Result}')]
                ${Qty Required}    Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${Qty Required}
                Sleep  1

#                ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
                ${Click Exception}   Run Keyword And Warn On Failure   Click Element   ${Add To Cart General}
                IF  '${Click Exception}[0]' == 'FAIL'
                    Click Element   ${Add To Cart Exception}
                    Click Again If No Reaction    ${Add To Cart Exception}    Items added to cart!
                END
                Click Again If No Reaction   ${Add To Cart General}     Items added to cart!
                Sliding Right Panel Have Correct Buttons And QTY     ${Qty Required}   ${MIK Check}
            END
        END
        Wait Until Element Is Enabled    //div[text()='View My Cart']    ${Long Waiting Time}

    END
    [Return]    ${PDP Shipping}    ${Class Set Qty}    ${Store Address}

Verify Calculation On The Order Summary Panel and Subtals Comparison
    [Arguments]    ${Order Summary Panel In}
    Sleep    2
    Wait Until Page Contains Element      //*[text()="Total:"]/following-sibling::h4
    Wait Until Element Is Enabled         //*[text()="Total:"]/following-sibling::h4
    ${Order Summary List}   Get Webelements    //h3[text()="Order Summary"]/following-sibling::div/child::p/following-sibling::p
    ${Except Subtotals}      Create List        Other Fees    Savings    Estimated Shipping
    FOR    ${Other Fee}   IN    @{Except Subtotals}
        ${Element}   Get Webelements    //p[text()="${Other Fee}"]
        ${Order Summary List}    Order Summary Panel Additional Consideration   ${Element}   ${Other Fee}   ${Order Summary List}
    END

    ${Total Calculated}   ${Order Subtotal}   Order Summary Page Process      ${Order Summary List}

    ${Total Display}     Get Text        //*[text()='Total:']/following-sibling::h4
    ${Total Number}      Set Variable    ${Total Display[1:]}
    IF  '${Order Summary Panel In}' == 'CART'
#   Will
        Run Keyword And Warn On Failure    String Comparison     ${Total Calculated}    ${Total Number}
    ELSE
        Run Keyword And Warn On Failure    String Comparison     ${Total Calculated}    ${Total Number}
    END
    [Return]   ${Total Number}

Get All Relevant Number Before Placing Order
    ${Place Order Parameters}   Get Webelements    //h3[text()='Order Summary']/following-sibling::div
    ${orderSummaryDict}   Create Dictionary
    FOR   ${Each Param}  IN   @{Place Order Parameters}
        ${Parameter}           Get Text                        ${Each Param}
        ${Updated Parameter}   Get Stats From Order Summary    ${Parameter}
        Set To Dictionary	${orderSummaryDict}    ${Updated Parameter}[0]=${Updated Parameter}[1]
    END

    [Return]    ${orderSummaryDict}

Inputing the Product or Class Quantity
    [Arguments]   ${qty}    ${Class}=Not
    IF  '${qty}' > '1'
        IF  '${Class}' == 'Class'
            Wait Until Element Is Enabled   (${Class Plus Mark})[2]
            FOR  ${i}  IN RANGE   ${${qty} - 1}
                Click Element    (${Class Plus Mark})[2]
            END
        ELSE
            Wait Until Element Is Enabled   ${Plus Mark}
            FOR  ${i}  IN RANGE   ${${qty} - 1}
                Click Element    ${Plus Mark}
            END
        END
    END

Pick Up In Store One Product With Different Stores
    [Arguments]   ${Required Store Amount}   ${qty}   ${Store Range}
    ${Total Items}   Set Variable   0
    ${Total Items}=  Evaluate   ${Required Store Amount} * ${qty}
    ${Multiple Store Address}    Create List
    ${Available Store}   Set Variable   0
    ${COS Display}       Run Keyword And Warn On Failure     Wait Until Element Is Enabled    //span[text()='Check Other Stores']     ${Short Waiting Time}
    IF  '${COS Display}[0]' == 'PASS'
        Reload Page
    END
    ${Available Found}   Run Keyword And Warn On Failure     Wait Until Element Is Enabled    //span[text()='Available Nearby']      ${Short Waiting Time}
    IF  '${Available Found}[0]' == 'PASS'
        Click Element     //span[text()='Available Nearby']
    ELSE
        Click Element     //span[text()='Check Other Stores']
    END
    ${SelectStoreHandle}   Run Keyword And Ignore Error    Wait Until Element Is Enabled    //p[contains(text(), "Stores in your Range")]     ${Short Waiting Time}
    IF  '${SelectStoreHandle}[0]' == 'FAIL'
        Run Keyword And Ignore Error    Wait Until Element Is Enabled    //p[contains(text(), "Stores in your range")]     ${Short Waiting Time}
    END
    Sleep   2

    FOR    ${i}    IN RANGE    20    #${store_amount}
        ${Stock Row}   Set Variable    (//span[contains(text(), " Stock")])[${i + 3}]
        ${Stock}       Get Text        ${Stock Row}
        ${Stock Adequate}   Store Panel Stock Handle   ${Stock}   ${qty}
        Continue For Loop If     ${Stock Adequate} == ${False}
        Sleep  1
        Execute Javascript       window.scrollBy(0,140)         #querySelectorAll('tr')[${i + 1}].scrollIntoView({behavior: 'smooth', block: 'center'})

        FOR    ${j}   IN RANGE   ${qty}
            #Click Element   ((${Stock Row}/parent::div/preceding-sibling::div)[1]/child::div/child::div/child::div)[2]
            Click Element   (//div[@aria-label="button to increment counter for number stepper"])[${i + 3}]
        END

        ${Store Name}         Get Text    ${Stock Row}/parent::div/parent::div/following-sibling::div//span[text()="Store Hours"]/parent::div/preceding-sibling::div
        ${Current Address}    Get Text    ${Stock Row}/parent::div/parent::div/following-sibling::div//span[text()="Store Hours"]/parent::div/following-sibling::p
        ${Available Store}=   Evaluate    ${Available Store} + 1
        ${Current Address}    Convert Store Address To Regular Space    ${Current Address}

        ${Multiple Store Address}=    Evaluate    ${Multiple Store Address} + ['${Store Name}'] + ['${Current Address}']
        ${Exit Loop Condition}=       Evaluate    ${Required Store Amount} == ${Available Store}
        Exit For Loop If     ${Exit Loop Condition}
    END
    Sleep   1
    Run Keyword And Warn On Failure    Check Items and Locations In Store Locator   ${Total Items}   ${Required Store Amount}
    ${Similar Items}     Run Keyword And Ignore Error       Wait Until Element Is Enabled     //div[text()="Compare With Similar Items"]    4
    ${AddCartButtons}    Get Webelements     //div[text()='ADD TO CART']
    IF   '${Similar Items}[0]' == 'FAIL'
        Click Element   ${AddCartButtons[0]}
    ELSE
        Click Element   ${AddCartButtons[-1]}
    END

    [Return]   ${Multiple Store Address}   ${Total Items}

Check Items and Locations In Store Locator
    [Arguments]    ${Total Items}    ${Required Store Amount}
    Wait Until Element Is Enabled         //*[text()='${Total Items}' and text()='${Required Store Amount}']


String Comparison
    [Arguments]    ${Message Source One}   ${Message Source Two}
    Should Be Equal As Strings   ${Message Source One}    ${Message Source Two}

Edit Cart Items and Subtotal Items Comparison
    Wait Until Element Is Enabled     //p[text()='Edit Cart']
    Wait Until Element Is Enabled     //p[contains(text(), 'Subtotal')]

    ${Edit Cart Qty}    Get Text      //p[text()='Edit Cart']
    ${Subtotal Qty}     Get Text      //p[contains(text(), 'Subtotal')]

    ${Edit Cart Qty}    Number Extracted    ${Edit Cart Qty}
    ${Subtotal Qty}     Number Extracted    ${Subtotal Qty}

    ${Verify Res}       Web Element Number Verification    ${Edit Cart Qty}   ${Subtotal Qty}
    [Return]    ${Verify Res}

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
    Wait Until Element Is Enabled     //*[text()="Items added to cart!"]     ${Mid Waiting Time}
    Run Keyword And Warn On Failure   Page Should Contain Element    //*[text()="Items added to cart!"]
    Wait Until Element Is Enabled     //*[text()="View My Cart"]/parent::button
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
    Wait Until Element Is Enabled    //p[text()='SELECT OTHER STORE']     ${Long Waiting Time}
    Input Text                       //input[@placeholder='Enter city, state, zip']     DFW-EULESS
    Sleep  2
    Press Keys                       //input[@value="DFW-EULESS"]    \ue007
    Wait Until Element Is Enabled    //p[text()='${Store}']               ${Long Waiting Time}
    Wait Until Element Is Enabled    (//p[text()='MY STORE']/following-sibling::div/child::div/following-sibling::div)[1]
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

AD Exception Handle-element Enabled
    [Arguments]    ${Triggering Element}
    ${Pop Handle}   Run Keyword And Ignore Error     Wait Until Element Is Enabled     ${Triggering Element}
    IF  '${Pop Handle}[0]' == 'FAIL'
        Advertisement Processment Handle   ${Triggering Element}  flase
    END


Advertisement Processment Handle
    [Arguments]    ${Button}   ${click_true}=true
    Execute Javascript    document.querySelector("#attentive_creative").remove()
    Sleep  1
    Wait Until Element Is Enabled      ${Button}
    Click Element                      ${Button}



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
    ${Select Or Change}     Run Keyword And Ignore Error    Wait Until Element Is Enabled    (//p[text()="My Store:"])[1]    20
    IF  '${Select Or Change}[0]' == 'PASS'
        ${Store Address}    Select Or Change A Store In The Homepage   ${Initial Store Name}    CHANGE
    ELSE
        ${Store Address}    Select Or Change A Store In The Homepage   ${Initial Store Name}    SELECT
    END
    [Return]   ${Store Address}



Add Products To Cart Process - Guest Continue As Guest
    [Arguments]   ${product_channel_info}    ${qty_process}
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

        Sleep  3
        IF   '${ClassOrNot}' == 'Class'
            ${Class Qty}   Set Variable    ${qty_process.pop()}
            Wait Until Element Is Enabled             (//p[text()="Book Class Only"])[2]
            Sleep  2
            ${Class Add to Cart}    Get Webelement    (//p[text()="Book Class Only"])[2]
            Inputing the Product or Class Quantity    ${Class Qty}    ${ClassOrNot}
            ${Class Set Qty}=  Evaluate   ${Class Set Qty} + [${Class Qty}]
            Sleep  2
#            ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
            Click Element     ${Class Add to Cart}
        ELSE
            IF  '${channel}' == 'SDD' or '${channel}' == 'SDDH'
                Wait Until Element Is Visible      ${Header Store}   50
                ${Store In Header}    Get Text     ${Header Store}
                ${Store Address}      Channel Pre-Initialization    ${channel}    ${Store In Header}
                Wait Until Element Is Enabled    //*[contains(text(),'Ship to Me')]       ${Long Waiting Time}
                Sleep    2
                Wait Until Element Is Enabled    ${SDD Element}
                ${Ship Text}     Get Text        ${SDD Element}
                ${Ship List}     Create List     ${Ship Text}
                ${PDP Shipping}  Evaluate        ${PDP Shipping} + ${Ship List}
                Click Element    ${SDD Element}
                ${SDD Qty}       Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${SDD Qty}
#                ${After Count}     Sliding Right Panel Verification Qty   ${ClassOrNot}
                ${Buy Now Result}   Run Keyword And Warn On Failure   Click Element   ${Buy Now General}
                IF  '${Buy Now Result}[0]' == 'FAIL'
                    Click Element   ${Buy Now Exception}
                END
            ELSE
                IF  '${channel}' == 'PIS'
                    Wait Until Element Is Visible      ${Header Store}   50
                    ${Store In Header}    Get Text     ${Header Store}
                    ${Store Address}      Channel Pre-Initialization    ${channel}    ${Store In Header}
                END
                ${PDP Handle}      Run Keyword And Warn On Failure     Wait Until Element Is Enabled       //*[contains(text(),'${MIK Mode Result}')]      ${Long Waiting Time}
                IF   '${PDP Handle}[0]' == 'FAIL'
                    Reload Page
                END
                ${Ship Text}       Get Text         //*[contains(text(),'${MIK Mode Result}')]
                ${Ship List}       Create List      ${Ship Text}
                ${PDP Shipping}    Evaluate         ${PDP Shipping} + ${Ship List}
                Click Element    //*[contains(text(),'${MIK Mode Result}')]
                ${Qty Required}    Set Variable    ${qty_process.pop()}
                Inputing the Product or Class Quantity    ${Qty Required}
                Sleep  1
#                ${After Count}     Sliding Right Panel Verification Qty  ${ClassOrNot}
                ${Buy Now Result}   Run Keyword And Warn On Failure   Click Element   ${Buy Now General}
                IF  '${Buy Now Result}[0]' == 'FAIL'
                    Click Element   ${Buy Now Exception}
                END
            END
        END
    END
    [Return]    ${PDP Shipping}    ${Class Set Qty}    ${Store Address}

Check Web Element Number Existed
   [Arguments]    ${Element One}   ${Element Two}
   ${Res One}   Run Keyword And Warn On Failure   Should Not Be Equal As Strings   ${Element One}   0
   ${Res Two}   Run Keyword And Warn On Failure   Should Not Be Equal As Strings   ${Element Two}   0
   [Return]   ${Res One}   ${Res Two}


Web Element Number Verification
    [Arguments]    ${Element One}   ${Element Two}
    ${Element One Res}   ${Element Two Res}   Check Web Element Number Existed    ${Element One}   ${Element Two}
    IF  '${Element One Res}[0]' == 'PASS' and '${Element Two Res}[0]' == 'PASS'
        ${Element Verify Res}   Run Keyword And Warn On Failure    Should Be Equal As Strings   ${Element One}   ${Element Two}
    END
    [Return]   ${Element Verify Res}


Click Again If No Reaction
    [Arguments]    ${Button}     ${Verify Point}
    ${Panel Slidng}   Run Keyword And Warn On Failure    Wait Until Element Is Enabled     //*[text()="${Verify Point}"]     ${Mid Waiting Time}
    IF  '${Panel Slidng}[0]' == 'FAIL'
        Click Element      ${Button}
    END


login
    [Arguments]    ${user}    ${password}
    Environ Browser Selection And Setting    ${ENV}    ${BROWSER}    ${Home URL}/signin?returnUrl=/cart
    login without open browser    ${user}    ${password}

login without open browser
    [Arguments]     ${user}    ${password}
    Wait Until Element Is Visible    //p[text()="Remember me"]
    Wait Until Element Is Enabled    //input[@id="email"]
    click element    //input[@id="email"]
    Sleep  1
    Press Keys  //input[@id="email"]   ${user}
    Click Element    //input[@id="password"]
    Sleep  1
    Press Keys  //input[@id="password"]   ${password}
    Click Button   //div[text()="SIGN IN"]/parent::button
    Sleep    2
#    IF  "${is_sign}" == "true"
    Wait Until Page Contains Element    //p[text()="${account_info["first_name"]}"]     ${Long Waiting Time}
#    END


#initial env data
#    Set Selenium Timeout   ${Time Initial}
#    ${env_data}    read excel    BuyerData.xlsx    ${None}    ${ENV}
#    FOR   ${product_group}   IN   @{env_data}
#        ${value}   get_list_step_value    ${product_group}   1
#        Set Suite Variable    ${${product_group[0]}}    ${value}
#    END
Initial Custom Selenium Keywords
    Set Library Search Order    CustomSeleniumKeywords
    Set Selenium Timeout      ${Time Initial}

Initial Env Data2
    Set Library Search Order    CustomSeleniumKeywords
    Set Selenium Timeout      ${Time Initial}
    ${test_data}    Set Variable    ${test_data}[${ENV}]
    ${keys}    Get Dictionary Keys     ${test_data}
    FOR    ${key}    IN    @{keys}
        Set Suite Variable    ${${key}}    ${test_data}[${key}]
    END

Paypal Payment
    Wait Until Element Is Visible       //h3[text()="Order Summary"]
    Wait Until Page Contains Element    //div[@type="submit"]
    Wait Until Element Is Visible       //div[@type="submit"]
    Wait Until Page Contains Element    //div[@type="submit"]//iframe[@title="PayPal"]
    Wait Until Element Is Visible       //div[@type="submit"]//iframe[@title="PayPal"]
    Wait Until Element Is Enabled       //div[@type="submit"]//iframe[@title="PayPal"]
    sleep    3
    Click Element    //div[@type="submit"]//iframe[@title="PayPal"]
    ${handles}  Get Window Handles
    Switch Window    ${handles[1]}
    Maximize Browser Window
    sleep    3
    If Close Cookie Popup
    login when paypal payment
    sleep    3
    If Close Cookie Popup
    Wait Until Page Contains Element     //*[contains(text(),"Pay with")]    ${Long Waiting Time}
    Wait Until Element Is Visible    //*[contains(text(),"Pay with")]     ${Long Waiting Time}
    Execute Javascript    document.querySelector("#payment-submit-btn").click()
#    Wait Until Page Contains Element   //p[text()="Processing..."]
#    Wait Until Page Does Not Contain Element   //p[text()="Processing..."]
#    Switch Window   ${handles[0]}
    FOR   ${num}    IN RANGE    10
        ${handles}  Get Window Handles
        ${len}    Get Length     ${handles}
        Exit For Loop If    ${len} == 1
        sleep    3
    END
    Switch Window   ${handles[0]}
    sleep    1
    Wait Until Page Does Not Contain Element     //*[@stroke="transparent"]

If Close Cookie Popup
    ${is_accept_button}    Get Element Count     //button[@id="acceptAllButton"]
    IF    ${is_accept_button} > 0
        Wait Until Page Contains Element         //button[@id="acceptAllButton"]
        Wait Until Element Is Visible            //button[@id="acceptAllButton"]
        Execute Javascript    document.querySelector("#acceptAllButton").click()
    END


login when paypal payment
    ${is_email}    Get Element Count     //input[@id="email"]
    IF   ${is_email} > 0
        Wait Until Element Is Visible    //input[@id="email"]
        Click Element   //input[@id="email"]
        Input Text    //input[@id="email"]   ${paypalInfo.email}
        ${is_next}    Get Element Count    //button[@id="btnNext"]
        IF   ${is_next} == 0
            Input Text    //input[@id="password"]    ${paypalInfo.password}
        ELSE
            Click Element    //button[@id="btnNext"]
            Wait Until Element Is Visible    //input[@id="password"]
            Input Text    //input[@id="password"]    ${paypalInfo.password}
        END
        Wait Until Element Is Visible    //button[@id="btnLogin"]
        Click Element    //button[@id="btnLogin"]
    END


Add Promo Code Function
    [Arguments]    ${Code}
    Run Keyword And Ignore Error   Click Element     //div[text()="Add a Promo Code"]
    Run Keyword And Ignore Error   Wait Until Element Is Enabled   //div[text()="Apply"]   5
    Input Text    id:promoCode    ${Code}
    Click Element                    //div[text()="Apply"]
    Wait Until Element Is Enabled    //p[text()="Savings"]
    Wait Until Element Is Visible    //p[text()="${Code}"]
    ${Saving Amount}    Run Keyword And Ignore Error    Get Text    //p[text()="Savings"]/following-sibling::p
    [Return]    ${Saving Amount}

Add First Additional Pick Up Person
    Click Element    (//p[text()="Add additional pickup person"])[1]
    FOR    ${Note}   IN   @{Add Panel Text}
        Wait Until Element Is Visible     //p[text()="${Note}"]
    END
    FOR    ${key}   ${value}   IN ZIP   ${addtionalPickInfo.keys()}    ${addtionalPickInfo.values()}
        Wait Until Element Is Visible    //input[@id='${key}']
        Input Text    //input[@id='${key}']       ${value}
    END
    Click Element    //div[text()="ADD PICKUP PERSON"]
    Wait Until Element Is Not Visible        //div[text()="ADD PICKUP PERSON"]
    Wait Until Element Is Visible            //span[text()="Additional Pickup Person"]
    ${Add Full Name}   Get Text   (//span[text()="Additional Pickup Person"]/following-sibling::p)[1]
    ${Add Email}       Get Text   (//span[text()="Additional Pickup Person"]/following-sibling::p)[2]
    [Return]    ${Add Full Name}    ${Add Email}


Add A Credit Card
    [Arguments]     ${creditInfo}     ${billAddress}
#    ${add_payment_ele}    Set Variable    //p[contains(text(),"Register for")]/../following-sibling::button
    ${add_additional_card_ele}     Set Variable     //p[contains(text(),"Add Additional Card")]
    Wait Until Page Contains Element     ${add_additional_card_ele}
    Wait Until Element Is Visible     ${add_additional_card_ele}
    Click Element     ${add_additional_card_ele}
    Wait Until Element Is Visible     //h2[text()="Card Information"]
    FOR    ${key}   ${value}   IN ZIP   ${creditInfo.keys()}    ${creditInfo.values()}
        Wait Until Element Is Visible    //input[@id='${key}']
        Input Text    //input[@id='${key}']       ${value}
    END
    FOR    ${key}   ${value}   IN ZIP   ${billAddress.keys()}    ${billAddress.values()}
        IF   "${key}" == "state"
            Click Element      //select[@id="${key}"]
            Click Element     //option[@value="${value}"]
        ELSE
            Wait Until Element Is Visible    //p[text()="Billing Information"]/..//input[@id='${key}']
            Input Text    //p[text()="Billing Information"]/..//input[@id='${key}']       ${value}
        END
    END
    Click Element     //div[text()="Save"]/..
    Wait Until Element Is Visible     //div[text()="SAVE"]/..
    Click Element     //div[text()="SAVE"]/..
#    Wait Until Page Contains Element     //div[text()="Success!"]


Special Channel Detect
    [Arguments]   ${Channel Mode}
    ${IF PIS}    Pis Only Verify    ${Channel Mode}

    ${IF SDD}    Sdd Detect         ${Channel Mode}
    IF  '${IF PIS}' != 'PIS Only'
        ${IF MKR}    Mkr Only Verify     ${Channel Mode}
    ELSE
        ${IF MKR}    Set Variable        Not MKR Only
    END
    [Return]    ${IF PIS}   ${IF MKR}     ${IF SDD}

Channel Pre-Initialization
    [Arguments]    ${Channel}   ${Store In Header}
    ${Store Address}    Set Variable   Not Set
    IF   '${Channel}' == 'MKP' or '${Channel}' == 'MKPS'
        Sleep  3
    ELSE IF  '${Channel}' == 'PIS' or '${Channel}' == 'SDD' or '${Channel}' == 'SDDH'
        IF  '${Store In Header}' != '${Initial Store Name}'
            ${Store Address}   Select Or Change a Store In the Homepage    ${Initial Store Name}    CHANGE
        END
    END
    [Return]    ${Store Address}

SDD Delivery Instructions
    [Arguments]     ${IF SDD}   ${Delivery Instruction}
    IF   '${IF SDD}' == 'YES'
        Wait Until Element Is Enabled    //p[text()="Add Delivery Instructions (optional)"]
        Click Element                    //p[text()="Add Delivery Instructions (optional)"]
        Wait Until Element Is Enabled    //textarea[@id="deliveryInstruction"]
        Input Text                       //textarea[@id="deliveryInstruction"]      ${Delivery Instruction}
    END
SDD Instruction Verify
    [Arguments]   ${IF SDD}  ${Instruction}
    IF  '${IF SDD}' == 'YES'
        ${Verify Locaiton}       Get Text    //p[text()="Delivery Instructions: "]/b
        Run Keyword And Ignore Error    Should Be Equal As Strings      ${Verify Locaiton}   ${Instruction}
    END


Checkout Process - Qty And Price Calculation Compare with Subtotals
    ${Subtotal}  Set Variable    ${0}
    Execute Javascript    window.scrollTo((document.body.offsetWidth -window.innerWidth )/2, 0)
    ${Qty Collection}     Get Webelements          //p[contains(text(),"Qty: ")]
    ${Price Collection}   Get Webelements          //p[contains(@class,"ProductName")]/following-sibling::div[1]/child::p[1]
    ${Loop Count}         Get Element Count        //p[contains(text(),"Qty: ")]
    FOR   ${i}   IN RANGE  ${Loop Count}
        ${Price}     Get Text    ${Price Collection}[${i}]
        ${Qty}       Get Text    ${Qty Collection}[${i}]
        ${Qty Ext}   Number Extracted    ${Qty}
        ${Subtotal}=  Evaluate  ${Subtotal} + ${Price[1:]} * ${Qty Ext}
    END
    ${Subtotal On Panel}    Get Text       //p[text()="Subtotal ("]/following-sibling::p
    ${Subtotal On Panel}    Set Variable   ${Subtotal On Panel[1:]}
    ${Compare Res}=  Evaluate    ${Subtotal} == ${Subtotal On Panel}
    [Return]   ${Compare Res}