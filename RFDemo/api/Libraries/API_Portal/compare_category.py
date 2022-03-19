import configparser
import json
import os
import traceback

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
    # print(len(taxonomyPath_list))


    # taxonomyPath = random.choice(taxonomyPath_list)
    # print(taxonomyPath)
    count = 0
    result_list = []
    for taxonomyPath in taxonomyPath_list:
        try:
            url = 'https://mik.tst03.platform.michaels.com/api/sch/search/michaels/category?keywords=' + taxonomyPath
            response = requests.get(url)
            res = json.loads(response.text)
            category_name_list = jsonpath.jsonpath(res,'$..items..categoryPath')
            for category_name in category_name_list:
                if taxonomyPath == category_name:
                    break
            else:
                result_list.append(taxonomyPath)
        except Exception as e:
            print(traceback.format_exc())
            result_list.append(taxonomyPath)
        count+=1
        print(f'已检查{count}条目录,目录为{taxonomyPath}')
        print(result_list)
    for i in result_list:
        print(i)



if __name__ == '__main__':
    get_taxonomyPath()

