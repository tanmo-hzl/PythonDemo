from datetime import datetime, timedelta


def _get_delta_timestamp(timestamp: str = None, **kwargs):
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


def buyer_list_req_data(sku_info):
    data = [
        {
            "channel": info[0],
            "michaelsStoreId": info[1],
            "skuNumber": info[2]
        } for info in list(map(lambda x: x.split("|"), sku_info))
    ]
    return data


def buyer_buy_req_data(customer_id, order_num, sku_info):
    data = {
        "buyerInventoryItemRoList": [
            {
                "channel": info[0],
                "michaelsStoreId": info[1],
                "skuNumber": info[2],
                "quantity": info[3]
            } for info in list(map(lambda x: x.split("|"), sku_info))
        ],
        "customerId": customer_id,
        "orderNumber": order_num
    }
    return data

def buyer_return_req_data(customer_id, order_num, adjust_reason,sku_info):
    data = {
        "buyerInventoryItemRoList": [
            {
                "channel": info[0],
                "michaelsStoreId": info[1],
                "skuNumber": info[2],
                "quantity": info[3]
            } for info in list(map(lambda x: x.split("|"), sku_info))
        ],
        "customerId": customer_id,
        "orderNumber": order_num,
        "adjustReason": int(adjust_reason)
    }
    return data


def buyer_reservation_request_data(customer_id, order_num, sku_info):
    data = {
        "buyerInventoryItemRoList": [
            {
                "channel": info[0],
                "michaelsStoreId": info[1],
                "skuNumber": info[2],
                "quantity": info[3],
                "shipmentIdx": i
            } for i, info in enumerate(list(map(lambda x: x.split("|"), sku_info)))
        ],
        "customerId": customer_id,
        "orderNumber": order_num,
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

            } for i, info_str in enumerate(sku_info)
        ],
        "reservationExpiredTime": _get_delta_timestamp(seconds=5)

    }
    return data



def store_inventorys(masterSkuNumber, channel,skuNumber, availableQuantity, inventoryId, adjustAvailableQuantity, adjustType):
    data = {
        "masterSkuNumber": masterSkuNumber,
        "channel":channel,
        "addInventoryItemRos": [
            {
                "skuNumber": skuNumber,
                "availableQuantity": availableQuantity,
                "minSaleQuantity": "1",
                "maxSaleQuantity": "10",
                "alertQuantityThrehold": "101"
            }
        ],
        "editInventoryItemRos": [
            {
                "inventoryId": inventoryId,
                "adjustAvailableQuantity": adjustAvailableQuantity,
                "adjustType": adjustType
            }
        ]
    }
    return data

def inventory_add_req_data(master_skunumber,channel,sku_and_quantity):
    data={
          "masterSkuNumber": master_skunumber,
          "channel":channel,
          "addInventoryItemRos": [
            {
              "skuNumber": item[0],
              "availableQuantity": item[1],
              "minSaleQuantity": "1",
              "maxSaleQuantity": "1",
              "alertQuantityThrehold": "1"
            } for item in list(map(lambda x:x.split("|"),sku_and_quantity))
          ],
          "editInventoryItemRos": [
          ]
        }
    return data

def inventory_edit_req_data(master_skunumber,channel,inventory_quantity_adjusttpye):
    data={
          "masterSkuNumber": master_skunumber,
          "channel":channel,
          "addInventoryItemRos": [
          ],
          "editInventoryItemRos": [{
          "inventoryId": item[0],
          "adjustAvailableQuantity": item[1],
          "adjustType": int(item[2])
            } for item in list(map(lambda x:x.split("|"),inventory_quantity_adjusttpye))
          ]
        }
    return data

def omni_inventory_req_data(michaels_store_id,skunumbers):
    data={
          "michaelsStoreId": michaels_store_id,
          "skuNumbers": [sku for sku in skunumbers]
        }
    return data

if __name__=="__main__":
    skunumbers=[1]
    print([i for i in skunumbers])