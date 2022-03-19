import os
import random


class MikFileLib(object):
    def __init__(self):
        pass

    @staticmethod
    def __get_root_path():
        abspath = os.path.dirname(os.path.abspath(__file__))
        root_path = os.path.dirname(os.path.dirname(abspath))
        return root_path

    def get_mik_img_path(self):
        img_dir_path = os.path.join(self.__get_root_path(), "CaseData", "MIK", "IMG")
        img_list = os.listdir(img_dir_path)
        img_path = os.path.join(img_dir_path, random.choice(img_list))
        return img_path

