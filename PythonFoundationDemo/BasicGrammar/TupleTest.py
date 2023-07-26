#!usr/bin/ python3
# -*- coding:utf-8 -*-

"""
@Description: 
@Author: 
@Time: 2021/12/12 10:56
@Website: 
@project: PythonDemo
@FileName: TupleTest.py

"""


class TupleTest(object):
    def test_case_a(self):
        # 元组的定义，空元组，一个元素的元组，多个元素的元组
        a_tuple = ()
        b_tuple = (1,)
        c_tuple = (1, 2, 3)
        print(type(a_tuple), type(b_tuple), type(c_tuple))  # <class 'tuple'> <class 'tuple'> <class 'tuple'>

        # 元组的解构赋值
        d_tuple = ('a', 'b', 'c')
        a_str, b_str, c_str = d_tuple
        print(a_str, b_str, c_str)  # a b c


if __name__ == '__main__':
    tuple = TupleTest()
    tuple.test_case_a()
