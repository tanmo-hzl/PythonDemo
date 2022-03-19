# import time
import datetime


# from pymouse import PyMouse


class BuyerKeywords(object):

    def __init__(self):
        pass

    @staticmethod
    def split_parameter(parameter,split_symbol=" "):
        parameter_list = parameter.split(split_symbol)
        return parameter_list

    @staticmethod
    def get_list_step_value(list,num1:int=None,num2:int=None):
        parameter_list = list[num1:num2]
        return parameter_list

    @staticmethod
    def upper_parameter(parameter):
        parameter = parameter.upper()
        return parameter

    @staticmethod
    def lower_parameter(parameter):
        parameter = parameter.lower()
        return parameter

    @staticmethod
    def strip_parameter(parameter):
        parameter = parameter.strip()
        return parameter

    @staticmethod
    def capitalize_parameter(parameter):
        parameter = parameter.capitalize()
        return parameter


    @staticmethod
    def list_reverse_order(list):
        list = list[::-1]
        return list

    @staticmethod
    def get_now_time():
        time = datetime.datetime.now().timetuple()
        now_time = str(time.tm_mon) + '/' + str(time.tm_mday) + '/' + str(time.tm_year)
        return now_time
    # @staticmethod
    # def Click_middle_screen():
    #     m = PyMouse()
    #     time.sleep(1)
    #     x_dim, y_dim = m.screen_size()
    #     c_x = x_dim // 2
    #     c_y = y_dim // 2
    #     m.move(c_x, c_y)
    #     m.click(c_x, c_y, 1)

    @staticmethod
    def get_class_guest_info(guest_number=4):
        first_name = ['One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve',
                      'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen', 'Twenty']
        email = 'buyertst{}@snapmail.cc'
        phone = '989796{}'
        guest_data = []
        for i in range(guest_number):
            if i < 20:
                firstName = "Guest {}".format(first_name[i])
            else:
                name_len = len(first_name)
                firstName = "Guest {} {}".format(first_name[i // name_len], first_name[i % name_len])
            guest = {
                "firstName": firstName,
                "lastName": "Auto",
                "email": email.format(str(i+1).zfill(3)),
                "phone": phone.format(str(i+1).zfill(4))
            }
            guest_data.append(guest)
        return guest_data

    # @staticmethod
    # def find_element1(locator,parent_ele):
    #     sl = BuiltIn().get_library_instance("Selenium2Library")
    #     ele = parent_ele.sl.find_element_by_xpath(locator)
    #     return ele

