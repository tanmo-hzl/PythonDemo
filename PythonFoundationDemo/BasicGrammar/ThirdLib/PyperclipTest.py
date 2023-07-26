#!usr/bin/ python3
# -*- coding:utf-8 -*-

import pyperclip
from PythonFoundationDemo.ProjectDemo.ImportTest import ImportTest
"""
@Description: pyperclip模块有copy()和paste()函数，可以向计算机的剪切板发送文本，或从计算机的剪切板接受文本。
@Author: 
@Time: 2022/2/12 11:19
@Website: 
@project: PythonDemo
@FileName: PyperclipTest.py
@Copyright: ©2019-2022 
"""

class PyperclipTest(object):
    def test_copy_and_paste(self):
        # pyperclip.copy()方法将文本copy进剪切板。
        pyperclip.copy("Hello world")
        # pyperclip.paste()方法将会取到剪切板的内容。
        paste = pyperclip.paste()
        print(paste)


if __name__ == '__main__':
    pyperclipTest = PyperclipTest()
    # pyperclipTest.test_copy_and_paste()
    IM= ImportTest()
    ImportTest.testA(IM)