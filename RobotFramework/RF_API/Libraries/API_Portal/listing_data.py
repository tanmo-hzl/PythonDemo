import json
import os
import string
import random
import time
import jsonpath
import requests
from requests_toolbelt import MultipartEncoder
from taxonomy import get_taxonomyPath

stringSet = string.ascii_lowercase + string.ascii_uppercase + ' '
numberSet = '012345678910'

upda_type_list = ['UPC', 'UPC-A', 'GS1-QRcode', 'JAN', 'EAN-8', 'ISBN', 'ASIN']

Uom_list = ['lb', 'kg']

Y_N_list = [True, False]

color_family = ['', 'Orange', 'Gold', 'Yellow', 'Green', 'Purple', 'Pink', 'Silver', 'Grey', 'Black', 'Brown', 'White', 'Red', 'Blue', 'Clear']

# return_policy_list = ['NO_RETURN', 'IN_30_DAYS', 'IN_60_DAYS']
return_policy_list = ['IN_30_DAYS', 'IN_60_DAYS']

listing_status = ['INACTIVE', 'ACTIVE']

variant_name_list = ['Color', 'Model', 'Size', 'Count']

file_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
file_path = os.path.join(file_path, 'CaseData')
file_path = os.path.join(file_path, 'API_Portal')

def get_utin_num(GTIN_type):
    num = ''
    if GTIN_type == 'UPC':
        for i in range(12):
            num += random.choice(numberSet)
    elif GTIN_type == 'UPC-A':
        for i in range(12):
            num += random.choice(numberSet)
    elif GTIN_type == 'GS1-QRcode':
        for i in range(5,20):
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
    for i in range(50):
        item_name += random.choice(stringSet)
    return item_name


def get_brand():
    brand_name = ''
    for i in range(random.randint(1, 30)):
        brand_name += random.choice(stringSet)
    return brand_name


def get_seller_sku():
    seller_sku = ''
    for i in range(random.randint(10, 32)):
        seller_sku += random.choice(numberSet)
    return seller_sku


def get_tag_list():
    tag_list = []
    for i in range(random.randint(1,10)):
        tag = ''
        for i in range(random.randint(3, 15)):
            tag += random.choice(stringSet)
        tag_list.append(tag)
    return tag_list


def get_description():
    description = ''
    for i in range(random.randint(1,3000)):
        description += random.choice(stringSet)
    return description


def get_availableFrom():
    timeStamp = time.time()
    timeStamp = timeStamp + random.randint(0, 864000)
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

    base_url = 'https://mda.tst02.platform.michaels.com/api'
    api_key = 'e5e3cbb27c3bef36e73a05d1c2f8b717f53b8933f0e3e3fe93cafa2567a34c54cdbd4eee144987d4'
    upload_url = '/developer/api/v1/listing/media'
    img_path = os.path.join(file_path, 'test-photo')
    img_list = os.listdir(img_path)
    img = os.path.join(img_path, random.choice(img_list))
    file = {
        'uploadFile': ('api-test.jpeg', open(img, 'rb'), 'image/jpg')
    }
    multipart_encoder = MultipartEncoder(fields=file)
    headers = {
        'Api-Key': api_key,
        'Content-Type': multipart_encoder.content_type,
    }
    response = requests.post(base_url + upload_url, headers=headers, data=multipart_encoder)
    res = json.loads(response.text)
    mediaId = jsonpath.jsonpath(res, '$..mediaId')[0]
    thumbnailUrl = jsonpath.jsonpath(res, '$..thumbnailUrl')[0]
    return mediaId, thumbnailUrl


def get_detail_data():
    media_id, media_url = get_media_info()
    categoryPath, filed_data = get_taxonomyPath()
    GTIN_type = random.choice(upda_type_list)
    data = {
        "details": {
            "globalTradeItemNumberType": GTIN_type,
            "globalTradeItemNumber": get_utin_num(GTIN_type),  # require  <=50 characters
            "itemName": get_item_name(),  # 商品名称  SKU name require <=250 characters
            # "categoryPath": get_taxonomyPath(),
            "categoryPath": categoryPath,
            "brandName": get_brand(),  # require  <=50 characters
            "vendorName": get_brand(),
            "colorFamily": random.choice(color_family),
            "colorName": get_brand(),
            "sellerSkuNumber": get_seller_sku(),  # require  <=32 characters
            # "manufactureName": get_brand(),
            "tags": get_tag_list(),
            "availableFrom": get_availableFrom(),  # require  formatted in yyyy-MM-dd
            # "availableFrom": '2020-01-01',  # require  formatted in yyyy-MM-dd
            "availableTo": "",
            # "status": random.choice(listing_status),  # require  DRAFT or ACTIVE
            "status": 'ACTIVE',
            "description": get_description()  # require <=3000 characters
        },
        "media": {  # require  9 pictures and 1 video at most
            "medias": [  # require
                {
                    "mediaId": media_id,  # require  retrieved from uploading medias response
                    "mediaUrl": media_url
                    # require  retrieved from uploading medias response
                }
            ],
            "videoUrl": None  # only accept video links from Vimeo and YouTube
        },
        "shippingAndRegulation": {  # require
            "weightUom": random.choice(Uom_list),  # Enum: lb, kg
            "weight": int(random.randint(1, 30)),  # require >=0
            "length": str(random.randint(1, 30)),  # require >=0
            "lengthUom": "in",  # Enum: in
            "width": str(random.randint(1, 30)),  # require >=0
            "widthUom": "in",  # Enum: in
            "height": str(random.randint(1, 30)),  # require >=0
            "heightUom": "in",  # Enum: in
            # "volumeUom": "Cu in",  # require >=0  体积
            # "volume": 1,  # Enum: Cu in
            "groundShipOnly": random.choice(Y_N_list),
            # "refundOnly": random.choice(Y_N_list),  # 是否只退款不退货
            "restrictAKHIShip": random.choice(Y_N_list),  # 是否运输至HI和AK
            "p65LabelRequirement": random.choice(Y_N_list),  # required
            "hazmatIndicator": random.choice(Y_N_list),  # required 危险物警告
            # "hazardType": get_random_string(),  # 危害类型
            "flammableContent": random.choice(Y_N_list),  # 是否易燃
            "flammableContentsVerbiage": get_random_string(),  # 易燃物品种类 <=200 characters
            "freeStandardShipping": random.choice(Y_N_list),  # 是否免运费
            "overrideShippingRate": random.choice(Y_N_list),  # required 是否自定义运费
            "standardRate": random.randint(1, 100),  # >=0  标准运费
            "expeditedRate": random.randint(1, 100),  # >=0 加急运费
            "ltlFreightRate": random.randint(1, 100),
            # >=0 LTL freight to non-zero, then the standard rate would be overwritten with 0
            "overrideReturnPolicy": random.choice(Y_N_list),  #
            "refundOnly": False,
            "returnPolicyOption": random.choice(return_policy_list)
            # 退货选项 available options are: NO_RETURN, IN_30_DAYS, IN_60_DAYS
        },
        "priceAndInventory": {  # require
            "price": str(random.randint(1, 1000)),  # > 0
            "quantity": str(random.randint(10, 10000)),  # require > 0  <99999999
            "percentOffOnPrice": random.randint(1, 99),
            # >= 0  <=100  percent off on price for subscription，subscription discounts
            "percentOffOnRepeatDeliveries": random.randint(1, 99)  # >= 0  <=100  subscription discounts
        },
    }
    if random.choice(Y_N_list):
        for key, value_list in filed_data.items():
            value = random.choice(value_list)
            data['details'][key] = value
    return data


def get_variants_detail():

    media_id, media_url = get_media_info()
    GTIN_type = random.choice(upda_type_list)
    data = {
        "details": {
            "globalTradeItemNumberType": GTIN_type,
            "globalTradeItemNumber": get_utin_num(GTIN_type),
            "sellerSkuNumber": get_seller_sku(),
        },
        "media": {
            "medias": [
                {
                    "mediaUrl": media_url
                }
            ],
            "videoUrl": None
        },
        "shippingAndRegulation": {
            "weightUom": random.choice(Uom_list),
            "weight": int(random.randint(1, 30)),
            "length": str(random.randint(1, 30)),
            "lengthUom": "in",  # Enum: in
            "width": str(random.randint(1, 30)),
            "widthUom": "in",  # Enum: in
            "height": str(random.randint(1, 30)),
            "heightUom": "in"
        },
        "priceAndInventory": {  # require
            "price": str(random.randint(1, 1000)),
            "quantity": str(random.randint(10, 10000)),
        },
    }
    return data


def get_variants():
    variants_list = []
    for i in range(1, 2):
        content = {}
        content['variantId'] = str(i - 1)
        content['variantName'] = random.choice(variant_name_list)
        variantOptions = []
        for i in range(random.randint(1, 6)):
            Option = {}
            name = get_random_variantName()
            Option['name'] = name
            swatchMedia = {}
            media_id, media_url = get_media_info()
            swatchMedia['mediaId'] = media_id
            swatchMedia['mediaUrl'] = media_url
            Option['swatchMedia'] = swatchMedia
            variantOptions.append(Option)
        content['variantOptions'] = variantOptions
    variants_list.append(content)
    return variants_list


def get_variation():
    variants = get_variants()
    variationDetails = []
    property_list = []
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
            detail = get_variants_detail()
            detail['attrs'] = attr
            variationDetails.append(detail)
        return variationDetails, variants
    if len(property_list) == 2:
        for i in property_list[0]:
            for j in property_list[1]:
                attr = {"0": i, "1": j}
                detail = get_variants_detail()
                detail['attrs'] = attr
                variationDetails.append(detail)
        return variationDetails, variants


def get_listing_data():
    detail = get_detail_data()

    variationDetails, variants = get_variation()
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
    if 'variation' in detail:
        seller_sku_list = []
        seller_sku_info_list = detail['variation']['variationDetails']
        for i in seller_sku_info_list:
            seller_sku_list.append(i['details']['sellerSkuNumber'])
    else:
        seller_sku_list = [detail['details']['sellerSkuNumber']]
    seller_sku_content['sellerSkuNumbers'] = seller_sku_list
    json.dump(seller_sku_content, open(os.path.join(file_path, 'seller_sku.json'), 'w'), indent=4)

    return detail


if __name__ == '__main__':

    print(get_media_info())
    # get_listing_data()
