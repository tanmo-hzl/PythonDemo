def deco(func):
    func.attr = 'decorated'
    return func


@deco
def f(): pass


def require_int(func):
    print('func',func)
    print('locals()',locals())
    def wer(arg,arg2):
        print('arg',arg)
        assert isinstance(arg, int)
        return func(arg,arg2)

    return wer


@require_int
def p1(arg,arg2):
    print(arg,arg2)


@require_int
def p2(arg,arg2):
    print(arg * 2+arg2)


# class DecoratorTest(object):
#
#     pass


if __name__ == '__main__':
    p2(12,22)
