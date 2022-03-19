import datetime


def listing_title():
    NowTime = datetime.datetime.now().strftime("%m-%d-%H:%M:%S")
    return NowTime