*** Settings ***
Library         ../../Libraries/CommonLibrary.py
Library         ../../Libraries/MP/SellerDashboardLib.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource        ../../Keywords/MP/SellerOrderManagementKeywords.robot
Resource        ../../Keywords/MP/SellerReturnsKeywords.robot
Resource        ../../Keywords/MP/SellerDisputesKeywords.robot
Resource        ../../Keywords/MP/SellerListingKeywords.robot
Resource        ../../Keywords/Common/MenuKeywords.robot
Resource        ../../TestData/EnvData.robot
Resource        ../../Keywords/MP/EAInitialSellerDataAPiKeywords.robot

*** Variables ***
${Business_Actions_Info}
${Store_Activities_Info}
${Dashboard_Store_Activities_Data}
${Dashboard_Business_Actions_Data}


*** Keywords ***
Seller Dashboard - Get Page Info
    ${listing_info}    Create Dictionary
    ${Business_Actins_Info}     Create Dictionary
    ${product_listings}      Create List    Active    Inactive    Prohibited    Draft    Out of stock    Pending Review
    FOR    ${item}    IN    @{product_listings}
        IF      "${item}" == "Active" or "${item}" == "Draft"
            ${text}    Get Text    (//p[text()="${item}"]/following-sibling::p)[1]
        ELSE
            ${text}    Get Text    //p[text()="${item}"]/following-sibling::p
        END
        Set To Dictionary    ${listing_info}    ${item}=${text}
    END
    Set To Dictionary    ${Business_Actins_Info}    listing_info=${listing_info}
    ${order_info}    Create Dictionary
    ${order_list}      Create List    Pending Confirmation    Ready to Ship    Partially Shipped    Pending Return
    ...    Pending Refund    Dispute Opened    Dispute Escalated
    FOR    ${item}    IN    @{order_list}
        ${text}    Get Text    //p[text()="${item}"]/following-sibling::p
        Set To Dictionary    ${order_info}    ${item}=${text}
    END
    Set To Dictionary    ${Business_Actins_Info}    order_info=${order_info}
    ${marketing_info}    Create Dictionary
    ${marketing_list}      Create List    Active    Scheduled    Completed    Draft    Terminated
    FOR    ${item}    IN    @{marketing_list}
        IF      "${item}" == "Active" or "${item}" == "Draft"
            ${text}    Get Text    (//p[text()="${item}"]/following-sibling::p)[2]
        ELSE
            ${text}    Get Text    //p[text()="${item}"]/following-sibling::p
        END
        Set To Dictionary    ${marketing_info}    ${item}=${text}
    END
    Set To Dictionary    ${Business_Actins_Info}    marketing_info=${marketing_info}
    Set Suite Variable      ${Business_Actins_Info}         ${Business_Actins_Info}
    Log     ${Business_Actins_Info}

Check Visit Your Live Store Here
    Check The Redirect Address Of The Dashboard Page Link       Visit your live store here       //h1[text()="CONTACT INFO"]
    Mouse Over      //p[text()="Visit your live store here"]
    Wait Until Element Is Visible       //p[text()="Copy"]
    Click Element       //p[text()="Copy"]
    Wait Until Element Is Visible       //p[text()="Copied"]
    ${live_page_url}        Get Clipboard Text
    Go To       https://${live_page_url}
    Wait Until Page Contains Element        //h1[text()="CONTACT INFO"]
    Sleep  1
    Go Back
    Wait Until Element Is Visible    //h2[starts-with(text(),"Welcome to your Dashboard")]

Check The Data Of Cards In Scroll Box
    Check The Redirect Address Of The Dashboard Page Link       Create Listing                              //h1[text()="Listing Details"]
    Check The Redirect Address Of The Dashboard Page Link       Start the Developer API Registration        //h3[text()="MICHAELS API LIBRARY"]

Get Dashboard Store Activities Data - GET
    ${res}    Send Get Request      ${API_HOST_MIK}       /mda/dashboard/store-activities        timeOption=2    ${Headers_Get_Seller}
    ${Dashboard_Store_Activities_Data}        Get Json Value              ${res.json()}           data
    Set Suite Variable              ${Dashboard_Store_Activities_Data}    ${Dashboard_Store_Activities_Data}
    Log  ${Dashboard_Store_Activities_Data}

Check Dashboard Store Activites Data
    # filterByStatus=1,2 means that the status is Completed and Pending ; filterByTransactionType=1  means that the Transactions Type is Sale
    ${params}    Create Dictionary      pageNumber=0    pageSize=1000    filterByStatus=1,2    filterByTransactionType=1      sortBy=occurTime     isAsc=false
    ${finance_sale_order_data}              Get Finance Sale Order List           ${API_HOST_MIK}      ${Seller_Store_Id}      ${Headers_Get_Seller}    ${params}
    ${finance_available_balance_data}       Get Finance Balance Data              ${API_HOST_MIK}      ${Seller_Store_Id}      ${Headers_Get_Seller}

    ${dashboard_sotre_sales}                Get Json Value      ${Dashboard_Store_Activities_Data}              sales
    ${dashboard_store_sales_change}         Get Json Value      ${Dashboard_Store_Activities_Data}              salesChange
    ${dashboard_store_units}                Get Json Value      ${Dashboard_Store_Activities_Data}              soldUnits
    ${dashboard_store_units_change}         Get Json Value      ${Dashboard_Store_Activities_Data}              soldUnitsChange
    ${dashboard_store_balance}              Get Json Value      ${Dashboard_Store_Activities_Data}              balance

    ${finance_order_sales}              Get Json Value      ${finance_sale_order_data}      allSellerData       pastSevenDaysData       sales
    ${finance_order_sales_change}       Get Json Value      ${finance_sale_order_data}      changeRate       pastSevenDaysChangeRate       saleChangeRate
    ${finance_order_units}              Get Json Value      ${finance_sale_order_data}      allSellerData       pastSevenDaysData       soldUnits
    ${finance_order_units_change}       Get Json Value      ${finance_sale_order_data}      changeRate       pastSevenDaysChangeRate       soldUnitChangeRate

    Should Be Equal As Numbers          ${dashboard_sotre_sales}                    ${finance_order_sales}                  precision=2
    Should Be Equal As Numbers          ${dashboard_store_sales_change}             ${finance_order_sales_change}           precision=2
    Should Be Equal As Numbers          ${dashboard_store_units}                    ${finance_order_units}                  precision=2
    Should Be Equal As Numbers          ${dashboard_store_units_change}             ${finance_order_units_change}           precision=2
    Should Be Equal As Numbers          ${dashboard_store_balance}                  ${finance_available_balance_data}       precision=2

    ${text_sales}          Get Text                 //p[text()="Sales"]/parent::div/following-sibling::div/div/h2
    ${text_units}          Get Text                 //p[text()="Units Sold"]/parent::div/following-sibling::div/div/h2
    ${text_balance}          Get Text                 //p[text()="Available Balance"]/parent::div/following-sibling::div/div/h2
    Should Not Be Empty                 ${text_sales}
    Should Not Be Empty                 ${text_units}
    Should Not Be Empty                 ${text_balance}



Get Dashboard Business Actions Data - GET
    ${res}    Send Get Request      ${API_HOST_MIK}       /mda/dashboard/business-actions-v2        ${null}    ${Headers_Get_Seller}
    ${Dashboard_Business_Actions_Data}        Get Json Value              ${res.json()}           data
    Set Suite Variable              ${Dashboard_Business_Actions_Data}    ${Dashboard_Business_Actions_Data}
    Log     ${Dashboard_Business_Actions_Data}

Check Dashboard Business Actions Listing Data
    Check Listings Number By Status     ${API_HOST_MIK}       ${Seller_Store_Id}      ${Headers_Get_Seller}     ${Business_Actins_Info}



Check Dashboard Business Actions Order Data
    Check Orders Number By Status       ${API_HOST_MIK}     ${Headers_Get_Seller}             ${Business_Actins_Info}
    Check Return Orders Number By Status        ${API_HOST_MIK}     ${Headers_Get_Seller}     ${Business_Actins_Info}
    Check Dispute Orders Number By Status       ${API_HOST_MIK}     ${Headers_Get_Seller}     ${Business_Actins_Info}



Check Dashboard Business Actions Marketing Data
    Check Promotion Number By Status     ${API_HOST_MIK}     ${Headers_Post_Seller}     ${Business_Actins_Info}

Check The Redirect Address Of The Dashboard Page Link
    [Arguments]  ${link_page_name}      ${target_page_context}
    Click Element       //p[text()="${link_page_name}"]
    Wait Until Page Contains Element        ${target_page_context}
    Sleep  1
    Go Back
    Wait Until Element Is Visible    //h2[starts-with(text(),"Welcome to your Dashboard")]


