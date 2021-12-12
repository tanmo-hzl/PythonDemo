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
class FuctionTest:

    # 不定长参数varTuple
    def printInfoTuple(self, argA, argB, *varTuple):
        '''不定长参数 "*varTuple" :
            1、当传入的参数个数不确定时，你可能需要一个函数能够处理比申明时更多的参数，这时需要定义
            一个不定长参数 “*varTuple”用来接受不确定的参数值。varTuple在使用时是一个元组（Tuple）
            2、下例中varTuple是一个不定长参数，其是一个元组，使用时根据元组的api进行调用
        '''
        print(argA)
        print(argB)
        print(''.center(80,'-'))
        for var in varTuple:
            print(varTuple)
        print("".center(80,'='))
        print("\r\n")
        return


    def printInfoDictionary(self,argA,argB,**varDict):
        print(argA)
        print(argB)
        print(''.center(80,'-'))
        print(varDict)
        print(''.center(80,'='))
        print("\r\n")









if __name__ == '__main__':
    fuctionTest = FuctionTest();

    fuctionTest.printInfoTuple(1, 2)
    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    ================================================================================
    '''

    fuctionTest.printInfoTuple(1, 2, 3)
    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    (3,)
    ================================================================================

    '''
    fuctionTest.printInfoTuple(1, 2, 3, 4, 5)

    '''输出结果：
    1
    2
    --------------------------------------------------------------------------------
    (3, 4, 5)
    (3, 4, 5)
    (3, 4, 5)
    ================================================================================
    '''


    fuctionTest.printInfoDictionary(1,2,)
    fuctionTest.printInfoDictionary(1,2,a=2,b=3,c=4)
