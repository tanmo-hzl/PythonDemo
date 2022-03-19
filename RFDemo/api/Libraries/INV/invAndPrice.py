
def inv_price_req_data(item):
    data=[
        {
    "skuNumber": iteminfo[1],
    "channel": int(iteminfo[0]),
    "michaelsStoreId": iteminfo[2]
    } for iteminfo in list(map(lambda x:x.split("|"),item))
    ]
    return data

if __name__=="__main__":
    print(inv_price_req_data(["123|1|-1","123|1|-1"]))