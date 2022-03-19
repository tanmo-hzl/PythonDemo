import random
import string


def seller_email():
    SellerAccount = ""
    num = string.ascii_letters+string.digits
    for i in range(6):
        SellerAccount += random.choice(num)
    return SellerAccount


def store_name():
    StoreName = ""
    for i in range(8):
        StoreName += random.choice(string.ascii_letters)
    return StoreName


def seller_pwd():
    Password = ""
    for i in range(10):
        Password += random.choice(string.hexdigits)
    return Password