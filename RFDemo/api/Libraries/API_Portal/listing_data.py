import configparser
import json
import os
import random
import string
import time

import jsonpath
import requests
from requests_toolbelt import MultipartEncoder
from taxonomy import get_taxonomyPath

stringSet = string.ascii_lowercase + string.ascii_uppercase + ' '
stringSet1 = string.ascii_lowercase + string.ascii_uppercase
numberSet = '012345678910'

upda_type_list = ['UPC', 'UPC-A', 'GS1-QRcode', 'JAN', 'EAN-8', 'ISBN', 'ASIN']

Uom_list = ['lb', 'kg', 'oz', 'g']

Y_N_list = [True, False]

color_family = ['', 'Orange', 'Gold', 'Yellow', 'Green', 'Purple', 'Pink', 'Silver', 'Grey', 'Black', 'Brown', 'White',
                'Red', 'Blue', 'Clear']

# return_policy_list = ['NO_RETURN', 'IN_30_DAYS', 'IN_60_DAYS']
return_policy_list = ['IN_30_DAYS', 'IN_60_DAYS']

listing_status = ['INACTIVE', 'ACTIVE']

variant_name_list = ['Color', 'Model', 'Size', 'Count']

file_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
config_path = os.path.join(file_path, 'config.ini')
file_path = os.path.join(file_path, 'CaseData')
file_path = os.path.join(file_path, 'API_Portal')

config = configparser.ConfigParser()
config.read(config_path)
base_url = config.get('API_Portal', 'url')
api_key = config.get('API_Portal', 'api_key')
upload_url = config.get('API_Portal', 'upload_url')


def get_utin_num(GTIN_type):
    num = ''
    if GTIN_type == 'UPC':
        for i in range(12):
            num += random.choice(numberSet)
    elif GTIN_type == 'UPC-A':
        for i in range(12):
            num += random.choice(numberSet)
    elif GTIN_type == 'GS1-QRcode':
        # for i in range(5,20):
        for i in range(14):
            num += random.choice(numberSet)
    elif GTIN_type == 'JAN':
        for i in range(9):
            num += random.choice(numberSet)
    elif GTIN_type == 'EAN-8':
        for i in range(8):
            num += random.choice(numberSet)
    elif GTIN_type == 'ISBN':
        for i in range(13):
            num += random.choice(numberSet)
    elif GTIN_type == 'ASIN':
        for i in range(10):
            num += random.choice(numberSet)
    return num


def get_item_name():
    timeStamp = time.time()
    timeArray = time.localtime(timeStamp)
    otherStyleTime = time.strftime("%Y%m%d", timeArray)
    item_name = f'API-test {otherStyleTime} '
    for i in range(random.randint(20, 100)):
        if i % 10 == 0:
            item_name += ' '
        else:
            item_name += random.choice(stringSet)
    return item_name


def get_brand():
    brand_name = ''
    for i in range(random.randint(1, 30)):
        brand_name += random.choice(stringSet1)
    return brand_name


def get_seller_sku():
    seller_sku = ''
    for i in range(random.randint(10, 32)):
        seller_sku += random.choice(numberSet)
    return seller_sku


def get_tag_list():
    tag_list = []
    for i in range(random.randint(1, 10)):
        tag = ''
        for i in range(random.randint(3, 20)):
            tag += random.choice(stringSet1)
        tag_list.append(tag)
    return tag_list


def get_description():
    description = ''
    for i in range(random.randint(1, 10)):
        # for i in range(random.randint(2000,3000)):
        description += random.choice(stringSet1)
    return description


def get_availableFrom():
    timeStamp = time.time()
    timeStamp = timeStamp + random.randint(-864000, 864000)
    timeArray = time.localtime(timeStamp)
    otherStyleTime = time.strftime("%Y-%m-%d", timeArray)
    return otherStyleTime


def get_random_string():
    content = ''
    for i in range(10):
        content += random.choice(stringSet)
    return content


def get_random_variantName():
    content = ''
    for i in range(5):
        content += random.choice(stringSet)
    return content


def get_media_info():
    img_path = os.path.join(file_path, 'test-photo')
    img_list = os.listdir(img_path)
    img = os.path.join(img_path, random.choice(img_list))
    # img = os.path.join(img_path, 'svitlana-_ETKZwUXMJg-unsplash.jpg')
    print(img)
    file = {
        'uploadFile': ('api-test.jpeg', open(img, 'rb'), 'image/jpg')
    }
    multipart_encoder = MultipartEncoder(fields=file)
    headers = {
        'Api-Key': api_key,
        'Content-Type': multipart_encoder.content_type,
    }
    response = requests.post(base_url + upload_url, headers=headers, data=multipart_encoder)
    print(response.text)
    res = json.loads(response.text)
    mediaId = jsonpath.jsonpath(res, '$..mediaId')[0]
    thumbnailUrl = jsonpath.jsonpath(res, '$..thumbnailUrl')[0]
    return mediaId, thumbnailUrl


def get_medias():
    medias_list = []
    for i in range(random.randint(1, 2)):
        media_id, media_url = get_media_info()
        medias = {'mediaUrl': media_url}
        medias_list.append(medias)
    return medias_list

def get_hazmat_result():

    hazmat_result = random.choice(Y_N_list)
    # hazmat_result = False
    if hazmat_result == True:
        ground_only = True
        free_ship = False
        expedited = None
        ltl = None
        standard = str(round(random.uniform(0, 999999999.99),2))
    else:
        ground_only = random.choice(Y_N_list)
        free_ship = random.choice(Y_N_list)
        # free_ship = False
        if free_ship == True:
            ltl = None
            standard = None
            expedited = str(round(random.uniform(0, 999999999.99),2))
        else:
            if random.choice(Y_N_list):
                ltl = None
                standard = str(round(random.uniform(0, 999999999.99),2))
                expedited = random.randint(1, 999999999)
            else:
                ltl = str(round(random.uniform(0, 999999999.99),2))
                standard = None
                expedited = None
    return hazmat_result,ground_only,free_ship,expedited,ltl,standard

def get_return_result():

    override_return = random.choice(Y_N_list)
    if override_return == False:
        refund_only = None
        return_policy = None
    else:
        refund_only = random.choice(Y_N_list)
        return_policy = random.choice(return_policy_list)
    return override_return, refund_only, return_policy

def get_weight():

    #Uom_list = ['lb', 'kg', 'oz', 'g']
    weightUom = random.choice(Uom_list)
    if weightUom == 'lb':
        weight = round(random.uniform(0.01, 150), 2)
    elif weightUom == 'kg':
        weight = round(random.uniform(0.01, 68), 2)
    elif weightUom == 'oz':
        weight = round(random.uniform(0.01, 2400), 2)
    elif weightUom == 'g':
        weight = round(random.uniform(0.01, 68038))
    else:
        weight = 0
    return weightUom, weight

def get_length_value():

    length = round(random.uniform(0.01, 108), 2)
    num = str((165-length)/2)
    num = float(num[:num.index('.')+3])
    width = round(random.uniform(0.01, num), 2)
    height = str(random.uniform(0.01, num-width))
    height = float(height[:height.index('.') + 3])
    return length, width, height

def get_detail_data():
    medias_list = get_medias()
    categoryPath, filed_data = get_taxonomyPath()
    GTIN_type = random.choice(upda_type_list)
    hazmat_result,ground_only,free_ship,expedited,ltl,standard = get_hazmat_result()
    override_return,refund_only,return_policy = get_return_result()
    override_shiprate = random.choice(Y_N_list)
    # override_shiprate = False
    if not override_shiprate:
        free_ship = False
        expedited = None
        ltl = None
        standard = None
    AKHI_ship = random.choice(Y_N_list)
    weightUom,weight = get_weight()
    length, width, height = get_length_value()
    data = {
        "details": {
            "globalTradeItemNumberType": GTIN_type,
            "globalTradeItemNumber": get_utin_num(GTIN_type),
            # "globalTradeItemNumberType": 'GS1-QRcode',
            # "globalTradeItemNumber": '99812090627670',
            "itemName": get_item_name(),
            "categoryPath": categoryPath,
            # "categoryPath": 'root//Shop Categories//Teacher Supplies//Resources & Management//Early Learning',
            "brandName": get_brand(),
            # "vendorName": get_brand(),
            "colorFamily": random.choice(color_family),
            # "colorFamily": '123456789',
            "colorName": get_brand(),
            "sellerSkuNumber": get_seller_sku(),
            # "sellerSkuNumber": '688502107510811214019',
            "manufactureName": get_brand(),
            "tags": get_tag_list(),
            # "availableFrom": get_availableFrom(),  # require  formatted in yyyy-MM-dd
            "availableFrom": '2020-01-01',  # require  formatted in yyyy-MM-dd
            "availableTo": "",
            # "availableTo": "2020-02-01",
            # "status": random.choice(listing_status),  # require  DRAFT or ACTIVE
            "status": 'ACTIVE',
            "description": get_description(),
            # "description": '0123'
        },
        "media": {  # require  9 pictures and 1 video at most
            "medias": medias_list,
            "videoUrl": None
        },
        "shippingAndRegulation": {  # require
            "weightUom": weightUom,
            "weight": weight,
            "length": length,
            "lengthUom": "in",
            "width": width,
            "widthUom": "in",
            "height": height,
            "heightUom": "in",
            "groundShipOnly": ground_only,
            "restrictAKHIShip": AKHI_ship,
            "hazmatIndicator":hazmat_result,
            "flammableContent": random.choice(Y_N_list),
            "overrideShippingRate": override_shiprate,
            "freeStandardShipping": free_ship,
            "standardRate": standard,
            "expeditedRate": expedited,
            "ltlFreightRate": ltl,
            "overrideReturnPolicy": override_return,
            "refundOnly": refund_only,
            "returnPolicyOption": return_policy
        },
        "priceAndInventory": {  # require
            "price": str(random.randint(1, 1000)),  # > 0
            "quantity": str(random.randint(10, 10000)),  # require > 0  <99999999
            # "quantity": "0",
        },
    }
    # if random.choice(Y_N_list):
    for key, value_list in filed_data.items():
        value = random.choice(value_list)
        data['details'][key] = value
    return data


def get_least_detail_data():
    medias_list = get_medias()
    categoryPath, filed_data = get_taxonomyPath()
    GTIN_type = random.choice(upda_type_list)
    data = {
        "details": {
            "globalTradeItemNumberType": GTIN_type,
            "globalTradeItemNumber": get_utin_num(GTIN_type),
            "itemName": get_item_name(),
            "categoryPath": categoryPath,
            "brandName": get_brand(),
            "tags": get_tag_list(),
            "status": 'ACTIVE',
            "description": get_description(),
        },
        "media": {
            "medias": medias_list,
        },
        "shippingAndRegulation": {  # require
            "weight": int(random.randint(1, 30)),
            "length": str(random.randint(1, 30)),
            "width": str(random.randint(1, 30)),
            "height": str(random.randint(1, 30)),
        },
        "priceAndInventory": {
            "price": str(random.randint(1, 1000)),
            "quantity": str(random.randint(10, 10000))
        },
    }
    return data


def get_variants_detail(media_id, media_url):
    medias_list = []
    medias = {'mediaUrl': media_url}
    medias_list.append(medias)
    # for i in range(random.randint(1,6)):
    #     medias = {}
    #     medias['mediaId'] = media_id
    #     medias['mediaUrl'] = media_url
    #     medias_list.append(medias)
    GTIN_type = random.choice(upda_type_list)
    weightUom,weight = get_weight()
    length, width, height = get_length_value()
    data = {
        "details": {
            "globalTradeItemNumberType": GTIN_type,
            "globalTradeItemNumber": get_utin_num(GTIN_type),
            "sellerSkuNumber": get_seller_sku(),
        },
        "media": {
            "medias": medias_list,
            "videoUrl": None
        },
        "shippingAndRegulation": {
            "weightUom": weightUom,
            "weight": weight,
            "length": length,
            "lengthUom": "in",  # Enum: in
            "width": width,
            "widthUom": "in",  # Enum: in
            "height": height,
            "heightUom": "in"
        },
        "priceAndInventory": {  # require
            "price": str(round(random.uniform(0, 999999999.99),2)),
            "quantity": str(random.randint(1, 99999999)),
            # "quantity": "0",
        },
    }
    return data


def get_variants(category_name=''):
    media_id, media_url = get_media_info()
    variants_list = []
    # search_variant = get_taxonomy_variants(category_name)
    search_variant = {}
    if search_variant:
        variantName_list = random.sample(list(search_variant.keys()), 3)
    else:
        variantName_list = random.sample(variant_name_list, 3)
    # for i in range(1, 2):
    for i in range(1, random.randint(2, 4)):
        content = {}
        content['variantId'] = str(i - 1)
        variantName = variantName_list[i - 1]
        if search_variant:
            variant_value_list = search_variant[variantName]
        else:
            variant_value_list = []
        # content['variantName'] = random.choice(variant_name_list)
        content['variantName'] = variantName
        variantOptions = []
        for i in range(random.randint(1, 4)):
            Option = {}
            if search_variant:
                name = random.choice(variant_value_list)
            else:
                name = get_random_variantName()
            Option['name'] = name
            swatchMedia = {}
            swatchMedia['mediaUrl'] = media_url
            Option['swatchMedia'] = swatchMedia
            variantOptions.append(Option)
        content['variantOptions'] = variantOptions
        variants_list.append(content)
    return variants_list


def get_variation(category_name=''):
    variants = get_variants(category_name)
    variationDetails = []
    property_list = []
    media_id, media_url = get_media_info()
    for i in variants:
        content_list = []
        option_list = i['variantOptions']
        for j in option_list:
            name = j['name']
            content_list.append(name)
        property_list.append(content_list)
    if len(property_list) == 0:
        return None, variants
    if len(property_list) == 1:
        for i in property_list[0]:
            attr = {"0": i}
            detail = get_variants_detail(media_id=media_id, media_url=media_url)
            detail['attrs'] = attr
            variationDetails.append(detail)
        return variationDetails, variants
    if len(property_list) == 2:
        for i in property_list[0]:
            for j in property_list[1]:
                attr = {"0": i, "1": j}
                detail = get_variants_detail(media_id=media_id, media_url=media_url)
                detail['attrs'] = attr
                variationDetails.append(detail)
        return variationDetails, variants
    if len(property_list) == 3:
        for i in property_list[0]:
            for j in property_list[1]:
                for k in property_list[2]:
                    attr = {"0": i, "1": j, "2": k}
                    detail = get_variants_detail(media_id=media_id, media_url=media_url)
                    detail['attrs'] = attr
                    variationDetails.append(detail)
        return variationDetails, variants


def get_listing_data(is_variant=1):
    detail = get_detail_data()

    if is_variant == 1:
        category_name = detail['details']['categoryPath']
        variationDetails, variants = get_variation(category_name)
        if variationDetails:
            detail['variation'] = {
                'variants': variants,
                'variationDetails': variationDetails
            }

    data_path = os.path.join(file_path, 'create_listing.json')
    json.dump(detail, open(data_path, 'w'), indent=4)

    seller_sku_content = {
        "sellerSkuNumbers": [
        ]
    }
    try:
        if 'variation' in detail:
            seller_sku_list = []
            seller_sku_info_list = detail['variation']['variationDetails']
            for i in seller_sku_info_list:
                seller_sku_list.append(i['details']['sellerSkuNumber'])
        else:
            seller_sku_list = [detail['details']['sellerSkuNumber']]
    except Exception:
        seller_sku_list = []
    seller_sku_content['sellerSkuNumbers'] = seller_sku_list
    primary_seller_sku = {}
    try:
        primary_seller_sku['sellerSkuNumbers'] = detail['details']['sellerSkuNumber']
    except Exception:
        pass
    json.dump(seller_sku_content, open(os.path.join(file_path, 'seller_sku.json'), 'w'), indent=4)
    json.dump(primary_seller_sku, open(os.path.join(file_path, 'primary_seller_sku.json'), 'w'), indent=4)

    return detail


def get_least_listing_data():
    medias_list = get_medias()
    categoryPath, filed_data = get_taxonomyPath()
    GTIN_type = random.choice(upda_type_list)
    data = {
        "details": {
            "itemName": get_item_name(),
            "categoryPath": categoryPath,
            "brandName": get_brand(),
            "tags": get_tag_list(),
            "status": 'ACTIVE',
            "description": get_description(),
        },
        "media": {
            "medias": medias_list,
        },
        "shippingAndRegulation": {
        },
        "priceAndInventory": {
        },
        "variation": {
            "variants": [
                {
                    "variantId": "0",
                    "variantName": "Size",
                    "variantOptions": [
                        {"name": "M"}
                    ],
                },
            ],
            "variationDetails": [
                {
                    "attrs": {"0": "M"},
                    "details": {
                        "globalTradeItemNumberType": GTIN_type,
                        "globalTradeItemNumber": get_utin_num(GTIN_type),
                    },
                    "priceAndInventory": {
                        "price": str(random.randint(1, 1000)),
                        "quantity": str(random.randint(10, 10000))
                    },
                    "shippingAndRegulation": {
                        "weight": int(random.randint(0, 30)),
                        "length": str(random.randint(0, 30)),
                        "width": str(random.randint(0, 30)),
                        "height": str(random.randint(0, 30)),
                    }
                },
            ]
        }
    }
    return data


if __name__ == '__main__':
    # print(json.dumps(get_listing_data()))
    # get_listing_data()
    # print(json.dumps(get_variants(category_name='root//Shop Categories//Storage//Storage Bins, Storage Boxes & Storage Baskets//Decorative Boxes')))
    print(111)