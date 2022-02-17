#!usr/bin/ python3
# -*- coding:utf-8 -*-

import re

"""
@Description:
@Author: hzlvxln
@Time: 2022/2/12 21:55
@Website: hezhilv@126.com
@project: PythonDemo
@FileName: RegexTest.py
@Copyright: ©2019-2022 家灏信息科技有限公司
"""


class RegexTest(object):
    def test_regex_compile(self):
        # compile 函数根据一个模式字符串和可选的标志参数生成一个正则表达式对象Regex。该对象拥有一系列方法用于正则表达式匹配和替换。
        phoneNumRegex = re.compile(r'\d{3}-\d{3}-\d{4}')
        # Regex 对象的search()方法查找传入的字符串，寻找该正则表达式的所有匹配。如果字符串中没有找到该正则表达式模式，
        # search()方法将返回None。如果找到了该模式，search()方法将返回一个Match Object
        mo = phoneNumRegex.search('My number is 415-555-4242.')
        print(mo)   # <re.Match object; span=(13, 25), match='415-555-4242'>
        # Match 对象有一个group()方法，它返回被查找字符串中实际匹配的文本（稍后我会解释分组）
        print('Phone number found: ' + mo.group() )     # Phone number found: 415-555-4242




    def test_regex_group(self):
        # 正则表达式字符串中的第一对括号是第1 组。第二对括号是第2 组。
        phoneNumRegex = re.compile(r'(\d{3})-(\d{3}-\d{4})')
        mo = phoneNumRegex.search('My number is 415-555-4242')
        print(mo)               # <re.Match object; span=(13, 25), match='415-555-4242'>
        # 向group()方法传入0或不传参数，将返回整个匹配的文本
        print(mo.group())       # 415-555-4242
        print(mo.group(0))      # 415-555-4242
        # 向group()匹配对象方法传入整数1或2，就可以取得匹配文本的不同部分。
        print(mo.group(1))      # 415
        print(mo.group(2))      # 555-4242

        # 如果一次想获取所有的分组，请使用groups()方法，请注意函数名的复数形式。
        print(mo.groups())      # ('415', '555-4242')
        areaCode,mainNumber = mo.groups()
        print(areaCode)         # 415
        print(mainNumber)       # 555-4242



if __name__ == '__main__':
    ci = RegexTest()
    # ci.test_regex_one()
    ci.test_regex_group()
