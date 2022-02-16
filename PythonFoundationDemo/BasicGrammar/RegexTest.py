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
        # search()方法将返回None。如果找到了该模式，search()方法将返回一个Match
        mo = phoneNumRegex.search('My number is 415-555-4242.')
        print(mo)   # <re.Match object; span=(13, 25), match='415-555-4242'>
        # Match 对象有一个group()方法，它返回被查找字符串中实际匹配的文本（稍后我会解释分组）
        print('Phone number found: ' + mo.group() )     # Phone number found: 415-555-4242


if __name__ == '__main__':
    ci = RegexTest()
    ci.test_regex_compile()
