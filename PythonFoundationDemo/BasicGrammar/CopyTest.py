import copy



class CopyTest(object):
    def test_copy_copy_list(self):
        spam = ['A','B','C','D']
        # copy.copy()函数用来复制列表或字典这样的可变值，而不只仅仅复制引用。
        cheese  = copy.copy(spam)
        print(id(spam))         # result: 34727528
        print(id(cheese))       # result: 34727432
        cheese[0] = 12
        print(spam)             # ['A', 'B', 'C', 'D']
        print(cheese)           # [12, 'B', 'C', 'D']


    def test_copy_deepCopy_list(self):
        spam = [[0,1,2,3],'A','B','C','D']
        # 对于列表中包含列表的多元列表，使用copy.deepcopy()函数来复制列表。copy.deepcopy()函数将会同时复制内嵌的列表。
        cheese = copy.deepcopy(spam)
        print(id(spam))         # result: 27977352
        print(id(cheese))       # result: 27977320
        cheese[0][0] = 'a'
        print(spam)             # result: [[0, 1, 2, 3], 'A', 'B', 'C', 'D']
        print(cheese)           # result: [['a', 1, 2, 3], 'A', 'B', 'C', 'D']

        # 对于列表中包含列表的多元列表，当使用copy.copy()函数对列表进行复制时，列表中内嵌的列表传递的是地址的引用
        temp = copy.copy(spam)
        temp[0][0] = 'cccB'
        print(temp)             # result: [['cccB', 1, 2, 3], 'A', 'B', 'C', 'D']
        print(spam)             # result: [['cccB', 1, 2, 3], 'A', 'B', 'C', 'D']
        temp[4] = "MMMMMMMMM"
        print(temp)             # result: [['cccB', 1, 2, 3], 'A', 'B', 'C', 'MMMMMMMMM']
        print(spam)             # result: [['cccB', 1, 2, 3], 'A', 'B', 'C', 'D']




if __name__ == '__main__' :
    copy_test = CopyTest()
    copy_test.test_copy_copy_list()
    copy_test.test_copy_deepCopy_list()