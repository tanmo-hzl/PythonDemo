*** Settings ***
Resource            ../../Keywords/MP/SllerMarketKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - Marketing
Suite Teardown       Delete All Sessions

*** Variables ***

*** Test Cases ***
Test Get Seller Promotion Listing
    [Documentation]  query seller promotion list
    [Tags]   mp-ea
    Get Seller Promotion Listing - GET

Test Create New Customer Promotion - Spend & Get - % Off
    [Documentation]  create promotion - Spend & Get - % Off
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Spend & Get - % Off - POST   ${skus}  status=enable

Test Create New Customer Promotion - Spend & Get - $ Amount Off
    [Documentation]  create promotion - Spend & Get - $ Amount Off
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Spend & Get - % Amount Off - POST   ${skus}  status=enable

Test Create New Customer Promotion - Buy & Get - % Off
    [Documentation]  create promotion - Buy & Get - % Off
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Buy & Get - % Off - POST   ${skus}  status=enable

Test Create New Customer Promotion - Buy A & Get B
    [Documentation]  create promotion - Buy A & Get B
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  3
    Create Promotion - Buy A Get B Free - POST   ${skus}  status=enable

Test Create New Customer Promotion - Percent Off
    [Documentation]   create promotion - Percent Off
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Percent Off - POST   ${skus}  status=enable

Test Create New Customer Promotion - BMSM - % Off
    [Documentation]  create promotion - BMSM - % Off
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - BMSM Off - POST   ${skus}  status=enable

Test Get Promotion List
    [Documentation]   query promotion list
    [Tags]  mp-ea
    Get Promotion List - POST  {}

Test Get Promotion List By Status
    [Documentation]  query promotion by status
    [Tags]  mp-ea
    ${status_q}  Evaluate  random.choice(["Active","Completed","Draft","Terminated","Scheduled"])
    ${filter_condition}  Create Dictionary  status_q=${status_q}
    Get Promotion List - POST  ${filter_condition}

Test Get Promotion List By Time
    [Documentation]  query promotion by time
    [Tags]  mp-ea
    ${yyyy}  ${mm}  ${dd}    Get Time    year,month,day
    ${start_time}  Set Variable  ${yyyy}-${mm}-${dd} 00:00:00
    ${end_time}  Set Variable  ${yyyy}-${mm}-${dd} 23:59:59
    ${filter_condition}  Create Dictionary  start_time=${start_time}  end_time=${end_time}
    Get Promotion List - POST  ${filter_condition}

Test Seller Stop Promation
    [Documentation]  seller sotp promotion
    [Tags]  mp-ea
    ${content}  Get Promotion List - POST  {}
    ${promotion_id}  Set Variable  ${null}}
    FOR  ${cont}  IN  @{content}
        IF  "${cont["status"]}"=="Active"
            ${promotion_id}  Set Variable  ${cont["promotionId"]}
            Seller Stop Promotion - POST  ${promotion_id}
        END
        IF  "${promotion_id}"!="None"
                Exit For Loop
            END
    END
    IF  "${promotion_id}"=="None"
        Skip  There don't have active promotion product
    END


Test Save Draft Promotion - Spend & Get - % Off
    [Documentation]  seller save draft promotion
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Spend & Get - % Off - POST   skus=${skus}   status=draft

Test Save Draft Promotion - Spend & Get - $ Amount Off
    [Documentation]  seller save draft promotion
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Spend & Get - % Amount Off - POST   ${skus}  status=draft

Test Save Draft Promotion - Buy & Get - % Off
    [Documentation]  seller save draft promotion
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Buy & Get - % Off - POST   ${skus}  status=draft

Test Save Draft Promotion - Buy A & Get B - Free
    [Documentation]  seller save draft promotion
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  3
    Create Promotion - Buy A Get B Free - POST   ${skus}  status=draft

Test Save Draft Promotion - Percent Off
    [Documentation]  seller save draft promotion
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - Percent Off - POST   ${skus}  status=draft

Test Save Draft Promotion - BMSM - % Off
    [Documentation]  seller save draft promotion
    [Tags]  mp-ea
    ${list_all}  Get Seller Promotion Listing - GET
    ${skus}  get_random_sku_list  ${list_all}  2
    Create Promotion - BMSM Off - POST   ${skus}  status=draft

Test Seller Delete Draft Promotion
    [Documentation]  seller save draft promotion
    [Tags]  mp-ea
    ${content}  Get Promotion List - POST  {"status_q":"Draft"}
    ${promotion_id}  Set Variable  ${null}}
    FOR  ${cont}  IN  @{content}
        IF  "${cont["status"]}"=="Draft"
            ${promotion_id}  Set Variable  ${cont["promotionId"]}
            Seller Delete Promotion - DELETE  ${promotion_id}
        END
        IF  "${promotion_id}"!="None"
                Exit For Loop
            END
    END
    IF  "${promotion_id}"=="None"
        Skip  There don't have draft promotion product
    END

Test Seller Edit Draft Promotion And Publish
    [Documentation]  seller edit draft promotion and publish
    [Tags]  mp-ea
    ${content}  Get Promotion List - POST  {"status_q":"Draft"}
    ${promotion_id}  Set Variable  ${null}}
    FOR  ${cont}  IN  @{content}
        IF  "${cont["status"]}"=="Draft"
            ${promotion_id}  Set Variable  ${cont["promotionId"]}
            ${list_all}  Get Seller Promotion Listing - GET
            ${skus}  get_random_sku_list  ${list_all}  2
            ${body}  get_promotion_spend_get_off_body  ${skus}
            ${body}  Set To Dictionary  ${body}   promotionId=${promotion_id}
            Seller Publish Promotion - PUT  ${body}
        END
        IF  "${promotion_id}"!="None"
                Exit For Loop
            END
    END
    IF  "${promotion_id}"=="None"
        Skip  There don't have draft promotion product
    END


