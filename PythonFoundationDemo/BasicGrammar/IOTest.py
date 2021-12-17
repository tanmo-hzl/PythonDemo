#!usr/bin/ python3
# -*- coding:utf-8 -*-
import os

"""
@Description: 
@Author: hzlvxln
@Time: 2021/12/17 22:08
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: IOTest.py
@Copyright: ©2019-2021 家灏信息科技有限公司
"""

'''
1、在Linux系统中，有点（.）和点点（.）文件夹，他们并不是真正的文件夹，而是可以在路径中使用的特殊名称。
单个的句点（“点”）用作文件夹目名称时，是“这个目录”的缩写。两个句点（“点点”）意思是父文件夹。下列命令是在Linux中运行情况
--hzl@hzl-PC:/dev/mapper$ cd ./
--hzl@hzl-PC:/dev/mapper$ cd ../
--hzl@hzl-PC:/dev$ cd ./
--hzl@hzl-PC:/dev$ 
2、




'''
class IOTest(object):

    # 文件路径的处理
    def testCaseA(self):
        # 拼接文件路径
        path = os.path.join('store', 'book', 'redbook')
        print(path)     # store\book\redbook

        # 获得当前文件路径,返回的是一个字符串<class 'str'>
        print(os.getcwd())      # D:\AppDocument\Pycharm\PythonDemo\PythonFoundationDemo\BasicGrammar
        print(type(os.getcwd()))    # <class 'str'>

        # 获取当前路径，返回的是一个
        print(os.getcwdb())     # b'D:\\AppDocument\\Pycharm\\PythonDemo\\PythonFoundationDemo\\BasicGrammar'
        print(type(os.getcwdb()))   # <class 'bytes'>

        # 更改当前工作路径
        # os.chdir('D:\\AppDocument\\Pycharm\\PythonDemo\\PythonFoundationDemo')
        print(os.getcwd())      # D:\AppDocument\Pycharm\PythonDemo\PythonFoundationDemo

        # 创建新文件夹
        # os.makedirs("D:\\AppDocument\\Pycharm\\PythonDemo\\test")   # 如果文件夹已存在就会报错

        # 调用 os.path.abspath(path)将返回参数的绝对路径的字符串。这是将相对路径转换为绝对路径的简便方法
        print('abspathA---',os.path.abspath('.'))       # D:\AppDocument\Pycharm\PythonDemo\PythonFoundationDemo\BasicGrammar
        print('abspathB===',os.path.abspath('../'))     # D:\AppDocument\Pycharm\PythonDemo\PythonFoundationDemo

        # 调用 os.path.isabs(path)，如果参数是一个绝对路径，就返回 True，如果参数是一个相对路径，就返回 False。
        print('isabs===',os.path.isabs('.'))    # False
        print('isabs',os.path.isabs(os.path.abspath('.')))      # True

        # 调用os.path.relpath(path, start) 将返回从start路径到path的相对路径的字符串。如果没有提供start，就使用当前工作目录作为开始路径。
        print(os.path.relpath('D:\AppDocument\Pycharm\PythonDemo\PythonFoundationDemo\BasicGrammar','D:\AppDocument\Pycharm\PythonDemo'))   # PythonFoundationDemo\BasicGrammar

        # 调用 os.path.dirname(path)将返回一个字符串，它包含 path 参数中最后一个斜杠之前的所有内容。
        print(os.getcwd())                      # D:\AppDocument\Pycharm\PythonDemo\PythonFoundationDemo\BasicGrammar
        print(os.path.dirname(os.getcwd()))     # D:\AppDocument\Pycharm\PythonDemo\PythonFoundationDemo

        # 调用 os.path.basename(path)将返回一个字符串，它包含 path 参数中最后一个斜杠之后的所有内容。
        print('basename ===== ',os.path.basename(os.path.abspath('.')))   # BasicGrammar

        # 如果同时需要一个路径的目录名称和基本名称， 就可以调用 os.path.split()，获得这两个字符串的元组
        print('split======= ',os.path.split(os.path.abspath('.')))    # ('D:\\AppDocument\\Pycharm\\PythonDemo\\PythonFoundationDemo', 'BasicGrammar')

        # 调用 os.path.getsize(path)将返回 path 参数中文件的字节数

        # 调用 os.listdir(path)将返回文件名字符串的列表，包含 path 参数中的每个文件

        # 如果 path 参数所指的文件或文件夹存在， 调用 os.path.exists(path)将返回 True，否则返回 False。

        # 如果 path 参数存在，并且是一个文件，调用 os.path.isfile(path)将返回 True，否则返回 False。

        # 如果 path 参数存在，并且是一个文件夹， 调用 os.path.isdir(path)将返回 True，否则返回 False。

    # 文件的读写
    def testCaseB(self):
        pass
if __name__ == '__main__':
    ioTest = IOTest()
    ioTest.testCaseA()
    pass
