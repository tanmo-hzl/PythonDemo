#!usr/bin/ python3
# -*- coding:utf-8 -*-

"""
@Description: 
@Author: hzlvxln
@Time: 2021/12/12 11:51
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: FunctionTest.py
@Copyright: ©2019-2021 家灏信息科技有限公司
"""


class FunctionTest:

    # 1、不定长参数varTuple
    def printInfoTuple(self, argA, argB, *varTuple):
        '''不定长参数 "*varTuple" :
            1、当传入的参数个数不确定时，你可能需要一个函数能够处理比申明时更多的参数，这时需要定义
            一个不定长参数 “*varTuple”用来接受不确定的参数值。varTuple在使用时是一个元组（Tuple）
            2、下例中varTuple是一个不定长参数，其是一个元组，使用时根据元组的api进行调用
        '''
        print(argA)
        print(argB)
        print(''.center(80, '-'))
        print(varTuple)
        print("".center(80, '='), "\r\n")
        return

    # 2、不定长参数 “**varDict”
    def printInfoDictionary(self, argA, argB, **varDict):
        '''不定长参数varDict
        1、加了两个星号 ** 的参数会以字典的形式导入
        '''
        print(argA)
        print(argB)
        print(''.center(80, '-'))
        print(varDict)
        print(''.center(80, '='), "\r\n")
        return

    # 3、星号是分隔符，调用时后面的参数必须带名字。星号本身不是参数。
    def testFunctionSeparator(self, a, b, *, name, value):
        print(a)
        print(b)
        print(''.center(80, '-'))
        print(name)
        print(value)
        print(''.center(80, '='),'\r\n')
        return

    # 4、匿名函数，Python中使用lambda表达式来创建匿名函数
    '''
    lambda 只是一个表达式，函数体比 def 简单很多。
    lambda的主体是一个表达式，而不是一个代码块。仅仅能在lambda表达式中封装有限的逻辑进去。
    lambda 函数拥有自己的命名空间，且不能访问自己参数列表之外或全局命名空间里的参数。
    虽然lambda函数看起来只能写一行，却不等同于C或C++的内联函数，后者的目的是调用小函数时不占用栈内存从而增加运行效率。
    '''
    def testLambdaFunction(self,argA,argB):
        sum=lambda argA, argB: argA + argB
        print(sum(12,13))
        print(''.center(80, '='), '\r\n')


    # 5、强制位置参数：Python3.8新增了一个函数形参语法 “/” 用来指明函数形参必须使用指定位置参数，不能使用关键字参数的形式
    def testlocationFunction(self,a,b,/,c,d,*,e,f):
        '''
        该函数定义中，形参a和b必须使用指定位置产出，c或d可以使用位置形参或关键字形参，而e和f要求为关键字形参
        '''
        print(a)
        print(b)
        print(c)
        print(d)
        print(e)
        print(f)
        print(''.center(80,'='),'\r\n')


    # 6、在一些Python的工程项目中，我们会看到函数参数中会有冒号，有的函数后面会跟着一个箭头，你可能会疑惑，这些都是什么东西？
    # 其实函数参数中的冒号是参数的类型建议符，告诉程序员希望传入的实参的类型。函数后面跟着的箭头是函数返回值的类型建议符，用来说明该函数返回的值是什么类型。


if __name__ == '__main__':
    functionTest = FunctionTest();

    functionTest.printInfoTuple(1, 2)
    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    ================================================================================
    '''

    functionTest.printInfoTuple(1, 2, 3)
    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    (3,)
    ================================================================================

    '''
    functionTest.printInfoTuple(1, 2, 3, 4, 5)

    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    (3, 4, 5)
    ================================================================================
    '''

    functionTest.printInfoDictionary(1, 2, )
    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    {}
    ================================================================================ 
    '''

    functionTest.printInfoDictionary(1, 2, a=3, b=4, c=5)
    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    {'a': 2, 'b': 3, 'c': 4}
    ================================================================================ 
    '''

    functionTest.testFunctionSeparator(1, 2, name='hzl', value='18')
    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    hzl
    18
    ================================================================================
    '''

    functionTest.testLambdaFunction(12,13)
    '''输出结果：
    25
    ================================================================================ 

    '''

    functionTest.testlocationFunction(10, 20, 30, d=40, e=50, f=60)
    '''输出结果：
    10
    20
    30
    40
    50
    60
    ================================================================================ 
    '''

    '''错误示例1：
    functionTest.testlocationFunction(10, b=20, c=30, d=40, e=50, f=60)     # b不能使用关键字参数的形式
    Traceback (most recent call last):
      File "D:/AppDocument/Pycharm/PythonDemo/PythonFoundationDemo/BasicGrammar/FunctionTest.py", line 156, in <module>
        functionTest.testlocationFunction(10, b=20, c=30, d=40, e=50, f=60)
    TypeError: testlocationFunction() got some positional-only arguments passed as keyword arguments: 'b'
    '''

    '''错误示例2：
    functionTest.testlocationFunction(10, 20, 30, 40, 50, f=60)     # e 必须使用关键字参数
    Traceback (most recent call last):
      File "D:/AppDocument/Pycharm/PythonDemo/PythonFoundationDemo/BasicGrammar/FunctionTest.py", line 159, in <module>
        functionTest.testlocationFunction(10, 20, 30, 40, 50, f=60)
    TypeError: testlocationFunction() takes 5 positional arguments but 6 positional arguments (and 1 keyword-only argument) were given
    '''
