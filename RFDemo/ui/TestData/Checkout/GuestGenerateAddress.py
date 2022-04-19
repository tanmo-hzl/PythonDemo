import json
import random
import re
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import productInfo
# from browsermobproxy import Server
from itertools import permutations
import zipCodeInfo

mkr_combination = ["MKR", "MKRS", "MKR CLASS", "MKRS CLASS"]
pis_combination = ["PIS", "PISM"]


def random_getting_zipcode(count):
    if int(count) < len(zipCodeInfo.zip_code_list) // 2:
        zip_list = random.sample(zipCodeInfo.zip_code_list, int(count))
    else:
        zip_list = random.sample(zipCodeInfo.zip_code_list, 4)
    return zip_list


def create_profile():
    fp = webdriver.FirefoxProfile()

    fp.set_preference("dom.webnotifications.enabled", False)
    fp.set_preference("geo.enabled", False)
    fp.set_preference("geo.provider.use_corelocation", False)
    fp.set_preference("geo.prompt.testing", False)
    fp.set_preference("geo.prompt.testing.allow", False)
    fp.set_preference('browser.dom.window.dump.enabled', True)
    fp.set_preference('devtools.console.stdout.content', True)
    fp.update_preferences()
    return fp.path


def desired_capabilities_setting():
    cap = DesiredCapabilities.FIREFOX
    # server = Server("/Users/fengmiao/PycharmProjects/UI_Smoke/Data/browsermob-proxy-2.1.4/bin/browsermob-proxy")
    # server.start()
    # proxy = server.create_proxy()
    # proxy_firefox = proxy.proxy
    cap['loggingPrefs'] = {'browser': 'ALL'}
    cap['marionette'] = True
    # cap['proxy'] = {
    #     "proxyType": "MANUAL",
    #     "httpProxy": proxy_firefox,
    #     "ftpProxy": proxy_firefox,
    #     "sslProxy": proxy_firefox
    # }
    # proxy.new_har("check")
    return cap


# def har_log(proxy, server):
#     result = proxy.har.get('log')
#     with open("data.json", "w") as f:
#         json.dump(result, f, ensure_ascii=False, indent=4)
#     server.stop()
#     return result


def console_log(driver):
    console_list = []
    for entry in driver.get_log('browser'):
        console_list.append(entry)
    return console_list


def get_product_list(channel, category, env):
    product_list = ["Empty Products"]
    if channel == "PISM":
        product_list = random.sample(productInfo.test_data[env]['PIS'], 1)
    elif category <= len(productInfo.test_data[env][channel]):
        product_list = random.sample(productInfo.test_data[env][channel], category)
    return product_list


def items_channel_dictionary_creation(channel, category, env):
    channel = channel.upper()
    if "|" not in channel:
        items = get_product_list(channel, int(category), env)
    else:
        items, channel_list = mixed_list(channel, category, env)

    return dict(zip(items, channel_list)) if "|" in channel else dict(
        zip(items, [channel for _ in range(int(category))]))


def mixed_list(channel, category, env):
    mode_list = channel.split("|")
    category_list = category.split("|")
    mixed_lists = []
    channel_exp_lists = []

    if len(mode_list) != len(category_list):
        return "The mode does not match the list, please reassign."

    for i in range(len(mode_list)):
        if int(category_list[i]) == 0:
            continue
        if mode_list[i] == "PISM":
            category_list[i] = 1
        for _ in range(int(category_list[i])):
            channel_exp_lists.append(mode_list[i])
        mixed_lists += get_product_list(mode_list[i], int(category_list[i]), env)

    return mixed_lists, channel_exp_lists


def split_skus_from_partial_url(sku_dict):
    sku_list = []
    partial_urls = []
    for key in sku_dict.keys():
        partial_urls.append(key)
        sku_list.append(key.split("-")[-1])
    return sku_list, partial_urls


def qty_process(qty_list):
    if "|" in qty_list:
        qty_processed = qty_list.split("|")
        qty_processed.reverse()
        return qty_processed
    else:
        return [qty_list]


def if_class(products):
    if products.startswith('class'):
        return 'Class'
    if products.startswith('fgm/class'):
        return 'Class'
    return 'Product'


def pis_only_verify(channel):
    if channel in permutation_with_channel(pis_combination):
        return 'PIS Only'
    elif "PISM" in channel or "PIS|PISM" in channel or "PISM|PIS" in channel:
        return 'PISM Existed'
    else:
        return 'Not PIS Only'


def mkr_only_verify(channel):
    mkr_permute_list = permutation_with_channel(mkr_combination)
    if channel in mkr_permute_list:
        return 'MKR Only'
    else:
        return 'Not MKR Only'


def sdd_detect(channel):
    if "SDD" in channel:
        return "YES"
    else:
        return "NO"


def permutation_with_channel(channel_list):
    permutation_channel_list = []
    for i in range(len(channel_list)):
        for result in permutations(channel_list, i + 1):
            if i == 0:
                permutation_channel_list.append(str(result[0]))
            else:
                permutation_channel_list.append("|".join(result))
    return permutation_channel_list


def if_mik_exist(channel):
    if "MIK" in channel:
        return "YES"
    else:
        return "NO"


mkr_channel = "MKRS|MKRS CLASsS"
non_mkr = "MKR|MKP"


def mik_ship_major_mode(channel):
    if channel == "PIS" or channel == "PISM":
        return "Pick-Up — FREE"
    elif channel == "SDD" or channel == "SDDH":
        return "Same Day Delivery"
    elif channel in ["MKR", "MKP", "MKRS", "MKPS", "MIK"]:
        return "Ship to Me"
    else:
        return "Incorrect Mode"


def order_summary_page_process(lists):
    results = []
    for list in lists:
        if list.text.upper() in ["TBD", "FREE", "CHANGE"]:
            continue
        else:
            results.append(float(list.text.replace("$", "")))
    return "%.2f" % sum(results), "%.2f" % results[0]


def adjust_to_two_digit_data_type(*sources):
    if len(sources) > 1:
        return tuple("%.2f" % source for source in sources)
    else:
        return "%.2f" % sources


def cart_subtotals_process(rough_lists):
    filtered_list = []
    for list in rough_lists:
        if "$" in list.text and "away from Free" not in list.text:
            filtered_list.append(list.text)

    for i in range(len(filtered_list)):
        filtered_list[i] = float(filtered_list[i].replace("$", ""))
    cart_results = sum(filtered_list)
    return "%.2f" % cart_results


def web_sku_process(rough_lists):
    web_skus = []
    for list in rough_lists:
        if list.text[5:] in web_skus:
            continue
        web_skus.append(list.text[5:].strip())  # .replace("item: ", "")
    return web_skus


def extract_shipping_info(elements):
    extract_lists = []
    for element in elements:
        extract_firstLine = element.text.splitlines()[0]
        extract_lists.append(extract_firstLine)
    return extract_lists


def extract_store_name_from_web(combined_texts):
    result_set = []
    for name in combined_texts.splitlines():
        result_set.append(name)
    return result_set


def PISM_list(pism, store_amount):
    return [pism for _ in range(int(store_amount))]


def get_list_value(parameter):
    parameter_list = parameter[0:-1]
    return parameter_list


def rearrange_lists(list_one, list_two):
    list_one = list(dict.fromkeys(list_one))
    list_two = list(dict.fromkeys(list_two))
    return sorted(list_one), sorted(list_two)


def remove_javascript(hrefs):
    list = []
    for i in range(len(hrefs)):
        if hrefs[i].startswith("java") or hrefs[i].startswith("https://sandbox"):
            continue
        if hrefs[i].split(".com/")[1] in list:
            continue
        list.append(hrefs[i].split(".com/")[1])
    return list


def remove_simple_ship_to_me(lists):
    updated_list = []
    for ship_method in lists:
        if ship_method == 'Ship To Me' or ship_method == 'Ship to Me':
            continue
        updated_list.append(ship_method)
    return updated_list


def items_verify(subtotal, side_subtotal):
    try:
        subtotal_number = int(re.findall('[0-9]+', subtotal)[0])
    except IndexError:
        subtotal_number = 0
    side_items_sum = 0
    for side in side_subtotal:
        try:
            side_number = int(re.findall('[0-9]+', side)[0])
        except IndexError:
            side_number = 0
        side_items_sum += side_number

    return subtotal_number, side_items_sum


def number_extracted(rough_number):
    extracted_number = re.findall('[0-9]+', rough_number)
    order_number = "".join(extracted_number)
    if order_number == "":
        order_number = 0
    return order_number


def pick_up_detection(channel):
    channel = channel.split("|")
    if "PIS" in channel and "PISM" in channel:
        return "Combined"
    elif "PIS" in channel:
        return "PIS"
    elif "PISM" in channel:
        return "PISM"
    else:
        return "Non Pick Up"


def mik_channel_check(channel):
    if channel in ["MIK", "PIS", "PISM", "SDD", "SDDH", "MIK CLASS"]:
        return "MICHAELS"
    else:
        return "Not Michaels"


def store_name_extract(store_address_lists):
    store_extract = []
    address_extract = []
    for store in store_address_lists:
        if "—" in store:
            store_extract.append(store.split("—")[0].strip())
        else:
            address_extract.append(store)
    return store_extract, address_extract


def remove_last_four_zipcode_digit(address_lists):
    refined_list = []
    for address in address_lists:
        refined_list.append(address.split("-")[0])
    return refined_list


def adjust_shipping_letter(adjust_list):
    result_set = []
    for adjust in adjust_list:
        result_set.append(adjust.upper())
    return result_set


def remove_dash_from_shipping_text(texts):
    refined_list = []
    for text in texts:
        text = re.findall("[A-Za-z0-9$.]", text)
        res = "".join(text)
        refined_list.append(res)
    return refined_list


def join_address(*address_params):
    address = " ".join(address_params)
    return address


def convert_store_address_to_regular_space(raw_address):
    if isinstance(raw_address, list):
        step_one = "".join(raw_address[0].splitlines())
    elif isinstance(raw_address, str):
        step_one = "".join(raw_address.splitlines())
    else:
        step_one = "Not, Set"
    step_two = step_one.replace(",", " ")
    converted_address = " ".join(step_two.split())
    return converted_address


def store_panel_stock_handle(stock_element, qty):
    try:
        if stock_element.split(" ")[0] == "999+" or stock_element.split(" ")[0] == "99+":
            return True
        elif int(stock_element.split(" ")[0]) >= int(qty):
            return True
        else:
            return False
    except ValueError:
        return False


def append_element_to_list(original, *elements):
    if isinstance(original, list):
        for element in elements:
            original.append(element)
        return original
    else:
        return "Incorrect Data Type"


def extract_cart_fee_and_check_str(elements, check_str):
    for element in elements:
        element_text = element.text
        if element_text.find(check_str) >= 0:
            return True
    return False


def select_store_process(channel_mode):
    store_channels = ["SDD", "SDDH", "PIS", "PISM"]
    for channel in store_channels:
        if channel in channel_mode:
            return True
    return False


def calculate_items_count(items):
    if "|" in items:
        return sum([int(item) for item in items.split("|")])
    else:
        return int(items)


def cart_promo_display(text):
    if text.lower() in ['sale', 'clearance', 'doorbuster']:
        return 'YES'
    else:
        return 'NO'


def extract_last_text(string):
    res = string.split(" ")[-1]
    return res


def get_stats_from_order_summary(param):
    if param.upper() == 'ADD A PROMO CODE':
        return "Promo Code", "0"
    else:
        return param.splitlines()[0], param.splitlines()[1].replace("$", "")

# a = remove_javascript([
#     'https://mik.qa.platform.michaels.com/product/3-pack-silver-fundamentals-8-x-8-display-case-by-studio-dcor-10641514',
#     'https://mik.qa.platform.michaels.com/fgm/product/uifree-shipping-one-8-6041083673213394944',
#     'https://mik.qa.platform.michaels.com/fgm/product/uifree-shipping-one-8-6041083673213394944',
#     'javascript:void(0)',
#     'https://sandbox.affirm.com/shop/michaels'])
# print(a)
# print(pism_list("PISM", 3))
# print(mixed_list("PISM|MKR", "2|2"))
# a_list = ["$3.99", "$-3.99", "-$3.99"]
# b = []
# for a in a_list:
#     b.append(float(a.replace("$", "")))
# print(sum(b))
# b = items_list("MKR Class", "1")
# print(b)
# c = url_to_sku_list(b)
# print (c)
# a = 29.0000000002
# print("%.2f" % a)
# b = "Epic West Towne Crossing\nLincoln Square\nMacArthur Park"
#
# print(extract_store_name_from_web(b))
