#!usr/bin/ python3
# -*- coding:utf-8 -*-

"""
@Description: 
@Author: 
@Time: 2021/12/12 10:56
@Website: 
@project: PythonDemo
@FileName: SetTest.py

"""


class SetTest(object):

    def test_case_a(self):
        # set集合的创建
        a_set = set()  # 创建空集合
        print('type(a_set)=======', type(a_set))  # <class 'set'>
        b_set = set("abcdefgabc")  # {'a', 'e', 'c', 'b', 'g', 'd', 'f'}
        print('b_set=======', b_set)
        # c_set = set('abc','bdc')     这样书写会报错

        # 重复的元素会被移除
        basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
        print('basket=========', basket)  # {'orange', 'pear', 'apple', 'banana'}
        print("'apple' in basket=====", ('apple' in basket))  # True

        '''
            set集合对象的’联合‘、’交集‘、’差集‘、’对称差分‘等数学运算
        '''
        a = set('abcdefghij')
        b = set('ijklmnop')

        # a-b为a与b的差集，差集的结果为元素在a中存在但不在b中存在的元素：letters in a but not in b
        print('a - b ========', (a - b))  # {'a', 'h', 'b', 'c', 'e', 'f', 'g', 'd'}
        print('a=========', a)  # {'a', 'h', 'i', 'b', 'c', 'e', 'f', 'g', 'j', 'd'}
        print('b=========', b)  # {'n', 'k', 'i', 'm', 'p', 'j', 'o', 'l'}

        # a | b 表示a与b的并集（联合），元素在a中存在或在b中存在或在a与b中都存在的元素：letters in a or b or both
        print('a | b==========',
              a | b)  # {'d', 'f', 'j', 'p', 'k', 'i', 'm', 'a', 'l', 'g', 'e', 'b', 'n', 'c', 'o', 'h'}

        # a & b 表示a与b的交集。元素既在a中存在也在b中存在：letters in both a and b
        print('a & b======', a & b)      # {'i', 'j'}

        # a ^ b 表示a与b的差分。只在a中有或者只在b中有的元素：letters in a or b but not both


if __name__ == '__main__':
    set_test = SetTest()
    set_test.test_case_a()
