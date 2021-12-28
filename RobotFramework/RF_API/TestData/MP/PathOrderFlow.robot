*** Variables ***

${mik-store-listing}                /store/5903673032166146048/listings
${mik-product-detail}               /cms/product/v2/skus
${mik-user-cart}                    /cpm/carts     # get user cart id
# GET/POST/PUT/DELETE   get cart items / add items to cart / Change items quantity / remvoe item from cart
${mik-cart-items}                   /cpm/carts

${mik-user-address}                 /usr/user/address
${mik-shipping-checkout-summary}    /cpm/shipping/checkout-summary/shippingMethodsSummary

${mik-usps-verify}                  /usr/usps/verify
${mik-checkout-initiate}            /cpm/v2/checkout/initiate
${mik-shipping-delivery-date}       /cpm/shipping/getDeliveryDateForMikOrEa

${mik-fin-pie}                      /fin/pie
${mik-fin-wallet-add}               /fin/wallet/add
${mik-fin-wallet-bankcard}          /fin/wallet/bankcard
${mik-fin-wallet-gift-card}         /fin/wallet/gift-card/990660001283013

${mik-checkout-submit-order}        /cpm/v2/checkout/submit-order
${mik-buyer-order-list}             /moh/order/v5/buyer/parentOrderList/simple/page?currentPage=0&pageSize=10&parentOrderNumberList=
${mik-buyer-order-detail}           /moh/order/v5/buyer/parentOrderList/single

${mik-after-sales-order-check}      /moh/afterSales/order/cancel/check
${mik-buyer-cancel-order}           /moh/afterSales/order/buyer/cancelOrder

${mik-seller-order-by-keywords}     /sch/search/sellerOrders/byKeywords
${mik-seller-order-list-page}       /moh/order/v5/seller/orderList/page?currentPage=0&pageSize=10&simpleMode=true&channel=2
${mik-seller-order-detail}          /moh/order/v5/seller/single
${mik-seller-cancel-order}          /moh/afterSales/order/seller/cancelOrder
${mik-seller-confirm-order}         /moh/order/v5/seller/ReadyToShip/ByOrderNumber

${mik-seller-order-estimate}        /fgm/order/estimate?orderNumber=THP8109051204375870-1
${mik-seller-order-shipment}        /moh/order/v3/seller/shipments/add


${mik-seller-after-sales-order-list}      /moh/afterSales/return/seller/list/page
${mik-seller-after-sales-order-detail}    /moh/afterSales/return/seller/single/getByReturnOrderNumber

${mik-returns-order-processRefund}        /moh/afterSales/return/seller/processRefund

${mik-dispute-detail}                     /rsc/disputes/5912346804519346176
${mik-dispute-in-progress}                /rsc/disputes/5912346804519346176/in-progress    # {"disputeId":"5912346804519346176"}
${mik-dispute-make-offer}                 /rsc/disputes/5912346804519346176/make-offer


${mik-buyer-return-order-check}             /moh/afterSales/return/buyer/list/page
${mik-buyer-return-order-create}            /moh/returns/buyer/create
${mik-buyer-return-order-list}              /moh/afterSales/return/buyer/list/page?returnOrderNumber=R5912308802649120769&userId=427710090280997
${mik-buer-return-order-detail}             /moh/afterSales/return/buyer/single/getByReturnOrderNumber/R5912308802649120769
${mik-buyer-order-dispute-create}           /rsc/disputes/batchCreateAfterSalesDispute