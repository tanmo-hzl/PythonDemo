#!usr/bin/ python3
# -*- coding:utf-8 -*-

import time
import datetime

"""
@Description: 标准库time，处理时间相关的方法
@Author: hzlvxln
@Time: 2021/12/14 20:19
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: DateTimeTest.py
@Copyright: ©2019-2021 家灏信息科技有限公司
"""


class DateTimeTest(object):
    def testCaseA(self):
        # 时间戳 1970.01.01到指定时间的间隔，单位是秒
        print(time.time())  # 获取当前时间的时间戳表示形式

    # 结构化时间对象
    def testCaseB(self):
        st = time.localtime()
        print(type(st))
        '''输出结果：
        <class 'time.struct_time'>
        '''
        print(isinstance(st,tuple))
        '''输出结果：
        True
        '''
        print(st)
        '''输出结果：
        time.struct_time(tm_year=2021, tm_mon=12, tm_mday=14, tm_hour=21, tm_min=2, tm_sec=30, tm_wday=1, tm_yday=348, tm_isdst=0)
        tm_year=2021:   年
        tm_mon=12：  月
        tm_mday=14： 日 
        tm_hour=21： 小时 
        tm_min=2,：  分
        tm_sec=30：  秒
        tm_wday=1：  一个星期中的第几天（星期一tm_wday=0） 
        tm_yday=348：    一年中的第几天
        tm_isdst=0:     夏令时
        '''
        print("".center(80,'='),st[0])  # 2021
        print(st.tm_year)   # 2021


    # 三种格式之间的相互转换
    def testCaseC(self):
        '''
        时间戳 -->  结构化对象
        '''
        # UTC  格林尼治时间
        print(time.gmtime())
        '''输出结果：
        time.struct_time(tm_year=2021, tm_mon=12, tm_mday=14, tm_hour=14, tm_min=5, tm_sec=15, tm_wday=1, tm_yday=348, tm_isdst=0)
        '''
        print(time.gmtime(time.time()))
        '''输出结果：
        time.struct_time(tm_year=2021, tm_mon=12, tm_mday=14, tm_hour=14, tm_min=5, tm_sec=15, tm_wday=1, tm_yday=348, tm_isdst=0)
        '''

        # local 本地时间
        print(time.localtime())
        '''输出结果：
        time.struct_time(tm_year=2021, tm_mon=12, tm_mday=14, tm_hour=22, tm_min=5, tm_sec=15, tm_wday=1, tm_yday=348, tm_isdst=0)
        '''
        print(time.localtime(time.time()))
        '''输出结果：
        time.struct_time(tm_year=2021, tm_mon=12, tm_mday=14, tm_hour=22, tm_min=5, tm_sec=15, tm_wday=1, tm_yday=348, tm_isdst=0)
        '''


        '''
        结构化对象 --> 时间戳
        '''
        print(time.time())  # 1639491506.3375685
        print(time.localtime()) # time.struct_time(tm_year=2021, tm_mon=12, tm_mday=14, tm_hour=22, tm_min=19, tm_sec=25, tm_wday=1, tm_yday=348, tm_isdst=0)
        print(time.mktime(time.localtime()))    # 1639491506.0


        '''
        结构化对象 --> 格式化时间字符串
        '''
        print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime()))  # 2021-12-14 22:28:48
        print(time.strftime('%Y-%m-%d %H:%M:%S',time.gmtime()))     # 2021-12-14 14:28:48


        '''
        格式化的字符串 --> 结构化时间对象
        '''
        strtime = '2020-02-25 20:20:18'
        print(time.strptime(strtime,'%Y-%m-%d %H:%M:%S'))
        '''输出结果：
        time.struct_time(tm_year=2020, tm_mon=2, tm_mday=25, tm_hour=20, tm_min=20, tm_sec=18, tm_wday=1, tm_yday=56, tm_isdst=-1)
        '''


if __name__ == '__main__':
    dateTime = DateTimeTest()
    dateTime.testCaseA()
    dateTime.testCaseB()
    dateTime.testCaseC()
