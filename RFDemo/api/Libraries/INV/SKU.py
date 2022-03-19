import os

from robot.utils.dotdict import DotDict


class SKU(object):
    skus = None

    def __init__(self):
        env = os.environ.get("TEST_ENV").lower()
        self.__get_sku(env)

    def __get_sku(self, env):
        if env == "dev":
            self.skus = DotDict({
                "channel2": ["5725028952729034752", "5794072957195206656", "5716357722996940800"],
                "channel3": ["5914861868647587840", "5628107037100711936", "5613025826376941568"],
                "mahattan": ["10035953", "10035954", "10035773"]
            })

        elif env == "qa":
            self.skus = DotDict({
                "channel2": ["5551556185716736001", "5551556185716736000","5260704539484626944"],
                "channel3": ["1000041", "1000411","5174986200666324992"],
                "mahattan": ["10035953", "10035954", "10035773"]
            })



