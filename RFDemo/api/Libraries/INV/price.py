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

def add_sku_price_info(michaelsStoreId,masterSkuNumber,skuNumber,price,originPrice):
    data={
        "skuNumber": skuNumber,
        "masterSkuNumber": masterSkuNumber,
        "michaelsStoreId": michaelsStoreId,
        "currency": "USD",
        "originPrice": None if originPrice == "" else originPrice,
        "price": price,
        "discountPrice": 0,
        "cost": 0,
        "minPrice": 0,
        "maxPrice": 0,
        "bundlePriceRule": 0
}
    return data

def update_sku_price_info(skuNumber,price,originPrice):
    data={
        "skuNumber": skuNumber,
        "masterSkuNumber": skuNumber,
        "michaelsStoreId": "-1",
        "currency": "USD",
        "originPrice": None if originPrice == "" else originPrice,
        "price": price,
        "discountPrice": 0,
        "cost": 0,
        "minPrice": 0,
        "maxPrice": 0,
        "bundlePriceRule": 0
}
    return data


def batch_sku_price_info(item_infos):
    data = [
        {
            "skuNumber": item_info[0],
            "masterSkuNumber": item_info[1],
            "michaelsStoreId": "-1",
            "currency": "USD",
            "originPrice": None if item_info[2] == "" else item_info[2],
            "price": item_info[3],
            "discountPrice": 0,
            "cost": 0,
            "minPrice": 0,
            "maxPrice": 0,
            "bundlePriceRule": 0
        }for item_info in list(map(lambda x: x.split("|"), item_infos))
    ]
    return data


def inner_batch_sku_price2(item_infos):
    data=[
        {
            "skuNumber": item_info[1],
            "masterSkuNumber": item_info[0],
            "michaelsStoreId": "-1",
            "currency": item_info[2],
            "originPrice": item_info[3],
            "price": item_info[4],
            "discountPrice": 3,
            "cost": 1,
            "minPrice": 9,
            "maxPrice": 10,
            "bundlePriceRule": "5212174123459174400"
        } for item_info in list(map(lambda x:x.split("|"),item_infos))
        ]
    return data

def inner_batch_sku_price(skuNumber,masterSkuNumber,originPrice,price,currency="USD",michaelsStoreId=-1):
    data=[
        {
            "skuNumber": skuNumber,
            "masterSkuNumber": masterSkuNumber,
            "michaelsStoreId": None if michaelsStoreId=="" else michaelsStoreId,
            "currency": currency,
            "originPrice": originPrice,
            "price": price,
            "discountPrice": 3,
            "cost": 1,
            "minPrice": 9,
            "maxPrice": 10,
            "bundlePriceRule": "5212174123459174400"
        }
        ]
    return data


def price_info(skuNumber,master,currency,price):
    data={
        "skuNumber": skuNumber,
        "masterSkuNumber": master,
        "michaelsStoreId": "-1",
        "currency": currency,
        "originPrice": 0,
        "price": price,
        "discountPrice": 0,
        "cost": 0,
        "minPrice": 0,
        "maxPrice": 0,
        "bundlePriceRule": "bundlePriceRule"
}
    return data


def sku_price_rule_data(item):
    data = {
            "skuNumber": item['sku_number'],
            "masterSkuNumber": item['sku_number'],
            "michaelsStoreId":None if item['michaels_store_id']=="" else item['michaels_store_id'],
            "currency": "USD",
            "price": None if item['price']=="" else float(item['price']),
            "bundlePriceRule": "string",
            "startTime": str(item['start_time']),
            "endTime": str(item['end_time']),
            "remark": "autotest",
            "referType": int(item['refer_type']),
            "referId": item['refer_id']
          }
    return data


def batch_sku_price_rule_data(item_infos):
    data = [
          {
            "skuNumber": item_info[0],
            "masterSkuNumber": item_info[1],
            "michaelsStoreId": "-1",
            "currency": "USD",
            "price": None if item_info[2]=="" else float(item_info[2]),
            "bundlePriceRule": "string",
            "startTime": str(_get_delta_timestamp(**dict([item_info[4].split("=")]))),
            "endTime": str(_get_delta_timestamp(**dict([item_info[5].split("=")]))),
            "remark": "autotest",
            "referType": 0,
            "referId": item_info[3]
          } for item_info in list(map(lambda x: x.split("|"), item_infos))
        ]
    return data

def sku_price_rule_query_data(item_infos):
    data = [
          {
            "skuNumber": item_info[2],
            "masterSkuNumber": item_info[1],
            "michaelsStoreId": item_info[0],
            "currency": "USD",
            "price": None if item_info[3]=="" else float(item_info[3]),
            "bundlePriceRule": "string",
            "startTime": str(_get_delta_timestamp(**dict([item_info[4].split("=")]))),
            "endTime": str(_get_delta_timestamp(**dict([item_info[5].split("=")]))),
            "remark": "autotest",
            "referType": item_info[6],
            "referId": item_info[7]
          } for item_info in list(map(lambda x: x.split("|"), item_infos))
        ]
    return data

def inner_batch_sku_price_rule_data(item_infos):
    data = [
        {
            "skuNumber": item_info[0],
            "masterSkuNumber": item_info[1],
            "michaelsStoreId": "-1",
            "currency": "USD",
            "price": None if item_info[2]=="" else float(item_info[2]),
            "bundlePriceRule": "string",
            "startTime": str(_get_delta_timestamp(**dict([item_info[4].split("=")]))),
            "endTime": str(_get_delta_timestamp(**dict([item_info[5].split("=")]))),
            "remark": "autotest",
            "referType": 0,
            "referId": item_info[3]
        } for item_info in list(map(lambda x: x.split("|"), item_infos))
    ]
    return data

def price_sku(skuNumber):
    sku_list=[]
    for i in skuNumber:
        sku="skuNumbers={}".format(i)
        sku_list.append(sku)
    str="&"
    return  str.join(sku_list)

def price_master_sku(skuNumber):
    sku_list=[]
    for i in skuNumber:
        sku="masterSkuNumbers={}".format(i)
        sku_list.append(sku)
    str="&"
    return  str.join(sku_list)

def price_sku_michaelsstoreid(michaelsStoreId,skuNumbers):
    data={
          "michaelsStoreId":michaelsStoreId,
          "skuNumbers": [sku for sku in skuNumbers]
        }
    return data

if __name__=="__main__":
    print(price_sku_michaelsstoreid(-1,["1","2"]))