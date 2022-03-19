import os
import random
import time
from typing import Optional


class RequestBodyOrderFlow(object):
    def __init__(self):
        self.root_path = self.__get_root_path()

    @staticmethod
    def __get_root_path():
        abspath = os.path.dirname(os.path.abspath(__file__))
        root_path = os.path.dirname(os.path.dirname(abspath))
        return root_path

    @staticmethod
    def get_active_listing(data, variation: Optional):
        if variation == "False":
            items = []
            for item in data:
                if (
                    item.get("status") == "Active"
                    and int(item.get("inventory")) > 0
                    and item.get("variationsNum") == 0
                ):
                    items.append(item)
            return items
        elif variation == "True":
            items = []
            for item in data:
                if (
                    item.get("status") == "Active"
                    and int(item.get("inventory")) > 0
                    and item.get("variationsNum") != 0
                ):
                    items.append(item)
            return items
        else:
            items = []
            for item in data:
                if item.get("status") == "Active" and int(item.get("inventory")) > 0:
                    items.append(item)
            return items

    @staticmethod
    def get_product_detail_body(sku_number, store_id=None):
        body = {
            "skuNumbers": sku_number,
            "michaelsStoreId": store_id,
            "needPromotion": True,
            "needPrice": True,
            "needInventory": True,
        }
        return body

    @staticmethod
    def get_cart_items_add_body(
        user_id, cart_id, sku_number, sub_sku_number, quantity: Optional[int] = 1
    ):
        body = {
            "cartItems": [
                {
                    "skuNumber": sku_number,
                    "subSkuNumber": sub_sku_number,
                    "shipMethod": 0,
                    "isSelected": False,
                    "isGift": False,
                    "quantity": quantity,
                    "canSchedule": False,
                    "itemType": 1,
                    "scheduleId": None,
                    "bundleSkus": [],
                    "bundleSkuCounts": [],
                    "cartItemGifts": [],
                    "userId": user_id,
                    "shoppingCartId": cart_id,
                    "intervalSeconds": None,
                }
            ]
        }
        return body

    @staticmethod
    def get_change_cart_item_quantity_body(cart_id, item_id, quantity):
        body = {
            "cartId": cart_id,
            "itemId": item_id,
            "quantity": quantity,
            "type": "editNum",
        }
        return body

    @staticmethod
    def get_shipping_checkout_summary_body(store_id, product_info_list: list):
        pro_info_list = []
        for product_info in product_info_list:
            pro_info = {
                "sku": product_info.get("sku"),
                "quantity": product_info.get("quantity"),
                "shoppingItemId": product_info.get("shoppingItemId"),
            }
            pro_info_list.append(pro_info)
        body = [
            {
                "channel": "THP",
                "productInfoList": pro_info_list,
                "shippingAddress": {
                    "firstName": "Test",
                    "lastName": "Auto",
                    "businessName": "",
                    "attention": "",
                    "addressLine1": "1051 E Southlake Blvd",
                    "addressLine2": "",
                    "city": "SOUTHLAKE",
                    "state": "TX",
                    "zipcode": "76092",
                    "countryId": "US",
                },
                "storeId": store_id,
            }
        ]
        return body

    @staticmethod
    def get_usr_usps_verify_body():
        body = {
            "addressLine1": "554 Lexington Ave",
            "addressLine2": "",
            "city": "New York",
            "state": "NY",
            "zipCode": "10022",
        }
        return body

    @staticmethod
    def get_checkout_initiate_body(shipping_method_res):
        sub_order_infos = []
        sub_order = {"channelType": "THP"}
        item_details = []
        for sub_order_info in shipping_method_res:
            skus = sub_order_info.get("skus")
            store_id = sub_order_info.get("storeId")
            for sku in skus:
                sub_items = {
                    "shoppingCartItemId": sku.get("shoppingItemId"),
                    "quantity": sku.get("quantity"),
                }
                item_details.append(sub_items)
            sub_order["storeId"] = store_id
            sub_order["shippingMethod"] = {
                "shippingMethodType": sub_order_info.get("shippingMethodsAndCostsList")[
                    0
                ]["shippingMethod"]
            }
            sub_order["itemDetails"] = item_details
            sub_order["giftFrom"] = None
            sub_order["giftMessage"] = None
            sub_order["chosenGift"] = []
        sub_order_infos.append(sub_order)
        body = {
            "areaCode": "US",
            "couponCodes": [],
            "ackTaxExempt": True,
            "shippingAddressInfo": {
                "firstName": "Test",
                "lastName": "Auto",
                "addressLine1": "554 Lexington Ave",
                "addressLine2": "",
                "email": "peselak@snapmail.cc",
                "phoneNumber": "3333333333",
                "sameAsShipping": False,
                "city": "New York",
                "state": "NY",
                "countryId": "US",
                "zipCode": "10022",
                "zipcode": "10022",
            },
            "subOrderInfos": sub_order_infos,
        }
        return body

    @staticmethod
    def get_checkout_submit_order_body(buyer_info, initiate_data, wallet_bankcard):
        print(buyer_info)
        print(initiate_data)
        print(wallet_bankcard)
        user = buyer_info.get("user")
        card_type = {1: "Visa", 2: "MasterCard", 3: "Amex", 4: "Discover"}
        creditCardPayment = {
            "payment": "CREDIT_CARD",
            "billingAddressInfo": {
                "firstName": user.get("firstName"),
                "lastName": user.get("lastName"),
                "addressLine1": "1051 E Southlake Blvd",
                "addressLine2": "",
                "city": "SOUTHLAKE",
                "state": "TX",
                "countryId": "US",
                "zipcode": wallet_bankcard.get("zipCode"),
                "zipCode": wallet_bankcard.get("zipCode"),
                "phoneNumber": wallet_bankcard.get("telephone"),
                "email": user.get("email"),
                "sameAsShipping": False,
                "addressType": "billing",
            },
            "cardReferenceNumber": wallet_bankcard.get("cardRefNum"),
            "cardLastFour": wallet_bankcard.get("tailNumber"),
            "expirationMonth": wallet_bankcard.get("expirationDate")[:2],
            "expirationYear": wallet_bankcard.get("expirationDate")[2:],
            "cardType": card_type[
                wallet_bankcard.get("cardChannelType")
            ],  # accept [Visa, MasterCard, Amex, Discover]
            "nameOnCard": "",
            "currency": "USD",
        }
        shippingAddressInfo = {
            "firstName": user.get("firstName"),
            "lastName": user.get("lastName"),
            "addressLine1": "554 Lexington Ave",
            "addressLine2": "",
            "city": "New York",
            "state": "NY",
            "countryId": "US",
            "zipcode": "10022",
            "zipCode": "10022",
            "phoneNumber": "3333333333",
            "email": user.get("email"),
            "sameAsShipping": True,
            "addressType": "billing",
        }
        # initiate_data["giftCartPayments"] = []
        initiate_data["shippingAddressInfo"] = shippingAddressInfo
        initiate_data["timeZone"] = "GMT+0800"
        initiate_data["voucherPayments"] = []
        initiate_data["creditCardPayment"] = creditCardPayment

        return initiate_data

    @staticmethod
    def get_wallet_bankcard_add_body(buyer_info):
        user = buyer_info.get("user")
        body = {
            "user": {"ownerType": "1", "userId": user.get("id")},
            "bankCardNickName": "Discover",
            "accountNumber": "6120762111040009",
            "expirationDate": "0834",
            "securityCode": "886",
            "holderName": "Discover",
            "pieKeyID": "22b49190",
            "piePhaseID": "0",
            "pieIntegrityCheck": "f1d22dfc90a93b94",
            "cardBrandType": "DI",
            "defaultCard": "0",
            "billingAddress": {
                "firstName": user.get("firstName"),
                "lastName": user.get("lastName"),
                "addressLine1": "554 Lexington Ave",
                "addressLine2": "",
                "city": "New York",
                "state": "NY",
                "zipCode": "10022",
                "countryId": "US",
                "telephone": "333" + random.randint(100000, 999999),
            },
        }
        return body

    def get_shipping_delivery_date(self, store_id, sku_number):
        address = self.get_usr_usps_verify_body()
        body = {
            "productList": [
                {"skuNumber": sku_number, "channel": 2, "storeId": store_id}
            ],
            "addressInfo": {
                "city": address.get("city"),
                "state": address.get("state"),
                "zipCode": address.get("zipCode"),
            },
            "localTime": {
                "timeInMillis": str(time.time() * 1000),
                "timeZone": "GMT+0800",
            },
        }
        return body

    @staticmethod
    def get_after_sales_order_check_body():
        body = {
            "userType": "BUYER",
            "order": {
                "parentOrderNumber": "6420505370208535",
                "grandTotalCollected": 14.14,
                "grandCollectedTotalBeforeDiscount": 14.14,
                "totalDiscount": 0,
                "estimatedTax": 1.15,
                "createdTime": "1635643831029",
                "shippingFeeAndHandlingFee": 3,
                "itemsSubtotal": 9.99,
                "extraCharge": 0,
                "subOrders": [
                    {
                        "orderNumber": "THP6420505370208535-1",
                        "storeId": "5903673032166146048",
                        "sellerId": "-1",
                        "orderChecksum": None,
                        "orderType": 2,
                        "cancelReason": "",
                        "parentOrderNumber": "6420505370208535",
                        "receiptNumber": "5908852144249839617",
                        "channel": 2,
                        "organizationId": None,
                        "parentOrganizationId": None,
                        "organizationName": None,
                        "purchaseOrderNumber": None,
                        "userId": "990660001283013",
                        "userType": 1,
                        "storeName": "Company KVw",
                        "firstName": "Test",
                        "lastName": "Auto",
                        "lastPullTime": None,
                        "phone": "3333333333",
                        "customerEmail": "at-kvw@snapmail.cc",
                        "currency": "USD",
                        "estimatedTax": 1.15,
                        "merchandiseTax": 0.89,
                        "itemsSubtotal": 9.99,
                        "shippingHandlingCharge": 3,
                        "partialRefundTotal": 0,
                        "grandTotalCollected": 14.14,
                        "totalDiscount": 0,
                        "allDiscount": 0,
                        "status": 3000,
                        "refundedAmount": 0,
                        "shippingLabelCost": 0,
                        "shippingFirstName": "Test",
                        "shippingLastName": "Auto",
                        "shippingPhone": None,
                        "shippingEmail": None,
                        "cancelledTax": 0,
                        "cancelledAmount": 0,
                        "gift": 0,
                        "giftMessage": None,
                        "giftFrom": None,
                        "shipFromLocationId": None,
                        "barCode": "5908852144249839618",
                        "postBox": "",
                        "shippingLabel": None,
                        "suite": "",
                        "address1": "554 Lexington Ave",
                        "address2": "",
                        "city": "New York",
                        "state": "NY",
                        "countryCode": "US",
                        "zipCode": "10022",
                        "isTaxExempt": False,
                        "taxExemptId": None,
                        "customerAccountNumber": None,
                        "parentCustomerAccountNumber": None,
                        "salesRepId": None,
                        "refundedTax": 0,
                        "serviceLevel": "30001",
                        "carrier": "0",
                        "valuable": 0,
                        "easTag": 0,
                        "ageRestricted": 0,
                        "businessName": None,
                        "attention": None,
                        "aftersalesStatus": 0,
                        "returnValue": 9.99,
                        "taxReturnValue": 0.89,
                        "appeasementDiscount": 0,
                        "appeasementDiscountTax": 0,
                        "refundedShippingFee": 0,
                        "refundedShippingTax": 0,
                        "shippingFeeReturnValue": 3,
                        "shippingTaxReturnValue": 0.26,
                        "handlingFeeReturnValue": 0,
                        "handlingTaxReturnValue": 0,
                        "refundedHandlingFee": 0,
                        "refundedHandlingTax": 0,
                        "handlingFee": 0,
                        "handlingTax": 0,
                        "shippingFee": 3,
                        "shippingTax": 0.26,
                        "extraCharge": 0,
                        "extraChargeTax": 0,
                        "subscriptionDiscount": 0,
                        "loyaltyId": "",
                        "promiseShipDate": "1635903030971",
                        "promiseDeliveryDate": "1635903030971",
                        "inManhattan": 0,
                        "isShopScan": 0,
                        "deliveryInstruction": None,
                        "b2bDiscount": 0,
                        "smsPreference": 0,
                        "createdTime": "1635643831029",
                        "updatedTime": "1635644401024",
                        "taxExempt": False,
                        "invoiceVo": None,
                        "orderLines": [
                            {
                                "orderItemId": "5908852144249839619",
                                "storeId": "5903673032166146048",
                                "taxExempt": False,
                                "taxExemptId": None,
                                "userId": "990660001283013",
                                "skuNumber": "5905979051646894080",
                                "itemType": 2,
                                "releaseId": "0",
                                "releaseLineId": "0",
                                "orderLineId": 1,
                                "gift": 0,
                                "giftMessage": None,
                                "giftFrom": None,
                                "uom": "EA",
                                "adjust": 0,
                                "itemDescription": "",
                                "returnAvailableQuantity": 0,
                                "manual": None,
                                "quantity": 1,
                                "thumbnail": "https://imgproxy.tst02.platform.michaels.com/XXTpt9MjeIKtJwhEo-W6WCFk1c9-K_Ll4qb5g7o5vco/aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL2Ntcy1taWstdHN0MDIvNTkwNTk4MzkzMDcyOTc1MDUyOA.webp",
                                "productName": "Boutique wooden comb",
                                "rating": 0,
                                "originalPrice": 9.99,
                                "commissionFee": 1.5,
                                "commissionRate": 0.15,
                                "originalCommissionRate": 0,
                                "shippingHandlingCharge": 0,
                                "refundedAmount": 0,
                                "refundedTax": 0,
                                "cancelledTax": 0,
                                "cancelledAmount": 0,
                                "completeTime": None,
                                "completeStatus": 0,
                                "itemSubtotal": 9.99,
                                "estimatedTax": 0.89,
                                "merchandiseTax": 0.89,
                                "totalDiscount": 0,
                                "price": 9.99,
                                "shippingLabelCost": 0,
                                "extraCharge": 0,
                                "refundedShippingFee": 0,
                                "refundedShippingTax": 0,
                                "shippingFeeReturnValue": 0,
                                "shippingTaxReturnValue": 0,
                                "taxReturnValue": 0.89,
                                "expectedShipDate": "1635903030971",
                                "personalizationNotes": None,
                                "externalId": "",
                                "classId": None,
                                "avsResidential": "C",
                                "bulkFlag": 0,
                                "promiseDeliveryDate": None,
                                "itemChannel": 2,
                                "itemName": "",
                                "taxation": 0,
                                "hazmat": False,
                                "refundable": 0,
                                "cancelDeadline": "1635647431029",
                                "returnDeadline": "1638239430971",
                                "status": 3000,
                                "aftersalesStatus": 0,
                                "bundleSkuNumber": None,
                                "extraChargeTax": 0,
                                "masterSkuNumber": "5905979051646894080",
                                "customerType": None,
                                "returnValue": 9.99,
                                "itemGrandTotalCollected": 10.88,
                                "affiliateCommission": 0,
                                "processingFee": 0,
                                "commissionDiscount": 0,
                                "benefitDiscount": 0,
                                "handlingFee": 0,
                                "handlingTax": 0,
                                "shippingFee": 0,
                                "shippingTax": 0,
                                "fulfilledQuantity": 0,
                                "categoryId": None,
                                "voucherDiscount": 0,
                                "projectAffiliate": False,
                                "instructorName": None,
                                "productClass": "100",
                                "classLink": None,
                                "classLocation": None,
                                "returnPolicy": 1,
                                "valuable": 0,
                                "easTag": 0,
                                "leadTime": 0,
                                "ageRestricted": 0,
                                "b2bDiscount": 0,
                                "orderBundleInfoId": None,
                                "processingRate": 0,
                                "subscriptionType": 0,
                                "giftParentOrderItemId": None,
                                "subscriptionDiscount": 0,
                                "upcNumber": None,
                                "classStartTime": None,
                                "classEndTime": None,
                                "createdTime": "1635643831029",
                                "updatedTime": "1635644401032",
                                "originalStatus": None,
                                "cancelQuantity": None,
                                "shipmentWaitingDay": None,
                                "inventoryQuantity": None,
                                "variance": [
                                    {"varianceName": "Color", "varianceValue": None},
                                    {"varianceName": "Size", "varianceValue": None},
                                    {"varianceName": "Weight", "varianceValue": "0.2"},
                                    {"varianceName": "Length", "varianceValue": "1"},
                                    {"varianceName": "Width", "varianceValue": "1"},
                                    {"varianceName": "Height", "varianceValue": "1"},
                                    {
                                        "varianceName": "WeightUnit",
                                        "varianceValue": "in",
                                    },
                                    {
                                        "varianceName": "VolumeUnit",
                                        "varianceValue": "Cu in",
                                    },
                                ],
                                "orderShippingTaxVos": None,
                                "orderItemCoupons": None,
                                "shipments": [],
                                "orderPickup": None,
                                "cancelReason": "",
                            }
                        ],
                        "shipments": [],
                        "orderBillingAddresses": {
                            "orderBillingAddressId": "5908852144249839621",
                            "orderNumber": "THP6420505370208535-1",
                            "userId": "990660001283013",
                            "postBox": "",
                            "suite": "",
                            "address1": "ww1",
                            "address2": "",
                            "city": "d",
                            "state": "AL",
                            "countryCode": "US",
                            "zipCode": "12706",
                            "firstName": "Test",
                            "fullName": "Test Auto",
                            "lastName": "Auto",
                            "phone": "3333333333",
                            "email": None,
                            "createdTime": "1635643831029",
                            "updatedTime": "1635643831029",
                        },
                        "orderPickup": None,
                        "paymentTransactions": [
                            {
                                "orderPaymentTransactionId": "5908852144249839620",
                                "paymentTransactionId": "5908852109889658882",
                                "orderNumber": "THP6420505370208535-1",
                                "userId": "990660001283013",
                                "transactionType": 0,
                                "requestAmount": 14.14,
                                "rewardsId": None,
                                "giftCardNumber": "",
                                "creditCardType": "Discover",
                                "status": 0,
                                "captureTime": None,
                                "captureAmount": 0,
                                "createdTime": "1635643831029",
                                "updatedTime": "1635643831029",
                                "availableToRefundMax": 14.14,
                                "refundedAmount": 0,
                                "expireMonth": "12",
                                "expireYear": "33",
                                "transactionExpirationDate": "1636507830970",
                                "transactionDate": "1635643830970",
                                "captureTransactionId": None,
                                "parentOrderNumber": "6420505370208535",
                                "cancelledCaptureAmount": 0,
                                "fulfilledAmount": 0,
                                "lastFourDigit": "6011",
                            }
                        ],
                        "orderCoupons": None,
                        "orderShippingTaxVos": None,
                        "orderBundleInfoRspVos": None,
                        "originalItemsSubtotal": 9.99,
                    }
                ],
                "refundedAmount": 0,
                "refundedTax": 0,
                "refundedShippingFeeAndHandlingFee": 0,
                "refundedTotal": 0,
                "originalItemsSubtotal": 9.99,
                "statusCategory": None,
                "firstName": "Test",
                "lastName": "Auto",
                "customerEmail": "at-kvw@snapmail.cc",
                "phone": "3333333333",
            },
        }
        return body

    @staticmethod
    def get_buyer_cancel_order_body(
        parent_order_number, sub_order_number, order_item_id, quantity
    ):
        body = {
            "parentOrderNumber": parent_order_number,
            "requestBy": "1",
            "subCancelOrders": [
                {
                    "orderNumber": sub_order_number,
                    "cancelOrderLines": [
                        {"orderItemId": order_item_id, "quantity": quantity}
                    ],
                }
            ],
        }
        return body

    @staticmethod
    def get_seller_cancel_order_body(sub_order_number):
        body = {"orderNumber": sub_order_number, "cancelReason": "Out of Stock"}
        return body

    @staticmethod
    def get_seller_order_search_body(store_id, statuses):
        """
        :param store_id:
        :param statuses:
                                3000:Open(打开)
                                1000:Pending Confirmation(待确认)
                                3500:Ready to Ship(准备装船)
                                6800:Partial Shipped(分批发货)
                                7000:Shipped(已发货)
                                7500:Delivered(已收货)
                                7900:Partially Pending Return(部分待归还)
                                8000:Return Requested(要求退货)
                                8500:Return Refund(退款)
                                8600:Dispute Opened(争论开始)
                                8700:Partial Refund(部分退款)
                                9000:Cancelled(取消)
                                10000:Completed (完成)
        :return:
        """
        body = {
            "pageNumber": 0,
            "pageSize": 10,
            "storeId": store_id,
            "keywords": "",
            "statuses": statuses,
            "startDate": "",
            "endDate": "",
            "channel": "2",
            "timeRange": "customized",
            "toAggregate": True,
            "userId": 427710090280997,
        }
        return body

    @staticmethod
    def get_buyer_order_from_list_by_buyer_name(order_list, buy_name):
        order_numbers = []
        for order in order_list:
            if buy_name.lower() == order.get("customer_name").lower():
                order_numbers.append(order.get("order_number"))
        return order_numbers

    @staticmethod
    def get_seller_order_list_page_body(order_number_list=None):
        body = {
            "currentPage": 0,
            "pageSize": 10,
            "simpleMode": True,
            "channel": 2,
            "orderNumberList": order_number_list,
        }
        return body

    @staticmethod
    def get_buyer_order_number_from_response(data, user_id):
        data = data.get("data").get("orderRspVoList")
        for item in reversed(data):  # for item in data[::-1]:
            if item.get("userId") == user_id:
                return item.get("orderNumber")

    @staticmethod
    def get_seller_confirm_order_body(sub_order_numbers):
        body = {"orderNumbers": sub_order_numbers}
        return body

    @staticmethod
    def get_shipment_estimate():
        body = {
            "weight": 0,
            "height": 0,
            "width": 0,
            "length": 0,
            "service": "ALL",
            "type": "regular",
        }
        return body

    @staticmethod
    def get_seller_order_shipment_body(sub_order_number, order_item_id, quantity):
        body = {
            "orderNumber": sub_order_number,
            "shipmentsList": [
                {
                    "trackingNumber": "123123123",
                    "carrier": "ups",
                    "carrierTrackingUrl": "https://www.ups.com/us/en/Home.page",
                    "shippingLabel": None,
                    "shipmentItemList": [
                        {
                            "quantity": quantity,
                            "orderItemId": order_item_id,
                            "uom": "EA",
                        }
                    ],
                }
            ],
        }
        return body

    @staticmethod
    def get_seller_after_sales_order_list_body(statuses=None, parent_order_number=None):
        """
        :param statuses:
        10500:  Partially Pending Return
        11000:  Pending Return
        17000:  Partially Returned
        18000:  Returned
        19000:  Return Canceled
        19100:  Refund Rejected
        :param parent_order_number:
        :return:
        """
        if statuses is None:
            returnOrderStatus = ""
        else:
            returnOrderStatus = ",".join(statuses)
        body = {
            "channel": "1,2,3,4",
            "pageNum": 1,
            "pageSize": 10,
            "parentOrderNumber": parent_order_number,
            "startTime": "",
            "endTime": "",
            "returnOrderStatus": returnOrderStatus,
        }
        return body

    @staticmethod
    def get_buyer_order_depute_body():
        body = {
            "parentOrderNumber": "8224338183181885",
            "returnOrderNumber": "R5912308802649120769",
            "orderNumber": "THP8224338183181885-1",
            "disputeItemVos": [
                {
                    "orderAfterSalesItemId": "5912308802649120771",
                    "disputeItemQuantity": 1,
                    "disputeType": "Item Does Not Work",
                    "buyerDisputeReason": "It really not work",
                    "evidenceMedia": [
                        {
                            "url": "https://imgproxy.tst02.platform.michaels.com/XXTpt9MjeIKtJwhEo-W6WCFk1c9-K_Ll4qb5g7o5vco/aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL2Ntcy1yc2MtdHN0MDIvNTkxMjMzMzA5NDk4NDEzODc1Mg.webp",
                            "fileName": "5873737522428993536.webp",
                            "contentType": "IMAGE",
                        }
                    ],
                }
            ],
        }
        return body

    @staticmethod
    def get_seller_dispute_make_offer_body():
        body = {
            "sellerOfferedAmount": 9.99,
            "currency": "USD",
            "offerType": "REFUND",
            "offerReason": "",
            "isRefundShippingFee": 1,
        }
        return body

    @staticmethod
    def get_buyer_return_order_body(buyer_order_detail, can_return_order, img_url):
        return_reason = [
            "Changed Mind",
            "Item Was Damaged",
            "Item Does Not Work",
            "Not As Described",
            "Did Not Receive This Item",
            "Wrong Item Was Sent",
            "Missing parts or accessories",
            "No Longer needed",
            "Purchased by mistake",
        ]
        after_sales_comment = random.choice(return_reason)
        user_upload_media = (
            [img_url]
            if after_sales_comment != "Changed Mind"
            or "Did Not Receive This Item"
            or "No Longer needed"
            or "Purchased by mistake"
            else []
        )
        item_condition = ["New", "Damaged"]
        sub_orders = buyer_order_detail["data"]["subOrders"]
        address = {}
        order_lines_list = []
        order_number = None
        for sub_order in sub_orders:
            if sub_order["orderNumber"] in can_return_order:
                address = {
                    "firstName": sub_order["firstName"],
                    "lastName": sub_order["lastName"],
                    "phone": sub_order["phone"],
                    "country": sub_order["countryCode"],
                    "state": sub_order["state"],
                    "city": sub_order["city"],
                    "zipCode": sub_order["zipCode"],
                    "address1": sub_order["address1"],
                    "address2": "",
                }
                order_lines_list = sub_order["orderLines"]
                order_number = sub_order["orderNumber"]
                if not (order_number or order_lines_list or address):
                    raise Exception(
                        "order_number or order_lines_list or address is None"
                    )
        return_order_lines = []
        for order_lines in order_lines_list:
            return_order_line = {
                "orderItemId": order_lines["orderItemId"],
                "quantity": order_lines["quantity"],
                "afterSalesReason": after_sales_comment,
                "afterSalesComment": "I don't Know what happen about the item",
                "userUploadMedia": user_upload_media,
                "itemCondition": item_condition[0],
            }
            return_order_lines.append(return_order_line)
        body = {
            "parentOrderNumber": buyer_order_detail["data"]["parentOrderNumber"],
            "disputeType": 0,
            "customerEmail": buyer_order_detail["data"]["customerEmail"],
            "subReturnOrders": [
                {
                    "orderNumber": order_number,
                    "shippingLabelsExpected": 1,
                    "channel": 2,
                    "address": address,
                    "returnOrderLines": return_order_lines,
                }
            ],
        }
        return body

    @staticmethod
    def get_buyer_after_order_list_body(parent_order_number):
        body = {
            "parentOrderNumber": parent_order_number,
            "pageNum": 1,
            "pageSize": 10,
            "sortFile": "createdTime",
            "afterSalesOrderType": 3000,
        }
        return body

    @staticmethod
    def get_seller_approve_after_sales_order_body(return_order_info, approval=True):
        if approval:
            action = "approveRefund"
        else:
            action = "rejectRefund"
        lines = return_order_info.get("returnOrderLines")
        returnOrderLines = []
        for item in lines:
            returnOrderLines.append(
                {
                    "orderAfterSalesItemId": item.get("orderAfterSalesItemId"),
                    "action": action,
                }
            )

        body = {
            "returnOrderNumber": return_order_info.get("returnOrderNumber"),
            "returnOrderLines": returnOrderLines,
        }

        return body

    @staticmethod
    def get_pre_initiate_body(item_info_list, shipping_address: dict):
        pre_initial_item_vo_list = []
        for item in item_info_list:
            item_info = {
                "shoppingCartItemId": item.get("shoppingItemId"),
                "skuNumber": item.get("sku"),
                "subSkuNumber": None,
                "price": item.get("price"),
                "quantity": item.get("quantity"),
                "totalPrice": int(item.get("quantity")) * float(item.get("price")),
                "channelType": 2,
                "storeId": item.get("StoreId"),
                "mikStoreId": "-1",
                "generalShippingType": 0,
            }
            pre_initial_item_vo_list.append(item_info)
        body = {
            "shippingAddress": shipping_address,
            "localTimeVo": {
                "timeInMillis": round(time.time() * 1000),
                "timeZone": "GMT+0800",
            },
            "preInitialItemVoList": pre_initial_item_vo_list,
        }
        return body

    @staticmethod
    def get_split_order_and_initiate_body(order_res, address_info, buyer_info):
        pre_initial_sub_order_vo_list = []
        for suborder in order_res:
            chosen_able_shipping_method_list = suborder.get(
                "chosenAbleShippingMethodList"
            )
            chosen_able_shipping_method_list[0]["checked"] = 1
            sub_od = {
                "storeId": suborder.get("storeId"),
                "mikStoreId": "-1",
                "channelType": 2,
                "itemList": suborder.get("itemList"),
                "chosenAbleShippingMethodList": chosen_able_shipping_method_list,
                "generalShippingType": 0,
                "pickupPersons": [],
                "giftFrom": None,
                "giftMessage": None,
                "chosenGift": None,
            }
            pre_initial_sub_order_vo_list.append(sub_od)
        body = {
            "orderSource": "Default",
            "areaCode": "US",
            "couponCodes": [],
            "ackTaxExempt": True,
            "smsPreference": True,
            "shippingAddressInfo": {
                "firstName": address_info.get("firstName"),
                "lastName": address_info.get("lastName"),
                "addressLine1": address_info.get("addressLine1"),
                "addressLine2": "",
                "city": address_info.get("city"),
                "state": address_info.get("state"),
                "countryId": address_info.get("countryId"),
                "zipcode": address_info.get("zipCode"),
                "zipCode": address_info.get("zipCode"),
                "phoneNumber": address_info.get("telephone"),
                "email": buyer_info.get("email"),  #
                "sameAsShipping": True,
            },
            "preInitialSubOrderVoList": pre_initial_sub_order_vo_list,
        }
        return body

    @staticmethod
    def get_submit_order_body(initiate_data, wallet_bankcard, address_info, buyer_info):
        user = buyer_info.get("user")
        card_type = {1: "Visa", 2: "MasterCard", 3: "Amex", 4: "Discover"}
        credit_card_payment = {
            "payment": "CREDIT_CARD",
            "billingAddressInfo": {
                "firstName": wallet_bankcard.get("firstName"),
                "lastName": wallet_bankcard.get("lastName"),
                "addressLine1": wallet_bankcard.get("addressLine1"),
                "addressLine2": "",
                "city": wallet_bankcard.get("city"),
                "state": wallet_bankcard.get("state"),
                "countryId": wallet_bankcard.get("countryId"),
                "zipCode": wallet_bankcard.get("zipCode"),
                "phoneNumber": wallet_bankcard.get("telephone"),
                "email": user.get("email"),
                "sameAsShipping": True,
                "isAddressSaved": True,
                "isAllItemsPickup": False,
            },
            "cardReferenceNumber": wallet_bankcard.get("cardRefNum"),
            "cardLastFour": wallet_bankcard.get("tailNumber"),
            "expirationMonth": wallet_bankcard.get("expirationDate")[:2],
            "expirationYear": wallet_bankcard.get("expirationDate")[2:],
            "cardType": card_type[wallet_bankcard.get("cardChannelType")],
            "nameOnCard": "",
            "currency": "USD",
        }
        shipping_address_info = {
            "firstName": address_info.get("firstName"),
            "lastName": address_info.get("lastName"),
            "addressLine1": address_info.get("addressLine1"),
            "addressLine2": "",
            "city": address_info.get("city"),
            "state": address_info.get("state"),
            "countryId": address_info.get("countryId"),
            "zipcode": address_info.get("zipCode"),
            "zipCode": address_info.get("zipCode"),
            "phoneNumber": address_info.get("telephone"),
            "email": buyer_info.get("email"),
            "sameAsShipping": True,
        }
        # initiate_data["giftCartPayments"] = []
        initiate_data["shippingAddressInfo"] = shipping_address_info
        initiate_data["timeZone"] = "GMT+0800"
        initiate_data["voucherPayments"] = []
        initiate_data["creditCardPayment"] = credit_card_payment
        return initiate_data


if __name__ == "__main__":
    r = RequestBodyOrderFlow()
    # a = r.get_seller_after_sales_order_list_body(None)
    # a = r.get_buyer_return_order_body(2,2)
    # print(a)
