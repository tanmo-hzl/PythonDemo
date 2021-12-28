import string
from typing import Optional, List
import random


def get_query_orders_param(
    start_time: Optional[str] = None,
    end_time: Optional[str] = None,
    order_number_list: Optional[str] = None,
    order_status_list: Optional[str] = None,
    is_asc=False,
    page_number: Optional[str] = "1",
    page_size: Optional[str] = "10",
    simple_mode: Optional[str] = "false",
):
    param = {
        "startTime": start_time,
        "endTime": end_time,
        "orderNumberList": order_number_list,
        "orderStatusList": order_status_list,
        "isAsc": is_asc,
        "pageNumber": page_number,
        "pageSize": page_size,
        "simpleMode": simple_mode,
    }
    return param


def get_order_status_list(num: int):
    order_status_list = [
        "OPEN",
        "PENDING_CONFIRMATION",
        "READY_TO_SHIP",
        "PARTIAL_DELIVERED",
        "DELIVERED",
        "PARTIAL_PENDING_RETURN",
        "RETURN_REQUESTED",
        "RETURN_REJECTED",
        "RETURN_REFUND",
        "PARTIAL_REFUND",
        "CANCELLED",
        "PARTIAL_COMPLETED",
        "COMPLETED",
    ]
    return random.sample(order_status_list, k=num)


def get_cancel_order_param(
    order_number: str,
    order_item_id: str,
    quantity=1,
    cancel_reason: Optional[str] = None,
):
    data = {
        "cancelReason": cancel_reason,
        "orderNumber": order_number,
        "cancelOrderLines": [
            {
                "orderItemId": order_item_id,
                "quantity": quantity,
                "cancelReason": cancel_reason,
            }
        ],
    }
    return data


def get_random_stings(num: int):
    return "".join(
        random.choice(string.ascii_lowercase + string.digits) for _ in range(num)
    )


def get_query_return_param(
    start_time: Optional[str] = None,
    end_time: Optional[str] = None,
    order_number: Optional[str] = None,
    return_order_number: Optional[str] = None,
    return_order_status_list: Optional[str] = None,
    is_asc=False,
    page_number: Optional[str] = "1",
    page_size: Optional[str] = "10",
):
    param = {
        "startTime": start_time,
        "endTime": end_time,
        "orderNumber": order_number,
        "returnOrderNumber": return_order_number,
        "returnOrderStatusList": return_order_status_list,
        "isAsc": is_asc,
        "pageNumber": page_number,
        "pageSize": page_size,
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


def get_return_order_status_list(num: int):
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
