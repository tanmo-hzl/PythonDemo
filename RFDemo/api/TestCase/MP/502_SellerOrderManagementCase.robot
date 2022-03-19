*** Settings ***
Resource            ../../Keywords/MP/OrderManagementKeywords.robot
Resource            ../../Keywords/MP/BuyerReturnAndDisputeKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - OrderManagement  AND
...                                  Set Initial Data - BuyerReturn
Suite Teardown       Delete All Sessions


*** Test Cases ***
Test Get Order Overview Listing
    [Documentation]  get seller listing overview,statues=3000 is Pending Confirmation
    [Tags]    mp-ea
    Get Order Overview List - GET  ${null}

Test Get Seller Order Detail
    [Documentation]  get seller order detail
    [Tags]    mp-ea
    ${order_content}   Get Order Overview List - GET   ${null}
    ${order_number}  Get Json Value  ${order_content}   orderNumber
    Get Seller Order Detail - GET  ${order_number}

Test Seller Confirm pending Confirmation Order
    [Documentation]  seller confirm pending confirm order
    [Tags]    mp-ea
    ${order_content}   Get Order Overview List - GET   statuses=3000
    ${order_number}  Get Json Value  ${order_content}   orderNumber
    Confirm pending Confirmation Order - POST  ${order_number}

Test Seller Ship Item For Ready To Ship Order
    [Documentation]  sller shiping item
    [Tags]    mp-ea  ship_item
    ${order_content}   Get Order Overview List - GET   statuses=3500
    ${order_number}  Get Json Value  ${order_content}   orderNumber
    ${order_detail}  Get Seller Order Detail - GET  ${order_number}
    ${order_lines}  Set Variable  ${order_detail["data"]["orderLines"]}
    Ship Item For Ready To Ship Order - POST  ${order_number}  ${order_lines}

Test Seller Cancel Item
    [Documentation]  sller cancel order
    [Tags]    mp-ea
    ${order_content}   Get Order Overview List - GET   statuses=3000
    ${order_number}  Get Json Value  ${order_content}   orderNumber
    ${order_detail}  Get Seller Order Detail - GET  ${order_number}
    ${order_lines}  Set Variable  ${order_detail["data"]["orderLines"]}
    Seller Cancel Item - POST  ${order_number}  ${order_lines}

Test Seller Download Order Export
    [Documentation]  seller download order export
    [Tags]    mp-ea
    Seller Download Order Export - GET  status=3000,6800

Test Get Seller Return List
    [Documentation]  query seller return list
    [Tags]    mp-ea
    Get Seller Return List - Get    ${null}


Test Seller Full Refund
    [Documentation]  seller full refund order
    [Tags]    mp-ea
    ${contents}  Get Seller Return List - Get   statuses=11000,10500,17000
    ${return_order_number}   Set Variable   ${null}
    FOR  ${content}  IN  @{contents}
        IF  ${content["status"]} in [11000,10500,17000]
            ${return_order_number}  Set Variable  ${content["returnOrderNumber"]}
            Exit For Loop
        END
    END
    IF  "${return_order_number}"=="None"
        Skip   There don't have pending return order
    END
    ${res}  Get Seller Return Order Detail - GET  ${return_order_number}
    ${return_order_lines}  Get Json Value   ${res}  data  returnOrderLines
    ${approve_items}    Create List
    FOR  ${returnline}  IN   @{return_order_lines}
         IF  '${returnline['status']}'=='11000'
            ${orderAfterSalesItemId}  Set Variable  ${returnline["orderAfterSalesItemId"]}
            ${items}  Create Dictionary   orderAfterSalesItemId=${orderAfterSalesItemId}  action=approveRefund
            Append To List   ${approve_items}   ${items}
         END
    END
    Seller Process Refund - POST  return_order_number=${return_order_number}   action_items=${approve_items}


Test Seller No Refund
    [Documentation]  seller reject refund
    [Tags]    mp-ea
    ${contents}  Get Seller Return List - Get  statuses=11000,10500,17000
    ${content_length}  Get Length  ${contents}
    IF  "${content_length}"=="0"
        Buyer Create Return Order
        Sleep  3
        ${contents}  Get Seller Return List - Get  statuses=11000,10500,17000
    END
    ${return_order_number}   Set Variable   ${null}
    FOR  ${content}  IN  @{contents}
        IF  ${content["status"]} in [11000,10500,17000]
            log  ${content["status"]}
            ${return_order_number}  Set Variable  ${content["returnOrderNumber"]}
            Exit For Loop
        END
    END
    IF  "${return_order_number}"=="None"
        Skip   There don't have pending return order
    END
    ${res}  Get Seller Return Order Detail - GET  ${return_order_number}
    ${return_order_lines}  Get Json Value   ${res}  data  returnOrderLines
    ${reject_items}    Create List
    FOR  ${returnline}  IN   @{return_order_lines}
         log   ${returnline['status']}
         IF  '${returnline['status']}'=='11000'
            ${orderAfterSalesItemId}  Set Variable  ${returnline["orderAfterSalesItemId"]}
            ${items}  Create Dictionary   orderAfterSalesItemId=${orderAfterSalesItemId}  action=rejectRefund
            Append To List   ${reject_items}   ${items}
         END
    END
    Seller Process Refund - POST  return_order_number=${return_order_number}   action_items=${reject_items}

Test Get Seller Dispute List
    [Documentation]  query seller dispute list
    [Tags]    mp-ea
    Get Seller Dispute List - Get  ${null}

Test Seller Get Dispute Detail
    [Documentation]  query dispute detail
    [Tags]    mp-ea
    ${content}  Get Seller Dispute List - Get   ${null}
    ${dispute_id}  Get Json Value  ${content}   id
    Seller Get Dispute Detail - GET  ${dispute_id}


Test Seller View Dispute Status Is Open
    [Documentation]  seller view open dispute
    [Tags]    mp-ea
    ${content}  Get Seller Dispute List - Get   statuses=30000
    ${dispute_id}  Get Json Value  ${content}   id
    IF  ${dispute_id}==None
        ${res}  Buyer Get Return And Dispute List And Create Dispute
        ${dispute_id}  Get Json Value  ${res}  data   disputeId
    END
    Seller View Dispute Status Is Open - POST  ${dispute_id}

Test Seller Make Decision For Dispute - REJECT
    [Documentation]  sleler reject dispute
    [Tags]    mp-ea
    ${content}  Get Seller Dispute List - Get   statuses=30100
    ${dispute_id}  Get Json Value  ${content}   id
    Run Keyword If  ${dispute_id}==None   Test Seller View Dispute Status Is Open
    ${dispute_detail}  Seller Get Dispute Detail - GET  ${dispute_id}
    ${order_item_id}  Get Json Value  ${dispute_detail}  disputeItems  orderItemId
    Seller Make Decision For Dispute - POST   ${dispute_id}   ${order_item_id}  offer_type=NO_OFFER


Test Seller Make Decision For Dispute - REFUND
    [Documentation]  seller approve dispute
    [Tags]    mp-ea
    ${content}  Get Seller Dispute List - Get   statuses=30100
    ${dispute_id}  Get Json Value  ${content}   id
    Run Keyword If  ${dispute_id}==None   Test Seller View Dispute Status Is Open
    ${dispute_detail}  Seller Get Dispute Detail - GET  ${dispute_id}
    ${order_item_id}  Get Json Value  ${dispute_detail}  disputeItems  orderItemId
    Seller Make Decision For Dispute - POST   ${dispute_id}   ${order_item_id}  offer_type=REFUND


Test Seller Make Decision For Dispute - PARTIAL_REFUND
    [Documentation]  seller partial approve distpue
    [Tags]    mp-ea
    ${content}  Get Seller Dispute List - Get   statuses=30100
    ${dispute_id}  Get Json Value  ${content}   id
    Run Keyword If  ${dispute_id}==None   Test Seller View Dispute Status Is Open
    ${dispute_detail}  Seller Get Dispute Detail - GET  ${dispute_id}
    ${order_item_id}  Get Json Value  ${dispute_detail}  disputeItems  orderItemId
    Seller Make Decision For Dispute - POST   ${dispute_id}   ${order_item_id}  offer_type=PARTIAL_REFUND


#Test for range
#    [Tags]   kk
#    FOR  ${index}  IN RANGE  4
#        log  hahah
#    END

