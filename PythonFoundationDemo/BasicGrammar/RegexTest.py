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



    # 分组 : ()
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

    #  管道符匹配多个分组：    |
    def test_regex_pipe(self):
        batRegex = re.compile(r'Bat(man|mobile|copter|bat)')
        mo = batRegex.search('Batmobile lost a wheel, Batbat')
        print(mo.group())       # Batmobile
        print(mo.group(1))      # mobile
        # print(mo.group(2))    # 报错。

    # 问号实现可选匹配（零次或一次）：    ？
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


    # 用星号匹配零次或多次：    *
    def test_regex_zero_or_more(self):
        '''
            字符* 意味着“匹配零次或多次”

        '''
        batRegex = re.compile(r'Bat(wo)*man')
        mo1 = batRegex.search('The Adventures of Batman')
        print(mo1.group())      # Batman
        mo2 = batRegex.search('The Adventures of Batwoman')
        print(mo2.group())      # Batwoman
        mo3 = batRegex.search('The Adventures of Batwowowowoman')
        print(mo3.group())      # Batwowowowoman



    # 用加号匹配一次或多次：    +
    def test_regex_one_or_more(self):
        '''
            字符+ 意味着匹配一次或多次

        '''
        batRegex = re.compile(r'Bat(wo)+man')
        mo1 = batRegex.search('The Adventures of Batman')
        print(mo1==None)  # True
        mo2 = batRegex.search('The Adventures of Batwoman')
        print(mo2.group())  # Batwoman
        mo3 = batRegex.search('The Adventures of Batwowowowoman')
        print(mo3.group())  # Batwowowowoman

    # 用花括号匹配特定的次数：    {}
    def test_regex_definite_number(self):
        '''
            花括号{}   意味着匹配特定的次数。
            1.(ha){3}           : 匹配ha这个字符串三次，既匹配hahaha这个字符串
            2.(ha){0,3}         : 匹配ha这个字符串0次到3次。
            3.(ha){,3}          : 匹配ha这个字符串0次到3次。
            4.(ha){3,}          : 匹配ha这个字符串3次或更多次。
        '''
        batRegex  = re.compile(r'Bat(wo){3,}man')
        mo1 = batRegex.search('The Adventures of Batwowoman')
        print(mo1==None)        # True
        mo2 = batRegex.search('The Adventures of Batwowowoman')
        print(mo2.group())      # Batwowowoman
        mo3 = batRegex.search('The Adventures of Batwowowowowowoman')
        print(mo3.group())      # Batwowowowowowoman



    def test_regex_greedy(self):
        '''
                Python中的正则表达式默认是“贪心”的， 这表示在有二义的情况下，他们会尽可能匹配最长的字符串。
            花括号的“非贪心”版本匹配尽可能短的字符串，即在结束的花括号后跟一个问好。
                请注意，问号在正则表达式中可能有两种含义：申明非贪心匹配或表示可选的分组。这两种含义是完全无关的。
        '''
        # 贪婪匹配，表示在有二意的情况下，尽可以多的匹配最长的字符串。Python中默认是贪婪匹配。
        greedyHaRegex = re.compile(r'(Ha){3,5}')
        mo1 = greedyHaRegex.search('HaHaHaHaHaHa')
        print(mo1.group())      # result: HaHaHaHaHa

        # 非贪婪匹配，匹配尽可能最短的字符串。 格式：  {start,end}?
        nongreedyHaRegex = re.compile(r'(Ha){3,5}?')
        mo2 = nongreedyHaRegex.search('HaHaHaHaHaHa')
        print(mo2.group())      # result:HaHaHa


    def test_regex_findall(self):
        '''
            作为 findall()方法的返回结果的总结，请记住下面两点：
                1．如果调用在一个没有分组的正则表达式上，例如\d\d\d-\d\d\d-\d\d\d\d，方法
            findall()将返回一个匹配字符串的列表，例如['415-555-9999', '212-555-0000']。
                2．如果调用在一个有分组的正则表达式上，例如(\d\d\d)-(\d\d\d)-(\d\d\d\d)，方
            法findall()将返回一个字符串的元组的列表（每个分组对应一个字符串），例如[('415',
            '555', '1122'), ('212', '555', '0000')]。

        '''
        # search()方法返回的Match对象只包含第一次出现的匹配文本
        phoneNumRegex1 = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d')
        mo1 = phoneNumRegex1.search('Cell: 415-555-9999 Work: 212-555-0000')
        print(mo1.group())      # result: 415-555-9999

        # findall()方法将返回一个字符串列表，包含被查询字符串中的所有匹配。
        allResult1 = phoneNumRegex1.findall('Cell: 415-555-9999 Work: 212-555-0000')
        print(type(allResult1))      # result:   <class 'list'>
        print(allResult1)            # result:   ['415-555-9999', '212-555-0000']

        # 如果正则表达式中有分组，那么findall()方法将返回元组的列表。每个元祖表示一个找到的匹配，
        # 其中的项就是正则表达式中每个分组的匹配字符串。
        phoneNumRegex2 = re.compile(r'(\d\d\d)-(\d\d\d)-(\d\d\d\d)')
        allResult2 = phoneNumRegex2.findall('Cell: 415-555-9999 Work: 212-555-0000')
        print(allResult2)       # result: [('415', '555', '9999'), ('212', '555', '0000')]








if __name__ == '__main__':
    ci = RegexTest()
    # ci.test_regex_one()
    # ci.test_regex_group()
    # ci.test_regex_pipe()
    # ci.test_regex_zero_or_one()
    # ci.test_regex_zero_or_more()
    # ci.test_regex_one_or_more()
    # ci.test_regex_definite_number()
    # ci.test_regex_greedy()
    ci.test_regex_findall()