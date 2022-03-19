*** Settings ***
Resource            ../../Keywords/MP/BuyerReturnAndDisputeKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - BuyerReturn
Suite Teardown       Delete All Sessions

*** Test Cases ***
Test Get Buyer Order History
    [Documentation]  query buyer order history
    [Tags]    mp-ea
    ${param}  Set Variable   toAggregate=true
    Get Buyer Order History - GET  ${param}

Test Get Buyer Order Detail
    [Documentation]  query buyer order detail
    [Tags]    mp-ea
    ${content}  Get Buyer Order History - GET   toAggregate=true
    ${parent_order_number}  Get Json Value  ${content}  parentOrderNumber
    Get Buyer Order Detail - GET  ${parent_order_number}

Test Buyer Create Return Order
    [Documentation]  buyre create return order
    [Tags]    mp-ea
    ${contents}  Get Buyer Order History - GET  pageSize=50
    ${return_length}  Set Variable  ${null}
    FOR  ${content}  IN  @{contents}
        ${parent_order_number}  Get Json Value  ${content}  parentOrderNumber
        ${buyer_order_detail}  Get Buyer Order Detail - GET   ${parent_order_number}
        ${can_return_order}  Buyer After Salers Chckorder  ${parent_order_number}
        ${return_length}  Get Length  ${can_return_order}
        IF  "${return_length}">"0"
            Buyer Create Return Order - POST   ${buyer_order_detail}   ${can_return_order}
            Exit For Loop
         END
    END
    Run Keyword If   "${return_length}"=="0"   Skip   There don't have order can return


Test Buyer Get Return And Dispute List And Create Dispute
    [Documentation]  buyre crete dispute
    [Tags]    mp-ea
    ${afterSalesRspVoList}  Buyer Get Return And Dispute List - GET
    ${dispute_items}  Create List
    FOR  ${sale_rep}  IN  @{afterSalesRspVoList}
        ${return_order_line}  Set Variable  ${sale_rep["returnOrderLines"]}
        ${return_order_number}  Set Variable  ${null}
        FOR  ${return_line}  IN  @{return_order_line}
            IF  ${return_line["disputeId"]}!=None
                Exit For Loop
            ELSE IF  ${return_line["status"]}==19100
                ${return_order_number}  Get Json Value  ${sale_rep}  returnOrderNumber
                ${order_number}  Set Variable  ${sale_rep["orderNumber"]}
                ${dispute_dict}  Create Dictionary  orderAfterSalesItemId=${return_line["orderAfterSalesItemId"]}  quantity=${return_line["quantity"]}
                Append To List  ${dispute_items}  ${dispute_dict}
                Exit For Loop
            END
        END
        Run Keyword If  "${return_order_number}"!="None"  Exit For Loop
    END
    IF  "${return_order_number}"=="None"
        Skip  There don't have can dispute order
    END
    Buyer Get Return Order Number Detail - GET  ${return_order_number}
    Buyer Create Dispute - POST  ${order_number}  ${return_order_number}  ${dispute_items}

Test Buyer View Dispute Details
    [Documentation]  buyre view dispute detail
    [Tags]    mp-ea
    ${afterSalesRspVoList}  Buyer Get Return And Dispute List - GET
    FOR  ${sale_rep}  IN  @{afterSalesRspVoList}
        ${dispute_id}  Set Variable  ${null}
        ${return_order_line}  Set Variable  ${sale_rep["returnOrderLines"]}
        FOR  ${return_line}  IN  @{return_order_line}
            IF  ${return_line["disputeId"]}!=None
                ${dispute_id}  Set Variable  ${return_line["disputeId"]}
                Exit For Loop
            END
        END
        Run Keyword If  ${dispute_id}!=None  Exit For Loop
    END
    Run Keyword If  ${dispute_id}==None  Skip  There don't have dispute order
    Buyer View Dispute Details - GET   ${dispute_id}

Test Buyer Cancel Dispute
    [Documentation]  buyre cancel distpute
    [Tags]    mp-ea
    ${afterSalesRspVoList}  Buyer Get Return And Dispute List - GET
    FOR  ${sale_rep}  IN  @{afterSalesRspVoList}
        ${dispute_id}  Set Variable  ${null}
        ${return_order_line}  Set Variable  ${sale_rep["returnOrderLines"]}
        FOR  ${return_line}  IN  @{return_order_line}
            IF  ${return_line["disputeStatus"]}==30000
                ${dispute_id}  Set Variable  ${return_line["disputeId"]}
                Exit For Loop
            END
        END
        Run Keyword If  ${dispute_id}!=None  Exit For Loop
    END
    Run Keyword If  ${dispute_id}==None  Skip  There don't have dispute order
    Buyer Cancel Dispute - POST   ${dispute_id}

