#!usr/bin/ python3
# -*- coding:utf-8 -*-
"""
@Description: 
@Author: Evan He
@Time: 12/30/2021 1:55 AM
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: OpenpyxlTest.py
@Copyright: ©2019-2021 michaels.com
"""

import openpyxl
import os


class OpenpyxlTest(object):
    '''
    @ClassName：OpenpyxlTest
    @Description：
    '''
    def test_a(self):
        wb = openpyxl.Workbook()
        file_name = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))),'TestData','OutputData','test.xlsx')

        # wb.save('test.xlsx')
        wb.save(file_name)


if __name__ == '__main__':
    ci = OpenpyxlTest()
    ci.test_a()