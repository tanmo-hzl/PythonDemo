import configparser
import json
import os
import random

import jsonpath
import requests
from requests_toolbelt import MultipartEncoder
from taxonomy import get_taxonomyPath

file_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
file_path = os.path.join(file_path, 'CaseData')
file_path = os.path.join(file_path, 'API_Portal')

class tools():

    def __init__(self):
        pass

    @staticmethod
    def get_parent_path():
        """
        获取当前文件所在绝对路劲的上一层路径
        :return:
        """
        parent_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
        return parent_path

    def get_config_ini(self, env_name, config_ini_name="config.ini"):
        env_name = env_name.lower()
        config_path = os.path.join(self.get_parent_path(), config_ini_name)
        conf = configparser.ConfigParser()
        conf.read(config_path, encoding="utf-8")
        options = conf.options(env_name)
        config_info = {}
        for item in options:
            config_info[item] = conf.get(env_name, item)

        api_portal_config_path = os.path.join(self.get_parent_path(), 'config.ini')
        config = configparser.ConfigParser()
        config.read(api_portal_config_path)
        url = f'https://mik.{env_name}.platform.michaels.com/api/mda'
        api_key = conf.get(env_name, 'api_key')
        config.set('API_Portal', 'url', url)
        config.set('API_Portal', 'api_key', api_key)
        with open(api_portal_config_path, 'w+') as f:
            config.write(f)

        return config_info

    @staticmethod
    def merge_urls(base_url, path_url):
        return base_url + path_url

    @staticmethod
    def get_status_code(res):
        status_code = jsonpath.jsonpath(res, '$..code')[0]
        return status_code

    @staticmethod
    def get_inventory(res):
        inventory = jsonpath.jsonpath(res, '$..availableQuantity')[0]
        return inventory

    @staticmethod
    def get_update_inventory_data():

        data_path = os.path.join(file_path, 'sku_list.json')
        sku_data = json.load(open(data_path, 'r', encoding='utf8'))
        sku_list = sku_data['sku_num']
        data = []
        for sku in sku_list:
            content = {}
            content['skuNumber'] = sku
            quantity = random.randint(0,9999999)
            content['availableQuantity'] = quantity
            data.append(content)
        return data

    @staticmethod
    def get_hundred_update_inventory_data():

        data_path = os.path.join(file_path, 'sixty_sku_num.json')
        sku_data = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for sku in sku_data:
            content = {}
            content['skuNumber'] = sku
            quantity = random.randint(0,9999999)
            content['availableQuantity'] = quantity
            data.append(content)
        return data

    @staticmethod
    def get_update_inventory_data_by_master_sku():

        data_path = os.path.join(file_path, 'primary_sku_list.json')
        master_sku_data = json.load(open(data_path, 'r', encoding='utf8'))
        master_sku_list = master_sku_data['primarySkuNumber']
        data_path = os.path.join(file_path, 'sku_list.json')
        sub_sku_data = json.load(open(data_path, 'r', encoding='utf8'))
        sub_sku_list = sub_sku_data['sku_num']
        if sub_sku_list ==  master_sku_list:
            master_sku_list = ['-1']
        data = []
        for master_sku in master_sku_list:
            content = {}
            content['skuNumber'] = master_sku
            quantity = random.randint(0,9999999)
            content['availableQuantity'] = quantity
            data.append(content)
        return data

    @staticmethod
    def get_inventory_sku_data():

        data_path = os.path.join(file_path, 'get_sku_inventory.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_sku_num():

        data_path = os.path.join(file_path, 'sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data['sku_num']

    @staticmethod
    def get_sku_num_price():

        data_path = os.path.join(file_path, 'sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))

        return data['sku_num']

    @staticmethod
    def get_variation_sub_sku():

        data_path = os.path.join(file_path, 'sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        master_sku_data_path = os.path.join(file_path, 'primary_sku.json')
        master_sku_data = json.load(open(master_sku_data_path, 'r', encoding='utf8'))
        sub_sku = data['sku_num']
        master_sku = master_sku_data['primarySkuNumber']
        if sub_sku != master_sku:
            return sub_sku
        else:
            return '-1'

    @staticmethod
    def get_primary_sku_num():

        data_path = os.path.join(file_path, 'primary_sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_primary_seller_sku():

        data_path = os.path.join(file_path, 'primary_seller_sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data


    @staticmethod
    def get_bantch_listing_data():

        data_path = os.path.join(file_path, 'primary_sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data['primarySkuNumber']

    @staticmethod
    def get_bantch_master_sku():

        data_path = os.path.join(file_path, 'primary_sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        primary_sku_list = data['primarySkuNumber']
        data_path = os.path.join(file_path, 'sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        sub_sku_list = data['sku_num']
        if sub_sku_list == primary_sku_list:
            return ['-1']
        else:
            return primary_sku_list

    @staticmethod
    def get_query_listing_data():

        data_path = os.path.join(file_path, 'query_listing.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        status_list = ['ACTIVE', 'DRAFT', 'EXPIRED', 'SOLD_OUT', 'INACTIVE']
        sortBy_list = ['UPDATED_TIME', 'TITLE', 'STATUS', 'INVENTORY']
        ascending_list = [True,False]
        data['pageNumber'] = random.randint(1, 10000)
        # data['pageNumber'] = 1
        data['pageSize'] = random.randint(1, 100)
        # data['pageSize'] = 50
        data['sortBy'] = random.choice(sortBy_list)
        data['status'] = random.choice(status_list)
        # data['status'] = ''
        data['ascending'] = random.choice(ascending_list)
        return data

    @staticmethod
    def get_query_sixty_listing_data():

        data_path = os.path.join(file_path, 'query_listing.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        data['pageNumber'] = '1'
        data['pageSize'] = '100'
        data['status'] = ''
        return data

    @staticmethod
    def get_activate_listing_data():

        data_path = os.path.join(file_path, 'activate_listing.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_hundred_activate_listing_data(res1,res2):

        data_path = os.path.join(file_path, 'activate_listing.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        sku_list = []
        data_list = res1['data']['listings']
        for i in data_list:
            if len(sku_list) < 101:
                sku_list.append(i['skuNumber'])
            else:
                break
        data_list = res2['data']['listings']
        for i in data_list:
            if len(sku_list) < 101:
                sku_list.append(i['skuNumber'])
            else:
                break
        if len(sku_list) <= 100:
            code = '200'
        else:
            code = '400'
        data['primarySkuNumbers'] = sku_list
        return [data,code]

    @staticmethod
    def get_deactivate_listing_data():

        data_path = os.path.join(file_path, 'deactivate_listing.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_update_listing_data():

        data_path = os.path.join(file_path, 'create_listing.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_query_financy_data():

        data_path = os.path.join(file_path, 'finance.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_download_template_data():

        data1, filed_data = get_taxonomyPath()
        data2, filed_data = get_taxonomyPath()
        data3 = 'root//Shop Categories//Frames//Shop By Frame Size'
        return {'taxonomyPath': f'{data1}$${data2}$${data3}'}

    @staticmethod
    def write_template(data):

        data_path = os.path.join(file_path, 'template.xlsx')
        with open(data_path, 'wb') as f:
            f.write(data)


    @staticmethod
    def get_export_listing_data():

        data_path = os.path.join(file_path, 'export_template_listing.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        status_list = ['ACTIVE','DRAFT','SOLD_OUT','SUSPEND','INACTIVE','SOLD_OUT']
        sort_list = ['UPDATED_TIME','TITLE','STATUS']
        ascending_list = [True,False]
        data = {}
        data['pageNumber'] = random.randint(1, 10000)
        data['pageSize'] = random.randint(1, 100)
        data['status'] = random.choice(status_list)
        data['primarySkuNumbers'] = ''
        data['sortBy'] = random.choice(sort_list)
        data['ascending'] = random.choice(ascending_list)
        return data

    @staticmethod
    def write_expost_listing(data):

        data_path = os.path.join(file_path, 'export_listing.xlsx')
        with open(data_path, 'wb') as f:
            f.write(data)

    @staticmethod
    def get_batch_sku():

        data_path = os.path.join(file_path, 'sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return {'skuNumbers': data['sku_num']}

    @staticmethod
    def get_hundred_sku():

        data_path = os.path.join(file_path, 'sixty_sku_num.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_sub_sku_list():

        data_path = os.path.join(file_path, 'sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data['sku_num']

    @staticmethod
    def get_inactive_subsku():

        data_path = os.path.join(file_path, 'sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        result_list = []
        for sku in data['sku_num']:
            content = {}
            content['sellerSkuNumber'] = ''
            content['skuNumber'] = sku
            content['status'] = 'INACTIVE'
            result_list.append(content)
        return result_list

    @staticmethod
    def get_inactive_mastersku():

        data_path = os.path.join(file_path, 'primary_sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        master_sku_list = data['primarySkuNumber']
        result_list = []
        for sku in master_sku_list:
            content = {}
            content['sellerSkuNumber'] = ''
            content['skuNumber'] = sku
            content['status'] = 'INACTIVE'
            result_list.append(content)
        return result_list

    @staticmethod
    def get_active_subsku():

        data_path = os.path.join(file_path, 'sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        result_list = []
        for sku in data['sku_num']:
            content = {}
            content['sellerSkuNumber'] = ''
            content['skuNumber'] = sku
            content['status'] = 'ACTIVE'
            result_list.append(content)
        return result_list

    @staticmethod
    def get_active_masetrsku():

        data_path = os.path.join(file_path, 'primary_sku_list.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        master_sku_list = data['primarySkuNumber']
        result_list = []
        for sku in master_sku_list:
            content = {}
            content['sellerSkuNumber'] = ''
            content['skuNumber'] = sku
            content['status'] = 'ACTIVE'
            content['availableFrom'] = '2022-01-01'
            content['availableTo'] = '2022-04-01'
            result_list.append(content)
        return result_list

    @staticmethod
    def get_exceed_sub_sku_list():

        data_path = os.path.join(file_path, 'sixty_sku_num.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_exceed_seller_sku_list():

        data_path = os.path.join(file_path, 'number_seller_sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data


    @staticmethod
    def post_media(base_url, upload_url, api_key):

        img_path = os.path.join(file_path, 'test-photo')
        img_list = os.listdir(img_path)
        # img = os.path.join(img_path, random.choice(img_list))
        img = os.path.join(img_path, 'svitlana-_ETKZwUXMJg-unsplash.jpg')
        print(img)
        file = {
            'uploadFile': ('api-test.jpeg', open(img, 'rb'), 'image/jpg'),
        }
        multipart_encoder = MultipartEncoder(fields=file)
        headers = {
            'Api-Key': api_key,
            'Content-Type': multipart_encoder.content_type,
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
        }
        response = requests.post(base_url + upload_url, headers=headers, data=multipart_encoder)
        res = json.loads(response.text)
        print(res)
        try:
            status = response.status_code
            mediaId = jsonpath.jsonpath(res, '$..mediaId')[0]
            thumbnailUrl = jsonpath.jsonpath(res, '$..thumbnailUrl')[0]
        except Exception:
            status = '400'
            mediaId = ''
            thumbnailUrl = jsonpath.jsonpath(res, '$..message')[0]
        return [status, mediaId, thumbnailUrl]

    @staticmethod
    def post_error_media(base_url, upload_url, api_key):

        error_img = os.path.join(file_path, 'cancel_order.json')
        file = {
            'uploadFile': ('api-test.jpeg', open(error_img, 'rb'), 'image/jpg'),
        }
        multipart_encoder = MultipartEncoder(fields=file)
        headers = {
            'Api-Key': api_key,
            'Content-Type': multipart_encoder.content_type,
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
        }
        response = requests.post(base_url + upload_url, headers=headers, data=multipart_encoder)
        res = json.loads(response.text)
        status = response.status_code
        print(status,res)
        return [status,repr(res)]

    @staticmethod
    def post_empty_media(base_url, upload_url, api_key):

        # error_img = os.path.join(file_path, 'cancel_order.json')
        file = {
            'uploadFile': ('api-test.jpeg', '', 'image/jpg'),
        }
        multipart_encoder = MultipartEncoder(fields=file)
        headers = {
            'Api-Key': api_key,
            'Content-Type': multipart_encoder.content_type,
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
        }
        response = requests.post(base_url + upload_url, headers=headers, data=multipart_encoder)
        res = json.loads(response.text)
        status = response.status_code
        print(status,res)
        return [status,repr(res)]

    @staticmethod
    def post_template(base_url, upload_url, api_key):

        data_path = os.path.join(file_path, 'import-create-active.xlsx')
        headers = {
            'Api-Key': api_key,
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
        }
        files = {"uploadFile": open(data_path, 'rb')}
        response = requests.post(base_url + upload_url, headers=headers, files=files)
        print(response.text)
        res = json.loads(response.text)
        status = jsonpath.jsonpath(res, '$..code')[0]
        if str(status) != '200':
            status = '400'
        msg = jsonpath.jsonpath(res, '$..message')[0]
        return [status, msg]

    @staticmethod
    def asyn_post_template(base_url, upload_url, api_key):

        data_path = os.path.join(file_path, 'import-create-active.xlsx')
        headers = {
            'Api-Key': api_key,
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
        }
        files = {"uploadFile": open(data_path, 'rb')}
        response = requests.post(base_url + upload_url, headers=headers, files=files)
        print(response.text)
        res = json.loads(response.text)
        status = jsonpath.jsonpath(res, '$..code')[0]
        if str(status) != '200':
            status = '400'
        task_id = jsonpath.jsonpath(res, '$..data..taskId')[0]
        return [status, task_id]

    @staticmethod
    def get_seller_sku():

        data_path = os.path.join(file_path, 'seller_sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_hundred_seller_sku():

        data_path = os.path.join(file_path, 'number_seller_sku.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        data = data[0:100]
        data = {
            "sellerSkuNumbers":data
        }
        return data

    @staticmethod
    def get_seller_sku_update_invenroty():

        data_path = os.path.join(file_path, 'seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for seller_sku in seller_sku_info['sellerSkuNumbers']:
            content = {}
            content['sellerSkuNumber'] = seller_sku
            quantity = random.randint(10,1000)
            content['availableQuantity'] = quantity
            data.append(content)
        return data

    @staticmethod
    def get_hunderd_seller_sku_update_invenroty():

        data_path = os.path.join(file_path, 'number_seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        seller_sku_info = seller_sku_info[0:100]
        data = []
        for seller_sku in seller_sku_info:
            content = {}
            content['sellerSkuNumber'] = seller_sku
            quantity = random.randint(10,1000)
            content['availableQuantity'] = quantity
            data.append(content)
        content = {}
        content['sellerSkuNumber'] = seller_sku_info[0]
        quantity = random.randint(10, 1000)
        content['availableQuantity'] = quantity
        data.append(content)
        return data

    @staticmethod
    def get_update_price():

        data_path = os.path.join(file_path, 'sku_list.json')
        sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for sku in sku_info['sku_num']:
            content = {}
            content['skuNumber'] = sku
            price =  random.uniform(0, 1000)
            price = round(price, 2)
            content['price'] = '980.0'
            data.append(content)
        return data

    @staticmethod
    def get_update_price_by_error_sku():

        data_path = os.path.join(file_path, 'sku_list.json')
        sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(sku_info['sku_num'])):
            if i == 0:
                sku = '000'
            else:
                sku = sku_info['sku_num'][i]
            content = {}
            content['skuNumber'] = sku
            price =  random.uniform(0, 1000)
            price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_update_price_by_master_sku():

        data_path = os.path.join(file_path, 'primary_sku_list.json')
        master_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(master_sku_info['primarySkuNumber'])):
            sku = master_sku_info['primarySkuNumber'][i]
            content = {}
            content['skuNumber'] = sku
            price =  random.uniform(0, 1000)
            price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_update_zero_price():

        data_path = os.path.join(file_path, 'sku_list.json')
        sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(sku_info['sku_num'])):
            sku = sku_info['sku_num'][i]
            content = {}
            content['skuNumber'] = sku
            if i == 0:
                price = 0
            else:
                price =  random.uniform(0, 1000)
                price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_update_error_price():

        data_path = os.path.join(file_path, 'sku_list.json')
        sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(sku_info['sku_num'])):
            sku = sku_info['sku_num'][i]
            content = {}
            content['skuNumber'] = sku
            if i == 0:
                price = 'abc'
            else:
                price =  random.uniform(0, 1000)
                price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_update_exceed_price():

        data_path = os.path.join(file_path, 'sku_list.json')
        sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(sku_info['sku_num'])):
            sku = sku_info['sku_num'][i]
            content = {}
            content['skuNumber'] = sku
            if i == 0:
                price = '99999999999999999999999999999999999999999999999999999999999999999'
            else:
                price =  random.uniform(0, 1000)
                price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_seller_sku_update_price():

        data_path = os.path.join(file_path, 'seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for seller_sku in seller_sku_info['sellerSkuNumbers']:
            content = {}
            content['sellerSkuNumber'] = seller_sku
            price =  random.uniform(0, 1000)
            price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_error_seller_sku_update_price():

        data_path = os.path.join(file_path, 'seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(seller_sku_info['sellerSkuNumbers'])):
            if i ==0:
                seller_sku = 'abc'
            else:
                seller_sku = seller_sku_info['sellerSkuNumbers'][i]
            content = {}
            content['sellerSkuNumber'] = seller_sku
            price =  random.uniform(0, 1000)
            price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_seller_sku_update_minus_price():

        data_path = os.path.join(file_path, 'seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(seller_sku_info['sellerSkuNumbers'])):
            seller_sku = seller_sku_info['sellerSkuNumbers'][i]
            content = {}
            content['sellerSkuNumber'] = seller_sku
            if i == 0:
                price = -1
            else:
                price =  random.uniform(0, 1000)
                price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_seller_sku_update_exceed_price():

        data_path = os.path.join(file_path, 'seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(seller_sku_info['sellerSkuNumbers'])):
            seller_sku = seller_sku_info['sellerSkuNumbers'][i]
            content = {}
            content['sellerSkuNumber'] = seller_sku
            if i == 0:
                price = 999999999999999999999999999999999999999999999
            else:
                price =  random.uniform(0, 1000)
                price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_seller_sku_update_invalid_price():

        data_path = os.path.join(file_path, 'seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for i in range(len(seller_sku_info['sellerSkuNumbers'])):
            seller_sku = seller_sku_info['sellerSkuNumbers'][i]
            content = {}
            content['sellerSkuNumber'] = seller_sku
            if i == 0:
                price = 'abcde'
            else:
                price =  random.uniform(0, 1000)
                price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_sellersku_hunderd_price():

        data_path = os.path.join(file_path, 'number_seller_sku.json')
        seller_sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for seller_sku in seller_sku_info:
            content = {}
            if not seller_sku:
                continue
            content['sellerSkuNumber'] = seller_sku
            price =  random.uniform(0, 1000)
            price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_sku_hunderd_price():

        data_path = os.path.join(file_path, 'sixty_sku_num.json')
        sku_info = json.load(open(data_path, 'r', encoding='utf8'))
        data = []
        for sku in sku_info:
            content = {}
            content['skuNumber'] = sku
            price =  random.uniform(0, 1000)
            price = round(price, 2)
            content['price'] = price
            data.append(content)
        return data

    @staticmethod
    def get_taxonomy_path():

        data_path = os.path.join(file_path, 'taxonomy_path.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_query_order_data():

        data_path = os.path.join(file_path, 'query_order.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_random_query_order_data():

        data_path = os.path.join(file_path, 'query_order.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        status_list = [
            'PENDING_CONFIRMATION',
            'READY_TO_SHIP',
            'PARTIAL_FULFILLED',
            'FULFILLED',
            'PARTIAL_DELIVERED',
            'DELIVERED',
            'CANCELLED',
            'COMPLETED',
            ''
        ]
        asc_list = [True, False, '']
        data['startTime'] = str(random.randint(1633681338000, 1633683338000))
        data['endTime'] = str(random.randint(1667975592000, 1667979592000))
        data['orderStatusList'] = random.choice(status_list)
        data['isAsc'] = random.choice(asc_list)
        data['pageNumber'] = '1'
        data['pageSize'] = str(random.randint(1,200))
        data['simpleMode'] = random.choice(asc_list)
        return data

    @staticmethod
    def modify_query_order_data(data,key,value):


        return data

    @staticmethod
    def get_order_num():

        data_path = os.path.join(file_path, 'order_num.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        order_num = data['orderNumber']
        if order_num:
            return order_num
        else:
            return ''

    @staticmethod
    def get_ready_order():

        data_path = os.path.join(file_path, 'ready_order.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_shipment_item():

        numberSet = '012345678910'
        data_path = os.path.join(file_path, 'shipment_item.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        # shipment_item_list = data['shipmentsList'][0]['shipmentItemList']
        carrier_list = ['UPS','USPS','FEDEX','DHL']
        # data['shipmentsList'] = []
        num = ''
        for i in range(12):
            num += random.choice(numberSet)
        carrier = random.choice(carrier_list)
        data['shipmentsList'][0]['carrier'] = carrier
        data['shipmentsList'][0]['trackingNumber'] = num
        # for item in shipment_item_list:
        #     content = {}
        #     # num = ''
        #     # for i in range(12):
        #     #     num += random.choice(numberSet)
        #     # carrier = random.choice(carrier_list)
        #     content['trackingNumber'] = num
        #     content['carrier'] = carrier
        #     content['carrierTrackingUrl'] = 'https://tools.usps.com/go/TrackConfirmAction_input'
        #     content['shipmentItemList'] = [item]
        #     data['shipmentsList'].append(content)
        return data

    @staticmethod
    def get_cancel_order():

        data_path = os.path.join(file_path, 'cancel_order.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_return_order_num():

        data_path = os.path.join(file_path, 'return_order.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        order_num = data['orderNumber']
        return order_num

    @staticmethod
    def get_return_by_order_num():

        data_path = os.path.join(file_path, 'return_by_order_num.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        order_num = data['orderNumber']
        return order_num

    @staticmethod
    def get_query_return():

        data_path = os.path.join(file_path, 'query_return.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data


    @staticmethod
    def get_approve_refund():

        data_path = os.path.join(file_path, 'approve_refund.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_reject_refund():

        data_path = os.path.join(file_path, 'reject_refund.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        return data

    @staticmethod
    def get_process_refund():

        data_path = os.path.join(file_path, 'process_refund.json')
        data = json.load(open(data_path, 'r', encoding='utf8'))
        # return_line = data['returnLines']
        # if len(return_line) > 1:
        #     data['returnLines'] = [return_line[0]]
        return data

    @staticmethod
    def record_order(data):

        order_num_content = {
            "orderNumber": "",
            "simpleMode": False
        }
        ready_content = {
            "orderNumbers": [
                ""
            ]
        }
        ship_content = {
            "orderNumber": "",
            "shipmentsList": [
                {
                    "trackingNumber": "123456780123",
                    "carrier": "UPS",
                    "carrierTrackingUrl": "https://tools.usps.com/go/TrackConfirmAction_input",
                    "shipmentItemList": []
                }
            ]
        }
        cancel_content = {
            "cancelReason": "Out of Stock",
            "orderNumber": "",
            "cancelOrderLines": []
        }
        if len(data['data']['pageData']) != 0:
            order_num = data['data']['pageData'][0]['orderNumber']
            order_item_id_list = jsonpath.jsonpath(data, '$..orderLines..orderItemId')
            order_item_mount_list = jsonpath.jsonpath(data, '$..orderLines..quantity')
        else:
            order_num = ''
            order_item_id_list = []
            order_item_mount_list = []
        ready_content['orderNumbers'][0] = order_num
        ship_content['orderNumber'] = order_num
        cancel_content['orderNumber'] = order_num
        order_num_content['orderNumber'] = order_num
        for i in range(len(order_item_id_list)):
            item_id = order_item_id_list[i]
            item_mount = int(order_item_mount_list[i])
            ship_item = {"quantity": item_mount, "orderItemId": item_id}
            cancel_item = {
                "orderItemId": item_id,
                "orderItemCancelReason": "Out of Stock",
            }
            ship_content['shipmentsList'][0]['shipmentItemList'].append(ship_item)
            cancel_content['cancelOrderLines'].append(cancel_item)
        json.dump(order_num_content, open(os.path.join(file_path, 'order_num.json'), 'w'), indent=4)
        json.dump(ready_content, open(os.path.join(file_path, 'ready_order.json'), 'w'), indent=4)
        json.dump(ship_content, open(os.path.join(file_path, 'shipment_item.json'), 'w'), indent=4)
        json.dump(cancel_content, open(os.path.join(file_path, 'cancel_order.json'), 'w'), indent=4)


    @staticmethod
    def record_return(data):

        return_num_content = {
            "orderNumber": ""
        }
        order_num_content = {
            "orderNumber": ""
        }
        approve_content = {
            "returnOrderNumber": "",
            "returnItemIds": [
            ]
        }
        reject_content = {
            "returnOrderNumber": "",
            "returnOrderLines": [
            ]
        }
        if data['data']['pageData']:
            order_num = data['data']['pageData'][0]['orderNumber']
            return_order_num = data['data']['pageData'][0]['returnOrderNumber']
            return_item_id_list = jsonpath.jsonpath(data, '$..pageData[0]..returnOrderLines..returnItemId')
        else:
            order_num = ''
            return_order_num = ''
            return_item_id_list = []
        return_num_content['orderNumber'] = return_order_num
        order_num_content['orderNumber'] = order_num
        approve_content['returnOrderNumber'] = return_order_num
        reject_content['returnOrderNumber'] = return_order_num
        for i in range(len(return_item_id_list)):
            item_id = return_item_id_list[i]
            approve_content['returnItemIds'].append(item_id)
            reject_item = {
                "returnItemId": item_id,
                "refundRejectReason": "reject",
                "refundRejectComment": "reject",
                "sellerRejectRefundMedia": [""]
            }
            reject_content['returnOrderLines'].append(reject_item)

        json.dump(return_num_content, open(os.path.join(file_path, 'return_order.json'), 'w'), indent=4)
        json.dump(order_num_content, open(os.path.join(file_path, 'return_by_order_num.json'), 'w'), indent=4)
        json.dump(approve_content, open(os.path.join(file_path, 'approve_refund.json'), 'w'), indent=4)
        json.dump(reject_content, open(os.path.join(file_path, 'reject_refund.json'), 'w'), indent=4)

    @staticmethod
    def record_new_return(data):

        return_num_content = {
            "orderNumber": ""
        }
        order_num_content = {
            "orderNumber": ""
        }
        approve_content = {
            "returnNumber": "",
            "returnItemIds": [
            ]
        }
        reject_content = {
            "returnNumber": "",
            "returnLines": [
            ]
        }
        process_content = {
            "returnNumber": "",
            "returnLines": []
        }
        if data['data']['pageData']:
            order_num = data['data']['pageData'][0]['orderNumber']
            return_order_num = data['data']['pageData'][0]['returnNumber']
            return_item_id_list = jsonpath.jsonpath(data, '$..pageData[0]..returnLines..returnItemId')
        else:
            order_num = ''
            return_order_num = ''
            return_item_id_list = []
        return_num_content['orderNumber'] = return_order_num
        order_num_content['orderNumber'] = order_num
        approve_content['returnNumber'] = return_order_num
        reject_content['returnNumber'] = return_order_num
        process_content['returnNumber'] = return_order_num
        action_list = ['APPROVE','REJECT']
        for i in range(len(return_item_id_list)):
            item_id = return_item_id_list[i]
            approve_content['returnItemIds'].append(item_id)
            reject_item = {
                "returnItemId": item_id,
                "refundRejectReason": "reject",
                "refundRejectComment": "reject",
                "sellerRejectRefundMedia": [""]
            }
            reject_content['returnLines'].append(reject_item)
            action = random.choice(action_list)
            if action == 'REJECT':
                process_item = {
                "action": action,
                "returnItemId": item_id,
                "refundRejectReason": "this is a reason",
                "refundRejectComment": "this is a comment",
                "sellerRejectRefundMedia": []
            }
            else:
                process_item = {
                    "action": action,
                    "returnItemId": item_id
                }
            process_content['returnLines'].append(process_item)

        json.dump(return_num_content, open(os.path.join(file_path, 'return_order.json'), 'w'), indent=4)
        json.dump(order_num_content, open(os.path.join(file_path, 'return_by_order_num.json'), 'w'), indent=4)
        json.dump(approve_content, open(os.path.join(file_path, 'approve_refund.json'), 'w'), indent=4)
        json.dump(reject_content, open(os.path.join(file_path, 'reject_refund.json'), 'w'), indent=4)
        json.dump(process_content, open(os.path.join(file_path, 'process_refund.json'), 'w'), indent=4)

    @staticmethod
    def record_listing(data):

        sku_content = {
            "sku_num": ""
        }
        sku_list_content = {
            "sku_num": []
        }
        active_listing_content = {
            "primarySkuNumbers": [
            ],
            "availableFrom": "2021-11-05",
            "availableTo": "2022-03-31"
        }
        deactive_listing_content = {
            "primarySkuNumbers": []
        }
        primary_sku_content = {
            "primarySkuNumber": ""
        }
        primary_sku_list_content = {
            "primarySkuNumber": []
        }
        primary_sku = data['data']['skuNumber']
        if 'subSkus' in data['data']:
            sku_list = []
            sku_info_list = data['data']['subSkus']
            if sku_info_list:
                for i in sku_info_list:
                    sku_list.append(i['skuNumber'])
            else:
                sku_list = [primary_sku]
        else:
            sku_list = [primary_sku]

        primary_sku_content['primarySkuNumber'] = primary_sku
        primary_sku_list_content['primarySkuNumber'].append(primary_sku)
        active_listing_content['primarySkuNumbers'].append(primary_sku)
        deactive_listing_content['primarySkuNumbers'].append(primary_sku)
        sku_list_content['sku_num'] = sku_list
        sku_content['sku_num'] = sku_list[0]

        json.dump(primary_sku_content, open(os.path.join(file_path, 'primary_sku.json'), 'w'), indent=4)
        json.dump(active_listing_content, open(os.path.join(file_path, 'activate_listing.json'), 'w'), indent=4)
        json.dump(deactive_listing_content, open(os.path.join(file_path, 'deactivate_listing.json'), 'w'), indent=4)
        json.dump(sku_content, open(os.path.join(file_path, 'sku.json'), 'w'), indent=4)
        json.dump(sku_list_content, open(os.path.join(file_path, 'sku_list.json'), 'w'), indent=4)
        json.dump(primary_sku_list_content, open(os.path.join(file_path, 'primary_sku_list.json'), 'w'), indent=4)

    @staticmethod
    def record_taxonomy(data):

        taxonomy_content = {
            "taxonomyPath": ""
        }
        taxonomy_list = data['data']
        taxonomy_dict = random.choice(taxonomy_list)
        taxonomy_content['taxonomyPath'] = taxonomy_dict['taxonomyPath']
        json.dump(taxonomy_content, open(os.path.join(file_path, 'taxonomy_path.json'), 'w'), indent=4)

    @staticmethod
    def record_sku_num(data):

        sku_num_list = []
        seller_sku_list = []
        listing_data = jsonpath.jsonpath(data, '$..listings..skuNumber')
        seller_sku_data = jsonpath.jsonpath(data, '$..listings..sellerSkuNumber')
        for i in listing_data:
            if len(sku_num_list) < 101:
                sku_num_list.append(i)
        for i in seller_sku_data:
            if len(sku_num_list) < 101:
                seller_sku_list.append(i)
        json.dump(sku_num_list, open(os.path.join(file_path, 'sixty_sku_num.json'), 'w'), indent=4)
        json.dump(seller_sku_data, open(os.path.join(file_path, 'number_seller_sku.json'), 'w'), indent=4)

    @staticmethod
    def get_result_data(res, data):
        result = jsonpath.jsonpath(res, f"$..{data}")
        return result


if __name__ == '__main__':
    t = tools()
    # t.asyn_post_template(
    #     base_url='https://mda.tst03.platform.michaels.com/api',
    #     upload_url='/developer/api/v1/listing/upload-excel-asyn',
    #     api_key='018f83b26b35e8536443e115c710d4e0049622620696244a4c03f734e69d4bef898ac5f9a5bbb1cb'
    # )
    # t.post_media(
    #     base_url='https://mda.aps.platform.michaels.com/api',
    #     upload_url='/developer/api/v1/listing/media',
    #     api_key='91d12621f060e2c6cd977b5ad25ff0bead7c67e5e884b86a61d663013fa1a25d3c9baf654966a641'
    # )
    # t.get_bantch_master_sku_inventory()

    t.get_shipment_item()