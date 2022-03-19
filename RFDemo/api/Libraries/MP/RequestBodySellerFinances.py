import datetime
import random
import re
import time
from typing import Optional

import execjs
import requests


class RequestBodySellerFinances(object):
    def __init__(self):
        pass

    @staticmethod
    def update_bank_account_body(sellerStoreId):
        body = {
            "bankName": "Discover",
            "bankAccountType": 0,
            "creditorAccountNumber": "6011016011016011",
            "creditorRoutingNumber": "233423412",
            "firstName": "",
            "lastName": "",
            "sellerBankAccountId": "5635567249702913",
            "sellerStoreId": sellerStoreId,
            "EIN": "942234687",
            "businessName": "LOLStore",
            "addressLineOne": "433 W Douglass St",
            "city": "Reading",
            "zipCode": "19601",
            "state": "PA",
        }
        return body

    @staticmethod
    def update_text_moderateForm_body():
        body = {
            "text": [
                {
                    "textName": "bankName",
                    "textValue": "Discover",
                    "textType": "STORE_STORY",
                },
                {
                    "textName": "businessName",
                    "textValue": "LOLStore",
                    "textType": "STORE_STORY",
                },
                {
                    "textName": "addressLineOne",
                    "textValue": "433 W Douglass St",
                    "textType": "STORE_STORY",
                },
                {"textName": "city", "textValue": "Reading", "textType": "STORE_STORY"},
            ]
        }
        return body

    @staticmethod
    def verify_profile_body():
        body = {
            "fulfillmentCenter": [
                {"city": "Reading", "state": "PA", "zipCode": "19601"}
            ],
            "storeId": "1",
        }
        return body

    @staticmethod
    def fin_Wallet_add_body(userId):
        body = {
            "user": {"ownerType": "1", "userId": userId},
            "bankCardNickName": "",
            "expirationDate": "0222",
            "holderName": "mase",
            "defaultCard": 0,
            "billingAddress": {
                "addressLine1": "zsdfdsf",
                "addressLine2": "sdfsd",
                "city": "New York",
                "state": "AL",
                "zipCode": "10022",
                "countryId": "US",
                "firstName": "sss",
                "lastName": "sadfasf",
                "telephone": "2143569896",
            },
            "accountNumber": "05007745726348812",
            "securityCode": "114",
            "pieKeyID": "74c2b2de",
            "piePhaseID": "0",
            "pieIntegrityCheck": "e2d27c20b453d4c3",
        }
        return body

    @staticmethod
    def usr_usps_verify_body():
        body = {
            "addressLine1": "zsdfdsf",
            "addressLine2": "sdfsd",
            "city": "New York",
            "state": "AL",
            "zipCode": "10022",
        }
        return body

    @staticmethod
    def get_finance_order_detail_param(
        start_data: Optional = None,
        end_data: Optional = None,
        status="",
        transaction_type="",
        page_number=0,
        page_size=5,
        sort_by="occurTime",
    ):
        """
        :param page_number:
        :param page_size:
        :param start_data:
        :param end_data:
        :param status: "1, 2, 3"
        :param transaction_type: "3, 1, 2, 6, 5"
        :param sort_by:
        :return:
        """

        param = {
            "pageNumber": page_number,
            "pageSize": page_size,
            "filterByStatus": status if status else "",
            "filterByTransactionType": transaction_type if transaction_type else "",
            "sortBy": sort_by,
            "isAsc": False,
        }
        if start_data and end_data:
            param["filterByStartDate"] = start_data
            param["filterByEndDate"] = end_data
        return param

    def get_add_credit_card_body(self, card_number, cvv, card_brand_type, user_id):
        """
        :param card_number:card_number
        :param cvv:
        :param card_brand_type: MC, DI, AM,VI
        :param user_id:
        :return:
        """
        pie_key = self.encryption_card(card_number, cvv)
        body = {
            "user": {"ownerType": "1", "userId": user_id},
            "bankCardNickName": "",
            "expirationDate": f'{"%02d" % random.randint(1,12)}{"%02d" % random.randint(25,30)}',
            "holderName": "autotest",
            "defaultCard": 0,
            "billingAddress": {
                "addressLine1": "2317 MARGARET ST",
                "addressLine2": "",
                "city": "HOUSTON",
                "state": "TX",
                "zipCode": "77093-4528",
                "countryId": "US",
                "firstName": "fistname",
                "lastName": "lastname",
                "telephone": "4232352324",
            },
            "accountNumber": pie_key.get("encrypted_card"),
            "securityCode": pie_key.get("encrypted_cvv"),
            "pieKeyID": pie_key.get("key_id"),
            "piePhaseID": pie_key.get("phase"),
            "pieIntegrityCheck": pie_key.get("integrity_check"),
            # "cardBrandType": "MC",
            "cardBrandType": card_brand_type,
        }
        return body

    @staticmethod
    def get_edit_credit_card_body(bank_card_id, user_id):
        body = {
            "user": {"ownerType": "1", "userId": user_id},
            "bankCardId": bank_card_id,
            "holderName": f'wahaha{datetime.datetime.now().strftime("%m%d%H")}',
            "bankCardNickName": "",
            "defaultCard": 1,
            "expirationDate": "0825",
        }
        return body

    @staticmethod
    def encryption_card(card_number: str, cvv: str):
        HOST = "https://safetechpageencryptionvar.chasepaymentech.com"
        Subscriber_ID = "100000000281"
        PIE_Format = "04"
        html = requests.request(
            method="GET", url=f"{HOST}/pie/v1/{PIE_Format}{Subscriber_ID}/getkey.js"
        )
        js_script = requests.request(method="GET", url=f"{HOST}/pie/v1/encryption.js")
        ctx = execjs.compile(js_script.text + html.text)
        func_result = ctx.call("ProtectPANandCVV", card_number, cvv, True)
        re_result = re.findall(r"PIE\.(.*)\s=\s(.*);", html.text)
        result = {
            "encrypted_card": func_result[0],
            "encrypted_cvv": func_result[1],
            "key_id": str(dict(re_result)["key_id"]).replace('"', ""),
            "phase": str(dict(re_result)["phase"]).replace('"', ""),
        }
        if len(func_result) > 2:
            result["integrity_check"] = func_result[2]
        return result

    @staticmethod
    def get_export_transaction_to_csv_param(
        start_data=(datetime.datetime.now()-datetime.timedelta(days=7)).strftime("%Y-%m-%d"),
        end_data=datetime.datetime.now().strftime("%Y-%m-%d"),
        transaction_type=random.choice([1, 2, 3, 5, 6]),
    ):
        """
        :param start_data:
        :param end_data:
        :param transaction_type: 1,2,3,5,6
        :return:
        """
        param = {
            "filterByStartDate": start_data,
            "filterByEndDate": end_data,
            "filterByTransactionType": transaction_type,
        }
        return param


if __name__ == "__main__":
    rr = RequestBodySellerFinances()
    print(time.time())
    print(datetime.datetime.now().strftime("%m%d%H"))
