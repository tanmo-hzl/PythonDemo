import random
import string


def get_query_orders_param(query_params):
    start_time = query_params.get("startTime")
    end_time = query_params.get("endTime")
    order_number_list = query_params.get("orderNumberList")
    order_status_list = query_params.get("orderStatusList")
    is_asc = query_params.get("isAsc")
    page_number = query_params.get("pageNumber")
    param = {
        "startTime":  start_time if start_time else "",
        "endTime": end_time if end_time else "",
        "orderNumberList": order_number_list if order_number_list else "",
        "orderStatusList": order_status_list if order_status_list else "",
        "isAsc": is_asc if is_asc else "",
        "pageNumber": page_number if page_number else 1
        if query_params.get("pageNumber")
        else "1",
        "pageSize": query_params.get("pageSize")
        if query_params.get("pageSize")
        else "10",
        "simpleMode": query_params.get("simpleMode")
        if query_params.get("simpleMode")
        else False,
    }
    return param


def get_confirm_orders_body(order_numbers: list):
    """
    Targeted order number list, separated with comma ','
    """
    body = {"orderNumbers": order_numbers}
    return body


def get_shipment_order_items_body(order_number, carrier, shipment_item_list):
    """
    :param order_number:
    :param carrier:
    :param shipment_item_list: {quantity:int, orderItemId:str}
    :return:
    """
    body = {
        "orderNumber": order_number,
        "shipmentsList": [
            {
                "trackingNumber": "".join(map(lambda x: random.choice(string.digits+string.ascii_letters), range(10))),
                "carrier": carrier,
                "carrierTrackingUrl": "https://tools.usps.com/go/TrackConfirmAction_input",
                "shipmentItemList": shipment_item_list,
            }
        ],
    }
    return body


def get_cancel_order_body(
    order_number,
    order_items: list,
    cancel_reason="Out of Stock",
):
    cancel_order_lines = []
    print(order_items)
    for order_item_id in order_items:
        cancel_order_line = {
            "orderItemId": order_item_id,
            "ordeItemCancelReason": cancel_reason,
        }
        cancel_order_lines.append(cancel_order_line)
    body = {
        "cancelReason": cancel_reason,
        "orderNumber": order_number,
        "cancelOrderLines": cancel_order_lines,
    }
    return body


def get_order_number_by_user_id(
    res,
    user_id,
):
    page_data = res["data"]["pageData"]
    for data in page_data:
        for order_detail in data["orderLines"]:
            if order_detail["userId"] == user_id:
                return data["orderNumber"]
    else:
        raise Exception(f"Not found order_number with this user_id :{user_id}")


def get_order_number_by_user_id_refundable(
    res,
    user_id,
):
    page_data = res["data"]["pageData"]
    for data in page_data:
        for order_detail in data["orderLines"]:
            if (
                order_detail["userId"] == user_id
                and order_detail["refundable"] == "FALSE"
            ):
                return data["orderNumber"]
    else:
        raise Exception(f"Not found order_number with this user_id :{user_id}")


def get_approve_refund_body(return_number, return_item_id: list):
    body = {"returnNumber": return_number, "returnItemIds": return_item_id}
    return body


def get_reject_refund_body(return_number, return_items: list):
    return_lines = []
    for returnItemId in return_items:
        return_line = {
            "returnItemId": returnItemId,
            "refundRejectReason": "OK",
            "refundRejectComment": "OK",
            "sellerRejectRefundMedia": [],
        }
        return_lines.append(return_line)
    body = {
        "returnNumber": return_number,
        "returnLines": return_lines,
    }
    return body


def get_process_a_return(return_number, item_ids: dict):
    return_lines = []
    approve_item_ids = item_ids.get("approve_item_ids")
    reject_item_ids = item_ids.get("reject_item_ids")
    if approve_item_ids:
        for item in approve_item_ids:
            approve_item = {"action": "APPROVE", "returnItemId": item}
            return_lines.append(approve_item)
    if reject_item_ids:
        for item in reject_item_ids:
            reject_item = {
                "action": "REJECT",
                "returnItemId": item,
                "refundRejectReason": "Item was damaged",
                "refundRejectComment": "",
                "sellerRejectRefundMedia": [""],
            }
            return_lines.append(reject_item)

    body = {"returnNumber": return_number, "returnLines": return_lines}
    return body


def get_order_status_list(num: int):
    order_status_list = [
        "PENDING_CONFIRMATION",
        "READY_TO_SHIP",
        "PARTIAL_FULFILLED",
        "FULFILLED",
        "PARTIAL_DELIVERED",
        "DELIVERED",
        "PARTIAL_COMPLETED",
        "COMPLETED",
        "CANCELLED",
    ]
    return random.sample(order_status_list, k=num)


def get_random_stings(num: int):
    return "".join(
        random.choice(string.ascii_lowercase + string.digits) for _ in range(num)
    )


def get_query_returns_param(query_param):
    param = {
        "startTime": query_param.get("startTime"),
        "endTime": query_param.get("endTime"),
        "orderNumber": query_param.get("orderNumber"),
        "returnNumber": query_param.get("returnNumber"),
        "returnStatusList": query_param.get("returnStatusList"),
        "isAsc": query_param.get("isAsc") if query_param.get("isAsc") else False,
        "pageNumber": query_param.get("pageNumber")
        if query_param.get("pageNumber")
        else "1",
        "pageSize": query_param.get("pageSize")
        if query_param.get("pageSize")
        else "10",
    }
    return param


def get_reject_request_body(return_order_number, return_item_id):

    body = {
        "returnOrderNumber": return_order_number,
        "returnOrderLines": [
            {
                "returnItemId": return_item_id,
                "refundRejectReason": "OK",
                "refundRejectComment": "OK",
                "sellerRejectRefundMedia": [],
            }
        ],
    }
    return body


def get_return_status_list(num: int):
    order_status_list = [
        "PENDING_RETURN",
        "SHIPPED",
        "PARTIALLY_RECEIVED",
        "RECEIVED",
        "PARTIALLY_REFUNDED",
        "REFUNDED",
        "REFUND_REJECTED",
        "CANCELLED",
    ]
    return random.sample(order_status_list, k=num)
