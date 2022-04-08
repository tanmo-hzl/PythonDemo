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






'''
在 Python 中，日期和时间可能涉及好几种不同的数据类型和函数。下面回顾了
表示时间的 3 种不同类型的值：
 Unix 纪元时间戳（time 模块中使用）是一个浮点值或整型值，表示自 1970 年
1 月 1 日午夜 0 点（UTC）以来的秒数。
 datetime 对象（属于 datetime 模块）包含一些整型值，保存在 year、 month、 day、
hour、 minute 和 second 等属性中。
 timedelta 对象（属于 datetime 模块）表示的一段时间，而不是一个特定的时刻。
下面回顾了时间函数及其参数和返回值：
 time.time()函数返回一个浮点值，表示当前时刻的 Unix 纪元时间戳。
 time.sleep(seconds)函数让程序暂停 seconds 参数指定的秒数。
 datetime.datetime(year, month, day, hour, minute, second)函数返回参数指定的时
本文档由Linux公社 www.linuxidc.com 整理第 15 章 保持时间、计划任务和启动程序
刻的 datetime 对象。如果没有提供 hour、 minute 或 second 参数，它们默认为 0。
 datetime.datetime.now()函数返回当前时刻的 datetime 对象。
 datetime.datetime.fromtimestamp(epoch)函数返回 epoch 时间戳参数表示的时刻
的 datetime 对象。
 datetime.timedelta(weeks, days, hours, minutes, seconds, milliseconds, microseconds)函
数返回一个表示一段时间的 timedelta 对象。该函数的关键字参数都是可选的，
不包括 month 或 year。
 total_seconds()方法用于 timedelta 对象，返回 timedelta 对象表示的秒数。
 strftime(format)方法返回一个字符串，用 format 字符串中的定制格式来表示
datetime 对象表示的时间。详细格式参见表 15-1。
 datetime.datetime.strptime(time_string, format)函数返回一个 datetime 对象，它的
时刻由 time_string 指定，利用 format 字符串参数来解析。详细格式参见表 15-1



'''

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

    def testCaseF(self):
        # datetime对象可以用比较操作符进行比较，弄清楚谁在前面。后面的datetime对象是“更大”的值。在交互式环境中输入以下代码：
        halloween2015 = datetime.datetime(2015, 10, 31, 0, 0, 0)
        newyears2016 = datetime.datetime(2016, 1, 1, 0, 0, 0)
        oct31_2015 = datetime.datetime(2015, 10, 31, 0, 0, 0)
        print(halloween2015 == oct31_2015)      # True
        print(halloween2015 > newyears2016)     # False
        print(newyears2016 > halloween2015)     # True
        newyears2016 != oct31_2015              # True

    def testCaseG(self):
        # datetime 模块还提供了 timedelta 数据类型，它表示一段时间，而不是一个时刻。在交互式环境中输入以下代码：
        delta = datetime.timedelta(days=11, hours=10, minutes=9, seconds=8)
        print(delta.days, delta.seconds, delta.microseconds)    # 11     36548   0
        print(delta.total_seconds())        # 986948.0
        print(str(delta))       # 11 days, 10:09:08
        '''
            要创建 timedelta 对象，就用 datetime.timedelta()函数。 datetime.timedelta()函数
        接受关键字参数 weeks、 days、 hours、 minutes、 seconds、 milliseconds 和 microseconds。
        没有 month 和 year 关键字参数，因为“月”和“年”是可变的时间，依赖于特定月
        份或年份。 timedelta 对象拥有的总时间以天、秒、微秒来表示。这些数字分别保存
        在 days、 seconds 和 microseconds 属性中。 total_seconds()方法返回只以秒表示的时
        间。将一个 timedelta 对象传入 str()，将返回格式良好的、人类可读的字符串表示。
        '''
        # 利用+和-运算符， timedelta 对象与 datetime 对象或其他 timedelta 对象相加或相
        # 减。利用*和/运算符， timedelta 对象可以乘以或除以整数或浮点数。
        oct21st = datetime.datetime(2015, 10, 21, 16, 29, 0)
        aboutThirtyYears = datetime.timedelta(days=365 * 30)
        print(oct21st)      # datetime.datetime(2015, 10, 21, 16, 29)
        print(oct21st - aboutThirtyYears)       # datetime.datetime(1985, 10, 28, 16, 29)
        print(oct21st - (2 * aboutThirtyYears))     # datetime.datetime(1955, 11, 5, 16, 29)

    def testCaseH(self):
        '''1、
            Unix 纪元时间戳和 datetime 对象对人类来说都不是很友好可读。利用 strftime()方
        法，可以将 datetime 对象显示为字符串。（strftime()函数名中的 f 表示格式， format）。
        该的 strftime()方法使用的指令类似于 Python 的字符串格式化。

        strftime 指令 含义:
            %Y       带世纪的年份，例如'2014'
            %y       不带世纪的年份， '00'至'99'（1970 至 2069）
            %m       数字表示的月份, '01'至'12'
            %B       完整的月份，例如'November'
            %b       简写的月份，例如'Nov'
            %d       一月中的第几天， '01'至'31'
            %j       一年中的第几天， '001'至'366'
            %w       一周中的第几天， '0'（周日）至'6'（周六）
            %A       完整的周几，例如'Monday'
            %a       简写的周几，例如'Mon'
            %H       小时（24 小时时钟）， '00'至'23'
            %I       小时（12 小时时钟）， '01'至'12'
            %M       分， '00'至'59'
            %S       秒， '00'至'59'
            %p       'AM'或'PM'
            %%       就是'%'字符
        '''
        oct21st = datetime.datetime(2015, 10, 21, 16, 29, 0)
        print(oct21st)
        print(type(oct21st))
        print(oct21st.strftime('%Y/%m/%d %H:%M:%S'))    # '2015/10/21 16:29:00'
        print(oct21st.strftime('%I:%M %p'))     # '04:29 PM'
        print(oct21st.strftime("%B of '%y"))       # "October of '15"

        '''
            如果有一个字符串的日期信息，如'2015/10/21 16:29:00'或'October 21, 2015'，需
        要将它转换为 datetime 对象，就用 datetime.datetime.strftime()函数。 strptime()函数与
        strftime()方法相反。定制的格式字符串使用相同的指令，像 strftime()一样。必须将
        格式字符串传入 strptime()，这样它就知道如何解析和理解日期字符串（ strptime()
        函数名中 p 表示解析， parse）  
        '''

        a = datetime.datetime.strptime('October 21, 2015', '%B %d, %Y')
        print(a)
        print(type(a))

    def get_begin_datatime_by_input(self, num):
        '''
        Gets the start timestamp of how many days before or after the current time
        (获得当前时间前多少天或后多少天的开始时间)
        :param num:
        :return:
        '''
        now_time = datetime.datetime.now()
        pastManyDayStr = (now_time + datetime.timedelta(days=num)).strftime("%Y-%m-%d")
        pastManyDay = datetime.datetime.strptime(pastManyDayStr, '%Y-%m-%d').astimezone()
        return pastManyDay

    def test_date(self):
        time_str = '2022-04-08T03:30:00.501+00:00'
        a = datetime.datetime.fromisoformat(time_str)
        print('type(a) :', type(a))
        print('a:', a)
        c = self.get_begin_datatime_by_input(0).astimezone()
        print('c:', c)
        print(a > c)


if __name__ == '__main__':
    dateTime = DateTimeTest()
    # dateTime.testCaseA()
    # dateTime.testCaseB()
    # dateTime.testCaseC()
    # dateTime.testCaseD()
    # dateTime.testCaseG()
    # dateTime.testCaseH()
    dateTime.testCaseI()