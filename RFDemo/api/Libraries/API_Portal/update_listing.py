import os
import random
import string
import time

stringSet = string.ascii_lowercase + string.ascii_uppercase + ' '
numberSet = '012345678910'

upda_type_list = ['UPC', 'UPC-A', 'GS1-QRcode', 'JAN', 'EAN-8', 'ISBN', 'ASIN']

Uom_list = ['lb', 'kg']

Y_N_list = [True, False]

color_family = ['', 'Orange', 'Gold', 'Yellow', 'Green', 'Purple', 'Pink', 'Silver', 'Grey', 'Black', 'Brown', 'White',
                'Red', 'Blue', 'Clear']

# return_policy_list = ['NO_RETURN', 'IN_30_DAYS', 'IN_60_DAYS']
return_policy_list = ['IN_30_DAYS', 'IN_60_DAYS']

listing_status = ['DRAFT', 'ACTIVE']

variant_name_list = ['Color', 'Model', 'Size', 'Count']

file_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
file_path = os.path.join(file_path, 'CaseData')
file_path = os.path.join(file_path, 'API_Portal')


class update_listing():

    def __init__(self):

        pass

    @staticmethod
    def add_tag_number(data, amount):

        tag_list = data['details']['tags']
        while len(tag_list) < int(amount):
            tag = ''
            for i in range(random.randint(3, 15)):
                tag += random.choice(stringSet)
            tag_list.append(tag)
        data['details']['tags'] = tag_list
        return data

    @staticmethod
    def remove_tag(data):

        tag_list = []
        data['details']['tags'] = tag_list
        return data

    @staticmethod
    def add_tag_length(data, length):

        tag_list = data['details']['tags']
        tag = ''
        for i in range(int(length)):
            tag += random.choice(stringSet)
        tag_list[0] = tag
        data['details']['tags'] = tag_list
        return data

    @staticmethod
    def change_date(data, start_date='', end_date=''):

        data['details']['availableFrom'] = start_date
        data['details']['availableTo'] = end_date
        return data

    @staticmethod
    def change_brand_length(data, length):

        brand_name = ''
        for i in range(int(length)):
            brand_name += random.choice(stringSet)
        data['details']['brandName'] = brand_name
        return data

    @staticmethod
    def change_listing_status(data, status):

        data['details']['status'] = status
        return data

    @staticmethod
    def get_listing_status(data):

        return data['data']['status']

    @staticmethod
    def change_listing_shipment_item(data, item, value):

        data['shippingAndRegulation'][item] = value
        return data

    @staticmethod
    def change_listing_percent_off(data, value):

        data['priceAndInventory']['percentOffOnPrice'] = value
        data['priceAndInventory']['percentOffOnRepeatDeliveries'] = value
        return data


    @staticmethod
    def change_listing_name(data, value):

        data['details']['itemName'] = value
        return data

    @staticmethod
    def change_gtin_type(data):

        gtin = data['details']['globalTradeItemNumberType']
        upda_type_list = ['UPC', 'UPC-A', 'GS1-QRcode', 'JAN', 'EAN-8', 'ISBN', 'ASIN']
        upda_type_list.remove(gtin)
        GTIN_type = random.choice(upda_type_list)
        data['details']['globalTradeItemNumberType'] = GTIN_type
        num = ''
        if GTIN_type == 'UPC':
            for i in range(12):
                num += random.choice(numberSet)
        elif GTIN_type == 'UPC-A':
            for i in range(12):
                num += random.choice(numberSet)
        elif GTIN_type == 'GS1-QRcode':
            for i in range(5, 20):
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
        data['details']['globalTradeItemNumber'] = num
        return data

    @staticmethod
    def change_invalid_item_name(data, value):

        timeStamp = time.time()
        timeArray = time.localtime(timeStamp)
        otherStyleTime = time.strftime("%Y%m%d", timeArray)
        if value == 0:
            item_name = f'API-test {otherStyleTime} '
            for i in range(233):
                if i % 10 == 0:
                    item_name += ' '
                else:
                    item_name += random.choice(stringSet)
        else:
            item_name = ''
        data['details']['itemName'] = item_name
        return data

    @staticmethod
    def change_invalid_color_family(data):

        color_family = '123'
        data['details']['colorFamily'] = color_family
        return data

    @staticmethod
    def change_invalid_color_name(data):

        color_name = '1'*51
        data['details']['colorName'] = color_name
        return data

    @staticmethod
    def change_invalid_vendor_name(data):

        vendor_name = '1'*51
        data['details']['vendorName'] = vendor_name
        return data

    @staticmethod
    def change_invalid_manufacture_name(data):

        manufacture_name = '1'*51
        data['details']['manufactureName'] = manufacture_name
        return data

    @staticmethod
    def change_item_name(data, item_name=''):

        data['details']['itemName'] = item_name
        return data

    @staticmethod
    def change_exceed_item_name(data):

        data['details']['itemName'] = '0'*251
        return data

    @staticmethod
    def delete_base_key(data,key,key1='',key2='',key3=''):

        if not key1:
            del data[key]
        elif not key2:
            del data[key][key1]
        elif not key3:
            del data[key][key1][key2]
        else:
            del data[key][key1][key2][key3]
        return data

    @staticmethod
    def delete_variation_key(data,key,key1='',key2='',key3=''):

        for i in range(len(data['variation']['variationDetails'])):
            if not key1:
                del data['variation']['variationDetails'][i][key]
            elif not key2:
                del data['variation']['variationDetails'][i][key][key1]
            elif not key3:
                del data['variation']['variationDetails'][i][key][key1][key2]
            else:
                del data['variation']['variationDetails'][i][key][key1][key2][key3]
        return data

    @staticmethod
    def delete_variation_media_key(data,key,key1='',key2='',key3=''):

        for i in range(len(data['variation']['variationDetails'])):
            for j in range(len(data['variation']['variationDetails'][i]['media']['medias'])):
                if not key1:
                    del data['variation']['variationDetails'][i]['media']['medias'][j][key]
                elif not key2:
                    del data['variation']['variationDetails'][i]['media']['medias'][j][key][key1]
                elif not key3:
                    del data['variation']['variationDetails'][i]['media']['medias'][j][key][key1][key2]
                else:
                    del data['variation']['variationDetails'][i]['media']['medias'][j][key][key1][key2][key3]
        return data

    @staticmethod
    def delete_variats_key(data,key,key1='',key2='',key3=''):

        for i in range(len(data['variation']['variants'])):
            if not key1:
                del data['variation']['variants'][i][key]
            elif not key2:
                del data['variation']['variants'][i][key][key1]
            elif not key3:
                del data['variation']['variants'][i][key][key1][key2]
            else:
                del data['variation']['variants'][i][key][key1][key2][key3]
        return data

    @staticmethod
    def delete_variantOptions_key(data,key,key1='',key2='',key3=''):

        for i in range(len(data['variation']['variants'])):
            for j in range(len(data['variation']['variants'][i]['variantOptions'])):
                if not key1:
                    del data['variation']['variants'][i]['variantOptions'][j][key]
                elif not key2:
                    del data['variation']['variants'][i]['variantOptions'][j][key][key1]
                elif not key3:
                    del data['variation']['variants'][i]['variantOptions'][j][key][key1][key2]
                else:
                    del data['variation']['variants'][i]['variantOptions'][j][key][key1][key2][key3]
        return data

    @staticmethod
    def delete_mediaId(data):

        for i in range(len(data['media']['medias'])):
            del data['media']['medias'][i]['mediaUrl']
        return data

