#!usr/bin/ python3
# -*- coding:utf-8 -*-

"""
@Description: 
@Author: hzlvxln
@Time: 2021/12/12 10:55
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: ListTest.py
@Copyright: ©2019-2021 家灏信息科技有限公司
"""

'''
1、list.append(x): 在列表的末尾添加一个元素，相当于a[len[a]] = [x]
2、list.extend(X): 使用迭代器对象中的所有元素来扩展列表，相当于a[len(a):]=iterable
3、list.insert(i,x): 在给定的位置插入一个元素。第一个参数是要插入的元素的索引，所以a.insert(0,x)插入列表头部，
    a.insert(len(a),x)等同于a.append(X)
4、list.remove(x): 移除列表中第一个值为x的元素。如果没有这样的元素，则抛出ValueError异常。
5、list.pop([i]): 删除列表中给定位置的元素并返回它。如果没有给定位置，a.pop()将会删除并返回列表中的最后一个元素
6、list.clear(): 移除列表中的所有元素。等价于 ‘ del a[:] ’
7、list.index(x[,start[,end]]): 返回列表中第一个值为x的元素的从零开始的索引。如果没有这样的元素将会抛出ValueError异常。
        可选参数start和end是切片符号，用于将搜索限制为列表的特定子序列。
8、list.count(x): 返回元素x在列表中出现的次数
9、sort(*,key=None,reverse=False): 对类表中的元素进行排序。
10、reverse():反转列表中的元素
11、copy(): 返回列表的一个浅拷贝
12、del list[x:y]： 通过索引来移除元素

'''


class ListTest(object):
    def test_case_a(self):
        a_list = [1, 2, 3, 4, 5]
        b_list = ['a', 'b', 'c', 'd', 'f']
        a_list.extend(b_list)
        print('a_list=======', a_list)  # [1, 2, 3, 4, 5, 'a', 'b', 'c', 'd', 'f']

        # 通过copy()实现浅拷贝.拷贝生成的新列表于原列表的地址不同，新列表数据的改动不会造成原有列表数据的改动。
        c_list = b_list.copy()
        print('id(b_list),id(c_list)========', id(b_list), id(c_list))  # 28389544 28613640
        print(c_list)  # ['a', 'b', 'c', 'd', 'f']
        print('type(c_list)', type(c_list))  # <class 'list'>
        c_list[len(c_list):] = 'Y'
        print('c_list========', c_list)  # ['a', 'b', 'c', 'd', 'f', 'Y']
        print('b_list=========', b_list)  # ['a', 'b', 'c', 'd', 'f']

        # del list[x:y]
        print('c_list=========', c_list)    # ['a', 'b', 'c', 'd', 'f', 'Y']
        del c_list[(len(c_list) - 1):]
        print('c_list-----', c_list)        # ['a', 'b', 'c', 'd', 'f']

        # list.remove(x)
        print('c_list=========', c_list)    # ['a', 'b', 'c', 'd', 'f']
        c_list.remove('a')
        print('c_list-----', c_list)        # ['b', 'c', 'd', 'f']

        # 列表的解构赋值
        b,c,d,f = c_list
        print(b,c,d,f)  # b c d f




if __name__ == '__main__':
    list_test = ListTest()
    list_test.test_case_a()
