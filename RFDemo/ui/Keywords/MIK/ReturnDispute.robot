*** Settings ***
Documentation       This is to Return Dispute
Library        ../../Libraries/CommonLibrary.py
Resource       ../../Keywords/Common/MikCommonKeywords.robot
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/CartAndOrder.robot

*** Variables ***
${order_num}
${return_order}

*** Keywords ***
Check Out FGM Product
    [Arguments]  ${product_num}
    Go To  ${URL_summer_store}
    ${result}  Run Keyword And Ignore Error  Wait Until Page Contains  All Products
    IF  '${result[0]}'=='PASS'
        ${product_ele}  Get Webelements  //h2[text()='All Products']/../following-sibling::div/div
        Click On The Element And Wait  ${product_ele}[${product_num}]
    ELSE
        Click On The Element And Wait  //p[text()='Search Makerplace']
        Input Text And Wait  //input[@aria-label="Search Input"]  Summer
        Click On The Element And Wait  //p[text()='Search Makerplace:']/following-sibling::div/button
        Click On The Element And Wait  //p[text()='summer']/following-sibling::p/parent::div
    END

Go To Seller Order And Shipments
    Switch Browser  miksellerUrl
    Reload Page
    Click On The Element And Wait  (//p[text()='Orders'])[2]
    Input Text And Wait  //input[@placeholder="Search"]  ${order_num}
    Click On The Element And Wait  //input[@placeholder="Search"]/preceding-sibling::div/*
    Click On The Element And Wait  //a[starts-with(text(), 'FGM')]
    Wait Until Page Contains  Waiting for shipment
    Click On The Element And Wait  //p[text()='Image']/parent::th/preceding-sibling::th/*
    Click On The Element And Wait  //div[contains(text(), 'Ship Item')]
    Click On The Element And Wait  //p[text()='Expand']/parent::button
    ${trackingNumber}  Generate Random String	 10  [NUMBERS]
    Input Text And Wait  //input[@id="trackingNumber"]  ${trackingNumber}
    Click On The Element And Wait  //div[text()='Add Tracking Number']/parent::button
    Wait Until Page Contains  Shipment created successfully
    Click On The Element And Wait  //p[text()='Back']

Go To Buyer Order And Return
    [Arguments]  ${return_num}=0  ${reason_num}=0
    Switch Browser  mikLandingUrl
    Reload Page
    Click On The Element And Wait  //div[text()='Return']/parent::button
    Click On The Element And Wait  //span[text()='Sold by']/../../preceding-sibling::span/span
    IF  '${return_num}'!='0'
        Input Text And Wait  //button[text()='+']/preceding-sibling::input  ${return_num}
    END
    Buyer Return Reason  ${reason_num}

Upload Pictures
    Click On The Element And Wait  //p[starts-with(text(), 'Add ')]
    Choose File And Wait  //span[text()='Select File']/../preceding-sibling::input
    Wait Until Page Contains Element  //img[@alt="Uploaded Image"]
    Click On The Element And Wait  //span[text()='Submit']/parent::button

Buyer Return Reason
    [Arguments]  ${reason_num}=0  ${reason_Notes}=test
    ${return_reason}  Create List  Changed Mind  Item Was Damaged  Item Does Not Work
    ...  Not as Described  Did Not Receive This Item  Wrong Item Was Sent
    ...  Missing Parts or Accessories  No Longer Needed  Purchased by Mistake
    Click On The Element And Wait  //span[text()='Next']/parent::button
    Sleep  0.2
    Scroll Last Button Into View
    Click On The Element And Wait  //p[text()='Return Reason']/../following-sibling::div/button
    Click On The Element And Wait  //button[text()='${return_reason}[${reason_num}]']
    Click On The Element And Wait  //p[text()='Condition of the item']/../following-sibling::div/button
    Click On The Element And Wait  //button[text()='Damaged']
    Input Text And Wait  //input[@title="Enter Notes Here (Optional)"]  ${reason_Notes}
    Upload Pictures
    Click On The Element And Wait  //span[text()='Next']/parent::button
    Click On The Element And Wait  //span[text()='Submit']/parent::button
    Click On The Element And Wait  //span[text()='View Return Details']/parent::button
    Wait Until Page Contains  ${order_num}
    ${return_order}  Get Text And Extraction Data  //h4[starts-with(text(), 'Return Order #')]  15
    Set Suite Variable  ${return_order}

Seller First Time Handle Disputes
    [Arguments]  ${return_reason}=Approve Full Refund   ${RejectReason}=Item Was Used  ${Refund Amount}=${null}
    Switch Browser  miksellerUrl
    Click On The Element And Wait  //p[text()='Returns / Disputes']
    Wait Until Page Contains  ${return_order}
    Click On The Element And Wait  //div[text()='Take action on the return requests']/parent::button
    Click On The Element And Wait  //button[@title="Please Select an Option"]
    Click On The Element And Wait  //button[text()='${return_reason}']
    IF  '${return_reason}'=='Reject Refund'
        Click On The Element And Wait  //button[@title="Please Select an Option"]
        Click On The Element And Wait  //button[text()='${RejectReason}']
    ELSE IF  '${return_reason}'=='Approve Partial Refund'
        Input Text And Wait  //input[@placeholder="Enter Text"]      ${RejectReason}
        Input Text And Wait  //input[@data-testid="Refund Amount"]   ${Refund Amount}
    END
    Scroll Last Button Into View
    Scroll Element And Wait And Click  //span[text()='Next']/parent::button
    Sleep  1
    Scroll Last Button Into View
    Click On The Element And Wait  //span[text()='Submit']/parent::button
    Click On The Element And Wait  //span[text()='Returns & Disputes']/parent::button

Buyer Confirms Status of Disputes
    [Arguments]  ${Dispute_Status}=Return Declined
    Switch Browser  mikLandingUrl
    Go To  ${URL_MIK}
    Go To Order History
    Click On The Element And Wait  (//p[text()='Return and Dispute'])[2]
    Reload Page
    Wait Until Page Contains  ${return_order}  30
    Click On The Element And Wait  //p[text()='View Details']
    Wait Until Page Contains  ${Dispute_Status}

Buyer First Time Handle Disputes
    [Arguments]  ${Dispute_Reason_num}=8  ${Notes}=${null}
    Switch Browser  mikLandingUrl
    Reload Page
    Click On The Element And Wait  //div[text()='Submit Dispute']/parent::button
    Click On The Element And Wait  //h3/preceding-sibling::span/span
    Click On The Element And Wait  //button[@title="Please Select an Option"]
    ${Dispute_Reason}  Create List  Changed Mind  Not as Described  Did Not Receive This Item
    ...  Item Was Damaged  Item Does Not Work  Wrong Item Was Sent  Missing Parts or Accessories
    ...  Unacceptable Offer  Others
    Click On The Element And Wait  //button[text()='${Dispute_Reason}[${Dispute_Reason_num}]']
    Input Text And Wait  //p[text()='Notes']/parent::div/following-sibling::div//input  ${Notes}
    Upload Pictures
    Click On The Element And Wait  //span[text()='Next']/parent::button
    Click On The Element And Wait  //span[text()='Submit']/parent::button
    Click On The Element And Wait  //span[text()='Return & Dispute Page']/parent::button

Seller second time Handle Disputes
    [Arguments]  ${Decision}   ${Reason}=${null}  ${Refund_Amount}=${null}
    Switch Browser  miksellerUrl
    Click On The Element And Wait  //p[text()='Disputes']/parent::button
    Reload Page
    Wait Until Page Contains  ${order_num}
    Click On The Element And Wait  //p[text()='View Dispute']/parent::a
    Click On The Element And Wait  //p[text()='Review Request']
    Click On The Element And Wait  //p[text()='Make Decision']
    Click On The Element And Wait  //button[@title="Please Select an Option"]
    Click On The Element And Wait  //button[text()='${Decision}']
    Input Text And Wait  //input[@title="Please fill in"]  ${Reason}
    IF  ' ${Decision}'=='Offer Partial Refund'
        Input Text And Wait  //input[@data-testid="Refund Amount_0"]  ${Refund_Amount}
    END
    Click On The Element And Wait  //span[starts-with(text(),'I acknowledge')]
    Click On The Element And Wait  //span[text()='Submit']/parent::button
#    Click On The Element And Wait  //p[text()='Provide Shipping Label']/../parent::button
#    Click On The Element And Wait  //span[starts-with(text(),'Use Michaels')]
#    Click On The Element And Wait  //span[text()='Next']/parent::button
#    ${UPS Service}  Create Dictionary  weight=7  Height=7  length=7  width=7
#    For Dict And Input Text  ${UPS Service}
#    Click On The Element And Wait  //p[starts-with(text(),'I agree to and accept the')]
#    Click On The Element And Wait  //span[text()='Attach Shipping Label']/parent::button

Buyer second time Handle Disputes
    [Arguments]  ${Reject_Accept}=Accept
    Switch Browser  mikLandingUrl
    Reload Page
    Wait Until Element Is Visible  //div[text()='View Dispute']/parent::button
    Click On The Element And Wait  //div[text()='View Dispute']/parent::button
    Click On The Element And Wait  //p[starts-with(text(),'I acknowledge')]
    Click On The Element And Wait  //a[text()='${Reject_Accept} Offer']

Seller third time Handle Disputes
    [Arguments]  ${Escalation_Reason}=123  ${info}=hello
    Switch Browser  miksellerUrl
    Reload Page
    Click On The Element And Wait  //span[text()='Dispute Summary']/parent::button
    Click On The Element And Wait  //span[text()='Escalate Dispute']/parent::button
    Input Text And Wait  //p[text()='Escalation Reason']/parent::div/following-sibling::div/textarea  ${Escalation_Reason}
    Click On The Element And Wait  //span[starts-with(text(),'I acknowledge')]
    Click On The Element And Wait  //span[text()='Yes']/parent::button
    Wait Until Page Contains  Escalate Dispute Success
    Click On The Element And Wait  //p[text()='Back']

Buyer third time Handle Disputes
    [Arguments]  ${Cancel_Disputes}=False  ${Cancel_Dispute_Reason}=${null}  ${info}=${null}
    Switch Browser  mikLandingUrl
    Reload Page
    Click On The Element And Wait  //span[text()='Dispute Summary']/parent::button
    IF  '${Cancel_Disputes}'=='True'
        Click On The Element And Wait  //span[text()='Cancel Dispute']/parent::button
        Click On The Element And Wait  //button[@title="Please Select an Option"]
        Click On The Element And Wait  //button[text()='${Cancel_Dispute_Reason}']
        Input Text And Wait  //textarea[@title]  ${info}
        Click On The Element And Wait  //span[starts-with(text(),'I acknowledge')]
        Click On The Element And Wait  //span[text()='Close']/../following-sibling::button
    END

Buyer Cancel Dispute
    [Arguments]  ${num}=0  ${Add_Notes}=${null}
    Click On The Element And Wait  //span[text()='Dispute Summary']/parent::button
    Click On The Element And Wait  //span[text()='Cancel Dispute']/parent::button
    Click On The Element And Wait  //p[text()='Reason to Cancel Dispute']/parent::div/following-sibling::div/button
    ${Reason_to_Cancel_Dispute}  Create List  Item Received  Seller Refunded
    ...  Tracking Info Provided  Replacement Item Received  Other
    Click On The Element And Wait  //button[text()='${Reason_to_Cancel_Dispute}[${num}]']
    Input Text And Wait  //textarea[@title="The item arrived unexpectedly..."]  ${Add_Notes}
    Click On The Element And Wait  //span[starts-with(text(),'I acknowledge')]
    Click On The Element And Wait  //span[text()='Cancel Dispute']/parent::button
    Click On The Element And Wait  //p[text()='Back']
    Page Should Contain  Cancellation Reason
    Click On The Element And Wait  //*[@class="MuiSvgIcon-root"]

Check Out FGM And Go To Order
    [Arguments]  ${buy_num}=1
    Sign in  ${BUYER_EMAIL}  ${BUYER_PWD}
    Remove All Shopping Cart
    Check Out FGM Product  0
    Wait Until Page Contains  ADD TO CART  60
    Add Shopping Cart  ${buy_num}
    Check Out
    Go To Order History
    Reload Page
    Wait Until Element Is Visible  //p[text()='Order Number']  30
    Go To Order Details Page
    Wait Until Element Is Visible  //h4[contains(text(), 'Order #')]  60
    ${order_num}  Get Text And Extraction Data  //h4[contains(text(), 'Order #')]  7
    Set Suite Variable  ${order_num}

Seller Goods shelves
    Go To personal information  Storefront  summer
    Click On The Element And Wait  //p[text()='My Product Listings']
    ${result}   Run Keyword And Ignore Error  wait until page contains  Active  3
    IF  '${result[0]}'=='FAIL'
        Click On The Element And Wait  //*[@cursor="pointer"]
        ${ele}  Get Webelements  //div[text()='Duplicate']/parent::p
        Click On The Element And Wait  ${ele}[-1]
        Scroll Element And Wait And Click  //div[text()='Publish']/parent::button
        Click On The Element And Wait  //div[text()='GO TO LISTING MANAGEMENT']/parent::button
    END