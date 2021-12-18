#!usr/bin/ python3
# -*- coding:utf-8 -*-

"""
@Description: 
@Author: hzlvxln
@Time: 2021/12/12 10:57
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: DictionaryTest.py
@Copyright: ©2019-2021 家灏信息科技有限公司
"""

class DictionaryTest(object):
    def test_case_a(self):
        dict_a = {'jack': 4098, 'sape': 4139}
        dict_a['guido'] = 4127
        print(dict_a)  # {'jack': 4098, 'sape': 4139, 'guido': 4127}
        print(dict_a['jack'])  # 4098
        print("list(dict_a)==========",list(dict_a))    # ['jack', 'sape', 'guido']

        print('jack' in dict_a)    # True
        print('jack' not in dict_a)    # False

        # 通过dict()构造函数从键值对序列中创建字典
        dict_b = dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
        print('dict_b========',dict_b) #{'sape': 4139, 'guido': 4127, 'jack': 4098}


        # 通过字典推导式来构建字典
        print("字典推导式",{x: x ** 2 for x in (2, 4, 6)})

        print(dict(sape=4139, guido=4127, jack=4098))   # {'sape': 4139, 'guido': 4127, 'jack': 4098}



    pass

if __name__ == '__main__':
    dict_test = DictionaryTest()
    dict_test.test_case_a()
    pass