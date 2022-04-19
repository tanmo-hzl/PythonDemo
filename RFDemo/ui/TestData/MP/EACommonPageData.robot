*** Variables ***
${SELLER_BASE_URL}      /mp/sellertools
&{SELLER_URLS}          das=/dashboard              msg=/messages                   ast=/account-settings
...                     msf=/my-storefront          spr=/store-profile              cus=/customer-service
...                     fui=/fulfillment-info       rep=/return-policy              mpr=/product-groups
...                     lst=/listing-management     ovr=/overview                   ret=/returns
...                     dis=/disputes               mak=/marketing-overview         fio=/finance-overview
...                     deo=/deposit-options        fit=/finance-transactions       tax=/tax-information
...                     rep=/reports


${BUYER_BASE_URL}       /buyertools
&{BUYER_URLS}           das=/dashboard              msg=/messages                   pro=/profile
...                     ast=/account-settings       wal=/wallet                     mlt=/my-lists
...                     brh=/browsing-history       orh=/order-history              sus=/subscription
...                     mre=/rewards/my-rewards     cou=/coupons                    ref=/referrals
...                     rad=/return-and-dispute     cal=/calendar

&{COMMON_URLS}          crt=/cart

${Filter_Btn_Ele}       //*[contains(text(),"Filter")]
${Filter_Btn_Ele1}       //p[contains(text(),"Filter")]/following-sibling::button
${Filter_Clear_All}     //*[(text()="Clear All")]
${Filter_View_Results}     //*[(text()="View Results")]