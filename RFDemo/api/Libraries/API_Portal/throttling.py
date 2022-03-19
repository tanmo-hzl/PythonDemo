import json
import os
import random
import threading
import time

import jsonpath
import requests
from listing_data import get_listing_data
from requests_toolbelt import MultipartEncoder

base_url = 'https://mda.tst03.platform.michaels.com/api'
api_key = '018f83b26b35e8536443e115c710d4e0049622620696244a4c03f734e69d4bef898ac5f9a5bbb1cb'
file_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
file_path = os.path.join(file_path, 'CaseData')
file_path = os.path.join(file_path, 'API_Portal')

# class MyThread(threading.Thread):
#     def __init__(self, func, args, name=''):
#         threading.Thread.__init__(self)
#         self.name = name
#         self.func = func
#         self.args = args
#         self.result = self.func(*self.args)
#
#     def get_result(self):
#         try:
#             return self.result
#         except Exception:
#             return None


def send_get_method(url, headers, para=''):
    response = requests.get(url, headers=headers, params=para, timeout=600.0)
    print(response.status_code)
    print(response.text)
    return response.status_code


def send_post_method(url, headers, data='', para=''):
    response = requests.post(url, headers=headers, json=data, params=para, timeout=600.0)
    print(response.status_code)
    print(response.text)
    return response.status_code


def send_put_method(url, headers, data=''):
    response = requests.put(url, headers=headers, json=data, timeout=600.0)
    print(response.status_code)
    print(response.text)
    return response.status_code

def send_media(url,apikey):

    img_path = os.path.join(file_path, 'test-photo')
    img_list = os.listdir(img_path)
    img = os.path.join(img_path, random.choice(img_list))
    # img = os.path.join(img_path, 'svitlana-_ETKZwUXMJg-unsplash.jpg')
    # print(img)
    file = {
        'uploadFile': ('api-test.jpeg', open(img, 'rb'), 'image/jpg'),
    }
    multipart_encoder = MultipartEncoder(fields=file)
    headers = {
        'Api-Key': apikey,
        'Content-Type': multipart_encoder.content_type,
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
    }
    response = requests.post(url, headers=headers, data=multipart_encoder,timeout=600.0)
    print(response.status_code)
    print(response.text)
    return response.status_code

def send_template(url,apikey):

    data_path = os.path.join(file_path, 'import-create-active.xlsx')
    headers = {
        'Api-Key': apikey,
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
    }
    files = {"uploadFile": open(data_path, 'rb')}
    response = requests.post(url, headers=headers, files=files,verify=False)
    print(response.text)
    res = json.loads(response.text)
    status = jsonpath.jsonpath(res, '$..code')[0]
    if str(status) != '200':
        status = '400'
    msg = jsonpath.jsonpath(res, '$..message')[0]
    return [status, msg]

class throttling():

    def __init__(self):
        pass

    @staticmethod
    def get_exceed_request(base_url, path_url, api_key, limit, data=''):
        url = base_url + path_url
        headers = {
            'Api-Key': api_key
        }
        thread_list = []
        for i in range(int(limit)):
            # thread = MyThread(func=post_get_method,args=(url,headers))
            thread = threading.Thread(target=send_get_method, args=(url, headers, data))
            # print(id(thread))
            thread.setDaemon(True)
            thread_list.append(thread)
        for thread in thread_list:
            thread.start()
        for thread in thread_list:
            thread.join()
        status = send_get_method(url=url, headers=headers, para=data)
        return status

    @staticmethod
    def post_exceed_request(base_url, path_url, api_key, limit, data='', para=''):
        url = base_url + path_url
        headers = {
            'Api-Key': api_key
        }
        thread_list = []
        for i in range(int(limit)):
            # thread = MyThread(func=post_get_method,args=(url,headers))
            thread = threading.Thread(target=send_post_method, args=(url, headers, data, para))
            # print(id(thread))
            thread.setDaemon(True)
            thread_list.append(thread)
        for thread in thread_list:
            thread.start()
        for thread in thread_list:
            thread.join()
        status = send_post_method(url=url, headers=headers, data=data)
        return status

    @staticmethod
    def put_exceed_request(base_url, path_url, api_key, limit, data=''):
        url = base_url + path_url
        headers = {
            'Api-Key': api_key
        }
        thread_list = []
        for i in range(int(limit)):
            # thread = MyThread(func=post_get_method,args=(url,headers))
            thread = threading.Thread(target=send_put_method, args=(url, headers, data))
            thread.setDaemon(True)
            thread_list.append(thread)
        for thread in thread_list:
            thread.start()
        for thread in thread_list:
            thread.join()
        status = send_put_method(url=url, headers=headers, data=data)
        return status

    @staticmethod
    def get_exceed_create_listing(base_url, path_url, api_key, limit, data=''):
        url = base_url + path_url
        headers = {
            'Api-Key': api_key
        }
        thread_list = []
        for i in range(int(limit)):
            # thread = MyThread(func=post_get_method,args=(url,headers))
            data = get_listing_data(is_variant=0)
            thread = threading.Thread(target=send_post_method, args=(url, headers, data))
            # print(id(thread))
            thread.setDaemon(True)
            thread_list.append(thread)
        for thread in thread_list:
            thread.start()
        for thread in thread_list:
            thread.join()
        data = get_listing_data(is_variant=0)
        status = send_post_method(url=url, headers=headers, data=data)
        return status

    @staticmethod
    def post_exceed_media(base_url, path_url, api_key, limit, data=''):

        url = base_url + path_url
        thread_list = []
        for i in range(int(limit)):
            # thread = MyThread(func=post_get_method,args=(url,headers))
            thread = threading.Thread(target=send_media, args=(url, api_key))
            thread.setDaemon(True)
            thread_list.append(thread)
        for thread in thread_list:
            thread.start()
        for thread in thread_list:
            thread.join()
        status = send_media(url=url, apikey=api_key)
        return status

    @staticmethod
    def post_exceed_template(base_url, path_url, api_key, limit, data=''):

        url = base_url + path_url
        thread_list = []
        for i in range(int(limit)):
            thread = threading.Thread(target=send_template, args=(url, api_key))
            thread.setDaemon(True)
            thread_list.append(thread)
        for thread in thread_list:
            thread.start()
        for thread in thread_list:
            thread.join()
        status = send_media(url=url, apikey=api_key)
        return status

if __name__ == '__main__':
    time1 = time.time()
    base_url = 'https://mik.aps.platform.michaels.com/api/mda'
    api_key = '91d12621f060e2c6cd977b5ad25ff0bead7c67e5e884b86a61d663013fa1a25d3c9baf654966a641'
    url = '/developer/api/v1/listing/upload-excel/'
    para = {
        "taxonomyPath": "root//Shop Categories//Office Supplies//Paper//Notepads"
    }
    headers = {
        'Api-Key': api_key
    }
    a = throttling
    result = a.post_exceed_template(base_url, url, api_key, 10)
    # result = send_get_method(base_url+get_taxonomy_attributes,headers,para)
    print(result)
    print(time.time() - time1)
