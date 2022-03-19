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
    def get_product_create_dict(title, reviews_num, price_list, transportation):
        product_dict = {
            "title": title,
            "reviews_num": int(reviews_num),
            "max": 0,
            "min": 0,
            "Ship to Me": "Flase",
            "Store Pickup": "Flase",
            "Same Day Delivery": "Flase",
        }
        temp_list = list()
        for text in price_list:
            if "-" in text:
                num = text.find("-")
                num01 = MikCommonKeywords.splits_string_get_text(text[:num-1], "$")
                num02 = MikCommonKeywords.splits_string_get_text(text[num+2:], "$")
                temp_list.append(num01[-1])
                temp_list.append(num02[-1])
            elif "Reg" in text:
                num = MikCommonKeywords.splits_string_get_text(text, "$")
                temp_list.append(num[-1])
            elif "ea" in text or "/" in text or 'per' in text or "pack" in text:
                pass
            else:
                num = MikCommonKeywords.splits_string_get_text(text, "$")
                temp_list.append(num[-1])
        price_list = [float(i) for i in temp_list]
        price_list.sort(reverse=True)
        product_dict["max"] = price_list[0]
        product_dict["min"] = price_list[-1]
        for v in transportation:
            if "Ship to Me" in v:
                product_dict["Ship to Me"] = "True"
            elif "Store Pickup" in v:
                product_dict["Store Pickup"] = "True"
            elif "Same Day Delivery" in v:
                product_dict["Same Day Delivery"] = "True"
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


if __name__ == "__main__":
    cc = MikCommonKeywords()
    a = cc.get_product_create_dict(1, 1, ['$69.00 - $804.00'], [])
    print(a)

