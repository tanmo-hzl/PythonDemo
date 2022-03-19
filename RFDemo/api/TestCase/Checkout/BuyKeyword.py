# import time


class BuyKeyword(object):

    def __init__(self):
        pass

    @staticmethod
    def split_parameter(parameter,split_symbol=" "):
        parameter_list = parameter.split(split_symbol)
        return parameter_list