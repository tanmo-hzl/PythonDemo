*** Settings ***
Resource            ../../Keywords/MP/ListingKeywords.robot
Suite Setup          Run Keywords    Initial Env Data  AND
...                                  Set Initial Data - Listing
Suite Teardown       Delete All Sessions

*** Variables ***
${sku}

*** Test Cases ***
Test Get Seller Listing List
    [Documentation]  get seller listing
    [Tags]    mp-ea
    Get Seller Listings List - GET

Test Get Listing Detail By sku
    [Documentation]  get listing detail
    [Tags]   mp-ea
    Run Keyword If  ${sku}==None  Skip  don't have list
    Get Seller Listing Detail  ${sku}

Test Create Listing Without Variant
    [Documentation]  create listing without variant
    [Tags]   mp-ea
    Create Listing Flow Add Listing Detail - 1
    Create Listing Flow Add Inventory And Pricing - 2
    Create Listing Flow Shipping And Return - 3
    Create Listing Flow Publish - 4

Test Create Listing With Variant
    [Documentation]  create listing with variant
    [Tags]   mp-ea
    Create Listing Flow Add Listing Detail - 1
    Create Listing Flow Add Inventory And Pricing With Variant - 2
    Create Listing Flow Shipping With Variant - 3
    Create Listing Flow Publish - 4

Test Create New Listing - Save Draft On step1
    [Documentation]  create list save draft
    [Tags]  mp-ea
    Create New Listing - Save Draft On step1

Test Create New Listing - No Variants - Save Draft On Step 2
    [Documentation]  create list save draft
    [Tags]  mp-ea
    Create Listing Flow Add Listing Detail - 1
    Create new Listing - No Variants - Save Draft On Step 2

Test Create New Listing - Have Variants - Save Draft On Step 2
    [Documentation]  create list save draft
    [Tags]  mp-ea
    Create Listing Flow Add Listing Detail - 1
    Create New Listing - Have Variants - Save Draft On Step 2

Test Create New Listing - No Variants - Save Draft On Step 3
    [Documentation]  create list save draft
    [Tags]  mp-ea
    Create Listing Flow Add Listing Detail - 1
    Create Listing Flow Add Inventory And Pricing - 2
    Create New Listing - No Variants - Save Draft On Step 3

Test Create New Listing - Have Variants - Save Draft On Step 3
    [Documentation]  create list save draft
    [Tags]  mp-ea
    Create Listing Flow Add Listing Detail - 1
    Create Listing Flow Add Inventory And Pricing With Variant - 2
    Create New Listing - Have Variants - Save Draft On Step 3


Test Update Draft Listing And Save Changes - No Variants
    [Documentation]  update draft list and save - no variant
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Draft" and "${listing["variationsNum"]}"=="0"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    ${res}  Get Seller Listing Detail  ${sku}
    ${media}  Set Variable  ${res["data"]["listing"]["media"][0]}
    Create Listing - No Variants - Save Changes  ${sku}  ${media}

Test Update Draft Listing And Publish - No Variants
    [Documentation]  update draft list and publish - no variant
    [Tags]  mp-ea   listing-update-draft
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Draft" and "${listing["variationsNum"]}"=="0"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    ${res}  Get Seller Listing Detail  ${sku}
    ${media}  Set Variable  ${res["data"]["listing"]["media"][0]}
    Create Listing - No variants - Publish    ${sku}   ${media}

Test Update Draft Listing And Save Changes - Have Variants
    [Documentation]  update draft and save - variant
    [Tags]  mp-ea  listing-update-draft
    ${listings}  Get Seller Listings List - GET
     FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Draft" and "${listing["variationsNum"]}"!="0"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    ${res}  Get Seller Listing Detail  ${sku}
    ${data}  Set Variable  ${res["data"]}
    Create Listing - Have Variants - Save Changes  ${sku}  ${data}

Test Update Draft Listing And Publish - Have Variants
    [Documentation]  update draft and publish - variant
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
     FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Draft" and "${listing["variationsNum"]}"!="0"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    ${res}  Get Seller Listing Detail  ${sku}
    ${data}  Set Variable  ${res["data"]}
    Create Listing - Have Variants - Publish  ${sku}  ${data}

Test Update Active Listing To Expired
    [Documentation]  Change Activate Listing To Inactive
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    reverse_list  ${listings}
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Active" and "${listing["variationsNum"]}"=="0"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    ${export_list}  Create List  ${sku}
    delete_file_by_name_if_exist   All_listings_${seller_store_id}
    Export All Listings - POST  ${export_list}
    ${file_path}   get_default_downloads_path
    ${new_listing_data}  update_listing_data  All_listings_${seller_store_id}.xlsx
    Import Excel Data   All_listings_${seller_store_id}.xlsx


Test Search Listing By Title or Sku
    [Documentation]  search listing
    [Tags]  mp-ea
    Search Listing By Ttitle or Sku - GET   key_word=tt

Test Export All Listings
    [Documentation]  export listing
    [Tags]  mp-ea
    ${listing}  Get Seller Listings List - GET
    ${export_list}   get_can_export_listing  ${listing[0:50]}
    delete_file_by_name_if_exist   All_listings_${seller_store_id}
    Export All Listings - POST  ${export_list}

Test Import Listing
    [Documentation]  import listing
    [Tags]  mp-ea
    Import Excel Data   All_listings_${seller_store_id}.xlsx

Test Delete Draft Listing Status
    [Documentation]  change draft listing to archived
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Draft"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    IF  ${sku}=="None"
        Create New Listing - Save Draft On step1
    END
    Delete XX Listing Status  ${sku}

Test Recover Archived Listing to Draft
    [Documentation]  chage archived listing to draft
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Archived"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    IF  ${sku}=="None"
        Create New Listing - Save Draft On step1
        Delete XX Listing Status  ${sku}
    END
    Recover Archived Listing to Draft/Inactive  ${sku}

Test Relist Inactivate Listing to Active
    [Documentation]  change inactive listing to active
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Inactive"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    IF  ${sku}=="None"
       Create Listing Without Variant
       Change Activate Listing to Inactive  ${sku}
    END
    Relist Inactivate Listing to Active  ${sku}


Test Relist Activate Listing to InActive
    [Documentation]  chanage active listing to inactive
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    reverse_list  ${listings}
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Active"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    IF  ${sku}=="None"
       Create Listing Without Variant
    END
    Change Activate Listing to Inactive   ${sku}

Test Relist Inactive Listing To Archived
    [Documentation]  change inactive listing to archive
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Inactive"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
#    Change Activate Listing to Inactive   ${sku}
    Delete XX Listing Status   ${sku}


Test Relist Archived Listing To Inactive
    [Documentation]  change archived listing to inactive
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Archived"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    Recover Archived Listing to Draft/Inactive   ${sku}


Test Relist Expired Listing To Archived
    [Documentation]  change expired listing to archived
    [Tags]  mp-ea
    ${listings}  Get Seller Listings List - GET
    FOR  ${listing}  IN  @{listings}
        IF  "${listing["status"]}"=="Expired"
            ${sku}  Set Variable  ${listing["sku"]}
            Exit For Loop
        END
    END
    Delete XX Listing Status   ${sku}


Test Create New Listing - No Variants - Inventory Zero
    [Documentation]  create zero inventory listing
    [Tags]  mp-ea
    Create Listing Flow Add Listing Detail - 1
    Create Listing Flow Add Inventory And Pricing - 2  quantity=0
    Create Listing Flow Shipping And Return - 3
    Create Listing Flow Publish - 4
