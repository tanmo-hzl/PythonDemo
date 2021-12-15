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
        print(' A '.center(80, '='))
        # 时间戳 1970.01.01到指定时间的间隔，单位是秒
        print(time.time())  # 获取当前时间的时间戳表示形式

    # 结构化时间对象
    def testCaseB(self):
        print(' B '.center(80, '='))
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
        print(' C '.center(80, '='))
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

        print(time.timezone)


    def testCaseD(self):
        print(' D '.center(80,'='))
        # time.time()返回的值是UNIX纪元时间戳，该返回值是一个浮点类型
        today = time.time()
        print(type(today))  # <class 'float'>
        print(today)    # 1639578364.86416
        print(round(today))  # 1639578365
        print(round(today,3))   # 1639578506.122    round(*args, **kwargs)方法四舍五入保留小数位数
        today2 = time.localtime(1639533997)
        print(today2)
        oneDayAgoBeginStamp = datetime.datetime.now() - datetime.timedelta(days=1)

        # 获取系统当前时间
        now_time_a = datetime.datetime.now()
        print(now_time_a)  # 2021-12-15 00:40:06.878866
        print(type(now_time_a))  # <class 'datetime.datetime'>
        # 将时间戳格式化为时间格式的字符串
        yesterdayStr = (now_time_a + datetime.timedelta(days=-1)).strftime("%Y-%m-%d")
        print(yesterdayStr)  # 021-12-14
        print(type(yesterdayStr))  # <class 'str'>
        # 将字符串转化为结构化时间struct_time。注意：时间格式字符串要与格式化字符串能够匹配
        yesterdayStructTime = time.strptime(yesterdayStr, '%Y-%m-%d')
        print(
            yesterdayStructTime)  # time.struct_time(tm_year=2021, tm_mon=12, tm_mday=14, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=1, tm_yday=348, tm_isdst=-1)
        # 将结构化时间转换为时间（float类型的时间）
        yesterdayStamp = time.mktime(yesterdayStructTime)
        print(yesterdayStamp)  # 1639461600.0
        print(type(yesterdayStamp))  # <class 'float'>

        # 将float类型的数字转换 成本 地时间戳
        a = datetime.datetime.fromtimestamp(yesterdayStamp)
        # 将时间戳格式化为日期字符
        a.strftime("%Y-%m-%d %H:%M:%S")
        print(a)  # 2021-12-14 00:00:00
        print(type(a))  # <class 'datetime.datetime'>
        print(a.strftime("%Y-%m-%d %H:%M:%S"))  # 2021-12-14 06:00:00

        # 将float类型的数字转换成 格林尼治 时间戳
        b = datetime.datetime.utcfromtimestamp(yesterdayStamp)
        # 将时间戳格式化为日期字符
        b.strftime("%Y-%m-%d %H:%M:%S")
        print(b)  # 2021-12-14 06:00:00
        print(type(b))  # <class 'datetime.datetime'>
        print(b.strftime("%Y-%m-%d %H:%M:%S"))  # 2021-12-14 06:00:00

        '''关于datetime类：
            datetime类是date和time的结合体，包括date与time的所有信息，date和time类中具有的方法和属性，datetime类都具有。
            
            所以在我们日常的工作中，可以仅使用datetime类。该类的构造函数： 
            datetime.datetime(year, month, day[, hour[, minute[, second[, microsecond[,tzinfo]]]]]) 
            各参数的含义与date、time构造函数中的一样，但是要注意各参数的取值范围。 
            
            1、today函数  返回一个当前本地时间的datetime.datetime类的对象。
            2、now（[tz]) 不指定时区，返回一个当前本地时间的datetime.datetime类的对象。指定时区，返回指定时区的时间
            3、fromtimestamp(timestamp[,tz]) 给定一个时间戳，返回指定时区的datetime.datetime类的对象。不指定时区，返回本地时区的datetime类对象
            4、strptime("时间字符串",format) 将格式时间字符串转换为datetime对象
            5、Datetime类—year、month、day、hour、minute、second属性 
               
            6、datetime.date() 参数是datetime.datetime类的对象，得到一个datetime.date对象
            7、datetime.time() 参数是datetime.datetime类的对象，得到一个datetime.time对象
            8、datetime.combime() 参数是datetime.datetime类的对象、datetime.date对象、datetime.time对象，得到一个datetime.datetime对象     
            9、datetime.replace([year[, month[, day[, hour[, minute[, second[, microsecond[, tzinfo]]]]]]]]) 函数
            
        '''

    def testCaseE(self):
        # 1、字符串转换为datetime.datetime：
        print(datetime.datetime.strptime("2020-07-09 18:21:17", "%Y-%m-%d %H:%M:%S"))   # 输出：2020 - 07 - 09 18: 21:17

        # 2、tuple、list转换为datetime.datetime：
        datetime_list = [2020, 7, 10, 9, 40, 47]
        datetime_tuple = (2020, 7, 10, 9, 40, 47)
        print(datetime.datetime(*datetime_list))    # 2020 - 07 - 10 09: 40:47
        print(datetime.datetime(*datetime_tuple))   # 2020 - 07 - 10 09: 40:47

        # 3、日期加减
        print(datetime.datetime.now())  # 2020 - 07 - 14 11: 34:47.671556
        print(datetime.datetime.now() + datetime.timedelta(hours=1))    # 2020 - 07 - 14 12: 34:47.671556
        print(datetime.datetime.now() + datetime.timedelta(days=1))     # 2020 - 07 - 15 11: 34:47.671556
        print(datetime.datetime.now() + datetime.timedelta(weeks=1))    # 2020 - 07 - 21 11: 34:47.671556

        # 4、修改时间为指定时间（查询是从00: 00:00开始查询）
        print((datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%d 00:00:00")) # 2020 - 07 - 15 00: 00:00


        # 5、生成10 & & 13位时间戳：
        print(int(datetime.datetime.now().timestamp())) # 1594698366
        print(int(datetime.datetime.now().timestamp()) * 1000)  # 1594698366000
        print(int(datetime.datetime(2020, 7, 10, 9, 40, 47).timestamp()))   # 1594345247
        print(int(datetime.datetime(2020, 7, 10, 9, 40, 47).timestamp()) * 1000)    # 1594345247000

        # 6、10 or 13位时间戳转换为标准时间：

        # 　　①10位时间戳转换为标准时间
        print(datetime.datetime.fromtimestamp(1594953515))  # 2020 - 07 - 17 10: 38:35

        # 　　②13位时间戳转换为标准时间：
        time_stamp = float(1594953515000 / 1000)
        date = datetime.datetime.fromtimestamp(time_stamp)
        print(date)     # 2020 - 07 - 17 10: 38:35


if __name__ == '__main__':
    dateTime = DateTimeTest()
    dateTime.testCaseA()
    dateTime.testCaseB()
    dateTime.testCaseC()
    dateTime.testCaseD()
