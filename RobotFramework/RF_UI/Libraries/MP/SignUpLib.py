import random
import uuid
import os


class SignUpLib(object):
    def __init__(self):
        self.root_path = self.__get_root_path()

    @staticmethod
    def __get_root_path():
        abspath = os.path.dirname(os.path.abspath(__file__))
        root_path = os.path.dirname(os.path.dirname(abspath))
        return root_path

    @staticmethod
    def get_random_data():
        return str(uuid.uuid1()).split("-")[0]

    def get_img_dir_path(self,quantity=1):
        img_dir_path = os.path.join(self.root_path, "CaseData", "MP", "Img", str(quantity))
        return img_dir_path

    def get_random_img_path(self, quantity=1):
        img_dir_path = os.path.join(self.root_path, "CaseData", "MP", "Img")
        img_list = os.listdir(img_dir_path)
        img_paths = []
        if int(quantity) == 1:
            img_path = os.path.join(img_dir_path, random.choice(img_list))
            return img_path
        else:
            images = random.sample(img_list, int(quantity))
            for item in images:
                img_paths.append(os.path.join(img_dir_path, item))
            return img_paths
        #
        # print(img_path)
        # return img_path

    @staticmethod
    def get_add_element_js():
        js = """
        var para=document.createElement("span");
var node=document.createTextNode("end");
para.appendChild(node);
var element=document.querySelector("#docx div");
element.appendChild(para);
        """
        return js

if __name__ == '__main__':
    lib = SignUpLib()
    print(lib.get_random_img_path())
    print(lib.get_random_data())
