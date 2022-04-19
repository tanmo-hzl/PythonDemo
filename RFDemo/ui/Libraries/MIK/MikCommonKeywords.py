class MikCommonKeywords(object):
    def __init__(self):
        pass

    @staticmethod
    def split_str_get_num(text):
        temp_list = str(text).strip(" Michaels products")
        temp_str = temp_list
        if temp_str.find(",") != -1:
            num = temp_str.replace(",", "")
        else:
            num = temp_str
        return num

    @staticmethod
    def get_product_create_dict(title, reviews_num, price_list):
        product_dict = {
            "title": title,
            "reviews_num": int(reviews_num),
            "max": 0,
            "min": 0,
        }
        temp_list = list()
        for text in price_list:
            if "e" in text or "/" in text or 'p' in text:
                pass
            elif "-" in text:
                num = text.find("-")
                num01 = MikCommonKeywords.splits_string_get_text(text[:num-1], "$")
                num02 = MikCommonKeywords.splits_string_get_text(text[num+2:], "$")
                temp_list.append(num01[-1])
                temp_list.append(num02[-1])
            elif "Reg" in text:
                num = MikCommonKeywords.splits_string_get_text(text, "$")
                temp_list.append(num[-1])
            else:
                num = MikCommonKeywords.splits_string_get_text(text, "$")
                temp_list.append(num[-1])
        price_list = [float(i) for i in temp_list]
        price_list.sort(reverse=True)
        product_dict["max"] = price_list[0]
        product_dict["min"] = price_list[-1]
        return product_dict

    @staticmethod
    def splits_string_get_text(text, point):
        num = text.find(point)
        if num != -1:
            text01 = text[:num]
            text02 = text[num + 1:]
            return [text01, text02]
        else:
            return list(text)

    @staticmethod
    def get_pdp_reviews(text):
        num = text.find('(')
        if num != -1:
            text01 = text[1:-1]
            return text01
        return text

    @staticmethod
    def verify_product_sort(product_list, sort_name, reverse):
        product_list.sort(key=lambda x: x[sort_name], reverse=bool(reverse))
        return product_list

    @staticmethod
    def Package_PLP_Transportation(*args):
        temp_dict = {
            "Store Pickup": False,
            "Ship to Me": False,
            "Same Day Delivery": False,
            "inventory": False,
            "Store Name": False,
            "FREE Over": False,
            "default": False,
            "version": False,
        }
        for i in args[0]:
            if "Unavailable" not in i:
                if "Store Pickup" in i:
                    temp_dict["Store Pickup"] = True
                    if "In" in i:
                        num01 = i.find('-')
                        num02 = i.find('In')
                        if num02-num01 > 2:
                            temp_dict["inventory"] = i[num01+2: num02-1]
                        num03 = i.find('at')
                        temp_dict["Store Name"] = i[num03+3:]
                elif "Ship to Me" in i:
                    temp_dict["Ship to Me"] = True
                    if "Free" in i:
                        temp_dict["FREE Over"] = (MikCommonKeywords().splits_string_get_text(i, '$'))[-1]
                elif "Same Day Delivery" in i:
                    temp_dict["Same Day Delivery"] = True
        for k, v in temp_dict.items():
            if v:
                temp_dict["default"] = k
                break
        if args[1] != [] or args[2] != []:
            temp_dict["version"] = True
            if temp_dict["inventory"]:
                raise Exception('商品有变体，Store Pickup尾巴带有库存')
        return temp_dict

    @staticmethod
    def Package_PDP_Transportation(temp_list):
        temp_dict = {
            "Store Pickup": False,
            "Ship to Me": False,
            "Same Day Delivery": False,
            "inventory": False,
            "Store Name": False,
            "FREE Over": False,
            "default": False,
        }
        for i in temp_list:
            for v in i:
                if v == 'Store Pickup':
                    temp_dict["Store Pickup"] = True
                elif "Ship to Me" in v:
                    temp_dict["Ship to Me"] = True
                    if "FREE Over" in v:
                        temp_dict["FREE Over"] = (MikCommonKeywords().splits_string_get_text(i[0], '$'))[-1]
                elif "at" in v:
                    num01 = v.find('at')
                    num04 = v.find('|')
                    temp_dict["Store Name"] = v[num01 + 3: num04-1]
                elif "In Stock" in v:
                    num02 = v.find('In')
                    temp_dict["inventory"] = v[: num02-1]
                elif "Same Day Delivery" in v:
                    temp_dict["Same Day Delivery"] = True
                elif "default" in v:
                    num03 = v.find('-')
                    temp_dict["default"] = v[num03+1:]
                elif "Out of Stock" in v:
                    temp_dict["Store Name"] = False
                    temp_dict["inventory"] = False
        return temp_dict

    @staticmethod
    def Verify_PDP_PLP_Transportation(PLP_info, PDP_info):
        for num in range(len(PLP_info)):
            for i in PDP_info[num]:
                if PLP_info[num][i] != PDP_info[num][i]:
                    print(PLP_info[num])
                    print(PDP_info[num])
                    raise 'The PDP and PLP pages are inconsistent'

    @staticmethod
    def Verify_List_identical(list01, list02):
        for i, v in zip(list01, list02):
            for text01, text02 in zip(i, v):
                if text01 != text02:
                    print(text01)
                    print(text02)
                    raise 'Two sides are not equal'


if __name__ == "__main__":
    cc = MikCommonKeywords()
    a = cc.Package_PLP_Transportation(['Store Pickup  - In Stock at MacArthur Park', 'Ship to Me - Free Over $49', 'Same Day Delivery'], [], [])
    b = cc.Package_PDP_Transportation([['Get it Tomorrow at Vista Ridge Shopping Center | Aisle S63'], ['4 In Stock', 'Out of Stock '], ['default-Store Pickup'], ['Store Pickup'], [['Ship to Me — FREE Over $49']], [[]]])
    # cc.Verify_PDP_PLP_Transportation([a], [b])
    # print(b)
    print(a)

