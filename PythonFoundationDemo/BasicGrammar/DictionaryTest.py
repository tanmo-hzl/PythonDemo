#!usr/bin/ python3
# -*- coding:utf-8 -*-

import pprint



"""
@Description: 
@Author: 
@Time: 2021/12/12 10:57
@Website: 
@project: PythonDemo
@FileName: DictionaryTest.py

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
        print("字典推导式",{x: x ** 2 for x in (2, 4, 6)})   # {2: 4, 4: 16, 6: 36}

        print(dict(sape=4139, guido=4127, jack=4098))   # {'sape': 4139, 'guido': 4127, 'jack': 4098}



    def test_setdefault(self):
        # setdefault(key,default) 方法第一个参数是要检查的键，第二个参数是该键在字典中不存在时要设置的值（此时该方法的返回值为设置的default的值）。
        # 如果该键在字典中存在，则该方法将返回该键在字典中对应的值。
        spam = {'name': 'Pooka', 'age': 5}
        cheese = spam.setdefault('color', 'black')
        print(cheese)       # result: black
        print(spam)         # result: {'name': 'Pooka', 'age': 5, 'color': 'black'}
        temp = spam.setdefault('color', 'white')
        print(temp)         # result: black
        print(spam)         # result: {'name': 'Pooka', 'age': 5, 'color': 'black'}
        st = spam.setdefault("addr")
        print(st)           # result: None
        print(spam)         # result: {'name': 'Pooka', 'age': 5, 'color': 'black', 'addr': None}



    def test_count_str_number(self):
        message = 'It was a bright cold day in April, and the clocks were striking thirteen.'
        count={}
        for character in message:
            # 使用setdefault()方法，确保message中的每个字母都保存到count字典中。
            count.setdefault(character,0)
            # 因为character 存在于message中，所以该character的个数要加1
            count[character] += 1

        print(count)        # result: {'I': 1, 't': 6, ' ': 13, 'w': 2, 'a': 4, 's': 3, 'b': 1, 'r': 5, 'i': 6, 'g': 2, 'h': 3, 'c': 3, 'o': 2, 'l': 3, 'd': 3, 'y': 1, 'n': 4, 'A': 1, 'p': 1, ',': 1, 'e': 5, 'k': 2, '.': 1}
        # 实现漂亮打印：键排过序
        pprint.pprint(count)
        ''' result:
        {' ': 13,
          ',': 1,
          '.': 1,
          'A': 1,
          'I': 1,
          'a': 4,
          'b': 1,
          'c': 3,
          'd': 3,
          'e': 5,
          'g': 2,
          'h': 3,
          'i': 6,
          'k': 2,
          'l': 3,
          'n': 4,
          'o': 2,
          'p': 1,
          'r': 5,
          's': 3,
          't': 6,
          'w': 2,
          'y': 1}
        '''

if __name__ == '__main__':
    dict_test = DictionaryTest()
    # dict_test.test_case_a()
    # dict_test.test_setdefault()
    dict_test.test_count_str_number()