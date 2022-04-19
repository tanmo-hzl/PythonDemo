import random, string


def seller_email():
    SellerAccount = ""
    num = string.ascii_letters+string.digits
    for i in range(4):
        SellerAccount += random.choice(num)
    return SellerAccount


def seller_pwd():
    Password = ""
    for i in range(10):
        Password += random.choice(string.hexdigits)
    return Password


def store_name():
    StoreName = ""
    for i in range(4):
        StoreName += random.choice(string.ascii_letters)
    return StoreName




