import requests
import jsonpath
import json
import random
import os

base_url = 'https://mda.tst02.platform.michaels.com/api'
api_key = 'e5e3cbb27c3bef36e73a05d1c2f8b717f53b8933f0e3e3fe93cafa2567a34c54cdbd4eee144987d4'
get_all_taxonomy = '/developer/api/v1/listing/taxonomy'
get_taxonomy_attributes = '/developer/api/v1/listing/taxonomy/get-taxonomy-attributes'

def get_taxonomyPath():

    headers = {
        'Api-Key':api_key
    }

    response = requests.get(url=base_url+get_all_taxonomy, headers=headers)
    # print(response.text)
    res = json.loads(response.text)
    taxonomyPath_list = jsonpath.jsonpath(res, '$..taxonomyPath')


    taxonomyPath = random.choice(taxonomyPath_list)

    para = {
        'taxonomyPath': taxonomyPath    # 分类路径
    }
    response = requests.get(url=base_url+get_taxonomy_attributes, headers=headers, params=para)
    res = json.loads(response.text)
    data_list = jsonpath.jsonpath(res, '$..data')[0]
    result_dict = {}
    if data_list:
        for item in data_list:
            filed_name = item['apiFieldName']
            filed_name = filed_name[filed_name.index('.')+1:]
            choose_list = item['availableValues']
            result_dict[filed_name] = choose_list

    return taxonomyPath, result_dict




if __name__ == '__main__':

    a, b = get_taxonomyPath()
    print(a)
    print(b)


