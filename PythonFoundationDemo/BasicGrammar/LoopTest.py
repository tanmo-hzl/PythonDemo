#!usr/bin/ python3
# -*- coding:utf-8 -*-

"""
@Description: 
@Author: hzlvxln
@Time: 2021/12/12 22:20
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: LoopTest.py
@Copyright: ©2019-2021 家灏信息科技有限公司
"""





'''深入条件控制

while 和 if 条件句中可以使用任意操作，而不仅仅是比较操作。

比较操作符 in 和 not in 校验一个值是否在（或不在）一个序列里。操作符 is 和 is not 比较两个对象是不是同一个对象，这只对像列表这样的可变对象比较重要。所有的比较操作符都有相同的优先级，且这个优先级比数值运算符低。

比较操作可以传递。例如 a < b == c 会校验是否 a 小于 b 并且 b 等于 c。

比较操作可以通过布尔运算符 and 和 or 来组合，并且比较操作（或其他任何布尔运算）的结果都可以用 not 来取反。这些操作符的优先级低于比较操作符；在它们之中，not 优先级最高， or 优先级最低，因此 A and not B or C 等价于 (A and (not B)) or C。和之前一样，你也可以在这种式子里使用圆括号。

布尔运算符 and 和 or 也被称为 短路 运算符：它们的参数从左至右解析，一旦可以确定结果解析就会停止。例如，如果 A 和 C 为真而 B 为假，那么 A and B and C 不会解析 C。当用作普通值而非布尔值时，短路操作符的返回值通常是最后一个变量。

也可以把比较操作或者逻辑表达式的结果赋值给一个变量，例如

>>>
>>> string1, string2, string3 = '', 'Trondheim', 'Hammer Dance'
>>> non_null = string1 or string2 or string3
>>> non_null
'Trondheim'
请注意 Python 与 C 不同，在表达式内部赋值必须显式地使用 海象运算符 := 来完成。 这避免了 C 程序中常见的一种问题：想要在表达式中写 == 时却写成了 =。



'''

class LoopTest(object):

    # 循环技巧
    def test_case_a(self):
        knights = {'gallahad': 'the pure', 'robin': 'the brave'}
        # 当在字典中循环时，用 items() 方法可将关键字和对应的值同时取出
        print('items'.center(80,'='))
        for k, v in knights.items():
            print(k, v)
            '''输出结果：
            gallahad the pure
            robin the brave
            '''

        # 当在序列中循环时，用 enumerate() 函数可以将索引位置和其对应的值同时取出
        print('enumerate'.center(80,'='))
        for i, v in enumerate(['tic', 'tac', 'toe']):
            print(i, v)
            '''输出结果
            0 tic
            1 tac
            2 toe
            '''

        print('enumerate'.center(80,'='))
        # 当同时在两个或更多序列中循环时，可以用 zip() 函数将其内元素一一匹配。
        questions = ['name', 'quest', 'favorite color']
        answers = ['lancelot', 'the holy grail', 'blue']
        for q, a in zip(questions, answers):
            print('What is your {0}?  It is {1}.'.format(q, a))
            '''
            What is your name?  It is lancelot.
            What is your quest?  It is the holy grail.
            What is your favorite color?  It is blue.
            '''

    # 深入条件控制
    def test_case_b(self):
        pass





if __name__ == '__main__':
    loop_test= LoopTest()
    loop_test.test_case_a()