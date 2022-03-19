import random


class RequestBodyBuyerReturn(object):
    def __init__(self):
        pass

    @staticmethod
    def get_buyer_return_body(buyer_order_detail, can_return_order, img_url):
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
            if order_lines["returnAvailableQuantity"] != 0:
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
    def get_create_dispute_body(order_number, return_order_number, dispute_items):
        dispute_item_vos = []
        for items in dispute_items:
            dispute_type = random.choice(
                [
                    "Changed Mind",
                    "Not as Described",
                    "Did Not Receive This Item",
                    "Item Was Damaged",
                    "Item Does Not Work",
                    "Wrong Item Was Sent",
                    "Missing Parts or Accessories",
                    "Unacceptable Offer",
                    "Others",
                ]
            )
            dispute = {
                "orderAfterSalesItemId": items.get("orderAfterSalesItemId"),
                "disputeItemQuantity": items.get("quantity"),
                "disputeType": dispute_type,
                "buyerDisputeReason": "automation dispute reason",
                "evidenceMedia": [],
            }
            dispute_item_vos.append(dispute)
        parent_order_number = order_number[3:-2]
        body = {
            "parentOrderNumber": parent_order_number,
            "returnOrderNumber": return_order_number,
            "orderNumber": order_number,
            "disputeItemVos": dispute_item_vos,
        }
        return body

    @staticmethod
    def get_buyer_cancel_dispute_body():
        buyer_cancel_type = random.choice(
            [
                "Item Received",
                "Seller Refunded",
                "Tracking Info Provided",
                "Replacement Item Received",
                "Other",
            ]
        )
        body = {
            "buyerCancelType": buyer_cancel_type,
            "buyerCancelReason": "automation cancel reason",
        }
        return body


if __name__ == "__main__":
    pass
