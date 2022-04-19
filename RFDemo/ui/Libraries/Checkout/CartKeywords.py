import re


class CartKeywords:
    def __init__(self):
        pass

    @staticmethod
    def text_contains_special_symbols(text: str, xpath: str):
        if '"' in text:
            return f"{xpath}[text()='{text}']"
        else:
            return f"""{xpath}[text()="{text}"]"""

    @staticmethod
    def text_split_max_length(text: str):
        text_list = text.split('''"''')
        max_length = 0
        index = -1
        for text_var in text_list:
            sub_text_length = len(text_var)
            if max_length < sub_text_length:
                max_length = sub_text_length
                index = text_list.index(text_var)

        return text_list[index]

    @staticmethod
    def get_order_summary_data_fun(data: dict):
        data1 = data.copy()
        print(data)

        for key, value in data1.items():
            if "Subtotal" in key:
                print(key, value)
                item_count = re.match("\w* \((\d*) \w*\)", key).group(1)
                # print(re.search("\d*", key).group())
                value = re.match("\$([\d.]*)", value).group(1)
                data.update({"item_count": int(item_count), "Subtotal": float(value)})
                data.pop(key)
            elif "$" in value:
                print(key, value)
                value = re.match("\$([\d.]*)", value).group(1)
                data.update({key: float(value)})
            elif "$" in key:
                data.pop(key)

        return data


# print(
#     CartKeywords.get_order_summary_data_fun(
#         {"Subtotal (42 items)": "$253.91", "Estimated Tax": "TBD"}
#     )
# )
