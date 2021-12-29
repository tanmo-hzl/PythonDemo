#!usr/bin/ python3
# -*- coding:utf-8 -*-
"""
@Description: Database connection pool
@Author: Evan He
@Time: 12/29/2021 12:01 AM
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: PoolUtils.py
@Copyright: ©2019-2021 michaels.com
"""

import pymysql  # 数据库连接
from dbutils.pooled_db import PooledDB  # 用于数据库连接池


class PoolUtils(object):
    '''
    @ClassName：PoolUtils
    @Description：
    '''
    __config = {
        'creator': pymysql,             # 使用链接数据库的模块
        'maxconnections': 6,            # 连接池允许的最大连接数，0和None表示没有限制
        'mincached': 2,                 # 初始化时，连接池至少创建的空闲的连接，0表示不创建
        'maxcached': 5,                 # 连接池空闲的最多连接数，0和None表示没有限制
        'maxshared': 3,                 # 连接池中最多共享的连接数量，0和None表示全部共享，ps:其实并没有什么用，因为pymsql和MySQLDB等模块中的threadsafety都为1，所有值无论设置多少，_maxcahed永远为0，所以永远是所有链接共享
        'blocking': True,               # 链接池中如果没有可用共享连接后，是否阻塞等待，True表示等待，False表示不等待然后报错
        'setsession': [],               # 开始会话前执行的命令列表
        'ping': 0,                      # ping Mysql 服务端，检查服务是否可用
        'host': '127.0.0.1',            # mysql主机的IP地址
        'port': 3306,                   # MySQL的端口号
        'user': 'root',                 # MySQL数据库用户名
        'password': 'Password123',      # MySQL数据用户名对应的密码
        'database': 'my_test',          # MySQL数据库的库名称
        'charset': 'utf8'               # 编码格式

    }


    def __init__(self):
        pass

    def get_pool_connection(self):
        pool = PooledDB(**self.__config)    # **self.__config 结构__config中的值。
        conn = pool.connection()
        return conn


if __name__ == '__main__':
    # 检测当前正在运行的连接数是否小于最大的连接数，如果不小于则等待连接或者抛出raise TooManyConnections异常
    # 否则优先去初始化时创建的连接中获取连接SteadyDBConnection
    # 然后将SteadyDBConnection对象封装到PooledDedicatedDBConnection中并返回
    # 如果最开始创建的连接没有链接，则去创建SteadyDBConnection对象，再封装到PooledDedicatedDBConnection中并返回
    # 一旦关闭链接后，连接就返回到连接池让后续线程继续使用
    ci = PoolUtils()
    conne = ci.get_pool_connection()
    cursor  = conne.cursor()
    result = cursor.execute('select * from student')
    print(result)

