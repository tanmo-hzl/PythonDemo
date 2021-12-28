*** Settings ***
Library             ../../Libraries/Common.py
Library             ../../Libraries/B2B/RequestBodyWishlists.py
Resource            ../../TestData/B2B/PathWishlists.robot
Resource            ../../TestData/EnvData.robot
Resource            ../../TestData/B2B/UserInfo.robot
Resource            ../../Keywords/CommonRequestsKeywords.robot
Resource            ../../Keywords/B2B/UserKeywords.robot

*** Variables ***
${Michaels_User_Info}
${Headers_Michaels_Get}
${Headers_Michaels_Post}
${Wishlist_Info}
${User_Id}
${WishList_Id}
${WishList_Item_info}
${WishList_Item_Id}
${Wishlists_Length}

*** Keywords ***
Set Initial Data - B2B - Wishlists
    Initial Env Data
    Set Suite Variable    ${Cur_PWD}    ${MICHAELS_PWD}
    Michaels User Sign In Secure - POST
    ${user_id}    Get Json Value    ${Michaels_User_Info}    michaelsUser    id
    Set Suite Variable    ${User_Id}    ${user_id}

Get User Wishlists - GET
    ${res}    Send Get Request    ${URL-B2B}    /users/${User_Id}${USER_WISHLISTS_PATH}    ${NULL}    ${Headers_Michaels_Get}
    ${len}    Get Length    ${res.json()}
    Set Suite Variable     ${Wishlists_Length}    ${len}
    Set Suite Variable     ${Wishlist_Info}    ${res.json()[${len}-1]}
    ${WishList_Id}    Get Json Value     ${Wishlist_Info}    listId
    Set Suite Variable     ${WishList_Id}    ${WishList_Id}

Add User Wishlists - POST
    ${body}    Get Add Wishlists Body    ${User_Id}
    ${res}    Send Post Request    ${URL-CPM}    ${USER_WISHLISTS_PATH}    ${body}    ${Headers_Michaels_Post}
    Set Suite Variable     ${Wishlist_Info}    ${res.json()}
    ${WishList_Id}    Get Json Value     ${Wishlist_Info}    listId
    Set Suite Variable     ${WishList_Id}    ${WishList_Id}

Update Wishlists Name - PUT
    ${wishlist_name}    Evaluate    "wishlist"+str(random.randint(10,99))
    ${body}    Get Update Wishlists Body     ${wishlist_name}
    ${res}    Send Put Request    ${URL-CPM}    ${USER_WISHLISTS_PATH}/${WishList_Id}    ${body}    ${Headers_Michaels_Post}
    ${new_wishlist}    Set Variable    ${res.json()[0]}
    ${new_list_name}    Get Json Value     ${new_wishlist}     listName
    Should Be Equal As Strings    ${wishlist_name}    ${new_list_name}

Add Items To Wishlists - POST
    ${object_id}    Set Variable    MP532887
    ${body}    Get Add Items To List Body    ${WishList_Id}    ${object_id}
    ${res}    Send Post Request    ${URL-CPM}    ${USER_WISHLISTS_PATH}/${WishList_Id}${WISHLIST_ITEMS}    ${body}    ${Headers_Michaels_Post}
    ${wishlist_item}    Set Variable    ${res.json()[0]}
    ${item_object_id}    Get Json Value    ${wishlist_item}    objectId
    Should Be Equal As Strings    ${object_id}    ${item_object_id}

Get Wishlists Item - GET
    ${res}    Send Get Request    ${URL-B2B}    /users/${User_Id}${USER_WISHLISTS_PATH}/${WishList_Id}    ${null}    ${Headers_Michaels_Get}
    ${len}    Get Length    ${res.json()}
    Run Keyword If    ${len}>0    Get Wishlists Item Info    ${res}    ELSE    Log    The Wishlists is Null

Get Wishlists Item Info
    [Arguments]    ${res}
    Set Suite Variable    ${WishList_Item_info}    ${res.json()[0]}
    ${WishList_Item_Id}    Get Json Value    ${WishList_Item_info}    listItemId
    Set Suite Variable    ${WishList_Item_Id}    ${WishList_Item_Id}

Remove Items From Wishlists - DELETE
    ${body}    Create Dictionary    wishlistItemIds    ${WishList_Item_Id}
    ${res}    Send Delete Request - Params    ${URL-CPM}    ${USER_WISHLISTS_PATH}/${WishList_Id}${WISHLIST_ITEMS}    ${body}    ${Headers_Michaels_Post}    204

Remove Wishlists - DELETE
    ${res}    Send Delete Request    ${URL-CPM}    ${USER_WISHLISTS_PATH}/${WishList_Id}    ${NULL}    ${Headers_Michaels_Post}    204
    ${res_list}    Send Get Request    ${URL-B2B}    /users/${User_Id}${USER_WISHLISTS_PATH}    ${NULL}    ${Headers_Michaels_Get}
    ${len}    Get Length    ${res_list.json()}
    Should Be Equal As Strings    ${Wishlists_Length}    ${len}







