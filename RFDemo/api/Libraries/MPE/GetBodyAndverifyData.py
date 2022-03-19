import datetime
import json
import os
import random
import string

import requests
import yaml


def get_apply_body(case_name: str, case_yaml: str = "./CaseData/MPE/case_data.yaml"):
    order_number = "ORDER" + str(random.randint(1, 999999))
    with open("./TestData/MPE/apply_coupon.json", "rb") as f:
        apply_body = json.load(f)

    with open(case_yaml, "rb") as f:
        case_data = yaml.load(f, yaml.FullLoader)
        order_info: dict = case_data[case_name]
        # print(case_data)
    if order_info.get("expect"):
        order_info.pop("expect")
    apply_body.update(
        {
            "orderNumber": order_number,
            "codes": order_info.get("codes") if order_info.get("codes") else "",
            "buyer": order_info.get("buyer")
            if order_info.get("buyer")
            else {"id": "555"},
            "preview": order_info.get("preview") if order_info.get("preview") else True,
        }
    )

    sub_order = apply_body["subOrder"][0]
    apply_body["subOrder"] = []
    # print(apply_body)

    # for number in range(len(case_data[case_name])):
    for order, i in zip(order_info["order"], range(len(order_info["order"]))):
        sub_order.update({"orderNumber": order_number + "-" + str(i)})
        apply_body["subOrder"].append(sub_order.copy())
        # print(order)
        for k, item in order.items():
            if k != "item":
                apply_body["subOrder"][i][k] = item
            else:

                item1 = apply_body["subOrder"][i]["item"][0]
                # if len(apply_body["subOrder"][i]["item"]) != len(item):

                apply_body["subOrder"][i]["item"] = []
                for number in range(len(item)):
                    item2 = item1.copy()
                    apply_body["subOrder"][i]["item"].append(item2)
                    for j, v in item[number].items():
                        item2[j] = v
                    item2["amount"] = float(item2["piece"]) * float(item2["price"])
                    print(number, item1)
                    apply_body["subOrder"][i]["item"][number].update(item2)
                print(apply_body["subOrder"][i]["item"])

    return apply_body


def get_item_list(base_str: str = "yx000", count: int = 100, start_str: int = 1):
    item_list = [
        {"type": "Item sku", "value": base_str + str(i)}
        for i in range(start_str, count)
    ]
    return item_list


def get_random_code():
    random_code = ""
    for i in range(8):
        if i % 2 == 1:
            random_code += random.choice(string.ascii_letters)
        else:
            random_code += str(random.randint(0, 9))
    return random_code


def case_name_split_promotion(case_name: str, split_str: str = "and"):
    return case_name.split(split_str)


def get_add_promotion_body_list(
    promotion_name,
    yaml_file="./CaseData/MPE/add_promotion.yaml",
    json_file="./TestData/MPE/add_promotion.json",
    is_expect_promotion_name: bool = False,
):
    promotion_list = case_name_split_promotion(promotion_name)
    with open(json_file, "rb") as f:
        promotion_body = json.load(f)
    with open(yaml_file, "rb") as f:
        promotion_data = yaml.load(f, yaml.FullLoader)
    for promotion in promotion_list:
        random_code = get_random_code()
    # order_number = "ORDER" + str(random.randint(1, 999999))
    # with open(json_file, "rb") as f:
    #     promotion_body = json.load(f)
    #
    # with open(yaml_file, "rb") as f:
    #     promotion_data = yaml.load(f, yaml.FullLoader)
    promotion_info = promotion_data[promotion_name]

    promotion_body.update(promotion_info)
    promotion_body.update({"code": random_code})
    if is_expect_promotion_name:
        promotion_name

    return promotion_body


def get_add_promotion_body(
    promotion_name,
    yaml_file="./CaseData/MPE/add_promotion.yaml",
    json_file="./TestData/MPE/add_promotion.json",
    is_expect_promotion_name: bool = False,
):
    random_code = get_random_code()
    # order_number = "ORDER" + str(random.randint(1, 999999))
    with open(json_file, "rb") as f:
        promotion_body = json.load(f)

    with open(yaml_file, "rb") as f:
        promotion_data = yaml.load(f, yaml.FullLoader)
        promotion_info = promotion_data[promotion_name]

    promotion_body.update(promotion_info)
    promotion_body.update({"code": random_code})
    if is_expect_promotion_name:
        promotion_name

    return promotion_body


def get_yaml_data(field: str, file_name: str):
    with open(file_name, "rb") as f:
        yaml_data = yaml.load(f, yaml.FullLoader)
        return yaml_data[field]["expect"]


def str_sum(a, b=0, c="+"):
    if c == "+":
        return round(float(a) + float(b), 2)
    elif c == "-":
        return round(float(a) - float(b), 2)
    else:

        return None


def error_log(str_log):
    raise Exception(str_log)


def verify_item_prices(item_list):
    bundle_item = []
    for item in item_list:
        print(item["sku"])

        if item.get("itemPrices") is not None:
            # if len(item["itemPrices"]) == 1:
            item_count_price = 0
            item_count_display_price = 0
            for price in item["itemPrices"]:

                item_price = round((price["piece"] * float(price["returnPrice"])), 2)
                item_count_price += item_price

                item_display_price = round(
                    (price["piece"] * float(price["displayPrice"])), 2
                )
                item_count_display_price += item_display_price
                # print(item_count_display_price,item_display_price)
            if float(item["adjustedAmount"]) == round(item_count_price, 2):
                print(
                    item["sku"],
                    item["itemPrices"][0]["piece"],
                    item_count_price,
                    item["adjustedAmount"],
                )
                # raise Exception(
                #     f"sku:{item['sku']}-itemPrices:{item_price} != {item['adjustedAmount']}"
                # )
            else:
                bundle_item.append(item)
            if float(item["adjustedAmount"]) != round(item_count_display_price, 2):
                raise Exception(
                    f"sku:{item['sku']}-displayPrice:{item_count_display_price} != {item['adjustedAmount']}"
                )
    return bundle_item


def verify_item_count_prices(item_list):
    item_count_price = 0
    adjusted_amount = 0
    for item in item_list:
        if item.get("itemPrices") is not None:
            # if len(item["itemPrices"]) == 1:
            adjusted_amount = round(adjusted_amount + float(item["adjustedAmount"]), 2)
            for price in item["itemPrices"]:
                item_price = round((price["piece"] * float(price["returnPrice"])), 2)
                item_count_price = round(item_count_price + item_price, 2)
    if adjusted_amount == item_count_price:
        print(item_count_price, adjusted_amount)

    else:
        raise Exception(
            f"item_count_price:{item_count_price} != count_adjusted_amount:{adjusted_amount}"
        )


def save_two_api_json(
    case_name: str, response: requests.Response, file_dir: str = "./json_file"
):
    if isinstance(response.request.body, bytes):
        body = json.loads(response.request.body)
    api_name = response.url.split("/")[-2] + "-" + response.url.split("/")[-1]
    data1 = str(datetime.datetime.now()).split(":")[0].replace(" ", "-")
    if not os.path.exists(file_dir):
        os.mkdir(file_dir)
    if not os.path.exists(f"{file_dir}/{data1}"):
        os.mkdir(f"{file_dir}/{data1}")
    if not os.path.exists(f"{file_dir}/{data1}/{case_name}"):
        os.mkdir(f"{file_dir}/{data1}/{case_name}")
    with open(f"{file_dir}/{data1}/{case_name}/{api_name}-body.json", "w+") as f:
        json.dump(body, f)
    with open(f"{file_dir}/{data1}/{case_name}/{api_name}-response.json", "w+") as f:
        json.dump(response.json(), f)


# def compare_two_response(one_resp:requests.Response,two_resp:requests.Response):
#     # one_resp_json = one_resp.json()
#     # two_resp_json = two_resp.json()
#     result= []
#     if type(one_resp) == type(two_resp):
#         pass
#     def difference_save(one,two,path):
#         if isinstance(one,(list,dict)):
#             pass
#


if __name__ == "__main__":
    print(get_item_list())
    print(case_name_split_promotion("priority_70-benefit_discount_0.5_-1_1and"))
    data = str(datetime.datetime.now()).split(":")[0].replace(" ", "-")
    print(data)
