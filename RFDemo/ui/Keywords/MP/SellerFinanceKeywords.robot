*** Settings ***
Library        ../../Libraries/CommonLibrary.py
Library        ../../Libraries/MP/SellerFinanceLib.py
Resource       ../../Keywords/Common/CommonKeywords.robot
Resource       ../../TestData/EnvData.robot

*** Variables ***
${Randmon_Data}
${Bank_Detail}
${Card_Detail}
${Order_Number}
${Transaction_Details}
${Cur_Order_Total}

*** Keywords ***
Overview - Click Button Change
    Wait Until Element Is Visible    //div[text()="Change"]/parent::button
    Click Element    //div[text()="Change"]/parent::button
    Wait Until Element Is Visible    //p[text()="Edit Bank Details"]
    Sleep    3

Overview - Bank Details - Bank Account Info
    Clear Element Value    //*[@id="bankName"]
    Input Text    //*[@id="bankName"]    ${Bank_Detail}[bankName]
    Select From List By Index    //*[@id="bankAccountType"]    ${Bank_Detail}[bankAccountType]
    Clear Element Value    //*[@id="creditorAccountNumber"]
    Input Text    //*[@id="creditorAccountNumber"]    ${Bank_Detail}[accountNumber]
    Clear Element Value    //*[@id="confirmAccountNumber"]
    Input Text    //*[@id="confirmAccountNumber"]    ${Bank_Detail}[accountNumber]
    Clear Element Value    //*[@id="creditorRoutingNumber"]
    Input Text    //*[@id="creditorRoutingNumber"]    ${Bank_Detail}[routingNumber]

Overview - Bank Details - Bank Address Info
    Clear Element Value    //*[@id="businessName"]
    Input Text    //*[@id="businessName"]    ${Bank_Detail}[businessName]
    Clear Element Value    //*[@id="addressLineOne"]
    Input Text    //*[@id="addressLineOne"]    ${Bank_Detail}[addressLineOne]
    Clear Element Value    //*[@id="city"]
    Input Text    //*[@id="city"]    ${Bank_Detail}[city]
    Select From List By Value    //*[@id="state"]    ${Bank_Detail}[state]
    Clear Element Value    //*[@id="zipCode"]
    Input Text    //*[@id="zipCode"]    ${Bank_Detail}[zipCode]

Finance - Bank Details - Update
    [Arguments]    ${sure}=${True}
    IF    '${sure}'=='${True}'
        Click Element    //div[text()="Update Bank Details"]/parent::button
        Wait Until Element Is Visible    //p[text()="We couldn’t verify your entered bank details, please try again."]
        Click Element    //div[text()="Cancel"]/parent::button
    ELSE
        Click Element    //div[text()="Cancel"]/parent::button
    END
    Wait Until Element Is Not Visible    //div[text()="Update Bank Details"]/parent::button
    Sleep    1

Overview - View Transaction History
    Click Element    //div[text()="View Transaction History"]/parent::a
    Wait Until Element Is Visible    ${Filter_Btn_Ele1}
    Sleep    1

Deposit Options - Click Button Edit Bank Detail
    Click Element    //p[text()="Edit"]/parent::button
    Wait Until Element Is Visible    //p[text()="Edit Bank Details"]
    Sleep    1

Deposit Options - Check Bank Detail Is Update
    Wait Until Element Is Visible    //p[text()="${Bank_Detail}[bankName]"]
    Page Should Contain Element    //p[text()="${Bank_Detail}[businessName]"]
    IF    '${Bank_Detail}[bankAccountType]'=='0'
        Page Should Contain Element    //p[text()="Checking"]
    ELSE
        Page Should Contain Element    //p[text()="Savings"]
    END
    Page Should Contain Element    //p[text()="${Bank_Detail}[routingNumber]"]
    Page Should Contain Element    //p[text()="ending with ${Bank_Detail}[endAccountNumber]"]
    Sleep    1


Deposit Options - Click Add Additional Card
    ${count}    Get Element Count    //h4[text()="Credit Cards"]/../following-sibling::div/div
    ${disable_button}    Get Element Count    //p[text()="Add Additional Card"]/parent::button[@disabled]
    IF    "${count}"=="5" and "${disable_button}"=="1"
        Pass Execution    Up to five cards can be added
    END
    Click Element    //p[text()="Add Additional Card"]/parent::button
    Wait Until Element Is Visible    //p[text()="Add New Card"]
    Sleep    1

Deposit Options - Add Card Info
    Input Text    //*[@id="cardHolderName"]    ${Card_Detail}[cardHolderName]
    Input Text    //*[@id="bankCardNickName"]    ${Card_Detail}[bankCardNickName]
    Input Text    //*[@id="cardNumber"]    ${Card_Detail}[cardNumber]
    Press Keys    //*[@id="expirationDate"]    ${Card_Detail}[expirationDate]
    Input Text    //*[@id="cvv"]    ${Card_Detail}[cvv]

Deposit Options - Billing Address
    Input Text    //*[@id="firstName"]    ${Card_Detail}[firstName]
    Input Text    //*[@id="lastName"]    ${Card_Detail}[lastName]
    Input Text    //*[@id="addressLine1"]    ${Card_Detail}[addressLine1]
    Input Text    //*[@id="addressLine2"]    ${Card_Detail}[addressLine2]
    Input Text    //*[@id="city"]    ${Card_Detail}[city]
    Select From List By Value    //*[@id="state"]    ${Card_Detail}[state]
    Input Text    //*[@id="zipCode"]    ${Card_Detail}[zipCode]
    Input Text    //*[@id="phoneNumber"]    ${Card_Detail}[phoneNumber]

Deposit Options - Add&Edit Card Save
    [Arguments]    ${sure}=${True}
    IF    '${sure}'=='${True}'
        Click Element    //div[text()="SAVE"]/parent::button
        Deposit Options - Address Not Verify
    ELSE
        Click Element    //div[text()="CANCEL"]/parent::button
        Wait Until Element Is Not Visible    //p[text()="Card Information"]
    END

Deposit Options - Address Not Verify
    Wait Until Element Is Visible    //p[text()="Verify Address"]
    Wait Until Element Is Visible    //footer//div[text()="SAVE"]/parent::button
    Sleep    1
    Click Element    //footer//div[text()="SAVE"]/parent::button
    Wait Until Element Is Not Visible    //p[text()="Verify Address"]
    Wait Until Element Is Not Visible    //p[text()="Card Information"]
    Wait Until Element Is Visible    //*[contains(text(),"Success")]
    Wait Until Element Is Not Visible    //*[contains(text(),"Success")]

Deposit Options - Select Last Credit Card
    ${edit_count}    Get Element Count    //p[text()="Edit"]/../parent::button
    IF    "${edit_count}"=="1"
        Reload Page
        Wait Loading Hidden
        Wait Until Element Is Visible    //p[text()="Expiration"]/parent::div/following-sibling::div
    END
    ${count}    Get Element Count    //p[text()="Expiration"]/parent::div/following-sibling::div
    Click Element    (//p[text()="Expiration"]/parent::div/following-sibling::div)[${count}]
    Wait Until Element Is Visible    //p[text()="Edit"]/../parent::button

Deposit Options - Click Edit Card Info
    Click Element    //p[text()="Edit"]/../parent::button
    Wait Until Element Is Visible    //p[text()="Edit Card"]
    Sleep    1

Deposit Options - Check New Card Info
    Page Should Contain Element    //*[@id="cardHolderName" and @value="${Card_Detail}[cardHolderName]"]
    Page Should Contain Element    //*[@id="bankCardNickName" and @value="${Card_Detail}[bankCardNickName]"]
#    Page Should Contain Element    //*[@id="cardNumber"]    ${Card_Detail}[cardNumber]
    Page Should Contain Element    //*[@id="firstName" and @value="${Card_Detail}[firstName]"]
    Page Should Contain Element    //*[@id="lastName" and @value="${Card_Detail}[lastName]"]
    Page Should Contain Element    //*[@id="addressLine1" and @value="${Card_Detail}[addressLine1]"]
    Page Should Contain Element    //*[@id="addressLine2" and @value="${Card_Detail}[addressLine2]"]
    Page Should Contain Element    //*[@id="city" and @value="${Card_Detail}[city]"]
    Page Should Contain Element    //*[@id="zipCode" and @value="${Card_Detail}[zipCode]"]
#    Page Should Contain Element    //*[@id="phoneNumber" and @value="${Card_Detail}[phoneNumber]"]

Deposit Options - Remove Credit Card
    [Arguments]    ${sure}=${True}
    Reload Page
    Wait Until Element Is Visible    //h4[text()="Credit Cards"]/../following-sibling::div/div
    ${count}    Get Element Count    //h4[text()="Credit Cards"]/../following-sibling::div/div
    IF    ${count}>2
        Click Element    (//p[text()="Expiration"]/../following-sibling::div//button)[${count}]
        Wait Until Element Is Visible    //p[text()="Remove"]/../parent::button
        Click Element    //p[text()="Remove"]/../parent::button
        Wait Until Element Is Visible    //p[text()="Remove Payment Method"]
        Sleep    1
        Run Keyword If    '${sure}'=='${True}'    Click Element    //div[text()="Confirm"]/parent::button
        Run Keyword If    '${sure}'=='${False}'    Click Element    //div[text()="Cancel"]/parent::button
        Wait Until Element Is Not Visible    //p[text()="Remove Payment Method"]
        Wait Until Element Is Not Visible    //p[text()="Remove"]/../parent::button
        Wait Until Element Is Visible    //*[contains(text(),"Success")]
        Wait Until Element Is Not Visible    //*[contains(text(),"Success")]
    ELSE
        Capture Element Screenshot    //h4[text()="Credit Cards"]/../parent::div    credit_card_list.png
        Skip  credit card number less than 2, not remove
    END

Transactions - Search Order
    [Arguments]    ${search_value}
    Clear Element Value    //*[@id="searchOrders"]
    Input Text    //*[@id="searchOrders"]    ${search_value}
    Press Keys    None    ${RETURN_OR_ENTER}
    Wait Until Element Is Visible    //p[contains(text(),"${search_value}")]
    Sleep    1
    Clear Element Value    //*[@id="searchOrders"]

Transactions - Filter By Status Or Transaction Single
    [Documentation]    Completed,Pending,Paid，Payout,Sales,Refund,Cancellation,Return Shipping Label Fee
    [Arguments]    ${status}
    Wait Until Element Is Visible    ${Filter_Btn_Ele1}
    Click Element    ${Filter_Btn_Ele1}
    Wait Until Element Is Visible    ${Filter_Clear_All}
    Click Element    ${Filter_Clear_All}
    Sleep  0.5
    Click Element    //*[text()="${status}"]/../parent::label
    Sleep  0.5
    Click Element    ${Filter_View_Results}
    Wait Until Element Is Not Visible    ${Filter_View_Results}
    Wait Loading Hidden
    Sleep    1

Transactions - Filter By Status Or Transaction List
    [Documentation]    Completed,Pending,Paid，Payout,Sales,Refund,Cancellation,Return Shipping Label Fee
    [Arguments]    ${status_list}
    Wait Until Element Is Visible    ${Filter_Btn_Ele1}
    Click Element    ${Filter_Btn_Ele1}
    Wait Until Element Is Visible    ${Filter_Clear_All}
    Click Element    ${Filter_Clear_All}
    Sleep  0.5
    FOR    ${item}   IN  ${status_list}
        Click Element    //*[text()="${item}"]/../parent::label
    END
    Sleep  0.5
    Click Element    ${Filter_View_Results}
    Wait Until Element Is Not Visible    ${Filter_View_Results}
    Wait Loading Hidden
    Sleep    1

Transactions - Get Order Number By Index
    [Arguments]    ${index}=1
    Wait Until Element Is Visible    //table//tbody/tr[${index}]/td[2]/p
    ${text}    Get Text  //table//tbody/tr[${index}]/td[2]/p
    ${Order_Number}    Evaluate    '${text}'[11:32]
    Set Suite Variable    ${Order_Number}    ${Order_Number}

Transactions - Show Detail By Index
    [Arguments]     ${index}=1
    Transactions - Get Detail By Index    ${index}
    Click Element    //table//tbody/tr[${index}]/td[2]/button
    Wait Until Element Is Visible   //p[text()="Transaction Details"]
    Sleep    1

Transactions - Click Link To Order Detail And Back
    Click Element    //p[starts-with(text(),"Order #")]
    Wait Until Element Is Visible    //h1[text()="Order Details"]
    Scroll Last Button Into View
    Click Element    //p[text()="Back"]/parent::button
    Wait Until Element Is Not Visible        //h1[text()="Order Details"]

Transactions - Get Detail By Index
    [Arguments]    ${index}=1
    ${date}    Get Text    //table//tbody/tr[${index}]/td[1]/p
    ${desc_status}    Get Text    //table//tbody/tr[${index}]/td[2]/button/p
    ${order_info}    Get Text    //table//tbody/tr[${index}]/td[2]/p
    ${status}    Get Text    //table//tbody/tr[${index}]/td[3]//p
    ${amount}    Get Text    //table//tbody/tr[${index}]/td[4]/p
    ${fees}    Get Text    //table//tbody/tr[${index}]/td[5]/p
    ${net}    Get Text    //table//tbody/tr[${index}]/td[6]/p
    ${detail}    Create Dictionary    date=${date}    desc_status=${desc_status}   order_info=${order_info}
    ...    status=${status}    amount=${amount}    fees=${fees}    net=${net}
    Set Suite Variable    ${Transaction_Details}   ${detail}

Transactions - Check Details
    ${base_ele}    Set Variable    //div[@role="dialog"]
    ${desc_status}   Set Variable    ${Transaction_Details}[desc_status]
    Page Should Contain Element    ${base_ele}//p\[text()="${desc_status}"\]
#    ${date}    Set Variable    ${Transaction_Details}[date]
#    Page Should Contain Element    ${base_ele}//p\[text()="${date}"\]
    ${status}    Set Variable    ${Transaction_Details}[status]
    Page Should Contain Element    ${base_ele}//p\[text()="${status}"\]

Transactions - Close
    Wait Until Element Is Visible    //p[text()="Transaction Details"]/following-sibling::*
    Click Element    //p[text()="Transaction Details"]/following-sibling::*
    Wait Until Element Is Not Visible   //p[text()="Transaction Details"]/following-sibling::*
    Sleep    1

Tax Information - Edit Business Info
    Wait Until Element Is Visible    //p[text()="Edit"]/parent::button
    Click Element    //p[text()="Edit"]/parent::button
    Wait Until Element Is Visible    //p[text()="Edit Business Information"]
    ${code}    Get Random Code    6    ${False}
    Clear Element Value    //input[@id="firstName"]
    Input Text    //input[@id="firstName"]    ${code}
    Clear Element Value    //*[@id="lastName"]
    Input Text    //*[@id="lastName"]    Auto
    Clear Element Value    //*[@id="companyName"]
    Input Text    //*[@id="companyName"]    Business ${code}
    Sleep    1
#    Click Element    //div[text()="Update Business Information"]/parent::button
#    Wait Until Element Is Not Visible    //p[text()="Edit Business Information"]
    Click Element    //div[text()="Cancel"]/parent::button
    Pass Execution   This account can't edit business info.

Transactions - Export To Xlsx On Overview Page And Check Results
    Wait Until Element Is Visible    //div[text()="Export to XLSX"]/parent::button
    Remove Download File If Existed    transaction.xlsx
    Click Element    //div[text()="Export to XLSX"]/parent::button
    ${results}   ${file_path}   Wait Until File Download    transaction.xlsx
    IF    "${results}"=="${False}"
        Fail    Fail to export file transaction.xlsx.
    END
    Transactions - Check Export Data    ${file_path}    ${False}

Transactions - Check Export Data
    [Arguments]    ${file_path}     ${transaction_page}=${False}    ${transaction}=All
    ${export_info}    Read Download Excel    ${file_path}
    ${export_len}    Get Length    ${export_info}
    ${export_len}    Evaluate    ${export_len}-1
    IF    "${transaction_page}"=="${False}"
        IF    "${export_len}"!="0"
            ${first_export}     Set Variable    ${export_info[1]}
            Page Should Contain Element    //table//tbody/tr[1]/td[2]//p[contains(text(),"${first_export[1]}")]
            Page Should Contain Element    //table//tbody/tr[1]/td[3]//p[text()="${first_export[3]}"]
            Page Should Contain Element    //table//tbody/tr[1]/td[4]//p[contains(text(),"${first_export[5]}")]
        END
    ELSE IF    "${transaction_page}"=="${True}"
        IF    "${transaction}"!="All"
            Transactions - Filter By Status Or Transaction Single    ${transaction}
        END
        Sleep    1
        Transactions - Get Results Total Number
        Should Be Equal As Strings    ${Cur_Order_Total}    ${export_len}
        IF    "${export_len}"!="0"
            ${first_export}     Set Variable    ${export_info[1]}
            Page Should Contain Element    //table//tbody/tr[1]/td[2]//p[contains(text(),"${first_export[1]}")]
            Page Should Contain Element    //table//tbody/tr[1]/td[3]//p[text()="${first_export[3]}"]
            Page Should Contain Element    //table//tbody/tr[1]/td[4]//p[contains(text(),"${first_export[5]}")]
            IF    "${first_export[6]}"=="--"
                ${text}   Get Text    //table//tbody/tr[1]/td[5]//p
                Should Be Equal As Strings    "${text}"    "——"
                Page Should Contain Element    //table//tbody/tr[1]/td[5]//p[contains(text(),"——")]
            ELSE
                Page Should Contain Element    //table//tbody/tr[1]/td[5]//p[contains(text(),"${first_export[6]}")]
            END
            Page Should Contain Element    //table//tbody/tr[1]/td[6]//p[contains(text(),"${first_export[8]}")]
            IF    "${transaction}"!="All"
                ${index}   Set Variable
                FOR   ${index}    IN RANGE    1    ${export_len}
                    ${export}   Set Variable    ${export_info[${index}]}
                    Should Be Equal As Strings    ${transaction}    ${export[4]}
                END
            END
        END
    END

Transactions - Get Results Total Number
    Sleep    1
    Wait Loading Hidden
    Sleep    0.5
    ${count}    Get Element Count    //table/following-sibling::div//p
    IF    ${count}>0
        ${result}    Get Text    //table/following-sibling::div//p
        ${order_total}    Evaluate    '${result}'.split(" ")\[2\]
        Set Suite Variable    ${Cur_Order_Total}    ${order_total}
    ELSE
        Set Suite Variable    ${Cur_Order_Total}    0
    END

Transactions - Export To Xlsx On Transactions Page By Transaction And Check Results
    [Arguments]    ${transaction}=All
    Store Left Menu - Finances - Transactions
    Wait Until Element Is Visible    //div[text()="EXPORT TO CSV FILE"]/parent::button
    Remove Download File If Existed    transactions.xlsx
    Click Element    //div[text()="EXPORT TO CSV FILE"]/parent::button
    Wait Until Element Is Visible    //p[text()="Export Transactions"]
    IF    "${transaction}"=="All"
        Click Element    //p[text()="Export All"]/parent::button
    ELSE
        Click Element    //*[@id="transactionStatus"]
        Wait Until Element Is Visible    //option[text()="Cancellation"]
        Click Element    //option[text()="${transaction}"]
        Sleep    0.5
        Click Element    //div[text()="Export Selected Transactions Details"]/parent::button
    END
    Wait Until Element Is Visible    //p[text()="Export Transactions to Spreadsheet - Export Success"]
    Click Element    //div[text()="Click Here to Download File Manually"]/parent::button
    ${results}    ${file_path}   Wait Until File Download    transactions.xlsx
    IF    "${results}"=="${False}"
        Fail    Fail to export file transactions.xlsx.
    END
    Click Element    //p[text()="Export Transactions to Spreadsheet - Export Success"]/../following-sibling::button
    Wait Until Element Is Not Visible    //p[text()="Export Transactions to Spreadsheet - Export Success"]
    Transactions - Check Export Data    ${file_path}    ${True}    ${transaction}
    Sleep    1


