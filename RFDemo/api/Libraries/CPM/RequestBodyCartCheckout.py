import datetime
import time
from typing import Any, Dict, List

import requests


class RequestBodyCartCheckout(object):
    def __init__(self):
        pass

    @staticmethod
    def get_carts(user_id: int, channel: str, cart_type: int):
        return {"userId": user_id, "channel": channel, "cartType": cart_type}

    @staticmethod
    def create_carts(user_id: str, channel: str, sub_scription_default, cart_type):
        return {
            "userId": user_id,
            "channel": channel,
            "subscriptionDefault": sub_scription_default,
            "cartType": cart_type,
        }

    @staticmethod
    def get_cart_items(
        city: str = None,
        state: str = None,
        zip_code: str = None,
        time_in_millis: str = None,
        time_zone: str = None,
        latitude: float = 0.0,
        longitude: float = 0.0,
    ):
        return {
            "city": city,
            "state": state,
            "zipCode": zip_code,
            "timeInMillis": time_in_millis,
            "timeZone": time_zone,
            "latitude": latitude,
            "longitude": longitude,
        }

    @staticmethod
    def create_cart_items(
        user_id: int, items: List[Dict[str, Any]], cart_id, url, headers
    ):
        buy_method = {"SDD": 2, "STM": 0, "PickUp": 1}
        cart_items = []
        # bundle_skus = []
        # bundle_sku_counts = []
        cart_item_gifts = []
        sub_sku_number = None
        for item in items:
            schedule_id = None
            bundle_skus = item.get("bundleSkus") if item.get("bundleSkus") else []
            bundle_sku_counts = (
                item.get("bundleSkuCounts") if item.get("bundleSkuCounts") else []
            )
            if item.get("Class"):
                resp = requests.get(
                    url=f"{url}/arr/external/event/{item.get('skuNumber')}",
                    headers=headers,
                ).json()
                schedule_id = RequestBodyCartCheckout.get_schedule(
                    resp, item.get("channel"), item.get("fees")
                )
            else:
                resp = requests.get(
                    url=f"{url}/product/sub-skus",
                    headers=headers,
                    params={"subSkuNumbers": [item.get("skuNumber")]},
                ).json()[0]
                sub_sku_number = RequestBodyCartCheckout.get_sub_sku_number(item, resp)
            if schedule_id is not None:
                item_type = 0
            elif len(bundle_skus) > 0:
                item_type = 2
            else:
                item_type = 1
            cart_item = {
                "skuNumber": item.get("skuNumber"),
                "subSkuNumber": sub_sku_number,
                "shipMethod": buy_method.get(item.get("shipMethod"))
                if item.get("shipMethod") is not None
                else 0,
                "michaelsStoreId": item.get("storeId")
                if item.get("storeId") is not None
                else 5062,
                "isSelected": False,
                "isGift": False,
                "quantity": item.get("quantity")
                if item.get("quantity") is not None
                else 1,
                "canSchedule": item.get("canSchedule") if item.get("canSchedule") else False,
                "itemType": item_type,
                "scheduleId": schedule_id,
                "bundleSkus": bundle_skus,
                "bundleSkuCounts": bundle_sku_counts,
                "userId": user_id,
                "shoppingCartId": cart_id,
                "cartItemGifts": cart_item_gifts,
                "intervalSeconds": item.get("intervalSeconds")
                if item.get("intervalSeconds")
                else None,
            }
            cart_items.append(cart_item)

        return {"userId": user_id, "cartItems": cart_items}

    @staticmethod
    def create_cart_items_guest(
        user_id: int,
        items: List[Dict[str, Any]],
        cart_id,
        url,
        headers,
        is_buy_now: bool = False,
    ):
        buy_method = {"SDD": 2, "STM": 0, "PickUp": 1}
        cart_items = []
        # bundle_skus = []
        # bundle_sku_counts = []
        cart_item_gifts = []
        sub_sku_number = None
        for item in items:
            schedule_id = None
            bundle_skus = item.get("bundleSkus") if item.get("bundleSkus") else []
            bundle_sku_counts = (
                item.get("bundleSkuCounts") if item.get("bundleSkuCounts") else []
            )
            if item.get("Class"):
                resp = requests.get(
                    url=f"{url}/arr/external/event/{item.get('skuNumber')}",
                    headers=headers,
                ).json()
                schedule_id = RequestBodyCartCheckout.get_schedule(
                    resp, item.get("channel"), item.get("fees")
                )
            else:
                resp = requests.get(
                    url=f"{url}/product/sub-skus",
                    headers=headers,
                    params={"subSkuNumbers": [item.get("skuNumber")]},
                ).json()[0]
                sub_sku_number = RequestBodyCartCheckout.get_sub_sku_number(item, resp)
            if schedule_id is not None:
                item_type = 0
            elif len(bundle_skus) > 0:
                item_type = 2
            else:
                item_type = 1
            cart_item = {
                "skuNumber": item.get("skuNumber"),
                "subSkuNumber": sub_sku_number,
                "shipMethod": buy_method.get(item.get("shipMethod"))
                if item.get("shipMethod") is not None
                else 0,
                "michaelsStoreId": item.get("storeId")
                if item.get("storeId") is not None
                else 5062,
                "isSelected": False,
                "isGift": False,
                "quantity": item.get("quantity")
                if item.get("quantity") is not None
                else 1,
                "canSchedule": False,
                "itemType": item_type,
                "scheduleId": schedule_id,
                "bundleSkus": bundle_skus,
                "bundleSkuCounts": bundle_sku_counts,
                "userId": user_id,
                "shoppingCartId": cart_id,
                "cartItemGifts": cart_item_gifts,
                "intervalSeconds": item.get("intervalSeconds")
                if item.get("intervalSeconds") is None
                else None,
            }
            cart_items.append(cart_item)

        return {"guestCartId": cart_id, "cartItems": cart_items, "isBuyNow": is_buy_now}

    @staticmethod
    def create_guest_cart_items(
        user_id: int, items: List[Dict[str, Any]], cart_id, url, headers
    ):
        buy_method = {"SDD": 2, "STM": 0, "PickUp": 1}
        cart_items = []
        # bundle_skus = []
        # bundle_sku_counts = []
        cart_item_gifts = []
        sub_sku_number = None
        for item in items:
            schedule_id = None
            bundle_skus = item.get("bundleSkus") if item.get("bundleSkus") else []
            bundle_sku_counts = (
                item.get("bundleSkuCounts") if item.get("bundleSkuCounts") else []
            )
            if item.get("Class"):
                resp = requests.get(
                    url=f"{url}/arr/external/event/{item.get('skuNumber')}",
                    headers=headers,
                ).json()
                schedule_id = RequestBodyCartCheckout.get_schedule(
                    resp, item.get("channel"), item.get("fees")
                )
            else:
                resp = requests.get(
                    url=f"{url}/product/sub-skus",
                    headers=headers,
                    params={"subSkuNumbers": [item.get("skuNumber")]},
                ).json()[0]
                sub_sku_number = RequestBodyCartCheckout.get_sub_sku_number(item, resp)
            if schedule_id is not None:
                item_type = 0
            elif len(bundle_skus) > 0:
                item_type = 2
            else:
                item_type = 1
            cart_item = {
                "skuNumber": item.get("skuNumber"),
                "subSkuNumber": sub_sku_number,
                "shipMethod": buy_method.get(item.get("shipMethod"))
                if item.get("shipMethod") is not None
                else 0,
                "michaelsStoreId": item.get("storeId")
                if item.get("storeId") is not None
                else 5062,
                "isSelected": False,
                "isGift": False,
                "quantity": item.get("quantity")
                if item.get("quantity") is not None
                else 1,
                "canSchedule": False,
                "itemType": item_type,
                "scheduleId": schedule_id,
                "bundleSkus": bundle_skus,
                "bundleSkuCounts": bundle_sku_counts,
                "userId": user_id,
                "shoppingCartId": cart_id,
                "cartItemGifts": cart_item_gifts,
                "intervalSeconds": item.get("intervalSeconds")
                if item.get("intervalSeconds") is None
                else None,
            }
            cart_items.append(cart_item)

        return {"guestCartId": user_id, "cartItems": cart_items}

    @staticmethod
    def get_sub_sku_number(item, product_info):
        if product_info.get("subSkus"):
            if item.get("variantTypeValues") is not None:
                for product_sku in product_info.get("subSkus"):
                    pass
            elif item.get("attrs"):
                for product_sku in product_info.get("subSkus"):
                    if item.get("attrs") in product_sku.get("attrs"):
                        return product_sku.get("skuNumber")
            else:
                return product_info.get("subSkus")[0].get("skuNumber")
        else:
            return None

    @staticmethod
    def get_schedule(schedule_list, channel, fees):
        if schedule_list["scheduleResponseList"]:
            for schedule in schedule_list["scheduleResponseList"]:
                current_time = datetime.datetime.strptime(
                    str(datetime.datetime.now()).split(".")[0],
                    "%Y-%m-%d %H:%M:%S",
                )
                end_time_split = str(schedule.get("countdownEndTime")).split("T")
                countdown_end_time = datetime.datetime.strptime(
                    f"{end_time_split[0]} {end_time_split[-1].split('.')[0]}",
                    "%Y-%m-%d %H:%M:%S",
                )
                if channel == "MIK":
                    # print(schedule.get("scheduleId"))
                    if fees:
                        if RequestBodyCartCheckout.judgement_time_range(
                            schedule_list.get("eventType"), schedule
                        ):
                            return schedule.get("scheduleId")
                    else:
                        if (
                            (countdown_end_time - current_time).days * 86400
                            + (countdown_end_time - current_time).seconds
                            > 2700
                            and schedule.get("numBooked") < schedule.get("maxSpots")
                            and schedule.get("status") != "CANCELLED"
                        ):
                            return schedule.get("scheduleId")
                elif channel == "FGM":
                    if fees:
                        if RequestBodyCartCheckout.judgement_time_range(
                            schedule_list.get("eventType"), schedule
                        ):
                            return schedule.get("scheduleId")
                    else:
                        if (
                            (countdown_end_time - current_time).days * 86400
                            + (countdown_end_time - current_time).seconds
                            > 2700
                            and schedule.get("numBooked") < schedule.get("maxSpots")
                            and schedule.get("status") != "CANCELLED"
                        ):
                            return schedule.get("scheduleId")

    @staticmethod
    def judgement_time_range(event_type: str, event_info):
        event_date_split = str(event_info.get("eventDate")).split("T")
        event_date_time = datetime.datetime.strptime(
            f"{event_date_split[0]} {event_date_split[-1].split('.')[0]}",
            "%Y-%m-%d %H:%M:%S",
        )

        current_time = datetime.datetime.strptime(
            str(datetime.datetime.now()).split(".")[0],
            "%Y-%m-%d %H:%M:%S",
        )
        result = time.mktime(
            time.strptime(str(event_date_time), "%Y-%m-%d %H:%M:%S")
        ) - time.mktime(time.strptime(str(current_time), "%Y-%m-%d %H:%M:%S"))
        if event_info.get("status") == "PUBLISHED" and (
            event_info.get("maxSpots") > event_info.get("numBooked")
        ):
            if event_type == "IN_STORE":
                if result >= 86400:
                    return True
                # event_data大于当前时间24小时
            elif event_type == "ONLINE":
                if result >= 900:
                    return True
                # event_data距离15分钟
        return False

    @staticmethod
    def create_checkout_pre_initiate(
        initial_item_list,
        shipping_address=None,
    ):
        shipping_type_dict = {0: 0, 2: 2, 1: 3}
        channel = {"MIK": 1, "FGM": 3, "THP": 2, "B2B": 4}
        pre_initial_item_list = []

        for item in initial_item_list:
            if (
                item.get("channel") in ["MIK", "FGM"]
                and item.get("scheduleId") is not None
            ):
                general_shipping_type = 1
            else:
                general_shipping_type = shipping_type_dict.get(item.get("shipMethod"))
            pre_initial_item_list.append(
                {
                    "shoppingCartItemId": item.get("shoppingItemId"),
                    "skuNumber": item.get("skuNumber"),
                    "subSkuNumber": item.get("subSkuNumber"),
                    "price": item.get("price"),
                    "quantity": item.get("quantity"),
                    "totalPrice": item.get("insertedPrice") * item.get("quantity"),
                    "channelType": channel.get(item.get("channel")),
                    "storeId": item.get("sellerStoreId")
                    if item.get("sellerStoreId") is not None
                    else "-1",
                    "mikStoreId": item.get("michaelsStoreId"),
                    "generalShippingType": general_shipping_type,
                }
            )

        local_time = {
            "timeInMillis": int(round(time.time() * 1000)),
            "timeZone": "GMT+0800",
        }
        if shipping_address is None:
            shipping_address = RequestBodyCartCheckout.get_shipping_address(
                shipping_address
            )
        return {
            "shippingAddress": shipping_address,
            "preInitialItemVoList": pre_initial_item_list,
            "localTimeVo": local_time,
        }

    @staticmethod
    def get_shipping_address(shipping_address=None):
        if shipping_address is None:
            return {
                "firstName": "Automation",
                "zipCode": "76092-6437",
                "zipcode": "76092-6437",
                "addressLine2": "APT 2",
                "addressLine1": "1051 E Southlake Blvd",
                "state": "TX",
                "lastName": "Buyer",
                "city": "Southlake",
                "countryId": "US",
                "phoneNumber": "8384697778",
                "telephone": "8384697778",
                "email": "automation@michaels.com",
            }

    # @staticmethod
    # def create_refresh_initiate(
    #     pre_initial_sub_order_list: List[Dict[str, Any]],
    #     items: List[Dict[str, Any]] = None,
    #     shipping_address=None,
    # ):
    #     sub_order_list = []
    #     for sub_order in pre_initial_sub_order_list:
    #         if sub_order.get("generalShippingType") == 1:
    #             sub_order["itemList"] = RequestBodyCartCheckout.set_booking_details(
    #                 sub_order.get("itemList")
    #             )
    #         shipping_method = RequestBodyCartCheckout.get_item_shipping_method(
    #             items,
    #             sub_order.get("itemList")[0].get("skuNumber"),
    #             sub_order.get("chosenAbleShippingMethodList"),
    #         )
    #         sub_order["chosenAbleShippingMethodList"] = [shipping_method]
    #         sub_order_list.append(sub_order)
    #
    #     return {
    #         "orderSource": "Default",
    #         "areaCode": "US",
    #         "couponCodes": [],
    #         "ackTaxExempt": True,
    #         "smsPreference": True,
    #         "shippingAddressInfo": RequestBodyCartCheckout.get_shipping_address(
    #             shipping_address
    #         ),
    #         "preInitialSubOrderVoList": sub_order_list,
    #     }

    @staticmethod
    def create_carts_bind(cart_id, user_id):
        return {"cartId": cart_id, "userId": user_id}

    @staticmethod
    def create_split_order_initiate(
        pre_initial_sub_order_list: List[Dict[str, Any]],
        items: List[Dict[str, Any]] = None,
        shipping_address=None,
        guest_id=None,
            coupon_codes=None
    ):
        sub_order_list = []
        for sub_order in pre_initial_sub_order_list:
            if sub_order.get("generalShippingType") == 1:
                sub_order["itemList"] = RequestBodyCartCheckout.set_booking_details(
                    sub_order.get("itemList")
                )
                product_shipping_method = {
                    "shippingMethodName": "Digital",
                    "shippingMethodType": "DIGITAL",
                    "shippingMethodTypeVal": 3,
                    "shippingFee": None,
                    "estimatedDeliveryDate": None,
                    "inRange": None,
                    "supportSDD": None,
                    "overRide": None,
                    "generalShippingType": 1,
                }
            else:
                product_shipping_method = (
                    RequestBodyCartCheckout.get_item_shipping_method(
                        items,
                        sub_order.get("itemList")[0],
                        sub_order.get("chosenAbleShippingMethodList"),
                    )
                )
            sub_order["chosenAbleShippingMethodList"] = [product_shipping_method]

            sub_order_list.append(sub_order)
        payload = {
            "orderSource": "Default",
            "areaCode": "US",
            "couponCodes": coupon_codes if coupon_codes else [],
            "ackTaxExempt": True,
            "smsPreference": True,
            "shippingAddressInfo": RequestBodyCartCheckout.get_shipping_address(
                shipping_address
            ),
            "preInitialSubOrderVoList": sub_order_list,
        }
        if guest_id:
            payload["guestId"] = guest_id

        return payload

    @staticmethod
    def create_initiate_status(
        pre_initial_sub_order_list: List[Dict[str, Any]],
        items: List[Dict[str, Any]] = None,
        shipping_address=None,
        guest_id=None,
        order_source=None,
        area_code=None,
        ack_tax_exempt=None,
        store_id=None,
        channel=None,
        quantity=None,
        shipping_method=None,
    ):
        sub_order_list = []
        test_list = []
        for sub_order in pre_initial_sub_order_list:
            product_shipping_method = None
            mik_store_id = sub_order.get("mikStoreId")

            channel_type = sub_order.get("channelType")

            item_list = []
            if quantity is not None:
                for item in sub_order.get("itemList"):
                    item["quantity"] = quantity
                    item_list.append(item)
            else:
                item_list = sub_order.get("itemList")

            if sub_order.get("generalShippingType") == 1:
                sub_order["itemList"] = RequestBodyCartCheckout.set_booking_details(
                    sub_order.get("itemList")
                )
                product_shipping_method = {
                    "shippingMethodName": "Digital",
                    "shippingMethodType": "DIGITAL",
                    "shippingMethodTypeVal": 3,
                    "shippingFee": None,
                    "estimatedDeliveryDate": None,
                    "inRange": None,
                    "supportSDD": None,
                    "overRide": None,
                    "generalShippingType": 1,
                }

            if product_shipping_method is None:
                product_shipping_method = (
                    RequestBodyCartCheckout.get_item_shipping_method(
                        items,
                        sub_order.get("itemList")[0],
                        sub_order.get("chosenAbleShippingMethodList"),
                    )
                )
                if shipping_method is not None:
                    product_shipping_method = {
                        "shippingMethodName": "Standard Ground",
                        "shippingMethodType": shipping_method,
                        "shippingMethodTypeVal": 10001,
                        "shippingFee": "6.95",
                        "estimatedDeliveryDate": "2022-03-15",
                        "inRange": None,
                        "supportSDD": None,
                        "overRide": None,
                        "generalShippingType": None,
                    }

            if store_id is not None:
                mik_store_id = store_id
            if channel is not None:
                channel_type = channel

            sub_order["channelType"] = channel_type

            sub_order["mikStoreId"] = mik_store_id

            sub_order["itemList"] = item_list

            sub_order["chosenAbleShippingMethodList"] = [product_shipping_method]

            sub_order_list.append(sub_order)
        payload = {
            "orderSource": order_source if order_source is not None else "Default",
            "areaCode": area_code if area_code is not None else "US",
            "couponCodes": [],
            "ackTaxExempt": ack_tax_exempt if ack_tax_exempt is not None else True,
            "smsPreference": True,
            "shippingAddressInfo": RequestBodyCartCheckout.get_shipping_address(
                shipping_address
            ),
            "preInitialSubOrderVoList": sub_order_list,
            "test": test_list,
        }
        return payload

    @staticmethod
    def create_initiate(
        pre_initial_sub_order_list: List[Dict[str, Any]],
        items: List[Dict[str, Any]] = None,
        shipping_address=None,
        guest_id=None,
        order_source=None,
        area_code=None,
        ack_tax_exempt=None,
        store_id=None,
        channel=None,
        quantity=None,
        shipping_method=None,
    ):
        sub_order_list = []
        test_list = []
        for sub_order in pre_initial_sub_order_list:
            product_shipping_method = None
            mik_store_id = sub_order.get("mikStoreId")

            channel_type = sub_order.get("channelType")

            item_list = []
            if quantity is not None:
                for item in sub_order.get("itemList"):
                    item["quantity"] = quantity
                    item_list.append(item)
            else:
                item_list = sub_order.get("itemList")

            if sub_order.get("generalShippingType") == 1:
                sub_order["itemList"] = RequestBodyCartCheckout.set_booking_details(
                    sub_order.get("itemList")
                )
                product_shipping_method = {
                    "shippingMethodName": "Digital",
                    "shippingMethodType": "DIGITAL",
                    "shippingMethodTypeVal": 3,
                    "shippingFee": None,
                    "estimatedDeliveryDate": None,
                    "inRange": None,
                    "supportSDD": None,
                    "overRide": None,
                    "generalShippingType": 1,
                }

            if product_shipping_method is None:
                product_shipping_method = (
                    RequestBodyCartCheckout.get_item_shipping_method(
                        items,
                        sub_order.get("itemList")[0],
                        sub_order.get("chosenAbleShippingMethodList"),
                    )
                )
                if shipping_method is not None:
                    product_shipping_method = {
                        "shippingMethodName": "Standard Ground",
                        "shippingMethodType": shipping_method,
                        "shippingMethodTypeVal": 10001,
                        "shippingFee": "6.95",
                        "estimatedDeliveryDate": "2022-03-15",
                        "inRange": None,
                        "supportSDD": None,
                        "overRide": None,
                        "generalShippingType": None,
                    }

            if store_id is not None:
                mik_store_id = store_id
            if channel is not None:
                channel_type = channel

            sub_order["channelType"] = channel_type

            sub_order["mikStoreId"] = mik_store_id

            sub_order["itemList"] = item_list

            sub_order["chosenAbleShippingMethodList"] = [product_shipping_method]

            sub_order_list.append(sub_order)
        payload = {
            "orderSource": order_source if order_source is not None else "Default",
            "areaCode": area_code if area_code is not None else "US",
            "couponCodes": [],
            "ackTaxExempt": ack_tax_exempt if ack_tax_exempt is not None else True,
            "smsPreference": True,
            "shippingAddressInfo": RequestBodyCartCheckout.get_shipping_address(
                shipping_address
            ),
            "preInitialSubOrderVoList": sub_order_list,
            "test": test_list,
        }
        return payload

    @staticmethod
    def set_booking_details(item_list):
        items = []
        for item in item_list:
            booking_details = []
            for i in range(0, int(item.get("quantity"))):
                booking_details.append(
                    {
                        "firstName": "automation",
                        "lastName": "API",
                        "email": "wang1@michal.com",
                        "phoneNumber": "408-802-2222",
                    }
                )
            item["bookingDetails"] = booking_details
            items.append(item)
        return items

    @staticmethod
    def get_shipping_method_by_type(shipping_method_list, shipping_method_type=None):
        if shipping_method_type is not None:
            for method in shipping_method_list:
                if method.get("shippingMethodType") == shipping_method_type:
                    return method
        else:
            return shipping_method_list[0]

    @staticmethod
    def get_item_shipping_method(items, sku_info, shipping_method_list):
        buy_method = {"SDD": 2, "STM": 0, "PickUp": 3}
        if items:
            for item in items:
                shipping_type = buy_method.get(
                    item.get("shipMethod")
                    if item.get("shipMethod") is not None
                    else "STM"
                )
                if (
                    str(item.get("skuNumber")) == str(sku_info.get("skuNumber"))
                    and sku_info.get("generalShippingType") == shipping_type
                ):
                    return RequestBodyCartCheckout.get_shipping_method_by_type(
                        shipping_method_list, item.get("shipping_method_type")
                    )
        else:
            return RequestBodyCartCheckout.get_shipping_method_by_type(
                shipping_method_list, None
            )

    @staticmethod
    def get_gift_card_payment(payment, initiate_payments, total_to_pay,gift_number_count):
        if payment.get("balance") is not None:
            key_name = f"InsufficientGiftCardPayment_{payment.get('balance')}"
            if payment.get("balance") == "2000":
                payments_method = initiate_payments.get(key_name)
                payment_info=payments_method[gift_number_count]
                balance = float(payment_info.get("giftCardBalance"))
                if balance > total_to_pay:
                    initiate_payments[key_name][gift_number_count]["giftCardBalance"] = str(
                        balance - total_to_pay
                    )
                    return payment_info
                # for gift in payments_method:
                #     balance = float(gift.get("giftCardBalance"))
                #     if balance > total_to_pay:
                #         index_ = payments_method.index(gift)
                #         initiate_payments[key_name][index_]["giftCardBalance"] = str(
                #             balance - total_to_pay
                #         )
                #         return gift
            else:
                return initiate_payments[key_name][0]

    @staticmethod
    def create_submit_order(
        refresh_initiate: Dict[str, Any],
        initiate_payments: Dict[str, Any],
        payments: List[Dict[str, Any]] = None,
        guest_id=None,
    ):
        total_to_pay = refresh_initiate.get("totalToPay")
        gift_card_payments = []
        if guest_id:
            refresh_initiate["guestId"] = guest_id
            if payments is not None:
                gift_id_count = 0
                gift_number_count=0
                for payment in payments:
                    if payment.get("payment_method") == "gift_card":
                        if payment.get("balance") is not None:
                            gift_card_payments.append(
                                RequestBodyCartCheckout.get_gift_card_payment(
                                    payment, initiate_payments, total_to_pay,gift_number_count
                                )
                            )
                            gift_number_count+=1
                        else:
                            gift_card_payments.append(
                                initiate_payments.get("giftCardPayments")[gift_id_count]
                            )
                            gift_id_count += 1
                    elif payment.get("payment_method") == "credit_id":
                        refresh_initiate["creditCardPayment"] = initiate_payments.get(
                            "creditCardPayment"
                        )
                    elif payment.get("payment_method") == "credit":
                        credit_card_payment = (
                            RequestBodyCartCheckout.get_credit_card_id(
                                initiate_payments.get("creditPaymentCardId")
                            )
                        )
                        refresh_initiate["creditCardPayment"] = credit_card_payment
            else:
                credit_card_payment = RequestBodyCartCheckout.get_credit_card_id(
                    initiate_payments.get("creditPaymentCardId")
                )
                refresh_initiate["creditCardPayment"] = credit_card_payment
        else:
            if payments is not None:
                gift_id_count = 0
                gift_number_count=0
                for payment in payments:
                    if payment.get("payment_method") == "gift_card":
                        if payment.get("balance") is not None:
                            gift_card_payments.append(
                                RequestBodyCartCheckout.get_gift_card_payment(
                                    payment, initiate_payments, total_to_pay,gift_number_count
                                )
                            )
                            gift_number_count+=1
                        else:
                            gift_card_payments.append(
                                initiate_payments.get("giftCardPayments")[gift_id_count]
                            )
                            gift_id_count += 1
                    elif payment.get("payment_method") == "credit_id":
                        refresh_initiate["creditCardPayment"] = initiate_payments.get(
                            "creditCardPayment"
                        )
                    elif payment.get("payment_method") == "credit":
                        credit_card_payment = (
                            RequestBodyCartCheckout.get_credit_card_id(
                                initiate_payments.get("creditPaymentCardId")
                            )
                        )
                        refresh_initiate["creditCardPayment"] = credit_card_payment
            else:
                # default ，credit
                refresh_initiate["creditCardPayment"] = initiate_payments.get(
                    "creditCardPayment"
                )
        refresh_initiate["giftCardPayments"] = gift_card_payments
        return refresh_initiate

    @staticmethod
    def get_credit_card_id(credit_card_payment):
        credit_card_payment[
            "billingAddressInfo"
        ] = RequestBodyCartCheckout.get_shipping_address()
        return credit_card_payment

    @staticmethod
    def list_inventory(skus: Dict[str, Any], url, headers):

        for values in skus.values():
            for item in values:
                print(item)
                if item.get("shipMethod") is not None:
                    if item.get("shipMethod") in ["PickUp", "SDD"]:
                        store_id = (
                            item.get("storeId")
                            if item.get("storeId") is not None
                            else "5062"
                        )
                    else:
                        store_id = "-1"
                else:
                    store_id = "-1"
                if item.get("bundleSkus"):
                    RequestBodyCartCheckout.list_bundle_inventory(
                        item, store_id, url, headers
                    )
                else:
                    product = RequestBodyCartCheckout.query_product(
                        item.get("skuNumber"), url
                    )
                    if product:
                        RequestBodyCartCheckout.query_inventory(
                            url,
                            channel=product.get("channel"),
                            sku_number=item.get("skuNumber"),
                            store_id=store_id,
                            headers=headers,
                        )

    @staticmethod
    def list_bundle_inventory(item, store_id, url, headers):
        for sku_number in item.get("bundleSkus"):
            product = RequestBodyCartCheckout.query_product(sku_number, url)
            if product:
                RequestBodyCartCheckout.query_inventory(
                    url,
                    channel=product.get("channel"),
                    sku_number=item.get("skuNumber"),
                    store_id=store_id,
                    headers=headers,
                )

    @staticmethod
    def query_inventory(url, channel, sku_number, store_id, headers):
        resp = requests.post(
            url=f"{url}/inv/inventory/buyer/list",
            json=[
                {
                    "channel": channel,
                    "skuNumber": sku_number,
                    "michaelsStoreId": store_id,
                }
            ],
        ).json()
        if resp.get("data"):
            product = resp.get("data")[0]
            if int(product.get("availableQuantity")) < 500:
                if channel == 1:
                    RequestBodyCartCheckout.mik_add_inventory(
                        url=url, michaels_store_id=store_id, sku_number=sku_number
                    )
                    omni = "OMNI"
                else:
                    RequestBodyCartCheckout.seller_add_inventory(
                        url=url,
                        store_id=product.get("sellerStoreId"),
                        master_sku_number=product.get("masterSkuNumber"),
                        channel=channel,
                        inventory_id=product.get("inventoryId"),
                        headers=headers,
                    )
                    store_id = product.get("sellerStoreId")
                    omni = "MIK"
                RequestBodyCartCheckout.delete_redis_test(
                    sku=product.get("skuNumber"),
                    store_id=store_id,
                    channel=omni,
                    url=url,
                    headers=headers,
                )

    @staticmethod
    def query_product(sku_number, url):
        resp = requests.get(
            url=f"{url}/product/skus", params={"skuNumbers": [sku_number]}
        ).json()
        if resp.get("data"):
            return resp.get("data")[0]
        else:
            return None

    @staticmethod
    def delete_redis_test(sku, store_id, channel, url, headers):
        requests.get(
            url=f"{url}/inv/redis-test/test-del?key=SKU_MIK_INVENTORY:F:{sku}-{store_id}-{channel}",
            headers=headers,
        )

    @staticmethod
    def mik_add_inventory(url, michaels_store_id, sku_number):
        requests.post(
            url=f"{url}/inv/inventory/omni/increase-inventories",
            json={
                "quantity": 2000,
                "michaelsStoreId": michaels_store_id,
                "skuNumbers": [sku_number],
            },
        ).json()

    @staticmethod
    def seller_add_inventory(
        url, store_id, master_sku_number, channel, inventory_id, headers
    ):
        requests.post(
            url=f"{url}/inv/inventory/store/{store_id}/inventorys",
            json={
                "masterSkuNumber": master_sku_number,
                "channel": channel,
                "editInventoryItemRos": [
                    {
                        "inventoryId": inventory_id,
                        "adjustAvailableQuantity": "2000",
                        "adjustType": 1,
                    }
                ],
            },
            headers=headers,
        ).json()

    @staticmethod
    def create_email_subscription_confirmation(quantity, unit_price: float = 9.99):
        return {
            "itemLink": " ",
            "itemName": "ATTest",
            "itemImage": "ATTest",
            "unitPrice": unit_price,
            "quantity": quantity,
            "deliveryDate": "2021-08-31",
            "frequency": "",
        }

    @staticmethod
    def update_cart_item(item, new_item):
        return {
            "quantity": new_item.get("quantity")
            if new_item.get("quantity") is not None
            else item.get("quantity"),
            "shipMethod": new_item.get("shipMethod")
            if new_item.get("shipMethod") is not None
            else item.get("shipMethod"),
            "michaelsStoreId": new_item.get("michaelsStoreId")
            if new_item.get("michaelsStoreId") is not None
            else item.get("michaelsStoreId"),
            "intervalSeconds": new_item.get("intervalSeconds")
            if new_item.get("intervalSeconds") is not None
            else item.get("intervalSeconds"),
            "isGift": new_item.get("isGift")
            if new_item.get("isGift") is not None
            else item.get("isGift"),
            "giftMessage": new_item.get("giftMessage")
            if new_item.get("giftMessage") is not None
            else item.get("giftMessage"),
            "customPrice": new_item.get("customPrice")
            if new_item.get("customPrice") is not None
            else item.get("customPrice"),
            "sourceType": new_item.get("sourceType")
            if new_item.get("sourceType") is not None
            else item.get("sourceType"),
            "sourceId": new_item.get("sourceId")
            if new_item.get("sourceId") is not None
            else item.get("sourceId"),
            "personalization": new_item.get("personalization")
            if new_item.get("personalization") is not None
            else item.get("personalization"),
            "canSchedule": new_item.get("canSchedule")
            if new_item.get("canSchedule") is not None
            else item.get("canSchedule"),
            "cartId": new_item.get("cartId")
            if new_item.get("cartId") is not None
            else item.get("cartId"),
            "itemId": new_item.get("itemId")
            if new_item.get("itemId") is not None
            else item.get("itemId"),
            "city": new_item.get("city")
            if new_item.get("city") is not None
            else item.get("city"),
            "state": new_item.get("state")
            if new_item.get("state") is not None
            else item.get("state"),
            "zipCode": new_item.get("zipCode")
            if new_item.get("zipCode") is not None
            else item.get("zipCode"),
            "timeInMillis": new_item.get("timeInMillis")
            if new_item.get("timeInMillis") is not None
            else item.get("timeInMillis"),
            "timeZone": new_item.get("timeZone")
            if new_item.get("timeZone") is not None
            else item.get("timeZone"),
            "latitude": new_item.get("latitude")
            if new_item.get("latitude") is not None
            else item.get("latitude"),
            "longitude": new_item.get("longitude")
            if new_item.get("longitude") is not None
            else item.get("longitude"),
        }

    @staticmethod
    def create_migrate(cart_id,to_user_id,item_ids=()):
        payload={"cartId":cart_id,"toUserId":to_user_id}
        if item_ids:
            payload["itemIds"]=item_ids
        return payload

    @staticmethod
    def create_transfer(cart_id,to_wishlist_id,item_ids=()):
        payload={"cartId":cart_id,"toWishlistId":to_wishlist_id}
        if item_ids:
            payload["itemIds"]=item_ids
        return payload




if __name__ == "__main__":
    list1 = {
        "The quantity of goods is 0": [
            {
                "skuNumber": "10662935",
                "shipMethod": "STM",
                "shipping_method_type": "GROUND_STANDARD",
                "quantity": 0,
            }
        ],
    }
    headers = {
        "User-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36",
        "admin-authorization": "eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6Im1hcCIsInVzZXJJZCI6IjUxODU1NjkyNDA2MDE4OTQ5MTIiLCJ0b2tlbiI6IjFuWHVTWE1NalZ0QXBSdEZ5NUMxYm03dXpZMXZPYmUyIiwiY3JlYXRlVGltZSI6IjE2NDczMzc3ODYyNjAiLCJleHBpcmVUaW1lIjoiMTY0NzMzODY4NjI2MCIsInJvbGVDb2RlcyI6WyJtaWsuRHluYW1pY0NvbnRlbnQuQWRtaW4iLCJEVFMgQWRtaW5pc3RyYXRvciIsImIyYi5UZWNoU3VwcG9ydCIsIkNNUy5BZG1pbiIsImIyYi5UZWNobm9sb2d5IiwibWt0Lk1hcmtldHBsYWNlQWRtaW4iLCJQcmljZS5BZG1pbiIsIkludmVudG9yeS5BZG1pbiIsIlJPTEVfQVJSX0FETUlOIiwibWtyLkR5bmFtaWNDb250ZW50LkFkbWluIiwibW9oX2FkbWluXzEiXSwic3ViIjoiNTE4NTU2OTI0MDYwMTg5NDkxMiIsImlhdCI6MTY0NzMzNzc4NiwiZXhwIjoxNjQ3MzM4Njg2LCJhdWQiOiJhZG1pbiIsImp0aSI6IkNzcno5SDBoZW83d29TVlpwQTllcFlFSTdXRmdRVTNHIn0.A65jdevly58OLE8Y7VKk-rRGxtJZ4A5VLwXg2Nh1cebKT4ZKBbblBTAoRVO_fZ9suVIuuxJc0CJI612JSDN0yg",
    }
    RequestBodyCartCheckout.list_inventory(
        list1, "https://mik.qa.platform.michaels.com/api", headers
    )
