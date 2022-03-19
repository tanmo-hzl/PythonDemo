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

    response = requests.get(url=base_url + get_all_taxonomy, headers=headers)
    res = json.loads(response.text)
    taxonomyPath_list = jsonpath.jsonpath(res, '$..taxonomyPath')


    # taxonomyPath = 'root//Shop Categories//Holiday & Seasonal Decor//Spring//Spring Baskets & Containers//Storage'
    # print(taxonomyPath)
    result_list = []
    count = 0
    for taxonomyPath in taxonomyPath_list:
        try:
            para = {
                'taxonomyPath': taxonomyPath  # 分类路径
            }
            response = requests.get(url=base_url + get_taxonomy_attributes, headers=headers, params=para)
            print(response.text)
            res = json.loads(response.text)
            attr_name_list = jsonpath.jsonpath(res, '$..attributes..displayName')
            attr_value_list = jsonpath.jsonpath(res, '$..attributes..availableValues')
            if not attr_name_list:
                attr_name_list = []
                attr_value_list = []
            attr_dict = {}
            if attr_name_list:
                for i in range(len(attr_name_list)):
                    attr_name = attr_name_list[i]
                    attr_value = attr_value_list[i]
                    attr_dict[attr_name] = attr_value

            variant_name_list = jsonpath.jsonpath(res, '$..variants..variantName')
            variant_value_list = jsonpath.jsonpath(res, '$..variants..availableValues')
            variant_dict = {}
            if variant_name_list:
                for i in range(len(variant_name_list)):
                    variant_name = variant_name_list[i]
                    variant_value = variant_value_list[i]
                    variant_dict[variant_name] = variant_value
                # return attr_dict, variant_dict

            url = 'https://mik.aps.platform.michaels.com/api/store/taxonomy-variants/getAttributeVariants'
            body = {
                'channel': '2',
                'taxonomyPath': taxonomyPath
            }
            headers1 = {
                'authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6InVzciIsIl91c2VySWQiOiI0NTA4MDEwMjg2NzkwOSIsIl9zZWxsZXJTdG9yZUlkIjoiNTkwMzQ1NjQyODM3NTA0ODE5MiIsIl9kZXZpY2VVdWlkIjoiZDUyMGM3YTgtNDIxYi00NTYzLWI5NTUtZjVhYmM1NmI5N2VjIiwiX2RldmljZU5hbWUiOiJDaHJvbWUiLCJfY3JlYXRlVGltZSI6IjE2NDQ0ODE4MDgyMjUiLCJfZXhwaXJlVGltZSI6IjE2NDcwNzM4MDgyMjUiLCJzdWIiOiI0NTA4MDEwMjg2NzkwOSIsImlhdCI6MTY0NDQ4MTgwOCwiZXhwIjoxNjQ3MDczODA4LCJhdWQiOiJ1c2VyIiwianRpIjoiMGRuclBrY3U0WTZhc0djSk1mY1B6NWhob3ZDbFJrVm0ifQ.--hRYuhmzUT6oFFPPjaATKx1V34z-Fg8u6UAjw8hJMBheBZKSwmpbWWvpFuQWVtSnMTvg2Q1jCw-xvDrI-kZMQ'
            }
            response = requests.post(url=url, headers=headers1, json=body)
            print(response.text)
            res = json.loads(response.text)
            seller_attr_name_list = jsonpath.jsonpath(res, '$..attributes..displayName')
            seller_attr_value_list = jsonpath.jsonpath(res, '$..attributes..availableValues')
            if not seller_attr_name_list:
                seller_attr_name_list = []
                seller_attr_value_list = []
            seller_variants_name_list = jsonpath.jsonpath(res, '$..variants..displayName')
            seller_variants_value_list = jsonpath.jsonpath(res, '$..variants..availableValues')
            if not seller_variants_name_list:
                seller_variants_name_list = []
                seller_variants_value_list = []
            seller_attr_dict = {}
            seller_variants_dict = {}
            for i in range(len(seller_attr_name_list)):
                seller_attr_dict[seller_attr_name_list[i]] = seller_attr_value_list[i]
            for i in range(len(seller_variants_name_list)):
                seller_variants_dict[seller_variants_name_list[i]] = seller_variants_value_list[i]

            # print(sorted(attr_name_list))
            # print(sorted(seller_attr_name_list))
            if sorted(attr_name_list) != sorted(seller_attr_name_list):
                result_list.append(taxonomyPath)
            else:
                for attr_name in attr_name_list:
                    if sorted(attr_dict[attr_name]) != sorted(seller_attr_dict[attr_name]):
                        result_list.append(taxonomyPath)
            # print(sorted(variant_name_list))
            # print(sorted(seller_variants_name_list))
            if sorted(variant_name_list) != sorted(seller_variants_name_list):
                if len(variant_name_list) != 4:
                    # pass
                    result_list.append(taxonomyPath)
            else:
                for variant_name in variant_name_list:
                    if sorted(variant_dict[variant_name]) != sorted(seller_variants_dict[variant_name]):
                        if variant_name != 'Kit':
                            result_list.append(taxonomyPath)
        except Exception as e:
            print(traceback.format_exc())
            result_list.append(taxonomyPath)
        count += 1
        print(f'已检查{count}条数据，当前目录为{taxonomyPath}')
        print(list(set(result_list)))
    print(list(set(result_list)))


if __name__ == '__main__':
    get_taxonomyPath()
