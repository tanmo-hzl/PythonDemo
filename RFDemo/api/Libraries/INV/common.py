
def omni_user_info(item):
    user_info=[
        "grant_type={grant_type}".format(grant_type=item["grant_type"]),
        "username={username}".format(username=item["username"]),
        "password={password}".format(password=item["password"]),
    ]
    str="&"
    user_info=str.join(user_info)
    return user_info

def omni_online(skunumber):
    data={
    "Items": [sku for sku in skunumber],
    "ViewName": "US Shipping"
    }
    return data

def inventory_cache(cache_type,sku_nmber,operate_type,michaels_store_id=-1):

    """
    :param cache_type: omni or mik
    :param skunmber:
    :param operate_type: get or del
    :return:
    """
    data={
        "key":"SKU_MIK_INVENTORY:E:{skuNumber}-{michaelsStoreId}-{cache_type}".format(skuNumber=sku_nmber,
                                                                                      michaelsStoreId=michaels_store_id,
                                                                                      cache_type=cache_type.upper()),"operate":operate_type}
    return data

def price_cache(sku_nmber,operate_type,michaels_store_id=-1):

    """
    :param skunmber:
    :param operate_type: get or del
    :return:
    """
    data={
        "key":"MIK_SKU_PRICE:A:{skuNumber}-{michaelsStoreId}".format(skuNumber=sku_nmber,michaelsStoreId=michaels_store_id),"operate":operate_type}
    return data

if __name__=="__main__":
    print(inventory_cache("OMNI","invtest1","del",-1))