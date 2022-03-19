import re
import time

import execjs
import requests


class RequestBodyPayment(object):
    def __init__(self):
        pass

    payments = {
        "voucherPayments": [],
        "giftCardPayments": [],
        "creditCardPayment": None,
        "paypalPayment": None,
        "creditLinePayment": None,
        "googlePayPayment": None,
        "googlePayEncryptedPaymentBundle": None,
        "applePayPayment": None,
        "applePayEncryptedPaymentBundle": None,
        "affirmPaymentVo": None,
        "creditPaymentCardId": None,
    }

    @staticmethod
    def init_payment(url: str, user_id=None, headers=None):
        if user_id is not None:
            RequestBodyPayment.init_credit_payment(
                url=url, user_id=user_id, headers=headers
            )
            RequestBodyPayment.init_gift_card_payment(
                url=url, user_id=user_id, headers=headers
            )

        RequestBodyPayment.init_insufficient_gift_card_payment(
            url=url, headers=headers, amount=1
        )

        RequestBodyPayment.init_insufficient_gift_card_payment(
            url=url, headers=headers, amount=0
        )

        RequestBodyPayment.init_insufficient_gift_card_payment(
            url=url, headers=headers, amount=2000
        )
        RequestBodyPayment.init_insufficient_gift_card_payment(
            url=url, headers=headers, amount=2000
        )
        RequestBodyPayment.init_insufficient_gift_card_payment(
            url=url, headers=headers, amount=2000
        )
        RequestBodyPayment.init_credit_payment_card_id(url)

        return RequestBodyPayment.payments

    @staticmethod
    def init_credit_payment_card_id(url,card_number="6545000000000009", cvv="947"):
        pie_key = RequestBodyPayment.encrypt_card(url,card_number, cvv=cvv)
        RequestBodyPayment.payments["creditPaymentCardId"] = {
            "currency": "USD",
            "payment": "CREDIT_CARD",
            "creditExpiration": "1228",
            "cardLastFour": card_number[-4:],
            "nameOnCard": "automation",
            "encCardNumber": pie_key.get("encrypted_card"),
            "encSecurityCode": pie_key.get("encrypted_cvv"),
            "expirationMonth": "12",
            "expirationYear": "28",
            "cardType": "Discover",
            "pieKeyId": pie_key.get("key_id"),
            "pieIntegrity": pie_key.get("integrity_check"),
            "piePhaseId": pie_key.get("phase"),
        }

    @staticmethod
    def init_credit_payment(url: str, user_id, headers):
        credit_info_list = requests.get(
            url=f"{url}/wallet/bankcard/{user_id}", headers=headers
        ).json()
        if credit_info_list:
            credit_info = credit_info_list[0]
        else:
            pass
        RequestBodyPayment.payments["creditCardPayment"] = {
            "payment": "CREDIT_CARD",
            "billingAddressInfo": {
                "id": "",
                "firstName": credit_info.get("firstName"),
                "lastName": credit_info.get("lastName"),
                "addressLine1": credit_info.get("addressLine1"),
                "addressLine2": credit_info.get("addressLine2"),
                "city": credit_info.get("city"),
                "state": credit_info.get("state"),
                "countryId": credit_info.get("countryId"),
                "zipcode": credit_info.get("zipCode"),
                "zipCode": credit_info.get("zipCode"),
                "phoneNumber": credit_info.get("telephone"),
                "email": "automation@mail.com",
                "sameAsShipping": True,
                "isAddressSaved": True,
                "isAllItemsPickup": False,
            },
            "cardReferenceNumber": credit_info.get("cardRefNum"),
            "cardLastFour": credit_info.get("tailNumber"),
            "expirationMonth": credit_info.get("expirationDate")[0:2],
            "expirationYear": credit_info.get("expirationDate")[2:],
            "cardType": "Visa",
            "nameOnCard": "",
            "currency": "USD",
        }

    @staticmethod
    def init_gift_card_payment(url: str, user_id, headers):
        gift_card_payments = []
        gift_card_list = requests.get(
            url=f"{url}/wallet/gift-card/{user_id}", headers=headers
        ).json()
        if gift_card_list:
            for gift_card in gift_card_list:
                if float(gift_card.get("balance")) >= 100:
                    gift_card_payments.append(
                        {
                            "paymentType": "GIFT_CARD",
                            "currency": gift_card.get("currency"),
                            "giftCardBalance": float(gift_card.get("balance")),
                            "cardId": gift_card.get("giftCardId"),
                        }
                    )
                else:
                    RequestBodyPayment.delete_gift_card(
                        url=url,
                        user_id=user_id,
                        gift_card_id=gift_card.get("giftCardId"),
                    )
        else:
            for i in range(0, 2):
                resp = RequestBodyPayment.add_gift_card(url=url, user_id=user_id)
                gift_card_payments.append(
                    {
                        "paymentType": "GIFT_CARD",
                        "currency": resp.get("currency"),
                        "giftCardBalance": float(resp.get("balance")) if resp.get("balance") else 0,
                        "cardId": resp.get("giftCardId"),
                    }
                )
        if len(gift_card_payments) < 2:
            for i in range(len(gift_card_payments), 2):
                resp = RequestBodyPayment.add_gift_card(url=url, user_id=user_id)
                gift_card_payments.append(
                    {
                        "paymentType": "GIFT_CARD",
                        "currency": resp.get("currency"),
                        "giftCardBalance": float(resp.get("balance")) if resp.get("balance") else 0 ,
                        "cardId": resp.get("giftCardId"),
                    }
                )

        RequestBodyPayment.payments["giftCardPayments"] = gift_card_payments

    @staticmethod
    def delete_gift_card(url: str, user_id, gift_card_id):
        payload = {"giftCardId": gift_card_id, "userId": user_id}
        requests.delete(url=f"{url}/wallet/gift-card/delete", json=payload).json()

    @staticmethod
    def add_gift_card(url: str, user_id):
        gift_card = RequestBodyPayment.init_gift_card(2000)
        payload = {
            "user": {"ownerType": "1", "userId": user_id},
            "giftCardNum": gift_card.get("card_number"),
            "pinNum": gift_card.get("pin"),
            "defaultCard": 1,
        }
        resp = requests.post(url=f"{url}/wallet/gift-card/add", json=payload).json()
        return resp

    @staticmethod
    def init_insufficient_gift_card_payment(url: str, headers, amount=1):
        key_name = f"InsufficientGiftCardPayment_{amount}"
        gift_card_payment = []
        if RequestBodyPayment.payments.get(key_name) is not None:
            gift_card_payment = RequestBodyPayment.payments.get(key_name)
        gift_card = RequestBodyPayment.init_gift_card(amount=amount)
        if gift_card.get("card_number"):
            gift_card_list = requests.post(
                url=f"{url}/inquiry/gift-card-balance",
                json=[
                    {
                        "giftCardNumber": gift_card.get("card_number"),
                        "giftCardPinNumber": gift_card.get("pin"),
                    }
                ],
                headers=headers,
            ).json()
        # RequestBodyPayment.payments[key_name] = {
        #     "paymentType": "GIFT_CARD",
        #     "currency": "USD",
        #     "cardNumber": "6006496912999906454",
        #     "pinNumber": "9249",
        #     "giftCardBalance": "1.0",
        #     "cardLastFourDigit": "6454",
        # }
            gift_card_payment.append(
                {
                    "paymentType": "GIFT_CARD",
                    "currency": gift_card_list[0].get("currencyCode"),
                    "cardNumber": gift_card_list[0].get("giftCardNumber"),
                    "pinNumber": gift_card_list[0].get("giftCardPinNumber"),
                    "giftCardBalance": gift_card_list[0].get("amount"),
                    "cardLastFourDigit": gift_card_list[0].get("giftCardNumber")[-4:],
                }
            )

        RequestBodyPayment.payments[key_name] = gift_card_payment

    @staticmethod
    def init_gift_card(amount=2000):
        now = time.strftime("%Y%m%d%H%M%S", time.localtime())
        transaction_id = f"REP{now[4:]}"
        init_url = (
            "https://webservices-cert.storedvalue.com/svsxml/v1/services/SVSXMLWay"
        )
        payload_xml = f"""
            <soapenv:Envelope
            xmlns:ser="http://service.svsxml.svs.com"
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext- 1.0.xsd">
                <soapenv:Header>
                    <wsse:Security soapenv:mustUnderstand="1" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
                        <wsse:UsernameToken>
                            <wsse:Username>msusg-cert</wsse:Username>
                            <wsse:Password>UQY3_Q@P^x9v&amp;d</wsse:Password>
                        </wsse:UsernameToken>
                    </wsse:Security>
                </soapenv:Header>
                <soapenv:Body>
                    <ser:issueVirtualGiftCard>
                        <request>
                            <date>2019-08-14T06:27:07</date>
                            <invoiceNumber>REP03517358</invoiceNumber>
                            <issueAmount>
                                <amount>{amount}</amount>
                                <currency>USD</currency>
                            </issueAmount>
                            <merchant>
                                <merchantName>Michael Stores</merchantName>
                                <merchantNumber>67352</merchantNumber>
                                <storeNumber>0000009490</storeNumber>
                                <division>00000</division>
                            </merchant>
                            <routingID>6006496911000000000</routingID>
                            <stan/>
                            <transactionID>{transaction_id}</transactionID>
                            <checkForDuplicate>true</checkForDuplicate>
                        </request>
                    </ser:issueVirtualGiftCard>
                </soapenv:Body>
            </soapenv:Envelope>
            """

        res = requests.post(url=init_url, data=payload_xml)
        gift_card_info = res.text

        card_number = re.findall(r"<cardNumber>(.*)</cardNumber>", gift_card_info)[0]
        pin = re.findall(r"<pinNumber>(.*)</pinNumber>", gift_card_info)[0]

        card_info = {
            "card_number": card_number,
            "pin": pin[-4:],
            "balance": amount,
        }
        if card_number=='':
            card_info={}
        return card_info

    @staticmethod
    def encrypt_card(url,card_no, cvv):
        host = "https://safetechpageencryptionvar.chasepaymentech.com"
        html = requests.get(url=f"{url}/pie")
        js_script = requests.get("{}/pie/v1/encryption.js".format(host))

        ctx = execjs.compile(js_script.text + html.text)
        func_result = ctx.call("ProtectPANandCVV", card_no, cvv, True)
        if not func_result:
            raise Exception(
                "Function 'ProtectPANandCVV' returns None, Please input a right card No!"
            )

        re_result = dict(re.findall(r"PIE\.(.*)\s=\s(.*);", html.text))

        result = {
            "encrypted_card": func_result[0],
            "encrypted_cvv": func_result[1],
            "key_id": re_result["key_id"].replace('"', ""),
            "phase": re_result["phase"],
        }

        if len(func_result) > 2:
            result["integrity_check"] = func_result[2]

        return result


if __name__ == "__main__":
    # print(RequestBodyPayment.init_gift_card(10))
    # dict1={'card_number': '6006496912999904533', 'pin': '3534', 'balance': 2000}
    # if dict1.get("card_number"):
    #     print(2)
    pass
    # RequestBodyPayment.init_gift_card(0)
