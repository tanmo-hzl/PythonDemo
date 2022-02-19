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
        mo = phoneNumRegex.search('My number is 415-555-5656.')
        print(mo)   # <re.Match object; span=(13, 25), match='415-555-5656'>
        # Match 对象有一个group()方法，它返回被查找字符串中实际匹配的文本（稍后我会解释分组）
        print('Phone number found: ' + mo.group() )     # Phone number found: 415-555-5656




    def test_regex_group(self):
        # 正则表达式字符串中的第一对括号是第1 组。第二对括号是第2 组。
        phoneNumRegex = re.compile(r'(\d{3})-(\d{3}-\d{4})')
        # search()扫描整个字符串并返回第一个成功的匹配
        mo = phoneNumRegex.search('My number is 415-555-5656')
        print(mo)               # <re.Match object; span=(13, 25), match='415-555-5656'>
        # 向group()方法传入0或不传参数，将返回整个匹配的文本
        print(mo.group())       # 415-555-5656
        print(mo.group(0))      # 415-555-5656
        # 向group()匹配对象方法传入整数1或2，就可以取得匹配文本的不同部分。
        print(mo.group(1))      # 415
        print(mo.group(2))      # 555-5656

        # 如果一次想获取所有的分组，请使用groups()方法，请注意函数名的复数形式。
        print(mo.groups())      # ('415', '555-5656')
        areaCode,mainNumber = mo.groups()
        print(areaCode)         # 415
        print(mainNumber)       # 555-5656


    def test_regex_pipe(self):
        batRegex = re.compile(r'Bat(man|mobile|copter|bat)')
        mo = batRegex.search('Batmobile lost a wheel, Batbat')
        print(mo.group())       # Batmobile
        print(mo.group(1))      # mobile
        # print(mo.group(2))    # 报错。


    def test_regex_zero_or_one(self):
        '''
            字符？表明它前面的分组在这个模式中是可选的。表示匹配这个问号之前的分组零次或一次。
            正则表达式中的(wo)?部分表明，模式wo是可选的分组。该正则表达式匹配的文本中，wo将出现零次或一次。
            这就是为什么这个正则表达式既匹配'Batwoman'，又匹配’Batman‘
        '''
        batRegex = re.compile(r'Bat(wo)?man')
        mo1 = batRegex.search('The adventures of Batman')
        print(mo1.group())      # Batman
        mo2 = batRegex.search('The Adventures of Batwoman')
        print(mo2.group())      # Batwoman

        phoneRegex = re.compile(r'(\d\d\d-)?\d\d\d-\d\d\d\d')
        mo3 = phoneRegex.search('My number is 415-555-5656')
        print(mo3.group())      # 415-555-5656
        mo4 = phoneRegex.search('My number is 555-5656')
        print(mo4.group())      # 555-5656



    def test_regex_zero_or_more(self):
        '''
            字符* 意味着“匹配零次或多次”

        '''
        pass



    def test_regex_one_or_more(self):
        '''
            字符+ 意味着匹配一次或多次

        '''
        pass



if __name__ == '__main__':
    ci = RegexTest()
    # ci.test_regex_one()
    # ci.test_regex_group()
    # ci.test_regex_pipe()
    ci.test_regex_zero_or_one()
