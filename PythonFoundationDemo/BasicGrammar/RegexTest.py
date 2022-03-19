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
        greedyHaRegex1 = re.compile(r'(Ha){3,5}')
        mo1 = greedyHaRegex1.search('HaHaHaHaHaHa')
        print(mo1.group())      # result: HaHaHaHaHa

        # 非贪婪匹配，匹配尽可能最短的字符串。 格式：  {start,end}?
        nongreedyHaRegex1 = re.compile(r'(Ha){3,5}?')
        mo2 = nongreedyHaRegex1.search('HaHaHaHaHaHa')
        print(mo2.group())      # result: HaHaHa

        nongreedyRegex2 = re.compile(r'<.*?>')
        mo3 = nongreedyRegex2.search('<To serve man> for dinner.>')
        print(mo3.group())      # result: <To serve man>

        greedyRegex2 = re.compile(r'<.*>')
        mo4 = greedyRegex2.search('<To serve man> for dinner.>')
        print(mo4.group())      # result: <To serve man> for dinner.>




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



    def test_regex_dotall(self):
        '''
            点-星将匹配除换行外的所有字符。通过传入re.DOTALL 作为re.compile()的第
        二个参数，可以让句点字符匹配所有字符，包括换行字符
        '''
        noNewlineRegex = re.compile('.*')
        mo1 = noNewlineRegex.search('Serve the public trust.\nProtect the innocent.\nUphold the law.')
        print(mo1.group())      # result: Serve the public trust.

        newLineRegex = re.compile('.*',re.DOTALL)
        mo2 = newLineRegex.search('Serve the public trust.\nProtect the innocent.\nUphold the law.')
        print(mo2.group())      # result:  'Serve the public trust.\nProtect the innocent.\nUphold the law.'
        ''' 
            正则表达式noNewlineRegex 在创建时没有向re.compile()传入re.DOTALL，它
        将匹配所有字符，直到第一个换行字符。但是，newlineRegex 在创建时向re.compile()传
        入了re.DOTALL，它将匹配所有字符。这就是为什么newlineRegex.search()调用匹配完
        整的字符串，包括其中的换行字符。
        '''



    def test_regex_ignorecase(self):
        '''
        有时候我们只关心匹配字母，不关心他们是大写或是小写。要让正则表达式不区分大小写。
        可以向re.compile()中传入re.IGNORECASE或re.I,作为第二个参数。
        '''
        robocop = re.compile(r'robocop',re.IGNORECASE)
        mo1 = robocop.search('RoboCop is part man, part machine, all cop.')
        print(mo1.group())      # result: RoboCop

        mo2 = robocop.search('ROBOCOP protects the innocent')
        print(mo2.group())      # result:  ROBOCOP

        mo3 = robocop.search('Al, why does your programming book talk about robocop so much?')
        print(mo3.group())      # result:  robocop



    def test_regex_sub(self):
        '''
        Regex对象的 sub()方法需要传入两个参数。第一个参数是一个字符串， 用于取代发现的匹
        配。第二个参数是一个字符串，即需要陪匹配的字符串。 sub()方法返回替换完成后的字符串。
        '''
        namesRegex = re.compile(r'Agent \w+')
        resultString = namesRegex.sub('CENSORED','Agent Alice gave the secret documents to Agent Bob.')
        print(resultString)     # result: CENSORED gave the secret documents to CENSORED.

        '''
        有时候，你可能需要使用匹配的文本本身，作为替换的一部分。在 sub()的第一
        个参数中，可以输入\1、 \2、 \3……。表示“在替换中输入分组 1、 2、 3……的文本”。
        例如，假定想要隐去密探的姓名，只显示他们姓名的第一个字母。要做到这一
        点，可以使用正则表达式 Agent (\w)\w*，传入 r'\1****'作为 sub()的第一个参数。字
        符串中的\1 将由分组 1 匹配的文本所替代，也就是正则表达式的(\w)分组
        '''
        agentNamesRegex = re.compile(r'Agent (\w)\w*')
        agentResultString = agentNamesRegex.sub(r'\1****', 'Agent Alice told Agent Carol that Agent Eve knew Agent Bob was a double agent.')
        print(agentResultString)    # result: A**** told C**** that E**** knew B**** was a double agent.


    def test_manage_complex_regex(self):
        '''
        如果要匹配的文本模式很简单，正则表达式就很好。但匹配复杂的文本模式，
        可能需要长的、费解的正则表达式。你可以告诉 re.compile()， 忽略正则表达式字符
        串中的空白符和注释， 从而缓解这一点。 要实现这种详细模式， 可以向 re.compile()
        传入变量 re.VERBOSE， 作为第二个参数
        '''
        phoneRegex = re.compile(r'((\d{3}|\(\d{3}\))?(\s|-|\.)?\d{3}(\s|-|\.)\d{4}(\s*(ext|x|ext.)\s*\d{2,5})?)')
        phoneRegexComment = re.compile(r'''(
                            (\d{3}|\(\d{3}\))?                  # area code
                            (\s|-|\.)?                          # separator
                            \d{3}                               # first 3 digits
                            (\s|-|\.)                           # separator
                            \d{4}                               # last 4 digits
                            (\s*(ext|x|ext.)\s*\d{2,5})?        # extension
                            )''', re.VERBOSE)


        '''
            如果你希望在正则表达式中使用 re.VERBOSE 来编写注释，还希望使用
        re.IGNORECASE 来忽略大小写，该怎么办？遗憾的是， re.compile()函数只接受一
        个值作为它的第二参数。可以使用管道字符（|）将变量组合起来，从而绕过这个限
        制。管道字符在这里称为“按位或”操作符。
            所以，如果希望正则表达式不区分大小写，并且句点字符匹配换行，就可以这
        样构造 re.compile()调用
        '''
        someRegexValue1 = re.compile('foo', re.IGNORECASE | re.DOTALL)
        # 使用第二个参数的全部 3 个选项， 看起来像这样：
        someRegexValue2 = re.compile('foo', re.IGNORECASE | re.DOTALL | re.VERBOSE)



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
    # ci.test_regex_findall()
    # ci.test_regex_dotall()
    # ci.test_regex_ignorecase()
    ci.test_regex_sub()
