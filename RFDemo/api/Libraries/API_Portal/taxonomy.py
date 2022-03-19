import configparser
import json
import os
import random

import jsonpath
import requests

file_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
config_path = os.path.join(file_path, 'config.ini')

config = configparser.ConfigParser()
config.read(config_path)
base_url = config.get('API_Portal', 'url')
api_key = config.get('API_Portal', 'api_key')
get_all_taxonomy = config.get('API_Portal', 'get_all_taxonomy')
get_taxonomy_attributes = config.get('API_Portal', 'get_taxonomy_attributes')

def get_taxonomyPath():

    headers = {
        'Api-Key': api_key
    }

    response = requests.get(url=base_url+get_all_taxonomy, headers=headers)
    # print(response.text)
    res = json.loads(response.text)
    taxonomyPath_list = jsonpath.jsonpath(res, '$..taxonomyPath')


    taxonomyPath = random.choice(taxonomyPath_list)
    # taxonomyPath = 'root//Shop Categories//Crafts & Hobbies//Apparel Crafts//T-shirts//BELLA+CANVAS//Baby & Toddler'
    # for taxonomyPath in taxonomyPath_list:
    para = {
        'taxonomyPath': taxonomyPath    # 分类路径
    }
    response = requests.get(url=base_url+get_taxonomy_attributes, headers=headers, params=para)
    if 'enum' in response.text:
        print(response.text)
    # print(response.request.url)
    print(response.text)
    res = json.loads(response.text)
    data_list = jsonpath.jsonpath(res, '$..data')[0]
    result_dict = {}
    if data_list:
        try:
            for item in data_list:
                filed_name = item['apiFieldName']
                filed_name = filed_name[filed_name.index('.')+1:]
                choose_list = item['availableValues']
                result_dict[filed_name] = choose_list
        except Exception:
            attr_list = data_list['attributes']
            for item in attr_list:
                filed_name = item['apiFieldName']
                filed_name = filed_name[filed_name.index('.')+1:]
                choose_list = item['availableValues']
                result_dict[filed_name] = choose_list
    return taxonomyPath, result_dict


def get_taxonomy_variants(taxonomy_name):

    para = {
        'taxonomyPath': taxonomy_name    # 分类路径
    }
    headers = {
        'Api-Key':api_key
    }
    response = requests.get(url=base_url+get_taxonomy_attributes, headers=headers, params=para)
    # print(response.text)
    res = json.loads(response.text)
    data_list = jsonpath.jsonpath(res, '$..data')[0]
    variants_result = {}
    try:
        if data_list:
            variants_list = data_list['variants']
            for variants_item in variants_list:
                variants_name = variants_item['variantName']
                variants_value_list = variants_item['availableValues']
                variants_result[variants_name] = variants_value_list
    except Exception:
        pass
    return variants_result


def mubbug():

    headers = {
        'Api-Key':api_key
    }

    response = requests.get(url=base_url+get_all_taxonomy, headers=headers)
    # print(response.text)
    res = json.loads(response.text)
    taxonomyPath_list = jsonpath.jsonpath(res, '$..taxonomyPath')
    # print(len(taxonomyPath_list))

    for name in taxonomyPath_list:
        if '+' in name:
            para = {
                'taxonomyPath': name  # 分类路径
            }
            response = requests.get(url=base_url + get_taxonomy_attributes, headers=headers, params=para)
            if response.status_code != 200:
                raise Exception
            else:
                res = json.loads(response.text)
                print(res)

if __name__ == '__main__':

    a, b= get_taxonomyPath()
    # print(a)
    # print(b)
    #
    # c = get_taxonomy_variants(a)
    # print(json.dumps(c))
    # mubbug()

