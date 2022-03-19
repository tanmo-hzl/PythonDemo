import datetime
import os
import random


class RequestBodyMarketing(object):
    def __init__(self):
        self.root_path = self.__get_root_path()

    @staticmethod
    def __get_root_path():
        abspath = os.path.dirname(os.path.abspath(__file__))
        root_path = os.path.dirname(os.path.dirname(abspath))
        return root_path

    @staticmethod
    def get_seller_promotion_param(
        keyword="",
    ):
        param = {"keyword": keyword, "pageNumber": 1, "pageSize": 10}
        return param

    @staticmethod
    def get_random_sku_list(list_all, num: int):
        sku_list = []
        for data in list_all:
            sku_list.append(data.get("sku"))
        skus = random.sample(sku_list, k=num)
        return skus

    @staticmethod
    def get_promotion_spend_get_off_body(skus, status="enable", amount=50, discount=5):
        apply_time = datetime.datetime.now().strftime("%Y-%m-%d 00:00:00")
        expired_time = (datetime.datetime.now() + datetime.timedelta(days=5)).strftime(
            "%Y-%m-%d 00:00:00"
        )
        product = []
        for sku in skus:
            pro = {"type": "Item sku", "value": sku}
            product.append(pro)
        body = {
            "applyTime": apply_time,
            "autoApply": "Promotion",
            "benefit": [
                {
                    "type": "discount",
                    "amount": amount,
                    "pieces": -1,
                    "value": (100 - discount) / 100,
                }
            ],
            "buyer": [],
            "expiredTime": expired_time,
            "product": product,
            "promotionExtensions": [
                {"attribute": "benefitJson", "value": "Spend & Get - % Off&&"},
                {
                    "attribute": "callout message",
                    "value": f"Spend ${amount} or more get {discount}% Off",
                },
                {
                    "attribute": "disclaimer",
                    "value": f"Spend ${amount} or more get {discount}% Off",
                },
            ],
            "startTime": "00:00",
            "endTime": "23:59",
            "status": status,
            "title": f"Spend ${amount} or more get {discount}% Off",
            "description": "spend_get_off",
            "timeZone": "Asia/Shanghai",
        }
        return body

    @staticmethod
    def get_promotion_spend_get_amount_off_body(
        skus, status="enable", amount=50, discount=5
    ):
        apply_time = datetime.datetime.now().strftime("%Y-%m-%d 00:00:00")
        expired_time = (datetime.datetime.now() + datetime.timedelta(days=5)).strftime(
            "%Y-%m-%d 00:00:00"
        )
        product = []
        for sku in skus:
            pro = {"type": "Item sku", "value": sku}
            product.append(pro)
        body = {
            "applyTime": apply_time,
            "autoApply": "Promotion",
            "benefit": [
                {
                    "type": "fixed-amount",
                    "amount": amount,
                    "pieces": -1,
                    "value": discount,
                }
            ],
            "buyer": [],
            "expiredTime": expired_time,
            "product": product,
            "promotionExtensions": [
                {"attribute": "benefitJson", "value": "Spend & Get - $ Amount Off&&"},
                {
                    "attribute": "callout message",
                    "value": f"Spend ${amount} get ${discount} amount Off",
                },
                {
                    "attribute": "disclaimer",
                    "value": f"Spend ${amount} get ${discount} amount Off",
                },
            ],
            "startTime": "00:00",
            "endTime": "23:59",
            "status": status,
            "title": f"Spend ${amount} get ${discount} amount Off",
            "description": "spend_get_amount_off",
            "timeZone": "Asia/Shanghai",
        }
        return body

    @staticmethod
    def get_promotion_buy_get_off_body(skus, status="enable", buy=10, get=1, off=20):
        apply_time = datetime.datetime.now().strftime("%Y-%m-%d 00:00:00")
        expired_time = (datetime.datetime.now() + datetime.timedelta(days=5)).strftime(
            "%Y-%m-%d 00:00:00"
        )
        product = []
        for sku in skus:
            pro = {"type": "Item sku", "value": sku}
            product.append(pro)
        body = {
            "applyTime": apply_time,
            "autoApply": "Promotion",
            "benefit": [
                {
                    "type": "buy&get discount",
                    "pieces": buy,
                    "amount": -1,
                    "value": f"{(100-off)/100},{get}",
                }
            ],
            "buyer": [],
            "expiredTime": expired_time,
            "product": product,
            "promotionExtensions": [
                {"attribute": "benefitJson", "value": "Buy  & Get  - % Off&&"},
                {
                    "attribute": "callout message",
                    "value": f"Buy {buy} get {get} piece {off}% Off",
                },
                {
                    "attribute": "disclaimer",
                    "value": f"Buy {buy} get {get} piece {off}% Off",
                },
            ],
            "startTime": "00:00",
            "endTime": "23:59",
            "status": status,
            "title": f"Buy {buy} get {get} piece {off}% Off",
            "description": "auto_buy_get_off",
            "timeZone": "Asia/Shanghai",
        }
        return body

    @staticmethod
    def get_promotion_buy_A_get_B_free_body(skus, status="enable", amount=100):
        apply_time = datetime.datetime.now().strftime("%Y-%m-%d 00:00:00")
        expired_time = (datetime.datetime.now() + datetime.timedelta(days=5)).strftime(
            "%Y-%m-%d 00:00:00"
        )
        product = []
        for sku in skus[:2]:
            pro = {"type": "Item sku", "value": sku}
            product.append(pro)
        body = {
            "applyTime": apply_time,
            "autoApply": "Promotion",
            "benefit": [
                {
                    "type": "free_gift",
                    "pieces": 100,
                    "amount": -1,
                    "value": skus[-1],
                }
            ],
            "buyer": [],
            "expiredTime": expired_time,
            "product": product,
            "promotionExtensions": [
                {"attribute": "benefitJson", "value": "Buy A & Get B - Free&&"},
                {
                    "attribute": "callout message",
                    "value": f"Buy {amount} get 1 piece free",
                },
                {"attribute": "disclaimer", "value": f"Buy {amount} get 1 piece free"},
            ],
            "startTime": "00:00",
            "endTime": "23:59",
            "status": status,
            "title": f"Buy {amount} get 1 piece free",
            "description": "Buy A & Get B - Free",
            "timeZone": "Asia/Shanghai",
        }
        return body

    @staticmethod
    def get_promotion_percent_off_body(skus, status="enable", discount=15):
        apply_time = datetime.datetime.now().strftime("%Y-%m-%d 00:00:00")
        expired_time = (datetime.datetime.now() + datetime.timedelta(days=5)).strftime(
            "%Y-%m-%d 00:00:00"
        )
        product = []
        for sku in skus:
            pro = {"type": "Item sku", "value": sku}
            product.append(pro)
        body = {
            "applyTime": apply_time,
            "autoApply": "Promotion",
            "benefit": [
                {
                    "type": "discount",
                    "pieces": 1,
                    "amount": -1,
                    "value": (100 - discount) / 100,
                }
            ],
            "buyer": [],
            "expiredTime": expired_time,
            "product": product,
            "promotionExtensions": [
                {"attribute": "benefitJson", "value": "Percent Off&&"},
                {"attribute": "callout message", "value": f"get {discount}% Off "},
                {"attribute": "disclaimer", "value": f"get {discount}% Off "},
            ],
            "startTime": "00:00",
            "endTime": "23:59",
            "status": status,
            "title": f"get {discount}% Off ",
            "description": "Percent Off",
            "timeZone": "Asia/Shanghai",
        }
        return body

    @staticmethod
    def get_promotion_BMSM_off_body(skus, status="enable", pieces=10, discount=15):
        apply_time = datetime.datetime.now().strftime("%Y-%m-%d 00:00:00")
        expired_time = (datetime.datetime.now() + datetime.timedelta(days=5)).strftime(
            "%Y-%m-%d 00:00:00"
        )
        product = []
        for sku in skus:
            pro = {"type": "Item sku", "value": sku}
            product.append(pro)
        body = {
            "applyTime": apply_time,
            "autoApply": "Promotion",
            "benefit": [
                {
                    "type": "discount",
                    "pieces": pieces,
                    "amount": -1,
                    "value": (100 - discount) / 100,
                }
            ],
            "buyer": [],
            "expiredTime": expired_time,
            "product": product,
            "promotionExtensions": [
                {"attribute": "benefitJson", "value": "BMSM - % Off&&"},
                {
                    "attribute": "callout message",
                    "value": f"Buy {pieces} Pieces or more for {discount} % Off",
                },
                {
                    "attribute": "disclaimer",
                    "value": f"Buy {pieces} Pieces or more for {discount} % Off",
                },
            ],
            "startTime": "00:00",
            "endTime": "23:59",
            "status": status,
            "title": f"Buy {pieces} Pieces or more for {discount} % Off",
            "description": "BMSM_off",
            "timeZone": "Asia/Shanghai",
        }
        return body

    @staticmethod
    def get_promotion_list_body(filter_condition: dict):
        """
        :param filter_condition: statusQ:"Active","Completed","Draft","Terminated","Scheduled","All Status"
        :return:
        """
        end_time = filter_condition.get("end_time")
        start_time = filter_condition.get("start_time")
        status_q = filter_condition.get("status_q")
        body = {
            "autoApplyQ": "",
            "end": end_time if end_time else "",
            "page": 1,
            "size": 5,
            "start": start_time if start_time else "",
            "statusQ": status_q if status_q else "",
            "title": "",
        }
        return body

    # @staticmethod
    # def get_seller_publish_promotion_body(promotion_id):
    #     body = {
    #         "applyTime": "2022-03-06 10:00:00",
    #         "autoApply": "Promotion",
    #         "benefit": [
    #             {
    #                 "type": "buy&get discount",
    #                 "pieces": 10,
    #                 "amount": -1,
    #                 "value": "0.8,1",
    #             }
    #         ],
    #         "buyer": [],
    #         "expiredTime": "2022-03-11 10:00:00",
    #         "product": [
    #             {"type": "Item sku", "value": "6025963395466551301"},
    #             {"type": "Item sku", "value": "6025963395466551309"},
    #         ],
    #         "promotionExtensions": [
    #             {"attribute": "benefitJson", "value": "Buy  & Get  - % Off&&"},
    #             {"attribute": "callout message", "value": "Buy 10 get 1 piece 20% Off"},
    #             {"attribute": "disclaimer", "value": "Buy 10 get 1 piece 20% Off"},
    #         ],
    #         "startTime": "00:00",
    #         "endTime": "23:59",
    #         "status": "enable",
    #         "title": "Buy 10 get 1 piece 20% Off",
    #         "description": "auto_buy_get_off",
    #         "timeZone": "Asia/Shanghai",
    #         "promotionId": promotion_id,
    #     }
    #     return body

if __name__ == "__main__":
    pass
    # print(datetime.datetime.now().strftime("%Y-%m-%d 00:00:00"))
    # print((datetime.datetime.now()-datetime.timedelta(days=1)).strftime("%Y-%m-%d 00:00:00"))
    rr = RequestBodyMarketing()
    # rr.get_random_sku_list()
    # print(random.sample(sku_list, k=3))
