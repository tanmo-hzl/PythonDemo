import random
import re


class GetPromotionCouponBody(object):
    def __init__(self):
        pass

    @staticmethod
    def get_match_apply_body(order_info):
        order_number = "ORDER" + str(random.randint(1, 999999))
        apply_body = {
            "orderNumber": order_number,
            "buyer": {"id": "555"},
            "coupon": [],
            "promotion": [],
            "codes": "",
            "subOrder": [
                {
                    "orderNumber": f"{order_number}-0",
                    "channel": "michaels.com",
                    "store": "0",
                    "item": [
                        {
                            "sku": "zyx666666666",
                            "piece": 1,
                            "price": 19.99,
                            "amount": 19.99,
                            "itemType": "REGULAR",
                            "scheduleId": None,
                            "promotion": [],
                            "coupon": [],
                        }
                    ],
                    "coupon": [],
                    "promotion": [],
                }
            ],
            "preview": True,
        }
        # for i in range(len(data)):
        #     print(data[i])
        # for key, value in kwargs.items():
        #     body.update({key: value})
        # return body
        apply_body.update(
            {
                "orderNumber": order_number,
                "codes": order_info.get("codes") if order_info.get("codes") else "",
                "buyer": order_info.get("buyer")
                if order_info.get("buyer")
                else {"id": "555"},
                "preview": order_info.get("preview")
                if order_info.get("preview")
                else True,
            }
        )



        # print(apply_body)

        # for number in range(len(case_data[case_name])):
        if order_info.get("order"):
            sub_order = apply_body["subOrder"][0]
            apply_body["subOrder"] = []
            for order, i in zip(order_info["order"], range(len(order_info["order"]))):
                sub_order.update({"orderNumber": order_number + "-" + str(i)})
                apply_body["subOrder"].append(sub_order.copy())
                # print(order)
                for k, item in order.items():
                    if k != "item":
                        apply_body["subOrder"][i][k] = item
                    else:

                        item1 = apply_body["subOrder"][i]["item"][0]
                        # if len(apply_body["subOrder"][i]["item"]) != len(item):

                        apply_body["subOrder"][i]["item"] = []
                        for number in range(len(item)):
                            item2 = item1.copy()
                            apply_body["subOrder"][i]["item"].append(item2)
                            for j, v in item[number].items():
                                item2[j] = v
                            item2["amount"] = float(item2["piece"]) * float(
                                item2["price"]
                            )
                            print(number, item1)
                            apply_body["subOrder"][i]["item"][number].update(item2)
                        print(apply_body["subOrder"][i]["item"])

        return apply_body

    @staticmethod
    def get_lockup_coupon_kms_data(
        data='<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><LookupCouponsResponse xmlns="http://www.copienttech.com/TrackableCouponsExternal/"><LookupCouponsResult><LookupCoupons xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns=""><Coupon><Code>467884001009796932110069800755</Code><StatusCode>0</StatusCode><Status>Coupon not Found</Status><InitialUses>0</InitialUses><RemainingUses>0</RemainingUses><ExtProgramId /></Coupon></LookupCoupons></LookupCouponsResult></LookupCouponsResponse></soap:Body></soap:Envelope>',
    ):
        pattern = f"<Code>(\d*)</Code><StatusCode>(\d)</StatusCode><Status>([\w ]*)</Status><InitialUses>([0-9])</InitialUses><RemainingUses>([0-9])</RemainingUses>"
        res_data = re.findall(pattern, data)[0]
        expect = {
            "long_code": res_data[0],
            "status_code": res_data[1],
            "status": res_data[2],
            "initial_uses": res_data[3],
            "remaining_uses": res_data[4],
        }
        return expect

    @staticmethod
    def get_group_mapping_body(
        items: str = "0",
        stores="0",
        customers="3",
        product_group_id=None,
        store_group_id=None,
        customer_group_id=None,
    ):
        item_list = items.strip().split(",")
        store_list = stores.strip().split(",")
        users = customers.strip().split(",")
        body = {
            "product_group": [
                {
                    "product_group_id": product_group_id,
                    "product_group_name": f"autoTest{product_group_id}",
                    "items": item_list,
                }
            ]
            if product_group_id is not None
            else None,
            "customer_group": [
                {
                    "customer_group_id": customer_group_id,
                    "customer_group_name": "string",
                    "customers": users,
                }
            ]
            if customer_group_id is not None
            else None,
            "store_group": [
                {
                    "store_group_id": store_group_id,
                    "store_group_name": "string",
                    "stores": store_list,
                }
            ]
            if store_group_id is not None
            else None,
        }
        return body


# print(GetPromotionCouponBody.get_match_apply_body(**{"codes": 2344, }))
print(
    GetPromotionCouponBody.get_group_mapping_body(product_group_id=2, items="1234,456 ")
)
