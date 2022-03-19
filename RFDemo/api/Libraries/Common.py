import base64
import configparser
import json
import os
import re

import jsonpath
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from requests_toolbelt.multipart.encoder import MultipartEncoder

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)


class Common(object):
    def __init__(self):
        self.save_file_path = os.path.join(self.get_parent_path(), "CaseData")

    def get_config_ini(self, env_name, config_ini_name="config.ini"):
        config_path = os.path.join(self.get_parent_path(), config_ini_name)
        conf = configparser.ConfigParser()
        conf.read(config_path, encoding="utf-8")
        options = conf.options(env_name)
        config_info = {}
        for item in options:
            config_info[item] = conf.get(env_name, item)
        return config_info

    def get_upload_file_path(self, file_name, project_dir_name=None):
        if project_dir_name is None:
            path = os.path.join(self.save_file_path, file_name)
        else:
            path = os.path.join(self.save_file_path, project_dir_name, file_name)
        return path

    @staticmethod
    def get_current_path():
        """
        获取当前文件的绝对路径
        :return:
        """
        current_path = os.path.dirname(os.path.abspath(__file__))
        return current_path

    @staticmethod
    def get_parent_path():
        """
        获取当前文件所在绝对路劲的上一层路径
        :return:
        """
        parent_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        return parent_path

    @staticmethod
    def lib_post_request(url, data=None, json=None, **kwargs):
        return requests.post(url, data=data, json=json, **kwargs)

    @staticmethod
    def lib_get_request(url, params=None, **kwargs):
        return requests.get(url, params=params, **kwargs)

    def upload_img_to_cms_request(self, url, path, file_name, user_info):
        contentRequest = {
            "clientId": user_info.get("source_type"),
            "sourceId": user_info.get("source_type"),
            "clientName": user_info.get("source_type"),
            "sourceType": user_info.get("source_type"),
            "userId": user_info.get("user_id"),
            "byPassScreening": True,
        }
        file_path = self.get_upload_file_path(file_name)
        img_file = open(file_path, "rb")
        multipart_encoder = MultipartEncoder(
            fields={
                "files": (file_name, img_file, "image/jpeg"),
                "contentRequest": (
                    "blob",
                    json.dumps(contentRequest).encode(),
                    "application/json",
                ),
            }
        )
        headers = {
            "Content-Type": multipart_encoder.content_type,
            "Authorization": user_info.get("token"),
        }

        file = {"files": multipart_encoder}
        response = requests.post(url + path, headers=headers, files=file, verify=False)
        print(response.request.url)
        print(response.request.headers)
        return response

    def upload_files_to_gcs(self, url, path, source_type="rsc"):
        content_request = {
            "clientId": source_type,
            "sourceId": source_type,
            "clientName": source_type,
            "sourceType": "IMAGE",
            "byPassScreening": True,
        }
        img_path = os.path.join(self.save_file_path)
        file_name = "up_logo.jpeg"
        file_path = os.path.join(img_path, file_name)
        img_file = open(file_path, "rb")
        multipart_encoder = MultipartEncoder(
            fields={
                "files": (file_name, img_file, "image/jpeg"),
                "contentRequest": (
                    "blob",
                    json.dumps(content_request).encode(),
                    "application/json",
                ),
            }
        )
        headers = {
            "Content-Type": multipart_encoder.content_type,
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0",
        }
        response = requests.post(url + path, headers=headers, data=multipart_encoder)
        return response.json()

    def upload_b2b_file_request(self, url, path, file_name):
        contentRequest = {"clientId": "b2b", "sourceId": "b2b"}
        files = []
        file_path = self.get_upload_file_path(file_name)
        with open(file_path, "rb") as f:
            open_file = f.read()
            file = base64.b64encode(open_file).decode("ascii")
            files.append(file)
        file = {"files": files, "contentRequest": contentRequest}
        # print(file)
        response = requests.post(url + path, json=file, verify=False)
        print(response.request.url)
        print(response.request.headers)
        print(response.request.body)
        return response

    @staticmethod
    def get_cookie(response):
        """
        获取response的cookies
        :param response:
        :return:
        """
        return requests.utils.dict_from_cookiejar(response.cookies)

    @staticmethod
    def get_json_value(data, *args):
        """
        根据传入的key值，返回
        :param data:
        :param args:
        :return:
        """
        try:
            for arg in args:
                if type(data) is list:
                    num = re.findall(re.compile(r"\d"), arg)
                    if not num:
                        _num = 0
                    else:
                        _num = int(num[0])
                    data = data[_num]
                    ag = re.sub(r"\W|\d", "", arg)
                    data = data[ag]
                else:
                    data = data[arg]
            return data
        except Exception as e:
            print(e)
            return None

    @staticmethod
    def create_dir_not_existed(dir_path):
        if not os.path.exists(dir_path):
            os.mkdir(dir_path)

    def save_file(self, file_name, data, project_name=None):
        if project_name is None:
            file_dir_path = self.save_file_path
        else:
            file_dir_path = os.path.join(self.save_file_path, project_name)
            self.create_dir_not_existed(file_dir_path)
        new_data = None
        try:
            if type(data) is list:
                new_data = {"data": data}
            else:
                if not type(data) is dict:
                    new_data = json.loads(data)
                else:
                    new_data = data
        except Exception as e:
            print(e)
            new_data = data
        finally:
            print("data type = ", type(new_data))
            if isinstance(new_data, dict):
                file_path = os.path.join(file_dir_path, file_name + ".json")
                with open(file_path, "w+") as f:
                    json.dump(new_data, f, indent=4)
            else:
                file_path = os.path.join(file_dir_path, file_name + ".txt")
                with open(file_path, "w+") as f:
                    f.write(str(new_data))
        print(file_path)

    def read_file(self, file_name, project_dir_name=None):
        """
        :param file_name:
        :param project_dir_name:
        :return:
        """
        file_type = 1
        if project_dir_name is not None:
            file_path = os.path.join(
                self.save_file_path, project_dir_name, file_name + ".txt"
            )
        else:
            file_path = os.path.join(self.save_file_path, file_name + ".txt")

        if not os.path.exists(file_path):
            file_type = 2
            if project_dir_name is not None:
                file_path = os.path.join(
                    self.save_file_path, project_dir_name, file_name + ".json"
                )
            else:
                file_path = os.path.join(self.save_file_path, file_name + ".json")
        if not os.path.exists(file_path):
            return None
        print(file_path)
        with open(file_path, "r") as f:
            if file_type == 1:
                data = f.read()
            else:
                data = json.load(f)
            return data

    @staticmethod
    def get_result_data(res, data):
        result = jsonpath.jsonpath(res, f"$..{data}")
        return result


if __name__ == "__main__":
    c = Common()
    print(c.get_config_ini("qa"))
    # img_path = os.path.join(c.save_file_path)
    # print(img_path)
    # import json
    # text = {"a":"22", "b":"33"}
    # print(json.dumps(text))

    # print(isinstance(text, dict))
    # print()
    # j = json.loads(text)
    # print(text)
    # print(j)