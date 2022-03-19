*** Settings ***
Library         ../../Libraries/CommonLibrary.py
Resource        ../../Keywords/Common/CommonKeywords.robot
Resource        ../../Keywords/MP/SellerOrderManagementKeywords.robot
Resource        ../../Keywords/MP/SellerReturnsKeywords.robot
Resource        ../../Keywords/MP/SellerDisputesKeywords.robot
Resource        ../../Keywords/MP/SellerListingKeywords.robot
Resource        ../../Keywords/Common/MenuKeywords.robot
Resource        ../../TestData/EnvData.robot
*** Variables ***
&{Business_Actions_Info}
${Store_Activities_Info}


*** Keywords ***
Seller Dashboard - Get Page Info
    ${listing_info}    Create Dictionary
    ${product_listings}      Create List    Active    Inactive    Prohibited    Drafted    Out of Stock    Pending Review
    FOR    ${item}    IN    @{product_listings}
        ${text}    Get Text    //p[text()="${item}"]/following-sibling::p
        Set To Dictionary    ${listing_info}    ${item}=${text}
    END
    Set To Dictionary    &{Business_Actins_Info}    listing_info=${listing_info}
    ${order_info}    Create Dictionary
    ${order_list}      Create List    Pending Confirmation    Ready to Ship    Partially Shipped    Pending Return
    ...    Pending Refund    Dispute Opened    Waiting for Seller’s Action    Dispute Escalated
    FOR    ${item}    IN    @{order_list}
        ${text}    Get Text    //p[text()="${item}"]/following-sibling::p
        Set To Dictionary    ${order_info}    ${item}=${text}
    END
    Set To Dictionary    &{Business_Actins_Info}    order_info=${order_info}
    ${marketing_info}    Create Dictionary
    ${marketing_list}      Create List    Active    Scheduled    Completed    Drafted    Stopped
    FOR    ${item}    IN    @{marketing_list}
        ${text}    Get Text    //p[text()="${item}"]/following-sibling::p
        Set To Dictionary    ${marketing_info}    ${item}=${text}
    END
    Set To Dictionary    &{Business_Actins_Info}    marketing_info=${marketing_info}