
import json
import time
from datetime import datetime, timedelta


def get_delta_ts(timestamp: str = None, **kwargs):
    """
    :param timestamp: 13 digits number
    :param kwargs: keys includes weeks, days, hours, minutes, seconds
    :return: 13 digits int
    """
    if not timestamp:
        dt = datetime.now()
    else:
        dt = datetime.fromtimestamp(int(timestamp)/1000)

    if kwargs:
        kwargs = dict(map(lambda item: (item[0], float(item[1])), kwargs.items()))
        dt += timedelta(**kwargs)

    return int(dt.timestamp() * 1000)

def generation_timestamp():
    t = time.time()
    time_120 = t + 1.01293683052063
    return int(round(time_120 * 1000))

def buyer_reservation_req_data(customer_id, order_num, sku_info):
    data = {
        "buyerInventoryItemRoList": [
            {
                "channel": int(info[0]),
                "michaelsStoreId": info[1],
                "skuNumber": info[2],
                "quantity": int(info[3]),
                "shipmentIdx": i
            } for i, info in enumerate(list(map(lambda x: x.split("|"), sku_info)))
        ],
        "customerId": customer_id,
        "orderNumber": str(order_num),
        "shipmentRequests": [
            {
                "shipmentIdx": i,
                "shippingMethod": "ISPU",
                "deliveryMethod": "UPS",
                "shippingAddress": {
                    "firstName": "test",
                    "lastName": "last",
                    "addressLine1": "8000 Bent Branch Dr",
                    "city": "Irving",
                    "state": "TX",
                    "county": "US",
                    "countryId": "US",
                    "zipcode": "75063-6023",
                    "phone": "18672064995",
                    "email": "lang2@michaels.com"
                },
                "deliveryInstructions": "string"

            } for i, info in enumerate(list(map(lambda x: x.split("|"), sku_info)))
        ]
    }
    return data


def post_scheduled_inventory(channel, sku_number, quantity, order_number):
    data = {
        "buyerInventoryItemRoList": [
            {
                "channel": channel,
                "michaelsStoreId": "-1",
                "skuNumber": sku_number,
                "quantity": quantity,
                "shipmentIdx": 0
            }
        ],
        "customerId": "111112",
        "orderNumber": order_number,
        "shipmentRequests": [
            {
                "shipmentIdx": 0,
                "shippingMethod": "ISPU",
                "deliveryMethod": "UPS",
                "shippingAddress": {
                    "firstName": "test",
                    "lastName": "last",
                    "addressLine1": "8000 Bent Branch Dr",
                    "city": "Irving",
                    "state": "TX",
                    "county": "US",
                    "countryId": "US",
                    "zipcode": "75063-6023",
                    "phone": "18672064995",
                    "email": "lang2@michaels.com"
                },
                "deliveryInstructions": "string"

            }
        ],
        "reservationExpiredTime": get_delta_ts(seconds=3)

    }
    return json.dumps(data)


def post_scheduled_inventory_many(channel, sku_number1, sku_number2, quantity, order_number):
    data = {
        "buyerInventoryItemRoList": [
            {
                "channel": channel,
                "michaelsStoreId": "-1",
                "skuNumber": sku_number1,
                "quantity": quantity,
                "shipmentIdx": 0
            },
            {
                "channel": channel,
                "michaelsStoreId": "-1",
                "skuNumber": sku_number2,
                "quantity": quantity,
                "shipmentIdx": 0
            }
        ],
        "customerId": "111112",
        "orderNumber": order_number,
        "shipmentRequests": [
            {
                "shipmentIdx": 0,
                "shippingMethod": "ISPU",
                "deliveryMethod": "UPS",
                "shippingAddress": {
                    "firstName": "test",
                    "lastName": "last",
                    "addressLine1": "8000 Bent Branch Dr",
                    "city": "Irving",
                    "state": "TX",
                    "county": "US",
                    "countryId": "US",
                    "zipcode": "75063-6023",
                    "phone": "18672064995",
                    "email": "lang2@michaels.com"
                },
                "deliveryInstructions": "string"

            }
        ],
        "reservationExpiredTime": generation_timestamp()

    }
    return json.dumps(data)


def delete_scheduled_inventory(order_number,customerId=111112):
    data = {
        "customerId": customerId,
        "orderNumber": order_number
    }
    return json.dumps(data)


def placing_order():
    body = {
        "buyerInventoryItemRoList": [
            {
                "channel": 1,
                "michaelsStoreId": "-1",
                "skuNumber": "10002329",
                "quantity": 2
            }
        ],
        "customerId": "111111",
        "orderNumber": "tttgl0005"
    }
    return body


def add_inventory():
    data = {
        "buyerInventoryItemRoList": [
            {
                "channel": 4,
                "michaelsStoreId": "123214213213",
                "skuNumber": "10554846",
                "quantity": 1
            }
        ],
        "customerId": "1267357421",
        "orderNumber": "2",
        "adjustReason": 0
    }
    return data


def get_inventory_test(channel, sku_number):
    data = [
        {
            "channel": channel,
            "skuNumber": sku_number,
            "michaelsStoreId": "-1"
        }
    ]

    return json.dumps(data)

def get_inventory_list(item_info):
    data = [
        {
            "channel": item[0],
            "skuNumber": item[1],
            "michaelsStoreId": "-1"
        } for item in list(map(lambda x:x.split("|"),item_info))
    ]

    return data

def edit_inventory(masterSkuNumber,channel,editInventoryItem):
    data = {
          "masterSkuNumber": masterSkuNumber,
          "channel":channel,
          "addInventoryItemRos": [
          ],
          "editInventoryItemRos": [
            {
              "inventoryId": item[0],
              "adjustAvailableQuantity": item[1],
              "adjustType": int(item[2])
            } for item in list(map(lambda x:x.split("|"),editInventoryItem))
          ]
    }
    return data


def test_user_subscribe(sku_number, michaels_store_id):
    data = {
        "michaelsStoreId": michaels_store_id,
        "skuNumber": sku_number,
        "quantity": 10,
        "email": "lang2@michaels.com",
        "phone": "18672064995"
    }
    return json.dumps(data)


if __name__ == '__main__':
    print("测试提交")
