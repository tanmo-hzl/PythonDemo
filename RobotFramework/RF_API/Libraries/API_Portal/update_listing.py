import json
import jsonpath
import os
import requests
from requests_toolbelt import MultipartEncoder
from taxonomy import get_taxonomyPath
import os
import string
import random
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
    def change_listing_shipment_item(data, item, value):

        data['shippingAndRegulation'][item] = value
        return data



