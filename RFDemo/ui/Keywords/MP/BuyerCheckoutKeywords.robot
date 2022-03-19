*** Settings ***
Library             ../../Libraries/CommonLibrary.py
Library             ../../Libraries/MP/BuyerCheckoutLib.py
Resource            ../../Keywords/Common/CommonKeywords.robot
Resource            ../../Keywords/MP/SellerStoreFrontKeywords.robot
Resource            ../../Keywords/Common/ProductKeywords.robot
Resource            ../../Keywords/Common/CheckoutKeywords.robot
Resource            ../../Keywords/Common/CartsKeywords.robot
Resource            ../../Keywords/MP/EAInitialDataAPiKeywords.robot

*** Keywords ***
Go To Home Page
    [Arguments]    ${status}=DONE
    IF   '${status}'=='FAIL'
        ${now_url}   Get Location
        IF    '${now_url}'!='${URL_MIK}'
            Go To    ${URL_MIK}
        ELSE
            Reload Page
        END
    ELSE IF   '${status}'=='DONE'
        Go To    ${URL_MIK}
        END

Buyer Chekcout - Search Product And Enter PDP
    ${product_info}    Get Random Active Listing    ${ENV}
    Product - Search Product By Product Name    ${product_info}[title]
    Product - Enter Product Detail Page     ${product_info}[title]

Buyer Chekcout - Flow - From Search To Checkout
    Buyer Chekcout - Search Product And Enter PDP
    Product - Add Item To Cart On Product Detail Page
    Product - Eneter Cart Page After Add Item To Cart
    Checkout - Flow - Proceed To Payment To Place

Buyer Chekcout - Flow - Select Listing From Seller Store Front Then Checkout
    [Arguments]    ${listing_number}=1    ${quantity}=1
    Shipping Cart - Remove All Items From Cart If Existed
    ${item}    Set Variable
    ${index}   Set Variable    1
    ${listing_urls}    API - Get Listing Url By Quantity Status And Variants    ${${listing_number}*2}
    FOR    ${item}    IN     @{listing_urls}
#        Store Front - Go To Seller Store Front Page
#        ${listing_index}    Evaluate    ${index}+1
#        Store Front - Select Random Listing Enter Detail Page    ${listing_index}
        Go To    ${URL_MIK}/product/${item}
        Wait Until Element Is Visible    //p[text()="Sold and shipped by"]
        Sleep    1
        ${count}     Get Element Count    //div[text()="ADD TO LIST"]/parent::button[@disabled]
        Continue For Loop If    ${count}==1
        Product - Quantity Update On Product Detail Page    ${quantity}
        Product - Add Item To Cart On Product Detail Page
        ${index}    Evaluate    ${index} + 1
        Exit For Loop If    ${index}>${listing_number}
    END
#    Product - Eneter Cart Page After Add Item To Cart
    Go To    ${URL_MIK}/cart
    Checkout - Flow - Proceed To Payment To Place
