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


class OpenpyxlTest(object):
    '''
    @ClassName：OpenpyxlTest
    @Description：
    '''
    def test_a(self):
        wb = openpyxl.Workbook()
        wb.save('test.xlsx')


if __name__ == '__main__':
    ci = OpenpyxlTest()
    ci.test_a()